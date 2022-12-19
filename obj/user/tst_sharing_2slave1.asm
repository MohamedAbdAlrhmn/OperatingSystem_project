
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
  80008d:	68 20 38 80 00       	push   $0x803820
  800092:	6a 13                	push   $0x13
  800094:	68 3c 38 80 00       	push   $0x80383c
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
  8000ab:	e8 3f 1c 00 00       	call   801cef <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 2b 1a 00 00       	call   801ae3 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 39 19 00 00       	call   8019f6 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 57 38 80 00       	push   $0x803857
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 02 17 00 00       	call   8017d2 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 5c 38 80 00       	push   $0x80385c
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 3c 38 80 00       	push   $0x80383c
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 fb 18 00 00       	call   8019f6 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 bc 38 80 00       	push   $0x8038bc
  80010c:	6a 21                	push   $0x21
  80010e:	68 3c 38 80 00       	push   $0x80383c
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 e0 19 00 00       	call   801afd <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 c1 19 00 00       	call   801ae3 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 cf 18 00 00       	call   8019f6 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 4d 39 80 00       	push   $0x80394d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 98 16 00 00       	call   8017d2 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 5c 38 80 00       	push   $0x80385c
  800151:	6a 27                	push   $0x27
  800153:	68 3c 38 80 00       	push   $0x80383c
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 94 18 00 00       	call   8019f6 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 bc 38 80 00       	push   $0x8038bc
  800173:	6a 28                	push   $0x28
  800175:	68 3c 38 80 00       	push   $0x80383c
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 79 19 00 00       	call   801afd <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 50 39 80 00       	push   $0x803950
  800196:	6a 2b                	push   $0x2b
  800198:	68 3c 38 80 00       	push   $0x80383c
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 3c 19 00 00       	call   801ae3 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 4a 18 00 00       	call   8019f6 <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 87 39 80 00       	push   $0x803987
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 13 16 00 00       	call   8017d2 <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 5c 38 80 00       	push   $0x80385c
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 3c 38 80 00       	push   $0x80383c
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 0f 18 00 00       	call   8019f6 <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 bc 38 80 00       	push   $0x8038bc
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 3c 38 80 00       	push   $0x80383c
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 f4 18 00 00       	call   801afd <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 50 39 80 00       	push   $0x803950
  80021b:	6a 34                	push   $0x34
  80021d:	68 3c 38 80 00       	push   $0x80383c
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
  800245:	68 50 39 80 00       	push   $0x803950
  80024a:	6a 37                	push   $0x37
  80024c:	68 3c 38 80 00       	push   $0x80383c
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 b9 1b 00 00       	call   801e14 <inctst>

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
  800267:	e8 6a 1a 00 00       	call   801cd6 <sys_getenvindex>
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
  8002d2:	e8 0c 18 00 00       	call   801ae3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 a4 39 80 00       	push   $0x8039a4
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
  800302:	68 cc 39 80 00       	push   $0x8039cc
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
  800333:	68 f4 39 80 00       	push   $0x8039f4
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 50 80 00       	mov    0x805020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 4c 3a 80 00       	push   $0x803a4c
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 a4 39 80 00       	push   $0x8039a4
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 8c 17 00 00       	call   801afd <sys_enable_interrupt>

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
  800384:	e8 19 19 00 00       	call   801ca2 <sys_destroy_env>
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
  800395:	e8 6e 19 00 00       	call   801d08 <sys_exit_env>
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
  8003be:	68 60 3a 80 00       	push   $0x803a60
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 65 3a 80 00       	push   $0x803a65
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
  8003fb:	68 81 3a 80 00       	push   $0x803a81
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
  800427:	68 84 3a 80 00       	push   $0x803a84
  80042c:	6a 26                	push   $0x26
  80042e:	68 d0 3a 80 00       	push   $0x803ad0
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
  8004f9:	68 dc 3a 80 00       	push   $0x803adc
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 d0 3a 80 00       	push   $0x803ad0
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
  800569:	68 30 3b 80 00       	push   $0x803b30
  80056e:	6a 44                	push   $0x44
  800570:	68 d0 3a 80 00       	push   $0x803ad0
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
  8005c3:	e8 6d 13 00 00       	call   801935 <sys_cputs>
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
  80063a:	e8 f6 12 00 00       	call   801935 <sys_cputs>
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
  800684:	e8 5a 14 00 00       	call   801ae3 <sys_disable_interrupt>
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
  8006a4:	e8 54 14 00 00       	call   801afd <sys_enable_interrupt>
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
  8006ee:	e8 c5 2e 00 00       	call   8035b8 <__udivdi3>
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
  80073e:	e8 85 2f 00 00       	call   8036c8 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 94 3d 80 00       	add    $0x803d94,%eax
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
  800899:	8b 04 85 b8 3d 80 00 	mov    0x803db8(,%eax,4),%eax
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
  80097a:	8b 34 9d 00 3c 80 00 	mov    0x803c00(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 a5 3d 80 00       	push   $0x803da5
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
  80099f:	68 ae 3d 80 00       	push   $0x803dae
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
  8009cc:	be b1 3d 80 00       	mov    $0x803db1,%esi
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
  8013f2:	68 10 3f 80 00       	push   $0x803f10
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
  8014c2:	e8 b2 05 00 00       	call   801a79 <sys_allocate_chunk>
  8014c7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 27 0c 00 00       	call   8020ff <initialize_MemBlocksList>
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
  801500:	68 35 3f 80 00       	push   $0x803f35
  801505:	6a 33                	push   $0x33
  801507:	68 53 3f 80 00       	push   $0x803f53
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
  80157f:	68 60 3f 80 00       	push   $0x803f60
  801584:	6a 34                	push   $0x34
  801586:	68 53 3f 80 00       	push   $0x803f53
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
  801617:	e8 2b 08 00 00       	call   801e47 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80161c:	85 c0                	test   %eax,%eax
  80161e:	74 11                	je     801631 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801620:	83 ec 0c             	sub    $0xc,%esp
  801623:	ff 75 e8             	pushl  -0x18(%ebp)
  801626:	e8 96 0e 00 00       	call   8024c1 <alloc_block_FF>
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
  80163d:	e8 f2 0b 00 00       	call   802234 <insert_sorted_allocList>
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
  801657:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	83 ec 08             	sub    $0x8,%esp
  801660:	50                   	push   %eax
  801661:	68 40 50 80 00       	push   $0x805040
  801666:	e8 71 0b 00 00       	call   8021dc <find_block>
  80166b:	83 c4 10             	add    $0x10,%esp
  80166e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801675:	0f 84 a6 00 00 00    	je     801721 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  80167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167e:	8b 50 0c             	mov    0xc(%eax),%edx
  801681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801684:	8b 40 08             	mov    0x8(%eax),%eax
  801687:	83 ec 08             	sub    $0x8,%esp
  80168a:	52                   	push   %edx
  80168b:	50                   	push   %eax
  80168c:	e8 b0 03 00 00       	call   801a41 <sys_free_user_mem>
  801691:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801698:	75 14                	jne    8016ae <free+0x5a>
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	68 35 3f 80 00       	push   $0x803f35
  8016a2:	6a 74                	push   $0x74
  8016a4:	68 53 3f 80 00       	push   $0x803f53
  8016a9:	e8 ef ec ff ff       	call   80039d <_panic>
  8016ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b1:	8b 00                	mov    (%eax),%eax
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	74 10                	je     8016c7 <free+0x73>
  8016b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016bf:	8b 52 04             	mov    0x4(%edx),%edx
  8016c2:	89 50 04             	mov    %edx,0x4(%eax)
  8016c5:	eb 0b                	jmp    8016d2 <free+0x7e>
  8016c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ca:	8b 40 04             	mov    0x4(%eax),%eax
  8016cd:	a3 44 50 80 00       	mov    %eax,0x805044
  8016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d5:	8b 40 04             	mov    0x4(%eax),%eax
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	74 0f                	je     8016eb <free+0x97>
  8016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016df:	8b 40 04             	mov    0x4(%eax),%eax
  8016e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e5:	8b 12                	mov    (%edx),%edx
  8016e7:	89 10                	mov    %edx,(%eax)
  8016e9:	eb 0a                	jmp    8016f5 <free+0xa1>
  8016eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ee:	8b 00                	mov    (%eax),%eax
  8016f0:	a3 40 50 80 00       	mov    %eax,0x805040
  8016f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801701:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801708:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80170d:	48                   	dec    %eax
  80170e:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  801713:	83 ec 0c             	sub    $0xc,%esp
  801716:	ff 75 f4             	pushl  -0xc(%ebp)
  801719:	e8 4e 17 00 00       	call   802e6c <insert_sorted_with_merge_freeList>
  80171e:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801721:	90                   	nop
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	83 ec 38             	sub    $0x38,%esp
  80172a:	8b 45 10             	mov    0x10(%ebp),%eax
  80172d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801730:	e8 a6 fc ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  801735:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801739:	75 0a                	jne    801745 <smalloc+0x21>
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax
  801740:	e9 8b 00 00 00       	jmp    8017d0 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801745:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80174c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801752:	01 d0                	add    %edx,%eax
  801754:	48                   	dec    %eax
  801755:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175b:	ba 00 00 00 00       	mov    $0x0,%edx
  801760:	f7 75 f0             	divl   -0x10(%ebp)
  801763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801766:	29 d0                	sub    %edx,%eax
  801768:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80176b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801772:	e8 d0 06 00 00       	call   801e47 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801777:	85 c0                	test   %eax,%eax
  801779:	74 11                	je     80178c <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80177b:	83 ec 0c             	sub    $0xc,%esp
  80177e:	ff 75 e8             	pushl  -0x18(%ebp)
  801781:	e8 3b 0d 00 00       	call   8024c1 <alloc_block_FF>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80178c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801790:	74 39                	je     8017cb <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801795:	8b 40 08             	mov    0x8(%eax),%eax
  801798:	89 c2                	mov    %eax,%edx
  80179a:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80179e:	52                   	push   %edx
  80179f:	50                   	push   %eax
  8017a0:	ff 75 0c             	pushl  0xc(%ebp)
  8017a3:	ff 75 08             	pushl  0x8(%ebp)
  8017a6:	e8 21 04 00 00       	call   801bcc <sys_createSharedObject>
  8017ab:	83 c4 10             	add    $0x10,%esp
  8017ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8017b1:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8017b5:	74 14                	je     8017cb <smalloc+0xa7>
  8017b7:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8017bb:	74 0e                	je     8017cb <smalloc+0xa7>
  8017bd:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8017c1:	74 08                	je     8017cb <smalloc+0xa7>
			return (void*) mem_block->sva;
  8017c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c6:	8b 40 08             	mov    0x8(%eax),%eax
  8017c9:	eb 05                	jmp    8017d0 <smalloc+0xac>
	}
	return NULL;
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d8:	e8 fe fb ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 0b 04 00 00       	call   801bf6 <sys_getSizeOfSharedObject>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8017f1:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8017f5:	74 76                	je     80186d <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017f7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801801:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801804:	01 d0                	add    %edx,%eax
  801806:	48                   	dec    %eax
  801807:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80180a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180d:	ba 00 00 00 00       	mov    $0x0,%edx
  801812:	f7 75 ec             	divl   -0x14(%ebp)
  801815:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801818:	29 d0                	sub    %edx,%eax
  80181a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80181d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801824:	e8 1e 06 00 00       	call   801e47 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801829:	85 c0                	test   %eax,%eax
  80182b:	74 11                	je     80183e <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80182d:	83 ec 0c             	sub    $0xc,%esp
  801830:	ff 75 e4             	pushl  -0x1c(%ebp)
  801833:	e8 89 0c 00 00       	call   8024c1 <alloc_block_FF>
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80183e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801842:	74 29                	je     80186d <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	8b 40 08             	mov    0x8(%eax),%eax
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	50                   	push   %eax
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	e8 ba 03 00 00       	call   801c13 <sys_getSharedObject>
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80185f:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801863:	74 08                	je     80186d <sget+0x9b>
				return (void *)mem_block->sva;
  801865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801868:	8b 40 08             	mov    0x8(%eax),%eax
  80186b:	eb 05                	jmp    801872 <sget+0xa0>
		}
	}
	return NULL;
  80186d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80187a:	e8 5c fb ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80187f:	83 ec 04             	sub    $0x4,%esp
  801882:	68 84 3f 80 00       	push   $0x803f84
  801887:	68 f7 00 00 00       	push   $0xf7
  80188c:	68 53 3f 80 00       	push   $0x803f53
  801891:	e8 07 eb ff ff       	call   80039d <_panic>

