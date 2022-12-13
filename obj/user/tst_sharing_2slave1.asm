
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 2b 02 00 00       	call   800261 <libmain>
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
  800099:	e8 ff 02 00 00       	call   80039d <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 31 15 00 00       	call   8015d9 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 f7 1a 00 00       	call   801ba7 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 e3 18 00 00       	call   80199b <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 f1 17 00 00       	call   8018ae <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 17 37 80 00       	push   $0x803717
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 3a 16 00 00       	call   80170a <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 1c 37 80 00       	push   $0x80371c
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 fc 36 80 00       	push   $0x8036fc
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 b3 17 00 00       	call   8018ae <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 7c 37 80 00       	push   $0x80377c
  80010c:	6a 21                	push   $0x21
  80010e:	68 fc 36 80 00       	push   $0x8036fc
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 98 18 00 00       	call   8019b5 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 79 18 00 00       	call   80199b <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 87 17 00 00       	call   8018ae <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 0d 38 80 00       	push   $0x80380d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 d0 15 00 00       	call   80170a <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 1c 37 80 00       	push   $0x80371c
  800151:	6a 27                	push   $0x27
  800153:	68 fc 36 80 00       	push   $0x8036fc
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 4c 17 00 00       	call   8018ae <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 7c 37 80 00       	push   $0x80377c
  800173:	6a 28                	push   $0x28
  800175:	68 fc 36 80 00       	push   $0x8036fc
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 31 18 00 00       	call   8019b5 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 10 38 80 00       	push   $0x803810
  800196:	6a 2b                	push   $0x2b
  800198:	68 fc 36 80 00       	push   $0x8036fc
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 f4 17 00 00       	call   80199b <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 02 17 00 00       	call   8018ae <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 47 38 80 00       	push   $0x803847
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 4b 15 00 00       	call   80170a <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 1c 37 80 00       	push   $0x80371c
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 fc 36 80 00       	push   $0x8036fc
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 c7 16 00 00       	call   8018ae <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 7c 37 80 00       	push   $0x80377c
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 fc 36 80 00       	push   $0x8036fc
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 ac 17 00 00       	call   8019b5 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 10 38 80 00       	push   $0x803810
  80021b:	6a 34                	push   $0x34
  80021d:	68 fc 36 80 00       	push   $0x8036fc
  800222:	e8 76 01 00 00       	call   80039d <_panic>

	*z = *x + *y ;
  800227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022a:	8b 10                	mov    (%eax),%edx
  80022c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	01 c2                	add    %eax,%edx
  800233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800236:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	83 f8 1e             	cmp    $0x1e,%eax
  800240:	74 14                	je     800256 <_main+0x21e>
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 10 38 80 00       	push   $0x803810
  80024a:	6a 37                	push   $0x37
  80024c:	68 fc 36 80 00       	push   $0x8036fc
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 71 1a 00 00       	call   801ccc <inctst>

	return;
  80025b:	90                   	nop
}
  80025c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800267:	e8 22 19 00 00       	call   801b8e <sys_getenvindex>
  80026c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80026f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800272:	89 d0                	mov    %edx,%eax
  800274:	c1 e0 03             	shl    $0x3,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	01 c0                	add    %eax,%eax
  80027b:	01 d0                	add    %edx,%eax
  80027d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800284:	01 d0                	add    %edx,%eax
  800286:	c1 e0 04             	shl    $0x4,%eax
  800289:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800293:	a1 20 50 80 00       	mov    0x805020,%eax
  800298:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80029e:	84 c0                	test   %al,%al
  8002a0:	74 0f                	je     8002b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8002ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b5:	7e 0a                	jle    8002c1 <libmain+0x60>
		binaryname = argv[0];
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 0c             	pushl  0xc(%ebp)
  8002c7:	ff 75 08             	pushl  0x8(%ebp)
  8002ca:	e8 69 fd ff ff       	call   800038 <_main>
  8002cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d2:	e8 c4 16 00 00       	call   80199b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 64 38 80 00       	push   $0x803864
  8002df:	e8 6d 03 00 00       	call   800651 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	68 8c 38 80 00       	push   $0x80388c
  800307:	e8 45 03 00 00       	call   800651 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80030f:	a1 20 50 80 00       	mov    0x805020,%eax
  800314:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80031a:	a1 20 50 80 00       	mov    0x805020,%eax
  80031f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800325:	a1 20 50 80 00       	mov    0x805020,%eax
  80032a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800330:	51                   	push   %ecx
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	68 b4 38 80 00       	push   $0x8038b4
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 50 80 00       	mov    0x805020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 0c 39 80 00       	push   $0x80390c
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 64 38 80 00       	push   $0x803864
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 44 16 00 00       	call   8019b5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800371:	e8 19 00 00 00       	call   80038f <exit>
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	6a 00                	push   $0x0
  800384:	e8 d1 17 00 00       	call   801b5a <sys_destroy_env>
  800389:	83 c4 10             	add    $0x10,%esp
}
  80038c:	90                   	nop
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <exit>:

void
exit(void)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800395:	e8 26 18 00 00       	call   801bc0 <sys_exit_env>
}
  80039a:	90                   	nop
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003ac:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	74 16                	je     8003cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	50                   	push   %eax
  8003be:	68 20 39 80 00       	push   $0x803920
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 25 39 80 00       	push   $0x803925
  8003dc:	e8 70 02 00 00       	call   800651 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ed:	50                   	push   %eax
  8003ee:	e8 f3 01 00 00       	call   8005e6 <vcprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	6a 00                	push   $0x0
  8003fb:	68 41 39 80 00       	push   $0x803941
  800400:	e8 e1 01 00 00       	call   8005e6 <vcprintf>
  800405:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800408:	e8 82 ff ff ff       	call   80038f <exit>

	// should not return here
	while (1) ;
  80040d:	eb fe                	jmp    80040d <_panic+0x70>

0080040f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800415:	a1 20 50 80 00       	mov    0x805020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 44 39 80 00       	push   $0x803944
  80042c:	6a 26                	push   $0x26
  80042e:	68 90 39 80 00       	push   $0x803990
  800433:	e8 65 ff ff ff       	call   80039d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80043f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800446:	e9 c2 00 00 00       	jmp    80050d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80044b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	85 c0                	test   %eax,%eax
  80045e:	75 08                	jne    800468 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800460:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800463:	e9 a2 00 00 00       	jmp    80050a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800476:	eb 69                	jmp    8004e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800478:	a1 20 50 80 00       	mov    0x805020,%eax
  80047d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800483:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800486:	89 d0                	mov    %edx,%eax
  800488:	01 c0                	add    %eax,%eax
  80048a:	01 d0                	add    %edx,%eax
  80048c:	c1 e0 03             	shl    $0x3,%eax
  80048f:	01 c8                	add    %ecx,%eax
  800491:	8a 40 04             	mov    0x4(%eax),%al
  800494:	84 c0                	test   %al,%al
  800496:	75 46                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800498:	a1 20 50 80 00       	mov    0x805020,%eax
  80049d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a6:	89 d0                	mov    %edx,%eax
  8004a8:	01 c0                	add    %eax,%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	c1 e0 03             	shl    $0x3,%eax
  8004af:	01 c8                	add    %ecx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	75 09                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004dc:	eb 12                	jmp    8004f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004de:	ff 45 e8             	incl   -0x18(%ebp)
  8004e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e6:	8b 50 74             	mov    0x74(%eax),%edx
  8004e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	77 88                	ja     800478 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004f4:	75 14                	jne    80050a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 9c 39 80 00       	push   $0x80399c
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 90 39 80 00       	push   $0x803990
  800505:	e8 93 fe ff ff       	call   80039d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80050a:	ff 45 f0             	incl   -0x10(%ebp)
  80050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800510:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800513:	0f 8c 32 ff ff ff    	jl     80044b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800519:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800520:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800527:	eb 26                	jmp    80054f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800529:	a1 20 50 80 00       	mov    0x805020,%eax
  80052e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	01 c0                	add    %eax,%eax
  80053b:	01 d0                	add    %edx,%eax
  80053d:	c1 e0 03             	shl    $0x3,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	8a 40 04             	mov    0x4(%eax),%al
  800545:	3c 01                	cmp    $0x1,%al
  800547:	75 03                	jne    80054c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800549:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054c:	ff 45 e0             	incl   -0x20(%ebp)
  80054f:	a1 20 50 80 00       	mov    0x805020,%eax
  800554:	8b 50 74             	mov    0x74(%eax),%edx
  800557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055a:	39 c2                	cmp    %eax,%edx
  80055c:	77 cb                	ja     800529 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800561:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800564:	74 14                	je     80057a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800566:	83 ec 04             	sub    $0x4,%esp
  800569:	68 f0 39 80 00       	push   $0x8039f0
  80056e:	6a 44                	push   $0x44
  800570:	68 90 39 80 00       	push   $0x803990
  800575:	e8 23 fe ff ff       	call   80039d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80057a:	90                   	nop
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	8d 48 01             	lea    0x1(%eax),%ecx
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	89 0a                	mov    %ecx,(%edx)
  800590:	8b 55 08             	mov    0x8(%ebp),%edx
  800593:	88 d1                	mov    %dl,%cl
  800595:	8b 55 0c             	mov    0xc(%ebp),%edx
  800598:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a6:	75 2c                	jne    8005d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005a8:	a0 24 50 80 00       	mov    0x805024,%al
  8005ad:	0f b6 c0             	movzbl %al,%eax
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	8b 12                	mov    (%edx),%edx
  8005b5:	89 d1                	mov    %edx,%ecx
  8005b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ba:	83 c2 08             	add    $0x8,%edx
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	50                   	push   %eax
  8005c1:	51                   	push   %ecx
  8005c2:	52                   	push   %edx
  8005c3:	e8 25 12 00 00       	call   8017ed <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d7:	8b 40 04             	mov    0x4(%eax),%eax
  8005da:	8d 50 01             	lea    0x1(%eax),%edx
  8005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e3:	90                   	nop
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f6:	00 00 00 
	b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800600:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060f:	50                   	push   %eax
  800610:	68 7d 05 80 00       	push   $0x80057d
  800615:	e8 11 02 00 00       	call   80082b <vprintfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80061d:	a0 24 50 80 00       	mov    0x805024,%al
  800622:	0f b6 c0             	movzbl %al,%eax
  800625:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80062b:	83 ec 04             	sub    $0x4,%esp
  80062e:	50                   	push   %eax
  80062f:	52                   	push   %edx
  800630:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800636:	83 c0 08             	add    $0x8,%eax
  800639:	50                   	push   %eax
  80063a:	e8 ae 11 00 00       	call   8017ed <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800642:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800649:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <cprintf>:

int cprintf(const char *fmt, ...) {
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800657:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80065e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 f4             	pushl  -0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	e8 73 ff ff ff       	call   8005e6 <vcprintf>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800684:	e8 12 13 00 00       	call   80199b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800689:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 f4             	pushl  -0xc(%ebp)
  800698:	50                   	push   %eax
  800699:	e8 48 ff ff ff       	call   8005e6 <vcprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006a4:	e8 0c 13 00 00       	call   8019b5 <sys_enable_interrupt>
	return cnt;
  8006a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 14             	sub    $0x14,%esp
  8006b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006cc:	77 55                	ja     800723 <printnum+0x75>
  8006ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d1:	72 05                	jb     8006d8 <printnum+0x2a>
  8006d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006d6:	77 4b                	ja     800723 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006de:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ee:	e8 7d 2d 00 00       	call   803470 <__udivdi3>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	53                   	push   %ebx
  8006fd:	ff 75 18             	pushl  0x18(%ebp)
  800700:	52                   	push   %edx
  800701:	50                   	push   %eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	e8 a1 ff ff ff       	call   8006ae <printnum>
  80070d:	83 c4 20             	add    $0x20,%esp
  800710:	eb 1a                	jmp    80072c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 20             	pushl  0x20(%ebp)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	ff d0                	call   *%eax
  800720:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800723:	ff 4d 1c             	decl   0x1c(%ebp)
  800726:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80072a:	7f e6                	jg     800712 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80072c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80072f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	53                   	push   %ebx
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	e8 3d 2e 00 00       	call   803580 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 54 3c 80 00       	add    $0x803c54,%eax
  80074b:	8a 00                	mov    (%eax),%al
  80074d:	0f be c0             	movsbl %al,%eax
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	50                   	push   %eax
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
}
  80075f:	90                   	nop
  800760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800768:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076c:	7e 1c                	jle    80078a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	8d 50 08             	lea    0x8(%eax),%edx
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	89 10                	mov    %edx,(%eax)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	83 e8 08             	sub    $0x8,%eax
  800783:	8b 50 04             	mov    0x4(%eax),%edx
  800786:	8b 00                	mov    (%eax),%eax
  800788:	eb 40                	jmp    8007ca <getuint+0x65>
	else if (lflag)
  80078a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078e:	74 1e                	je     8007ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	8d 50 04             	lea    0x4(%eax),%edx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	89 10                	mov    %edx,(%eax)
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	83 e8 04             	sub    $0x4,%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	eb 1c                	jmp    8007ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d3:	7e 1c                	jle    8007f1 <getint+0x25>
		return va_arg(*ap, long long);
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	8d 50 08             	lea    0x8(%eax),%edx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	89 10                	mov    %edx,(%eax)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	83 e8 08             	sub    $0x8,%eax
  8007ea:	8b 50 04             	mov    0x4(%eax),%edx
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	eb 38                	jmp    800829 <getint+0x5d>
	else if (lflag)
  8007f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f5:	74 1a                	je     800811 <getint+0x45>
		return va_arg(*ap, long);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	8d 50 04             	lea    0x4(%eax),%edx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 10                	mov    %edx,(%eax)
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	83 e8 04             	sub    $0x4,%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	99                   	cltd   
  80080f:	eb 18                	jmp    800829 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	99                   	cltd   
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	56                   	push   %esi
  80082f:	53                   	push   %ebx
  800830:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800833:	eb 17                	jmp    80084c <vprintfmt+0x21>
			if (ch == '\0')
  800835:	85 db                	test   %ebx,%ebx
  800837:	0f 84 af 03 00 00    	je     800bec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	83 fb 25             	cmp    $0x25,%ebx
  80085d:	75 d6                	jne    800835 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800863:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80086a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800871:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800878:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	89 55 10             	mov    %edx,0x10(%ebp)
  800888:	8a 00                	mov    (%eax),%al
  80088a:	0f b6 d8             	movzbl %al,%ebx
  80088d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800890:	83 f8 55             	cmp    $0x55,%eax
  800893:	0f 87 2b 03 00 00    	ja     800bc4 <vprintfmt+0x399>
  800899:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
  8008a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008a6:	eb d7                	jmp    80087f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ac:	eb d1                	jmp    80087f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	c1 e0 02             	shl    $0x2,%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	01 c0                	add    %eax,%eax
  8008c1:	01 d8                	add    %ebx,%eax
  8008c3:	83 e8 30             	sub    $0x30,%eax
  8008c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	8a 00                	mov    (%eax),%al
  8008ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d4:	7e 3e                	jle    800914 <vprintfmt+0xe9>
  8008d6:	83 fb 39             	cmp    $0x39,%ebx
  8008d9:	7f 39                	jg     800914 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008de:	eb d5                	jmp    8008b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 c0 04             	add    $0x4,%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f4:	eb 1f                	jmp    800915 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	79 83                	jns    80087f <vprintfmt+0x54>
				width = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800903:	e9 77 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800908:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80090f:	e9 6b ff ff ff       	jmp    80087f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800914:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800919:	0f 89 60 ff ff ff    	jns    80087f <vprintfmt+0x54>
				width = precision, precision = -1;
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800925:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80092c:	e9 4e ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800931:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800934:	e9 46 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	50                   	push   %eax
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			break;
  800959:	e9 89 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 c0 04             	add    $0x4,%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	83 e8 04             	sub    $0x4,%eax
  80096d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80096f:	85 db                	test   %ebx,%ebx
  800971:	79 02                	jns    800975 <vprintfmt+0x14a>
				err = -err;
  800973:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800975:	83 fb 64             	cmp    $0x64,%ebx
  800978:	7f 0b                	jg     800985 <vprintfmt+0x15a>
  80097a:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 65 3c 80 00       	push   $0x803c65
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 5e 02 00 00       	call   800bf4 <printfmt>
  800996:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800999:	e9 49 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80099e:	56                   	push   %esi
  80099f:	68 6e 3c 80 00       	push   $0x803c6e
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 45 02 00 00       	call   800bf4 <printfmt>
  8009af:	83 c4 10             	add    $0x10,%esp
			break;
  8009b2:	e9 30 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	83 c0 04             	add    $0x4,%eax
  8009bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 30                	mov    (%eax),%esi
  8009c8:	85 f6                	test   %esi,%esi
  8009ca:	75 05                	jne    8009d1 <vprintfmt+0x1a6>
				p = "(null)";
  8009cc:	be 71 3c 80 00       	mov    $0x803c71,%esi
			if (width > 0 && padc != '-')
  8009d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d5:	7e 6d                	jle    800a44 <vprintfmt+0x219>
  8009d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009db:	74 67                	je     800a44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	50                   	push   %eax
  8009e4:	56                   	push   %esi
  8009e5:	e8 0c 03 00 00       	call   800cf6 <strnlen>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f0:	eb 16                	jmp    800a08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a05:	ff 4d e4             	decl   -0x1c(%ebp)
  800a08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0c:	7f e4                	jg     8009f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	eb 34                	jmp    800a44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a14:	74 1c                	je     800a32 <vprintfmt+0x207>
  800a16:	83 fb 1f             	cmp    $0x1f,%ebx
  800a19:	7e 05                	jle    800a20 <vprintfmt+0x1f5>
  800a1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a1e:	7e 12                	jle    800a32 <vprintfmt+0x207>
					putch('?', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 3f                	push   $0x3f
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	eb 0f                	jmp    800a41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	53                   	push   %ebx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a41:	ff 4d e4             	decl   -0x1c(%ebp)
  800a44:	89 f0                	mov    %esi,%eax
  800a46:	8d 70 01             	lea    0x1(%eax),%esi
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	0f be d8             	movsbl %al,%ebx
  800a4e:	85 db                	test   %ebx,%ebx
  800a50:	74 24                	je     800a76 <vprintfmt+0x24b>
  800a52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a56:	78 b8                	js     800a10 <vprintfmt+0x1e5>
  800a58:	ff 4d e0             	decl   -0x20(%ebp)
  800a5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5f:	79 af                	jns    800a10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	eb 13                	jmp    800a76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	6a 20                	push   $0x20
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7a:	7f e7                	jg     800a63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a7c:	e9 66 01 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 e8             	pushl  -0x18(%ebp)
  800a87:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8a:	50                   	push   %eax
  800a8b:	e8 3c fd ff ff       	call   8007cc <getint>
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9f:	85 d2                	test   %edx,%edx
  800aa1:	79 23                	jns    800ac6 <vprintfmt+0x29b>
				putch('-', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 2d                	push   $0x2d
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab9:	f7 d8                	neg    %eax
  800abb:	83 d2 00             	adc    $0x0,%edx
  800abe:	f7 da                	neg    %edx
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ac6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800acd:	e9 bc 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad8:	8d 45 14             	lea    0x14(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 84 fc ff ff       	call   800765 <getuint>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af1:	e9 98 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 58                	push   $0x58
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 58                	push   $0x58
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 58                	push   $0x58
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			break;
  800b26:	e9 bc 00 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 30                	push   $0x30
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 78                	push   $0x78
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b6d:	eb 1f                	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 e8             	pushl  -0x18(%ebp)
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	e8 e7 fb ff ff       	call   800765 <getuint>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	52                   	push   %edx
  800b99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b9c:	50                   	push   %eax
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 00 fb ff ff       	call   8006ae <printnum>
  800bae:	83 c4 20             	add    $0x20,%esp
			break;
  800bb1:	eb 34                	jmp    800be7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			break;
  800bc2:	eb 23                	jmp    800be7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 25                	push   $0x25
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd4:	ff 4d 10             	decl   0x10(%ebp)
  800bd7:	eb 03                	jmp    800bdc <vprintfmt+0x3b1>
  800bd9:	ff 4d 10             	decl   0x10(%ebp)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	48                   	dec    %eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	3c 25                	cmp    $0x25,%al
  800be4:	75 f3                	jne    800bd9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800be6:	90                   	nop
		}
	}
  800be7:	e9 47 fc ff ff       	jmp    800833 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	ff 75 f4             	pushl  -0xc(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 16 fc ff ff       	call   80082b <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c18:	90                   	nop
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 40 08             	mov    0x8(%eax),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 10                	mov    (%eax),%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8b 40 04             	mov    0x4(%eax),%eax
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	73 12                	jae    800c4e <sprintputch+0x33>
		*b->buf++ = ch;
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	8d 48 01             	lea    0x1(%eax),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 0a                	mov    %ecx,(%edx)
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	88 10                	mov    %dl,(%eax)
}
  800c4e:	90                   	nop
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	01 d0                	add    %edx,%eax
  800c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c76:	74 06                	je     800c7e <vsnprintf+0x2d>
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	7f 07                	jg     800c85 <vsnprintf+0x34>
		return -E_INVAL;
  800c7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c83:	eb 20                	jmp    800ca5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c85:	ff 75 14             	pushl  0x14(%ebp)
  800c88:	ff 75 10             	pushl  0x10(%ebp)
  800c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	68 1b 0c 80 00       	push   $0x800c1b
  800c94:	e8 92 fb ff ff       	call   80082b <vprintfmt>
  800c99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cad:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb0:	83 c0 04             	add    $0x4,%eax
  800cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 89 ff ff ff       	call   800c51 <vsnprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 06                	jmp    800ce8 <strlen+0x15>
		n++;
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 f1                	jne    800ce2 <strlen+0xf>
		n++;
	return n;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d03:	eb 09                	jmp    800d0e <strnlen+0x18>
		n++;
  800d05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d08:	ff 45 08             	incl   0x8(%ebp)
  800d0b:	ff 4d 0c             	decl   0xc(%ebp)
  800d0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d12:	74 09                	je     800d1d <strnlen+0x27>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	75 e8                	jne    800d05 <strnlen+0xf>
		n++;
	return n;
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d2e:	90                   	nop
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 08             	mov    %edx,0x8(%ebp)
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 e4                	jne    800d2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d63:	eb 1f                	jmp    800d84 <strncpy+0x34>
		*dst++ = *src;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 03                	je     800d81 <strncpy+0x31>
			src++;
  800d7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d81:	ff 45 fc             	incl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8a:	72 d9                	jb     800d65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 30                	je     800dd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da3:	eb 16                	jmp    800dbb <strlcpy+0x2a>
			*dst++ = *src++;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 08             	mov    %edx,0x8(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dbb:	ff 4d 10             	decl   0x10(%ebp)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	74 09                	je     800dcd <strlcpy+0x3c>
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 d8                	jne    800da5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de2:	eb 06                	jmp    800dea <strcmp+0xb>
		p++, q++;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 0e                	je     800e01 <strcmp+0x22>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 10                	mov    (%eax),%dl
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	38 c2                	cmp    %al,%dl
  800dff:	74 e3                	je     800de4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	0f b6 d0             	movzbl %al,%edx
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	0f b6 c0             	movzbl %al,%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e1a:	eb 09                	jmp    800e25 <strncmp+0xe>
		n--, p++, q++;
  800e1c:	ff 4d 10             	decl   0x10(%ebp)
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 17                	je     800e42 <strncmp+0x2b>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	74 0e                	je     800e42 <strncmp+0x2b>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 10                	mov    (%eax),%dl
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	38 c2                	cmp    %al,%dl
  800e40:	74 da                	je     800e1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strncmp+0x38>
		return 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	eb 14                	jmp    800e63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f b6 d0             	movzbl %al,%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 c0             	movzbl %al,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
}
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e71:	eb 12                	jmp    800e85 <strchr+0x20>
		if (*s == c)
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7b:	75 05                	jne    800e82 <strchr+0x1d>
			return (char *) s;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	eb 11                	jmp    800e93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e5                	jne    800e73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea1:	eb 0d                	jmp    800eb0 <strfind+0x1b>
		if (*s == c)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eab:	74 0e                	je     800ebb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ead:	ff 45 08             	incl   0x8(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 ea                	jne    800ea3 <strfind+0xe>
  800eb9:	eb 01                	jmp    800ebc <strfind+0x27>
		if (*s == c)
			break;
  800ebb:	90                   	nop
	return (char *) s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ed3:	eb 0e                	jmp    800ee3 <memset+0x22>
		*p++ = c;
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ee3:	ff 4d f8             	decl   -0x8(%ebp)
  800ee6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eea:	79 e9                	jns    800ed5 <memset+0x14>
		*p++ = c;

	return v;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f03:	eb 16                	jmp    800f1b <memcpy+0x2a>
		*d++ = *s++;
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f17:	8a 12                	mov    (%edx),%dl
  800f19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 dd                	jne    800f05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	73 50                	jae    800f97 <memmove+0x6a>
  800f47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f52:	76 43                	jbe    800f97 <memmove+0x6a>
		s += n;
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f60:	eb 10                	jmp    800f72 <memmove+0x45>
			*--d = *--s;
  800f62:	ff 4d f8             	decl   -0x8(%ebp)
  800f65:	ff 4d fc             	decl   -0x4(%ebp)
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6b:	8a 10                	mov    (%eax),%dl
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 e3                	jne    800f62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f7f:	eb 23                	jmp    800fa4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f84:	8d 50 01             	lea    0x1(%eax),%edx
  800f87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f93:	8a 12                	mov    (%edx),%dl
  800f95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 dd                	jne    800f81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fbb:	eb 2a                	jmp    800fe7 <memcmp+0x3e>
		if (*s1 != *s2)
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc0:	8a 10                	mov    (%eax),%dl
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	38 c2                	cmp    %al,%dl
  800fc9:	74 16                	je     800fe1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 d0             	movzbl %al,%edx
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	eb 18                	jmp    800ff9 <memcmp+0x50>
		s1++, s2++;
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 c9                	jne    800fbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80100c:	eb 15                	jmp    801023 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f b6 d0             	movzbl %al,%edx
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	0f b6 c0             	movzbl %al,%eax
  80101c:	39 c2                	cmp    %eax,%edx
  80101e:	74 0d                	je     80102d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801029:	72 e3                	jb     80100e <memfind+0x13>
  80102b:	eb 01                	jmp    80102e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80102d:	90                   	nop
	return (void *) s;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801040:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801047:	eb 03                	jmp    80104c <strtol+0x19>
		s++;
  801049:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	3c 20                	cmp    $0x20,%al
  801053:	74 f4                	je     801049 <strtol+0x16>
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	3c 09                	cmp    $0x9,%al
  80105c:	74 eb                	je     801049 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 2b                	cmp    $0x2b,%al
  801065:	75 05                	jne    80106c <strtol+0x39>
		s++;
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	eb 13                	jmp    80107f <strtol+0x4c>
	else if (*s == '-')
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 2d                	cmp    $0x2d,%al
  801073:	75 0a                	jne    80107f <strtol+0x4c>
		s++, neg = 1;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80107f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801083:	74 06                	je     80108b <strtol+0x58>
  801085:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801089:	75 20                	jne    8010ab <strtol+0x78>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 30                	cmp    $0x30,%al
  801092:	75 17                	jne    8010ab <strtol+0x78>
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	40                   	inc    %eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 78                	cmp    $0x78,%al
  80109c:	75 0d                	jne    8010ab <strtol+0x78>
		s += 2, base = 16;
  80109e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010a2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010a9:	eb 28                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010af:	75 15                	jne    8010c6 <strtol+0x93>
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 30                	cmp    $0x30,%al
  8010b8:	75 0c                	jne    8010c6 <strtol+0x93>
		s++, base = 8;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010c4:	eb 0d                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0)
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	75 07                	jne    8010d3 <strtol+0xa0>
		base = 10;
  8010cc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2f                	cmp    $0x2f,%al
  8010da:	7e 19                	jle    8010f5 <strtol+0xc2>
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 39                	cmp    $0x39,%al
  8010e3:	7f 10                	jg     8010f5 <strtol+0xc2>
			dig = *s - '0';
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	0f be c0             	movsbl %al,%eax
  8010ed:	83 e8 30             	sub    $0x30,%eax
  8010f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f3:	eb 42                	jmp    801137 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 60                	cmp    $0x60,%al
  8010fc:	7e 19                	jle    801117 <strtol+0xe4>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 7a                	cmp    $0x7a,%al
  801105:	7f 10                	jg     801117 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f be c0             	movsbl %al,%eax
  80110f:	83 e8 57             	sub    $0x57,%eax
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801115:	eb 20                	jmp    801137 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 40                	cmp    $0x40,%al
  80111e:	7e 39                	jle    801159 <strtol+0x126>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 5a                	cmp    $0x5a,%al
  801127:	7f 30                	jg     801159 <strtol+0x126>
			dig = *s - 'A' + 10;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f be c0             	movsbl %al,%eax
  801131:	83 e8 37             	sub    $0x37,%eax
  801134:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80113d:	7d 19                	jge    801158 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80113f:	ff 45 08             	incl   0x8(%ebp)
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	0f af 45 10          	imul   0x10(%ebp),%eax
  801149:	89 c2                	mov    %eax,%edx
  80114b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801153:	e9 7b ff ff ff       	jmp    8010d3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801158:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801159:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115d:	74 08                	je     801167 <strtol+0x134>
		*endptr = (char *) s;
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8b 55 08             	mov    0x8(%ebp),%edx
  801165:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801167:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80116b:	74 07                	je     801174 <strtol+0x141>
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	f7 d8                	neg    %eax
  801172:	eb 03                	jmp    801177 <strtol+0x144>
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <ltostr>:

void
ltostr(long value, char *str)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80118d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801191:	79 13                	jns    8011a6 <ltostr+0x2d>
	{
		neg = 1;
  801193:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ae:	99                   	cltd   
  8011af:	f7 f9                	idiv   %ecx
  8011b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011c7:	83 c2 30             	add    $0x30,%edx
  8011ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011d4:	f7 e9                	imul   %ecx
  8011d6:	c1 fa 02             	sar    $0x2,%edx
  8011d9:	89 c8                	mov    %ecx,%eax
  8011db:	c1 f8 1f             	sar    $0x1f,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ed:	f7 e9                	imul   %ecx
  8011ef:	c1 fa 02             	sar    $0x2,%edx
  8011f2:	89 c8                	mov    %ecx,%eax
  8011f4:	c1 f8 1f             	sar    $0x1f,%eax
  8011f7:	29 c2                	sub    %eax,%edx
  8011f9:	89 d0                	mov    %edx,%eax
  8011fb:	c1 e0 02             	shl    $0x2,%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	01 c0                	add    %eax,%eax
  801202:	29 c1                	sub    %eax,%ecx
  801204:	89 ca                	mov    %ecx,%edx
  801206:	85 d2                	test   %edx,%edx
  801208:	75 9c                	jne    8011a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80120a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	48                   	dec    %eax
  801215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121c:	74 3d                	je     80125b <ltostr+0xe2>
		start = 1 ;
  80121e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801225:	eb 34                	jmp    80125b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 c2                	add    %eax,%edx
  80123c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 c8                	add    %ecx,%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8a 45 eb             	mov    -0x15(%ebp),%al
  801253:	88 02                	mov    %al,(%edx)
		start++ ;
  801255:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801258:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801261:	7c c4                	jl     801227 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801263:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80126e:	90                   	nop
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801277:	ff 75 08             	pushl  0x8(%ebp)
  80127a:	e8 54 fa ff ff       	call   800cd3 <strlen>
  80127f:	83 c4 04             	add    $0x4,%esp
  801282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	e8 46 fa ff ff       	call   800cd3 <strlen>
  80128d:	83 c4 04             	add    $0x4,%esp
  801290:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80129a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a1:	eb 17                	jmp    8012ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	01 c2                	add    %eax,%edx
  8012ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	01 c8                	add    %ecx,%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b7:	ff 45 fc             	incl   -0x4(%ebp)
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c0:	7c e1                	jl     8012a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d0:	eb 1f                	jmp    8012f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 c2                	add    %eax,%edx
  8012e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e8:	01 c8                	add    %ecx,%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ee:	ff 45 f8             	incl   -0x8(%ebp)
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f7:	7c d9                	jl     8012d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 d0                	add    %edx,%eax
  801301:	c6 00 00             	movb   $0x0,(%eax)
}
  801304:	90                   	nop
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	8b 00                	mov    (%eax),%eax
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132a:	eb 0c                	jmp    801338 <strsplit+0x31>
			*string++ = 0;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8d 50 01             	lea    0x1(%eax),%edx
  801332:	89 55 08             	mov    %edx,0x8(%ebp)
  801335:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 18                	je     801359 <strsplit+0x52>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	0f be c0             	movsbl %al,%eax
  801349:	50                   	push   %eax
  80134a:	ff 75 0c             	pushl  0xc(%ebp)
  80134d:	e8 13 fb ff ff       	call   800e65 <strchr>
  801352:	83 c4 08             	add    $0x8,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	75 d3                	jne    80132c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 5a                	je     8013bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	83 f8 0f             	cmp    $0xf,%eax
  80136a:	75 07                	jne    801373 <strsplit+0x6c>
		{
			return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
  801371:	eb 66                	jmp    8013d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	8d 48 01             	lea    0x1(%eax),%ecx
  80137b:	8b 55 14             	mov    0x14(%ebp),%edx
  80137e:	89 0a                	mov    %ecx,(%edx)
  801380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 c2                	add    %eax,%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801391:	eb 03                	jmp    801396 <strsplit+0x8f>
			string++;
  801393:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	84 c0                	test   %al,%al
  80139d:	74 8b                	je     80132a <strsplit+0x23>
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	0f be c0             	movsbl %al,%eax
  8013a7:	50                   	push   %eax
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	e8 b5 fa ff ff       	call   800e65 <strchr>
  8013b0:	83 c4 08             	add    $0x8,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 dc                	je     801393 <strsplit+0x8c>
			string++;
	}
  8013b7:	e9 6e ff ff ff       	jmp    80132a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013e1:	a1 04 50 80 00       	mov    0x805004,%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	74 1f                	je     801409 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013ea:	e8 1d 00 00 00       	call   80140c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	68 d0 3d 80 00       	push   $0x803dd0
  8013f7:	e8 55 f2 ff ff       	call   800651 <cprintf>
  8013fc:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013ff:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801406:	00 00 00 
	}
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  801412:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801419:	00 00 00 
  80141c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801423:	00 00 00 
  801426:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80142d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801430:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801437:	00 00 00 
  80143a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801441:	00 00 00 
  801444:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80144b:	00 00 00 
	uint32 arr_size = 0;
  80144e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801455:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80145c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801464:	2d 00 10 00 00       	sub    $0x1000,%eax
  801469:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80146e:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801475:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801478:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80147f:	a1 20 51 80 00       	mov    0x805120,%eax
  801484:	c1 e0 04             	shl    $0x4,%eax
  801487:	89 c2                	mov    %eax,%edx
  801489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80148c:	01 d0                	add    %edx,%eax
  80148e:	48                   	dec    %eax
  80148f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801492:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801495:	ba 00 00 00 00       	mov    $0x0,%edx
  80149a:	f7 75 ec             	divl   -0x14(%ebp)
  80149d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014a0:	29 d0                	sub    %edx,%eax
  8014a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  8014a5:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	6a 06                	push   $0x6
  8014be:	ff 75 f4             	pushl  -0xc(%ebp)
  8014c1:	50                   	push   %eax
  8014c2:	e8 6a 04 00 00       	call   801931 <sys_allocate_chunk>
  8014c7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 df 0a 00 00       	call   801fb7 <initialize_MemBlocksList>
  8014d8:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014db:	a1 48 51 80 00       	mov    0x805148,%eax
  8014e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8014e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8014ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8014f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014fb:	75 14                	jne    801511 <initialize_dyn_block_system+0x105>
  8014fd:	83 ec 04             	sub    $0x4,%esp
  801500:	68 f5 3d 80 00       	push   $0x803df5
  801505:	6a 33                	push   $0x33
  801507:	68 13 3e 80 00       	push   $0x803e13
  80150c:	e8 8c ee ff ff       	call   80039d <_panic>
  801511:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801514:	8b 00                	mov    (%eax),%eax
  801516:	85 c0                	test   %eax,%eax
  801518:	74 10                	je     80152a <initialize_dyn_block_system+0x11e>
  80151a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151d:	8b 00                	mov    (%eax),%eax
  80151f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801522:	8b 52 04             	mov    0x4(%edx),%edx
  801525:	89 50 04             	mov    %edx,0x4(%eax)
  801528:	eb 0b                	jmp    801535 <initialize_dyn_block_system+0x129>
  80152a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152d:	8b 40 04             	mov    0x4(%eax),%eax
  801530:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801535:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801538:	8b 40 04             	mov    0x4(%eax),%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 0f                	je     80154e <initialize_dyn_block_system+0x142>
  80153f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801542:	8b 40 04             	mov    0x4(%eax),%eax
  801545:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801548:	8b 12                	mov    (%edx),%edx
  80154a:	89 10                	mov    %edx,(%eax)
  80154c:	eb 0a                	jmp    801558 <initialize_dyn_block_system+0x14c>
  80154e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801551:	8b 00                	mov    (%eax),%eax
  801553:	a3 48 51 80 00       	mov    %eax,0x805148
  801558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801561:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801564:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80156b:	a1 54 51 80 00       	mov    0x805154,%eax
  801570:	48                   	dec    %eax
  801571:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801576:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80157a:	75 14                	jne    801590 <initialize_dyn_block_system+0x184>
  80157c:	83 ec 04             	sub    $0x4,%esp
  80157f:	68 20 3e 80 00       	push   $0x803e20
  801584:	6a 34                	push   $0x34
  801586:	68 13 3e 80 00       	push   $0x803e13
  80158b:	e8 0d ee ff ff       	call   80039d <_panic>
  801590:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801599:	89 10                	mov    %edx,(%eax)
  80159b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159e:	8b 00                	mov    (%eax),%eax
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	74 0d                	je     8015b1 <initialize_dyn_block_system+0x1a5>
  8015a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8015a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015ac:	89 50 04             	mov    %edx,0x4(%eax)
  8015af:	eb 08                	jmp    8015b9 <initialize_dyn_block_system+0x1ad>
  8015b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8015b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8015c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8015d0:	40                   	inc    %eax
  8015d1:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8015d6:	90                   	nop
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015df:	e8 f7 fd ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  8015e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e8:	75 07                	jne    8015f1 <malloc+0x18>
  8015ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ef:	eb 61                	jmp    801652 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8015f1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	01 d0                	add    %edx,%eax
  801600:	48                   	dec    %eax
  801601:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801604:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801607:	ba 00 00 00 00       	mov    $0x0,%edx
  80160c:	f7 75 f0             	divl   -0x10(%ebp)
  80160f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801612:	29 d0                	sub    %edx,%eax
  801614:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801617:	e8 e3 06 00 00       	call   801cff <sys_isUHeapPlacementStrategyFIRSTFIT>
  80161c:	85 c0                	test   %eax,%eax
  80161e:	74 11                	je     801631 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801620:	83 ec 0c             	sub    $0xc,%esp
  801623:	ff 75 e8             	pushl  -0x18(%ebp)
  801626:	e8 4e 0d 00 00       	call   802379 <alloc_block_FF>
  80162b:	83 c4 10             	add    $0x10,%esp
  80162e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801635:	74 16                	je     80164d <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801637:	83 ec 0c             	sub    $0xc,%esp
  80163a:	ff 75 f4             	pushl  -0xc(%ebp)
  80163d:	e8 aa 0a 00 00       	call   8020ec <insert_sorted_allocList>
  801642:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801648:	8b 40 08             	mov    0x8(%eax),%eax
  80164b:	eb 05                	jmp    801652 <malloc+0x79>
	}

    return NULL;
  80164d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80165a:	83 ec 04             	sub    $0x4,%esp
  80165d:	68 44 3e 80 00       	push   $0x803e44
  801662:	6a 6f                	push   $0x6f
  801664:	68 13 3e 80 00       	push   $0x803e13
  801669:	e8 2f ed ff ff       	call   80039d <_panic>

