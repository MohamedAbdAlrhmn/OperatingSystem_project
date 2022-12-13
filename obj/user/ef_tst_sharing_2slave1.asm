
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
  80008d:	68 a0 36 80 00       	push   $0x8036a0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 36 80 00       	push   $0x8036bc
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 cf 1a 00 00       	call   801b72 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 bb 18 00 00       	call   801966 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 c9 17 00 00       	call   801879 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 da 36 80 00       	push   $0x8036da
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 12 16 00 00       	call   8016d5 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 dc 36 80 00       	push   $0x8036dc
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 bc 36 80 00       	push   $0x8036bc
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 8b 17 00 00       	call   801879 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 3c 37 80 00       	push   $0x80373c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 bc 36 80 00       	push   $0x8036bc
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 70 18 00 00       	call   801980 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 51 18 00 00       	call   801966 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 5f 17 00 00       	call   801879 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 cd 37 80 00       	push   $0x8037cd
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 a8 15 00 00       	call   8016d5 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 dc 36 80 00       	push   $0x8036dc
  800144:	6a 23                	push   $0x23
  800146:	68 bc 36 80 00       	push   $0x8036bc
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 24 17 00 00       	call   801879 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 3c 37 80 00       	push   $0x80373c
  800166:	6a 24                	push   $0x24
  800168:	68 bc 36 80 00       	push   $0x8036bc
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 09 18 00 00       	call   801980 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 d0 37 80 00       	push   $0x8037d0
  800189:	6a 27                	push   $0x27
  80018b:	68 bc 36 80 00       	push   $0x8036bc
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 cc 17 00 00       	call   801966 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 da 16 00 00       	call   801879 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 07 38 80 00       	push   $0x803807
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 23 15 00 00       	call   8016d5 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 dc 36 80 00       	push   $0x8036dc
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 bc 36 80 00       	push   $0x8036bc
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 9f 16 00 00       	call   801879 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 3c 37 80 00       	push   $0x80373c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 bc 36 80 00       	push   $0x8036bc
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 84 17 00 00       	call   801980 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 d0 37 80 00       	push   $0x8037d0
  80020e:	6a 30                	push   $0x30
  800210:	68 bc 36 80 00       	push   $0x8036bc
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
  800238:	68 d0 37 80 00       	push   $0x8037d0
  80023d:	6a 33                	push   $0x33
  80023f:	68 bc 36 80 00       	push   $0x8036bc
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 49 1a 00 00       	call   801c97 <inctst>

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
  80025a:	e8 fa 18 00 00       	call   801b59 <sys_getenvindex>
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
  8002c5:	e8 9c 16 00 00       	call   801966 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 24 38 80 00       	push   $0x803824
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
  8002f5:	68 4c 38 80 00       	push   $0x80384c
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
  800326:	68 74 38 80 00       	push   $0x803874
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 50 80 00       	mov    0x805020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 cc 38 80 00       	push   $0x8038cc
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 24 38 80 00       	push   $0x803824
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 1c 16 00 00       	call   801980 <sys_enable_interrupt>

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
  800377:	e8 a9 17 00 00       	call   801b25 <sys_destroy_env>
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
  800388:	e8 fe 17 00 00       	call   801b8b <sys_exit_env>
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
  8003b1:	68 e0 38 80 00       	push   $0x8038e0
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 50 80 00       	mov    0x805000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 e5 38 80 00       	push   $0x8038e5
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
  8003ee:	68 01 39 80 00       	push   $0x803901
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
  80041a:	68 04 39 80 00       	push   $0x803904
  80041f:	6a 26                	push   $0x26
  800421:	68 50 39 80 00       	push   $0x803950
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
  8004ec:	68 5c 39 80 00       	push   $0x80395c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 50 39 80 00       	push   $0x803950
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
  80055c:	68 b0 39 80 00       	push   $0x8039b0
  800561:	6a 44                	push   $0x44
  800563:	68 50 39 80 00       	push   $0x803950
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
  8005b6:	e8 fd 11 00 00       	call   8017b8 <sys_cputs>
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
  80062d:	e8 86 11 00 00       	call   8017b8 <sys_cputs>
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
  800677:	e8 ea 12 00 00       	call   801966 <sys_disable_interrupt>
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
  800697:	e8 e4 12 00 00       	call   801980 <sys_enable_interrupt>
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
  8006e1:	e8 56 2d 00 00       	call   80343c <__udivdi3>
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
  800731:	e8 16 2e 00 00       	call   80354c <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 14 3c 80 00       	add    $0x803c14,%eax
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
  80088c:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
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
  80096d:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 25 3c 80 00       	push   $0x803c25
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
  800992:	68 2e 3c 80 00       	push   $0x803c2e
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
  8009bf:	be 31 3c 80 00       	mov    $0x803c31,%esi
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
  8013e5:	68 90 3d 80 00       	push   $0x803d90
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
  8014b5:	e8 42 04 00 00       	call   8018fc <sys_allocate_chunk>
  8014ba:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014bd:	a1 20 51 80 00       	mov    0x805120,%eax
  8014c2:	83 ec 0c             	sub    $0xc,%esp
  8014c5:	50                   	push   %eax
  8014c6:	e8 b7 0a 00 00       	call   801f82 <initialize_MemBlocksList>
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
  8014f3:	68 b5 3d 80 00       	push   $0x803db5
  8014f8:	6a 33                	push   $0x33
  8014fa:	68 d3 3d 80 00       	push   $0x803dd3
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
  801572:	68 e0 3d 80 00       	push   $0x803de0
  801577:	6a 34                	push   $0x34
  801579:	68 d3 3d 80 00       	push   $0x803dd3
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
  8015e7:	68 04 3e 80 00       	push   $0x803e04
  8015ec:	6a 46                	push   $0x46
  8015ee:	68 d3 3d 80 00       	push   $0x803dd3
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
  801603:	68 2c 3e 80 00       	push   $0x803e2c
  801608:	6a 61                	push   $0x61
  80160a:	68 d3 3d 80 00       	push   $0x803dd3
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
  801629:	75 0a                	jne    801635 <smalloc+0x21>
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
  801630:	e9 9e 00 00 00       	jmp    8016d3 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801635:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801642:	01 d0                	add    %edx,%eax
  801644:	48                   	dec    %eax
  801645:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164b:	ba 00 00 00 00       	mov    $0x0,%edx
  801650:	f7 75 f0             	divl   -0x10(%ebp)
  801653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801656:	29 d0                	sub    %edx,%eax
  801658:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80165b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801662:	e8 63 06 00 00       	call   801cca <sys_isUHeapPlacementStrategyFIRSTFIT>
  801667:	85 c0                	test   %eax,%eax
  801669:	74 11                	je     80167c <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80166b:	83 ec 0c             	sub    $0xc,%esp
  80166e:	ff 75 e8             	pushl  -0x18(%ebp)
  801671:	e8 ce 0c 00 00       	call   802344 <alloc_block_FF>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80167c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801680:	74 4c                	je     8016ce <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801685:	8b 40 08             	mov    0x8(%eax),%eax
  801688:	89 c2                	mov    %eax,%edx
  80168a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80168e:	52                   	push   %edx
  80168f:	50                   	push   %eax
  801690:	ff 75 0c             	pushl  0xc(%ebp)
  801693:	ff 75 08             	pushl  0x8(%ebp)
  801696:	e8 b4 03 00 00       	call   801a4f <sys_createSharedObject>
  80169b:	83 c4 10             	add    $0x10,%esp
  80169e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8016a1:	83 ec 08             	sub    $0x8,%esp
  8016a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8016a7:	68 4f 3e 80 00       	push   $0x803e4f
  8016ac:	e8 93 ef ff ff       	call   800644 <cprintf>
  8016b1:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016b4:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016b8:	74 14                	je     8016ce <smalloc+0xba>
  8016ba:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016be:	74 0e                	je     8016ce <smalloc+0xba>
  8016c0:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016c4:	74 08                	je     8016ce <smalloc+0xba>
			return (void*) mem_block->sva;
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	8b 40 08             	mov    0x8(%eax),%eax
  8016cc:	eb 05                	jmp    8016d3 <smalloc+0xbf>
	}
	return NULL;
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016db:	e8 ee fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016e0:	83 ec 04             	sub    $0x4,%esp
  8016e3:	68 64 3e 80 00       	push   $0x803e64
  8016e8:	68 ab 00 00 00       	push   $0xab
  8016ed:	68 d3 3d 80 00       	push   $0x803dd3
  8016f2:	e8 99 ec ff ff       	call   800390 <_panic>

008016f7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016fd:	e8 cc fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801702:	83 ec 04             	sub    $0x4,%esp
  801705:	68 88 3e 80 00       	push   $0x803e88
  80170a:	68 ef 00 00 00       	push   $0xef
  80170f:	68 d3 3d 80 00       	push   $0x803dd3
  801714:	e8 77 ec ff ff       	call   800390 <_panic>

00801719 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80171f:	83 ec 04             	sub    $0x4,%esp
  801722:	68 b0 3e 80 00       	push   $0x803eb0
  801727:	68 03 01 00 00       	push   $0x103
  80172c:	68 d3 3d 80 00       	push   $0x803dd3
  801731:	e8 5a ec ff ff       	call   800390 <_panic>

00801736 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801736:	55                   	push   %ebp
  801737:	89 e5                	mov    %esp,%ebp
  801739:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80173c:	83 ec 04             	sub    $0x4,%esp
  80173f:	68 d4 3e 80 00       	push   $0x803ed4
  801744:	68 0e 01 00 00       	push   $0x10e
  801749:	68 d3 3d 80 00       	push   $0x803dd3
  80174e:	e8 3d ec ff ff       	call   800390 <_panic>

00801753 <shrink>:

}
void shrink(uint32 newSize)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	68 d4 3e 80 00       	push   $0x803ed4
  801761:	68 13 01 00 00       	push   $0x113
  801766:	68 d3 3d 80 00       	push   $0x803dd3
  80176b:	e8 20 ec ff ff       	call   800390 <_panic>

00801770 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801776:	83 ec 04             	sub    $0x4,%esp
  801779:	68 d4 3e 80 00       	push   $0x803ed4
  80177e:	68 18 01 00 00       	push   $0x118
  801783:	68 d3 3d 80 00       	push   $0x803dd3
  801788:	e8 03 ec ff ff       	call   800390 <_panic>

0080178d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	57                   	push   %edi
  801791:	56                   	push   %esi
  801792:	53                   	push   %ebx
  801793:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801796:	8b 45 08             	mov    0x8(%ebp),%eax
  801799:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017a5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017a8:	cd 30                	int    $0x30
  8017aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5e                   	pop    %esi
  8017b5:	5f                   	pop    %edi
  8017b6:	5d                   	pop    %ebp
  8017b7:	c3                   	ret    

008017b8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 04             	sub    $0x4,%esp
  8017be:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017c4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	52                   	push   %edx
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	50                   	push   %eax
  8017d4:	6a 00                	push   $0x0
  8017d6:	e8 b2 ff ff ff       	call   80178d <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
}
  8017de:	90                   	nop
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017e4:	6a 00                	push   $0x0
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 01                	push   $0x1
  8017f0:	e8 98 ff ff ff       	call   80178d <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801800:	8b 45 08             	mov    0x8(%ebp),%eax
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	52                   	push   %edx
  80180a:	50                   	push   %eax
  80180b:	6a 05                	push   $0x5
  80180d:	e8 7b ff ff ff       	call   80178d <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	56                   	push   %esi
  80181b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80181c:	8b 75 18             	mov    0x18(%ebp),%esi
  80181f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801822:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801825:	8b 55 0c             	mov    0xc(%ebp),%edx
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	56                   	push   %esi
  80182c:	53                   	push   %ebx
  80182d:	51                   	push   %ecx
  80182e:	52                   	push   %edx
  80182f:	50                   	push   %eax
  801830:	6a 06                	push   $0x6
  801832:	e8 56 ff ff ff       	call   80178d <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5e                   	pop    %esi
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    

