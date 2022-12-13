
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
  80008d:	68 c0 36 80 00       	push   $0x8036c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 36 80 00       	push   $0x8036dc
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
  8000ab:	e8 cf 1a 00 00       	call   801b7f <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 bb 18 00 00       	call   801973 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 c9 17 00 00       	call   801886 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f7 36 80 00       	push   $0x8036f7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 12 16 00 00       	call   8016e2 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 fc 36 80 00       	push   $0x8036fc
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 dc 36 80 00       	push   $0x8036dc
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 8b 17 00 00       	call   801886 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 5c 37 80 00       	push   $0x80375c
  80010c:	6a 21                	push   $0x21
  80010e:	68 dc 36 80 00       	push   $0x8036dc
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 70 18 00 00       	call   80198d <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 51 18 00 00       	call   801973 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 5f 17 00 00       	call   801886 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ed 37 80 00       	push   $0x8037ed
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 a8 15 00 00       	call   8016e2 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 fc 36 80 00       	push   $0x8036fc
  800151:	6a 27                	push   $0x27
  800153:	68 dc 36 80 00       	push   $0x8036dc
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 24 17 00 00       	call   801886 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 5c 37 80 00       	push   $0x80375c
  800173:	6a 28                	push   $0x28
  800175:	68 dc 36 80 00       	push   $0x8036dc
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 09 18 00 00       	call   80198d <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 f0 37 80 00       	push   $0x8037f0
  800196:	6a 2b                	push   $0x2b
  800198:	68 dc 36 80 00       	push   $0x8036dc
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 cc 17 00 00       	call   801973 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 da 16 00 00       	call   801886 <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 27 38 80 00       	push   $0x803827
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 23 15 00 00       	call   8016e2 <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 fc 36 80 00       	push   $0x8036fc
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 dc 36 80 00       	push   $0x8036dc
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 9f 16 00 00       	call   801886 <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 5c 37 80 00       	push   $0x80375c
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 dc 36 80 00       	push   $0x8036dc
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 84 17 00 00       	call   80198d <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 f0 37 80 00       	push   $0x8037f0
  80021b:	6a 34                	push   $0x34
  80021d:	68 dc 36 80 00       	push   $0x8036dc
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
  800245:	68 f0 37 80 00       	push   $0x8037f0
  80024a:	6a 37                	push   $0x37
  80024c:	68 dc 36 80 00       	push   $0x8036dc
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 49 1a 00 00       	call   801ca4 <inctst>

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
  800267:	e8 fa 18 00 00       	call   801b66 <sys_getenvindex>
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
  8002d2:	e8 9c 16 00 00       	call   801973 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 44 38 80 00       	push   $0x803844
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
  800302:	68 6c 38 80 00       	push   $0x80386c
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
  800333:	68 94 38 80 00       	push   $0x803894
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 50 80 00       	mov    0x805020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 ec 38 80 00       	push   $0x8038ec
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 44 38 80 00       	push   $0x803844
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 1c 16 00 00       	call   80198d <sys_enable_interrupt>

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
  800384:	e8 a9 17 00 00       	call   801b32 <sys_destroy_env>
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
  800395:	e8 fe 17 00 00       	call   801b98 <sys_exit_env>
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
  8003be:	68 00 39 80 00       	push   $0x803900
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 05 39 80 00       	push   $0x803905
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
  8003fb:	68 21 39 80 00       	push   $0x803921
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
  800427:	68 24 39 80 00       	push   $0x803924
  80042c:	6a 26                	push   $0x26
  80042e:	68 70 39 80 00       	push   $0x803970
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
  8004f9:	68 7c 39 80 00       	push   $0x80397c
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 70 39 80 00       	push   $0x803970
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
  800569:	68 d0 39 80 00       	push   $0x8039d0
  80056e:	6a 44                	push   $0x44
  800570:	68 70 39 80 00       	push   $0x803970
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
  8005c3:	e8 fd 11 00 00       	call   8017c5 <sys_cputs>
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
  80063a:	e8 86 11 00 00       	call   8017c5 <sys_cputs>
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
  800684:	e8 ea 12 00 00       	call   801973 <sys_disable_interrupt>
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
  8006a4:	e8 e4 12 00 00       	call   80198d <sys_enable_interrupt>
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
  8006ee:	e8 55 2d 00 00       	call   803448 <__udivdi3>
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
  80073e:	e8 15 2e 00 00       	call   803558 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 34 3c 80 00       	add    $0x803c34,%eax
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
  800899:	8b 04 85 58 3c 80 00 	mov    0x803c58(,%eax,4),%eax
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
  80097a:	8b 34 9d a0 3a 80 00 	mov    0x803aa0(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 45 3c 80 00       	push   $0x803c45
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
  80099f:	68 4e 3c 80 00       	push   $0x803c4e
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
  8009cc:	be 51 3c 80 00       	mov    $0x803c51,%esi
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
  8013f2:	68 b0 3d 80 00       	push   $0x803db0
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
  8014c2:	e8 42 04 00 00       	call   801909 <sys_allocate_chunk>
  8014c7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 b7 0a 00 00       	call   801f8f <initialize_MemBlocksList>
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
  801500:	68 d5 3d 80 00       	push   $0x803dd5
  801505:	6a 33                	push   $0x33
  801507:	68 f3 3d 80 00       	push   $0x803df3
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
  80157f:	68 00 3e 80 00       	push   $0x803e00
  801584:	6a 34                	push   $0x34
  801586:	68 f3 3d 80 00       	push   $0x803df3
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
  8015dc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015df:	e8 f7 fd ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  8015e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e8:	75 07                	jne    8015f1 <malloc+0x18>
  8015ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ef:	eb 14                	jmp    801605 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015f1:	83 ec 04             	sub    $0x4,%esp
  8015f4:	68 24 3e 80 00       	push   $0x803e24
  8015f9:	6a 46                	push   $0x46
  8015fb:	68 f3 3d 80 00       	push   $0x803df3
  801600:	e8 98 ed ff ff       	call   80039d <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801605:	c9                   	leave  
  801606:	c3                   	ret    

00801607 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801607:	55                   	push   %ebp
  801608:	89 e5                	mov    %esp,%ebp
  80160a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	68 4c 3e 80 00       	push   $0x803e4c
  801615:	6a 61                	push   $0x61
  801617:	68 f3 3d 80 00       	push   $0x803df3
  80161c:	e8 7c ed ff ff       	call   80039d <_panic>

00801621 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 38             	sub    $0x38,%esp
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162d:	e8 a9 fd ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  801632:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801636:	75 0a                	jne    801642 <smalloc+0x21>
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	e9 9e 00 00 00       	jmp    8016e0 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801642:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801649:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	01 d0                	add    %edx,%eax
  801651:	48                   	dec    %eax
  801652:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801658:	ba 00 00 00 00       	mov    $0x0,%edx
  80165d:	f7 75 f0             	divl   -0x10(%ebp)
  801660:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801663:	29 d0                	sub    %edx,%eax
  801665:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801668:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80166f:	e8 63 06 00 00       	call   801cd7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801674:	85 c0                	test   %eax,%eax
  801676:	74 11                	je     801689 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801678:	83 ec 0c             	sub    $0xc,%esp
  80167b:	ff 75 e8             	pushl  -0x18(%ebp)
  80167e:	e8 ce 0c 00 00       	call   802351 <alloc_block_FF>
  801683:	83 c4 10             	add    $0x10,%esp
  801686:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801689:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80168d:	74 4c                	je     8016db <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801692:	8b 40 08             	mov    0x8(%eax),%eax
  801695:	89 c2                	mov    %eax,%edx
  801697:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80169b:	52                   	push   %edx
  80169c:	50                   	push   %eax
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	ff 75 08             	pushl  0x8(%ebp)
  8016a3:	e8 b4 03 00 00       	call   801a5c <sys_createSharedObject>
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	ff 75 e0             	pushl  -0x20(%ebp)
  8016b4:	68 6f 3e 80 00       	push   $0x803e6f
  8016b9:	e8 93 ef ff ff       	call   800651 <cprintf>
  8016be:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016c1:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016c5:	74 14                	je     8016db <smalloc+0xba>
  8016c7:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016cb:	74 0e                	je     8016db <smalloc+0xba>
  8016cd:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016d1:	74 08                	je     8016db <smalloc+0xba>
			return (void*) mem_block->sva;
  8016d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d6:	8b 40 08             	mov    0x8(%eax),%eax
  8016d9:	eb 05                	jmp    8016e0 <smalloc+0xbf>
	}
	return NULL;
  8016db:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e8:	e8 ee fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	68 84 3e 80 00       	push   $0x803e84
  8016f5:	68 ab 00 00 00       	push   $0xab
  8016fa:	68 f3 3d 80 00       	push   $0x803df3
  8016ff:	e8 99 ec ff ff       	call   80039d <_panic>

00801704 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80170a:	e8 cc fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	68 a8 3e 80 00       	push   $0x803ea8
  801717:	68 ef 00 00 00       	push   $0xef
  80171c:	68 f3 3d 80 00       	push   $0x803df3
  801721:	e8 77 ec ff ff       	call   80039d <_panic>

00801726 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	68 d0 3e 80 00       	push   $0x803ed0
  801734:	68 03 01 00 00       	push   $0x103
  801739:	68 f3 3d 80 00       	push   $0x803df3
  80173e:	e8 5a ec ff ff       	call   80039d <_panic>

00801743 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801743:	55                   	push   %ebp
  801744:	89 e5                	mov    %esp,%ebp
  801746:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	68 f4 3e 80 00       	push   $0x803ef4
  801751:	68 0e 01 00 00       	push   $0x10e
  801756:	68 f3 3d 80 00       	push   $0x803df3
  80175b:	e8 3d ec ff ff       	call   80039d <_panic>

00801760 <shrink>:

}
void shrink(uint32 newSize)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801766:	83 ec 04             	sub    $0x4,%esp
  801769:	68 f4 3e 80 00       	push   $0x803ef4
  80176e:	68 13 01 00 00       	push   $0x113
  801773:	68 f3 3d 80 00       	push   $0x803df3
  801778:	e8 20 ec ff ff       	call   80039d <_panic>

0080177d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80177d:	55                   	push   %ebp
  80177e:	89 e5                	mov    %esp,%ebp
  801780:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	68 f4 3e 80 00       	push   $0x803ef4
  80178b:	68 18 01 00 00       	push   $0x118
  801790:	68 f3 3d 80 00       	push   $0x803df3
  801795:	e8 03 ec ff ff       	call   80039d <_panic>

0080179a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	57                   	push   %edi
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
  8017a0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017af:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017b2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017b5:	cd 30                	int    $0x30
  8017b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017bd:	83 c4 10             	add    $0x10,%esp
  8017c0:	5b                   	pop    %ebx
  8017c1:	5e                   	pop    %esi
  8017c2:	5f                   	pop    %edi
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    

008017c5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017d1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	52                   	push   %edx
  8017dd:	ff 75 0c             	pushl  0xc(%ebp)
  8017e0:	50                   	push   %eax
  8017e1:	6a 00                	push   $0x0
  8017e3:	e8 b2 ff ff ff       	call   80179a <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	90                   	nop
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 01                	push   $0x1
  8017fd:	e8 98 ff ff ff       	call   80179a <syscall>
  801802:	83 c4 18             	add    $0x18,%esp
}
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80180a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	6a 00                	push   $0x0
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	52                   	push   %edx
  801817:	50                   	push   %eax
  801818:	6a 05                	push   $0x5
  80181a:	e8 7b ff ff ff       	call   80179a <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	c9                   	leave  
  801823:	c3                   	ret    