0080166e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	83 ec 38             	sub    $0x38,%esp
  801674:	8b 45 10             	mov    0x10(%ebp),%eax
  801677:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80167a:	e8 5c fd ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  80167f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801683:	75 07                	jne    80168c <smalloc+0x1e>
  801685:	b8 00 00 00 00       	mov    $0x0,%eax
  80168a:	eb 7c                	jmp    801708 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80168c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801693:	8b 55 0c             	mov    0xc(%ebp),%edx
  801696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801699:	01 d0                	add    %edx,%eax
  80169b:	48                   	dec    %eax
  80169c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80169f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a7:	f7 75 f0             	divl   -0x10(%ebp)
  8016aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ad:	29 d0                	sub    %edx,%eax
  8016af:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016b2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016b9:	e8 41 06 00 00       	call   801cff <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	74 11                	je     8016d3 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	ff 75 e8             	pushl  -0x18(%ebp)
  8016c8:	e8 ac 0c 00 00       	call   802379 <alloc_block_FF>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d7:	74 2a                	je     801703 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dc:	8b 40 08             	mov    0x8(%eax),%eax
  8016df:	89 c2                	mov    %eax,%edx
  8016e1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	e8 92 03 00 00       	call   801a84 <sys_createSharedObject>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8016f8:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8016fc:	74 05                	je     801703 <smalloc+0x95>
			return (void*)virtual_address;
  8016fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801701:	eb 05                	jmp    801708 <smalloc+0x9a>
	}
	return NULL;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801710:	e8 c6 fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801715:	83 ec 04             	sub    $0x4,%esp
  801718:	68 68 3e 80 00       	push   $0x803e68
  80171d:	68 b0 00 00 00       	push   $0xb0
  801722:	68 13 3e 80 00       	push   $0x803e13
  801727:	e8 71 ec ff ff       	call   80039d <_panic>

0080172c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801732:	e8 a4 fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801737:	83 ec 04             	sub    $0x4,%esp
  80173a:	68 8c 3e 80 00       	push   $0x803e8c
  80173f:	68 f4 00 00 00       	push   $0xf4
  801744:	68 13 3e 80 00       	push   $0x803e13
  801749:	e8 4f ec ff ff       	call   80039d <_panic>

0080174e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	68 b4 3e 80 00       	push   $0x803eb4
  80175c:	68 08 01 00 00       	push   $0x108
  801761:	68 13 3e 80 00       	push   $0x803e13
  801766:	e8 32 ec ff ff       	call   80039d <_panic>

0080176b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801771:	83 ec 04             	sub    $0x4,%esp
  801774:	68 d8 3e 80 00       	push   $0x803ed8
  801779:	68 13 01 00 00       	push   $0x113
  80177e:	68 13 3e 80 00       	push   $0x803e13
  801783:	e8 15 ec ff ff       	call   80039d <_panic>

00801788 <shrink>:

}
void shrink(uint32 newSize)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	68 d8 3e 80 00       	push   $0x803ed8
  801796:	68 18 01 00 00       	push   $0x118
  80179b:	68 13 3e 80 00       	push   $0x803e13
  8017a0:	e8 f8 eb ff ff       	call   80039d <_panic>

008017a5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	68 d8 3e 80 00       	push   $0x803ed8
  8017b3:	68 1d 01 00 00       	push   $0x11d
  8017b8:	68 13 3e 80 00       	push   $0x803e13
  8017bd:	e8 db eb ff ff       	call   80039d <_panic>

008017c2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	57                   	push   %edi
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
  8017c8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017da:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017dd:	cd 30                	int    $0x30
  8017df:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	5b                   	pop    %ebx
  8017e9:	5e                   	pop    %esi
  8017ea:	5f                   	pop    %edi
  8017eb:	5d                   	pop    %ebp
  8017ec:	c3                   	ret    

008017ed <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	52                   	push   %edx
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	50                   	push   %eax
  801809:	6a 00                	push   $0x0
  80180b:	e8 b2 ff ff ff       	call   8017c2 <syscall>
  801810:	83 c4 18             	add    $0x18,%esp
}
  801813:	90                   	nop
  801814:	c9                   	leave  
  801815:	c3                   	ret    

00801816 <sys_cgetc>:

int
sys_cgetc(void)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 01                	push   $0x1
  801825:	e8 98 ff ff ff       	call   8017c2 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	52                   	push   %edx
  80183f:	50                   	push   %eax
  801840:	6a 05                	push   $0x5
  801842:	e8 7b ff ff ff       	call   8017c2 <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801851:	8b 75 18             	mov    0x18(%ebp),%esi
  801854:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801857:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	56                   	push   %esi
  801861:	53                   	push   %ebx
  801862:	51                   	push   %ecx
  801863:	52                   	push   %edx
  801864:	50                   	push   %eax
  801865:	6a 06                	push   $0x6
  801867:	e8 56 ff ff ff       	call   8017c2 <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801872:	5b                   	pop    %ebx
  801873:	5e                   	pop    %esi
  801874:	5d                   	pop    %ebp
  801875:	c3                   	ret    

00801876 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	52                   	push   %edx
  801886:	50                   	push   %eax
  801887:	6a 07                	push   $0x7
  801889:	e8 34 ff ff ff       	call   8017c2 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	6a 08                	push   $0x8
  8018a4:	e8 19 ff ff ff       	call   8017c2 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 09                	push   $0x9
  8018bd:	e8 00 ff ff ff       	call   8017c2 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 0a                	push   $0xa
  8018d6:	e8 e7 fe ff ff       	call   8017c2 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 0b                	push   $0xb
  8018ef:	e8 ce fe ff ff       	call   8017c2 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	ff 75 0c             	pushl  0xc(%ebp)
  801905:	ff 75 08             	pushl  0x8(%ebp)
  801908:	6a 0f                	push   $0xf
  80190a:	e8 b3 fe ff ff       	call   8017c2 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
	return;
  801912:	90                   	nop
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	ff 75 0c             	pushl  0xc(%ebp)
  801921:	ff 75 08             	pushl  0x8(%ebp)
  801924:	6a 10                	push   $0x10
  801926:	e8 97 fe ff ff       	call   8017c2 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
	return ;
  80192e:	90                   	nop
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	ff 75 10             	pushl  0x10(%ebp)
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	6a 11                	push   $0x11
  801943:	e8 7a fe ff ff       	call   8017c2 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
	return ;
  80194b:	90                   	nop
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 0c                	push   $0xc
  80195d:	e8 60 fe ff ff       	call   8017c2 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	6a 0d                	push   $0xd
  801977:	e8 46 fe ff ff       	call   8017c2 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 0e                	push   $0xe
  801990:	e8 2d fe ff ff       	call   8017c2 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 13                	push   $0x13
  8019aa:	e8 13 fe ff ff       	call   8017c2 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
}
  8019b2:	90                   	nop
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 14                	push   $0x14
  8019c4:	e8 f9 fd ff ff       	call   8017c2 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	90                   	nop
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_cputc>:


void
sys_cputc(const char c)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019db:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	50                   	push   %eax
  8019e8:	6a 15                	push   $0x15
  8019ea:	e8 d3 fd ff ff       	call   8017c2 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 16                	push   $0x16
  801a04:	e8 b9 fd ff ff       	call   8017c2 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	90                   	nop
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	50                   	push   %eax
  801a1f:	6a 17                	push   $0x17
  801a21:	e8 9c fd ff ff       	call   8017c2 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	52                   	push   %edx
  801a3b:	50                   	push   %eax
  801a3c:	6a 1a                	push   $0x1a
  801a3e:	e8 7f fd ff ff       	call   8017c2 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	6a 18                	push   $0x18
  801a5b:	e8 62 fd ff ff       	call   8017c2 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	6a 19                	push   $0x19
  801a79:	e8 44 fd ff ff       	call   8017c2 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	90                   	nop
  801a82:	c9                   	leave  
  801a83:	c3                   	ret    