00801896 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80189c:	83 ec 04             	sub    $0x4,%esp
  80189f:	68 ac 3f 80 00       	push   $0x803fac
  8018a4:	68 0b 01 00 00       	push   $0x10b
  8018a9:	68 53 3f 80 00       	push   $0x803f53
  8018ae:	e8 ea ea ff ff       	call   80039d <_panic>

008018b3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b9:	83 ec 04             	sub    $0x4,%esp
  8018bc:	68 d0 3f 80 00       	push   $0x803fd0
  8018c1:	68 16 01 00 00       	push   $0x116
  8018c6:	68 53 3f 80 00       	push   $0x803f53
  8018cb:	e8 cd ea ff ff       	call   80039d <_panic>

008018d0 <shrink>:

}
void shrink(uint32 newSize)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	68 d0 3f 80 00       	push   $0x803fd0
  8018de:	68 1b 01 00 00       	push   $0x11b
  8018e3:	68 53 3f 80 00       	push   $0x803f53
  8018e8:	e8 b0 ea ff ff       	call   80039d <_panic>

008018ed <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f3:	83 ec 04             	sub    $0x4,%esp
  8018f6:	68 d0 3f 80 00       	push   $0x803fd0
  8018fb:	68 20 01 00 00       	push   $0x120
  801900:	68 53 3f 80 00       	push   $0x803f53
  801905:	e8 93 ea ff ff       	call   80039d <_panic>

0080190a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	57                   	push   %edi
  80190e:	56                   	push   %esi
  80190f:	53                   	push   %ebx
  801910:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8b 55 0c             	mov    0xc(%ebp),%edx
  801919:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801922:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801925:	cd 30                	int    $0x30
  801927:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80192a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	5b                   	pop    %ebx
  801931:	5e                   	pop    %esi
  801932:	5f                   	pop    %edi
  801933:	5d                   	pop    %ebp
  801934:	c3                   	ret    

00801935 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	8b 45 10             	mov    0x10(%ebp),%eax
  80193e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801941:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	52                   	push   %edx
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	50                   	push   %eax
  801951:	6a 00                	push   $0x0
  801953:	e8 b2 ff ff ff       	call   80190a <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	90                   	nop
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <sys_cgetc>:

int
sys_cgetc(void)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 01                	push   $0x1
  80196d:	e8 98 ff ff ff       	call   80190a <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80197a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197d:	8b 45 08             	mov    0x8(%ebp),%eax
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	52                   	push   %edx
  801987:	50                   	push   %eax
  801988:	6a 05                	push   $0x5
  80198a:	e8 7b ff ff ff       	call   80190a <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	56                   	push   %esi
  801998:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801999:	8b 75 18             	mov    0x18(%ebp),%esi
  80199c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80199f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	56                   	push   %esi
  8019a9:	53                   	push   %ebx
  8019aa:	51                   	push   %ecx
  8019ab:	52                   	push   %edx
  8019ac:	50                   	push   %eax
  8019ad:	6a 06                	push   $0x6
  8019af:	e8 56 ff ff ff       	call   80190a <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ba:	5b                   	pop    %ebx
  8019bb:	5e                   	pop    %esi
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	52                   	push   %edx
  8019ce:	50                   	push   %eax
  8019cf:	6a 07                	push   $0x7
  8019d1:	e8 34 ff ff ff       	call   80190a <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	ff 75 0c             	pushl  0xc(%ebp)
  8019e7:	ff 75 08             	pushl  0x8(%ebp)
  8019ea:	6a 08                	push   $0x8
  8019ec:	e8 19 ff ff ff       	call   80190a <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 09                	push   $0x9
  801a05:	e8 00 ff ff ff       	call   80190a <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 0a                	push   $0xa
  801a1e:	e8 e7 fe ff ff       	call   80190a <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 0b                	push   $0xb
  801a37:	e8 ce fe ff ff       	call   80190a <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 0f                	push   $0xf
  801a52:	e8 b3 fe ff ff       	call   80190a <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	ff 75 0c             	pushl  0xc(%ebp)
  801a69:	ff 75 08             	pushl  0x8(%ebp)
  801a6c:	6a 10                	push   $0x10
  801a6e:	e8 97 fe ff ff       	call   80190a <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
	return ;
  801a76:	90                   	nop
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	ff 75 10             	pushl  0x10(%ebp)
  801a83:	ff 75 0c             	pushl  0xc(%ebp)
  801a86:	ff 75 08             	pushl  0x8(%ebp)
  801a89:	6a 11                	push   $0x11
  801a8b:	e8 7a fe ff ff       	call   80190a <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
	return ;
  801a93:	90                   	nop
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 0c                	push   $0xc
  801aa5:	e8 60 fe ff ff       	call   80190a <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	ff 75 08             	pushl  0x8(%ebp)
  801abd:	6a 0d                	push   $0xd
  801abf:	e8 46 fe ff ff       	call   80190a <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 0e                	push   $0xe
  801ad8:	e8 2d fe ff ff       	call   80190a <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	90                   	nop
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 13                	push   $0x13
  801af2:	e8 13 fe ff ff       	call   80190a <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	90                   	nop
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 14                	push   $0x14
  801b0c:	e8 f9 fd ff ff       	call   80190a <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	90                   	nop
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 04             	sub    $0x4,%esp
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b23:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	50                   	push   %eax
  801b30:	6a 15                	push   $0x15
  801b32:	e8 d3 fd ff ff       	call   80190a <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 16                	push   $0x16
  801b4c:	e8 b9 fd ff ff       	call   80190a <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	50                   	push   %eax
  801b67:	6a 17                	push   $0x17
  801b69:	e8 9c fd ff ff       	call   80190a <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	52                   	push   %edx
  801b83:	50                   	push   %eax
  801b84:	6a 1a                	push   $0x1a
  801b86:	e8 7f fd ff ff       	call   80190a <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	52                   	push   %edx
  801ba0:	50                   	push   %eax
  801ba1:	6a 18                	push   $0x18
  801ba3:	e8 62 fd ff ff       	call   80190a <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 19                	push   $0x19
  801bc1:	e8 44 fd ff ff       	call   80190a <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	90                   	nop
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 04             	sub    $0x4,%esp
  801bd2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bd8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bdb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	6a 00                	push   $0x0
  801be4:	51                   	push   %ecx
  801be5:	52                   	push   %edx
  801be6:	ff 75 0c             	pushl  0xc(%ebp)
  801be9:	50                   	push   %eax
  801bea:	6a 1b                	push   $0x1b
  801bec:	e8 19 fd ff ff       	call   80190a <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	52                   	push   %edx
  801c06:	50                   	push   %eax
  801c07:	6a 1c                	push   $0x1c
  801c09:	e8 fc fc ff ff       	call   80190a <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c16:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	51                   	push   %ecx
  801c24:	52                   	push   %edx
  801c25:	50                   	push   %eax
  801c26:	6a 1d                	push   $0x1d
  801c28:	e8 dd fc ff ff       	call   80190a <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	52                   	push   %edx
  801c42:	50                   	push   %eax
  801c43:	6a 1e                	push   $0x1e
  801c45:	e8 c0 fc ff ff       	call   80190a <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 1f                	push   $0x1f
  801c5e:	e8 a7 fc ff ff       	call   80190a <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6e:	6a 00                	push   $0x0
  801c70:	ff 75 14             	pushl  0x14(%ebp)
  801c73:	ff 75 10             	pushl  0x10(%ebp)
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	50                   	push   %eax
  801c7a:	6a 20                	push   $0x20
  801c7c:	e8 89 fc ff ff       	call   80190a <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	50                   	push   %eax
  801c95:	6a 21                	push   $0x21
  801c97:	e8 6e fc ff ff       	call   80190a <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	90                   	nop
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	50                   	push   %eax
  801cb1:	6a 22                	push   $0x22
  801cb3:	e8 52 fc ff ff       	call   80190a <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 02                	push   $0x2
  801ccc:	e8 39 fc ff ff       	call   80190a <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 03                	push   $0x3
  801ce5:	e8 20 fc ff ff       	call   80190a <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 04                	push   $0x4
  801cfe:	e8 07 fc ff ff       	call   80190a <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_exit_env>:


void sys_exit_env(void)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 23                	push   $0x23
  801d17:	e8 ee fb ff ff       	call   80190a <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	90                   	nop
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d28:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d2b:	8d 50 04             	lea    0x4(%eax),%edx
  801d2e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	52                   	push   %edx
  801d38:	50                   	push   %eax
  801d39:	6a 24                	push   $0x24
  801d3b:	e8 ca fb ff ff       	call   80190a <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
	return result;
  801d43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d49:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d4c:	89 01                	mov    %eax,(%ecx)
  801d4e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	c9                   	leave  
  801d55:	c2 04 00             	ret    $0x4