00801841 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801844:	8b 55 0c             	mov    0xc(%ebp),%edx
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	52                   	push   %edx
  801851:	50                   	push   %eax
  801852:	6a 07                	push   $0x7
  801854:	e8 34 ff ff ff       	call   80178d <syscall>
  801859:	83 c4 18             	add    $0x18,%esp
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	ff 75 0c             	pushl  0xc(%ebp)
  80186a:	ff 75 08             	pushl  0x8(%ebp)
  80186d:	6a 08                	push   $0x8
  80186f:	e8 19 ff ff ff       	call   80178d <syscall>
  801874:	83 c4 18             	add    $0x18,%esp
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 09                	push   $0x9
  801888:	e8 00 ff ff ff       	call   80178d <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 0a                	push   $0xa
  8018a1:	e8 e7 fe ff ff       	call   80178d <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 0b                	push   $0xb
  8018ba:	e8 ce fe ff ff       	call   80178d <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	ff 75 0c             	pushl  0xc(%ebp)
  8018d0:	ff 75 08             	pushl  0x8(%ebp)
  8018d3:	6a 0f                	push   $0xf
  8018d5:	e8 b3 fe ff ff       	call   80178d <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
	return;
  8018dd:	90                   	nop
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ec:	ff 75 08             	pushl  0x8(%ebp)
  8018ef:	6a 10                	push   $0x10
  8018f1:	e8 97 fe ff ff       	call   80178d <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f9:	90                   	nop
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	ff 75 10             	pushl  0x10(%ebp)
  801906:	ff 75 0c             	pushl  0xc(%ebp)
  801909:	ff 75 08             	pushl  0x8(%ebp)
  80190c:	6a 11                	push   $0x11
  80190e:	e8 7a fe ff ff       	call   80178d <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
	return ;
  801916:	90                   	nop
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 0c                	push   $0xc
  801928:	e8 60 fe ff ff       	call   80178d <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	6a 0d                	push   $0xd
  801942:	e8 46 fe ff ff       	call   80178d <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 0e                	push   $0xe
  80195b:	e8 2d fe ff ff       	call   80178d <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	90                   	nop
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 13                	push   $0x13
  801975:	e8 13 fe ff ff       	call   80178d <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	90                   	nop
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 14                	push   $0x14
  80198f:	e8 f9 fd ff ff       	call   80178d <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_cputc>:


void
sys_cputc(const char c)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019a6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	50                   	push   %eax
  8019b3:	6a 15                	push   $0x15
  8019b5:	e8 d3 fd ff ff       	call   80178d <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	90                   	nop
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 16                	push   $0x16
  8019cf:	e8 b9 fd ff ff       	call   80178d <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	90                   	nop
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	50                   	push   %eax
  8019ea:	6a 17                	push   $0x17
  8019ec:	e8 9c fd ff ff       	call   80178d <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	52                   	push   %edx
  801a06:	50                   	push   %eax
  801a07:	6a 1a                	push   $0x1a
  801a09:	e8 7f fd ff ff       	call   80178d <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	52                   	push   %edx
  801a23:	50                   	push   %eax
  801a24:	6a 18                	push   $0x18
  801a26:	e8 62 fd ff ff       	call   80178d <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 19                	push   $0x19
  801a44:	e8 44 fd ff ff       	call   80178d <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	8b 45 10             	mov    0x10(%ebp),%eax
  801a58:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a5b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a5e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	51                   	push   %ecx
  801a68:	52                   	push   %edx
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	50                   	push   %eax
  801a6d:	6a 1b                	push   $0x1b
  801a6f:	e8 19 fd ff ff       	call   80178d <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 1c                	push   $0x1c
  801a8c:	e8 fc fc ff ff       	call   80178d <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	51                   	push   %ecx
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 1d                	push   $0x1d
  801aab:	e8 dd fc ff ff       	call   80178d <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	52                   	push   %edx
  801ac5:	50                   	push   %eax
  801ac6:	6a 1e                	push   $0x1e
  801ac8:	e8 c0 fc ff ff       	call   80178d <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 1f                	push   $0x1f
  801ae1:	e8 a7 fc ff ff       	call   80178d <syscall>
  801ae6:	83 c4 18             	add    $0x18,%esp
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aee:	8b 45 08             	mov    0x8(%ebp),%eax
  801af1:	6a 00                	push   $0x0
  801af3:	ff 75 14             	pushl  0x14(%ebp)
  801af6:	ff 75 10             	pushl  0x10(%ebp)
  801af9:	ff 75 0c             	pushl  0xc(%ebp)
  801afc:	50                   	push   %eax
  801afd:	6a 20                	push   $0x20
  801aff:	e8 89 fc ff ff       	call   80178d <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	50                   	push   %eax
  801b18:	6a 21                	push   $0x21
  801b1a:	e8 6e fc ff ff       	call   80178d <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	90                   	nop
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	50                   	push   %eax
  801b34:	6a 22                	push   $0x22
  801b36:	e8 52 fc ff ff       	call   80178d <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 02                	push   $0x2
  801b4f:	e8 39 fc ff ff       	call   80178d <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 03                	push   $0x3
  801b68:	e8 20 fc ff ff       	call   80178d <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 04                	push   $0x4
  801b81:	e8 07 fc ff ff       	call   80178d <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_exit_env>:


void sys_exit_env(void)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 23                	push   $0x23
  801b9a:	e8 ee fb ff ff       	call   80178d <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	90                   	nop
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bae:	8d 50 04             	lea    0x4(%eax),%edx
  801bb1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	52                   	push   %edx
  801bbb:	50                   	push   %eax
  801bbc:	6a 24                	push   $0x24
  801bbe:	e8 ca fb ff ff       	call   80178d <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
	return result;
  801bc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bcf:	89 01                	mov    %eax,(%ecx)
  801bd1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	c9                   	leave  
  801bd8:	c2 04 00             	ret    $0x4

00801bdb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 10             	pushl  0x10(%ebp)
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	ff 75 08             	pushl  0x8(%ebp)
  801beb:	6a 12                	push   $0x12
  801bed:	e8 9b fb ff ff       	call   80178d <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf5:	90                   	nop
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 25                	push   $0x25
  801c07:	e8 81 fb ff ff       	call   80178d <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c1d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	50                   	push   %eax
  801c2a:	6a 26                	push   $0x26
  801c2c:	e8 5c fb ff ff       	call   80178d <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
	return ;
  801c34:	90                   	nop
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <rsttst>:
void rsttst()
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 28                	push   $0x28
  801c46:	e8 42 fb ff ff       	call   80178d <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c5d:	8b 55 18             	mov    0x18(%ebp),%edx
  801c60:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c64:	52                   	push   %edx
  801c65:	50                   	push   %eax
  801c66:	ff 75 10             	pushl  0x10(%ebp)
  801c69:	ff 75 0c             	pushl  0xc(%ebp)
  801c6c:	ff 75 08             	pushl  0x8(%ebp)
  801c6f:	6a 27                	push   $0x27
  801c71:	e8 17 fb ff ff       	call   80178d <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
	return ;
  801c79:	90                   	nop
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <chktst>:
void chktst(uint32 n)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	ff 75 08             	pushl  0x8(%ebp)
  801c8a:	6a 29                	push   $0x29
  801c8c:	e8 fc fa ff ff       	call   80178d <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
	return ;
  801c94:	90                   	nop
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <inctst>:

void inctst()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 2a                	push   $0x2a
  801ca6:	e8 e2 fa ff ff       	call   80178d <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
	return ;
  801cae:	90                   	nop
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <gettst>:
uint32 gettst()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 2b                	push   $0x2b
  801cc0:	e8 c8 fa ff ff       	call   80178d <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 2c                	push   $0x2c
  801cdc:	e8 ac fa ff ff       	call   80178d <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
  801ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ce7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ceb:	75 07                	jne    801cf4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ced:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf2:	eb 05                	jmp    801cf9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf9:	c9                   	leave  
  801cfa:	c3                   	ret    

00801cfb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 2c                	push   $0x2c
  801d0d:	e8 7b fa ff ff       	call   80178d <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
  801d15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d18:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d1c:	75 07                	jne    801d25 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d23:	eb 05                	jmp    801d2a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    