00801a84 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a90:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a93:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	51                   	push   %ecx
  801a9d:	52                   	push   %edx
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	6a 1b                	push   $0x1b
  801aa4:	e8 19 fd ff ff       	call   8017c2 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	52                   	push   %edx
  801abe:	50                   	push   %eax
  801abf:	6a 1c                	push   $0x1c
  801ac1:	e8 fc fc ff ff       	call   8017c2 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ace:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	51                   	push   %ecx
  801adc:	52                   	push   %edx
  801add:	50                   	push   %eax
  801ade:	6a 1d                	push   $0x1d
  801ae0:	e8 dd fc ff ff       	call   8017c2 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	6a 1e                	push   $0x1e
  801afd:	e8 c0 fc ff ff       	call   8017c2 <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 1f                	push   $0x1f
  801b16:	e8 a7 fc ff ff       	call   8017c2 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	ff 75 14             	pushl  0x14(%ebp)
  801b2b:	ff 75 10             	pushl  0x10(%ebp)
  801b2e:	ff 75 0c             	pushl  0xc(%ebp)
  801b31:	50                   	push   %eax
  801b32:	6a 20                	push   $0x20
  801b34:	e8 89 fc ff ff       	call   8017c2 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	50                   	push   %eax
  801b4d:	6a 21                	push   $0x21
  801b4f:	e8 6e fc ff ff       	call   8017c2 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	90                   	nop
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	50                   	push   %eax
  801b69:	6a 22                	push   $0x22
  801b6b:	e8 52 fc ff ff       	call   8017c2 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 02                	push   $0x2
  801b84:	e8 39 fc ff ff       	call   8017c2 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 03                	push   $0x3
  801b9d:	e8 20 fc ff ff       	call   8017c2 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 04                	push   $0x4
  801bb6:	e8 07 fc ff ff       	call   8017c2 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_exit_env>:


void sys_exit_env(void)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 23                	push   $0x23
  801bcf:	e8 ee fb ff ff       	call   8017c2 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	90                   	nop
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801be0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be3:	8d 50 04             	lea    0x4(%eax),%edx
  801be6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	6a 24                	push   $0x24
  801bf3:	e8 ca fb ff ff       	call   8017c2 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return result;
  801bfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c04:	89 01                	mov    %eax,(%ecx)
  801c06:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	c9                   	leave  
  801c0d:	c2 04 00             	ret    $0x4

00801c10 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	ff 75 10             	pushl  0x10(%ebp)
  801c1a:	ff 75 0c             	pushl  0xc(%ebp)
  801c1d:	ff 75 08             	pushl  0x8(%ebp)
  801c20:	6a 12                	push   $0x12
  801c22:	e8 9b fb ff ff       	call   8017c2 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2a:	90                   	nop
}
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_rcr2>:
uint32 sys_rcr2()
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 25                	push   $0x25
  801c3c:	e8 81 fb ff ff       	call   8017c2 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c52:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	50                   	push   %eax
  801c5f:	6a 26                	push   $0x26
  801c61:	e8 5c fb ff ff       	call   8017c2 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
	return ;
  801c69:	90                   	nop
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <rsttst>:
void rsttst()
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 28                	push   $0x28
  801c7b:	e8 42 fb ff ff       	call   8017c2 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
	return ;
  801c83:	90                   	nop
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c92:	8b 55 18             	mov    0x18(%ebp),%edx
  801c95:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c99:	52                   	push   %edx
  801c9a:	50                   	push   %eax
  801c9b:	ff 75 10             	pushl  0x10(%ebp)
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	ff 75 08             	pushl  0x8(%ebp)
  801ca4:	6a 27                	push   $0x27
  801ca6:	e8 17 fb ff ff       	call   8017c2 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
	return ;
  801cae:	90                   	nop
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <chktst>:
void chktst(uint32 n)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	ff 75 08             	pushl  0x8(%ebp)
  801cbf:	6a 29                	push   $0x29
  801cc1:	e8 fc fa ff ff       	call   8017c2 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc9:	90                   	nop
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <inctst>:

void inctst()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 2a                	push   $0x2a
  801cdb:	e8 e2 fa ff ff       	call   8017c2 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce3:	90                   	nop
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <gettst>:
uint32 gettst()
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 2b                	push   $0x2b
  801cf5:	e8 c8 fa ff ff       	call   8017c2 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 2c                	push   $0x2c
  801d11:	e8 ac fa ff ff       	call   8017c2 <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
  801d19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d1c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d20:	75 07                	jne    801d29 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
  801d27:	eb 05                	jmp    801d2e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 2c                	push   $0x2c
  801d42:	e8 7b fa ff ff       	call   8017c2 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
  801d4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d4d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d51:	75 07                	jne    801d5a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d53:	b8 01 00 00 00       	mov    $0x1,%eax
  801d58:	eb 05                	jmp    801d5f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 2c                	push   $0x2c
  801d73:	e8 4a fa ff ff       	call   8017c2 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
  801d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d7e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d82:	75 07                	jne    801d8b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d84:	b8 01 00 00 00       	mov    $0x1,%eax
  801d89:	eb 05                	jmp    801d90 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 2c                	push   $0x2c
  801da4:	e8 19 fa ff ff       	call   8017c2 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
  801dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801daf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801db3:	75 07                	jne    801dbc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801db5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dba:	eb 05                	jmp    801dc1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	6a 2d                	push   $0x2d
  801dd3:	e8 ea f9 ff ff       	call   8017c2 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801de2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	6a 00                	push   $0x0
  801df0:	53                   	push   %ebx
  801df1:	51                   	push   %ecx
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	6a 2e                	push   $0x2e
  801df6:	e8 c7 f9 ff ff       	call   8017c2 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	52                   	push   %edx
  801e13:	50                   	push   %eax
  801e14:	6a 2f                	push   $0x2f
  801e16:	e8 a7 f9 ff ff       	call   8017c2 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	68 e8 3e 80 00       	push   $0x803ee8
  801e2e:	e8 1e e8 ff ff       	call   800651 <cprintf>
  801e33:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e3d:	83 ec 0c             	sub    $0xc,%esp
  801e40:	68 14 3f 80 00       	push   $0x803f14
  801e45:	e8 07 e8 ff ff       	call   800651 <cprintf>
  801e4a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e4d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e51:	a1 38 51 80 00       	mov    0x805138,%eax
  801e56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e59:	eb 56                	jmp    801eb1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e5f:	74 1c                	je     801e7d <print_mem_block_lists+0x5d>
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	8b 50 08             	mov    0x8(%eax),%edx
  801e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6a:	8b 48 08             	mov    0x8(%eax),%ecx
  801e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e70:	8b 40 0c             	mov    0xc(%eax),%eax
  801e73:	01 c8                	add    %ecx,%eax
  801e75:	39 c2                	cmp    %eax,%edx
  801e77:	73 04                	jae    801e7d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e79:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e80:	8b 50 08             	mov    0x8(%eax),%edx
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	8b 40 0c             	mov    0xc(%eax),%eax
  801e89:	01 c2                	add    %eax,%edx
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8e:	8b 40 08             	mov    0x8(%eax),%eax
  801e91:	83 ec 04             	sub    $0x4,%esp
  801e94:	52                   	push   %edx
  801e95:	50                   	push   %eax
  801e96:	68 29 3f 80 00       	push   $0x803f29
  801e9b:	e8 b1 e7 ff ff       	call   800651 <cprintf>
  801ea0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ea9:	a1 40 51 80 00       	mov    0x805140,%eax
  801eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb5:	74 07                	je     801ebe <print_mem_block_lists+0x9e>
  801eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eba:	8b 00                	mov    (%eax),%eax
  801ebc:	eb 05                	jmp    801ec3 <print_mem_block_lists+0xa3>
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec3:	a3 40 51 80 00       	mov    %eax,0x805140
  801ec8:	a1 40 51 80 00       	mov    0x805140,%eax
  801ecd:	85 c0                	test   %eax,%eax
  801ecf:	75 8a                	jne    801e5b <print_mem_block_lists+0x3b>
  801ed1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed5:	75 84                	jne    801e5b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ed7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801edb:	75 10                	jne    801eed <print_mem_block_lists+0xcd>
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	68 38 3f 80 00       	push   $0x803f38
  801ee5:	e8 67 e7 ff ff       	call   800651 <cprintf>
  801eea:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	68 5c 3f 80 00       	push   $0x803f5c
  801efc:	e8 50 e7 ff ff       	call   800651 <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f04:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f08:	a1 40 50 80 00       	mov    0x805040,%eax
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f10:	eb 56                	jmp    801f68 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f16:	74 1c                	je     801f34 <print_mem_block_lists+0x114>
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 50 08             	mov    0x8(%eax),%edx
  801f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f21:	8b 48 08             	mov    0x8(%eax),%ecx
  801f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f27:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2a:	01 c8                	add    %ecx,%eax
  801f2c:	39 c2                	cmp    %eax,%edx
  801f2e:	73 04                	jae    801f34 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f30:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	8b 50 08             	mov    0x8(%eax),%edx
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f40:	01 c2                	add    %eax,%edx
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 40 08             	mov    0x8(%eax),%eax
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	52                   	push   %edx
  801f4c:	50                   	push   %eax
  801f4d:	68 29 3f 80 00       	push   $0x803f29
  801f52:	e8 fa e6 ff ff       	call   800651 <cprintf>
  801f57:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f60:	a1 48 50 80 00       	mov    0x805048,%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6c:	74 07                	je     801f75 <print_mem_block_lists+0x155>
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	8b 00                	mov    (%eax),%eax
  801f73:	eb 05                	jmp    801f7a <print_mem_block_lists+0x15a>
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	a3 48 50 80 00       	mov    %eax,0x805048
  801f7f:	a1 48 50 80 00       	mov    0x805048,%eax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	75 8a                	jne    801f12 <print_mem_block_lists+0xf2>
  801f88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8c:	75 84                	jne    801f12 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f8e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f92:	75 10                	jne    801fa4 <print_mem_block_lists+0x184>
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	68 74 3f 80 00       	push   $0x803f74
  801f9c:	e8 b0 e6 ff ff       	call   800651 <cprintf>
  801fa1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fa4:	83 ec 0c             	sub    $0xc,%esp
  801fa7:	68 e8 3e 80 00       	push   $0x803ee8
  801fac:	e8 a0 e6 ff ff       	call   800651 <cprintf>
  801fb1:	83 c4 10             	add    $0x10,%esp

}
  801fb4:	90                   	nop
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fbd:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fc4:	00 00 00 
  801fc7:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801fce:	00 00 00 
  801fd1:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fd8:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fe2:	e9 9e 00 00 00       	jmp    802085 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fe7:	a1 50 50 80 00       	mov    0x805050,%eax
  801fec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fef:	c1 e2 04             	shl    $0x4,%edx
  801ff2:	01 d0                	add    %edx,%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	75 14                	jne    80200c <initialize_MemBlocksList+0x55>
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 9c 3f 80 00       	push   $0x803f9c
  802000:	6a 46                	push   $0x46
  802002:	68 bf 3f 80 00       	push   $0x803fbf
  802007:	e8 91 e3 ff ff       	call   80039d <_panic>
  80200c:	a1 50 50 80 00       	mov    0x805050,%eax
  802011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802014:	c1 e2 04             	shl    $0x4,%edx
  802017:	01 d0                	add    %edx,%eax
  802019:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80201f:	89 10                	mov    %edx,(%eax)
  802021:	8b 00                	mov    (%eax),%eax
  802023:	85 c0                	test   %eax,%eax
  802025:	74 18                	je     80203f <initialize_MemBlocksList+0x88>
  802027:	a1 48 51 80 00       	mov    0x805148,%eax
  80202c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802032:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802035:	c1 e1 04             	shl    $0x4,%ecx
  802038:	01 ca                	add    %ecx,%edx
  80203a:	89 50 04             	mov    %edx,0x4(%eax)
  80203d:	eb 12                	jmp    802051 <initialize_MemBlocksList+0x9a>
  80203f:	a1 50 50 80 00       	mov    0x805050,%eax
  802044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802047:	c1 e2 04             	shl    $0x4,%edx
  80204a:	01 d0                	add    %edx,%eax
  80204c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802051:	a1 50 50 80 00       	mov    0x805050,%eax
  802056:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802059:	c1 e2 04             	shl    $0x4,%edx
  80205c:	01 d0                	add    %edx,%eax
  80205e:	a3 48 51 80 00       	mov    %eax,0x805148
  802063:	a1 50 50 80 00       	mov    0x805050,%eax
  802068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206b:	c1 e2 04             	shl    $0x4,%edx
  80206e:	01 d0                	add    %edx,%eax
  802070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802077:	a1 54 51 80 00       	mov    0x805154,%eax
  80207c:	40                   	inc    %eax
  80207d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802082:	ff 45 f4             	incl   -0xc(%ebp)
  802085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802088:	3b 45 08             	cmp    0x8(%ebp),%eax
  80208b:	0f 82 56 ff ff ff    	jb     801fe7 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802091:	90                   	nop
  802092:	c9                   	leave  
  802093:	c3                   	ret    