00801824 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	56                   	push   %esi
  801828:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801829:	8b 75 18             	mov    0x18(%ebp),%esi
  80182c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801832:	8b 55 0c             	mov    0xc(%ebp),%edx
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
  80183a:	51                   	push   %ecx
  80183b:	52                   	push   %edx
  80183c:	50                   	push   %eax
  80183d:	6a 06                	push   $0x6
  80183f:	e8 56 ff ff ff       	call   80179a <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80184a:	5b                   	pop    %ebx
  80184b:	5e                   	pop    %esi
  80184c:	5d                   	pop    %ebp
  80184d:	c3                   	ret    

0080184e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801851:	8b 55 0c             	mov    0xc(%ebp),%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	52                   	push   %edx
  80185e:	50                   	push   %eax
  80185f:	6a 07                	push   $0x7
  801861:	e8 34 ff ff ff       	call   80179a <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	ff 75 0c             	pushl  0xc(%ebp)
  801877:	ff 75 08             	pushl  0x8(%ebp)
  80187a:	6a 08                	push   $0x8
  80187c:	e8 19 ff ff ff       	call   80179a <syscall>
  801881:	83 c4 18             	add    $0x18,%esp
}
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 09                	push   $0x9
  801895:	e8 00 ff ff ff       	call   80179a <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 0a                	push   $0xa
  8018ae:	e8 e7 fe ff ff       	call   80179a <syscall>
  8018b3:	83 c4 18             	add    $0x18,%esp
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 0b                	push   $0xb
  8018c7:	e8 ce fe ff ff       	call   80179a <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	ff 75 0c             	pushl  0xc(%ebp)
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	6a 0f                	push   $0xf
  8018e2:	e8 b3 fe ff ff       	call   80179a <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
	return;
  8018ea:	90                   	nop
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	ff 75 0c             	pushl  0xc(%ebp)
  8018f9:	ff 75 08             	pushl  0x8(%ebp)
  8018fc:	6a 10                	push   $0x10
  8018fe:	e8 97 fe ff ff       	call   80179a <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
	return ;
  801906:	90                   	nop
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	ff 75 10             	pushl  0x10(%ebp)
  801913:	ff 75 0c             	pushl  0xc(%ebp)
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	6a 11                	push   $0x11
  80191b:	e8 7a fe ff ff       	call   80179a <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
	return ;
  801923:	90                   	nop
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 0c                	push   $0xc
  801935:	e8 60 fe ff ff       	call   80179a <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	6a 0d                	push   $0xd
  80194f:	e8 46 fe ff ff       	call   80179a <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 0e                	push   $0xe
  801968:	e8 2d fe ff ff       	call   80179a <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	90                   	nop
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 13                	push   $0x13
  801982:	e8 13 fe ff ff       	call   80179a <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	90                   	nop
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 14                	push   $0x14
  80199c:	e8 f9 fd ff ff       	call   80179a <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	90                   	nop
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019b3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	50                   	push   %eax
  8019c0:	6a 15                	push   $0x15
  8019c2:	e8 d3 fd ff ff       	call   80179a <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	90                   	nop
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 16                	push   $0x16
  8019dc:	e8 b9 fd ff ff       	call   80179a <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	90                   	nop
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	ff 75 0c             	pushl  0xc(%ebp)
  8019f6:	50                   	push   %eax
  8019f7:	6a 17                	push   $0x17
  8019f9:	e8 9c fd ff ff       	call   80179a <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	52                   	push   %edx
  801a13:	50                   	push   %eax
  801a14:	6a 1a                	push   $0x1a
  801a16:	e8 7f fd ff ff       	call   80179a <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	52                   	push   %edx
  801a30:	50                   	push   %eax
  801a31:	6a 18                	push   $0x18
  801a33:	e8 62 fd ff ff       	call   80179a <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	90                   	nop
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	6a 19                	push   $0x19
  801a51:	e8 44 fd ff ff       	call   80179a <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	90                   	nop
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	83 ec 04             	sub    $0x4,%esp
  801a62:	8b 45 10             	mov    0x10(%ebp),%eax
  801a65:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a68:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a6b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	51                   	push   %ecx
  801a75:	52                   	push   %edx
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	50                   	push   %eax
  801a7a:	6a 1b                	push   $0x1b
  801a7c:	e8 19 fd ff ff       	call   80179a <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	52                   	push   %edx
  801a96:	50                   	push   %eax
  801a97:	6a 1c                	push   $0x1c
  801a99:	e8 fc fc ff ff       	call   80179a <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	51                   	push   %ecx
  801ab4:	52                   	push   %edx
  801ab5:	50                   	push   %eax
  801ab6:	6a 1d                	push   $0x1d
  801ab8:	e8 dd fc ff ff       	call   80179a <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	52                   	push   %edx
  801ad2:	50                   	push   %eax
  801ad3:	6a 1e                	push   $0x1e
  801ad5:	e8 c0 fc ff ff       	call   80179a <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 1f                	push   $0x1f
  801aee:	e8 a7 fc ff ff       	call   80179a <syscall>
  801af3:	83 c4 18             	add    $0x18,%esp
}
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	6a 00                	push   $0x0
  801b00:	ff 75 14             	pushl  0x14(%ebp)
  801b03:	ff 75 10             	pushl  0x10(%ebp)
  801b06:	ff 75 0c             	pushl  0xc(%ebp)
  801b09:	50                   	push   %eax
  801b0a:	6a 20                	push   $0x20
  801b0c:	e8 89 fc ff ff       	call   80179a <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	50                   	push   %eax
  801b25:	6a 21                	push   $0x21
  801b27:	e8 6e fc ff ff       	call   80179a <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	90                   	nop
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	50                   	push   %eax
  801b41:	6a 22                	push   $0x22
  801b43:	e8 52 fc ff ff       	call   80179a <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 02                	push   $0x2
  801b5c:	e8 39 fc ff ff       	call   80179a <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 03                	push   $0x3
  801b75:	e8 20 fc ff ff       	call   80179a <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 04                	push   $0x4
  801b8e:	e8 07 fc ff ff       	call   80179a <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_exit_env>:


void sys_exit_env(void)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 23                	push   $0x23
  801ba7:	e8 ee fb ff ff       	call   80179a <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	90                   	nop
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bb8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bbb:	8d 50 04             	lea    0x4(%eax),%edx
  801bbe:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	52                   	push   %edx
  801bc8:	50                   	push   %eax
  801bc9:	6a 24                	push   $0x24
  801bcb:	e8 ca fb ff ff       	call   80179a <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return result;
  801bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bdc:	89 01                	mov    %eax,(%ecx)
  801bde:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801be1:	8b 45 08             	mov    0x8(%ebp),%eax
  801be4:	c9                   	leave  
  801be5:	c2 04 00             	ret    $0x4

00801be8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	ff 75 10             	pushl  0x10(%ebp)
  801bf2:	ff 75 0c             	pushl  0xc(%ebp)
  801bf5:	ff 75 08             	pushl  0x8(%ebp)
  801bf8:	6a 12                	push   $0x12
  801bfa:	e8 9b fb ff ff       	call   80179a <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
	return ;
  801c02:	90                   	nop
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 25                	push   $0x25
  801c14:	e8 81 fb ff ff       	call   80179a <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c2a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	50                   	push   %eax
  801c37:	6a 26                	push   $0x26
  801c39:	e8 5c fb ff ff       	call   80179a <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c41:	90                   	nop
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <rsttst>:
void rsttst()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 28                	push   $0x28
  801c53:	e8 42 fb ff ff       	call   80179a <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5b:	90                   	nop
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c6a:	8b 55 18             	mov    0x18(%ebp),%edx
  801c6d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c71:	52                   	push   %edx
  801c72:	50                   	push   %eax
  801c73:	ff 75 10             	pushl  0x10(%ebp)
  801c76:	ff 75 0c             	pushl  0xc(%ebp)
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	6a 27                	push   $0x27
  801c7e:	e8 17 fb ff ff       	call   80179a <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
	return ;
  801c86:	90                   	nop
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <chktst>:
void chktst(uint32 n)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	ff 75 08             	pushl  0x8(%ebp)
  801c97:	6a 29                	push   $0x29
  801c99:	e8 fc fa ff ff       	call   80179a <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca1:	90                   	nop
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <inctst>:

void inctst()
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 2a                	push   $0x2a
  801cb3:	e8 e2 fa ff ff       	call   80179a <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbb:	90                   	nop
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <gettst>:
uint32 gettst()
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 2b                	push   $0x2b
  801ccd:	e8 c8 fa ff ff       	call   80179a <syscall>
  801cd2:	83 c4 18             	add    $0x18,%esp
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 2c                	push   $0x2c
  801ce9:	e8 ac fa ff ff       	call   80179a <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
  801cf1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cf4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cf8:	75 07                	jne    801d01 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801cff:	eb 05                	jmp    801d06 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 2c                	push   $0x2c
  801d1a:	e8 7b fa ff ff       	call   80179a <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
  801d22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d25:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d29:	75 07                	jne    801d32 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d30:	eb 05                	jmp    801d37 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d37:	c9                   	leave  
  801d38:	c3                   	ret    