00801d2c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 2c                	push   $0x2c
  801d3e:	e8 4a fa ff ff       	call   80178d <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
  801d46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d49:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d4d:	75 07                	jne    801d56 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d54:	eb 05                	jmp    801d5b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 2c                	push   $0x2c
  801d6f:	e8 19 fa ff ff       	call   80178d <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
  801d77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d7a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d7e:	75 07                	jne    801d87 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d80:	b8 01 00 00 00       	mov    $0x1,%eax
  801d85:	eb 05                	jmp    801d8c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	ff 75 08             	pushl  0x8(%ebp)
  801d9c:	6a 2d                	push   $0x2d
  801d9e:	e8 ea f9 ff ff       	call   80178d <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
	return ;
  801da6:	90                   	nop
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	6a 00                	push   $0x0
  801dbb:	53                   	push   %ebx
  801dbc:	51                   	push   %ecx
  801dbd:	52                   	push   %edx
  801dbe:	50                   	push   %eax
  801dbf:	6a 2e                	push   $0x2e
  801dc1:	e8 c7 f9 ff ff       	call   80178d <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	52                   	push   %edx
  801dde:	50                   	push   %eax
  801ddf:	6a 2f                	push   $0x2f
  801de1:	e8 a7 f9 ff ff       	call   80178d <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801df1:	83 ec 0c             	sub    $0xc,%esp
  801df4:	68 e4 3e 80 00       	push   $0x803ee4
  801df9:	e8 46 e8 ff ff       	call   800644 <cprintf>
  801dfe:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	68 10 3f 80 00       	push   $0x803f10
  801e10:	e8 2f e8 ff ff       	call   800644 <cprintf>
  801e15:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e18:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e1c:	a1 38 51 80 00       	mov    0x805138,%eax
  801e21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e24:	eb 56                	jmp    801e7c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2a:	74 1c                	je     801e48 <print_mem_block_lists+0x5d>
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 50 08             	mov    0x8(%eax),%edx
  801e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e35:	8b 48 08             	mov    0x8(%eax),%ecx
  801e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3e:	01 c8                	add    %ecx,%eax
  801e40:	39 c2                	cmp    %eax,%edx
  801e42:	73 04                	jae    801e48 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e44:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	8b 50 08             	mov    0x8(%eax),%edx
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	8b 40 0c             	mov    0xc(%eax),%eax
  801e54:	01 c2                	add    %eax,%edx
  801e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e59:	8b 40 08             	mov    0x8(%eax),%eax
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	52                   	push   %edx
  801e60:	50                   	push   %eax
  801e61:	68 25 3f 80 00       	push   $0x803f25
  801e66:	e8 d9 e7 ff ff       	call   800644 <cprintf>
  801e6b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e74:	a1 40 51 80 00       	mov    0x805140,%eax
  801e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e80:	74 07                	je     801e89 <print_mem_block_lists+0x9e>
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	8b 00                	mov    (%eax),%eax
  801e87:	eb 05                	jmp    801e8e <print_mem_block_lists+0xa3>
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	a3 40 51 80 00       	mov    %eax,0x805140
  801e93:	a1 40 51 80 00       	mov    0x805140,%eax
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	75 8a                	jne    801e26 <print_mem_block_lists+0x3b>
  801e9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea0:	75 84                	jne    801e26 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ea2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ea6:	75 10                	jne    801eb8 <print_mem_block_lists+0xcd>
  801ea8:	83 ec 0c             	sub    $0xc,%esp
  801eab:	68 34 3f 80 00       	push   $0x803f34
  801eb0:	e8 8f e7 ff ff       	call   800644 <cprintf>
  801eb5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eb8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ebf:	83 ec 0c             	sub    $0xc,%esp
  801ec2:	68 58 3f 80 00       	push   $0x803f58
  801ec7:	e8 78 e7 ff ff       	call   800644 <cprintf>
  801ecc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ecf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ed3:	a1 40 50 80 00       	mov    0x805040,%eax
  801ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edb:	eb 56                	jmp    801f33 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801edd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee1:	74 1c                	je     801eff <print_mem_block_lists+0x114>
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	8b 50 08             	mov    0x8(%eax),%edx
  801ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eec:	8b 48 08             	mov    0x8(%eax),%ecx
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef5:	01 c8                	add    %ecx,%eax
  801ef7:	39 c2                	cmp    %eax,%edx
  801ef9:	73 04                	jae    801eff <print_mem_block_lists+0x114>
			sorted = 0 ;
  801efb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f02:	8b 50 08             	mov    0x8(%eax),%edx
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0b:	01 c2                	add    %eax,%edx
  801f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f10:	8b 40 08             	mov    0x8(%eax),%eax
  801f13:	83 ec 04             	sub    $0x4,%esp
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	68 25 3f 80 00       	push   $0x803f25
  801f1d:	e8 22 e7 ff ff       	call   800644 <cprintf>
  801f22:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f28:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f2b:	a1 48 50 80 00       	mov    0x805048,%eax
  801f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f37:	74 07                	je     801f40 <print_mem_block_lists+0x155>
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	8b 00                	mov    (%eax),%eax
  801f3e:	eb 05                	jmp    801f45 <print_mem_block_lists+0x15a>
  801f40:	b8 00 00 00 00       	mov    $0x0,%eax
  801f45:	a3 48 50 80 00       	mov    %eax,0x805048
  801f4a:	a1 48 50 80 00       	mov    0x805048,%eax
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	75 8a                	jne    801edd <print_mem_block_lists+0xf2>
  801f53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f57:	75 84                	jne    801edd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f59:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f5d:	75 10                	jne    801f6f <print_mem_block_lists+0x184>
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	68 70 3f 80 00       	push   $0x803f70
  801f67:	e8 d8 e6 ff ff       	call   800644 <cprintf>
  801f6c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	68 e4 3e 80 00       	push   $0x803ee4
  801f77:	e8 c8 e6 ff ff       	call   800644 <cprintf>
  801f7c:	83 c4 10             	add    $0x10,%esp

}
  801f7f:	90                   	nop
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f88:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f8f:	00 00 00 
  801f92:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f99:	00 00 00 
  801f9c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fa3:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fa6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fad:	e9 9e 00 00 00       	jmp    802050 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fb2:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fba:	c1 e2 04             	shl    $0x4,%edx
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	75 14                	jne    801fd7 <initialize_MemBlocksList+0x55>
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	68 98 3f 80 00       	push   $0x803f98
  801fcb:	6a 46                	push   $0x46
  801fcd:	68 bb 3f 80 00       	push   $0x803fbb
  801fd2:	e8 b9 e3 ff ff       	call   800390 <_panic>
  801fd7:	a1 50 50 80 00       	mov    0x805050,%eax
  801fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdf:	c1 e2 04             	shl    $0x4,%edx
  801fe2:	01 d0                	add    %edx,%eax
  801fe4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fea:	89 10                	mov    %edx,(%eax)
  801fec:	8b 00                	mov    (%eax),%eax
  801fee:	85 c0                	test   %eax,%eax
  801ff0:	74 18                	je     80200a <initialize_MemBlocksList+0x88>
  801ff2:	a1 48 51 80 00       	mov    0x805148,%eax
  801ff7:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801ffd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802000:	c1 e1 04             	shl    $0x4,%ecx
  802003:	01 ca                	add    %ecx,%edx
  802005:	89 50 04             	mov    %edx,0x4(%eax)
  802008:	eb 12                	jmp    80201c <initialize_MemBlocksList+0x9a>
  80200a:	a1 50 50 80 00       	mov    0x805050,%eax
  80200f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802012:	c1 e2 04             	shl    $0x4,%edx
  802015:	01 d0                	add    %edx,%eax
  802017:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80201c:	a1 50 50 80 00       	mov    0x805050,%eax
  802021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802024:	c1 e2 04             	shl    $0x4,%edx
  802027:	01 d0                	add    %edx,%eax
  802029:	a3 48 51 80 00       	mov    %eax,0x805148
  80202e:	a1 50 50 80 00       	mov    0x805050,%eax
  802033:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802036:	c1 e2 04             	shl    $0x4,%edx
  802039:	01 d0                	add    %edx,%eax
  80203b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802042:	a1 54 51 80 00       	mov    0x805154,%eax
  802047:	40                   	inc    %eax
  802048:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80204d:	ff 45 f4             	incl   -0xc(%ebp)
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	3b 45 08             	cmp    0x8(%ebp),%eax
  802056:	0f 82 56 ff ff ff    	jb     801fb2 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80205c:	90                   	nop
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8b 00                	mov    (%eax),%eax
  80206a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80206d:	eb 19                	jmp    802088 <find_block+0x29>
	{
		if(va==point->sva)
  80206f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802072:	8b 40 08             	mov    0x8(%eax),%eax
  802075:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802078:	75 05                	jne    80207f <find_block+0x20>
		   return point;
  80207a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207d:	eb 36                	jmp    8020b5 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	8b 40 08             	mov    0x8(%eax),%eax
  802085:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802088:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80208c:	74 07                	je     802095 <find_block+0x36>
  80208e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802091:	8b 00                	mov    (%eax),%eax
  802093:	eb 05                	jmp    80209a <find_block+0x3b>
  802095:	b8 00 00 00 00       	mov    $0x0,%eax
  80209a:	8b 55 08             	mov    0x8(%ebp),%edx
  80209d:	89 42 08             	mov    %eax,0x8(%edx)
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	8b 40 08             	mov    0x8(%eax),%eax
  8020a6:	85 c0                	test   %eax,%eax
  8020a8:	75 c5                	jne    80206f <find_block+0x10>
  8020aa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020ae:	75 bf                	jne    80206f <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020bd:	a1 40 50 80 00       	mov    0x805040,%eax
  8020c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8020ca:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020d3:	74 24                	je     8020f9 <insert_sorted_allocList+0x42>
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	8b 50 08             	mov    0x8(%eax),%edx
  8020db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020de:	8b 40 08             	mov    0x8(%eax),%eax
  8020e1:	39 c2                	cmp    %eax,%edx
  8020e3:	76 14                	jbe    8020f9 <insert_sorted_allocList+0x42>
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	8b 50 08             	mov    0x8(%eax),%edx
  8020eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ee:	8b 40 08             	mov    0x8(%eax),%eax
  8020f1:	39 c2                	cmp    %eax,%edx
  8020f3:	0f 82 60 01 00 00    	jb     802259 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020fd:	75 65                	jne    802164 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802103:	75 14                	jne    802119 <insert_sorted_allocList+0x62>
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	68 98 3f 80 00       	push   $0x803f98
  80210d:	6a 6b                	push   $0x6b
  80210f:	68 bb 3f 80 00       	push   $0x803fbb
  802114:	e8 77 e2 ff ff       	call   800390 <_panic>
  802119:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	89 10                	mov    %edx,(%eax)
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	8b 00                	mov    (%eax),%eax
  802129:	85 c0                	test   %eax,%eax
  80212b:	74 0d                	je     80213a <insert_sorted_allocList+0x83>
  80212d:	a1 40 50 80 00       	mov    0x805040,%eax
  802132:	8b 55 08             	mov    0x8(%ebp),%edx
  802135:	89 50 04             	mov    %edx,0x4(%eax)
  802138:	eb 08                	jmp    802142 <insert_sorted_allocList+0x8b>
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	a3 44 50 80 00       	mov    %eax,0x805044
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	a3 40 50 80 00       	mov    %eax,0x805040
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802154:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802159:	40                   	inc    %eax
  80215a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80215f:	e9 dc 01 00 00       	jmp    802340 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	8b 50 08             	mov    0x8(%eax),%edx
  80216a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216d:	8b 40 08             	mov    0x8(%eax),%eax
  802170:	39 c2                	cmp    %eax,%edx
  802172:	77 6c                	ja     8021e0 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802178:	74 06                	je     802180 <insert_sorted_allocList+0xc9>
  80217a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217e:	75 14                	jne    802194 <insert_sorted_allocList+0xdd>
  802180:	83 ec 04             	sub    $0x4,%esp
  802183:	68 d4 3f 80 00       	push   $0x803fd4
  802188:	6a 6f                	push   $0x6f
  80218a:	68 bb 3f 80 00       	push   $0x803fbb
  80218f:	e8 fc e1 ff ff       	call   800390 <_panic>
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802197:	8b 50 04             	mov    0x4(%eax),%edx
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	89 50 04             	mov    %edx,0x4(%eax)
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021a6:	89 10                	mov    %edx,(%eax)
  8021a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ab:	8b 40 04             	mov    0x4(%eax),%eax
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	74 0d                	je     8021bf <insert_sorted_allocList+0x108>
  8021b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b5:	8b 40 04             	mov    0x4(%eax),%eax
  8021b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021bb:	89 10                	mov    %edx,(%eax)
  8021bd:	eb 08                	jmp    8021c7 <insert_sorted_allocList+0x110>
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8021c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8021cd:	89 50 04             	mov    %edx,0x4(%eax)
  8021d0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021d5:	40                   	inc    %eax
  8021d6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021db:	e9 60 01 00 00       	jmp    802340 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	8b 50 08             	mov    0x8(%eax),%edx
  8021e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021e9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ec:	39 c2                	cmp    %eax,%edx
  8021ee:	0f 82 4c 01 00 00    	jb     802340 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f8:	75 14                	jne    80220e <insert_sorted_allocList+0x157>
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 0c 40 80 00       	push   $0x80400c
  802202:	6a 73                	push   $0x73
  802204:	68 bb 3f 80 00       	push   $0x803fbb
  802209:	e8 82 e1 ff ff       	call   800390 <_panic>
  80220e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	89 50 04             	mov    %edx,0x4(%eax)
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	8b 40 04             	mov    0x4(%eax),%eax
  802220:	85 c0                	test   %eax,%eax
  802222:	74 0c                	je     802230 <insert_sorted_allocList+0x179>
  802224:	a1 44 50 80 00       	mov    0x805044,%eax
  802229:	8b 55 08             	mov    0x8(%ebp),%edx
  80222c:	89 10                	mov    %edx,(%eax)
  80222e:	eb 08                	jmp    802238 <insert_sorted_allocList+0x181>
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	a3 40 50 80 00       	mov    %eax,0x805040
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	a3 44 50 80 00       	mov    %eax,0x805044
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802249:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80224e:	40                   	inc    %eax
  80224f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802254:	e9 e7 00 00 00       	jmp    802340 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80225f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802266:	a1 40 50 80 00       	mov    0x805040,%eax
  80226b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226e:	e9 9d 00 00 00       	jmp    802310 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	8b 50 08             	mov    0x8(%eax),%edx
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 40 08             	mov    0x8(%eax),%eax
  802287:	39 c2                	cmp    %eax,%edx
  802289:	76 7d                	jbe    802308 <insert_sorted_allocList+0x251>
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	8b 50 08             	mov    0x8(%eax),%edx
  802291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802294:	8b 40 08             	mov    0x8(%eax),%eax
  802297:	39 c2                	cmp    %eax,%edx
  802299:	73 6d                	jae    802308 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80229b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80229f:	74 06                	je     8022a7 <insert_sorted_allocList+0x1f0>
  8022a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a5:	75 14                	jne    8022bb <insert_sorted_allocList+0x204>
  8022a7:	83 ec 04             	sub    $0x4,%esp
  8022aa:	68 30 40 80 00       	push   $0x804030
  8022af:	6a 7f                	push   $0x7f
  8022b1:	68 bb 3f 80 00       	push   $0x803fbb
  8022b6:	e8 d5 e0 ff ff       	call   800390 <_panic>
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 10                	mov    (%eax),%edx
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	89 10                	mov    %edx,(%eax)
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8b 00                	mov    (%eax),%eax
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	74 0b                	je     8022d9 <insert_sorted_allocList+0x222>
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 00                	mov    (%eax),%eax
  8022d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d6:	89 50 04             	mov    %edx,0x4(%eax)
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022df:	89 10                	mov    %edx,(%eax)
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	75 08                	jne    8022fb <insert_sorted_allocList+0x244>
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	a3 44 50 80 00       	mov    %eax,0x805044
  8022fb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802300:	40                   	inc    %eax
  802301:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802306:	eb 39                	jmp    802341 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802308:	a1 48 50 80 00       	mov    0x805048,%eax
  80230d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802314:	74 07                	je     80231d <insert_sorted_allocList+0x266>
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 00                	mov    (%eax),%eax
  80231b:	eb 05                	jmp    802322 <insert_sorted_allocList+0x26b>
  80231d:	b8 00 00 00 00       	mov    $0x0,%eax
  802322:	a3 48 50 80 00       	mov    %eax,0x805048
  802327:	a1 48 50 80 00       	mov    0x805048,%eax
  80232c:	85 c0                	test   %eax,%eax
  80232e:	0f 85 3f ff ff ff    	jne    802273 <insert_sorted_allocList+0x1bc>
  802334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802338:	0f 85 35 ff ff ff    	jne    802273 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80233e:	eb 01                	jmp    802341 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802340:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802341:	90                   	nop
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80234a:	a1 38 51 80 00       	mov    0x805138,%eax
  80234f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802352:	e9 85 01 00 00       	jmp    8024dc <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 0c             	mov    0xc(%eax),%eax
  80235d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802360:	0f 82 6e 01 00 00    	jb     8024d4 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 40 0c             	mov    0xc(%eax),%eax
  80236c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80236f:	0f 85 8a 00 00 00    	jne    8023ff <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802375:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802379:	75 17                	jne    802392 <alloc_block_FF+0x4e>
  80237b:	83 ec 04             	sub    $0x4,%esp
  80237e:	68 64 40 80 00       	push   $0x804064
  802383:	68 93 00 00 00       	push   $0x93
  802388:	68 bb 3f 80 00       	push   $0x803fbb
  80238d:	e8 fe df ff ff       	call   800390 <_panic>
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 00                	mov    (%eax),%eax
  802397:	85 c0                	test   %eax,%eax
  802399:	74 10                	je     8023ab <alloc_block_FF+0x67>
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a3:	8b 52 04             	mov    0x4(%edx),%edx
  8023a6:	89 50 04             	mov    %edx,0x4(%eax)
  8023a9:	eb 0b                	jmp    8023b6 <alloc_block_FF+0x72>
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 40 04             	mov    0x4(%eax),%eax
  8023b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 40 04             	mov    0x4(%eax),%eax
  8023bc:	85 c0                	test   %eax,%eax
  8023be:	74 0f                	je     8023cf <alloc_block_FF+0x8b>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 40 04             	mov    0x4(%eax),%eax
  8023c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c9:	8b 12                	mov    (%edx),%edx
  8023cb:	89 10                	mov    %edx,(%eax)
  8023cd:	eb 0a                	jmp    8023d9 <alloc_block_FF+0x95>
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8023f1:	48                   	dec    %eax
  8023f2:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	e9 10 01 00 00       	jmp    80250f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	8b 40 0c             	mov    0xc(%eax),%eax
  802405:	3b 45 08             	cmp    0x8(%ebp),%eax
  802408:	0f 86 c6 00 00 00    	jbe    8024d4 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80240e:	a1 48 51 80 00       	mov    0x805148,%eax
  802413:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 50 08             	mov    0x8(%eax),%edx
  80241c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	8b 55 08             	mov    0x8(%ebp),%edx
  802428:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80242b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80242f:	75 17                	jne    802448 <alloc_block_FF+0x104>
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	68 64 40 80 00       	push   $0x804064
  802439:	68 9b 00 00 00       	push   $0x9b
  80243e:	68 bb 3f 80 00       	push   $0x803fbb
  802443:	e8 48 df ff ff       	call   800390 <_panic>
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	8b 00                	mov    (%eax),%eax
  80244d:	85 c0                	test   %eax,%eax
  80244f:	74 10                	je     802461 <alloc_block_FF+0x11d>
  802451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802454:	8b 00                	mov    (%eax),%eax
  802456:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802459:	8b 52 04             	mov    0x4(%edx),%edx
  80245c:	89 50 04             	mov    %edx,0x4(%eax)
  80245f:	eb 0b                	jmp    80246c <alloc_block_FF+0x128>
  802461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802464:	8b 40 04             	mov    0x4(%eax),%eax
  802467:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	8b 40 04             	mov    0x4(%eax),%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 0f                	je     802485 <alloc_block_FF+0x141>
  802476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802479:	8b 40 04             	mov    0x4(%eax),%eax
  80247c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80247f:	8b 12                	mov    (%edx),%edx
  802481:	89 10                	mov    %edx,(%eax)
  802483:	eb 0a                	jmp    80248f <alloc_block_FF+0x14b>
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	8b 00                	mov    (%eax),%eax
  80248a:	a3 48 51 80 00       	mov    %eax,0x805148
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a2:	a1 54 51 80 00       	mov    0x805154,%eax
  8024a7:	48                   	dec    %eax
  8024a8:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 50 08             	mov    0x8(%eax),%edx
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	01 c2                	add    %eax,%edx
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c4:	2b 45 08             	sub    0x8(%ebp),%eax
  8024c7:	89 c2                	mov    %eax,%edx
  8024c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cc:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d2:	eb 3b                	jmp    80250f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e0:	74 07                	je     8024e9 <alloc_block_FF+0x1a5>
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 00                	mov    (%eax),%eax
  8024e7:	eb 05                	jmp    8024ee <alloc_block_FF+0x1aa>
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ee:	a3 40 51 80 00       	mov    %eax,0x805140
  8024f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8024f8:	85 c0                	test   %eax,%eax
  8024fa:	0f 85 57 fe ff ff    	jne    802357 <alloc_block_FF+0x13>
  802500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802504:	0f 85 4d fe ff ff    	jne    802357 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
  802514:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802517:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80251e:	a1 38 51 80 00       	mov    0x805138,%eax
  802523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802526:	e9 df 00 00 00       	jmp    80260a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 40 0c             	mov    0xc(%eax),%eax
  802531:	3b 45 08             	cmp    0x8(%ebp),%eax
  802534:	0f 82 c8 00 00 00    	jb     802602 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 40 0c             	mov    0xc(%eax),%eax
  802540:	3b 45 08             	cmp    0x8(%ebp),%eax
  802543:	0f 85 8a 00 00 00    	jne    8025d3 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254d:	75 17                	jne    802566 <alloc_block_BF+0x55>
  80254f:	83 ec 04             	sub    $0x4,%esp
  802552:	68 64 40 80 00       	push   $0x804064
  802557:	68 b7 00 00 00       	push   $0xb7
  80255c:	68 bb 3f 80 00       	push   $0x803fbb
  802561:	e8 2a de ff ff       	call   800390 <_panic>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	74 10                	je     80257f <alloc_block_BF+0x6e>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 00                	mov    (%eax),%eax
  802574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802577:	8b 52 04             	mov    0x4(%edx),%edx
  80257a:	89 50 04             	mov    %edx,0x4(%eax)
  80257d:	eb 0b                	jmp    80258a <alloc_block_BF+0x79>
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	8b 40 04             	mov    0x4(%eax),%eax
  802585:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	74 0f                	je     8025a3 <alloc_block_BF+0x92>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 04             	mov    0x4(%eax),%eax
  80259a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259d:	8b 12                	mov    (%edx),%edx
  80259f:	89 10                	mov    %edx,(%eax)
  8025a1:	eb 0a                	jmp    8025ad <alloc_block_BF+0x9c>
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	8b 00                	mov    (%eax),%eax
  8025a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8025c5:	48                   	dec    %eax
  8025c6:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	e9 4d 01 00 00       	jmp    802720 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025dc:	76 24                	jbe    802602 <alloc_block_BF+0xf1>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025e7:	73 19                	jae    802602 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025e9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 08             	mov    0x8(%eax),%eax
  8025ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802602:	a1 40 51 80 00       	mov    0x805140,%eax
  802607:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260e:	74 07                	je     802617 <alloc_block_BF+0x106>
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 00                	mov    (%eax),%eax
  802615:	eb 05                	jmp    80261c <alloc_block_BF+0x10b>
  802617:	b8 00 00 00 00       	mov    $0x0,%eax
  80261c:	a3 40 51 80 00       	mov    %eax,0x805140
  802621:	a1 40 51 80 00       	mov    0x805140,%eax
  802626:	85 c0                	test   %eax,%eax
  802628:	0f 85 fd fe ff ff    	jne    80252b <alloc_block_BF+0x1a>
  80262e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802632:	0f 85 f3 fe ff ff    	jne    80252b <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802638:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80263c:	0f 84 d9 00 00 00    	je     80271b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802642:	a1 48 51 80 00       	mov    0x805148,%eax
  802647:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80264a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802650:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802656:	8b 55 08             	mov    0x8(%ebp),%edx
  802659:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80265c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802660:	75 17                	jne    802679 <alloc_block_BF+0x168>
  802662:	83 ec 04             	sub    $0x4,%esp
  802665:	68 64 40 80 00       	push   $0x804064
  80266a:	68 c7 00 00 00       	push   $0xc7
  80266f:	68 bb 3f 80 00       	push   $0x803fbb
  802674:	e8 17 dd ff ff       	call   800390 <_panic>
  802679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	85 c0                	test   %eax,%eax
  802680:	74 10                	je     802692 <alloc_block_BF+0x181>
  802682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802685:	8b 00                	mov    (%eax),%eax
  802687:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268a:	8b 52 04             	mov    0x4(%edx),%edx
  80268d:	89 50 04             	mov    %edx,0x4(%eax)
  802690:	eb 0b                	jmp    80269d <alloc_block_BF+0x18c>
  802692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802695:	8b 40 04             	mov    0x4(%eax),%eax
  802698:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80269d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a0:	8b 40 04             	mov    0x4(%eax),%eax
  8026a3:	85 c0                	test   %eax,%eax
  8026a5:	74 0f                	je     8026b6 <alloc_block_BF+0x1a5>
  8026a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026aa:	8b 40 04             	mov    0x4(%eax),%eax
  8026ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026b0:	8b 12                	mov    (%edx),%edx
  8026b2:	89 10                	mov    %edx,(%eax)
  8026b4:	eb 0a                	jmp    8026c0 <alloc_block_BF+0x1af>
  8026b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b9:	8b 00                	mov    (%eax),%eax
  8026bb:	a3 48 51 80 00       	mov    %eax,0x805148
  8026c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d3:	a1 54 51 80 00       	mov    0x805154,%eax
  8026d8:	48                   	dec    %eax
  8026d9:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026de:	83 ec 08             	sub    $0x8,%esp
  8026e1:	ff 75 ec             	pushl  -0x14(%ebp)
  8026e4:	68 38 51 80 00       	push   $0x805138
  8026e9:	e8 71 f9 ff ff       	call   80205f <find_block>
  8026ee:	83 c4 10             	add    $0x10,%esp
  8026f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f7:	8b 50 08             	mov    0x8(%eax),%edx
  8026fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fd:	01 c2                	add    %eax,%edx
  8026ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802702:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802705:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802708:	8b 40 0c             	mov    0xc(%eax),%eax
  80270b:	2b 45 08             	sub    0x8(%ebp),%eax
  80270e:	89 c2                	mov    %eax,%edx
  802710:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802713:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802719:	eb 05                	jmp    802720 <alloc_block_BF+0x20f>
	}
	return NULL;
  80271b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802720:	c9                   	leave  
  802721:	c3                   	ret    