00802094 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8b 00                	mov    (%eax),%eax
  80209f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020a2:	eb 19                	jmp    8020bd <find_block+0x29>
	{
		if(va==point->sva)
  8020a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a7:	8b 40 08             	mov    0x8(%eax),%eax
  8020aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020ad:	75 05                	jne    8020b4 <find_block+0x20>
		   return point;
  8020af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b2:	eb 36                	jmp    8020ea <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	8b 40 08             	mov    0x8(%eax),%eax
  8020ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c1:	74 07                	je     8020ca <find_block+0x36>
  8020c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c6:	8b 00                	mov    (%eax),%eax
  8020c8:	eb 05                	jmp    8020cf <find_block+0x3b>
  8020ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d2:	89 42 08             	mov    %eax,0x8(%edx)
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	8b 40 08             	mov    0x8(%eax),%eax
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	75 c5                	jne    8020a4 <find_block+0x10>
  8020df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e3:	75 bf                	jne    8020a4 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020f2:	a1 40 50 80 00       	mov    0x805040,%eax
  8020f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020fa:	a1 44 50 80 00       	mov    0x805044,%eax
  8020ff:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802102:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802105:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802108:	74 24                	je     80212e <insert_sorted_allocList+0x42>
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	8b 50 08             	mov    0x8(%eax),%edx
  802110:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802113:	8b 40 08             	mov    0x8(%eax),%eax
  802116:	39 c2                	cmp    %eax,%edx
  802118:	76 14                	jbe    80212e <insert_sorted_allocList+0x42>
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	8b 50 08             	mov    0x8(%eax),%edx
  802120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802123:	8b 40 08             	mov    0x8(%eax),%eax
  802126:	39 c2                	cmp    %eax,%edx
  802128:	0f 82 60 01 00 00    	jb     80228e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80212e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802132:	75 65                	jne    802199 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802134:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802138:	75 14                	jne    80214e <insert_sorted_allocList+0x62>
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	68 9c 3f 80 00       	push   $0x803f9c
  802142:	6a 6b                	push   $0x6b
  802144:	68 bf 3f 80 00       	push   $0x803fbf
  802149:	e8 4f e2 ff ff       	call   80039d <_panic>
  80214e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	89 10                	mov    %edx,(%eax)
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	8b 00                	mov    (%eax),%eax
  80215e:	85 c0                	test   %eax,%eax
  802160:	74 0d                	je     80216f <insert_sorted_allocList+0x83>
  802162:	a1 40 50 80 00       	mov    0x805040,%eax
  802167:	8b 55 08             	mov    0x8(%ebp),%edx
  80216a:	89 50 04             	mov    %edx,0x4(%eax)
  80216d:	eb 08                	jmp    802177 <insert_sorted_allocList+0x8b>
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	a3 44 50 80 00       	mov    %eax,0x805044
  802177:	8b 45 08             	mov    0x8(%ebp),%eax
  80217a:	a3 40 50 80 00       	mov    %eax,0x805040
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802189:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80218e:	40                   	inc    %eax
  80218f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802194:	e9 dc 01 00 00       	jmp    802375 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	8b 50 08             	mov    0x8(%eax),%edx
  80219f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a2:	8b 40 08             	mov    0x8(%eax),%eax
  8021a5:	39 c2                	cmp    %eax,%edx
  8021a7:	77 6c                	ja     802215 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ad:	74 06                	je     8021b5 <insert_sorted_allocList+0xc9>
  8021af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b3:	75 14                	jne    8021c9 <insert_sorted_allocList+0xdd>
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	68 d8 3f 80 00       	push   $0x803fd8
  8021bd:	6a 6f                	push   $0x6f
  8021bf:	68 bf 3f 80 00       	push   $0x803fbf
  8021c4:	e8 d4 e1 ff ff       	call   80039d <_panic>
  8021c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cc:	8b 50 04             	mov    0x4(%eax),%edx
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	89 50 04             	mov    %edx,0x4(%eax)
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021db:	89 10                	mov    %edx,(%eax)
  8021dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e0:	8b 40 04             	mov    0x4(%eax),%eax
  8021e3:	85 c0                	test   %eax,%eax
  8021e5:	74 0d                	je     8021f4 <insert_sorted_allocList+0x108>
  8021e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ea:	8b 40 04             	mov    0x4(%eax),%eax
  8021ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f0:	89 10                	mov    %edx,(%eax)
  8021f2:	eb 08                	jmp    8021fc <insert_sorted_allocList+0x110>
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	a3 40 50 80 00       	mov    %eax,0x805040
  8021fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802202:	89 50 04             	mov    %edx,0x4(%eax)
  802205:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80220a:	40                   	inc    %eax
  80220b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802210:	e9 60 01 00 00       	jmp    802375 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	8b 50 08             	mov    0x8(%eax),%edx
  80221b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221e:	8b 40 08             	mov    0x8(%eax),%eax
  802221:	39 c2                	cmp    %eax,%edx
  802223:	0f 82 4c 01 00 00    	jb     802375 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222d:	75 14                	jne    802243 <insert_sorted_allocList+0x157>
  80222f:	83 ec 04             	sub    $0x4,%esp
  802232:	68 10 40 80 00       	push   $0x804010
  802237:	6a 73                	push   $0x73
  802239:	68 bf 3f 80 00       	push   $0x803fbf
  80223e:	e8 5a e1 ff ff       	call   80039d <_panic>
  802243:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	89 50 04             	mov    %edx,0x4(%eax)
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	8b 40 04             	mov    0x4(%eax),%eax
  802255:	85 c0                	test   %eax,%eax
  802257:	74 0c                	je     802265 <insert_sorted_allocList+0x179>
  802259:	a1 44 50 80 00       	mov    0x805044,%eax
  80225e:	8b 55 08             	mov    0x8(%ebp),%edx
  802261:	89 10                	mov    %edx,(%eax)
  802263:	eb 08                	jmp    80226d <insert_sorted_allocList+0x181>
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	a3 40 50 80 00       	mov    %eax,0x805040
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	a3 44 50 80 00       	mov    %eax,0x805044
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80227e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802283:	40                   	inc    %eax
  802284:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802289:	e9 e7 00 00 00       	jmp    802375 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802294:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80229b:	a1 40 50 80 00       	mov    0x805040,%eax
  8022a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a3:	e9 9d 00 00 00       	jmp    802345 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 00                	mov    (%eax),%eax
  8022ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	8b 50 08             	mov    0x8(%eax),%edx
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 40 08             	mov    0x8(%eax),%eax
  8022bc:	39 c2                	cmp    %eax,%edx
  8022be:	76 7d                	jbe    80233d <insert_sorted_allocList+0x251>
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 50 08             	mov    0x8(%eax),%edx
  8022c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c9:	8b 40 08             	mov    0x8(%eax),%eax
  8022cc:	39 c2                	cmp    %eax,%edx
  8022ce:	73 6d                	jae    80233d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d4:	74 06                	je     8022dc <insert_sorted_allocList+0x1f0>
  8022d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022da:	75 14                	jne    8022f0 <insert_sorted_allocList+0x204>
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	68 34 40 80 00       	push   $0x804034
  8022e4:	6a 7f                	push   $0x7f
  8022e6:	68 bf 3f 80 00       	push   $0x803fbf
  8022eb:	e8 ad e0 ff ff       	call   80039d <_panic>
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 10                	mov    (%eax),%edx
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	89 10                	mov    %edx,(%eax)
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 0b                	je     80230e <insert_sorted_allocList+0x222>
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 00                	mov    (%eax),%eax
  802308:	8b 55 08             	mov    0x8(%ebp),%edx
  80230b:	89 50 04             	mov    %edx,0x4(%eax)
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 55 08             	mov    0x8(%ebp),%edx
  802314:	89 10                	mov    %edx,(%eax)
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231c:	89 50 04             	mov    %edx,0x4(%eax)
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	8b 00                	mov    (%eax),%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	75 08                	jne    802330 <insert_sorted_allocList+0x244>
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	a3 44 50 80 00       	mov    %eax,0x805044
  802330:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802335:	40                   	inc    %eax
  802336:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80233b:	eb 39                	jmp    802376 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80233d:	a1 48 50 80 00       	mov    0x805048,%eax
  802342:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802345:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802349:	74 07                	je     802352 <insert_sorted_allocList+0x266>
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	8b 00                	mov    (%eax),%eax
  802350:	eb 05                	jmp    802357 <insert_sorted_allocList+0x26b>
  802352:	b8 00 00 00 00       	mov    $0x0,%eax
  802357:	a3 48 50 80 00       	mov    %eax,0x805048
  80235c:	a1 48 50 80 00       	mov    0x805048,%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	0f 85 3f ff ff ff    	jne    8022a8 <insert_sorted_allocList+0x1bc>
  802369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236d:	0f 85 35 ff ff ff    	jne    8022a8 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802373:	eb 01                	jmp    802376 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802375:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802376:	90                   	nop
  802377:	c9                   	leave  
  802378:	c3                   	ret    

00802379 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802379:	55                   	push   %ebp
  80237a:	89 e5                	mov    %esp,%ebp
  80237c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80237f:	a1 38 51 80 00       	mov    0x805138,%eax
  802384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802387:	e9 85 01 00 00       	jmp    802511 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 40 0c             	mov    0xc(%eax),%eax
  802392:	3b 45 08             	cmp    0x8(%ebp),%eax
  802395:	0f 82 6e 01 00 00    	jb     802509 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a4:	0f 85 8a 00 00 00    	jne    802434 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ae:	75 17                	jne    8023c7 <alloc_block_FF+0x4e>
  8023b0:	83 ec 04             	sub    $0x4,%esp
  8023b3:	68 68 40 80 00       	push   $0x804068
  8023b8:	68 93 00 00 00       	push   $0x93
  8023bd:	68 bf 3f 80 00       	push   $0x803fbf
  8023c2:	e8 d6 df ff ff       	call   80039d <_panic>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	74 10                	je     8023e0 <alloc_block_FF+0x67>
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 00                	mov    (%eax),%eax
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	8b 52 04             	mov    0x4(%edx),%edx
  8023db:	89 50 04             	mov    %edx,0x4(%eax)
  8023de:	eb 0b                	jmp    8023eb <alloc_block_FF+0x72>
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 40 04             	mov    0x4(%eax),%eax
  8023e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 04             	mov    0x4(%eax),%eax
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	74 0f                	je     802404 <alloc_block_FF+0x8b>
  8023f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f8:	8b 40 04             	mov    0x4(%eax),%eax
  8023fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fe:	8b 12                	mov    (%edx),%edx
  802400:	89 10                	mov    %edx,(%eax)
  802402:	eb 0a                	jmp    80240e <alloc_block_FF+0x95>
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 00                	mov    (%eax),%eax
  802409:	a3 38 51 80 00       	mov    %eax,0x805138
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802421:	a1 44 51 80 00       	mov    0x805144,%eax
  802426:	48                   	dec    %eax
  802427:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	e9 10 01 00 00       	jmp    802544 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 0c             	mov    0xc(%eax),%eax
  80243a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243d:	0f 86 c6 00 00 00    	jbe    802509 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802443:	a1 48 51 80 00       	mov    0x805148,%eax
  802448:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 50 08             	mov    0x8(%eax),%edx
  802451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802454:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245a:	8b 55 08             	mov    0x8(%ebp),%edx
  80245d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802460:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802464:	75 17                	jne    80247d <alloc_block_FF+0x104>
  802466:	83 ec 04             	sub    $0x4,%esp
  802469:	68 68 40 80 00       	push   $0x804068
  80246e:	68 9b 00 00 00       	push   $0x9b
  802473:	68 bf 3f 80 00       	push   $0x803fbf
  802478:	e8 20 df ff ff       	call   80039d <_panic>
  80247d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	85 c0                	test   %eax,%eax
  802484:	74 10                	je     802496 <alloc_block_FF+0x11d>
  802486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80248e:	8b 52 04             	mov    0x4(%edx),%edx
  802491:	89 50 04             	mov    %edx,0x4(%eax)
  802494:	eb 0b                	jmp    8024a1 <alloc_block_FF+0x128>
  802496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a4:	8b 40 04             	mov    0x4(%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 0f                	je     8024ba <alloc_block_FF+0x141>
  8024ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ae:	8b 40 04             	mov    0x4(%eax),%eax
  8024b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b4:	8b 12                	mov    (%edx),%edx
  8024b6:	89 10                	mov    %edx,(%eax)
  8024b8:	eb 0a                	jmp    8024c4 <alloc_block_FF+0x14b>
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	8b 00                	mov    (%eax),%eax
  8024bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8024c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8024dc:	48                   	dec    %eax
  8024dd:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 50 08             	mov    0x8(%eax),%edx
  8024e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024eb:	01 c2                	add    %eax,%edx
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f9:	2b 45 08             	sub    0x8(%ebp),%eax
  8024fc:	89 c2                	mov    %eax,%edx
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	eb 3b                	jmp    802544 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802509:	a1 40 51 80 00       	mov    0x805140,%eax
  80250e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802511:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802515:	74 07                	je     80251e <alloc_block_FF+0x1a5>
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 00                	mov    (%eax),%eax
  80251c:	eb 05                	jmp    802523 <alloc_block_FF+0x1aa>
  80251e:	b8 00 00 00 00       	mov    $0x0,%eax
  802523:	a3 40 51 80 00       	mov    %eax,0x805140
  802528:	a1 40 51 80 00       	mov    0x805140,%eax
  80252d:	85 c0                	test   %eax,%eax
  80252f:	0f 85 57 fe ff ff    	jne    80238c <alloc_block_FF+0x13>
  802535:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802539:	0f 85 4d fe ff ff    	jne    80238c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80253f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80254c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802553:	a1 38 51 80 00       	mov    0x805138,%eax
  802558:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255b:	e9 df 00 00 00       	jmp    80263f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 0c             	mov    0xc(%eax),%eax
  802566:	3b 45 08             	cmp    0x8(%ebp),%eax
  802569:	0f 82 c8 00 00 00    	jb     802637 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 0c             	mov    0xc(%eax),%eax
  802575:	3b 45 08             	cmp    0x8(%ebp),%eax
  802578:	0f 85 8a 00 00 00    	jne    802608 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80257e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802582:	75 17                	jne    80259b <alloc_block_BF+0x55>
  802584:	83 ec 04             	sub    $0x4,%esp
  802587:	68 68 40 80 00       	push   $0x804068
  80258c:	68 b7 00 00 00       	push   $0xb7
  802591:	68 bf 3f 80 00       	push   $0x803fbf
  802596:	e8 02 de ff ff       	call   80039d <_panic>
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	74 10                	je     8025b4 <alloc_block_BF+0x6e>
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ac:	8b 52 04             	mov    0x4(%edx),%edx
  8025af:	89 50 04             	mov    %edx,0x4(%eax)
  8025b2:	eb 0b                	jmp    8025bf <alloc_block_BF+0x79>
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 40 04             	mov    0x4(%eax),%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	74 0f                	je     8025d8 <alloc_block_BF+0x92>
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 40 04             	mov    0x4(%eax),%eax
  8025cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d2:	8b 12                	mov    (%edx),%edx
  8025d4:	89 10                	mov    %edx,(%eax)
  8025d6:	eb 0a                	jmp    8025e2 <alloc_block_BF+0x9c>
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	a3 38 51 80 00       	mov    %eax,0x805138
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f5:	a1 44 51 80 00       	mov    0x805144,%eax
  8025fa:	48                   	dec    %eax
  8025fb:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802603:	e9 4d 01 00 00       	jmp    802755 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 0c             	mov    0xc(%eax),%eax
  80260e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802611:	76 24                	jbe    802637 <alloc_block_BF+0xf1>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 0c             	mov    0xc(%eax),%eax
  802619:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80261c:	73 19                	jae    802637 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80261e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 40 0c             	mov    0xc(%eax),%eax
  80262b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 40 08             	mov    0x8(%eax),%eax
  802634:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802637:	a1 40 51 80 00       	mov    0x805140,%eax
  80263c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802643:	74 07                	je     80264c <alloc_block_BF+0x106>
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 00                	mov    (%eax),%eax
  80264a:	eb 05                	jmp    802651 <alloc_block_BF+0x10b>
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
  802651:	a3 40 51 80 00       	mov    %eax,0x805140
  802656:	a1 40 51 80 00       	mov    0x805140,%eax
  80265b:	85 c0                	test   %eax,%eax
  80265d:	0f 85 fd fe ff ff    	jne    802560 <alloc_block_BF+0x1a>
  802663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802667:	0f 85 f3 fe ff ff    	jne    802560 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80266d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802671:	0f 84 d9 00 00 00    	je     802750 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802677:	a1 48 51 80 00       	mov    0x805148,%eax
  80267c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80267f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802682:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802685:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268b:	8b 55 08             	mov    0x8(%ebp),%edx
  80268e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802691:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802695:	75 17                	jne    8026ae <alloc_block_BF+0x168>
  802697:	83 ec 04             	sub    $0x4,%esp
  80269a:	68 68 40 80 00       	push   $0x804068
  80269f:	68 c7 00 00 00       	push   $0xc7
  8026a4:	68 bf 3f 80 00       	push   $0x803fbf
  8026a9:	e8 ef dc ff ff       	call   80039d <_panic>
  8026ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b1:	8b 00                	mov    (%eax),%eax
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	74 10                	je     8026c7 <alloc_block_BF+0x181>
  8026b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026bf:	8b 52 04             	mov    0x4(%edx),%edx
  8026c2:	89 50 04             	mov    %edx,0x4(%eax)
  8026c5:	eb 0b                	jmp    8026d2 <alloc_block_BF+0x18c>
  8026c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ca:	8b 40 04             	mov    0x4(%eax),%eax
  8026cd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d5:	8b 40 04             	mov    0x4(%eax),%eax
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	74 0f                	je     8026eb <alloc_block_BF+0x1a5>
  8026dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026df:	8b 40 04             	mov    0x4(%eax),%eax
  8026e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e5:	8b 12                	mov    (%edx),%edx
  8026e7:	89 10                	mov    %edx,(%eax)
  8026e9:	eb 0a                	jmp    8026f5 <alloc_block_BF+0x1af>
  8026eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ee:	8b 00                	mov    (%eax),%eax
  8026f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8026f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802701:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802708:	a1 54 51 80 00       	mov    0x805154,%eax
  80270d:	48                   	dec    %eax
  80270e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802713:	83 ec 08             	sub    $0x8,%esp
  802716:	ff 75 ec             	pushl  -0x14(%ebp)
  802719:	68 38 51 80 00       	push   $0x805138
  80271e:	e8 71 f9 ff ff       	call   802094 <find_block>
  802723:	83 c4 10             	add    $0x10,%esp
  802726:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272c:	8b 50 08             	mov    0x8(%eax),%edx
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	01 c2                	add    %eax,%edx
  802734:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802737:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80273a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	2b 45 08             	sub    0x8(%ebp),%eax
  802743:	89 c2                	mov    %eax,%edx
  802745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802748:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80274b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274e:	eb 05                	jmp    802755 <alloc_block_BF+0x20f>
	}
	return NULL;
  802750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802755:	c9                   	leave  
  802756:	c3                   	ret    

00802757 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802757:	55                   	push   %ebp
  802758:	89 e5                	mov    %esp,%ebp
  80275a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80275d:	a1 28 50 80 00       	mov    0x805028,%eax
  802762:	85 c0                	test   %eax,%eax
  802764:	0f 85 de 01 00 00    	jne    802948 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80276a:	a1 38 51 80 00       	mov    0x805138,%eax
  80276f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802772:	e9 9e 01 00 00       	jmp    802915 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 0c             	mov    0xc(%eax),%eax
  80277d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802780:	0f 82 87 01 00 00    	jb     80290d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	8b 40 0c             	mov    0xc(%eax),%eax
  80278c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278f:	0f 85 95 00 00 00    	jne    80282a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802799:	75 17                	jne    8027b2 <alloc_block_NF+0x5b>
  80279b:	83 ec 04             	sub    $0x4,%esp
  80279e:	68 68 40 80 00       	push   $0x804068
  8027a3:	68 e0 00 00 00       	push   $0xe0
  8027a8:	68 bf 3f 80 00       	push   $0x803fbf
  8027ad:	e8 eb db ff ff       	call   80039d <_panic>
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	74 10                	je     8027cb <alloc_block_NF+0x74>
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	8b 00                	mov    (%eax),%eax
  8027c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c3:	8b 52 04             	mov    0x4(%edx),%edx
  8027c6:	89 50 04             	mov    %edx,0x4(%eax)
  8027c9:	eb 0b                	jmp    8027d6 <alloc_block_NF+0x7f>
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 40 04             	mov    0x4(%eax),%eax
  8027d1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 04             	mov    0x4(%eax),%eax
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	74 0f                	je     8027ef <alloc_block_NF+0x98>
  8027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e3:	8b 40 04             	mov    0x4(%eax),%eax
  8027e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e9:	8b 12                	mov    (%edx),%edx
  8027eb:	89 10                	mov    %edx,(%eax)
  8027ed:	eb 0a                	jmp    8027f9 <alloc_block_NF+0xa2>
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	a3 38 51 80 00       	mov    %eax,0x805138
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280c:	a1 44 51 80 00       	mov    0x805144,%eax
  802811:	48                   	dec    %eax
  802812:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 40 08             	mov    0x8(%eax),%eax
  80281d:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	e9 f8 04 00 00       	jmp    802d22 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 40 0c             	mov    0xc(%eax),%eax
  802830:	3b 45 08             	cmp    0x8(%ebp),%eax
  802833:	0f 86 d4 00 00 00    	jbe    80290d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802839:	a1 48 51 80 00       	mov    0x805148,%eax
  80283e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 50 08             	mov    0x8(%eax),%edx
  802847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80284d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802850:	8b 55 08             	mov    0x8(%ebp),%edx
  802853:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802856:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80285a:	75 17                	jne    802873 <alloc_block_NF+0x11c>
  80285c:	83 ec 04             	sub    $0x4,%esp
  80285f:	68 68 40 80 00       	push   $0x804068
  802864:	68 e9 00 00 00       	push   $0xe9
  802869:	68 bf 3f 80 00       	push   $0x803fbf
  80286e:	e8 2a db ff ff       	call   80039d <_panic>
  802873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802876:	8b 00                	mov    (%eax),%eax
  802878:	85 c0                	test   %eax,%eax
  80287a:	74 10                	je     80288c <alloc_block_NF+0x135>
  80287c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802884:	8b 52 04             	mov    0x4(%edx),%edx
  802887:	89 50 04             	mov    %edx,0x4(%eax)
  80288a:	eb 0b                	jmp    802897 <alloc_block_NF+0x140>
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289a:	8b 40 04             	mov    0x4(%eax),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	74 0f                	je     8028b0 <alloc_block_NF+0x159>
  8028a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a4:	8b 40 04             	mov    0x4(%eax),%eax
  8028a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028aa:	8b 12                	mov    (%edx),%edx
  8028ac:	89 10                	mov    %edx,(%eax)
  8028ae:	eb 0a                	jmp    8028ba <alloc_block_NF+0x163>
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8028d2:	48                   	dec    %eax
  8028d3:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028db:	8b 40 08             	mov    0x8(%eax),%eax
  8028de:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	8b 50 08             	mov    0x8(%eax),%edx
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	01 c2                	add    %eax,%edx
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fa:	2b 45 08             	sub    0x8(%ebp),%eax
  8028fd:	89 c2                	mov    %eax,%edx
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	e9 15 04 00 00       	jmp    802d22 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80290d:	a1 40 51 80 00       	mov    0x805140,%eax
  802912:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802919:	74 07                	je     802922 <alloc_block_NF+0x1cb>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 00                	mov    (%eax),%eax
  802920:	eb 05                	jmp    802927 <alloc_block_NF+0x1d0>
  802922:	b8 00 00 00 00       	mov    $0x0,%eax
  802927:	a3 40 51 80 00       	mov    %eax,0x805140
  80292c:	a1 40 51 80 00       	mov    0x805140,%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	0f 85 3e fe ff ff    	jne    802777 <alloc_block_NF+0x20>
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	0f 85 34 fe ff ff    	jne    802777 <alloc_block_NF+0x20>
  802943:	e9 d5 03 00 00       	jmp    802d1d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802948:	a1 38 51 80 00       	mov    0x805138,%eax
  80294d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802950:	e9 b1 01 00 00       	jmp    802b06 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 50 08             	mov    0x8(%eax),%edx
  80295b:	a1 28 50 80 00       	mov    0x805028,%eax
  802960:	39 c2                	cmp    %eax,%edx
  802962:	0f 82 96 01 00 00    	jb     802afe <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 40 0c             	mov    0xc(%eax),%eax
  80296e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802971:	0f 82 87 01 00 00    	jb     802afe <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 0c             	mov    0xc(%eax),%eax
  80297d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802980:	0f 85 95 00 00 00    	jne    802a1b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298a:	75 17                	jne    8029a3 <alloc_block_NF+0x24c>
  80298c:	83 ec 04             	sub    $0x4,%esp
  80298f:	68 68 40 80 00       	push   $0x804068
  802994:	68 fc 00 00 00       	push   $0xfc
  802999:	68 bf 3f 80 00       	push   $0x803fbf
  80299e:	e8 fa d9 ff ff       	call   80039d <_panic>
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 10                	je     8029bc <alloc_block_NF+0x265>
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b4:	8b 52 04             	mov    0x4(%edx),%edx
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	eb 0b                	jmp    8029c7 <alloc_block_NF+0x270>
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	85 c0                	test   %eax,%eax
  8029cf:	74 0f                	je     8029e0 <alloc_block_NF+0x289>
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 40 04             	mov    0x4(%eax),%eax
  8029d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029da:	8b 12                	mov    (%edx),%edx
  8029dc:	89 10                	mov    %edx,(%eax)
  8029de:	eb 0a                	jmp    8029ea <alloc_block_NF+0x293>
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fd:	a1 44 51 80 00       	mov    0x805144,%eax
  802a02:	48                   	dec    %eax
  802a03:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 40 08             	mov    0x8(%eax),%eax
  802a0e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	e9 07 03 00 00       	jmp    802d22 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a21:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a24:	0f 86 d4 00 00 00    	jbe    802afe <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a2a:	a1 48 51 80 00       	mov    0x805148,%eax
  802a2f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 50 08             	mov    0x8(%eax),%edx
  802a38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a41:	8b 55 08             	mov    0x8(%ebp),%edx
  802a44:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a47:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a4b:	75 17                	jne    802a64 <alloc_block_NF+0x30d>
  802a4d:	83 ec 04             	sub    $0x4,%esp
  802a50:	68 68 40 80 00       	push   $0x804068
  802a55:	68 04 01 00 00       	push   $0x104
  802a5a:	68 bf 3f 80 00       	push   $0x803fbf
  802a5f:	e8 39 d9 ff ff       	call   80039d <_panic>
  802a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 10                	je     802a7d <alloc_block_NF+0x326>
  802a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a75:	8b 52 04             	mov    0x4(%edx),%edx
  802a78:	89 50 04             	mov    %edx,0x4(%eax)
  802a7b:	eb 0b                	jmp    802a88 <alloc_block_NF+0x331>
  802a7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	74 0f                	je     802aa1 <alloc_block_NF+0x34a>
  802a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a95:	8b 40 04             	mov    0x4(%eax),%eax
  802a98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a9b:	8b 12                	mov    (%edx),%edx
  802a9d:	89 10                	mov    %edx,(%eax)
  802a9f:	eb 0a                	jmp    802aab <alloc_block_NF+0x354>
  802aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	a3 48 51 80 00       	mov    %eax,0x805148
  802aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abe:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac3:	48                   	dec    %eax
  802ac4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acc:	8b 40 08             	mov    0x8(%eax),%eax
  802acf:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 50 08             	mov    0x8(%eax),%edx
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	01 c2                	add    %eax,%edx
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 0c             	mov    0xc(%eax),%eax
  802aeb:	2b 45 08             	sub    0x8(%ebp),%eax
  802aee:	89 c2                	mov    %eax,%edx
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af9:	e9 24 02 00 00       	jmp    802d22 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802afe:	a1 40 51 80 00       	mov    0x805140,%eax
  802b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0a:	74 07                	je     802b13 <alloc_block_NF+0x3bc>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	eb 05                	jmp    802b18 <alloc_block_NF+0x3c1>
  802b13:	b8 00 00 00 00       	mov    $0x0,%eax
  802b18:	a3 40 51 80 00       	mov    %eax,0x805140
  802b1d:	a1 40 51 80 00       	mov    0x805140,%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	0f 85 2b fe ff ff    	jne    802955 <alloc_block_NF+0x1fe>
  802b2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2e:	0f 85 21 fe ff ff    	jne    802955 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b34:	a1 38 51 80 00       	mov    0x805138,%eax
  802b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b3c:	e9 ae 01 00 00       	jmp    802cef <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 50 08             	mov    0x8(%eax),%edx
  802b47:	a1 28 50 80 00       	mov    0x805028,%eax
  802b4c:	39 c2                	cmp    %eax,%edx
  802b4e:	0f 83 93 01 00 00    	jae    802ce7 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5d:	0f 82 84 01 00 00    	jb     802ce7 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 40 0c             	mov    0xc(%eax),%eax
  802b69:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b6c:	0f 85 95 00 00 00    	jne    802c07 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b76:	75 17                	jne    802b8f <alloc_block_NF+0x438>
  802b78:	83 ec 04             	sub    $0x4,%esp
  802b7b:	68 68 40 80 00       	push   $0x804068
  802b80:	68 14 01 00 00       	push   $0x114
  802b85:	68 bf 3f 80 00       	push   $0x803fbf
  802b8a:	e8 0e d8 ff ff       	call   80039d <_panic>
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 10                	je     802ba8 <alloc_block_NF+0x451>
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba0:	8b 52 04             	mov    0x4(%edx),%edx
  802ba3:	89 50 04             	mov    %edx,0x4(%eax)
  802ba6:	eb 0b                	jmp    802bb3 <alloc_block_NF+0x45c>
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 40 04             	mov    0x4(%eax),%eax
  802bae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 40 04             	mov    0x4(%eax),%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	74 0f                	je     802bcc <alloc_block_NF+0x475>
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 40 04             	mov    0x4(%eax),%eax
  802bc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc6:	8b 12                	mov    (%edx),%edx
  802bc8:	89 10                	mov    %edx,(%eax)
  802bca:	eb 0a                	jmp    802bd6 <alloc_block_NF+0x47f>
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 00                	mov    (%eax),%eax
  802bd1:	a3 38 51 80 00       	mov    %eax,0x805138
  802bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be9:	a1 44 51 80 00       	mov    0x805144,%eax
  802bee:	48                   	dec    %eax
  802bef:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 40 08             	mov    0x8(%eax),%eax
  802bfa:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	e9 1b 01 00 00       	jmp    802d22 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c10:	0f 86 d1 00 00 00    	jbe    802ce7 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c16:	a1 48 51 80 00       	mov    0x805148,%eax
  802c1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 50 08             	mov    0x8(%eax),%edx
  802c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c27:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c30:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c37:	75 17                	jne    802c50 <alloc_block_NF+0x4f9>
  802c39:	83 ec 04             	sub    $0x4,%esp
  802c3c:	68 68 40 80 00       	push   $0x804068
  802c41:	68 1c 01 00 00       	push   $0x11c
  802c46:	68 bf 3f 80 00       	push   $0x803fbf
  802c4b:	e8 4d d7 ff ff       	call   80039d <_panic>
  802c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 10                	je     802c69 <alloc_block_NF+0x512>
  802c59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5c:	8b 00                	mov    (%eax),%eax
  802c5e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c61:	8b 52 04             	mov    0x4(%edx),%edx
  802c64:	89 50 04             	mov    %edx,0x4(%eax)
  802c67:	eb 0b                	jmp    802c74 <alloc_block_NF+0x51d>
  802c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6c:	8b 40 04             	mov    0x4(%eax),%eax
  802c6f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c77:	8b 40 04             	mov    0x4(%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 0f                	je     802c8d <alloc_block_NF+0x536>
  802c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c81:	8b 40 04             	mov    0x4(%eax),%eax
  802c84:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c87:	8b 12                	mov    (%edx),%edx
  802c89:	89 10                	mov    %edx,(%eax)
  802c8b:	eb 0a                	jmp    802c97 <alloc_block_NF+0x540>
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	a3 48 51 80 00       	mov    %eax,0x805148
  802c97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802caa:	a1 54 51 80 00       	mov    0x805154,%eax
  802caf:	48                   	dec    %eax
  802cb0:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb8:	8b 40 08             	mov    0x8(%eax),%eax
  802cbb:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 50 08             	mov    0x8(%eax),%edx
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	01 c2                	add    %eax,%edx
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd7:	2b 45 08             	sub    0x8(%ebp),%eax
  802cda:	89 c2                	mov    %eax,%edx
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce5:	eb 3b                	jmp    802d22 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ce7:	a1 40 51 80 00       	mov    0x805140,%eax
  802cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf3:	74 07                	je     802cfc <alloc_block_NF+0x5a5>
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 00                	mov    (%eax),%eax
  802cfa:	eb 05                	jmp    802d01 <alloc_block_NF+0x5aa>
  802cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  802d01:	a3 40 51 80 00       	mov    %eax,0x805140
  802d06:	a1 40 51 80 00       	mov    0x805140,%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	0f 85 2e fe ff ff    	jne    802b41 <alloc_block_NF+0x3ea>
  802d13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d17:	0f 85 24 fe ff ff    	jne    802b41 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d22:	c9                   	leave  
  802d23:	c3                   	ret    

00802d24 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d24:	55                   	push   %ebp
  802d25:	89 e5                	mov    %esp,%ebp
  802d27:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d2a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d32:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d37:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d3a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 14                	je     802d57 <insert_sorted_with_merge_freeList+0x33>
  802d43:	8b 45 08             	mov    0x8(%ebp),%eax
  802d46:	8b 50 08             	mov    0x8(%eax),%edx
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	39 c2                	cmp    %eax,%edx
  802d51:	0f 87 9b 01 00 00    	ja     802ef2 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5b:	75 17                	jne    802d74 <insert_sorted_with_merge_freeList+0x50>
  802d5d:	83 ec 04             	sub    $0x4,%esp
  802d60:	68 9c 3f 80 00       	push   $0x803f9c
  802d65:	68 38 01 00 00       	push   $0x138
  802d6a:	68 bf 3f 80 00       	push   $0x803fbf
  802d6f:	e8 29 d6 ff ff       	call   80039d <_panic>
  802d74:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	89 10                	mov    %edx,(%eax)
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	8b 00                	mov    (%eax),%eax
  802d84:	85 c0                	test   %eax,%eax
  802d86:	74 0d                	je     802d95 <insert_sorted_with_merge_freeList+0x71>
  802d88:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d90:	89 50 04             	mov    %edx,0x4(%eax)
  802d93:	eb 08                	jmp    802d9d <insert_sorted_with_merge_freeList+0x79>
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	a3 38 51 80 00       	mov    %eax,0x805138
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802daf:	a1 44 51 80 00       	mov    0x805144,%eax
  802db4:	40                   	inc    %eax
  802db5:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dbe:	0f 84 a8 06 00 00    	je     80346c <insert_sorted_with_merge_freeList+0x748>
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	8b 50 08             	mov    0x8(%eax),%edx
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd0:	01 c2                	add    %eax,%edx
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	8b 40 08             	mov    0x8(%eax),%eax
  802dd8:	39 c2                	cmp    %eax,%edx
  802dda:	0f 85 8c 06 00 00    	jne    80346c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 50 0c             	mov    0xc(%eax),%edx
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dec:	01 c2                	add    %eax,%edx
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802df4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df8:	75 17                	jne    802e11 <insert_sorted_with_merge_freeList+0xed>
  802dfa:	83 ec 04             	sub    $0x4,%esp
  802dfd:	68 68 40 80 00       	push   $0x804068
  802e02:	68 3c 01 00 00       	push   $0x13c
  802e07:	68 bf 3f 80 00       	push   $0x803fbf
  802e0c:	e8 8c d5 ff ff       	call   80039d <_panic>
  802e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 10                	je     802e2a <insert_sorted_with_merge_freeList+0x106>
  802e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e22:	8b 52 04             	mov    0x4(%edx),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 0b                	jmp    802e35 <insert_sorted_with_merge_freeList+0x111>
  802e2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2d:	8b 40 04             	mov    0x4(%eax),%eax
  802e30:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0f                	je     802e4e <insert_sorted_with_merge_freeList+0x12a>
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e48:	8b 12                	mov    (%edx),%edx
  802e4a:	89 10                	mov    %edx,(%eax)
  802e4c:	eb 0a                	jmp    802e58 <insert_sorted_with_merge_freeList+0x134>
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	a3 38 51 80 00       	mov    %eax,0x805138
  802e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6b:	a1 44 51 80 00       	mov    0x805144,%eax
  802e70:	48                   	dec    %eax
  802e71:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e8e:	75 17                	jne    802ea7 <insert_sorted_with_merge_freeList+0x183>
  802e90:	83 ec 04             	sub    $0x4,%esp
  802e93:	68 9c 3f 80 00       	push   $0x803f9c
  802e98:	68 3f 01 00 00       	push   $0x13f
  802e9d:	68 bf 3f 80 00       	push   $0x803fbf
  802ea2:	e8 f6 d4 ff ff       	call   80039d <_panic>
  802ea7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	89 10                	mov    %edx,(%eax)
  802eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb5:	8b 00                	mov    (%eax),%eax
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	74 0d                	je     802ec8 <insert_sorted_with_merge_freeList+0x1a4>
  802ebb:	a1 48 51 80 00       	mov    0x805148,%eax
  802ec0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec3:	89 50 04             	mov    %edx,0x4(%eax)
  802ec6:	eb 08                	jmp    802ed0 <insert_sorted_with_merge_freeList+0x1ac>
  802ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed3:	a3 48 51 80 00       	mov    %eax,0x805148
  802ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee2:	a1 54 51 80 00       	mov    0x805154,%eax
  802ee7:	40                   	inc    %eax
  802ee8:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eed:	e9 7a 05 00 00       	jmp    80346c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	8b 50 08             	mov    0x8(%eax),%edx
  802ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efb:	8b 40 08             	mov    0x8(%eax),%eax
  802efe:	39 c2                	cmp    %eax,%edx
  802f00:	0f 82 14 01 00 00    	jb     80301a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f09:	8b 50 08             	mov    0x8(%eax),%edx
  802f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f12:	01 c2                	add    %eax,%edx
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	8b 40 08             	mov    0x8(%eax),%eax
  802f1a:	39 c2                	cmp    %eax,%edx
  802f1c:	0f 85 90 00 00 00    	jne    802fb2 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	8b 50 0c             	mov    0xc(%eax),%edx
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2e:	01 c2                	add    %eax,%edx
  802f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f33:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4e:	75 17                	jne    802f67 <insert_sorted_with_merge_freeList+0x243>
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	68 9c 3f 80 00       	push   $0x803f9c
  802f58:	68 49 01 00 00       	push   $0x149
  802f5d:	68 bf 3f 80 00       	push   $0x803fbf
  802f62:	e8 36 d4 ff ff       	call   80039d <_panic>
  802f67:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	89 10                	mov    %edx,(%eax)
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	74 0d                	je     802f88 <insert_sorted_with_merge_freeList+0x264>
  802f7b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f80:	8b 55 08             	mov    0x8(%ebp),%edx
  802f83:	89 50 04             	mov    %edx,0x4(%eax)
  802f86:	eb 08                	jmp    802f90 <insert_sorted_with_merge_freeList+0x26c>
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	a3 48 51 80 00       	mov    %eax,0x805148
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa2:	a1 54 51 80 00       	mov    0x805154,%eax
  802fa7:	40                   	inc    %eax
  802fa8:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fad:	e9 bb 04 00 00       	jmp    80346d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb6:	75 17                	jne    802fcf <insert_sorted_with_merge_freeList+0x2ab>
  802fb8:	83 ec 04             	sub    $0x4,%esp
  802fbb:	68 10 40 80 00       	push   $0x804010
  802fc0:	68 4c 01 00 00       	push   $0x14c
  802fc5:	68 bf 3f 80 00       	push   $0x803fbf
  802fca:	e8 ce d3 ff ff       	call   80039d <_panic>
  802fcf:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	89 50 04             	mov    %edx,0x4(%eax)
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	8b 40 04             	mov    0x4(%eax),%eax
  802fe1:	85 c0                	test   %eax,%eax
  802fe3:	74 0c                	je     802ff1 <insert_sorted_with_merge_freeList+0x2cd>
  802fe5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fea:	8b 55 08             	mov    0x8(%ebp),%edx
  802fed:	89 10                	mov    %edx,(%eax)
  802fef:	eb 08                	jmp    802ff9 <insert_sorted_with_merge_freeList+0x2d5>
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300a:	a1 44 51 80 00       	mov    0x805144,%eax
  80300f:	40                   	inc    %eax
  803010:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803015:	e9 53 04 00 00       	jmp    80346d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80301a:	a1 38 51 80 00       	mov    0x805138,%eax
  80301f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803022:	e9 15 04 00 00       	jmp    80343c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	8b 50 08             	mov    0x8(%eax),%edx
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 40 08             	mov    0x8(%eax),%eax
  80303b:	39 c2                	cmp    %eax,%edx
  80303d:	0f 86 f1 03 00 00    	jbe    803434 <insert_sorted_with_merge_freeList+0x710>
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 50 08             	mov    0x8(%eax),%edx
  803049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304c:	8b 40 08             	mov    0x8(%eax),%eax
  80304f:	39 c2                	cmp    %eax,%edx
  803051:	0f 83 dd 03 00 00    	jae    803434 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 50 08             	mov    0x8(%eax),%edx
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 40 0c             	mov    0xc(%eax),%eax
  803063:	01 c2                	add    %eax,%edx
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	8b 40 08             	mov    0x8(%eax),%eax
  80306b:	39 c2                	cmp    %eax,%edx
  80306d:	0f 85 b9 01 00 00    	jne    80322c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	8b 50 08             	mov    0x8(%eax),%edx
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	8b 40 0c             	mov    0xc(%eax),%eax
  80307f:	01 c2                	add    %eax,%edx
  803081:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803084:	8b 40 08             	mov    0x8(%eax),%eax
  803087:	39 c2                	cmp    %eax,%edx
  803089:	0f 85 0d 01 00 00    	jne    80319c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 50 0c             	mov    0xc(%eax),%edx
  803095:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803098:	8b 40 0c             	mov    0xc(%eax),%eax
  80309b:	01 c2                	add    %eax,%edx
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030a3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030a7:	75 17                	jne    8030c0 <insert_sorted_with_merge_freeList+0x39c>
  8030a9:	83 ec 04             	sub    $0x4,%esp
  8030ac:	68 68 40 80 00       	push   $0x804068
  8030b1:	68 5c 01 00 00       	push   $0x15c
  8030b6:	68 bf 3f 80 00       	push   $0x803fbf
  8030bb:	e8 dd d2 ff ff       	call   80039d <_panic>
  8030c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 10                	je     8030d9 <insert_sorted_with_merge_freeList+0x3b5>
  8030c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d1:	8b 52 04             	mov    0x4(%edx),%edx
  8030d4:	89 50 04             	mov    %edx,0x4(%eax)
  8030d7:	eb 0b                	jmp    8030e4 <insert_sorted_with_merge_freeList+0x3c0>
  8030d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030dc:	8b 40 04             	mov    0x4(%eax),%eax
  8030df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ea:	85 c0                	test   %eax,%eax
  8030ec:	74 0f                	je     8030fd <insert_sorted_with_merge_freeList+0x3d9>
  8030ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f1:	8b 40 04             	mov    0x4(%eax),%eax
  8030f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f7:	8b 12                	mov    (%edx),%edx
  8030f9:	89 10                	mov    %edx,(%eax)
  8030fb:	eb 0a                	jmp    803107 <insert_sorted_with_merge_freeList+0x3e3>
  8030fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803100:	8b 00                	mov    (%eax),%eax
  803102:	a3 38 51 80 00       	mov    %eax,0x805138
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311a:	a1 44 51 80 00       	mov    0x805144,%eax
  80311f:	48                   	dec    %eax
  803120:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803128:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80312f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803132:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803139:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313d:	75 17                	jne    803156 <insert_sorted_with_merge_freeList+0x432>
  80313f:	83 ec 04             	sub    $0x4,%esp
  803142:	68 9c 3f 80 00       	push   $0x803f9c
  803147:	68 5f 01 00 00       	push   $0x15f
  80314c:	68 bf 3f 80 00       	push   $0x803fbf
  803151:	e8 47 d2 ff ff       	call   80039d <_panic>
  803156:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	89 10                	mov    %edx,(%eax)
  803161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 0d                	je     803177 <insert_sorted_with_merge_freeList+0x453>
  80316a:	a1 48 51 80 00       	mov    0x805148,%eax
  80316f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803172:	89 50 04             	mov    %edx,0x4(%eax)
  803175:	eb 08                	jmp    80317f <insert_sorted_with_merge_freeList+0x45b>
  803177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803182:	a3 48 51 80 00       	mov    %eax,0x805148
  803187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803191:	a1 54 51 80 00       	mov    0x805154,%eax
  803196:	40                   	inc    %eax
  803197:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80319c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319f:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a8:	01 c2                	add    %eax,%edx
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c8:	75 17                	jne    8031e1 <insert_sorted_with_merge_freeList+0x4bd>
  8031ca:	83 ec 04             	sub    $0x4,%esp
  8031cd:	68 9c 3f 80 00       	push   $0x803f9c
  8031d2:	68 64 01 00 00       	push   $0x164
  8031d7:	68 bf 3f 80 00       	push   $0x803fbf
  8031dc:	e8 bc d1 ff ff       	call   80039d <_panic>
  8031e1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	89 10                	mov    %edx,(%eax)
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 0d                	je     803202 <insert_sorted_with_merge_freeList+0x4de>
  8031f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8031fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8031fd:	89 50 04             	mov    %edx,0x4(%eax)
  803200:	eb 08                	jmp    80320a <insert_sorted_with_merge_freeList+0x4e6>
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	a3 48 51 80 00       	mov    %eax,0x805148
  803212:	8b 45 08             	mov    0x8(%ebp),%eax
  803215:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321c:	a1 54 51 80 00       	mov    0x805154,%eax
  803221:	40                   	inc    %eax
  803222:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803227:	e9 41 02 00 00       	jmp    80346d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	8b 50 08             	mov    0x8(%eax),%edx
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	8b 40 0c             	mov    0xc(%eax),%eax
  803238:	01 c2                	add    %eax,%edx
  80323a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323d:	8b 40 08             	mov    0x8(%eax),%eax
  803240:	39 c2                	cmp    %eax,%edx
  803242:	0f 85 7c 01 00 00    	jne    8033c4 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803248:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80324c:	74 06                	je     803254 <insert_sorted_with_merge_freeList+0x530>
  80324e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803252:	75 17                	jne    80326b <insert_sorted_with_merge_freeList+0x547>
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	68 d8 3f 80 00       	push   $0x803fd8
  80325c:	68 69 01 00 00       	push   $0x169
  803261:	68 bf 3f 80 00       	push   $0x803fbf
  803266:	e8 32 d1 ff ff       	call   80039d <_panic>
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	8b 50 04             	mov    0x4(%eax),%edx
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	89 50 04             	mov    %edx,0x4(%eax)
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80327d:	89 10                	mov    %edx,(%eax)
  80327f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803282:	8b 40 04             	mov    0x4(%eax),%eax
  803285:	85 c0                	test   %eax,%eax
  803287:	74 0d                	je     803296 <insert_sorted_with_merge_freeList+0x572>
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	8b 40 04             	mov    0x4(%eax),%eax
  80328f:	8b 55 08             	mov    0x8(%ebp),%edx
  803292:	89 10                	mov    %edx,(%eax)
  803294:	eb 08                	jmp    80329e <insert_sorted_with_merge_freeList+0x57a>
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	a3 38 51 80 00       	mov    %eax,0x805138
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a4:	89 50 04             	mov    %edx,0x4(%eax)
  8032a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ac:	40                   	inc    %eax
  8032ad:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	8b 50 0c             	mov    0xc(%eax),%edx
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032be:	01 c2                	add    %eax,%edx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032c6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ca:	75 17                	jne    8032e3 <insert_sorted_with_merge_freeList+0x5bf>
  8032cc:	83 ec 04             	sub    $0x4,%esp
  8032cf:	68 68 40 80 00       	push   $0x804068
  8032d4:	68 6b 01 00 00       	push   $0x16b
  8032d9:	68 bf 3f 80 00       	push   $0x803fbf
  8032de:	e8 ba d0 ff ff       	call   80039d <_panic>
  8032e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	85 c0                	test   %eax,%eax
  8032ea:	74 10                	je     8032fc <insert_sorted_with_merge_freeList+0x5d8>
  8032ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ef:	8b 00                	mov    (%eax),%eax
  8032f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f4:	8b 52 04             	mov    0x4(%edx),%edx
  8032f7:	89 50 04             	mov    %edx,0x4(%eax)
  8032fa:	eb 0b                	jmp    803307 <insert_sorted_with_merge_freeList+0x5e3>
  8032fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ff:	8b 40 04             	mov    0x4(%eax),%eax
  803302:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803307:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330a:	8b 40 04             	mov    0x4(%eax),%eax
  80330d:	85 c0                	test   %eax,%eax
  80330f:	74 0f                	je     803320 <insert_sorted_with_merge_freeList+0x5fc>
  803311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803314:	8b 40 04             	mov    0x4(%eax),%eax
  803317:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331a:	8b 12                	mov    (%edx),%edx
  80331c:	89 10                	mov    %edx,(%eax)
  80331e:	eb 0a                	jmp    80332a <insert_sorted_with_merge_freeList+0x606>
  803320:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803323:	8b 00                	mov    (%eax),%eax
  803325:	a3 38 51 80 00       	mov    %eax,0x805138
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803333:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803336:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333d:	a1 44 51 80 00       	mov    0x805144,%eax
  803342:	48                   	dec    %eax
  803343:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803348:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803352:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803355:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80335c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803360:	75 17                	jne    803379 <insert_sorted_with_merge_freeList+0x655>
  803362:	83 ec 04             	sub    $0x4,%esp
  803365:	68 9c 3f 80 00       	push   $0x803f9c
  80336a:	68 6e 01 00 00       	push   $0x16e
  80336f:	68 bf 3f 80 00       	push   $0x803fbf
  803374:	e8 24 d0 ff ff       	call   80039d <_panic>
  803379:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	89 10                	mov    %edx,(%eax)
  803384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0d                	je     80339a <insert_sorted_with_merge_freeList+0x676>
  80338d:	a1 48 51 80 00       	mov    0x805148,%eax
  803392:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803395:	89 50 04             	mov    %edx,0x4(%eax)
  803398:	eb 08                	jmp    8033a2 <insert_sorted_with_merge_freeList+0x67e>
  80339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8033aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8033b9:	40                   	inc    %eax
  8033ba:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033bf:	e9 a9 00 00 00       	jmp    80346d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c8:	74 06                	je     8033d0 <insert_sorted_with_merge_freeList+0x6ac>
  8033ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ce:	75 17                	jne    8033e7 <insert_sorted_with_merge_freeList+0x6c3>
  8033d0:	83 ec 04             	sub    $0x4,%esp
  8033d3:	68 34 40 80 00       	push   $0x804034
  8033d8:	68 73 01 00 00       	push   $0x173
  8033dd:	68 bf 3f 80 00       	push   $0x803fbf
  8033e2:	e8 b6 cf ff ff       	call   80039d <_panic>
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	8b 10                	mov    (%eax),%edx
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	89 10                	mov    %edx,(%eax)
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	8b 00                	mov    (%eax),%eax
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	74 0b                	je     803405 <insert_sorted_with_merge_freeList+0x6e1>
  8033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803402:	89 50 04             	mov    %edx,0x4(%eax)
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	8b 55 08             	mov    0x8(%ebp),%edx
  80340b:	89 10                	mov    %edx,(%eax)
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803413:	89 50 04             	mov    %edx,0x4(%eax)
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	75 08                	jne    803427 <insert_sorted_with_merge_freeList+0x703>
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803427:	a1 44 51 80 00       	mov    0x805144,%eax
  80342c:	40                   	inc    %eax
  80342d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803432:	eb 39                	jmp    80346d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803434:	a1 40 51 80 00       	mov    0x805140,%eax
  803439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80343c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803440:	74 07                	je     803449 <insert_sorted_with_merge_freeList+0x725>
  803442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803445:	8b 00                	mov    (%eax),%eax
  803447:	eb 05                	jmp    80344e <insert_sorted_with_merge_freeList+0x72a>
  803449:	b8 00 00 00 00       	mov    $0x0,%eax
  80344e:	a3 40 51 80 00       	mov    %eax,0x805140
  803453:	a1 40 51 80 00       	mov    0x805140,%eax
  803458:	85 c0                	test   %eax,%eax
  80345a:	0f 85 c7 fb ff ff    	jne    803027 <insert_sorted_with_merge_freeList+0x303>
  803460:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803464:	0f 85 bd fb ff ff    	jne    803027 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80346a:	eb 01                	jmp    80346d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80346c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80346d:	90                   	nop
  80346e:	c9                   	leave  
  80346f:	c3                   	ret    

00803470 <__udivdi3>:
  803470:	55                   	push   %ebp
  803471:	57                   	push   %edi
  803472:	56                   	push   %esi
  803473:	53                   	push   %ebx
  803474:	83 ec 1c             	sub    $0x1c,%esp
  803477:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80347b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80347f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803483:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803487:	89 ca                	mov    %ecx,%edx
  803489:	89 f8                	mov    %edi,%eax
  80348b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80348f:	85 f6                	test   %esi,%esi
  803491:	75 2d                	jne    8034c0 <__udivdi3+0x50>
  803493:	39 cf                	cmp    %ecx,%edi
  803495:	77 65                	ja     8034fc <__udivdi3+0x8c>
  803497:	89 fd                	mov    %edi,%ebp
  803499:	85 ff                	test   %edi,%edi
  80349b:	75 0b                	jne    8034a8 <__udivdi3+0x38>
  80349d:	b8 01 00 00 00       	mov    $0x1,%eax
  8034a2:	31 d2                	xor    %edx,%edx
  8034a4:	f7 f7                	div    %edi
  8034a6:	89 c5                	mov    %eax,%ebp
  8034a8:	31 d2                	xor    %edx,%edx
  8034aa:	89 c8                	mov    %ecx,%eax
  8034ac:	f7 f5                	div    %ebp
  8034ae:	89 c1                	mov    %eax,%ecx
  8034b0:	89 d8                	mov    %ebx,%eax
  8034b2:	f7 f5                	div    %ebp
  8034b4:	89 cf                	mov    %ecx,%edi
  8034b6:	89 fa                	mov    %edi,%edx
  8034b8:	83 c4 1c             	add    $0x1c,%esp
  8034bb:	5b                   	pop    %ebx
  8034bc:	5e                   	pop    %esi
  8034bd:	5f                   	pop    %edi
  8034be:	5d                   	pop    %ebp
  8034bf:	c3                   	ret    
  8034c0:	39 ce                	cmp    %ecx,%esi
  8034c2:	77 28                	ja     8034ec <__udivdi3+0x7c>
  8034c4:	0f bd fe             	bsr    %esi,%edi
  8034c7:	83 f7 1f             	xor    $0x1f,%edi
  8034ca:	75 40                	jne    80350c <__udivdi3+0x9c>
  8034cc:	39 ce                	cmp    %ecx,%esi
  8034ce:	72 0a                	jb     8034da <__udivdi3+0x6a>
  8034d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034d4:	0f 87 9e 00 00 00    	ja     803578 <__udivdi3+0x108>
  8034da:	b8 01 00 00 00       	mov    $0x1,%eax
  8034df:	89 fa                	mov    %edi,%edx
  8034e1:	83 c4 1c             	add    $0x1c,%esp
  8034e4:	5b                   	pop    %ebx
  8034e5:	5e                   	pop    %esi
  8034e6:	5f                   	pop    %edi
  8034e7:	5d                   	pop    %ebp
  8034e8:	c3                   	ret    
  8034e9:	8d 76 00             	lea    0x0(%esi),%esi
  8034ec:	31 ff                	xor    %edi,%edi
  8034ee:	31 c0                	xor    %eax,%eax
  8034f0:	89 fa                	mov    %edi,%edx
  8034f2:	83 c4 1c             	add    $0x1c,%esp
  8034f5:	5b                   	pop    %ebx
  8034f6:	5e                   	pop    %esi
  8034f7:	5f                   	pop    %edi
  8034f8:	5d                   	pop    %ebp
  8034f9:	c3                   	ret    
  8034fa:	66 90                	xchg   %ax,%ax
  8034fc:	89 d8                	mov    %ebx,%eax
  8034fe:	f7 f7                	div    %edi
  803500:	31 ff                	xor    %edi,%edi
  803502:	89 fa                	mov    %edi,%edx
  803504:	83 c4 1c             	add    $0x1c,%esp
  803507:	5b                   	pop    %ebx
  803508:	5e                   	pop    %esi
  803509:	5f                   	pop    %edi
  80350a:	5d                   	pop    %ebp
  80350b:	c3                   	ret    
  80350c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803511:	89 eb                	mov    %ebp,%ebx
  803513:	29 fb                	sub    %edi,%ebx
  803515:	89 f9                	mov    %edi,%ecx
  803517:	d3 e6                	shl    %cl,%esi
  803519:	89 c5                	mov    %eax,%ebp
  80351b:	88 d9                	mov    %bl,%cl
  80351d:	d3 ed                	shr    %cl,%ebp
  80351f:	89 e9                	mov    %ebp,%ecx
  803521:	09 f1                	or     %esi,%ecx
  803523:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803527:	89 f9                	mov    %edi,%ecx
  803529:	d3 e0                	shl    %cl,%eax
  80352b:	89 c5                	mov    %eax,%ebp
  80352d:	89 d6                	mov    %edx,%esi
  80352f:	88 d9                	mov    %bl,%cl
  803531:	d3 ee                	shr    %cl,%esi
  803533:	89 f9                	mov    %edi,%ecx
  803535:	d3 e2                	shl    %cl,%edx
  803537:	8b 44 24 08          	mov    0x8(%esp),%eax
  80353b:	88 d9                	mov    %bl,%cl
  80353d:	d3 e8                	shr    %cl,%eax
  80353f:	09 c2                	or     %eax,%edx
  803541:	89 d0                	mov    %edx,%eax
  803543:	89 f2                	mov    %esi,%edx
  803545:	f7 74 24 0c          	divl   0xc(%esp)
  803549:	89 d6                	mov    %edx,%esi
  80354b:	89 c3                	mov    %eax,%ebx
  80354d:	f7 e5                	mul    %ebp
  80354f:	39 d6                	cmp    %edx,%esi
  803551:	72 19                	jb     80356c <__udivdi3+0xfc>
  803553:	74 0b                	je     803560 <__udivdi3+0xf0>
  803555:	89 d8                	mov    %ebx,%eax
  803557:	31 ff                	xor    %edi,%edi
  803559:	e9 58 ff ff ff       	jmp    8034b6 <__udivdi3+0x46>
  80355e:	66 90                	xchg   %ax,%ax
  803560:	8b 54 24 08          	mov    0x8(%esp),%edx
  803564:	89 f9                	mov    %edi,%ecx
  803566:	d3 e2                	shl    %cl,%edx
  803568:	39 c2                	cmp    %eax,%edx
  80356a:	73 e9                	jae    803555 <__udivdi3+0xe5>
  80356c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80356f:	31 ff                	xor    %edi,%edi
  803571:	e9 40 ff ff ff       	jmp    8034b6 <__udivdi3+0x46>
  803576:	66 90                	xchg   %ax,%ax
  803578:	31 c0                	xor    %eax,%eax
  80357a:	e9 37 ff ff ff       	jmp    8034b6 <__udivdi3+0x46>
  80357f:	90                   	nop

00803580 <__umoddi3>:
  803580:	55                   	push   %ebp
  803581:	57                   	push   %edi
  803582:	56                   	push   %esi
  803583:	53                   	push   %ebx
  803584:	83 ec 1c             	sub    $0x1c,%esp
  803587:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80358b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80358f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803593:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803597:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80359b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80359f:	89 f3                	mov    %esi,%ebx
  8035a1:	89 fa                	mov    %edi,%edx
  8035a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035a7:	89 34 24             	mov    %esi,(%esp)
  8035aa:	85 c0                	test   %eax,%eax
  8035ac:	75 1a                	jne    8035c8 <__umoddi3+0x48>
  8035ae:	39 f7                	cmp    %esi,%edi
  8035b0:	0f 86 a2 00 00 00    	jbe    803658 <__umoddi3+0xd8>
  8035b6:	89 c8                	mov    %ecx,%eax
  8035b8:	89 f2                	mov    %esi,%edx
  8035ba:	f7 f7                	div    %edi
  8035bc:	89 d0                	mov    %edx,%eax
  8035be:	31 d2                	xor    %edx,%edx
  8035c0:	83 c4 1c             	add    $0x1c,%esp
  8035c3:	5b                   	pop    %ebx
  8035c4:	5e                   	pop    %esi
  8035c5:	5f                   	pop    %edi
  8035c6:	5d                   	pop    %ebp
  8035c7:	c3                   	ret    
  8035c8:	39 f0                	cmp    %esi,%eax
  8035ca:	0f 87 ac 00 00 00    	ja     80367c <__umoddi3+0xfc>
  8035d0:	0f bd e8             	bsr    %eax,%ebp
  8035d3:	83 f5 1f             	xor    $0x1f,%ebp
  8035d6:	0f 84 ac 00 00 00    	je     803688 <__umoddi3+0x108>
  8035dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8035e1:	29 ef                	sub    %ebp,%edi
  8035e3:	89 fe                	mov    %edi,%esi
  8035e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035e9:	89 e9                	mov    %ebp,%ecx
  8035eb:	d3 e0                	shl    %cl,%eax
  8035ed:	89 d7                	mov    %edx,%edi
  8035ef:	89 f1                	mov    %esi,%ecx
  8035f1:	d3 ef                	shr    %cl,%edi
  8035f3:	09 c7                	or     %eax,%edi
  8035f5:	89 e9                	mov    %ebp,%ecx
  8035f7:	d3 e2                	shl    %cl,%edx
  8035f9:	89 14 24             	mov    %edx,(%esp)
  8035fc:	89 d8                	mov    %ebx,%eax
  8035fe:	d3 e0                	shl    %cl,%eax
  803600:	89 c2                	mov    %eax,%edx
  803602:	8b 44 24 08          	mov    0x8(%esp),%eax
  803606:	d3 e0                	shl    %cl,%eax
  803608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80360c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803610:	89 f1                	mov    %esi,%ecx
  803612:	d3 e8                	shr    %cl,%eax
  803614:	09 d0                	or     %edx,%eax
  803616:	d3 eb                	shr    %cl,%ebx
  803618:	89 da                	mov    %ebx,%edx
  80361a:	f7 f7                	div    %edi
  80361c:	89 d3                	mov    %edx,%ebx
  80361e:	f7 24 24             	mull   (%esp)
  803621:	89 c6                	mov    %eax,%esi
  803623:	89 d1                	mov    %edx,%ecx
  803625:	39 d3                	cmp    %edx,%ebx
  803627:	0f 82 87 00 00 00    	jb     8036b4 <__umoddi3+0x134>
  80362d:	0f 84 91 00 00 00    	je     8036c4 <__umoddi3+0x144>
  803633:	8b 54 24 04          	mov    0x4(%esp),%edx
  803637:	29 f2                	sub    %esi,%edx
  803639:	19 cb                	sbb    %ecx,%ebx
  80363b:	89 d8                	mov    %ebx,%eax
  80363d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803641:	d3 e0                	shl    %cl,%eax
  803643:	89 e9                	mov    %ebp,%ecx
  803645:	d3 ea                	shr    %cl,%edx
  803647:	09 d0                	or     %edx,%eax
  803649:	89 e9                	mov    %ebp,%ecx
  80364b:	d3 eb                	shr    %cl,%ebx
  80364d:	89 da                	mov    %ebx,%edx
  80364f:	83 c4 1c             	add    $0x1c,%esp
  803652:	5b                   	pop    %ebx
  803653:	5e                   	pop    %esi
  803654:	5f                   	pop    %edi
  803655:	5d                   	pop    %ebp
  803656:	c3                   	ret    
  803657:	90                   	nop
  803658:	89 fd                	mov    %edi,%ebp
  80365a:	85 ff                	test   %edi,%edi
  80365c:	75 0b                	jne    803669 <__umoddi3+0xe9>
  80365e:	b8 01 00 00 00       	mov    $0x1,%eax
  803663:	31 d2                	xor    %edx,%edx
  803665:	f7 f7                	div    %edi
  803667:	89 c5                	mov    %eax,%ebp
  803669:	89 f0                	mov    %esi,%eax
  80366b:	31 d2                	xor    %edx,%edx
  80366d:	f7 f5                	div    %ebp
  80366f:	89 c8                	mov    %ecx,%eax
  803671:	f7 f5                	div    %ebp
  803673:	89 d0                	mov    %edx,%eax
  803675:	e9 44 ff ff ff       	jmp    8035be <__umoddi3+0x3e>
  80367a:	66 90                	xchg   %ax,%ax
  80367c:	89 c8                	mov    %ecx,%eax
  80367e:	89 f2                	mov    %esi,%edx
  803680:	83 c4 1c             	add    $0x1c,%esp
  803683:	5b                   	pop    %ebx
  803684:	5e                   	pop    %esi
  803685:	5f                   	pop    %edi
  803686:	5d                   	pop    %ebp
  803687:	c3                   	ret    
  803688:	3b 04 24             	cmp    (%esp),%eax
  80368b:	72 06                	jb     803693 <__umoddi3+0x113>
  80368d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803691:	77 0f                	ja     8036a2 <__umoddi3+0x122>
  803693:	89 f2                	mov    %esi,%edx
  803695:	29 f9                	sub    %edi,%ecx
  803697:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80369b:	89 14 24             	mov    %edx,(%esp)
  80369e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036a6:	8b 14 24             	mov    (%esp),%edx
  8036a9:	83 c4 1c             	add    $0x1c,%esp
  8036ac:	5b                   	pop    %ebx
  8036ad:	5e                   	pop    %esi
  8036ae:	5f                   	pop    %edi
  8036af:	5d                   	pop    %ebp
  8036b0:	c3                   	ret    
  8036b1:	8d 76 00             	lea    0x0(%esi),%esi
  8036b4:	2b 04 24             	sub    (%esp),%eax
  8036b7:	19 fa                	sbb    %edi,%edx
  8036b9:	89 d1                	mov    %edx,%ecx
  8036bb:	89 c6                	mov    %eax,%esi
  8036bd:	e9 71 ff ff ff       	jmp    803633 <__umoddi3+0xb3>
  8036c2:	66 90                	xchg   %ax,%ax
  8036c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036c8:	72 ea                	jb     8036b4 <__umoddi3+0x134>
  8036ca:	89 d9                	mov    %ebx,%ecx
  8036cc:	e9 62 ff ff ff       	jmp    803633 <__umoddi3+0xb3>