00801d39 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 2c                	push   $0x2c
  801d4b:	e8 4a fa ff ff       	call   80179a <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
  801d53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d56:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d5a:	75 07                	jne    801d63 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d61:	eb 05                	jmp    801d68 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
  801d6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 2c                	push   $0x2c
  801d7c:	e8 19 fa ff ff       	call   80179a <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
  801d84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d87:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d8b:	75 07                	jne    801d94 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d92:	eb 05                	jmp    801d99 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	6a 2d                	push   $0x2d
  801dab:	e8 ea f9 ff ff       	call   80179a <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
	return ;
  801db3:	90                   	nop
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dbd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc6:	6a 00                	push   $0x0
  801dc8:	53                   	push   %ebx
  801dc9:	51                   	push   %ecx
  801dca:	52                   	push   %edx
  801dcb:	50                   	push   %eax
  801dcc:	6a 2e                	push   $0x2e
  801dce:	e8 c7 f9 ff ff       	call   80179a <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
}
  801dd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	52                   	push   %edx
  801deb:	50                   	push   %eax
  801dec:	6a 2f                	push   $0x2f
  801dee:	e8 a7 f9 ff ff       	call   80179a <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	68 04 3f 80 00       	push   $0x803f04
  801e06:	e8 46 e8 ff ff       	call   800651 <cprintf>
  801e0b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e15:	83 ec 0c             	sub    $0xc,%esp
  801e18:	68 30 3f 80 00       	push   $0x803f30
  801e1d:	e8 2f e8 ff ff       	call   800651 <cprintf>
  801e22:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e25:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e29:	a1 38 51 80 00       	mov    0x805138,%eax
  801e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e31:	eb 56                	jmp    801e89 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e37:	74 1c                	je     801e55 <print_mem_block_lists+0x5d>
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	8b 50 08             	mov    0x8(%eax),%edx
  801e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e42:	8b 48 08             	mov    0x8(%eax),%ecx
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e48:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4b:	01 c8                	add    %ecx,%eax
  801e4d:	39 c2                	cmp    %eax,%edx
  801e4f:	73 04                	jae    801e55 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e51:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e58:	8b 50 08             	mov    0x8(%eax),%edx
  801e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e61:	01 c2                	add    %eax,%edx
  801e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e66:	8b 40 08             	mov    0x8(%eax),%eax
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	52                   	push   %edx
  801e6d:	50                   	push   %eax
  801e6e:	68 45 3f 80 00       	push   $0x803f45
  801e73:	e8 d9 e7 ff ff       	call   800651 <cprintf>
  801e78:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e81:	a1 40 51 80 00       	mov    0x805140,%eax
  801e86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e8d:	74 07                	je     801e96 <print_mem_block_lists+0x9e>
  801e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e92:	8b 00                	mov    (%eax),%eax
  801e94:	eb 05                	jmp    801e9b <print_mem_block_lists+0xa3>
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	a3 40 51 80 00       	mov    %eax,0x805140
  801ea0:	a1 40 51 80 00       	mov    0x805140,%eax
  801ea5:	85 c0                	test   %eax,%eax
  801ea7:	75 8a                	jne    801e33 <print_mem_block_lists+0x3b>
  801ea9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ead:	75 84                	jne    801e33 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eaf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eb3:	75 10                	jne    801ec5 <print_mem_block_lists+0xcd>
  801eb5:	83 ec 0c             	sub    $0xc,%esp
  801eb8:	68 54 3f 80 00       	push   $0x803f54
  801ebd:	e8 8f e7 ff ff       	call   800651 <cprintf>
  801ec2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ec5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ecc:	83 ec 0c             	sub    $0xc,%esp
  801ecf:	68 78 3f 80 00       	push   $0x803f78
  801ed4:	e8 78 e7 ff ff       	call   800651 <cprintf>
  801ed9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801edc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ee0:	a1 40 50 80 00       	mov    0x805040,%eax
  801ee5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee8:	eb 56                	jmp    801f40 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eee:	74 1c                	je     801f0c <print_mem_block_lists+0x114>
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	8b 50 08             	mov    0x8(%eax),%edx
  801ef6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef9:	8b 48 08             	mov    0x8(%eax),%ecx
  801efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eff:	8b 40 0c             	mov    0xc(%eax),%eax
  801f02:	01 c8                	add    %ecx,%eax
  801f04:	39 c2                	cmp    %eax,%edx
  801f06:	73 04                	jae    801f0c <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f08:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	8b 50 08             	mov    0x8(%eax),%edx
  801f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f15:	8b 40 0c             	mov    0xc(%eax),%eax
  801f18:	01 c2                	add    %eax,%edx
  801f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1d:	8b 40 08             	mov    0x8(%eax),%eax
  801f20:	83 ec 04             	sub    $0x4,%esp
  801f23:	52                   	push   %edx
  801f24:	50                   	push   %eax
  801f25:	68 45 3f 80 00       	push   $0x803f45
  801f2a:	e8 22 e7 ff ff       	call   800651 <cprintf>
  801f2f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f38:	a1 48 50 80 00       	mov    0x805048,%eax
  801f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f44:	74 07                	je     801f4d <print_mem_block_lists+0x155>
  801f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f49:	8b 00                	mov    (%eax),%eax
  801f4b:	eb 05                	jmp    801f52 <print_mem_block_lists+0x15a>
  801f4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f52:	a3 48 50 80 00       	mov    %eax,0x805048
  801f57:	a1 48 50 80 00       	mov    0x805048,%eax
  801f5c:	85 c0                	test   %eax,%eax
  801f5e:	75 8a                	jne    801eea <print_mem_block_lists+0xf2>
  801f60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f64:	75 84                	jne    801eea <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f66:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f6a:	75 10                	jne    801f7c <print_mem_block_lists+0x184>
  801f6c:	83 ec 0c             	sub    $0xc,%esp
  801f6f:	68 90 3f 80 00       	push   $0x803f90
  801f74:	e8 d8 e6 ff ff       	call   800651 <cprintf>
  801f79:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	68 04 3f 80 00       	push   $0x803f04
  801f84:	e8 c8 e6 ff ff       	call   800651 <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp

}
  801f8c:	90                   	nop
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f95:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f9c:	00 00 00 
  801f9f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801fa6:	00 00 00 
  801fa9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fb0:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fba:	e9 9e 00 00 00       	jmp    80205d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fbf:	a1 50 50 80 00       	mov    0x805050,%eax
  801fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc7:	c1 e2 04             	shl    $0x4,%edx
  801fca:	01 d0                	add    %edx,%eax
  801fcc:	85 c0                	test   %eax,%eax
  801fce:	75 14                	jne    801fe4 <initialize_MemBlocksList+0x55>
  801fd0:	83 ec 04             	sub    $0x4,%esp
  801fd3:	68 b8 3f 80 00       	push   $0x803fb8
  801fd8:	6a 46                	push   $0x46
  801fda:	68 db 3f 80 00       	push   $0x803fdb
  801fdf:	e8 b9 e3 ff ff       	call   80039d <_panic>
  801fe4:	a1 50 50 80 00       	mov    0x805050,%eax
  801fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fec:	c1 e2 04             	shl    $0x4,%edx
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801ff7:	89 10                	mov    %edx,(%eax)
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	74 18                	je     802017 <initialize_MemBlocksList+0x88>
  801fff:	a1 48 51 80 00       	mov    0x805148,%eax
  802004:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80200a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80200d:	c1 e1 04             	shl    $0x4,%ecx
  802010:	01 ca                	add    %ecx,%edx
  802012:	89 50 04             	mov    %edx,0x4(%eax)
  802015:	eb 12                	jmp    802029 <initialize_MemBlocksList+0x9a>
  802017:	a1 50 50 80 00       	mov    0x805050,%eax
  80201c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201f:	c1 e2 04             	shl    $0x4,%edx
  802022:	01 d0                	add    %edx,%eax
  802024:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802029:	a1 50 50 80 00       	mov    0x805050,%eax
  80202e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802031:	c1 e2 04             	shl    $0x4,%edx
  802034:	01 d0                	add    %edx,%eax
  802036:	a3 48 51 80 00       	mov    %eax,0x805148
  80203b:	a1 50 50 80 00       	mov    0x805050,%eax
  802040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802043:	c1 e2 04             	shl    $0x4,%edx
  802046:	01 d0                	add    %edx,%eax
  802048:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80204f:	a1 54 51 80 00       	mov    0x805154,%eax
  802054:	40                   	inc    %eax
  802055:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80205a:	ff 45 f4             	incl   -0xc(%ebp)
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	3b 45 08             	cmp    0x8(%ebp),%eax
  802063:	0f 82 56 ff ff ff    	jb     801fbf <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802069:	90                   	nop
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	8b 00                	mov    (%eax),%eax
  802077:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80207a:	eb 19                	jmp    802095 <find_block+0x29>
	{
		if(va==point->sva)
  80207c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207f:	8b 40 08             	mov    0x8(%eax),%eax
  802082:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802085:	75 05                	jne    80208c <find_block+0x20>
		   return point;
  802087:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80208a:	eb 36                	jmp    8020c2 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	8b 40 08             	mov    0x8(%eax),%eax
  802092:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802095:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802099:	74 07                	je     8020a2 <find_block+0x36>
  80209b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80209e:	8b 00                	mov    (%eax),%eax
  8020a0:	eb 05                	jmp    8020a7 <find_block+0x3b>
  8020a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020aa:	89 42 08             	mov    %eax,0x8(%edx)
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8b 40 08             	mov    0x8(%eax),%eax
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	75 c5                	jne    80207c <find_block+0x10>
  8020b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020bb:	75 bf                	jne    80207c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020ca:	a1 40 50 80 00       	mov    0x805040,%eax
  8020cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020d2:	a1 44 50 80 00       	mov    0x805044,%eax
  8020d7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020e0:	74 24                	je     802106 <insert_sorted_allocList+0x42>
  8020e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e5:	8b 50 08             	mov    0x8(%eax),%edx
  8020e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020eb:	8b 40 08             	mov    0x8(%eax),%eax
  8020ee:	39 c2                	cmp    %eax,%edx
  8020f0:	76 14                	jbe    802106 <insert_sorted_allocList+0x42>
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	8b 50 08             	mov    0x8(%eax),%edx
  8020f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fb:	8b 40 08             	mov    0x8(%eax),%eax
  8020fe:	39 c2                	cmp    %eax,%edx
  802100:	0f 82 60 01 00 00    	jb     802266 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802106:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80210a:	75 65                	jne    802171 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80210c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802110:	75 14                	jne    802126 <insert_sorted_allocList+0x62>
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	68 b8 3f 80 00       	push   $0x803fb8
  80211a:	6a 6b                	push   $0x6b
  80211c:	68 db 3f 80 00       	push   $0x803fdb
  802121:	e8 77 e2 ff ff       	call   80039d <_panic>
  802126:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	89 10                	mov    %edx,(%eax)
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8b 00                	mov    (%eax),%eax
  802136:	85 c0                	test   %eax,%eax
  802138:	74 0d                	je     802147 <insert_sorted_allocList+0x83>
  80213a:	a1 40 50 80 00       	mov    0x805040,%eax
  80213f:	8b 55 08             	mov    0x8(%ebp),%edx
  802142:	89 50 04             	mov    %edx,0x4(%eax)
  802145:	eb 08                	jmp    80214f <insert_sorted_allocList+0x8b>
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	a3 44 50 80 00       	mov    %eax,0x805044
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	a3 40 50 80 00       	mov    %eax,0x805040
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802161:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802166:	40                   	inc    %eax
  802167:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80216c:	e9 dc 01 00 00       	jmp    80234d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8b 50 08             	mov    0x8(%eax),%edx
  802177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217a:	8b 40 08             	mov    0x8(%eax),%eax
  80217d:	39 c2                	cmp    %eax,%edx
  80217f:	77 6c                	ja     8021ed <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802185:	74 06                	je     80218d <insert_sorted_allocList+0xc9>
  802187:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218b:	75 14                	jne    8021a1 <insert_sorted_allocList+0xdd>
  80218d:	83 ec 04             	sub    $0x4,%esp
  802190:	68 f4 3f 80 00       	push   $0x803ff4
  802195:	6a 6f                	push   $0x6f
  802197:	68 db 3f 80 00       	push   $0x803fdb
  80219c:	e8 fc e1 ff ff       	call   80039d <_panic>
  8021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a4:	8b 50 04             	mov    0x4(%eax),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	89 50 04             	mov    %edx,0x4(%eax)
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021b3:	89 10                	mov    %edx,(%eax)
  8021b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b8:	8b 40 04             	mov    0x4(%eax),%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	74 0d                	je     8021cc <insert_sorted_allocList+0x108>
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	8b 40 04             	mov    0x4(%eax),%eax
  8021c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c8:	89 10                	mov    %edx,(%eax)
  8021ca:	eb 08                	jmp    8021d4 <insert_sorted_allocList+0x110>
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	a3 40 50 80 00       	mov    %eax,0x805040
  8021d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021da:	89 50 04             	mov    %edx,0x4(%eax)
  8021dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021e2:	40                   	inc    %eax
  8021e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021e8:	e9 60 01 00 00       	jmp    80234d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 50 08             	mov    0x8(%eax),%edx
  8021f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f6:	8b 40 08             	mov    0x8(%eax),%eax
  8021f9:	39 c2                	cmp    %eax,%edx
  8021fb:	0f 82 4c 01 00 00    	jb     80234d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802205:	75 14                	jne    80221b <insert_sorted_allocList+0x157>
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 2c 40 80 00       	push   $0x80402c
  80220f:	6a 73                	push   $0x73
  802211:	68 db 3f 80 00       	push   $0x803fdb
  802216:	e8 82 e1 ff ff       	call   80039d <_panic>
  80221b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	89 50 04             	mov    %edx,0x4(%eax)
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	8b 40 04             	mov    0x4(%eax),%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	74 0c                	je     80223d <insert_sorted_allocList+0x179>
  802231:	a1 44 50 80 00       	mov    0x805044,%eax
  802236:	8b 55 08             	mov    0x8(%ebp),%edx
  802239:	89 10                	mov    %edx,(%eax)
  80223b:	eb 08                	jmp    802245 <insert_sorted_allocList+0x181>
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	a3 40 50 80 00       	mov    %eax,0x805040
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	a3 44 50 80 00       	mov    %eax,0x805044
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802256:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80225b:	40                   	inc    %eax
  80225c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802261:	e9 e7 00 00 00       	jmp    80234d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802269:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80226c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802273:	a1 40 50 80 00       	mov    0x805040,%eax
  802278:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80227b:	e9 9d 00 00 00       	jmp    80231d <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	8b 50 08             	mov    0x8(%eax),%edx
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 40 08             	mov    0x8(%eax),%eax
  802294:	39 c2                	cmp    %eax,%edx
  802296:	76 7d                	jbe    802315 <insert_sorted_allocList+0x251>
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	8b 50 08             	mov    0x8(%eax),%edx
  80229e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022a1:	8b 40 08             	mov    0x8(%eax),%eax
  8022a4:	39 c2                	cmp    %eax,%edx
  8022a6:	73 6d                	jae    802315 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ac:	74 06                	je     8022b4 <insert_sorted_allocList+0x1f0>
  8022ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b2:	75 14                	jne    8022c8 <insert_sorted_allocList+0x204>
  8022b4:	83 ec 04             	sub    $0x4,%esp
  8022b7:	68 50 40 80 00       	push   $0x804050
  8022bc:	6a 7f                	push   $0x7f
  8022be:	68 db 3f 80 00       	push   $0x803fdb
  8022c3:	e8 d5 e0 ff ff       	call   80039d <_panic>
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 10                	mov    (%eax),%edx
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	89 10                	mov    %edx,(%eax)
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	74 0b                	je     8022e6 <insert_sorted_allocList+0x222>
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e3:	89 50 04             	mov    %edx,0x4(%eax)
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ec:	89 10                	mov    %edx,(%eax)
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f4:	89 50 04             	mov    %edx,0x4(%eax)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	75 08                	jne    802308 <insert_sorted_allocList+0x244>
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	a3 44 50 80 00       	mov    %eax,0x805044
  802308:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80230d:	40                   	inc    %eax
  80230e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802313:	eb 39                	jmp    80234e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802315:	a1 48 50 80 00       	mov    0x805048,%eax
  80231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802321:	74 07                	je     80232a <insert_sorted_allocList+0x266>
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 00                	mov    (%eax),%eax
  802328:	eb 05                	jmp    80232f <insert_sorted_allocList+0x26b>
  80232a:	b8 00 00 00 00       	mov    $0x0,%eax
  80232f:	a3 48 50 80 00       	mov    %eax,0x805048
  802334:	a1 48 50 80 00       	mov    0x805048,%eax
  802339:	85 c0                	test   %eax,%eax
  80233b:	0f 85 3f ff ff ff    	jne    802280 <insert_sorted_allocList+0x1bc>
  802341:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802345:	0f 85 35 ff ff ff    	jne    802280 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80234b:	eb 01                	jmp    80234e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80234d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80234e:	90                   	nop
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802357:	a1 38 51 80 00       	mov    0x805138,%eax
  80235c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235f:	e9 85 01 00 00       	jmp    8024e9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 40 0c             	mov    0xc(%eax),%eax
  80236a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80236d:	0f 82 6e 01 00 00    	jb     8024e1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 40 0c             	mov    0xc(%eax),%eax
  802379:	3b 45 08             	cmp    0x8(%ebp),%eax
  80237c:	0f 85 8a 00 00 00    	jne    80240c <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802386:	75 17                	jne    80239f <alloc_block_FF+0x4e>
  802388:	83 ec 04             	sub    $0x4,%esp
  80238b:	68 84 40 80 00       	push   $0x804084
  802390:	68 93 00 00 00       	push   $0x93
  802395:	68 db 3f 80 00       	push   $0x803fdb
  80239a:	e8 fe df ff ff       	call   80039d <_panic>
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	74 10                	je     8023b8 <alloc_block_FF+0x67>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b0:	8b 52 04             	mov    0x4(%edx),%edx
  8023b3:	89 50 04             	mov    %edx,0x4(%eax)
  8023b6:	eb 0b                	jmp    8023c3 <alloc_block_FF+0x72>
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 40 04             	mov    0x4(%eax),%eax
  8023be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 40 04             	mov    0x4(%eax),%eax
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	74 0f                	je     8023dc <alloc_block_FF+0x8b>
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 40 04             	mov    0x4(%eax),%eax
  8023d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d6:	8b 12                	mov    (%edx),%edx
  8023d8:	89 10                	mov    %edx,(%eax)
  8023da:	eb 0a                	jmp    8023e6 <alloc_block_FF+0x95>
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	8b 00                	mov    (%eax),%eax
  8023e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f9:	a1 44 51 80 00       	mov    0x805144,%eax
  8023fe:	48                   	dec    %eax
  8023ff:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	e9 10 01 00 00       	jmp    80251c <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 40 0c             	mov    0xc(%eax),%eax
  802412:	3b 45 08             	cmp    0x8(%ebp),%eax
  802415:	0f 86 c6 00 00 00    	jbe    8024e1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80241b:	a1 48 51 80 00       	mov    0x805148,%eax
  802420:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 50 08             	mov    0x8(%eax),%edx
  802429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242c:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	8b 55 08             	mov    0x8(%ebp),%edx
  802435:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802438:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80243c:	75 17                	jne    802455 <alloc_block_FF+0x104>
  80243e:	83 ec 04             	sub    $0x4,%esp
  802441:	68 84 40 80 00       	push   $0x804084
  802446:	68 9b 00 00 00       	push   $0x9b
  80244b:	68 db 3f 80 00       	push   $0x803fdb
  802450:	e8 48 df ff ff       	call   80039d <_panic>
  802455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 10                	je     80246e <alloc_block_FF+0x11d>
  80245e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802461:	8b 00                	mov    (%eax),%eax
  802463:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802466:	8b 52 04             	mov    0x4(%edx),%edx
  802469:	89 50 04             	mov    %edx,0x4(%eax)
  80246c:	eb 0b                	jmp    802479 <alloc_block_FF+0x128>
  80246e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247c:	8b 40 04             	mov    0x4(%eax),%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	74 0f                	je     802492 <alloc_block_FF+0x141>
  802483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80248c:	8b 12                	mov    (%edx),%edx
  80248e:	89 10                	mov    %edx,(%eax)
  802490:	eb 0a                	jmp    80249c <alloc_block_FF+0x14b>
  802492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802495:	8b 00                	mov    (%eax),%eax
  802497:	a3 48 51 80 00       	mov    %eax,0x805148
  80249c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024af:	a1 54 51 80 00       	mov    0x805154,%eax
  8024b4:	48                   	dec    %eax
  8024b5:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 50 08             	mov    0x8(%eax),%edx
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	01 c2                	add    %eax,%edx
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d1:	2b 45 08             	sub    0x8(%ebp),%eax
  8024d4:	89 c2                	mov    %eax,%edx
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	eb 3b                	jmp    80251c <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8024e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ed:	74 07                	je     8024f6 <alloc_block_FF+0x1a5>
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 00                	mov    (%eax),%eax
  8024f4:	eb 05                	jmp    8024fb <alloc_block_FF+0x1aa>
  8024f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fb:	a3 40 51 80 00       	mov    %eax,0x805140
  802500:	a1 40 51 80 00       	mov    0x805140,%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	0f 85 57 fe ff ff    	jne    802364 <alloc_block_FF+0x13>
  80250d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802511:	0f 85 4d fe ff ff    	jne    802364 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    

0080251e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802524:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80252b:	a1 38 51 80 00       	mov    0x805138,%eax
  802530:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802533:	e9 df 00 00 00       	jmp    802617 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 40 0c             	mov    0xc(%eax),%eax
  80253e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802541:	0f 82 c8 00 00 00    	jb     80260f <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 40 0c             	mov    0xc(%eax),%eax
  80254d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802550:	0f 85 8a 00 00 00    	jne    8025e0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802556:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255a:	75 17                	jne    802573 <alloc_block_BF+0x55>
  80255c:	83 ec 04             	sub    $0x4,%esp
  80255f:	68 84 40 80 00       	push   $0x804084
  802564:	68 b7 00 00 00       	push   $0xb7
  802569:	68 db 3f 80 00       	push   $0x803fdb
  80256e:	e8 2a de ff ff       	call   80039d <_panic>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 10                	je     80258c <alloc_block_BF+0x6e>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802584:	8b 52 04             	mov    0x4(%edx),%edx
  802587:	89 50 04             	mov    %edx,0x4(%eax)
  80258a:	eb 0b                	jmp    802597 <alloc_block_BF+0x79>
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 04             	mov    0x4(%eax),%eax
  802592:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 40 04             	mov    0x4(%eax),%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	74 0f                	je     8025b0 <alloc_block_BF+0x92>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 40 04             	mov    0x4(%eax),%eax
  8025a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025aa:	8b 12                	mov    (%edx),%edx
  8025ac:	89 10                	mov    %edx,(%eax)
  8025ae:	eb 0a                	jmp    8025ba <alloc_block_BF+0x9c>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 00                	mov    (%eax),%eax
  8025b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8025d2:	48                   	dec    %eax
  8025d3:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	e9 4d 01 00 00       	jmp    80272d <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e9:	76 24                	jbe    80260f <alloc_block_BF+0xf1>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025f4:	73 19                	jae    80260f <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025f6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802600:	8b 40 0c             	mov    0xc(%eax),%eax
  802603:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 40 08             	mov    0x8(%eax),%eax
  80260c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80260f:	a1 40 51 80 00       	mov    0x805140,%eax
  802614:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802617:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261b:	74 07                	je     802624 <alloc_block_BF+0x106>
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 00                	mov    (%eax),%eax
  802622:	eb 05                	jmp    802629 <alloc_block_BF+0x10b>
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
  802629:	a3 40 51 80 00       	mov    %eax,0x805140
  80262e:	a1 40 51 80 00       	mov    0x805140,%eax
  802633:	85 c0                	test   %eax,%eax
  802635:	0f 85 fd fe ff ff    	jne    802538 <alloc_block_BF+0x1a>
  80263b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263f:	0f 85 f3 fe ff ff    	jne    802538 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802645:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802649:	0f 84 d9 00 00 00    	je     802728 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80264f:	a1 48 51 80 00       	mov    0x805148,%eax
  802654:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80265d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802663:	8b 55 08             	mov    0x8(%ebp),%edx
  802666:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802669:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80266d:	75 17                	jne    802686 <alloc_block_BF+0x168>
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	68 84 40 80 00       	push   $0x804084
  802677:	68 c7 00 00 00       	push   $0xc7
  80267c:	68 db 3f 80 00       	push   $0x803fdb
  802681:	e8 17 dd ff ff       	call   80039d <_panic>
  802686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 10                	je     80269f <alloc_block_BF+0x181>
  80268f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802697:	8b 52 04             	mov    0x4(%edx),%edx
  80269a:	89 50 04             	mov    %edx,0x4(%eax)
  80269d:	eb 0b                	jmp    8026aa <alloc_block_BF+0x18c>
  80269f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0f                	je     8026c3 <alloc_block_BF+0x1a5>
  8026b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026bd:	8b 12                	mov    (%edx),%edx
  8026bf:	89 10                	mov    %edx,(%eax)
  8026c1:	eb 0a                	jmp    8026cd <alloc_block_BF+0x1af>
  8026c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8026cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8026e5:	48                   	dec    %eax
  8026e6:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026eb:	83 ec 08             	sub    $0x8,%esp
  8026ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8026f1:	68 38 51 80 00       	push   $0x805138
  8026f6:	e8 71 f9 ff ff       	call   80206c <find_block>
  8026fb:	83 c4 10             	add    $0x10,%esp
  8026fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802701:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802704:	8b 50 08             	mov    0x8(%eax),%edx
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	01 c2                	add    %eax,%edx
  80270c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270f:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	2b 45 08             	sub    0x8(%ebp),%eax
  80271b:	89 c2                	mov    %eax,%edx
  80271d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802720:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802726:	eb 05                	jmp    80272d <alloc_block_BF+0x20f>
	}
	return NULL;
  802728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80272d:	c9                   	leave  
  80272e:	c3                   	ret    