00801d58 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 10             	pushl  0x10(%ebp)
  801d62:	ff 75 0c             	pushl  0xc(%ebp)
  801d65:	ff 75 08             	pushl  0x8(%ebp)
  801d68:	6a 12                	push   $0x12
  801d6a:	e8 9b fb ff ff       	call   80190a <syscall>
  801d6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d72:	90                   	nop
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 25                	push   $0x25
  801d84:	e8 81 fb ff ff       	call   80190a <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 04             	sub    $0x4,%esp
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d9a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	50                   	push   %eax
  801da7:	6a 26                	push   $0x26
  801da9:	e8 5c fb ff ff       	call   80190a <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return ;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <rsttst>:
void rsttst()
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 28                	push   $0x28
  801dc3:	e8 42 fb ff ff       	call   80190a <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcb:	90                   	nop
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 04             	sub    $0x4,%esp
  801dd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dda:	8b 55 18             	mov    0x18(%ebp),%edx
  801ddd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801de1:	52                   	push   %edx
  801de2:	50                   	push   %eax
  801de3:	ff 75 10             	pushl  0x10(%ebp)
  801de6:	ff 75 0c             	pushl  0xc(%ebp)
  801de9:	ff 75 08             	pushl  0x8(%ebp)
  801dec:	6a 27                	push   $0x27
  801dee:	e8 17 fb ff ff       	call   80190a <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
	return ;
  801df6:	90                   	nop
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <chktst>:
void chktst(uint32 n)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	ff 75 08             	pushl  0x8(%ebp)
  801e07:	6a 29                	push   $0x29
  801e09:	e8 fc fa ff ff       	call   80190a <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e11:	90                   	nop
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <inctst>:

void inctst()
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 2a                	push   $0x2a
  801e23:	e8 e2 fa ff ff       	call   80190a <syscall>
  801e28:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2b:	90                   	nop
}
  801e2c:	c9                   	leave  
  801e2d:	c3                   	ret    

00801e2e <gettst>:
uint32 gettst()
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 2b                	push   $0x2b
  801e3d:	e8 c8 fa ff ff       	call   80190a <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 2c                	push   $0x2c
  801e59:	e8 ac fa ff ff       	call   80190a <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
  801e61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e64:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e68:	75 07                	jne    801e71 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6f:	eb 05                	jmp    801e76 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 2c                	push   $0x2c
  801e8a:	e8 7b fa ff ff       	call   80190a <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
  801e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e95:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e99:	75 07                	jne    801ea2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea0:	eb 05                	jmp    801ea7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ea2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 2c                	push   $0x2c
  801ebb:	e8 4a fa ff ff       	call   80190a <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
  801ec3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ec6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eca:	75 07                	jne    801ed3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ecc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed1:	eb 05                	jmp    801ed8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 2c                	push   $0x2c
  801eec:	e8 19 fa ff ff       	call   80190a <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
  801ef4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ef7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801efb:	75 07                	jne    801f04 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801efd:	b8 01 00 00 00       	mov    $0x1,%eax
  801f02:	eb 05                	jmp    801f09 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	ff 75 08             	pushl  0x8(%ebp)
  801f19:	6a 2d                	push   $0x2d
  801f1b:	e8 ea f9 ff ff       	call   80190a <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
	return ;
  801f23:	90                   	nop
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f2a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	53                   	push   %ebx
  801f39:	51                   	push   %ecx
  801f3a:	52                   	push   %edx
  801f3b:	50                   	push   %eax
  801f3c:	6a 2e                	push   $0x2e
  801f3e:	e8 c7 f9 ff ff       	call   80190a <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f49:	c9                   	leave  
  801f4a:	c3                   	ret    