00802722 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802722:	55                   	push   %ebp
  802723:	89 e5                	mov    %esp,%ebp
  802725:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802728:	a1 28 50 80 00       	mov    0x805028,%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	0f 85 de 01 00 00    	jne    802913 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802735:	a1 38 51 80 00       	mov    0x805138,%eax
  80273a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273d:	e9 9e 01 00 00       	jmp    8028e0 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274b:	0f 82 87 01 00 00    	jb     8028d8 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 40 0c             	mov    0xc(%eax),%eax
  802757:	3b 45 08             	cmp    0x8(%ebp),%eax
  80275a:	0f 85 95 00 00 00    	jne    8027f5 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802764:	75 17                	jne    80277d <alloc_block_NF+0x5b>
  802766:	83 ec 04             	sub    $0x4,%esp
  802769:	68 64 40 80 00       	push   $0x804064
  80276e:	68 e0 00 00 00       	push   $0xe0
  802773:	68 bb 3f 80 00       	push   $0x803fbb
  802778:	e8 13 dc ff ff       	call   800390 <_panic>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	85 c0                	test   %eax,%eax
  802784:	74 10                	je     802796 <alloc_block_NF+0x74>
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 00                	mov    (%eax),%eax
  80278b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278e:	8b 52 04             	mov    0x4(%edx),%edx
  802791:	89 50 04             	mov    %edx,0x4(%eax)
  802794:	eb 0b                	jmp    8027a1 <alloc_block_NF+0x7f>
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 04             	mov    0x4(%eax),%eax
  80279c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 40 04             	mov    0x4(%eax),%eax
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	74 0f                	je     8027ba <alloc_block_NF+0x98>
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 04             	mov    0x4(%eax),%eax
  8027b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b4:	8b 12                	mov    (%edx),%edx
  8027b6:	89 10                	mov    %edx,(%eax)
  8027b8:	eb 0a                	jmp    8027c4 <alloc_block_NF+0xa2>
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8027dc:	48                   	dec    %eax
  8027dd:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 40 08             	mov    0x8(%eax),%eax
  8027e8:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	e9 f8 04 00 00       	jmp    802ced <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027fe:	0f 86 d4 00 00 00    	jbe    8028d8 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802804:	a1 48 51 80 00       	mov    0x805148,%eax
  802809:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 50 08             	mov    0x8(%eax),%edx
  802812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802815:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	8b 55 08             	mov    0x8(%ebp),%edx
  80281e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802821:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802825:	75 17                	jne    80283e <alloc_block_NF+0x11c>
  802827:	83 ec 04             	sub    $0x4,%esp
  80282a:	68 64 40 80 00       	push   $0x804064
  80282f:	68 e9 00 00 00       	push   $0xe9
  802834:	68 bb 3f 80 00       	push   $0x803fbb
  802839:	e8 52 db ff ff       	call   800390 <_panic>
  80283e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802841:	8b 00                	mov    (%eax),%eax
  802843:	85 c0                	test   %eax,%eax
  802845:	74 10                	je     802857 <alloc_block_NF+0x135>
  802847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284a:	8b 00                	mov    (%eax),%eax
  80284c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284f:	8b 52 04             	mov    0x4(%edx),%edx
  802852:	89 50 04             	mov    %edx,0x4(%eax)
  802855:	eb 0b                	jmp    802862 <alloc_block_NF+0x140>
  802857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285a:	8b 40 04             	mov    0x4(%eax),%eax
  80285d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802862:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	85 c0                	test   %eax,%eax
  80286a:	74 0f                	je     80287b <alloc_block_NF+0x159>
  80286c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286f:	8b 40 04             	mov    0x4(%eax),%eax
  802872:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802875:	8b 12                	mov    (%edx),%edx
  802877:	89 10                	mov    %edx,(%eax)
  802879:	eb 0a                	jmp    802885 <alloc_block_NF+0x163>
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	a3 48 51 80 00       	mov    %eax,0x805148
  802885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802888:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802891:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802898:	a1 54 51 80 00       	mov    0x805154,%eax
  80289d:	48                   	dec    %eax
  80289e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a6:	8b 40 08             	mov    0x8(%eax),%eax
  8028a9:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	8b 50 08             	mov    0x8(%eax),%edx
  8028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b7:	01 c2                	add    %eax,%edx
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c5:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c8:	89 c2                	mov    %eax,%edx
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d3:	e9 15 04 00 00       	jmp    802ced <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8028dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e4:	74 07                	je     8028ed <alloc_block_NF+0x1cb>
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	eb 05                	jmp    8028f2 <alloc_block_NF+0x1d0>
  8028ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f2:	a3 40 51 80 00       	mov    %eax,0x805140
  8028f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	0f 85 3e fe ff ff    	jne    802742 <alloc_block_NF+0x20>
  802904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802908:	0f 85 34 fe ff ff    	jne    802742 <alloc_block_NF+0x20>
  80290e:	e9 d5 03 00 00       	jmp    802ce8 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802913:	a1 38 51 80 00       	mov    0x805138,%eax
  802918:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291b:	e9 b1 01 00 00       	jmp    802ad1 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 50 08             	mov    0x8(%eax),%edx
  802926:	a1 28 50 80 00       	mov    0x805028,%eax
  80292b:	39 c2                	cmp    %eax,%edx
  80292d:	0f 82 96 01 00 00    	jb     802ac9 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 0c             	mov    0xc(%eax),%eax
  802939:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293c:	0f 82 87 01 00 00    	jb     802ac9 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 40 0c             	mov    0xc(%eax),%eax
  802948:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294b:	0f 85 95 00 00 00    	jne    8029e6 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802955:	75 17                	jne    80296e <alloc_block_NF+0x24c>
  802957:	83 ec 04             	sub    $0x4,%esp
  80295a:	68 64 40 80 00       	push   $0x804064
  80295f:	68 fc 00 00 00       	push   $0xfc
  802964:	68 bb 3f 80 00       	push   $0x803fbb
  802969:	e8 22 da ff ff       	call   800390 <_panic>
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	85 c0                	test   %eax,%eax
  802975:	74 10                	je     802987 <alloc_block_NF+0x265>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297f:	8b 52 04             	mov    0x4(%edx),%edx
  802982:	89 50 04             	mov    %edx,0x4(%eax)
  802985:	eb 0b                	jmp    802992 <alloc_block_NF+0x270>
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 40 04             	mov    0x4(%eax),%eax
  80298d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 40 04             	mov    0x4(%eax),%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	74 0f                	je     8029ab <alloc_block_NF+0x289>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 04             	mov    0x4(%eax),%eax
  8029a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a5:	8b 12                	mov    (%edx),%edx
  8029a7:	89 10                	mov    %edx,(%eax)
  8029a9:	eb 0a                	jmp    8029b5 <alloc_block_NF+0x293>
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8029cd:	48                   	dec    %eax
  8029ce:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 40 08             	mov    0x8(%eax),%eax
  8029d9:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e1:	e9 07 03 00 00       	jmp    802ced <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ef:	0f 86 d4 00 00 00    	jbe    802ac9 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8029fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 50 08             	mov    0x8(%eax),%edx
  802a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a06:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a12:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a16:	75 17                	jne    802a2f <alloc_block_NF+0x30d>
  802a18:	83 ec 04             	sub    $0x4,%esp
  802a1b:	68 64 40 80 00       	push   $0x804064
  802a20:	68 04 01 00 00       	push   $0x104
  802a25:	68 bb 3f 80 00       	push   $0x803fbb
  802a2a:	e8 61 d9 ff ff       	call   800390 <_panic>
  802a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a32:	8b 00                	mov    (%eax),%eax
  802a34:	85 c0                	test   %eax,%eax
  802a36:	74 10                	je     802a48 <alloc_block_NF+0x326>
  802a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a40:	8b 52 04             	mov    0x4(%edx),%edx
  802a43:	89 50 04             	mov    %edx,0x4(%eax)
  802a46:	eb 0b                	jmp    802a53 <alloc_block_NF+0x331>
  802a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a56:	8b 40 04             	mov    0x4(%eax),%eax
  802a59:	85 c0                	test   %eax,%eax
  802a5b:	74 0f                	je     802a6c <alloc_block_NF+0x34a>
  802a5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a60:	8b 40 04             	mov    0x4(%eax),%eax
  802a63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a66:	8b 12                	mov    (%edx),%edx
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	eb 0a                	jmp    802a76 <alloc_block_NF+0x354>
  802a6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	a3 48 51 80 00       	mov    %eax,0x805148
  802a76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a89:	a1 54 51 80 00       	mov    0x805154,%eax
  802a8e:	48                   	dec    %eax
  802a8f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a97:	8b 40 08             	mov    0x8(%eax),%eax
  802a9a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 50 08             	mov    0x8(%eax),%edx
  802aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa8:	01 c2                	add    %eax,%edx
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab6:	2b 45 08             	sub    0x8(%ebp),%eax
  802ab9:	89 c2                	mov    %eax,%edx
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ac1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac4:	e9 24 02 00 00       	jmp    802ced <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ac9:	a1 40 51 80 00       	mov    0x805140,%eax
  802ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad5:	74 07                	je     802ade <alloc_block_NF+0x3bc>
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	eb 05                	jmp    802ae3 <alloc_block_NF+0x3c1>
  802ade:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ae8:	a1 40 51 80 00       	mov    0x805140,%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	0f 85 2b fe ff ff    	jne    802920 <alloc_block_NF+0x1fe>
  802af5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af9:	0f 85 21 fe ff ff    	jne    802920 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aff:	a1 38 51 80 00       	mov    0x805138,%eax
  802b04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b07:	e9 ae 01 00 00       	jmp    802cba <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 50 08             	mov    0x8(%eax),%edx
  802b12:	a1 28 50 80 00       	mov    0x805028,%eax
  802b17:	39 c2                	cmp    %eax,%edx
  802b19:	0f 83 93 01 00 00    	jae    802cb2 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 0c             	mov    0xc(%eax),%eax
  802b25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b28:	0f 82 84 01 00 00    	jb     802cb2 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 0c             	mov    0xc(%eax),%eax
  802b34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b37:	0f 85 95 00 00 00    	jne    802bd2 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b41:	75 17                	jne    802b5a <alloc_block_NF+0x438>
  802b43:	83 ec 04             	sub    $0x4,%esp
  802b46:	68 64 40 80 00       	push   $0x804064
  802b4b:	68 14 01 00 00       	push   $0x114
  802b50:	68 bb 3f 80 00       	push   $0x803fbb
  802b55:	e8 36 d8 ff ff       	call   800390 <_panic>
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 10                	je     802b73 <alloc_block_NF+0x451>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 00                	mov    (%eax),%eax
  802b68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6b:	8b 52 04             	mov    0x4(%edx),%edx
  802b6e:	89 50 04             	mov    %edx,0x4(%eax)
  802b71:	eb 0b                	jmp    802b7e <alloc_block_NF+0x45c>
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 40 04             	mov    0x4(%eax),%eax
  802b79:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 04             	mov    0x4(%eax),%eax
  802b84:	85 c0                	test   %eax,%eax
  802b86:	74 0f                	je     802b97 <alloc_block_NF+0x475>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 40 04             	mov    0x4(%eax),%eax
  802b8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b91:	8b 12                	mov    (%edx),%edx
  802b93:	89 10                	mov    %edx,(%eax)
  802b95:	eb 0a                	jmp    802ba1 <alloc_block_NF+0x47f>
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	a3 38 51 80 00       	mov    %eax,0x805138
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb4:	a1 44 51 80 00       	mov    0x805144,%eax
  802bb9:	48                   	dec    %eax
  802bba:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	8b 40 08             	mov    0x8(%eax),%eax
  802bc5:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	e9 1b 01 00 00       	jmp    802ced <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bdb:	0f 86 d1 00 00 00    	jbe    802cb2 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802be1:	a1 48 51 80 00       	mov    0x805148,%eax
  802be6:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 50 08             	mov    0x8(%eax),%edx
  802bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c02:	75 17                	jne    802c1b <alloc_block_NF+0x4f9>
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	68 64 40 80 00       	push   $0x804064
  802c0c:	68 1c 01 00 00       	push   $0x11c
  802c11:	68 bb 3f 80 00       	push   $0x803fbb
  802c16:	e8 75 d7 ff ff       	call   800390 <_panic>
  802c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1e:	8b 00                	mov    (%eax),%eax
  802c20:	85 c0                	test   %eax,%eax
  802c22:	74 10                	je     802c34 <alloc_block_NF+0x512>
  802c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c2c:	8b 52 04             	mov    0x4(%edx),%edx
  802c2f:	89 50 04             	mov    %edx,0x4(%eax)
  802c32:	eb 0b                	jmp    802c3f <alloc_block_NF+0x51d>
  802c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c37:	8b 40 04             	mov    0x4(%eax),%eax
  802c3a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c42:	8b 40 04             	mov    0x4(%eax),%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	74 0f                	je     802c58 <alloc_block_NF+0x536>
  802c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4c:	8b 40 04             	mov    0x4(%eax),%eax
  802c4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c52:	8b 12                	mov    (%edx),%edx
  802c54:	89 10                	mov    %edx,(%eax)
  802c56:	eb 0a                	jmp    802c62 <alloc_block_NF+0x540>
  802c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c65:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c75:	a1 54 51 80 00       	mov    0x805154,%eax
  802c7a:	48                   	dec    %eax
  802c7b:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c83:	8b 40 08             	mov    0x8(%eax),%eax
  802c86:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 50 08             	mov    0x8(%eax),%edx
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	01 c2                	add    %eax,%edx
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ca5:	89 c2                	mov    %eax,%edx
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb0:	eb 3b                	jmp    802ced <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cb2:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	74 07                	je     802cc7 <alloc_block_NF+0x5a5>
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	eb 05                	jmp    802ccc <alloc_block_NF+0x5aa>
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccc:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	0f 85 2e fe ff ff    	jne    802b0c <alloc_block_NF+0x3ea>
  802cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce2:	0f 85 24 fe ff ff    	jne    802b0c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ced:	c9                   	leave  
  802cee:	c3                   	ret    