0080272f <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
  802732:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802735:	a1 28 50 80 00       	mov    0x805028,%eax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	0f 85 de 01 00 00    	jne    802920 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802742:	a1 38 51 80 00       	mov    0x805138,%eax
  802747:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274a:	e9 9e 01 00 00       	jmp    8028ed <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 40 0c             	mov    0xc(%eax),%eax
  802755:	3b 45 08             	cmp    0x8(%ebp),%eax
  802758:	0f 82 87 01 00 00    	jb     8028e5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 40 0c             	mov    0xc(%eax),%eax
  802764:	3b 45 08             	cmp    0x8(%ebp),%eax
  802767:	0f 85 95 00 00 00    	jne    802802 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80276d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802771:	75 17                	jne    80278a <alloc_block_NF+0x5b>
  802773:	83 ec 04             	sub    $0x4,%esp
  802776:	68 84 40 80 00       	push   $0x804084
  80277b:	68 e0 00 00 00       	push   $0xe0
  802780:	68 db 3f 80 00       	push   $0x803fdb
  802785:	e8 13 dc ff ff       	call   80039d <_panic>
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	85 c0                	test   %eax,%eax
  802791:	74 10                	je     8027a3 <alloc_block_NF+0x74>
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279b:	8b 52 04             	mov    0x4(%edx),%edx
  80279e:	89 50 04             	mov    %edx,0x4(%eax)
  8027a1:	eb 0b                	jmp    8027ae <alloc_block_NF+0x7f>
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	74 0f                	je     8027c7 <alloc_block_NF+0x98>
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 40 04             	mov    0x4(%eax),%eax
  8027be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c1:	8b 12                	mov    (%edx),%edx
  8027c3:	89 10                	mov    %edx,(%eax)
  8027c5:	eb 0a                	jmp    8027d1 <alloc_block_NF+0xa2>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	a3 38 51 80 00       	mov    %eax,0x805138
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8027e9:	48                   	dec    %eax
  8027ea:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 40 08             	mov    0x8(%eax),%eax
  8027f5:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	e9 f8 04 00 00       	jmp    802cfa <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 0c             	mov    0xc(%eax),%eax
  802808:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280b:	0f 86 d4 00 00 00    	jbe    8028e5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802811:	a1 48 51 80 00       	mov    0x805148,%eax
  802816:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 50 08             	mov    0x8(%eax),%edx
  80281f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802822:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802828:	8b 55 08             	mov    0x8(%ebp),%edx
  80282b:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80282e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802832:	75 17                	jne    80284b <alloc_block_NF+0x11c>
  802834:	83 ec 04             	sub    $0x4,%esp
  802837:	68 84 40 80 00       	push   $0x804084
  80283c:	68 e9 00 00 00       	push   $0xe9
  802841:	68 db 3f 80 00       	push   $0x803fdb
  802846:	e8 52 db ff ff       	call   80039d <_panic>
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	8b 00                	mov    (%eax),%eax
  802850:	85 c0                	test   %eax,%eax
  802852:	74 10                	je     802864 <alloc_block_NF+0x135>
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285c:	8b 52 04             	mov    0x4(%edx),%edx
  80285f:	89 50 04             	mov    %edx,0x4(%eax)
  802862:	eb 0b                	jmp    80286f <alloc_block_NF+0x140>
  802864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802867:	8b 40 04             	mov    0x4(%eax),%eax
  80286a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	8b 40 04             	mov    0x4(%eax),%eax
  802875:	85 c0                	test   %eax,%eax
  802877:	74 0f                	je     802888 <alloc_block_NF+0x159>
  802879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287c:	8b 40 04             	mov    0x4(%eax),%eax
  80287f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802882:	8b 12                	mov    (%edx),%edx
  802884:	89 10                	mov    %edx,(%eax)
  802886:	eb 0a                	jmp    802892 <alloc_block_NF+0x163>
  802888:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	a3 48 51 80 00       	mov    %eax,0x805148
  802892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802895:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8028aa:	48                   	dec    %eax
  8028ab:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	8b 40 08             	mov    0x8(%eax),%eax
  8028b6:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 50 08             	mov    0x8(%eax),%edx
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	01 c2                	add    %eax,%edx
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d5:	89 c2                	mov    %eax,%edx
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	e9 15 04 00 00       	jmp    802cfa <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f1:	74 07                	je     8028fa <alloc_block_NF+0x1cb>
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	eb 05                	jmp    8028ff <alloc_block_NF+0x1d0>
  8028fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ff:	a3 40 51 80 00       	mov    %eax,0x805140
  802904:	a1 40 51 80 00       	mov    0x805140,%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	0f 85 3e fe ff ff    	jne    80274f <alloc_block_NF+0x20>
  802911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802915:	0f 85 34 fe ff ff    	jne    80274f <alloc_block_NF+0x20>
  80291b:	e9 d5 03 00 00       	jmp    802cf5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802920:	a1 38 51 80 00       	mov    0x805138,%eax
  802925:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802928:	e9 b1 01 00 00       	jmp    802ade <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 50 08             	mov    0x8(%eax),%edx
  802933:	a1 28 50 80 00       	mov    0x805028,%eax
  802938:	39 c2                	cmp    %eax,%edx
  80293a:	0f 82 96 01 00 00    	jb     802ad6 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 0c             	mov    0xc(%eax),%eax
  802946:	3b 45 08             	cmp    0x8(%ebp),%eax
  802949:	0f 82 87 01 00 00    	jb     802ad6 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 40 0c             	mov    0xc(%eax),%eax
  802955:	3b 45 08             	cmp    0x8(%ebp),%eax
  802958:	0f 85 95 00 00 00    	jne    8029f3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80295e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802962:	75 17                	jne    80297b <alloc_block_NF+0x24c>
  802964:	83 ec 04             	sub    $0x4,%esp
  802967:	68 84 40 80 00       	push   $0x804084
  80296c:	68 fc 00 00 00       	push   $0xfc
  802971:	68 db 3f 80 00       	push   $0x803fdb
  802976:	e8 22 da ff ff       	call   80039d <_panic>
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 10                	je     802994 <alloc_block_NF+0x265>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298c:	8b 52 04             	mov    0x4(%edx),%edx
  80298f:	89 50 04             	mov    %edx,0x4(%eax)
  802992:	eb 0b                	jmp    80299f <alloc_block_NF+0x270>
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 40 04             	mov    0x4(%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 0f                	je     8029b8 <alloc_block_NF+0x289>
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 40 04             	mov    0x4(%eax),%eax
  8029af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b2:	8b 12                	mov    (%edx),%edx
  8029b4:	89 10                	mov    %edx,(%eax)
  8029b6:	eb 0a                	jmp    8029c2 <alloc_block_NF+0x293>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8029da:	48                   	dec    %eax
  8029db:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 40 08             	mov    0x8(%eax),%eax
  8029e6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	e9 07 03 00 00       	jmp    802cfa <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029fc:	0f 86 d4 00 00 00    	jbe    802ad6 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a02:	a1 48 51 80 00       	mov    0x805148,%eax
  802a07:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 50 08             	mov    0x8(%eax),%edx
  802a10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a13:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a19:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a23:	75 17                	jne    802a3c <alloc_block_NF+0x30d>
  802a25:	83 ec 04             	sub    $0x4,%esp
  802a28:	68 84 40 80 00       	push   $0x804084
  802a2d:	68 04 01 00 00       	push   $0x104
  802a32:	68 db 3f 80 00       	push   $0x803fdb
  802a37:	e8 61 d9 ff ff       	call   80039d <_panic>
  802a3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	74 10                	je     802a55 <alloc_block_NF+0x326>
  802a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a4d:	8b 52 04             	mov    0x4(%edx),%edx
  802a50:	89 50 04             	mov    %edx,0x4(%eax)
  802a53:	eb 0b                	jmp    802a60 <alloc_block_NF+0x331>
  802a55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a63:	8b 40 04             	mov    0x4(%eax),%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	74 0f                	je     802a79 <alloc_block_NF+0x34a>
  802a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6d:	8b 40 04             	mov    0x4(%eax),%eax
  802a70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a73:	8b 12                	mov    (%edx),%edx
  802a75:	89 10                	mov    %edx,(%eax)
  802a77:	eb 0a                	jmp    802a83 <alloc_block_NF+0x354>
  802a79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7c:	8b 00                	mov    (%eax),%eax
  802a7e:	a3 48 51 80 00       	mov    %eax,0x805148
  802a83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a96:	a1 54 51 80 00       	mov    0x805154,%eax
  802a9b:	48                   	dec    %eax
  802a9c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802aa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa4:	8b 40 08             	mov    0x8(%eax),%eax
  802aa7:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 50 08             	mov    0x8(%eax),%edx
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	01 c2                	add    %eax,%edx
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac3:	2b 45 08             	sub    0x8(%ebp),%eax
  802ac6:	89 c2                	mov    %eax,%edx
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad1:	e9 24 02 00 00       	jmp    802cfa <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ad6:	a1 40 51 80 00       	mov    0x805140,%eax
  802adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ade:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae2:	74 07                	je     802aeb <alloc_block_NF+0x3bc>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	eb 05                	jmp    802af0 <alloc_block_NF+0x3c1>
  802aeb:	b8 00 00 00 00       	mov    $0x0,%eax
  802af0:	a3 40 51 80 00       	mov    %eax,0x805140
  802af5:	a1 40 51 80 00       	mov    0x805140,%eax
  802afa:	85 c0                	test   %eax,%eax
  802afc:	0f 85 2b fe ff ff    	jne    80292d <alloc_block_NF+0x1fe>
  802b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b06:	0f 85 21 fe ff ff    	jne    80292d <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b0c:	a1 38 51 80 00       	mov    0x805138,%eax
  802b11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b14:	e9 ae 01 00 00       	jmp    802cc7 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 50 08             	mov    0x8(%eax),%edx
  802b1f:	a1 28 50 80 00       	mov    0x805028,%eax
  802b24:	39 c2                	cmp    %eax,%edx
  802b26:	0f 83 93 01 00 00    	jae    802cbf <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 40 0c             	mov    0xc(%eax),%eax
  802b32:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b35:	0f 82 84 01 00 00    	jb     802cbf <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b44:	0f 85 95 00 00 00    	jne    802bdf <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4e:	75 17                	jne    802b67 <alloc_block_NF+0x438>
  802b50:	83 ec 04             	sub    $0x4,%esp
  802b53:	68 84 40 80 00       	push   $0x804084
  802b58:	68 14 01 00 00       	push   $0x114
  802b5d:	68 db 3f 80 00       	push   $0x803fdb
  802b62:	e8 36 d8 ff ff       	call   80039d <_panic>
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 10                	je     802b80 <alloc_block_NF+0x451>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b78:	8b 52 04             	mov    0x4(%edx),%edx
  802b7b:	89 50 04             	mov    %edx,0x4(%eax)
  802b7e:	eb 0b                	jmp    802b8b <alloc_block_NF+0x45c>
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	8b 40 04             	mov    0x4(%eax),%eax
  802b86:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 40 04             	mov    0x4(%eax),%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	74 0f                	je     802ba4 <alloc_block_NF+0x475>
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 40 04             	mov    0x4(%eax),%eax
  802b9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9e:	8b 12                	mov    (%edx),%edx
  802ba0:	89 10                	mov    %edx,(%eax)
  802ba2:	eb 0a                	jmp    802bae <alloc_block_NF+0x47f>
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 00                	mov    (%eax),%eax
  802ba9:	a3 38 51 80 00       	mov    %eax,0x805138
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc1:	a1 44 51 80 00       	mov    0x805144,%eax
  802bc6:	48                   	dec    %eax
  802bc7:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 08             	mov    0x8(%eax),%eax
  802bd2:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	e9 1b 01 00 00       	jmp    802cfa <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 40 0c             	mov    0xc(%eax),%eax
  802be5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be8:	0f 86 d1 00 00 00    	jbe    802cbf <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bee:	a1 48 51 80 00       	mov    0x805148,%eax
  802bf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 50 08             	mov    0x8(%eax),%edx
  802bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bff:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c05:	8b 55 08             	mov    0x8(%ebp),%edx
  802c08:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c0f:	75 17                	jne    802c28 <alloc_block_NF+0x4f9>
  802c11:	83 ec 04             	sub    $0x4,%esp
  802c14:	68 84 40 80 00       	push   $0x804084
  802c19:	68 1c 01 00 00       	push   $0x11c
  802c1e:	68 db 3f 80 00       	push   $0x803fdb
  802c23:	e8 75 d7 ff ff       	call   80039d <_panic>
  802c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2b:	8b 00                	mov    (%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 10                	je     802c41 <alloc_block_NF+0x512>
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c39:	8b 52 04             	mov    0x4(%edx),%edx
  802c3c:	89 50 04             	mov    %edx,0x4(%eax)
  802c3f:	eb 0b                	jmp    802c4c <alloc_block_NF+0x51d>
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4f:	8b 40 04             	mov    0x4(%eax),%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	74 0f                	je     802c65 <alloc_block_NF+0x536>
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	8b 40 04             	mov    0x4(%eax),%eax
  802c5c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c5f:	8b 12                	mov    (%edx),%edx
  802c61:	89 10                	mov    %edx,(%eax)
  802c63:	eb 0a                	jmp    802c6f <alloc_block_NF+0x540>
  802c65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	a3 48 51 80 00       	mov    %eax,0x805148
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c82:	a1 54 51 80 00       	mov    0x805154,%eax
  802c87:	48                   	dec    %eax
  802c88:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	8b 40 08             	mov    0x8(%eax),%eax
  802c93:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	8b 50 08             	mov    0x8(%eax),%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	01 c2                	add    %eax,%edx
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 0c             	mov    0xc(%eax),%eax
  802caf:	2b 45 08             	sub    0x8(%ebp),%eax
  802cb2:	89 c2                	mov    %eax,%edx
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbd:	eb 3b                	jmp    802cfa <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cbf:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccb:	74 07                	je     802cd4 <alloc_block_NF+0x5a5>
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 00                	mov    (%eax),%eax
  802cd2:	eb 05                	jmp    802cd9 <alloc_block_NF+0x5aa>
  802cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd9:	a3 40 51 80 00       	mov    %eax,0x805140
  802cde:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	0f 85 2e fe ff ff    	jne    802b19 <alloc_block_NF+0x3ea>
  802ceb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cef:	0f 85 24 fe ff ff    	jne    802b19 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cfa:	c9                   	leave  
  802cfb:	c3                   	ret    

00802cfc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cfc:	55                   	push   %ebp
  802cfd:	89 e5                	mov    %esp,%ebp
  802cff:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d02:	a1 38 51 80 00       	mov    0x805138,%eax
  802d07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d0a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d0f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d12:	a1 38 51 80 00       	mov    0x805138,%eax
  802d17:	85 c0                	test   %eax,%eax
  802d19:	74 14                	je     802d2f <insert_sorted_with_merge_freeList+0x33>
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	8b 50 08             	mov    0x8(%eax),%edx
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	8b 40 08             	mov    0x8(%eax),%eax
  802d27:	39 c2                	cmp    %eax,%edx
  802d29:	0f 87 9b 01 00 00    	ja     802eca <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d33:	75 17                	jne    802d4c <insert_sorted_with_merge_freeList+0x50>
  802d35:	83 ec 04             	sub    $0x4,%esp
  802d38:	68 b8 3f 80 00       	push   $0x803fb8
  802d3d:	68 38 01 00 00       	push   $0x138
  802d42:	68 db 3f 80 00       	push   $0x803fdb
  802d47:	e8 51 d6 ff ff       	call   80039d <_panic>
  802d4c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	89 10                	mov    %edx,(%eax)
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 00                	mov    (%eax),%eax
  802d5c:	85 c0                	test   %eax,%eax
  802d5e:	74 0d                	je     802d6d <insert_sorted_with_merge_freeList+0x71>
  802d60:	a1 38 51 80 00       	mov    0x805138,%eax
  802d65:	8b 55 08             	mov    0x8(%ebp),%edx
  802d68:	89 50 04             	mov    %edx,0x4(%eax)
  802d6b:	eb 08                	jmp    802d75 <insert_sorted_with_merge_freeList+0x79>
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	a3 38 51 80 00       	mov    %eax,0x805138
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d87:	a1 44 51 80 00       	mov    0x805144,%eax
  802d8c:	40                   	inc    %eax
  802d8d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d96:	0f 84 a8 06 00 00    	je     803444 <insert_sorted_with_merge_freeList+0x748>
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	8b 50 08             	mov    0x8(%eax),%edx
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 40 0c             	mov    0xc(%eax),%eax
  802da8:	01 c2                	add    %eax,%edx
  802daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dad:	8b 40 08             	mov    0x8(%eax),%eax
  802db0:	39 c2                	cmp    %eax,%edx
  802db2:	0f 85 8c 06 00 00    	jne    803444 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc4:	01 c2                	add    %eax,%edx
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd0:	75 17                	jne    802de9 <insert_sorted_with_merge_freeList+0xed>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 84 40 80 00       	push   $0x804084
  802dda:	68 3c 01 00 00       	push   $0x13c
  802ddf:	68 db 3f 80 00       	push   $0x803fdb
  802de4:	e8 b4 d5 ff ff       	call   80039d <_panic>
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 10                	je     802e02 <insert_sorted_with_merge_freeList+0x106>
  802df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df5:	8b 00                	mov    (%eax),%eax
  802df7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dfa:	8b 52 04             	mov    0x4(%edx),%edx
  802dfd:	89 50 04             	mov    %edx,0x4(%eax)
  802e00:	eb 0b                	jmp    802e0d <insert_sorted_with_merge_freeList+0x111>
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	8b 40 04             	mov    0x4(%eax),%eax
  802e13:	85 c0                	test   %eax,%eax
  802e15:	74 0f                	je     802e26 <insert_sorted_with_merge_freeList+0x12a>
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e20:	8b 12                	mov    (%edx),%edx
  802e22:	89 10                	mov    %edx,(%eax)
  802e24:	eb 0a                	jmp    802e30 <insert_sorted_with_merge_freeList+0x134>
  802e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e43:	a1 44 51 80 00       	mov    0x805144,%eax
  802e48:	48                   	dec    %eax
  802e49:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e66:	75 17                	jne    802e7f <insert_sorted_with_merge_freeList+0x183>
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	68 b8 3f 80 00       	push   $0x803fb8
  802e70:	68 3f 01 00 00       	push   $0x13f
  802e75:	68 db 3f 80 00       	push   $0x803fdb
  802e7a:	e8 1e d5 ff ff       	call   80039d <_panic>
  802e7f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	89 10                	mov    %edx,(%eax)
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	74 0d                	je     802ea0 <insert_sorted_with_merge_freeList+0x1a4>
  802e93:	a1 48 51 80 00       	mov    0x805148,%eax
  802e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9b:	89 50 04             	mov    %edx,0x4(%eax)
  802e9e:	eb 08                	jmp    802ea8 <insert_sorted_with_merge_freeList+0x1ac>
  802ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eba:	a1 54 51 80 00       	mov    0x805154,%eax
  802ebf:	40                   	inc    %eax
  802ec0:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ec5:	e9 7a 05 00 00       	jmp    803444 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	8b 50 08             	mov    0x8(%eax),%edx
  802ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed3:	8b 40 08             	mov    0x8(%eax),%eax
  802ed6:	39 c2                	cmp    %eax,%edx
  802ed8:	0f 82 14 01 00 00    	jb     802ff2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ede:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee1:	8b 50 08             	mov    0x8(%eax),%edx
  802ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eea:	01 c2                	add    %eax,%edx
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 40 08             	mov    0x8(%eax),%eax
  802ef2:	39 c2                	cmp    %eax,%edx
  802ef4:	0f 85 90 00 00 00    	jne    802f8a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802efa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efd:	8b 50 0c             	mov    0xc(%eax),%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 40 0c             	mov    0xc(%eax),%eax
  802f06:	01 c2                	add    %eax,%edx
  802f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0b:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f26:	75 17                	jne    802f3f <insert_sorted_with_merge_freeList+0x243>
  802f28:	83 ec 04             	sub    $0x4,%esp
  802f2b:	68 b8 3f 80 00       	push   $0x803fb8
  802f30:	68 49 01 00 00       	push   $0x149
  802f35:	68 db 3f 80 00       	push   $0x803fdb
  802f3a:	e8 5e d4 ff ff       	call   80039d <_panic>
  802f3f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	89 10                	mov    %edx,(%eax)
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	85 c0                	test   %eax,%eax
  802f51:	74 0d                	je     802f60 <insert_sorted_with_merge_freeList+0x264>
  802f53:	a1 48 51 80 00       	mov    0x805148,%eax
  802f58:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5b:	89 50 04             	mov    %edx,0x4(%eax)
  802f5e:	eb 08                	jmp    802f68 <insert_sorted_with_merge_freeList+0x26c>
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	a3 48 51 80 00       	mov    %eax,0x805148
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f7f:	40                   	inc    %eax
  802f80:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f85:	e9 bb 04 00 00       	jmp    803445 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8e:	75 17                	jne    802fa7 <insert_sorted_with_merge_freeList+0x2ab>
  802f90:	83 ec 04             	sub    $0x4,%esp
  802f93:	68 2c 40 80 00       	push   $0x80402c
  802f98:	68 4c 01 00 00       	push   $0x14c
  802f9d:	68 db 3f 80 00       	push   $0x803fdb
  802fa2:	e8 f6 d3 ff ff       	call   80039d <_panic>
  802fa7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 40 04             	mov    0x4(%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0c                	je     802fc9 <insert_sorted_with_merge_freeList+0x2cd>
  802fbd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc5:	89 10                	mov    %edx,(%eax)
  802fc7:	eb 08                	jmp    802fd1 <insert_sorted_with_merge_freeList+0x2d5>
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe2:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe7:	40                   	inc    %eax
  802fe8:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fed:	e9 53 04 00 00       	jmp    803445 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ff2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffa:	e9 15 04 00 00       	jmp    803414 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	8b 50 08             	mov    0x8(%eax),%edx
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	8b 40 08             	mov    0x8(%eax),%eax
  803013:	39 c2                	cmp    %eax,%edx
  803015:	0f 86 f1 03 00 00    	jbe    80340c <insert_sorted_with_merge_freeList+0x710>
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	8b 50 08             	mov    0x8(%eax),%edx
  803021:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803024:	8b 40 08             	mov    0x8(%eax),%eax
  803027:	39 c2                	cmp    %eax,%edx
  803029:	0f 83 dd 03 00 00    	jae    80340c <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803032:	8b 50 08             	mov    0x8(%eax),%edx
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 40 0c             	mov    0xc(%eax),%eax
  80303b:	01 c2                	add    %eax,%edx
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	8b 40 08             	mov    0x8(%eax),%eax
  803043:	39 c2                	cmp    %eax,%edx
  803045:	0f 85 b9 01 00 00    	jne    803204 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 50 08             	mov    0x8(%eax),%edx
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	8b 40 0c             	mov    0xc(%eax),%eax
  803057:	01 c2                	add    %eax,%edx
  803059:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305c:	8b 40 08             	mov    0x8(%eax),%eax
  80305f:	39 c2                	cmp    %eax,%edx
  803061:	0f 85 0d 01 00 00    	jne    803174 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 50 0c             	mov    0xc(%eax),%edx
  80306d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803070:	8b 40 0c             	mov    0xc(%eax),%eax
  803073:	01 c2                	add    %eax,%edx
  803075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803078:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80307b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80307f:	75 17                	jne    803098 <insert_sorted_with_merge_freeList+0x39c>
  803081:	83 ec 04             	sub    $0x4,%esp
  803084:	68 84 40 80 00       	push   $0x804084
  803089:	68 5c 01 00 00       	push   $0x15c
  80308e:	68 db 3f 80 00       	push   $0x803fdb
  803093:	e8 05 d3 ff ff       	call   80039d <_panic>
  803098:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	74 10                	je     8030b1 <insert_sorted_with_merge_freeList+0x3b5>
  8030a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030a9:	8b 52 04             	mov    0x4(%edx),%edx
  8030ac:	89 50 04             	mov    %edx,0x4(%eax)
  8030af:	eb 0b                	jmp    8030bc <insert_sorted_with_merge_freeList+0x3c0>
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	8b 40 04             	mov    0x4(%eax),%eax
  8030b7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bf:	8b 40 04             	mov    0x4(%eax),%eax
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	74 0f                	je     8030d5 <insert_sorted_with_merge_freeList+0x3d9>
  8030c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c9:	8b 40 04             	mov    0x4(%eax),%eax
  8030cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030cf:	8b 12                	mov    (%edx),%edx
  8030d1:	89 10                	mov    %edx,(%eax)
  8030d3:	eb 0a                	jmp    8030df <insert_sorted_with_merge_freeList+0x3e3>
  8030d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d8:	8b 00                	mov    (%eax),%eax
  8030da:	a3 38 51 80 00       	mov    %eax,0x805138
  8030df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f7:	48                   	dec    %eax
  8030f8:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803100:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803107:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803111:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803115:	75 17                	jne    80312e <insert_sorted_with_merge_freeList+0x432>
  803117:	83 ec 04             	sub    $0x4,%esp
  80311a:	68 b8 3f 80 00       	push   $0x803fb8
  80311f:	68 5f 01 00 00       	push   $0x15f
  803124:	68 db 3f 80 00       	push   $0x803fdb
  803129:	e8 6f d2 ff ff       	call   80039d <_panic>
  80312e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	89 10                	mov    %edx,(%eax)
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 0d                	je     80314f <insert_sorted_with_merge_freeList+0x453>
  803142:	a1 48 51 80 00       	mov    0x805148,%eax
  803147:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80314a:	89 50 04             	mov    %edx,0x4(%eax)
  80314d:	eb 08                	jmp    803157 <insert_sorted_with_merge_freeList+0x45b>
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315a:	a3 48 51 80 00       	mov    %eax,0x805148
  80315f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803162:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803169:	a1 54 51 80 00       	mov    0x805154,%eax
  80316e:	40                   	inc    %eax
  80316f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803177:	8b 50 0c             	mov    0xc(%eax),%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 40 0c             	mov    0xc(%eax),%eax
  803180:	01 c2                	add    %eax,%edx
  803182:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803185:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80319c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a0:	75 17                	jne    8031b9 <insert_sorted_with_merge_freeList+0x4bd>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 b8 3f 80 00       	push   $0x803fb8
  8031aa:	68 64 01 00 00       	push   $0x164
  8031af:	68 db 3f 80 00       	push   $0x803fdb
  8031b4:	e8 e4 d1 ff ff       	call   80039d <_panic>
  8031b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	74 0d                	je     8031da <insert_sorted_with_merge_freeList+0x4de>
  8031cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	eb 08                	jmp    8031e2 <insert_sorted_with_merge_freeList+0x4e6>
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f9:	40                   	inc    %eax
  8031fa:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031ff:	e9 41 02 00 00       	jmp    803445 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	8b 50 08             	mov    0x8(%eax),%edx
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	8b 40 0c             	mov    0xc(%eax),%eax
  803210:	01 c2                	add    %eax,%edx
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	8b 40 08             	mov    0x8(%eax),%eax
  803218:	39 c2                	cmp    %eax,%edx
  80321a:	0f 85 7c 01 00 00    	jne    80339c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803220:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803224:	74 06                	je     80322c <insert_sorted_with_merge_freeList+0x530>
  803226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322a:	75 17                	jne    803243 <insert_sorted_with_merge_freeList+0x547>
  80322c:	83 ec 04             	sub    $0x4,%esp
  80322f:	68 f4 3f 80 00       	push   $0x803ff4
  803234:	68 69 01 00 00       	push   $0x169
  803239:	68 db 3f 80 00       	push   $0x803fdb
  80323e:	e8 5a d1 ff ff       	call   80039d <_panic>
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	8b 50 04             	mov    0x4(%eax),%edx
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	89 50 04             	mov    %edx,0x4(%eax)
  80324f:	8b 45 08             	mov    0x8(%ebp),%eax
  803252:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803255:	89 10                	mov    %edx,(%eax)
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 40 04             	mov    0x4(%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 0d                	je     80326e <insert_sorted_with_merge_freeList+0x572>
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	8b 40 04             	mov    0x4(%eax),%eax
  803267:	8b 55 08             	mov    0x8(%ebp),%edx
  80326a:	89 10                	mov    %edx,(%eax)
  80326c:	eb 08                	jmp    803276 <insert_sorted_with_merge_freeList+0x57a>
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	a3 38 51 80 00       	mov    %eax,0x805138
  803276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803279:	8b 55 08             	mov    0x8(%ebp),%edx
  80327c:	89 50 04             	mov    %edx,0x4(%eax)
  80327f:	a1 44 51 80 00       	mov    0x805144,%eax
  803284:	40                   	inc    %eax
  803285:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	8b 50 0c             	mov    0xc(%eax),%edx
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	8b 40 0c             	mov    0xc(%eax),%eax
  803296:	01 c2                	add    %eax,%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80329e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032a2:	75 17                	jne    8032bb <insert_sorted_with_merge_freeList+0x5bf>
  8032a4:	83 ec 04             	sub    $0x4,%esp
  8032a7:	68 84 40 80 00       	push   $0x804084
  8032ac:	68 6b 01 00 00       	push   $0x16b
  8032b1:	68 db 3f 80 00       	push   $0x803fdb
  8032b6:	e8 e2 d0 ff ff       	call   80039d <_panic>
  8032bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032be:	8b 00                	mov    (%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	74 10                	je     8032d4 <insert_sorted_with_merge_freeList+0x5d8>
  8032c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c7:	8b 00                	mov    (%eax),%eax
  8032c9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cc:	8b 52 04             	mov    0x4(%edx),%edx
  8032cf:	89 50 04             	mov    %edx,0x4(%eax)
  8032d2:	eb 0b                	jmp    8032df <insert_sorted_with_merge_freeList+0x5e3>
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 40 04             	mov    0x4(%eax),%eax
  8032da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e2:	8b 40 04             	mov    0x4(%eax),%eax
  8032e5:	85 c0                	test   %eax,%eax
  8032e7:	74 0f                	je     8032f8 <insert_sorted_with_merge_freeList+0x5fc>
  8032e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ec:	8b 40 04             	mov    0x4(%eax),%eax
  8032ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032f2:	8b 12                	mov    (%edx),%edx
  8032f4:	89 10                	mov    %edx,(%eax)
  8032f6:	eb 0a                	jmp    803302 <insert_sorted_with_merge_freeList+0x606>
  8032f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803302:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80330b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803315:	a1 44 51 80 00       	mov    0x805144,%eax
  80331a:	48                   	dec    %eax
  80331b:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803320:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803323:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80332a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803334:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803338:	75 17                	jne    803351 <insert_sorted_with_merge_freeList+0x655>
  80333a:	83 ec 04             	sub    $0x4,%esp
  80333d:	68 b8 3f 80 00       	push   $0x803fb8
  803342:	68 6e 01 00 00       	push   $0x16e
  803347:	68 db 3f 80 00       	push   $0x803fdb
  80334c:	e8 4c d0 ff ff       	call   80039d <_panic>
  803351:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803357:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335a:	89 10                	mov    %edx,(%eax)
  80335c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335f:	8b 00                	mov    (%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 0d                	je     803372 <insert_sorted_with_merge_freeList+0x676>
  803365:	a1 48 51 80 00       	mov    0x805148,%eax
  80336a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80336d:	89 50 04             	mov    %edx,0x4(%eax)
  803370:	eb 08                	jmp    80337a <insert_sorted_with_merge_freeList+0x67e>
  803372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803375:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337d:	a3 48 51 80 00       	mov    %eax,0x805148
  803382:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803385:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80338c:	a1 54 51 80 00       	mov    0x805154,%eax
  803391:	40                   	inc    %eax
  803392:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803397:	e9 a9 00 00 00       	jmp    803445 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80339c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a0:	74 06                	je     8033a8 <insert_sorted_with_merge_freeList+0x6ac>
  8033a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a6:	75 17                	jne    8033bf <insert_sorted_with_merge_freeList+0x6c3>
  8033a8:	83 ec 04             	sub    $0x4,%esp
  8033ab:	68 50 40 80 00       	push   $0x804050
  8033b0:	68 73 01 00 00       	push   $0x173
  8033b5:	68 db 3f 80 00       	push   $0x803fdb
  8033ba:	e8 de cf ff ff       	call   80039d <_panic>
  8033bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c2:	8b 10                	mov    (%eax),%edx
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	89 10                	mov    %edx,(%eax)
  8033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	85 c0                	test   %eax,%eax
  8033d0:	74 0b                	je     8033dd <insert_sorted_with_merge_freeList+0x6e1>
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	8b 00                	mov    (%eax),%eax
  8033d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033da:	89 50 04             	mov    %edx,0x4(%eax)
  8033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e3:	89 10                	mov    %edx,(%eax)
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033eb:	89 50 04             	mov    %edx,0x4(%eax)
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	8b 00                	mov    (%eax),%eax
  8033f3:	85 c0                	test   %eax,%eax
  8033f5:	75 08                	jne    8033ff <insert_sorted_with_merge_freeList+0x703>
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ff:	a1 44 51 80 00       	mov    0x805144,%eax
  803404:	40                   	inc    %eax
  803405:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80340a:	eb 39                	jmp    803445 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80340c:	a1 40 51 80 00       	mov    0x805140,%eax
  803411:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803418:	74 07                	je     803421 <insert_sorted_with_merge_freeList+0x725>
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	8b 00                	mov    (%eax),%eax
  80341f:	eb 05                	jmp    803426 <insert_sorted_with_merge_freeList+0x72a>
  803421:	b8 00 00 00 00       	mov    $0x0,%eax
  803426:	a3 40 51 80 00       	mov    %eax,0x805140
  80342b:	a1 40 51 80 00       	mov    0x805140,%eax
  803430:	85 c0                	test   %eax,%eax
  803432:	0f 85 c7 fb ff ff    	jne    802fff <insert_sorted_with_merge_freeList+0x303>
  803438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343c:	0f 85 bd fb ff ff    	jne    802fff <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803442:	eb 01                	jmp    803445 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803444:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803445:	90                   	nop
  803446:	c9                   	leave  
  803447:	c3                   	ret    

00803448 <__udivdi3>:
  803448:	55                   	push   %ebp
  803449:	57                   	push   %edi
  80344a:	56                   	push   %esi
  80344b:	53                   	push   %ebx
  80344c:	83 ec 1c             	sub    $0x1c,%esp
  80344f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803453:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803457:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80345b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80345f:	89 ca                	mov    %ecx,%edx
  803461:	89 f8                	mov    %edi,%eax
  803463:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803467:	85 f6                	test   %esi,%esi
  803469:	75 2d                	jne    803498 <__udivdi3+0x50>
  80346b:	39 cf                	cmp    %ecx,%edi
  80346d:	77 65                	ja     8034d4 <__udivdi3+0x8c>
  80346f:	89 fd                	mov    %edi,%ebp
  803471:	85 ff                	test   %edi,%edi
  803473:	75 0b                	jne    803480 <__udivdi3+0x38>
  803475:	b8 01 00 00 00       	mov    $0x1,%eax
  80347a:	31 d2                	xor    %edx,%edx
  80347c:	f7 f7                	div    %edi
  80347e:	89 c5                	mov    %eax,%ebp
  803480:	31 d2                	xor    %edx,%edx
  803482:	89 c8                	mov    %ecx,%eax
  803484:	f7 f5                	div    %ebp
  803486:	89 c1                	mov    %eax,%ecx
  803488:	89 d8                	mov    %ebx,%eax
  80348a:	f7 f5                	div    %ebp
  80348c:	89 cf                	mov    %ecx,%edi
  80348e:	89 fa                	mov    %edi,%edx
  803490:	83 c4 1c             	add    $0x1c,%esp
  803493:	5b                   	pop    %ebx
  803494:	5e                   	pop    %esi
  803495:	5f                   	pop    %edi
  803496:	5d                   	pop    %ebp
  803497:	c3                   	ret    
  803498:	39 ce                	cmp    %ecx,%esi
  80349a:	77 28                	ja     8034c4 <__udivdi3+0x7c>
  80349c:	0f bd fe             	bsr    %esi,%edi
  80349f:	83 f7 1f             	xor    $0x1f,%edi
  8034a2:	75 40                	jne    8034e4 <__udivdi3+0x9c>
  8034a4:	39 ce                	cmp    %ecx,%esi
  8034a6:	72 0a                	jb     8034b2 <__udivdi3+0x6a>
  8034a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034ac:	0f 87 9e 00 00 00    	ja     803550 <__udivdi3+0x108>
  8034b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034b7:	89 fa                	mov    %edi,%edx
  8034b9:	83 c4 1c             	add    $0x1c,%esp
  8034bc:	5b                   	pop    %ebx
  8034bd:	5e                   	pop    %esi
  8034be:	5f                   	pop    %edi
  8034bf:	5d                   	pop    %ebp
  8034c0:	c3                   	ret    
  8034c1:	8d 76 00             	lea    0x0(%esi),%esi
  8034c4:	31 ff                	xor    %edi,%edi
  8034c6:	31 c0                	xor    %eax,%eax
  8034c8:	89 fa                	mov    %edi,%edx
  8034ca:	83 c4 1c             	add    $0x1c,%esp
  8034cd:	5b                   	pop    %ebx
  8034ce:	5e                   	pop    %esi
  8034cf:	5f                   	pop    %edi
  8034d0:	5d                   	pop    %ebp
  8034d1:	c3                   	ret    
  8034d2:	66 90                	xchg   %ax,%ax
  8034d4:	89 d8                	mov    %ebx,%eax
  8034d6:	f7 f7                	div    %edi
  8034d8:	31 ff                	xor    %edi,%edi
  8034da:	89 fa                	mov    %edi,%edx
  8034dc:	83 c4 1c             	add    $0x1c,%esp
  8034df:	5b                   	pop    %ebx
  8034e0:	5e                   	pop    %esi
  8034e1:	5f                   	pop    %edi
  8034e2:	5d                   	pop    %ebp
  8034e3:	c3                   	ret    
  8034e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034e9:	89 eb                	mov    %ebp,%ebx
  8034eb:	29 fb                	sub    %edi,%ebx
  8034ed:	89 f9                	mov    %edi,%ecx
  8034ef:	d3 e6                	shl    %cl,%esi
  8034f1:	89 c5                	mov    %eax,%ebp
  8034f3:	88 d9                	mov    %bl,%cl
  8034f5:	d3 ed                	shr    %cl,%ebp
  8034f7:	89 e9                	mov    %ebp,%ecx
  8034f9:	09 f1                	or     %esi,%ecx
  8034fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034ff:	89 f9                	mov    %edi,%ecx
  803501:	d3 e0                	shl    %cl,%eax
  803503:	89 c5                	mov    %eax,%ebp
  803505:	89 d6                	mov    %edx,%esi
  803507:	88 d9                	mov    %bl,%cl
  803509:	d3 ee                	shr    %cl,%esi
  80350b:	89 f9                	mov    %edi,%ecx
  80350d:	d3 e2                	shl    %cl,%edx
  80350f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803513:	88 d9                	mov    %bl,%cl
  803515:	d3 e8                	shr    %cl,%eax
  803517:	09 c2                	or     %eax,%edx
  803519:	89 d0                	mov    %edx,%eax
  80351b:	89 f2                	mov    %esi,%edx
  80351d:	f7 74 24 0c          	divl   0xc(%esp)
  803521:	89 d6                	mov    %edx,%esi
  803523:	89 c3                	mov    %eax,%ebx
  803525:	f7 e5                	mul    %ebp
  803527:	39 d6                	cmp    %edx,%esi
  803529:	72 19                	jb     803544 <__udivdi3+0xfc>
  80352b:	74 0b                	je     803538 <__udivdi3+0xf0>
  80352d:	89 d8                	mov    %ebx,%eax
  80352f:	31 ff                	xor    %edi,%edi
  803531:	e9 58 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  803536:	66 90                	xchg   %ax,%ax
  803538:	8b 54 24 08          	mov    0x8(%esp),%edx
  80353c:	89 f9                	mov    %edi,%ecx
  80353e:	d3 e2                	shl    %cl,%edx
  803540:	39 c2                	cmp    %eax,%edx
  803542:	73 e9                	jae    80352d <__udivdi3+0xe5>
  803544:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803547:	31 ff                	xor    %edi,%edi
  803549:	e9 40 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  80354e:	66 90                	xchg   %ax,%ax
  803550:	31 c0                	xor    %eax,%eax
  803552:	e9 37 ff ff ff       	jmp    80348e <__udivdi3+0x46>
  803557:	90                   	nop

00803558 <__umoddi3>:
  803558:	55                   	push   %ebp
  803559:	57                   	push   %edi
  80355a:	56                   	push   %esi
  80355b:	53                   	push   %ebx
  80355c:	83 ec 1c             	sub    $0x1c,%esp
  80355f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803563:	8b 74 24 34          	mov    0x34(%esp),%esi
  803567:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80356b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80356f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803577:	89 f3                	mov    %esi,%ebx
  803579:	89 fa                	mov    %edi,%edx
  80357b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80357f:	89 34 24             	mov    %esi,(%esp)
  803582:	85 c0                	test   %eax,%eax
  803584:	75 1a                	jne    8035a0 <__umoddi3+0x48>
  803586:	39 f7                	cmp    %esi,%edi
  803588:	0f 86 a2 00 00 00    	jbe    803630 <__umoddi3+0xd8>
  80358e:	89 c8                	mov    %ecx,%eax
  803590:	89 f2                	mov    %esi,%edx
  803592:	f7 f7                	div    %edi
  803594:	89 d0                	mov    %edx,%eax
  803596:	31 d2                	xor    %edx,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	39 f0                	cmp    %esi,%eax
  8035a2:	0f 87 ac 00 00 00    	ja     803654 <__umoddi3+0xfc>
  8035a8:	0f bd e8             	bsr    %eax,%ebp
  8035ab:	83 f5 1f             	xor    $0x1f,%ebp
  8035ae:	0f 84 ac 00 00 00    	je     803660 <__umoddi3+0x108>
  8035b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035b9:	29 ef                	sub    %ebp,%edi
  8035bb:	89 fe                	mov    %edi,%esi
  8035bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035c1:	89 e9                	mov    %ebp,%ecx
  8035c3:	d3 e0                	shl    %cl,%eax
  8035c5:	89 d7                	mov    %edx,%edi
  8035c7:	89 f1                	mov    %esi,%ecx
  8035c9:	d3 ef                	shr    %cl,%edi
  8035cb:	09 c7                	or     %eax,%edi
  8035cd:	89 e9                	mov    %ebp,%ecx
  8035cf:	d3 e2                	shl    %cl,%edx
  8035d1:	89 14 24             	mov    %edx,(%esp)
  8035d4:	89 d8                	mov    %ebx,%eax
  8035d6:	d3 e0                	shl    %cl,%eax
  8035d8:	89 c2                	mov    %eax,%edx
  8035da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035de:	d3 e0                	shl    %cl,%eax
  8035e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e8:	89 f1                	mov    %esi,%ecx
  8035ea:	d3 e8                	shr    %cl,%eax
  8035ec:	09 d0                	or     %edx,%eax
  8035ee:	d3 eb                	shr    %cl,%ebx
  8035f0:	89 da                	mov    %ebx,%edx
  8035f2:	f7 f7                	div    %edi
  8035f4:	89 d3                	mov    %edx,%ebx
  8035f6:	f7 24 24             	mull   (%esp)
  8035f9:	89 c6                	mov    %eax,%esi
  8035fb:	89 d1                	mov    %edx,%ecx
  8035fd:	39 d3                	cmp    %edx,%ebx
  8035ff:	0f 82 87 00 00 00    	jb     80368c <__umoddi3+0x134>
  803605:	0f 84 91 00 00 00    	je     80369c <__umoddi3+0x144>
  80360b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80360f:	29 f2                	sub    %esi,%edx
  803611:	19 cb                	sbb    %ecx,%ebx
  803613:	89 d8                	mov    %ebx,%eax
  803615:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803619:	d3 e0                	shl    %cl,%eax
  80361b:	89 e9                	mov    %ebp,%ecx
  80361d:	d3 ea                	shr    %cl,%edx
  80361f:	09 d0                	or     %edx,%eax
  803621:	89 e9                	mov    %ebp,%ecx
  803623:	d3 eb                	shr    %cl,%ebx
  803625:	89 da                	mov    %ebx,%edx
  803627:	83 c4 1c             	add    $0x1c,%esp
  80362a:	5b                   	pop    %ebx
  80362b:	5e                   	pop    %esi
  80362c:	5f                   	pop    %edi
  80362d:	5d                   	pop    %ebp
  80362e:	c3                   	ret    
  80362f:	90                   	nop
  803630:	89 fd                	mov    %edi,%ebp
  803632:	85 ff                	test   %edi,%edi
  803634:	75 0b                	jne    803641 <__umoddi3+0xe9>
  803636:	b8 01 00 00 00       	mov    $0x1,%eax
  80363b:	31 d2                	xor    %edx,%edx
  80363d:	f7 f7                	div    %edi
  80363f:	89 c5                	mov    %eax,%ebp
  803641:	89 f0                	mov    %esi,%eax
  803643:	31 d2                	xor    %edx,%edx
  803645:	f7 f5                	div    %ebp
  803647:	89 c8                	mov    %ecx,%eax
  803649:	f7 f5                	div    %ebp
  80364b:	89 d0                	mov    %edx,%eax
  80364d:	e9 44 ff ff ff       	jmp    803596 <__umoddi3+0x3e>
  803652:	66 90                	xchg   %ax,%ax
  803654:	89 c8                	mov    %ecx,%eax
  803656:	89 f2                	mov    %esi,%edx
  803658:	83 c4 1c             	add    $0x1c,%esp
  80365b:	5b                   	pop    %ebx
  80365c:	5e                   	pop    %esi
  80365d:	5f                   	pop    %edi
  80365e:	5d                   	pop    %ebp
  80365f:	c3                   	ret    
  803660:	3b 04 24             	cmp    (%esp),%eax
  803663:	72 06                	jb     80366b <__umoddi3+0x113>
  803665:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803669:	77 0f                	ja     80367a <__umoddi3+0x122>
  80366b:	89 f2                	mov    %esi,%edx
  80366d:	29 f9                	sub    %edi,%ecx
  80366f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803673:	89 14 24             	mov    %edx,(%esp)
  803676:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80367a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80367e:	8b 14 24             	mov    (%esp),%edx
  803681:	83 c4 1c             	add    $0x1c,%esp
  803684:	5b                   	pop    %ebx
  803685:	5e                   	pop    %esi
  803686:	5f                   	pop    %edi
  803687:	5d                   	pop    %ebp
  803688:	c3                   	ret    
  803689:	8d 76 00             	lea    0x0(%esi),%esi
  80368c:	2b 04 24             	sub    (%esp),%eax
  80368f:	19 fa                	sbb    %edi,%edx
  803691:	89 d1                	mov    %edx,%ecx
  803693:	89 c6                	mov    %eax,%esi
  803695:	e9 71 ff ff ff       	jmp    80360b <__umoddi3+0xb3>
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036a0:	72 ea                	jb     80368c <__umoddi3+0x134>
  8036a2:	89 d9                	mov    %ebx,%ecx
  8036a4:	e9 62 ff ff ff       	jmp    80360b <__umoddi3+0xb3>