00801f4b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	52                   	push   %edx
  801f5b:	50                   	push   %eax
  801f5c:	6a 2f                	push   $0x2f
  801f5e:	e8 a7 f9 ff ff       	call   80190a <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f6e:	83 ec 0c             	sub    $0xc,%esp
  801f71:	68 e0 3f 80 00       	push   $0x803fe0
  801f76:	e8 d6 e6 ff ff       	call   800651 <cprintf>
  801f7b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f7e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	68 0c 40 80 00       	push   $0x80400c
  801f8d:	e8 bf e6 ff ff       	call   800651 <cprintf>
  801f92:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f95:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f99:	a1 38 51 80 00       	mov    0x805138,%eax
  801f9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa1:	eb 56                	jmp    801ff9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fa3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa7:	74 1c                	je     801fc5 <print_mem_block_lists+0x5d>
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 50 08             	mov    0x8(%eax),%edx
  801faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb2:	8b 48 08             	mov    0x8(%eax),%ecx
  801fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbb:	01 c8                	add    %ecx,%eax
  801fbd:	39 c2                	cmp    %eax,%edx
  801fbf:	73 04                	jae    801fc5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fc1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	8b 50 08             	mov    0x8(%eax),%edx
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd1:	01 c2                	add    %eax,%edx
  801fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd6:	8b 40 08             	mov    0x8(%eax),%eax
  801fd9:	83 ec 04             	sub    $0x4,%esp
  801fdc:	52                   	push   %edx
  801fdd:	50                   	push   %eax
  801fde:	68 21 40 80 00       	push   $0x804021
  801fe3:	e8 69 e6 ff ff       	call   800651 <cprintf>
  801fe8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ff1:	a1 40 51 80 00       	mov    0x805140,%eax
  801ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffd:	74 07                	je     802006 <print_mem_block_lists+0x9e>
  801fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802002:	8b 00                	mov    (%eax),%eax
  802004:	eb 05                	jmp    80200b <print_mem_block_lists+0xa3>
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
  80200b:	a3 40 51 80 00       	mov    %eax,0x805140
  802010:	a1 40 51 80 00       	mov    0x805140,%eax
  802015:	85 c0                	test   %eax,%eax
  802017:	75 8a                	jne    801fa3 <print_mem_block_lists+0x3b>
  802019:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201d:	75 84                	jne    801fa3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80201f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802023:	75 10                	jne    802035 <print_mem_block_lists+0xcd>
  802025:	83 ec 0c             	sub    $0xc,%esp
  802028:	68 30 40 80 00       	push   $0x804030
  80202d:	e8 1f e6 ff ff       	call   800651 <cprintf>
  802032:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802035:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	68 54 40 80 00       	push   $0x804054
  802044:	e8 08 e6 ff ff       	call   800651 <cprintf>
  802049:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80204c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802050:	a1 40 50 80 00       	mov    0x805040,%eax
  802055:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802058:	eb 56                	jmp    8020b0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80205a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80205e:	74 1c                	je     80207c <print_mem_block_lists+0x114>
  802060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802063:	8b 50 08             	mov    0x8(%eax),%edx
  802066:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802069:	8b 48 08             	mov    0x8(%eax),%ecx
  80206c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206f:	8b 40 0c             	mov    0xc(%eax),%eax
  802072:	01 c8                	add    %ecx,%eax
  802074:	39 c2                	cmp    %eax,%edx
  802076:	73 04                	jae    80207c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802078:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80207c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207f:	8b 50 08             	mov    0x8(%eax),%edx
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	8b 40 0c             	mov    0xc(%eax),%eax
  802088:	01 c2                	add    %eax,%edx
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	8b 40 08             	mov    0x8(%eax),%eax
  802090:	83 ec 04             	sub    $0x4,%esp
  802093:	52                   	push   %edx
  802094:	50                   	push   %eax
  802095:	68 21 40 80 00       	push   $0x804021
  80209a:	e8 b2 e5 ff ff       	call   800651 <cprintf>
  80209f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020a8:	a1 48 50 80 00       	mov    0x805048,%eax
  8020ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b4:	74 07                	je     8020bd <print_mem_block_lists+0x155>
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 00                	mov    (%eax),%eax
  8020bb:	eb 05                	jmp    8020c2 <print_mem_block_lists+0x15a>
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c2:	a3 48 50 80 00       	mov    %eax,0x805048
  8020c7:	a1 48 50 80 00       	mov    0x805048,%eax
  8020cc:	85 c0                	test   %eax,%eax
  8020ce:	75 8a                	jne    80205a <print_mem_block_lists+0xf2>
  8020d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d4:	75 84                	jne    80205a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020d6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020da:	75 10                	jne    8020ec <print_mem_block_lists+0x184>
  8020dc:	83 ec 0c             	sub    $0xc,%esp
  8020df:	68 6c 40 80 00       	push   $0x80406c
  8020e4:	e8 68 e5 ff ff       	call   800651 <cprintf>
  8020e9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020ec:	83 ec 0c             	sub    $0xc,%esp
  8020ef:	68 e0 3f 80 00       	push   $0x803fe0
  8020f4:	e8 58 e5 ff ff       	call   800651 <cprintf>
  8020f9:	83 c4 10             	add    $0x10,%esp

}
  8020fc:	90                   	nop
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  802105:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80210c:	00 00 00 
  80210f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802116:	00 00 00 
  802119:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802120:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80212a:	e9 9e 00 00 00       	jmp    8021cd <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  80212f:	a1 50 50 80 00       	mov    0x805050,%eax
  802134:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802137:	c1 e2 04             	shl    $0x4,%edx
  80213a:	01 d0                	add    %edx,%eax
  80213c:	85 c0                	test   %eax,%eax
  80213e:	75 14                	jne    802154 <initialize_MemBlocksList+0x55>
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 94 40 80 00       	push   $0x804094
  802148:	6a 46                	push   $0x46
  80214a:	68 b7 40 80 00       	push   $0x8040b7
  80214f:	e8 49 e2 ff ff       	call   80039d <_panic>
  802154:	a1 50 50 80 00       	mov    0x805050,%eax
  802159:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215c:	c1 e2 04             	shl    $0x4,%edx
  80215f:	01 d0                	add    %edx,%eax
  802161:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802167:	89 10                	mov    %edx,(%eax)
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	85 c0                	test   %eax,%eax
  80216d:	74 18                	je     802187 <initialize_MemBlocksList+0x88>
  80216f:	a1 48 51 80 00       	mov    0x805148,%eax
  802174:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80217a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80217d:	c1 e1 04             	shl    $0x4,%ecx
  802180:	01 ca                	add    %ecx,%edx
  802182:	89 50 04             	mov    %edx,0x4(%eax)
  802185:	eb 12                	jmp    802199 <initialize_MemBlocksList+0x9a>
  802187:	a1 50 50 80 00       	mov    0x805050,%eax
  80218c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218f:	c1 e2 04             	shl    $0x4,%edx
  802192:	01 d0                	add    %edx,%eax
  802194:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802199:	a1 50 50 80 00       	mov    0x805050,%eax
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	c1 e2 04             	shl    $0x4,%edx
  8021a4:	01 d0                	add    %edx,%eax
  8021a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8021ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8021b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b3:	c1 e2 04             	shl    $0x4,%edx
  8021b6:	01 d0                	add    %edx,%eax
  8021b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8021c4:	40                   	inc    %eax
  8021c5:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8021ca:	ff 45 f4             	incl   -0xc(%ebp)
  8021cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021d3:	0f 82 56 ff ff ff    	jb     80212f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021d9:	90                   	nop
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	8b 00                	mov    (%eax),%eax
  8021e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ea:	eb 19                	jmp    802205 <find_block+0x29>
	{
		if(va==point->sva)
  8021ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ef:	8b 40 08             	mov    0x8(%eax),%eax
  8021f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021f5:	75 05                	jne    8021fc <find_block+0x20>
		   return point;
  8021f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fa:	eb 36                	jmp    802232 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	8b 40 08             	mov    0x8(%eax),%eax
  802202:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802205:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802209:	74 07                	je     802212 <find_block+0x36>
  80220b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	eb 05                	jmp    802217 <find_block+0x3b>
  802212:	b8 00 00 00 00       	mov    $0x0,%eax
  802217:	8b 55 08             	mov    0x8(%ebp),%edx
  80221a:	89 42 08             	mov    %eax,0x8(%edx)
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	8b 40 08             	mov    0x8(%eax),%eax
  802223:	85 c0                	test   %eax,%eax
  802225:	75 c5                	jne    8021ec <find_block+0x10>
  802227:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80222b:	75 bf                	jne    8021ec <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80222d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80223a:	a1 40 50 80 00       	mov    0x805040,%eax
  80223f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802242:	a1 44 50 80 00       	mov    0x805044,%eax
  802247:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80224a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802250:	74 24                	je     802276 <insert_sorted_allocList+0x42>
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	8b 50 08             	mov    0x8(%eax),%edx
  802258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225b:	8b 40 08             	mov    0x8(%eax),%eax
  80225e:	39 c2                	cmp    %eax,%edx
  802260:	76 14                	jbe    802276 <insert_sorted_allocList+0x42>
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	8b 50 08             	mov    0x8(%eax),%edx
  802268:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226b:	8b 40 08             	mov    0x8(%eax),%eax
  80226e:	39 c2                	cmp    %eax,%edx
  802270:	0f 82 60 01 00 00    	jb     8023d6 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802276:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80227a:	75 65                	jne    8022e1 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80227c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802280:	75 14                	jne    802296 <insert_sorted_allocList+0x62>
  802282:	83 ec 04             	sub    $0x4,%esp
  802285:	68 94 40 80 00       	push   $0x804094
  80228a:	6a 6b                	push   $0x6b
  80228c:	68 b7 40 80 00       	push   $0x8040b7
  802291:	e8 07 e1 ff ff       	call   80039d <_panic>
  802296:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	89 10                	mov    %edx,(%eax)
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	8b 00                	mov    (%eax),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	74 0d                	je     8022b7 <insert_sorted_allocList+0x83>
  8022aa:	a1 40 50 80 00       	mov    0x805040,%eax
  8022af:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b2:	89 50 04             	mov    %edx,0x4(%eax)
  8022b5:	eb 08                	jmp    8022bf <insert_sorted_allocList+0x8b>
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	a3 44 50 80 00       	mov    %eax,0x805044
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	a3 40 50 80 00       	mov    %eax,0x805040
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022d1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022d6:	40                   	inc    %eax
  8022d7:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022dc:	e9 dc 01 00 00       	jmp    8024bd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	8b 50 08             	mov    0x8(%eax),%edx
  8022e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ea:	8b 40 08             	mov    0x8(%eax),%eax
  8022ed:	39 c2                	cmp    %eax,%edx
  8022ef:	77 6c                	ja     80235d <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022f5:	74 06                	je     8022fd <insert_sorted_allocList+0xc9>
  8022f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022fb:	75 14                	jne    802311 <insert_sorted_allocList+0xdd>
  8022fd:	83 ec 04             	sub    $0x4,%esp
  802300:	68 d0 40 80 00       	push   $0x8040d0
  802305:	6a 6f                	push   $0x6f
  802307:	68 b7 40 80 00       	push   $0x8040b7
  80230c:	e8 8c e0 ff ff       	call   80039d <_panic>
  802311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802314:	8b 50 04             	mov    0x4(%eax),%edx
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	89 50 04             	mov    %edx,0x4(%eax)
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802323:	89 10                	mov    %edx,(%eax)
  802325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802328:	8b 40 04             	mov    0x4(%eax),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	74 0d                	je     80233c <insert_sorted_allocList+0x108>
  80232f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802332:	8b 40 04             	mov    0x4(%eax),%eax
  802335:	8b 55 08             	mov    0x8(%ebp),%edx
  802338:	89 10                	mov    %edx,(%eax)
  80233a:	eb 08                	jmp    802344 <insert_sorted_allocList+0x110>
  80233c:	8b 45 08             	mov    0x8(%ebp),%eax
  80233f:	a3 40 50 80 00       	mov    %eax,0x805040
  802344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802347:	8b 55 08             	mov    0x8(%ebp),%edx
  80234a:	89 50 04             	mov    %edx,0x4(%eax)
  80234d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802352:	40                   	inc    %eax
  802353:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802358:	e9 60 01 00 00       	jmp    8024bd <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	8b 50 08             	mov    0x8(%eax),%edx
  802363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802366:	8b 40 08             	mov    0x8(%eax),%eax
  802369:	39 c2                	cmp    %eax,%edx
  80236b:	0f 82 4c 01 00 00    	jb     8024bd <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802371:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802375:	75 14                	jne    80238b <insert_sorted_allocList+0x157>
  802377:	83 ec 04             	sub    $0x4,%esp
  80237a:	68 08 41 80 00       	push   $0x804108
  80237f:	6a 73                	push   $0x73
  802381:	68 b7 40 80 00       	push   $0x8040b7
  802386:	e8 12 e0 ff ff       	call   80039d <_panic>
  80238b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	89 50 04             	mov    %edx,0x4(%eax)
  802397:	8b 45 08             	mov    0x8(%ebp),%eax
  80239a:	8b 40 04             	mov    0x4(%eax),%eax
  80239d:	85 c0                	test   %eax,%eax
  80239f:	74 0c                	je     8023ad <insert_sorted_allocList+0x179>
  8023a1:	a1 44 50 80 00       	mov    0x805044,%eax
  8023a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a9:	89 10                	mov    %edx,(%eax)
  8023ab:	eb 08                	jmp    8023b5 <insert_sorted_allocList+0x181>
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	a3 40 50 80 00       	mov    %eax,0x805040
  8023b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b8:	a3 44 50 80 00       	mov    %eax,0x805044
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023cb:	40                   	inc    %eax
  8023cc:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d1:	e9 e7 00 00 00       	jmp    8024bd <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023e3:	a1 40 50 80 00       	mov    0x805040,%eax
  8023e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023eb:	e9 9d 00 00 00       	jmp    80248d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 00                	mov    (%eax),%eax
  8023f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	8b 50 08             	mov    0x8(%eax),%edx
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 40 08             	mov    0x8(%eax),%eax
  802404:	39 c2                	cmp    %eax,%edx
  802406:	76 7d                	jbe    802485 <insert_sorted_allocList+0x251>
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	8b 50 08             	mov    0x8(%eax),%edx
  80240e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802411:	8b 40 08             	mov    0x8(%eax),%eax
  802414:	39 c2                	cmp    %eax,%edx
  802416:	73 6d                	jae    802485 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	74 06                	je     802424 <insert_sorted_allocList+0x1f0>
  80241e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802422:	75 14                	jne    802438 <insert_sorted_allocList+0x204>
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	68 2c 41 80 00       	push   $0x80412c
  80242c:	6a 7f                	push   $0x7f
  80242e:	68 b7 40 80 00       	push   $0x8040b7
  802433:	e8 65 df ff ff       	call   80039d <_panic>
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 10                	mov    (%eax),%edx
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	89 10                	mov    %edx,(%eax)
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	8b 00                	mov    (%eax),%eax
  802447:	85 c0                	test   %eax,%eax
  802449:	74 0b                	je     802456 <insert_sorted_allocList+0x222>
  80244b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244e:	8b 00                	mov    (%eax),%eax
  802450:	8b 55 08             	mov    0x8(%ebp),%edx
  802453:	89 50 04             	mov    %edx,0x4(%eax)
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	8b 55 08             	mov    0x8(%ebp),%edx
  80245c:	89 10                	mov    %edx,(%eax)
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802464:	89 50 04             	mov    %edx,0x4(%eax)
  802467:	8b 45 08             	mov    0x8(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	85 c0                	test   %eax,%eax
  80246e:	75 08                	jne    802478 <insert_sorted_allocList+0x244>
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	a3 44 50 80 00       	mov    %eax,0x805044
  802478:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80247d:	40                   	inc    %eax
  80247e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802483:	eb 39                	jmp    8024be <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802485:	a1 48 50 80 00       	mov    0x805048,%eax
  80248a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802491:	74 07                	je     80249a <insert_sorted_allocList+0x266>
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 00                	mov    (%eax),%eax
  802498:	eb 05                	jmp    80249f <insert_sorted_allocList+0x26b>
  80249a:	b8 00 00 00 00       	mov    $0x0,%eax
  80249f:	a3 48 50 80 00       	mov    %eax,0x805048
  8024a4:	a1 48 50 80 00       	mov    0x805048,%eax
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	0f 85 3f ff ff ff    	jne    8023f0 <insert_sorted_allocList+0x1bc>
  8024b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b5:	0f 85 35 ff ff ff    	jne    8023f0 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024bb:	eb 01                	jmp    8024be <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8024bd:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8024be:	90                   	nop
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024c7:	a1 38 51 80 00       	mov    0x805138,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cf:	e9 85 01 00 00       	jmp    802659 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024dd:	0f 82 6e 01 00 00    	jb     802651 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ec:	0f 85 8a 00 00 00    	jne    80257c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f6:	75 17                	jne    80250f <alloc_block_FF+0x4e>
  8024f8:	83 ec 04             	sub    $0x4,%esp
  8024fb:	68 60 41 80 00       	push   $0x804160
  802500:	68 93 00 00 00       	push   $0x93
  802505:	68 b7 40 80 00       	push   $0x8040b7
  80250a:	e8 8e de ff ff       	call   80039d <_panic>
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 10                	je     802528 <alloc_block_FF+0x67>
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802520:	8b 52 04             	mov    0x4(%edx),%edx
  802523:	89 50 04             	mov    %edx,0x4(%eax)
  802526:	eb 0b                	jmp    802533 <alloc_block_FF+0x72>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 04             	mov    0x4(%eax),%eax
  80252e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 04             	mov    0x4(%eax),%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	74 0f                	je     80254c <alloc_block_FF+0x8b>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802546:	8b 12                	mov    (%edx),%edx
  802548:	89 10                	mov    %edx,(%eax)
  80254a:	eb 0a                	jmp    802556 <alloc_block_FF+0x95>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	a3 38 51 80 00       	mov    %eax,0x805138
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802569:	a1 44 51 80 00       	mov    0x805144,%eax
  80256e:	48                   	dec    %eax
  80256f:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	e9 10 01 00 00       	jmp    80268c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 40 0c             	mov    0xc(%eax),%eax
  802582:	3b 45 08             	cmp    0x8(%ebp),%eax
  802585:	0f 86 c6 00 00 00    	jbe    802651 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80258b:	a1 48 51 80 00       	mov    0x805148,%eax
  802590:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 50 08             	mov    0x8(%eax),%edx
  802599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80259f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8025a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ac:	75 17                	jne    8025c5 <alloc_block_FF+0x104>
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	68 60 41 80 00       	push   $0x804160
  8025b6:	68 9b 00 00 00       	push   $0x9b
  8025bb:	68 b7 40 80 00       	push   $0x8040b7
  8025c0:	e8 d8 dd ff ff       	call   80039d <_panic>
  8025c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	85 c0                	test   %eax,%eax
  8025cc:	74 10                	je     8025de <alloc_block_FF+0x11d>
  8025ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025d6:	8b 52 04             	mov    0x4(%edx),%edx
  8025d9:	89 50 04             	mov    %edx,0x4(%eax)
  8025dc:	eb 0b                	jmp    8025e9 <alloc_block_FF+0x128>
  8025de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ec:	8b 40 04             	mov    0x4(%eax),%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	74 0f                	je     802602 <alloc_block_FF+0x141>
  8025f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025fc:	8b 12                	mov    (%edx),%edx
  8025fe:	89 10                	mov    %edx,(%eax)
  802600:	eb 0a                	jmp    80260c <alloc_block_FF+0x14b>
  802602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	a3 48 51 80 00       	mov    %eax,0x805148
  80260c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261f:	a1 54 51 80 00       	mov    0x805154,%eax
  802624:	48                   	dec    %eax
  802625:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 50 08             	mov    0x8(%eax),%edx
  802630:	8b 45 08             	mov    0x8(%ebp),%eax
  802633:	01 c2                	add    %eax,%edx
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 40 0c             	mov    0xc(%eax),%eax
  802641:	2b 45 08             	sub    0x8(%ebp),%eax
  802644:	89 c2                	mov    %eax,%edx
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80264c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264f:	eb 3b                	jmp    80268c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802651:	a1 40 51 80 00       	mov    0x805140,%eax
  802656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265d:	74 07                	je     802666 <alloc_block_FF+0x1a5>
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	eb 05                	jmp    80266b <alloc_block_FF+0x1aa>
  802666:	b8 00 00 00 00       	mov    $0x0,%eax
  80266b:	a3 40 51 80 00       	mov    %eax,0x805140
  802670:	a1 40 51 80 00       	mov    0x805140,%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	0f 85 57 fe ff ff    	jne    8024d4 <alloc_block_FF+0x13>
  80267d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802681:	0f 85 4d fe ff ff    	jne    8024d4 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    

0080268e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802694:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80269b:	a1 38 51 80 00       	mov    0x805138,%eax
  8026a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a3:	e9 df 00 00 00       	jmp    802787 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b1:	0f 82 c8 00 00 00    	jb     80277f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c0:	0f 85 8a 00 00 00    	jne    802750 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	75 17                	jne    8026e3 <alloc_block_BF+0x55>
  8026cc:	83 ec 04             	sub    $0x4,%esp
  8026cf:	68 60 41 80 00       	push   $0x804160
  8026d4:	68 b7 00 00 00       	push   $0xb7
  8026d9:	68 b7 40 80 00       	push   $0x8040b7
  8026de:	e8 ba dc ff ff       	call   80039d <_panic>
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 00                	mov    (%eax),%eax
  8026e8:	85 c0                	test   %eax,%eax
  8026ea:	74 10                	je     8026fc <alloc_block_BF+0x6e>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f4:	8b 52 04             	mov    0x4(%edx),%edx
  8026f7:	89 50 04             	mov    %edx,0x4(%eax)
  8026fa:	eb 0b                	jmp    802707 <alloc_block_BF+0x79>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 40 04             	mov    0x4(%eax),%eax
  80270d:	85 c0                	test   %eax,%eax
  80270f:	74 0f                	je     802720 <alloc_block_BF+0x92>
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	8b 12                	mov    (%edx),%edx
  80271c:	89 10                	mov    %edx,(%eax)
  80271e:	eb 0a                	jmp    80272a <alloc_block_BF+0x9c>
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	8b 00                	mov    (%eax),%eax
  802725:	a3 38 51 80 00       	mov    %eax,0x805138
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273d:	a1 44 51 80 00       	mov    0x805144,%eax
  802742:	48                   	dec    %eax
  802743:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	e9 4d 01 00 00       	jmp    80289d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 0c             	mov    0xc(%eax),%eax
  802756:	3b 45 08             	cmp    0x8(%ebp),%eax
  802759:	76 24                	jbe    80277f <alloc_block_BF+0xf1>
  80275b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275e:	8b 40 0c             	mov    0xc(%eax),%eax
  802761:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802764:	73 19                	jae    80277f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802766:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 40 0c             	mov    0xc(%eax),%eax
  802773:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 08             	mov    0x8(%eax),%eax
  80277c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80277f:	a1 40 51 80 00       	mov    0x805140,%eax
  802784:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802787:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278b:	74 07                	je     802794 <alloc_block_BF+0x106>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 00                	mov    (%eax),%eax
  802792:	eb 05                	jmp    802799 <alloc_block_BF+0x10b>
  802794:	b8 00 00 00 00       	mov    $0x0,%eax
  802799:	a3 40 51 80 00       	mov    %eax,0x805140
  80279e:	a1 40 51 80 00       	mov    0x805140,%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	0f 85 fd fe ff ff    	jne    8026a8 <alloc_block_BF+0x1a>
  8027ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027af:	0f 85 f3 fe ff ff    	jne    8026a8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8027b5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027b9:	0f 84 d9 00 00 00    	je     802898 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8027c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8027c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027cd:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8027d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d6:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027dd:	75 17                	jne    8027f6 <alloc_block_BF+0x168>
  8027df:	83 ec 04             	sub    $0x4,%esp
  8027e2:	68 60 41 80 00       	push   $0x804160
  8027e7:	68 c7 00 00 00       	push   $0xc7
  8027ec:	68 b7 40 80 00       	push   $0x8040b7
  8027f1:	e8 a7 db ff ff       	call   80039d <_panic>
  8027f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	74 10                	je     80280f <alloc_block_BF+0x181>
  8027ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802802:	8b 00                	mov    (%eax),%eax
  802804:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802807:	8b 52 04             	mov    0x4(%edx),%edx
  80280a:	89 50 04             	mov    %edx,0x4(%eax)
  80280d:	eb 0b                	jmp    80281a <alloc_block_BF+0x18c>
  80280f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802812:	8b 40 04             	mov    0x4(%eax),%eax
  802815:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80281a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281d:	8b 40 04             	mov    0x4(%eax),%eax
  802820:	85 c0                	test   %eax,%eax
  802822:	74 0f                	je     802833 <alloc_block_BF+0x1a5>
  802824:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802827:	8b 40 04             	mov    0x4(%eax),%eax
  80282a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80282d:	8b 12                	mov    (%edx),%edx
  80282f:	89 10                	mov    %edx,(%eax)
  802831:	eb 0a                	jmp    80283d <alloc_block_BF+0x1af>
  802833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	a3 48 51 80 00       	mov    %eax,0x805148
  80283d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802840:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802849:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802850:	a1 54 51 80 00       	mov    0x805154,%eax
  802855:	48                   	dec    %eax
  802856:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80285b:	83 ec 08             	sub    $0x8,%esp
  80285e:	ff 75 ec             	pushl  -0x14(%ebp)
  802861:	68 38 51 80 00       	push   $0x805138
  802866:	e8 71 f9 ff ff       	call   8021dc <find_block>
  80286b:	83 c4 10             	add    $0x10,%esp
  80286e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802874:	8b 50 08             	mov    0x8(%eax),%edx
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	01 c2                	add    %eax,%edx
  80287c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802882:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802885:	8b 40 0c             	mov    0xc(%eax),%eax
  802888:	2b 45 08             	sub    0x8(%ebp),%eax
  80288b:	89 c2                	mov    %eax,%edx
  80288d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802890:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802896:	eb 05                	jmp    80289d <alloc_block_BF+0x20f>
	}
	return NULL;
  802898:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80289d:	c9                   	leave  
  80289e:	c3                   	ret    

0080289f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8028a5:	a1 28 50 80 00       	mov    0x805028,%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	0f 85 de 01 00 00    	jne    802a90 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8028b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ba:	e9 9e 01 00 00       	jmp    802a5d <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c8:	0f 82 87 01 00 00    	jb     802a55 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d7:	0f 85 95 00 00 00    	jne    802972 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e1:	75 17                	jne    8028fa <alloc_block_NF+0x5b>
  8028e3:	83 ec 04             	sub    $0x4,%esp
  8028e6:	68 60 41 80 00       	push   $0x804160
  8028eb:	68 e0 00 00 00       	push   $0xe0
  8028f0:	68 b7 40 80 00       	push   $0x8040b7
  8028f5:	e8 a3 da ff ff       	call   80039d <_panic>
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 10                	je     802913 <alloc_block_NF+0x74>
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290b:	8b 52 04             	mov    0x4(%edx),%edx
  80290e:	89 50 04             	mov    %edx,0x4(%eax)
  802911:	eb 0b                	jmp    80291e <alloc_block_NF+0x7f>
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 0f                	je     802937 <alloc_block_NF+0x98>
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802931:	8b 12                	mov    (%edx),%edx
  802933:	89 10                	mov    %edx,(%eax)
  802935:	eb 0a                	jmp    802941 <alloc_block_NF+0xa2>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	a3 38 51 80 00       	mov    %eax,0x805138
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802954:	a1 44 51 80 00       	mov    0x805144,%eax
  802959:	48                   	dec    %eax
  80295a:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 40 08             	mov    0x8(%eax),%eax
  802965:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	e9 f8 04 00 00       	jmp    802e6a <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 0c             	mov    0xc(%eax),%eax
  802978:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297b:	0f 86 d4 00 00 00    	jbe    802a55 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802981:	a1 48 51 80 00       	mov    0x805148,%eax
  802986:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 50 08             	mov    0x8(%eax),%edx
  80298f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802992:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802998:	8b 55 08             	mov    0x8(%ebp),%edx
  80299b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80299e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a2:	75 17                	jne    8029bb <alloc_block_NF+0x11c>
  8029a4:	83 ec 04             	sub    $0x4,%esp
  8029a7:	68 60 41 80 00       	push   $0x804160
  8029ac:	68 e9 00 00 00       	push   $0xe9
  8029b1:	68 b7 40 80 00       	push   $0x8040b7
  8029b6:	e8 e2 d9 ff ff       	call   80039d <_panic>
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	74 10                	je     8029d4 <alloc_block_NF+0x135>
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029cc:	8b 52 04             	mov    0x4(%edx),%edx
  8029cf:	89 50 04             	mov    %edx,0x4(%eax)
  8029d2:	eb 0b                	jmp    8029df <alloc_block_NF+0x140>
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	8b 40 04             	mov    0x4(%eax),%eax
  8029da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	8b 40 04             	mov    0x4(%eax),%eax
  8029e5:	85 c0                	test   %eax,%eax
  8029e7:	74 0f                	je     8029f8 <alloc_block_NF+0x159>
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f2:	8b 12                	mov    (%edx),%edx
  8029f4:	89 10                	mov    %edx,(%eax)
  8029f6:	eb 0a                	jmp    802a02 <alloc_block_NF+0x163>
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	a3 48 51 80 00       	mov    %eax,0x805148
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a15:	a1 54 51 80 00       	mov    0x805154,%eax
  802a1a:	48                   	dec    %eax
  802a1b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2e:	8b 50 08             	mov    0x8(%eax),%edx
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	01 c2                	add    %eax,%edx
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a42:	2b 45 08             	sub    0x8(%ebp),%eax
  802a45:	89 c2                	mov    %eax,%edx
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	e9 15 04 00 00       	jmp    802e6a <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a55:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a61:	74 07                	je     802a6a <alloc_block_NF+0x1cb>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	eb 05                	jmp    802a6f <alloc_block_NF+0x1d0>
  802a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6f:	a3 40 51 80 00       	mov    %eax,0x805140
  802a74:	a1 40 51 80 00       	mov    0x805140,%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	0f 85 3e fe ff ff    	jne    8028bf <alloc_block_NF+0x20>
  802a81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a85:	0f 85 34 fe ff ff    	jne    8028bf <alloc_block_NF+0x20>
  802a8b:	e9 d5 03 00 00       	jmp    802e65 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a90:	a1 38 51 80 00       	mov    0x805138,%eax
  802a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a98:	e9 b1 01 00 00       	jmp    802c4e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 50 08             	mov    0x8(%eax),%edx
  802aa3:	a1 28 50 80 00       	mov    0x805028,%eax
  802aa8:	39 c2                	cmp    %eax,%edx
  802aaa:	0f 82 96 01 00 00    	jb     802c46 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab9:	0f 82 87 01 00 00    	jb     802c46 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac8:	0f 85 95 00 00 00    	jne    802b63 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad2:	75 17                	jne    802aeb <alloc_block_NF+0x24c>
  802ad4:	83 ec 04             	sub    $0x4,%esp
  802ad7:	68 60 41 80 00       	push   $0x804160
  802adc:	68 fc 00 00 00       	push   $0xfc
  802ae1:	68 b7 40 80 00       	push   $0x8040b7
  802ae6:	e8 b2 d8 ff ff       	call   80039d <_panic>
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 10                	je     802b04 <alloc_block_NF+0x265>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afc:	8b 52 04             	mov    0x4(%edx),%edx
  802aff:	89 50 04             	mov    %edx,0x4(%eax)
  802b02:	eb 0b                	jmp    802b0f <alloc_block_NF+0x270>
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 0f                	je     802b28 <alloc_block_NF+0x289>
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 04             	mov    0x4(%eax),%eax
  802b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b22:	8b 12                	mov    (%edx),%edx
  802b24:	89 10                	mov    %edx,(%eax)
  802b26:	eb 0a                	jmp    802b32 <alloc_block_NF+0x293>
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b45:	a1 44 51 80 00       	mov    0x805144,%eax
  802b4a:	48                   	dec    %eax
  802b4b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	8b 40 08             	mov    0x8(%eax),%eax
  802b56:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	e9 07 03 00 00       	jmp    802e6a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 40 0c             	mov    0xc(%eax),%eax
  802b69:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b6c:	0f 86 d4 00 00 00    	jbe    802c46 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b72:	a1 48 51 80 00       	mov    0x805148,%eax
  802b77:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 50 08             	mov    0x8(%eax),%edx
  802b80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b83:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b89:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b93:	75 17                	jne    802bac <alloc_block_NF+0x30d>
  802b95:	83 ec 04             	sub    $0x4,%esp
  802b98:	68 60 41 80 00       	push   $0x804160
  802b9d:	68 04 01 00 00       	push   $0x104
  802ba2:	68 b7 40 80 00       	push   $0x8040b7
  802ba7:	e8 f1 d7 ff ff       	call   80039d <_panic>
  802bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802baf:	8b 00                	mov    (%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	74 10                	je     802bc5 <alloc_block_NF+0x326>
  802bb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bbd:	8b 52 04             	mov    0x4(%edx),%edx
  802bc0:	89 50 04             	mov    %edx,0x4(%eax)
  802bc3:	eb 0b                	jmp    802bd0 <alloc_block_NF+0x331>
  802bc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc8:	8b 40 04             	mov    0x4(%eax),%eax
  802bcb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd3:	8b 40 04             	mov    0x4(%eax),%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	74 0f                	je     802be9 <alloc_block_NF+0x34a>
  802bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bdd:	8b 40 04             	mov    0x4(%eax),%eax
  802be0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802be3:	8b 12                	mov    (%edx),%edx
  802be5:	89 10                	mov    %edx,(%eax)
  802be7:	eb 0a                	jmp    802bf3 <alloc_block_NF+0x354>
  802be9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bec:	8b 00                	mov    (%eax),%eax
  802bee:	a3 48 51 80 00       	mov    %eax,0x805148
  802bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c06:	a1 54 51 80 00       	mov    0x805154,%eax
  802c0b:	48                   	dec    %eax
  802c0c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c14:	8b 40 08             	mov    0x8(%eax),%eax
  802c17:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 50 08             	mov    0x8(%eax),%edx
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	01 c2                	add    %eax,%edx
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 40 0c             	mov    0xc(%eax),%eax
  802c33:	2b 45 08             	sub    0x8(%ebp),%eax
  802c36:	89 c2                	mov    %eax,%edx
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c41:	e9 24 02 00 00       	jmp    802e6a <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c46:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c52:	74 07                	je     802c5b <alloc_block_NF+0x3bc>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	eb 05                	jmp    802c60 <alloc_block_NF+0x3c1>
  802c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c60:	a3 40 51 80 00       	mov    %eax,0x805140
  802c65:	a1 40 51 80 00       	mov    0x805140,%eax
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	0f 85 2b fe ff ff    	jne    802a9d <alloc_block_NF+0x1fe>
  802c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c76:	0f 85 21 fe ff ff    	jne    802a9d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c7c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c84:	e9 ae 01 00 00       	jmp    802e37 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 50 08             	mov    0x8(%eax),%edx
  802c8f:	a1 28 50 80 00       	mov    0x805028,%eax
  802c94:	39 c2                	cmp    %eax,%edx
  802c96:	0f 83 93 01 00 00    	jae    802e2f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca5:	0f 82 84 01 00 00    	jb     802e2f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb4:	0f 85 95 00 00 00    	jne    802d4f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	75 17                	jne    802cd7 <alloc_block_NF+0x438>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 60 41 80 00       	push   $0x804160
  802cc8:	68 14 01 00 00       	push   $0x114
  802ccd:	68 b7 40 80 00       	push   $0x8040b7
  802cd2:	e8 c6 d6 ff ff       	call   80039d <_panic>
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	85 c0                	test   %eax,%eax
  802cde:	74 10                	je     802cf0 <alloc_block_NF+0x451>
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce8:	8b 52 04             	mov    0x4(%edx),%edx
  802ceb:	89 50 04             	mov    %edx,0x4(%eax)
  802cee:	eb 0b                	jmp    802cfb <alloc_block_NF+0x45c>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 40 04             	mov    0x4(%eax),%eax
  802cf6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 0f                	je     802d14 <alloc_block_NF+0x475>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d0e:	8b 12                	mov    (%edx),%edx
  802d10:	89 10                	mov    %edx,(%eax)
  802d12:	eb 0a                	jmp    802d1e <alloc_block_NF+0x47f>
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	8b 00                	mov    (%eax),%eax
  802d19:	a3 38 51 80 00       	mov    %eax,0x805138
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d31:	a1 44 51 80 00       	mov    0x805144,%eax
  802d36:	48                   	dec    %eax
  802d37:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 08             	mov    0x8(%eax),%eax
  802d42:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	e9 1b 01 00 00       	jmp    802e6a <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 40 0c             	mov    0xc(%eax),%eax
  802d55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d58:	0f 86 d1 00 00 00    	jbe    802e2f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d5e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d63:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 50 08             	mov    0x8(%eax),%edx
  802d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d75:	8b 55 08             	mov    0x8(%ebp),%edx
  802d78:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d7f:	75 17                	jne    802d98 <alloc_block_NF+0x4f9>
  802d81:	83 ec 04             	sub    $0x4,%esp
  802d84:	68 60 41 80 00       	push   $0x804160
  802d89:	68 1c 01 00 00       	push   $0x11c
  802d8e:	68 b7 40 80 00       	push   $0x8040b7
  802d93:	e8 05 d6 ff ff       	call   80039d <_panic>
  802d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	74 10                	je     802db1 <alloc_block_NF+0x512>
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 00                	mov    (%eax),%eax
  802da6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da9:	8b 52 04             	mov    0x4(%edx),%edx
  802dac:	89 50 04             	mov    %edx,0x4(%eax)
  802daf:	eb 0b                	jmp    802dbc <alloc_block_NF+0x51d>
  802db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db4:	8b 40 04             	mov    0x4(%eax),%eax
  802db7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbf:	8b 40 04             	mov    0x4(%eax),%eax
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	74 0f                	je     802dd5 <alloc_block_NF+0x536>
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dcf:	8b 12                	mov    (%edx),%edx
  802dd1:	89 10                	mov    %edx,(%eax)
  802dd3:	eb 0a                	jmp    802ddf <alloc_block_NF+0x540>
  802dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	a3 48 51 80 00       	mov    %eax,0x805148
  802ddf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802deb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df2:	a1 54 51 80 00       	mov    0x805154,%eax
  802df7:	48                   	dec    %eax
  802df8:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e00:	8b 40 08             	mov    0x8(%eax),%eax
  802e03:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0b:	8b 50 08             	mov    0x8(%eax),%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	01 c2                	add    %eax,%edx
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1f:	2b 45 08             	sub    0x8(%ebp),%eax
  802e22:	89 c2                	mov    %eax,%edx
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802e2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e2d:	eb 3b                	jmp    802e6a <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802e2f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e3b:	74 07                	je     802e44 <alloc_block_NF+0x5a5>
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 00                	mov    (%eax),%eax
  802e42:	eb 05                	jmp    802e49 <alloc_block_NF+0x5aa>
  802e44:	b8 00 00 00 00       	mov    $0x0,%eax
  802e49:	a3 40 51 80 00       	mov    %eax,0x805140
  802e4e:	a1 40 51 80 00       	mov    0x805140,%eax
  802e53:	85 c0                	test   %eax,%eax
  802e55:	0f 85 2e fe ff ff    	jne    802c89 <alloc_block_NF+0x3ea>
  802e5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5f:	0f 85 24 fe ff ff    	jne    802c89 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e6a:	c9                   	leave  
  802e6b:	c3                   	ret    

00802e6c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e6c:	55                   	push   %ebp
  802e6d:	89 e5                	mov    %esp,%ebp
  802e6f:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e72:	a1 38 51 80 00       	mov    0x805138,%eax
  802e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e7a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e7f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e82:	a1 38 51 80 00       	mov    0x805138,%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 14                	je     802e9f <insert_sorted_with_merge_freeList+0x33>
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8b 50 08             	mov    0x8(%eax),%edx
  802e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e94:	8b 40 08             	mov    0x8(%eax),%eax
  802e97:	39 c2                	cmp    %eax,%edx
  802e99:	0f 87 9b 01 00 00    	ja     80303a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea3:	75 17                	jne    802ebc <insert_sorted_with_merge_freeList+0x50>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 94 40 80 00       	push   $0x804094
  802ead:	68 38 01 00 00       	push   $0x138
  802eb2:	68 b7 40 80 00       	push   $0x8040b7
  802eb7:	e8 e1 d4 ff ff       	call   80039d <_panic>
  802ebc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	89 10                	mov    %edx,(%eax)
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	74 0d                	je     802edd <insert_sorted_with_merge_freeList+0x71>
  802ed0:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed8:	89 50 04             	mov    %edx,0x4(%eax)
  802edb:	eb 08                	jmp    802ee5 <insert_sorted_with_merge_freeList+0x79>
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	a3 38 51 80 00       	mov    %eax,0x805138
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef7:	a1 44 51 80 00       	mov    0x805144,%eax
  802efc:	40                   	inc    %eax
  802efd:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f06:	0f 84 a8 06 00 00    	je     8035b4 <insert_sorted_with_merge_freeList+0x748>
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	8b 50 08             	mov    0x8(%eax),%edx
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 40 0c             	mov    0xc(%eax),%eax
  802f18:	01 c2                	add    %eax,%edx
  802f1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1d:	8b 40 08             	mov    0x8(%eax),%eax
  802f20:	39 c2                	cmp    %eax,%edx
  802f22:	0f 85 8c 06 00 00    	jne    8035b4 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f31:	8b 40 0c             	mov    0xc(%eax),%eax
  802f34:	01 c2                	add    %eax,%edx
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f40:	75 17                	jne    802f59 <insert_sorted_with_merge_freeList+0xed>
  802f42:	83 ec 04             	sub    $0x4,%esp
  802f45:	68 60 41 80 00       	push   $0x804160
  802f4a:	68 3c 01 00 00       	push   $0x13c
  802f4f:	68 b7 40 80 00       	push   $0x8040b7
  802f54:	e8 44 d4 ff ff       	call   80039d <_panic>
  802f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 10                	je     802f72 <insert_sorted_with_merge_freeList+0x106>
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f6a:	8b 52 04             	mov    0x4(%edx),%edx
  802f6d:	89 50 04             	mov    %edx,0x4(%eax)
  802f70:	eb 0b                	jmp    802f7d <insert_sorted_with_merge_freeList+0x111>
  802f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f75:	8b 40 04             	mov    0x4(%eax),%eax
  802f78:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 0f                	je     802f96 <insert_sorted_with_merge_freeList+0x12a>
  802f87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f90:	8b 12                	mov    (%edx),%edx
  802f92:	89 10                	mov    %edx,(%eax)
  802f94:	eb 0a                	jmp    802fa0 <insert_sorted_with_merge_freeList+0x134>
  802f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	a3 38 51 80 00       	mov    %eax,0x805138
  802fa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb3:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb8:	48                   	dec    %eax
  802fb9:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802fd2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fd6:	75 17                	jne    802fef <insert_sorted_with_merge_freeList+0x183>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 94 40 80 00       	push   $0x804094
  802fe0:	68 3f 01 00 00       	push   $0x13f
  802fe5:	68 b7 40 80 00       	push   $0x8040b7
  802fea:	e8 ae d3 ff ff       	call   80039d <_panic>
  802fef:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	89 10                	mov    %edx,(%eax)
  802ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffd:	8b 00                	mov    (%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0d                	je     803010 <insert_sorted_with_merge_freeList+0x1a4>
  803003:	a1 48 51 80 00       	mov    0x805148,%eax
  803008:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300b:	89 50 04             	mov    %edx,0x4(%eax)
  80300e:	eb 08                	jmp    803018 <insert_sorted_with_merge_freeList+0x1ac>
  803010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803013:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301b:	a3 48 51 80 00       	mov    %eax,0x805148
  803020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803023:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302a:	a1 54 51 80 00       	mov    0x805154,%eax
  80302f:	40                   	inc    %eax
  803030:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803035:	e9 7a 05 00 00       	jmp    8035b4 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 50 08             	mov    0x8(%eax),%edx
  803040:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803043:	8b 40 08             	mov    0x8(%eax),%eax
  803046:	39 c2                	cmp    %eax,%edx
  803048:	0f 82 14 01 00 00    	jb     803162 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80304e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803051:	8b 50 08             	mov    0x8(%eax),%edx
  803054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803057:	8b 40 0c             	mov    0xc(%eax),%eax
  80305a:	01 c2                	add    %eax,%edx
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 40 08             	mov    0x8(%eax),%eax
  803062:	39 c2                	cmp    %eax,%edx
  803064:	0f 85 90 00 00 00    	jne    8030fa <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  80306a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306d:	8b 50 0c             	mov    0xc(%eax),%edx
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	8b 40 0c             	mov    0xc(%eax),%eax
  803076:	01 c2                	add    %eax,%edx
  803078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803096:	75 17                	jne    8030af <insert_sorted_with_merge_freeList+0x243>
  803098:	83 ec 04             	sub    $0x4,%esp
  80309b:	68 94 40 80 00       	push   $0x804094
  8030a0:	68 49 01 00 00       	push   $0x149
  8030a5:	68 b7 40 80 00       	push   $0x8040b7
  8030aa:	e8 ee d2 ff ff       	call   80039d <_panic>
  8030af:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	89 10                	mov    %edx,(%eax)
  8030ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bd:	8b 00                	mov    (%eax),%eax
  8030bf:	85 c0                	test   %eax,%eax
  8030c1:	74 0d                	je     8030d0 <insert_sorted_with_merge_freeList+0x264>
  8030c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8030c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cb:	89 50 04             	mov    %edx,0x4(%eax)
  8030ce:	eb 08                	jmp    8030d8 <insert_sorted_with_merge_freeList+0x26c>
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	a3 48 51 80 00       	mov    %eax,0x805148
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ea:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ef:	40                   	inc    %eax
  8030f0:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030f5:	e9 bb 04 00 00       	jmp    8035b5 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fe:	75 17                	jne    803117 <insert_sorted_with_merge_freeList+0x2ab>
  803100:	83 ec 04             	sub    $0x4,%esp
  803103:	68 08 41 80 00       	push   $0x804108
  803108:	68 4c 01 00 00       	push   $0x14c
  80310d:	68 b7 40 80 00       	push   $0x8040b7
  803112:	e8 86 d2 ff ff       	call   80039d <_panic>
  803117:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	89 50 04             	mov    %edx,0x4(%eax)
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 40 04             	mov    0x4(%eax),%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	74 0c                	je     803139 <insert_sorted_with_merge_freeList+0x2cd>
  80312d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803132:	8b 55 08             	mov    0x8(%ebp),%edx
  803135:	89 10                	mov    %edx,(%eax)
  803137:	eb 08                	jmp    803141 <insert_sorted_with_merge_freeList+0x2d5>
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	a3 38 51 80 00       	mov    %eax,0x805138
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803152:	a1 44 51 80 00       	mov    0x805144,%eax
  803157:	40                   	inc    %eax
  803158:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80315d:	e9 53 04 00 00       	jmp    8035b5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803162:	a1 38 51 80 00       	mov    0x805138,%eax
  803167:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80316a:	e9 15 04 00 00       	jmp    803584 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	8b 50 08             	mov    0x8(%eax),%edx
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	8b 40 08             	mov    0x8(%eax),%eax
  803183:	39 c2                	cmp    %eax,%edx
  803185:	0f 86 f1 03 00 00    	jbe    80357c <insert_sorted_with_merge_freeList+0x710>
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	8b 50 08             	mov    0x8(%eax),%edx
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 40 08             	mov    0x8(%eax),%eax
  803197:	39 c2                	cmp    %eax,%edx
  803199:	0f 83 dd 03 00 00    	jae    80357c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80319f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a2:	8b 50 08             	mov    0x8(%eax),%edx
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ab:	01 c2                	add    %eax,%edx
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	8b 40 08             	mov    0x8(%eax),%eax
  8031b3:	39 c2                	cmp    %eax,%edx
  8031b5:	0f 85 b9 01 00 00    	jne    803374 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	8b 50 08             	mov    0x8(%eax),%edx
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c7:	01 c2                	add    %eax,%edx
  8031c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cc:	8b 40 08             	mov    0x8(%eax),%eax
  8031cf:	39 c2                	cmp    %eax,%edx
  8031d1:	0f 85 0d 01 00 00    	jne    8032e4 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	8b 50 0c             	mov    0xc(%eax),%edx
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e3:	01 c2                	add    %eax,%edx
  8031e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e8:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031eb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ef:	75 17                	jne    803208 <insert_sorted_with_merge_freeList+0x39c>
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	68 60 41 80 00       	push   $0x804160
  8031f9:	68 5c 01 00 00       	push   $0x15c
  8031fe:	68 b7 40 80 00       	push   $0x8040b7
  803203:	e8 95 d1 ff ff       	call   80039d <_panic>
  803208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	74 10                	je     803221 <insert_sorted_with_merge_freeList+0x3b5>
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	8b 00                	mov    (%eax),%eax
  803216:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803219:	8b 52 04             	mov    0x4(%edx),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	eb 0b                	jmp    80322c <insert_sorted_with_merge_freeList+0x3c0>
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80322c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322f:	8b 40 04             	mov    0x4(%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 0f                	je     803245 <insert_sorted_with_merge_freeList+0x3d9>
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	8b 40 04             	mov    0x4(%eax),%eax
  80323c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80323f:	8b 12                	mov    (%edx),%edx
  803241:	89 10                	mov    %edx,(%eax)
  803243:	eb 0a                	jmp    80324f <insert_sorted_with_merge_freeList+0x3e3>
  803245:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803248:	8b 00                	mov    (%eax),%eax
  80324a:	a3 38 51 80 00       	mov    %eax,0x805138
  80324f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803252:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 44 51 80 00       	mov    0x805144,%eax
  803267:	48                   	dec    %eax
  803268:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803281:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803285:	75 17                	jne    80329e <insert_sorted_with_merge_freeList+0x432>
  803287:	83 ec 04             	sub    $0x4,%esp
  80328a:	68 94 40 80 00       	push   $0x804094
  80328f:	68 5f 01 00 00       	push   $0x15f
  803294:	68 b7 40 80 00       	push   $0x8040b7
  803299:	e8 ff d0 ff ff       	call   80039d <_panic>
  80329e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a7:	89 10                	mov    %edx,(%eax)
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	8b 00                	mov    (%eax),%eax
  8032ae:	85 c0                	test   %eax,%eax
  8032b0:	74 0d                	je     8032bf <insert_sorted_with_merge_freeList+0x453>
  8032b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032ba:	89 50 04             	mov    %edx,0x4(%eax)
  8032bd:	eb 08                	jmp    8032c7 <insert_sorted_with_merge_freeList+0x45b>
  8032bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8032cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8032de:	40                   	inc    %eax
  8032df:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f0:	01 c2                	add    %eax,%edx
  8032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f5:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80330c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803310:	75 17                	jne    803329 <insert_sorted_with_merge_freeList+0x4bd>
  803312:	83 ec 04             	sub    $0x4,%esp
  803315:	68 94 40 80 00       	push   $0x804094
  80331a:	68 64 01 00 00       	push   $0x164
  80331f:	68 b7 40 80 00       	push   $0x8040b7
  803324:	e8 74 d0 ff ff       	call   80039d <_panic>
  803329:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	89 10                	mov    %edx,(%eax)
  803334:	8b 45 08             	mov    0x8(%ebp),%eax
  803337:	8b 00                	mov    (%eax),%eax
  803339:	85 c0                	test   %eax,%eax
  80333b:	74 0d                	je     80334a <insert_sorted_with_merge_freeList+0x4de>
  80333d:	a1 48 51 80 00       	mov    0x805148,%eax
  803342:	8b 55 08             	mov    0x8(%ebp),%edx
  803345:	89 50 04             	mov    %edx,0x4(%eax)
  803348:	eb 08                	jmp    803352 <insert_sorted_with_merge_freeList+0x4e6>
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	a3 48 51 80 00       	mov    %eax,0x805148
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803364:	a1 54 51 80 00       	mov    0x805154,%eax
  803369:	40                   	inc    %eax
  80336a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80336f:	e9 41 02 00 00       	jmp    8035b5 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	8b 50 08             	mov    0x8(%eax),%edx
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 40 0c             	mov    0xc(%eax),%eax
  803380:	01 c2                	add    %eax,%edx
  803382:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803385:	8b 40 08             	mov    0x8(%eax),%eax
  803388:	39 c2                	cmp    %eax,%edx
  80338a:	0f 85 7c 01 00 00    	jne    80350c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803390:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803394:	74 06                	je     80339c <insert_sorted_with_merge_freeList+0x530>
  803396:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339a:	75 17                	jne    8033b3 <insert_sorted_with_merge_freeList+0x547>
  80339c:	83 ec 04             	sub    $0x4,%esp
  80339f:	68 d0 40 80 00       	push   $0x8040d0
  8033a4:	68 69 01 00 00       	push   $0x169
  8033a9:	68 b7 40 80 00       	push   $0x8040b7
  8033ae:	e8 ea cf ff ff       	call   80039d <_panic>
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	8b 50 04             	mov    0x4(%eax),%edx
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	89 50 04             	mov    %edx,0x4(%eax)
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033c5:	89 10                	mov    %edx,(%eax)
  8033c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ca:	8b 40 04             	mov    0x4(%eax),%eax
  8033cd:	85 c0                	test   %eax,%eax
  8033cf:	74 0d                	je     8033de <insert_sorted_with_merge_freeList+0x572>
  8033d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d4:	8b 40 04             	mov    0x4(%eax),%eax
  8033d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033da:	89 10                	mov    %edx,(%eax)
  8033dc:	eb 08                	jmp    8033e6 <insert_sorted_with_merge_freeList+0x57a>
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8033e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ec:	89 50 04             	mov    %edx,0x4(%eax)
  8033ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8033f4:	40                   	inc    %eax
  8033f5:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 50 0c             	mov    0xc(%eax),%edx
  803400:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803403:	8b 40 0c             	mov    0xc(%eax),%eax
  803406:	01 c2                	add    %eax,%edx
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80340e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803412:	75 17                	jne    80342b <insert_sorted_with_merge_freeList+0x5bf>
  803414:	83 ec 04             	sub    $0x4,%esp
  803417:	68 60 41 80 00       	push   $0x804160
  80341c:	68 6b 01 00 00       	push   $0x16b
  803421:	68 b7 40 80 00       	push   $0x8040b7
  803426:	e8 72 cf ff ff       	call   80039d <_panic>
  80342b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342e:	8b 00                	mov    (%eax),%eax
  803430:	85 c0                	test   %eax,%eax
  803432:	74 10                	je     803444 <insert_sorted_with_merge_freeList+0x5d8>
  803434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803437:	8b 00                	mov    (%eax),%eax
  803439:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80343c:	8b 52 04             	mov    0x4(%edx),%edx
  80343f:	89 50 04             	mov    %edx,0x4(%eax)
  803442:	eb 0b                	jmp    80344f <insert_sorted_with_merge_freeList+0x5e3>
  803444:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803447:	8b 40 04             	mov    0x4(%eax),%eax
  80344a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80344f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803452:	8b 40 04             	mov    0x4(%eax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	74 0f                	je     803468 <insert_sorted_with_merge_freeList+0x5fc>
  803459:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345c:	8b 40 04             	mov    0x4(%eax),%eax
  80345f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803462:	8b 12                	mov    (%edx),%edx
  803464:	89 10                	mov    %edx,(%eax)
  803466:	eb 0a                	jmp    803472 <insert_sorted_with_merge_freeList+0x606>
  803468:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	a3 38 51 80 00       	mov    %eax,0x805138
  803472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80347b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803485:	a1 44 51 80 00       	mov    0x805144,%eax
  80348a:	48                   	dec    %eax
  80348b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803493:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80349a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8034a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034a8:	75 17                	jne    8034c1 <insert_sorted_with_merge_freeList+0x655>
  8034aa:	83 ec 04             	sub    $0x4,%esp
  8034ad:	68 94 40 80 00       	push   $0x804094
  8034b2:	68 6e 01 00 00       	push   $0x16e
  8034b7:	68 b7 40 80 00       	push   $0x8040b7
  8034bc:	e8 dc ce ff ff       	call   80039d <_panic>
  8034c1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ca:	89 10                	mov    %edx,(%eax)
  8034cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	85 c0                	test   %eax,%eax
  8034d3:	74 0d                	je     8034e2 <insert_sorted_with_merge_freeList+0x676>
  8034d5:	a1 48 51 80 00       	mov    0x805148,%eax
  8034da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034dd:	89 50 04             	mov    %edx,0x4(%eax)
  8034e0:	eb 08                	jmp    8034ea <insert_sorted_with_merge_freeList+0x67e>
  8034e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ed:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fc:	a1 54 51 80 00       	mov    0x805154,%eax
  803501:	40                   	inc    %eax
  803502:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803507:	e9 a9 00 00 00       	jmp    8035b5 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80350c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803510:	74 06                	je     803518 <insert_sorted_with_merge_freeList+0x6ac>
  803512:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803516:	75 17                	jne    80352f <insert_sorted_with_merge_freeList+0x6c3>
  803518:	83 ec 04             	sub    $0x4,%esp
  80351b:	68 2c 41 80 00       	push   $0x80412c
  803520:	68 73 01 00 00       	push   $0x173
  803525:	68 b7 40 80 00       	push   $0x8040b7
  80352a:	e8 6e ce ff ff       	call   80039d <_panic>
  80352f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803532:	8b 10                	mov    (%eax),%edx
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	89 10                	mov    %edx,(%eax)
  803539:	8b 45 08             	mov    0x8(%ebp),%eax
  80353c:	8b 00                	mov    (%eax),%eax
  80353e:	85 c0                	test   %eax,%eax
  803540:	74 0b                	je     80354d <insert_sorted_with_merge_freeList+0x6e1>
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	8b 00                	mov    (%eax),%eax
  803547:	8b 55 08             	mov    0x8(%ebp),%edx
  80354a:	89 50 04             	mov    %edx,0x4(%eax)
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	8b 55 08             	mov    0x8(%ebp),%edx
  803553:	89 10                	mov    %edx,(%eax)
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80355b:	89 50 04             	mov    %edx,0x4(%eax)
  80355e:	8b 45 08             	mov    0x8(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	85 c0                	test   %eax,%eax
  803565:	75 08                	jne    80356f <insert_sorted_with_merge_freeList+0x703>
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80356f:	a1 44 51 80 00       	mov    0x805144,%eax
  803574:	40                   	inc    %eax
  803575:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80357a:	eb 39                	jmp    8035b5 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80357c:	a1 40 51 80 00       	mov    0x805140,%eax
  803581:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803588:	74 07                	je     803591 <insert_sorted_with_merge_freeList+0x725>
  80358a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	eb 05                	jmp    803596 <insert_sorted_with_merge_freeList+0x72a>
  803591:	b8 00 00 00 00       	mov    $0x0,%eax
  803596:	a3 40 51 80 00       	mov    %eax,0x805140
  80359b:	a1 40 51 80 00       	mov    0x805140,%eax
  8035a0:	85 c0                	test   %eax,%eax
  8035a2:	0f 85 c7 fb ff ff    	jne    80316f <insert_sorted_with_merge_freeList+0x303>
  8035a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035ac:	0f 85 bd fb ff ff    	jne    80316f <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035b2:	eb 01                	jmp    8035b5 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8035b4:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8035b5:	90                   	nop
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