00802cef <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cef:	55                   	push   %ebp
  802cf0:	89 e5                	mov    %esp,%ebp
  802cf2:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cf5:	a1 38 51 80 00       	mov    0x805138,%eax
  802cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cfd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d02:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d05:	a1 38 51 80 00       	mov    0x805138,%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 14                	je     802d22 <insert_sorted_with_merge_freeList+0x33>
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	8b 50 08             	mov    0x8(%eax),%edx
  802d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d17:	8b 40 08             	mov    0x8(%eax),%eax
  802d1a:	39 c2                	cmp    %eax,%edx
  802d1c:	0f 87 9b 01 00 00    	ja     802ebd <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d26:	75 17                	jne    802d3f <insert_sorted_with_merge_freeList+0x50>
  802d28:	83 ec 04             	sub    $0x4,%esp
  802d2b:	68 98 3f 80 00       	push   $0x803f98
  802d30:	68 38 01 00 00       	push   $0x138
  802d35:	68 bb 3f 80 00       	push   $0x803fbb
  802d3a:	e8 51 d6 ff ff       	call   800390 <_panic>
  802d3f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	89 10                	mov    %edx,(%eax)
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	74 0d                	je     802d60 <insert_sorted_with_merge_freeList+0x71>
  802d53:	a1 38 51 80 00       	mov    0x805138,%eax
  802d58:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	eb 08                	jmp    802d68 <insert_sorted_with_merge_freeList+0x79>
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d7f:	40                   	inc    %eax
  802d80:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d89:	0f 84 a8 06 00 00    	je     803437 <insert_sorted_with_merge_freeList+0x748>
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	8b 50 08             	mov    0x8(%eax),%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	01 c2                	add    %eax,%edx
  802d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da0:	8b 40 08             	mov    0x8(%eax),%eax
  802da3:	39 c2                	cmp    %eax,%edx
  802da5:	0f 85 8c 06 00 00    	jne    803437 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	8b 50 0c             	mov    0xc(%eax),%edx
  802db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db4:	8b 40 0c             	mov    0xc(%eax),%eax
  802db7:	01 c2                	add    %eax,%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc3:	75 17                	jne    802ddc <insert_sorted_with_merge_freeList+0xed>
  802dc5:	83 ec 04             	sub    $0x4,%esp
  802dc8:	68 64 40 80 00       	push   $0x804064
  802dcd:	68 3c 01 00 00       	push   $0x13c
  802dd2:	68 bb 3f 80 00       	push   $0x803fbb
  802dd7:	e8 b4 d5 ff ff       	call   800390 <_panic>
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 10                	je     802df5 <insert_sorted_with_merge_freeList+0x106>
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ded:	8b 52 04             	mov    0x4(%edx),%edx
  802df0:	89 50 04             	mov    %edx,0x4(%eax)
  802df3:	eb 0b                	jmp    802e00 <insert_sorted_with_merge_freeList+0x111>
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	8b 40 04             	mov    0x4(%eax),%eax
  802dfb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e03:	8b 40 04             	mov    0x4(%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 0f                	je     802e19 <insert_sorted_with_merge_freeList+0x12a>
  802e0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0d:	8b 40 04             	mov    0x4(%eax),%eax
  802e10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e13:	8b 12                	mov    (%edx),%edx
  802e15:	89 10                	mov    %edx,(%eax)
  802e17:	eb 0a                	jmp    802e23 <insert_sorted_with_merge_freeList+0x134>
  802e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1c:	8b 00                	mov    (%eax),%eax
  802e1e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e36:	a1 44 51 80 00       	mov    0x805144,%eax
  802e3b:	48                   	dec    %eax
  802e3c:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e59:	75 17                	jne    802e72 <insert_sorted_with_merge_freeList+0x183>
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	68 98 3f 80 00       	push   $0x803f98
  802e63:	68 3f 01 00 00       	push   $0x13f
  802e68:	68 bb 3f 80 00       	push   $0x803fbb
  802e6d:	e8 1e d5 ff ff       	call   800390 <_panic>
  802e72:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7b:	89 10                	mov    %edx,(%eax)
  802e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0d                	je     802e93 <insert_sorted_with_merge_freeList+0x1a4>
  802e86:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e8e:	89 50 04             	mov    %edx,0x4(%eax)
  802e91:	eb 08                	jmp    802e9b <insert_sorted_with_merge_freeList+0x1ac>
  802e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9e:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ead:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb2:	40                   	inc    %eax
  802eb3:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eb8:	e9 7a 05 00 00       	jmp    803437 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 50 08             	mov    0x8(%eax),%edx
  802ec3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec6:	8b 40 08             	mov    0x8(%eax),%eax
  802ec9:	39 c2                	cmp    %eax,%edx
  802ecb:	0f 82 14 01 00 00    	jb     802fe5 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed4:	8b 50 08             	mov    0x8(%eax),%edx
  802ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	01 c2                	add    %eax,%edx
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 40 08             	mov    0x8(%eax),%eax
  802ee5:	39 c2                	cmp    %eax,%edx
  802ee7:	0f 85 90 00 00 00    	jne    802f7d <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef9:	01 c2                	add    %eax,%edx
  802efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efe:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f19:	75 17                	jne    802f32 <insert_sorted_with_merge_freeList+0x243>
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 98 3f 80 00       	push   $0x803f98
  802f23:	68 49 01 00 00       	push   $0x149
  802f28:	68 bb 3f 80 00       	push   $0x803fbb
  802f2d:	e8 5e d4 ff ff       	call   800390 <_panic>
  802f32:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	89 10                	mov    %edx,(%eax)
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	8b 00                	mov    (%eax),%eax
  802f42:	85 c0                	test   %eax,%eax
  802f44:	74 0d                	je     802f53 <insert_sorted_with_merge_freeList+0x264>
  802f46:	a1 48 51 80 00       	mov    0x805148,%eax
  802f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4e:	89 50 04             	mov    %edx,0x4(%eax)
  802f51:	eb 08                	jmp    802f5b <insert_sorted_with_merge_freeList+0x26c>
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	a3 48 51 80 00       	mov    %eax,0x805148
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802f72:	40                   	inc    %eax
  802f73:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f78:	e9 bb 04 00 00       	jmp    803438 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f81:	75 17                	jne    802f9a <insert_sorted_with_merge_freeList+0x2ab>
  802f83:	83 ec 04             	sub    $0x4,%esp
  802f86:	68 0c 40 80 00       	push   $0x80400c
  802f8b:	68 4c 01 00 00       	push   $0x14c
  802f90:	68 bb 3f 80 00       	push   $0x803fbb
  802f95:	e8 f6 d3 ff ff       	call   800390 <_panic>
  802f9a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	89 50 04             	mov    %edx,0x4(%eax)
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	8b 40 04             	mov    0x4(%eax),%eax
  802fac:	85 c0                	test   %eax,%eax
  802fae:	74 0c                	je     802fbc <insert_sorted_with_merge_freeList+0x2cd>
  802fb0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb8:	89 10                	mov    %edx,(%eax)
  802fba:	eb 08                	jmp    802fc4 <insert_sorted_with_merge_freeList+0x2d5>
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	a3 38 51 80 00       	mov    %eax,0x805138
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd5:	a1 44 51 80 00       	mov    0x805144,%eax
  802fda:	40                   	inc    %eax
  802fdb:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fe0:	e9 53 04 00 00       	jmp    803438 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fe5:	a1 38 51 80 00       	mov    0x805138,%eax
  802fea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fed:	e9 15 04 00 00       	jmp    803407 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8b 50 08             	mov    0x8(%eax),%edx
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 40 08             	mov    0x8(%eax),%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	0f 86 f1 03 00 00    	jbe    8033ff <insert_sorted_with_merge_freeList+0x710>
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	8b 50 08             	mov    0x8(%eax),%edx
  803014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803017:	8b 40 08             	mov    0x8(%eax),%eax
  80301a:	39 c2                	cmp    %eax,%edx
  80301c:	0f 83 dd 03 00 00    	jae    8033ff <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	8b 50 08             	mov    0x8(%eax),%edx
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	8b 40 0c             	mov    0xc(%eax),%eax
  80302e:	01 c2                	add    %eax,%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	8b 40 08             	mov    0x8(%eax),%eax
  803036:	39 c2                	cmp    %eax,%edx
  803038:	0f 85 b9 01 00 00    	jne    8031f7 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	8b 50 08             	mov    0x8(%eax),%edx
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	8b 40 0c             	mov    0xc(%eax),%eax
  80304a:	01 c2                	add    %eax,%edx
  80304c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304f:	8b 40 08             	mov    0x8(%eax),%eax
  803052:	39 c2                	cmp    %eax,%edx
  803054:	0f 85 0d 01 00 00    	jne    803167 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 50 0c             	mov    0xc(%eax),%edx
  803060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803063:	8b 40 0c             	mov    0xc(%eax),%eax
  803066:	01 c2                	add    %eax,%edx
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80306e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803072:	75 17                	jne    80308b <insert_sorted_with_merge_freeList+0x39c>
  803074:	83 ec 04             	sub    $0x4,%esp
  803077:	68 64 40 80 00       	push   $0x804064
  80307c:	68 5c 01 00 00       	push   $0x15c
  803081:	68 bb 3f 80 00       	push   $0x803fbb
  803086:	e8 05 d3 ff ff       	call   800390 <_panic>
  80308b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 10                	je     8030a4 <insert_sorted_with_merge_freeList+0x3b5>
  803094:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309c:	8b 52 04             	mov    0x4(%edx),%edx
  80309f:	89 50 04             	mov    %edx,0x4(%eax)
  8030a2:	eb 0b                	jmp    8030af <insert_sorted_with_merge_freeList+0x3c0>
  8030a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a7:	8b 40 04             	mov    0x4(%eax),%eax
  8030aa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	74 0f                	je     8030c8 <insert_sorted_with_merge_freeList+0x3d9>
  8030b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bc:	8b 40 04             	mov    0x4(%eax),%eax
  8030bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c2:	8b 12                	mov    (%edx),%edx
  8030c4:	89 10                	mov    %edx,(%eax)
  8030c6:	eb 0a                	jmp    8030d2 <insert_sorted_with_merge_freeList+0x3e3>
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	8b 00                	mov    (%eax),%eax
  8030cd:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e5:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ea:	48                   	dec    %eax
  8030eb:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803104:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803108:	75 17                	jne    803121 <insert_sorted_with_merge_freeList+0x432>
  80310a:	83 ec 04             	sub    $0x4,%esp
  80310d:	68 98 3f 80 00       	push   $0x803f98
  803112:	68 5f 01 00 00       	push   $0x15f
  803117:	68 bb 3f 80 00       	push   $0x803fbb
  80311c:	e8 6f d2 ff ff       	call   800390 <_panic>
  803121:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803127:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312a:	89 10                	mov    %edx,(%eax)
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	8b 00                	mov    (%eax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	74 0d                	je     803142 <insert_sorted_with_merge_freeList+0x453>
  803135:	a1 48 51 80 00       	mov    0x805148,%eax
  80313a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80313d:	89 50 04             	mov    %edx,0x4(%eax)
  803140:	eb 08                	jmp    80314a <insert_sorted_with_merge_freeList+0x45b>
  803142:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803145:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80314a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314d:	a3 48 51 80 00       	mov    %eax,0x805148
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315c:	a1 54 51 80 00       	mov    0x805154,%eax
  803161:	40                   	inc    %eax
  803162:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316a:	8b 50 0c             	mov    0xc(%eax),%edx
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	8b 40 0c             	mov    0xc(%eax),%eax
  803173:	01 c2                	add    %eax,%edx
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80318f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803193:	75 17                	jne    8031ac <insert_sorted_with_merge_freeList+0x4bd>
  803195:	83 ec 04             	sub    $0x4,%esp
  803198:	68 98 3f 80 00       	push   $0x803f98
  80319d:	68 64 01 00 00       	push   $0x164
  8031a2:	68 bb 3f 80 00       	push   $0x803fbb
  8031a7:	e8 e4 d1 ff ff       	call   800390 <_panic>
  8031ac:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	89 10                	mov    %edx,(%eax)
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 0d                	je     8031cd <insert_sorted_with_merge_freeList+0x4de>
  8031c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c8:	89 50 04             	mov    %edx,0x4(%eax)
  8031cb:	eb 08                	jmp    8031d5 <insert_sorted_with_merge_freeList+0x4e6>
  8031cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	a3 48 51 80 00       	mov    %eax,0x805148
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e7:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ec:	40                   	inc    %eax
  8031ed:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031f2:	e9 41 02 00 00       	jmp    803438 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fa:	8b 50 08             	mov    0x8(%eax),%edx
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	8b 40 0c             	mov    0xc(%eax),%eax
  803203:	01 c2                	add    %eax,%edx
  803205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803208:	8b 40 08             	mov    0x8(%eax),%eax
  80320b:	39 c2                	cmp    %eax,%edx
  80320d:	0f 85 7c 01 00 00    	jne    80338f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803213:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803217:	74 06                	je     80321f <insert_sorted_with_merge_freeList+0x530>
  803219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321d:	75 17                	jne    803236 <insert_sorted_with_merge_freeList+0x547>
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	68 d4 3f 80 00       	push   $0x803fd4
  803227:	68 69 01 00 00       	push   $0x169
  80322c:	68 bb 3f 80 00       	push   $0x803fbb
  803231:	e8 5a d1 ff ff       	call   800390 <_panic>
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	8b 50 04             	mov    0x4(%eax),%edx
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	89 50 04             	mov    %edx,0x4(%eax)
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803248:	89 10                	mov    %edx,(%eax)
  80324a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324d:	8b 40 04             	mov    0x4(%eax),%eax
  803250:	85 c0                	test   %eax,%eax
  803252:	74 0d                	je     803261 <insert_sorted_with_merge_freeList+0x572>
  803254:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803257:	8b 40 04             	mov    0x4(%eax),%eax
  80325a:	8b 55 08             	mov    0x8(%ebp),%edx
  80325d:	89 10                	mov    %edx,(%eax)
  80325f:	eb 08                	jmp    803269 <insert_sorted_with_merge_freeList+0x57a>
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	a3 38 51 80 00       	mov    %eax,0x805138
  803269:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326c:	8b 55 08             	mov    0x8(%ebp),%edx
  80326f:	89 50 04             	mov    %edx,0x4(%eax)
  803272:	a1 44 51 80 00       	mov    0x805144,%eax
  803277:	40                   	inc    %eax
  803278:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	8b 50 0c             	mov    0xc(%eax),%edx
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	8b 40 0c             	mov    0xc(%eax),%eax
  803289:	01 c2                	add    %eax,%edx
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803291:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803295:	75 17                	jne    8032ae <insert_sorted_with_merge_freeList+0x5bf>
  803297:	83 ec 04             	sub    $0x4,%esp
  80329a:	68 64 40 80 00       	push   $0x804064
  80329f:	68 6b 01 00 00       	push   $0x16b
  8032a4:	68 bb 3f 80 00       	push   $0x803fbb
  8032a9:	e8 e2 d0 ff ff       	call   800390 <_panic>
  8032ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b1:	8b 00                	mov    (%eax),%eax
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	74 10                	je     8032c7 <insert_sorted_with_merge_freeList+0x5d8>
  8032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ba:	8b 00                	mov    (%eax),%eax
  8032bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032bf:	8b 52 04             	mov    0x4(%edx),%edx
  8032c2:	89 50 04             	mov    %edx,0x4(%eax)
  8032c5:	eb 0b                	jmp    8032d2 <insert_sorted_with_merge_freeList+0x5e3>
  8032c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ca:	8b 40 04             	mov    0x4(%eax),%eax
  8032cd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d5:	8b 40 04             	mov    0x4(%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	74 0f                	je     8032eb <insert_sorted_with_merge_freeList+0x5fc>
  8032dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032df:	8b 40 04             	mov    0x4(%eax),%eax
  8032e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e5:	8b 12                	mov    (%edx),%edx
  8032e7:	89 10                	mov    %edx,(%eax)
  8032e9:	eb 0a                	jmp    8032f5 <insert_sorted_with_merge_freeList+0x606>
  8032eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ee:	8b 00                	mov    (%eax),%eax
  8032f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803301:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803308:	a1 44 51 80 00       	mov    0x805144,%eax
  80330d:	48                   	dec    %eax
  80330e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803316:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80331d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803320:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803327:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80332b:	75 17                	jne    803344 <insert_sorted_with_merge_freeList+0x655>
  80332d:	83 ec 04             	sub    $0x4,%esp
  803330:	68 98 3f 80 00       	push   $0x803f98
  803335:	68 6e 01 00 00       	push   $0x16e
  80333a:	68 bb 3f 80 00       	push   $0x803fbb
  80333f:	e8 4c d0 ff ff       	call   800390 <_panic>
  803344:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	89 10                	mov    %edx,(%eax)
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	8b 00                	mov    (%eax),%eax
  803354:	85 c0                	test   %eax,%eax
  803356:	74 0d                	je     803365 <insert_sorted_with_merge_freeList+0x676>
  803358:	a1 48 51 80 00       	mov    0x805148,%eax
  80335d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803360:	89 50 04             	mov    %edx,0x4(%eax)
  803363:	eb 08                	jmp    80336d <insert_sorted_with_merge_freeList+0x67e>
  803365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803368:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803370:	a3 48 51 80 00       	mov    %eax,0x805148
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80337f:	a1 54 51 80 00       	mov    0x805154,%eax
  803384:	40                   	inc    %eax
  803385:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80338a:	e9 a9 00 00 00       	jmp    803438 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80338f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803393:	74 06                	je     80339b <insert_sorted_with_merge_freeList+0x6ac>
  803395:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803399:	75 17                	jne    8033b2 <insert_sorted_with_merge_freeList+0x6c3>
  80339b:	83 ec 04             	sub    $0x4,%esp
  80339e:	68 30 40 80 00       	push   $0x804030
  8033a3:	68 73 01 00 00       	push   $0x173
  8033a8:	68 bb 3f 80 00       	push   $0x803fbb
  8033ad:	e8 de cf ff ff       	call   800390 <_panic>
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	8b 10                	mov    (%eax),%edx
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	89 10                	mov    %edx,(%eax)
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	85 c0                	test   %eax,%eax
  8033c3:	74 0b                	je     8033d0 <insert_sorted_with_merge_freeList+0x6e1>
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	8b 00                	mov    (%eax),%eax
  8033ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8033cd:	89 50 04             	mov    %edx,0x4(%eax)
  8033d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d6:	89 10                	mov    %edx,(%eax)
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033de:	89 50 04             	mov    %edx,0x4(%eax)
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 00                	mov    (%eax),%eax
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	75 08                	jne    8033f2 <insert_sorted_with_merge_freeList+0x703>
  8033ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8033f7:	40                   	inc    %eax
  8033f8:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033fd:	eb 39                	jmp    803438 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033ff:	a1 40 51 80 00       	mov    0x805140,%eax
  803404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803407:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340b:	74 07                	je     803414 <insert_sorted_with_merge_freeList+0x725>
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	eb 05                	jmp    803419 <insert_sorted_with_merge_freeList+0x72a>
  803414:	b8 00 00 00 00       	mov    $0x0,%eax
  803419:	a3 40 51 80 00       	mov    %eax,0x805140
  80341e:	a1 40 51 80 00       	mov    0x805140,%eax
  803423:	85 c0                	test   %eax,%eax
  803425:	0f 85 c7 fb ff ff    	jne    802ff2 <insert_sorted_with_merge_freeList+0x303>
  80342b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80342f:	0f 85 bd fb ff ff    	jne    802ff2 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803435:	eb 01                	jmp    803438 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803437:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803438:	90                   	nop
  803439:	c9                   	leave  
  80343a:	c3                   	ret    
  80343b:	90                   	nop

0080343c <__udivdi3>:
  80343c:	55                   	push   %ebp
  80343d:	57                   	push   %edi
  80343e:	56                   	push   %esi
  80343f:	53                   	push   %ebx
  803440:	83 ec 1c             	sub    $0x1c,%esp
  803443:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803447:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80344b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80344f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803453:	89 ca                	mov    %ecx,%edx
  803455:	89 f8                	mov    %edi,%eax
  803457:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80345b:	85 f6                	test   %esi,%esi
  80345d:	75 2d                	jne    80348c <__udivdi3+0x50>
  80345f:	39 cf                	cmp    %ecx,%edi
  803461:	77 65                	ja     8034c8 <__udivdi3+0x8c>
  803463:	89 fd                	mov    %edi,%ebp
  803465:	85 ff                	test   %edi,%edi
  803467:	75 0b                	jne    803474 <__udivdi3+0x38>
  803469:	b8 01 00 00 00       	mov    $0x1,%eax
  80346e:	31 d2                	xor    %edx,%edx
  803470:	f7 f7                	div    %edi
  803472:	89 c5                	mov    %eax,%ebp
  803474:	31 d2                	xor    %edx,%edx
  803476:	89 c8                	mov    %ecx,%eax
  803478:	f7 f5                	div    %ebp
  80347a:	89 c1                	mov    %eax,%ecx
  80347c:	89 d8                	mov    %ebx,%eax
  80347e:	f7 f5                	div    %ebp
  803480:	89 cf                	mov    %ecx,%edi
  803482:	89 fa                	mov    %edi,%edx
  803484:	83 c4 1c             	add    $0x1c,%esp
  803487:	5b                   	pop    %ebx
  803488:	5e                   	pop    %esi
  803489:	5f                   	pop    %edi
  80348a:	5d                   	pop    %ebp
  80348b:	c3                   	ret    
  80348c:	39 ce                	cmp    %ecx,%esi
  80348e:	77 28                	ja     8034b8 <__udivdi3+0x7c>
  803490:	0f bd fe             	bsr    %esi,%edi
  803493:	83 f7 1f             	xor    $0x1f,%edi
  803496:	75 40                	jne    8034d8 <__udivdi3+0x9c>
  803498:	39 ce                	cmp    %ecx,%esi
  80349a:	72 0a                	jb     8034a6 <__udivdi3+0x6a>
  80349c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034a0:	0f 87 9e 00 00 00    	ja     803544 <__udivdi3+0x108>
  8034a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ab:	89 fa                	mov    %edi,%edx
  8034ad:	83 c4 1c             	add    $0x1c,%esp
  8034b0:	5b                   	pop    %ebx
  8034b1:	5e                   	pop    %esi
  8034b2:	5f                   	pop    %edi
  8034b3:	5d                   	pop    %ebp
  8034b4:	c3                   	ret    
  8034b5:	8d 76 00             	lea    0x0(%esi),%esi
  8034b8:	31 ff                	xor    %edi,%edi
  8034ba:	31 c0                	xor    %eax,%eax
  8034bc:	89 fa                	mov    %edi,%edx
  8034be:	83 c4 1c             	add    $0x1c,%esp
  8034c1:	5b                   	pop    %ebx
  8034c2:	5e                   	pop    %esi
  8034c3:	5f                   	pop    %edi
  8034c4:	5d                   	pop    %ebp
  8034c5:	c3                   	ret    
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	89 d8                	mov    %ebx,%eax
  8034ca:	f7 f7                	div    %edi
  8034cc:	31 ff                	xor    %edi,%edi
  8034ce:	89 fa                	mov    %edi,%edx
  8034d0:	83 c4 1c             	add    $0x1c,%esp
  8034d3:	5b                   	pop    %ebx
  8034d4:	5e                   	pop    %esi
  8034d5:	5f                   	pop    %edi
  8034d6:	5d                   	pop    %ebp
  8034d7:	c3                   	ret    
  8034d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034dd:	89 eb                	mov    %ebp,%ebx
  8034df:	29 fb                	sub    %edi,%ebx
  8034e1:	89 f9                	mov    %edi,%ecx
  8034e3:	d3 e6                	shl    %cl,%esi
  8034e5:	89 c5                	mov    %eax,%ebp
  8034e7:	88 d9                	mov    %bl,%cl
  8034e9:	d3 ed                	shr    %cl,%ebp
  8034eb:	89 e9                	mov    %ebp,%ecx
  8034ed:	09 f1                	or     %esi,%ecx
  8034ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034f3:	89 f9                	mov    %edi,%ecx
  8034f5:	d3 e0                	shl    %cl,%eax
  8034f7:	89 c5                	mov    %eax,%ebp
  8034f9:	89 d6                	mov    %edx,%esi
  8034fb:	88 d9                	mov    %bl,%cl
  8034fd:	d3 ee                	shr    %cl,%esi
  8034ff:	89 f9                	mov    %edi,%ecx
  803501:	d3 e2                	shl    %cl,%edx
  803503:	8b 44 24 08          	mov    0x8(%esp),%eax
  803507:	88 d9                	mov    %bl,%cl
  803509:	d3 e8                	shr    %cl,%eax
  80350b:	09 c2                	or     %eax,%edx
  80350d:	89 d0                	mov    %edx,%eax
  80350f:	89 f2                	mov    %esi,%edx
  803511:	f7 74 24 0c          	divl   0xc(%esp)
  803515:	89 d6                	mov    %edx,%esi
  803517:	89 c3                	mov    %eax,%ebx
  803519:	f7 e5                	mul    %ebp
  80351b:	39 d6                	cmp    %edx,%esi
  80351d:	72 19                	jb     803538 <__udivdi3+0xfc>
  80351f:	74 0b                	je     80352c <__udivdi3+0xf0>
  803521:	89 d8                	mov    %ebx,%eax
  803523:	31 ff                	xor    %edi,%edi
  803525:	e9 58 ff ff ff       	jmp    803482 <__udivdi3+0x46>
  80352a:	66 90                	xchg   %ax,%ax
  80352c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803530:	89 f9                	mov    %edi,%ecx
  803532:	d3 e2                	shl    %cl,%edx
  803534:	39 c2                	cmp    %eax,%edx
  803536:	73 e9                	jae    803521 <__udivdi3+0xe5>
  803538:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80353b:	31 ff                	xor    %edi,%edi
  80353d:	e9 40 ff ff ff       	jmp    803482 <__udivdi3+0x46>
  803542:	66 90                	xchg   %ax,%ax
  803544:	31 c0                	xor    %eax,%eax
  803546:	e9 37 ff ff ff       	jmp    803482 <__udivdi3+0x46>
  80354b:	90                   	nop

0080354c <__umoddi3>:
  80354c:	55                   	push   %ebp
  80354d:	57                   	push   %edi
  80354e:	56                   	push   %esi
  80354f:	53                   	push   %ebx
  803550:	83 ec 1c             	sub    $0x1c,%esp
  803553:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803557:	8b 74 24 34          	mov    0x34(%esp),%esi
  80355b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80355f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803563:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803567:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80356b:	89 f3                	mov    %esi,%ebx
  80356d:	89 fa                	mov    %edi,%edx
  80356f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803573:	89 34 24             	mov    %esi,(%esp)
  803576:	85 c0                	test   %eax,%eax
  803578:	75 1a                	jne    803594 <__umoddi3+0x48>
  80357a:	39 f7                	cmp    %esi,%edi
  80357c:	0f 86 a2 00 00 00    	jbe    803624 <__umoddi3+0xd8>
  803582:	89 c8                	mov    %ecx,%eax
  803584:	89 f2                	mov    %esi,%edx
  803586:	f7 f7                	div    %edi
  803588:	89 d0                	mov    %edx,%eax
  80358a:	31 d2                	xor    %edx,%edx
  80358c:	83 c4 1c             	add    $0x1c,%esp
  80358f:	5b                   	pop    %ebx
  803590:	5e                   	pop    %esi
  803591:	5f                   	pop    %edi
  803592:	5d                   	pop    %ebp
  803593:	c3                   	ret    
  803594:	39 f0                	cmp    %esi,%eax
  803596:	0f 87 ac 00 00 00    	ja     803648 <__umoddi3+0xfc>
  80359c:	0f bd e8             	bsr    %eax,%ebp
  80359f:	83 f5 1f             	xor    $0x1f,%ebp
  8035a2:	0f 84 ac 00 00 00    	je     803654 <__umoddi3+0x108>
  8035a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8035ad:	29 ef                	sub    %ebp,%edi
  8035af:	89 fe                	mov    %edi,%esi
  8035b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035b5:	89 e9                	mov    %ebp,%ecx
  8035b7:	d3 e0                	shl    %cl,%eax
  8035b9:	89 d7                	mov    %edx,%edi
  8035bb:	89 f1                	mov    %esi,%ecx
  8035bd:	d3 ef                	shr    %cl,%edi
  8035bf:	09 c7                	or     %eax,%edi
  8035c1:	89 e9                	mov    %ebp,%ecx
  8035c3:	d3 e2                	shl    %cl,%edx
  8035c5:	89 14 24             	mov    %edx,(%esp)
  8035c8:	89 d8                	mov    %ebx,%eax
  8035ca:	d3 e0                	shl    %cl,%eax
  8035cc:	89 c2                	mov    %eax,%edx
  8035ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d2:	d3 e0                	shl    %cl,%eax
  8035d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035dc:	89 f1                	mov    %esi,%ecx
  8035de:	d3 e8                	shr    %cl,%eax
  8035e0:	09 d0                	or     %edx,%eax
  8035e2:	d3 eb                	shr    %cl,%ebx
  8035e4:	89 da                	mov    %ebx,%edx
  8035e6:	f7 f7                	div    %edi
  8035e8:	89 d3                	mov    %edx,%ebx
  8035ea:	f7 24 24             	mull   (%esp)
  8035ed:	89 c6                	mov    %eax,%esi
  8035ef:	89 d1                	mov    %edx,%ecx
  8035f1:	39 d3                	cmp    %edx,%ebx
  8035f3:	0f 82 87 00 00 00    	jb     803680 <__umoddi3+0x134>
  8035f9:	0f 84 91 00 00 00    	je     803690 <__umoddi3+0x144>
  8035ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803603:	29 f2                	sub    %esi,%edx
  803605:	19 cb                	sbb    %ecx,%ebx
  803607:	89 d8                	mov    %ebx,%eax
  803609:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80360d:	d3 e0                	shl    %cl,%eax
  80360f:	89 e9                	mov    %ebp,%ecx
  803611:	d3 ea                	shr    %cl,%edx
  803613:	09 d0                	or     %edx,%eax
  803615:	89 e9                	mov    %ebp,%ecx
  803617:	d3 eb                	shr    %cl,%ebx
  803619:	89 da                	mov    %ebx,%edx
  80361b:	83 c4 1c             	add    $0x1c,%esp
  80361e:	5b                   	pop    %ebx
  80361f:	5e                   	pop    %esi
  803620:	5f                   	pop    %edi
  803621:	5d                   	pop    %ebp
  803622:	c3                   	ret    
  803623:	90                   	nop
  803624:	89 fd                	mov    %edi,%ebp
  803626:	85 ff                	test   %edi,%edi
  803628:	75 0b                	jne    803635 <__umoddi3+0xe9>
  80362a:	b8 01 00 00 00       	mov    $0x1,%eax
  80362f:	31 d2                	xor    %edx,%edx
  803631:	f7 f7                	div    %edi
  803633:	89 c5                	mov    %eax,%ebp
  803635:	89 f0                	mov    %esi,%eax
  803637:	31 d2                	xor    %edx,%edx
  803639:	f7 f5                	div    %ebp
  80363b:	89 c8                	mov    %ecx,%eax
  80363d:	f7 f5                	div    %ebp
  80363f:	89 d0                	mov    %edx,%eax
  803641:	e9 44 ff ff ff       	jmp    80358a <__umoddi3+0x3e>
  803646:	66 90                	xchg   %ax,%ax
  803648:	89 c8                	mov    %ecx,%eax
  80364a:	89 f2                	mov    %esi,%edx
  80364c:	83 c4 1c             	add    $0x1c,%esp
  80364f:	5b                   	pop    %ebx
  803650:	5e                   	pop    %esi
  803651:	5f                   	pop    %edi
  803652:	5d                   	pop    %ebp
  803653:	c3                   	ret    
  803654:	3b 04 24             	cmp    (%esp),%eax
  803657:	72 06                	jb     80365f <__umoddi3+0x113>
  803659:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80365d:	77 0f                	ja     80366e <__umoddi3+0x122>
  80365f:	89 f2                	mov    %esi,%edx
  803661:	29 f9                	sub    %edi,%ecx
  803663:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803667:	89 14 24             	mov    %edx,(%esp)
  80366a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80366e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803672:	8b 14 24             	mov    (%esp),%edx
  803675:	83 c4 1c             	add    $0x1c,%esp
  803678:	5b                   	pop    %ebx
  803679:	5e                   	pop    %esi
  80367a:	5f                   	pop    %edi
  80367b:	5d                   	pop    %ebp
  80367c:	c3                   	ret    
  80367d:	8d 76 00             	lea    0x0(%esi),%esi
  803680:	2b 04 24             	sub    (%esp),%eax
  803683:	19 fa                	sbb    %edi,%edx
  803685:	89 d1                	mov    %edx,%ecx
  803687:	89 c6                	mov    %eax,%esi
  803689:	e9 71 ff ff ff       	jmp    8035ff <__umoddi3+0xb3>
  80368e:	66 90                	xchg   %ax,%ax
  803690:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803694:	72 ea                	jb     803680 <__umoddi3+0x134>
  803696:	89 d9                	mov    %ebx,%ecx
  803698:	e9 62 ff ff ff       	jmp    8035ff <__umoddi3+0xb3>
