
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
  80008d:	68 80 37 80 00       	push   $0x803780
  800092:	6a 13                	push   $0x13
  800094:	68 9c 37 80 00       	push   $0x80379c
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
  8000ab:	e8 89 1b 00 00       	call   801c39 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 75 19 00 00       	call   801a2d <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 83 18 00 00       	call   801940 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 b7 37 80 00       	push   $0x8037b7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 4c 16 00 00       	call   80171c <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 bc 37 80 00       	push   $0x8037bc
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 9c 37 80 00       	push   $0x80379c
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 45 18 00 00       	call   801940 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 1c 38 80 00       	push   $0x80381c
  80010c:	6a 21                	push   $0x21
  80010e:	68 9c 37 80 00       	push   $0x80379c
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 2a 19 00 00       	call   801a47 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 0b 19 00 00       	call   801a2d <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 19 18 00 00       	call   801940 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ad 38 80 00       	push   $0x8038ad
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 e2 15 00 00       	call   80171c <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 bc 37 80 00       	push   $0x8037bc
  800151:	6a 27                	push   $0x27
  800153:	68 9c 37 80 00       	push   $0x80379c
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 de 17 00 00       	call   801940 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 1c 38 80 00       	push   $0x80381c
  800173:	6a 28                	push   $0x28
  800175:	68 9c 37 80 00       	push   $0x80379c
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 c3 18 00 00       	call   801a47 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 b0 38 80 00       	push   $0x8038b0
  800196:	6a 2b                	push   $0x2b
  800198:	68 9c 37 80 00       	push   $0x80379c
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 86 18 00 00       	call   801a2d <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 94 17 00 00       	call   801940 <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 e7 38 80 00       	push   $0x8038e7
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 5d 15 00 00       	call   80171c <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 bc 37 80 00       	push   $0x8037bc
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 9c 37 80 00       	push   $0x80379c
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 59 17 00 00       	call   801940 <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 1c 38 80 00       	push   $0x80381c
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 9c 37 80 00       	push   $0x80379c
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 3e 18 00 00       	call   801a47 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 b0 38 80 00       	push   $0x8038b0
  80021b:	6a 34                	push   $0x34
  80021d:	68 9c 37 80 00       	push   $0x80379c
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
  800245:	68 b0 38 80 00       	push   $0x8038b0
  80024a:	6a 37                	push   $0x37
  80024c:	68 9c 37 80 00       	push   $0x80379c
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 03 1b 00 00       	call   801d5e <inctst>

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
  800267:	e8 b4 19 00 00       	call   801c20 <sys_getenvindex>
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
  8002d2:	e8 56 17 00 00       	call   801a2d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 04 39 80 00       	push   $0x803904
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
  800302:	68 2c 39 80 00       	push   $0x80392c
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
  800333:	68 54 39 80 00       	push   $0x803954
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 50 80 00       	mov    0x805020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 ac 39 80 00       	push   $0x8039ac
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 04 39 80 00       	push   $0x803904
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 d6 16 00 00       	call   801a47 <sys_enable_interrupt>

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
  800384:	e8 63 18 00 00       	call   801bec <sys_destroy_env>
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
  800395:	e8 b8 18 00 00       	call   801c52 <sys_exit_env>
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
  8003be:	68 c0 39 80 00       	push   $0x8039c0
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 c5 39 80 00       	push   $0x8039c5
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
  8003fb:	68 e1 39 80 00       	push   $0x8039e1
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
  800427:	68 e4 39 80 00       	push   $0x8039e4
  80042c:	6a 26                	push   $0x26
  80042e:	68 30 3a 80 00       	push   $0x803a30
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
  8004f9:	68 3c 3a 80 00       	push   $0x803a3c
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 30 3a 80 00       	push   $0x803a30
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
  800569:	68 90 3a 80 00       	push   $0x803a90
  80056e:	6a 44                	push   $0x44
  800570:	68 30 3a 80 00       	push   $0x803a30
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
  8005c3:	e8 b7 12 00 00       	call   80187f <sys_cputs>
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
  80063a:	e8 40 12 00 00       	call   80187f <sys_cputs>
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
  800684:	e8 a4 13 00 00       	call   801a2d <sys_disable_interrupt>
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
  8006a4:	e8 9e 13 00 00       	call   801a47 <sys_enable_interrupt>
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
  8006ee:	e8 11 2e 00 00       	call   803504 <__udivdi3>
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
  80073e:	e8 d1 2e 00 00       	call   803614 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 f4 3c 80 00       	add    $0x803cf4,%eax
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
  800899:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
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
  80097a:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 05 3d 80 00       	push   $0x803d05
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
  80099f:	68 0e 3d 80 00       	push   $0x803d0e
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
  8009cc:	be 11 3d 80 00       	mov    $0x803d11,%esi
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
  8013f2:	68 70 3e 80 00       	push   $0x803e70
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
  8014c2:	e8 fc 04 00 00       	call   8019c3 <sys_allocate_chunk>
  8014c7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 71 0b 00 00       	call   802049 <initialize_MemBlocksList>
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
  801500:	68 95 3e 80 00       	push   $0x803e95
  801505:	6a 33                	push   $0x33
  801507:	68 b3 3e 80 00       	push   $0x803eb3
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
  80157f:	68 c0 3e 80 00       	push   $0x803ec0
  801584:	6a 34                	push   $0x34
  801586:	68 b3 3e 80 00       	push   $0x803eb3
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
  801617:	e8 75 07 00 00       	call   801d91 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80161c:	85 c0                	test   %eax,%eax
  80161e:	74 11                	je     801631 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  801620:	83 ec 0c             	sub    $0xc,%esp
  801623:	ff 75 e8             	pushl  -0x18(%ebp)
  801626:	e8 e0 0d 00 00       	call   80240b <alloc_block_FF>
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
  80163d:	e8 3c 0b 00 00       	call   80217e <insert_sorted_allocList>
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
  80165d:	68 e4 3e 80 00       	push   $0x803ee4
  801662:	6a 6f                	push   $0x6f
  801664:	68 b3 3e 80 00       	push   $0x803eb3
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
  801683:	75 0a                	jne    80168f <smalloc+0x21>
  801685:	b8 00 00 00 00       	mov    $0x0,%eax
  80168a:	e9 8b 00 00 00       	jmp    80171a <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80168f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801696:	8b 55 0c             	mov    0xc(%ebp),%edx
  801699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169c:	01 d0                	add    %edx,%eax
  80169e:	48                   	dec    %eax
  80169f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016aa:	f7 75 f0             	divl   -0x10(%ebp)
  8016ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b0:	29 d0                	sub    %edx,%eax
  8016b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  8016b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016bc:	e8 d0 06 00 00       	call   801d91 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	74 11                	je     8016d6 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  8016c5:	83 ec 0c             	sub    $0xc,%esp
  8016c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8016cb:	e8 3b 0d 00 00       	call   80240b <alloc_block_FF>
  8016d0:	83 c4 10             	add    $0x10,%esp
  8016d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016da:	74 39                	je     801715 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016df:	8b 40 08             	mov    0x8(%eax),%eax
  8016e2:	89 c2                	mov    %eax,%edx
  8016e4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016e8:	52                   	push   %edx
  8016e9:	50                   	push   %eax
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	ff 75 08             	pushl  0x8(%ebp)
  8016f0:	e8 21 04 00 00       	call   801b16 <sys_createSharedObject>
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016fb:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016ff:	74 14                	je     801715 <smalloc+0xa7>
  801701:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801705:	74 0e                	je     801715 <smalloc+0xa7>
  801707:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80170b:	74 08                	je     801715 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801710:	8b 40 08             	mov    0x8(%eax),%eax
  801713:	eb 05                	jmp    80171a <smalloc+0xac>
	}
	return NULL;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801722:	e8 b4 fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801727:	83 ec 08             	sub    $0x8,%esp
  80172a:	ff 75 0c             	pushl  0xc(%ebp)
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	e8 0b 04 00 00       	call   801b40 <sys_getSizeOfSharedObject>
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80173b:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80173f:	74 76                	je     8017b7 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801741:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801748:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174e:	01 d0                	add    %edx,%eax
  801750:	48                   	dec    %eax
  801751:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801754:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801757:	ba 00 00 00 00       	mov    $0x0,%edx
  80175c:	f7 75 ec             	divl   -0x14(%ebp)
  80175f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801762:	29 d0                	sub    %edx,%eax
  801764:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801767:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80176e:	e8 1e 06 00 00       	call   801d91 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801773:	85 c0                	test   %eax,%eax
  801775:	74 11                	je     801788 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801777:	83 ec 0c             	sub    $0xc,%esp
  80177a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80177d:	e8 89 0c 00 00       	call   80240b <alloc_block_FF>
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80178c:	74 29                	je     8017b7 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80178e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801791:	8b 40 08             	mov    0x8(%eax),%eax
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	50                   	push   %eax
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	ff 75 08             	pushl  0x8(%ebp)
  80179e:	e8 ba 03 00 00       	call   801b5d <sys_getSharedObject>
  8017a3:	83 c4 10             	add    $0x10,%esp
  8017a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8017a9:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8017ad:	74 08                	je     8017b7 <sget+0x9b>
				return (void *)mem_block->sva;
  8017af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b2:	8b 40 08             	mov    0x8(%eax),%eax
  8017b5:	eb 05                	jmp    8017bc <sget+0xa0>
		}
	}
	return (void *)NULL;
  8017b7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017c4:	e8 12 fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 08 3f 80 00       	push   $0x803f08
  8017d1:	68 f1 00 00 00       	push   $0xf1
  8017d6:	68 b3 3e 80 00       	push   $0x803eb3
  8017db:	e8 bd eb ff ff       	call   80039d <_panic>

008017e0 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 30 3f 80 00       	push   $0x803f30
  8017ee:	68 05 01 00 00       	push   $0x105
  8017f3:	68 b3 3e 80 00       	push   $0x803eb3
  8017f8:	e8 a0 eb ff ff       	call   80039d <_panic>

008017fd <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 54 3f 80 00       	push   $0x803f54
  80180b:	68 10 01 00 00       	push   $0x110
  801810:	68 b3 3e 80 00       	push   $0x803eb3
  801815:	e8 83 eb ff ff       	call   80039d <_panic>

0080181a <shrink>:

}
void shrink(uint32 newSize)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	68 54 3f 80 00       	push   $0x803f54
  801828:	68 15 01 00 00       	push   $0x115
  80182d:	68 b3 3e 80 00       	push   $0x803eb3
  801832:	e8 66 eb ff ff       	call   80039d <_panic>

00801837 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80183d:	83 ec 04             	sub    $0x4,%esp
  801840:	68 54 3f 80 00       	push   $0x803f54
  801845:	68 1a 01 00 00       	push   $0x11a
  80184a:	68 b3 3e 80 00       	push   $0x803eb3
  80184f:	e8 49 eb ff ff       	call   80039d <_panic>

00801854 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	57                   	push   %edi
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80185d:	8b 45 08             	mov    0x8(%ebp),%eax
  801860:	8b 55 0c             	mov    0xc(%ebp),%edx
  801863:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801866:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801869:	8b 7d 18             	mov    0x18(%ebp),%edi
  80186c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80186f:	cd 30                	int    $0x30
  801871:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801874:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801877:	83 c4 10             	add    $0x10,%esp
  80187a:	5b                   	pop    %ebx
  80187b:	5e                   	pop    %esi
  80187c:	5f                   	pop    %edi
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    

0080187f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	8b 45 10             	mov    0x10(%ebp),%eax
  801888:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80188b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	52                   	push   %edx
  801897:	ff 75 0c             	pushl  0xc(%ebp)
  80189a:	50                   	push   %eax
  80189b:	6a 00                	push   $0x0
  80189d:	e8 b2 ff ff ff       	call   801854 <syscall>
  8018a2:	83 c4 18             	add    $0x18,%esp
}
  8018a5:	90                   	nop
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 01                	push   $0x1
  8018b7:	e8 98 ff ff ff       	call   801854 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	52                   	push   %edx
  8018d1:	50                   	push   %eax
  8018d2:	6a 05                	push   $0x5
  8018d4:	e8 7b ff ff ff       	call   801854 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	56                   	push   %esi
  8018e2:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018e3:	8b 75 18             	mov    0x18(%ebp),%esi
  8018e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
  8018f4:	51                   	push   %ecx
  8018f5:	52                   	push   %edx
  8018f6:	50                   	push   %eax
  8018f7:	6a 06                	push   $0x6
  8018f9:	e8 56 ff ff ff       	call   801854 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801904:	5b                   	pop    %ebx
  801905:	5e                   	pop    %esi
  801906:	5d                   	pop    %ebp
  801907:	c3                   	ret    

00801908 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80190b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 07                	push   $0x7
  80191b:	e8 34 ff ff ff       	call   801854 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	ff 75 0c             	pushl  0xc(%ebp)
  801931:	ff 75 08             	pushl  0x8(%ebp)
  801934:	6a 08                	push   $0x8
  801936:	e8 19 ff ff ff       	call   801854 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 09                	push   $0x9
  80194f:	e8 00 ff ff ff       	call   801854 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	c9                   	leave  
  801958:	c3                   	ret    

00801959 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 0a                	push   $0xa
  801968:	e8 e7 fe ff ff       	call   801854 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 0b                	push   $0xb
  801981:	e8 ce fe ff ff       	call   801854 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	ff 75 08             	pushl  0x8(%ebp)
  80199a:	6a 0f                	push   $0xf
  80199c:	e8 b3 fe ff ff       	call   801854 <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
	return;
  8019a4:	90                   	nop
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	6a 10                	push   $0x10
  8019b8:	e8 97 fe ff ff       	call   801854 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c0:	90                   	nop
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	ff 75 10             	pushl  0x10(%ebp)
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	ff 75 08             	pushl  0x8(%ebp)
  8019d3:	6a 11                	push   $0x11
  8019d5:	e8 7a fe ff ff       	call   801854 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dd:	90                   	nop
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0c                	push   $0xc
  8019ef:	e8 60 fe ff ff       	call   801854 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	ff 75 08             	pushl  0x8(%ebp)
  801a07:	6a 0d                	push   $0xd
  801a09:	e8 46 fe ff ff       	call   801854 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 0e                	push   $0xe
  801a22:	e8 2d fe ff ff       	call   801854 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	90                   	nop
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 13                	push   $0x13
  801a3c:	e8 13 fe ff ff       	call   801854 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 14                	push   $0x14
  801a56:	e8 f9 fd ff ff       	call   801854 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	90                   	nop
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a6d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	50                   	push   %eax
  801a7a:	6a 15                	push   $0x15
  801a7c:	e8 d3 fd ff ff       	call   801854 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	90                   	nop
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 16                	push   $0x16
  801a96:	e8 b9 fd ff ff       	call   801854 <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	50                   	push   %eax
  801ab1:	6a 17                	push   $0x17
  801ab3:	e8 9c fd ff ff       	call   801854 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 1a                	push   $0x1a
  801ad0:	e8 7f fd ff ff       	call   801854 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	52                   	push   %edx
  801aea:	50                   	push   %eax
  801aeb:	6a 18                	push   $0x18
  801aed:	e8 62 fd ff ff       	call   801854 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	90                   	nop
  801af6:	c9                   	leave  
  801af7:	c3                   	ret    

00801af8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	52                   	push   %edx
  801b08:	50                   	push   %eax
  801b09:	6a 19                	push   $0x19
  801b0b:	e8 44 fd ff ff       	call   801854 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	90                   	nop
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b22:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b25:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	51                   	push   %ecx
  801b2f:	52                   	push   %edx
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	50                   	push   %eax
  801b34:	6a 1b                	push   $0x1b
  801b36:	e8 19 fd ff ff       	call   801854 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 1c                	push   $0x1c
  801b53:	e8 fc fc ff ff       	call   801854 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b60:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	51                   	push   %ecx
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 1d                	push   $0x1d
  801b72:	e8 dd fc ff ff       	call   801854 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	52                   	push   %edx
  801b8c:	50                   	push   %eax
  801b8d:	6a 1e                	push   $0x1e
  801b8f:	e8 c0 fc ff ff       	call   801854 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 1f                	push   $0x1f
  801ba8:	e8 a7 fc ff ff       	call   801854 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	ff 75 14             	pushl  0x14(%ebp)
  801bbd:	ff 75 10             	pushl  0x10(%ebp)
  801bc0:	ff 75 0c             	pushl  0xc(%ebp)
  801bc3:	50                   	push   %eax
  801bc4:	6a 20                	push   $0x20
  801bc6:	e8 89 fc ff ff       	call   801854 <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	50                   	push   %eax
  801bdf:	6a 21                	push   $0x21
  801be1:	e8 6e fc ff ff       	call   801854 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	50                   	push   %eax
  801bfb:	6a 22                	push   $0x22
  801bfd:	e8 52 fc ff ff       	call   801854 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 02                	push   $0x2
  801c16:	e8 39 fc ff ff       	call   801854 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 03                	push   $0x3
  801c2f:	e8 20 fc ff ff       	call   801854 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 04                	push   $0x4
  801c48:	e8 07 fc ff ff       	call   801854 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_exit_env>:


void sys_exit_env(void)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 23                	push   $0x23
  801c61:	e8 ee fb ff ff       	call   801854 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
}
  801c69:	90                   	nop
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c72:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c75:	8d 50 04             	lea    0x4(%eax),%edx
  801c78:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	52                   	push   %edx
  801c82:	50                   	push   %eax
  801c83:	6a 24                	push   $0x24
  801c85:	e8 ca fb ff ff       	call   801854 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c96:	89 01                	mov    %eax,(%ecx)
  801c98:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	c9                   	leave  
  801c9f:	c2 04 00             	ret    $0x4

00801ca2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	ff 75 10             	pushl  0x10(%ebp)
  801cac:	ff 75 0c             	pushl  0xc(%ebp)
  801caf:	ff 75 08             	pushl  0x8(%ebp)
  801cb2:	6a 12                	push   $0x12
  801cb4:	e8 9b fb ff ff       	call   801854 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbc:	90                   	nop
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_rcr2>:
uint32 sys_rcr2()
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 25                	push   $0x25
  801cce:	e8 81 fb ff ff       	call   801854 <syscall>
  801cd3:	83 c4 18             	add    $0x18,%esp
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ce4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	50                   	push   %eax
  801cf1:	6a 26                	push   $0x26
  801cf3:	e8 5c fb ff ff       	call   801854 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <rsttst>:
void rsttst()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 28                	push   $0x28
  801d0d:	e8 42 fb ff ff       	call   801854 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
	return ;
  801d15:	90                   	nop
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d24:	8b 55 18             	mov    0x18(%ebp),%edx
  801d27:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d2b:	52                   	push   %edx
  801d2c:	50                   	push   %eax
  801d2d:	ff 75 10             	pushl  0x10(%ebp)
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	ff 75 08             	pushl  0x8(%ebp)
  801d36:	6a 27                	push   $0x27
  801d38:	e8 17 fb ff ff       	call   801854 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d40:	90                   	nop
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <chktst>:
void chktst(uint32 n)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	ff 75 08             	pushl  0x8(%ebp)
  801d51:	6a 29                	push   $0x29
  801d53:	e8 fc fa ff ff       	call   801854 <syscall>
  801d58:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5b:	90                   	nop
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <inctst>:

void inctst()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 2a                	push   $0x2a
  801d6d:	e8 e2 fa ff ff       	call   801854 <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
	return ;
  801d75:	90                   	nop
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <gettst>:
uint32 gettst()
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 2b                	push   $0x2b
  801d87:	e8 c8 fa ff ff       	call   801854 <syscall>
  801d8c:	83 c4 18             	add    $0x18,%esp
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 2c                	push   $0x2c
  801da3:	e8 ac fa ff ff       	call   801854 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
  801dab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dae:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801db2:	75 07                	jne    801dbb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801db4:	b8 01 00 00 00       	mov    $0x1,%eax
  801db9:	eb 05                	jmp    801dc0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 2c                	push   $0x2c
  801dd4:	e8 7b fa ff ff       	call   801854 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
  801ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ddf:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801de3:	75 07                	jne    801dec <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801de5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dea:	eb 05                	jmp    801df1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 2c                	push   $0x2c
  801e05:	e8 4a fa ff ff       	call   801854 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
  801e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e10:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e14:	75 07                	jne    801e1d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e16:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1b:	eb 05                	jmp    801e22 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
  801e27:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 2c                	push   $0x2c
  801e36:	e8 19 fa ff ff       	call   801854 <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
  801e3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e41:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e45:	75 07                	jne    801e4e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e47:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4c:	eb 05                	jmp    801e53 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	ff 75 08             	pushl  0x8(%ebp)
  801e63:	6a 2d                	push   $0x2d
  801e65:	e8 ea f9 ff ff       	call   801854 <syscall>
  801e6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6d:	90                   	nop
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e74:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e77:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	53                   	push   %ebx
  801e83:	51                   	push   %ecx
  801e84:	52                   	push   %edx
  801e85:	50                   	push   %eax
  801e86:	6a 2e                	push   $0x2e
  801e88:	e8 c7 f9 ff ff       	call   801854 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
}
  801e90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e98:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	52                   	push   %edx
  801ea5:	50                   	push   %eax
  801ea6:	6a 2f                	push   $0x2f
  801ea8:	e8 a7 f9 ff ff       	call   801854 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	68 64 3f 80 00       	push   $0x803f64
  801ec0:	e8 8c e7 ff ff       	call   800651 <cprintf>
  801ec5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ec8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ecf:	83 ec 0c             	sub    $0xc,%esp
  801ed2:	68 90 3f 80 00       	push   $0x803f90
  801ed7:	e8 75 e7 ff ff       	call   800651 <cprintf>
  801edc:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801edf:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ee3:	a1 38 51 80 00       	mov    0x805138,%eax
  801ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eeb:	eb 56                	jmp    801f43 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ef1:	74 1c                	je     801f0f <print_mem_block_lists+0x5d>
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 50 08             	mov    0x8(%eax),%edx
  801ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efc:	8b 48 08             	mov    0x8(%eax),%ecx
  801eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f02:	8b 40 0c             	mov    0xc(%eax),%eax
  801f05:	01 c8                	add    %ecx,%eax
  801f07:	39 c2                	cmp    %eax,%edx
  801f09:	73 04                	jae    801f0f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f0b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 50 08             	mov    0x8(%eax),%edx
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1b:	01 c2                	add    %eax,%edx
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	8b 40 08             	mov    0x8(%eax),%eax
  801f23:	83 ec 04             	sub    $0x4,%esp
  801f26:	52                   	push   %edx
  801f27:	50                   	push   %eax
  801f28:	68 a5 3f 80 00       	push   $0x803fa5
  801f2d:	e8 1f e7 ff ff       	call   800651 <cprintf>
  801f32:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f3b:	a1 40 51 80 00       	mov    0x805140,%eax
  801f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f47:	74 07                	je     801f50 <print_mem_block_lists+0x9e>
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4c:	8b 00                	mov    (%eax),%eax
  801f4e:	eb 05                	jmp    801f55 <print_mem_block_lists+0xa3>
  801f50:	b8 00 00 00 00       	mov    $0x0,%eax
  801f55:	a3 40 51 80 00       	mov    %eax,0x805140
  801f5a:	a1 40 51 80 00       	mov    0x805140,%eax
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	75 8a                	jne    801eed <print_mem_block_lists+0x3b>
  801f63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f67:	75 84                	jne    801eed <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f69:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f6d:	75 10                	jne    801f7f <print_mem_block_lists+0xcd>
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	68 b4 3f 80 00       	push   $0x803fb4
  801f77:	e8 d5 e6 ff ff       	call   800651 <cprintf>
  801f7c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f7f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	68 d8 3f 80 00       	push   $0x803fd8
  801f8e:	e8 be e6 ff ff       	call   800651 <cprintf>
  801f93:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f96:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f9a:	a1 40 50 80 00       	mov    0x805040,%eax
  801f9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa2:	eb 56                	jmp    801ffa <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa8:	74 1c                	je     801fc6 <print_mem_block_lists+0x114>
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 50 08             	mov    0x8(%eax),%edx
  801fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb3:	8b 48 08             	mov    0x8(%eax),%ecx
  801fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbc:	01 c8                	add    %ecx,%eax
  801fbe:	39 c2                	cmp    %eax,%edx
  801fc0:	73 04                	jae    801fc6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fc2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 50 08             	mov    0x8(%eax),%edx
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fd2:	01 c2                	add    %eax,%edx
  801fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd7:	8b 40 08             	mov    0x8(%eax),%eax
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	52                   	push   %edx
  801fde:	50                   	push   %eax
  801fdf:	68 a5 3f 80 00       	push   $0x803fa5
  801fe4:	e8 68 e6 ff ff       	call   800651 <cprintf>
  801fe9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ff2:	a1 48 50 80 00       	mov    0x805048,%eax
  801ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ffa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffe:	74 07                	je     802007 <print_mem_block_lists+0x155>
  802000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802003:	8b 00                	mov    (%eax),%eax
  802005:	eb 05                	jmp    80200c <print_mem_block_lists+0x15a>
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	a3 48 50 80 00       	mov    %eax,0x805048
  802011:	a1 48 50 80 00       	mov    0x805048,%eax
  802016:	85 c0                	test   %eax,%eax
  802018:	75 8a                	jne    801fa4 <print_mem_block_lists+0xf2>
  80201a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201e:	75 84                	jne    801fa4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802020:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802024:	75 10                	jne    802036 <print_mem_block_lists+0x184>
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	68 f0 3f 80 00       	push   $0x803ff0
  80202e:	e8 1e e6 ff ff       	call   800651 <cprintf>
  802033:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802036:	83 ec 0c             	sub    $0xc,%esp
  802039:	68 64 3f 80 00       	push   $0x803f64
  80203e:	e8 0e e6 ff ff       	call   800651 <cprintf>
  802043:	83 c4 10             	add    $0x10,%esp

}
  802046:	90                   	nop
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80204f:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802056:	00 00 00 
  802059:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802060:	00 00 00 
  802063:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80206a:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80206d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802074:	e9 9e 00 00 00       	jmp    802117 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802079:	a1 50 50 80 00       	mov    0x805050,%eax
  80207e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802081:	c1 e2 04             	shl    $0x4,%edx
  802084:	01 d0                	add    %edx,%eax
  802086:	85 c0                	test   %eax,%eax
  802088:	75 14                	jne    80209e <initialize_MemBlocksList+0x55>
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	68 18 40 80 00       	push   $0x804018
  802092:	6a 46                	push   $0x46
  802094:	68 3b 40 80 00       	push   $0x80403b
  802099:	e8 ff e2 ff ff       	call   80039d <_panic>
  80209e:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	c1 e2 04             	shl    $0x4,%edx
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020b1:	89 10                	mov    %edx,(%eax)
  8020b3:	8b 00                	mov    (%eax),%eax
  8020b5:	85 c0                	test   %eax,%eax
  8020b7:	74 18                	je     8020d1 <initialize_MemBlocksList+0x88>
  8020b9:	a1 48 51 80 00       	mov    0x805148,%eax
  8020be:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8020c4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c7:	c1 e1 04             	shl    $0x4,%ecx
  8020ca:	01 ca                	add    %ecx,%edx
  8020cc:	89 50 04             	mov    %edx,0x4(%eax)
  8020cf:	eb 12                	jmp    8020e3 <initialize_MemBlocksList+0x9a>
  8020d1:	a1 50 50 80 00       	mov    0x805050,%eax
  8020d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d9:	c1 e2 04             	shl    $0x4,%edx
  8020dc:	01 d0                	add    %edx,%eax
  8020de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020e3:	a1 50 50 80 00       	mov    0x805050,%eax
  8020e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020eb:	c1 e2 04             	shl    $0x4,%edx
  8020ee:	01 d0                	add    %edx,%eax
  8020f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8020f5:	a1 50 50 80 00       	mov    0x805050,%eax
  8020fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fd:	c1 e2 04             	shl    $0x4,%edx
  802100:	01 d0                	add    %edx,%eax
  802102:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802109:	a1 54 51 80 00       	mov    0x805154,%eax
  80210e:	40                   	inc    %eax
  80210f:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802114:	ff 45 f4             	incl   -0xc(%ebp)
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80211d:	0f 82 56 ff ff ff    	jb     802079 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802123:	90                   	nop
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	8b 00                	mov    (%eax),%eax
  802131:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802134:	eb 19                	jmp    80214f <find_block+0x29>
	{
		if(va==point->sva)
  802136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802139:	8b 40 08             	mov    0x8(%eax),%eax
  80213c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80213f:	75 05                	jne    802146 <find_block+0x20>
		   return point;
  802141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802144:	eb 36                	jmp    80217c <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	8b 40 08             	mov    0x8(%eax),%eax
  80214c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80214f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802153:	74 07                	je     80215c <find_block+0x36>
  802155:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802158:	8b 00                	mov    (%eax),%eax
  80215a:	eb 05                	jmp    802161 <find_block+0x3b>
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
  802161:	8b 55 08             	mov    0x8(%ebp),%edx
  802164:	89 42 08             	mov    %eax,0x8(%edx)
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	8b 40 08             	mov    0x8(%eax),%eax
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 c5                	jne    802136 <find_block+0x10>
  802171:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802175:	75 bf                	jne    802136 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802177:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802184:	a1 40 50 80 00       	mov    0x805040,%eax
  802189:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80218c:	a1 44 50 80 00       	mov    0x805044,%eax
  802191:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802197:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80219a:	74 24                	je     8021c0 <insert_sorted_allocList+0x42>
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	8b 50 08             	mov    0x8(%eax),%edx
  8021a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a5:	8b 40 08             	mov    0x8(%eax),%eax
  8021a8:	39 c2                	cmp    %eax,%edx
  8021aa:	76 14                	jbe    8021c0 <insert_sorted_allocList+0x42>
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8b 50 08             	mov    0x8(%eax),%edx
  8021b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b5:	8b 40 08             	mov    0x8(%eax),%eax
  8021b8:	39 c2                	cmp    %eax,%edx
  8021ba:	0f 82 60 01 00 00    	jb     802320 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8021c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c4:	75 65                	jne    80222b <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8021c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ca:	75 14                	jne    8021e0 <insert_sorted_allocList+0x62>
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	68 18 40 80 00       	push   $0x804018
  8021d4:	6a 6b                	push   $0x6b
  8021d6:	68 3b 40 80 00       	push   $0x80403b
  8021db:	e8 bd e1 ff ff       	call   80039d <_panic>
  8021e0:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	89 10                	mov    %edx,(%eax)
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	8b 00                	mov    (%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	74 0d                	je     802201 <insert_sorted_allocList+0x83>
  8021f4:	a1 40 50 80 00       	mov    0x805040,%eax
  8021f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021fc:	89 50 04             	mov    %edx,0x4(%eax)
  8021ff:	eb 08                	jmp    802209 <insert_sorted_allocList+0x8b>
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	a3 44 50 80 00       	mov    %eax,0x805044
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	a3 40 50 80 00       	mov    %eax,0x805040
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80221b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802220:	40                   	inc    %eax
  802221:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802226:	e9 dc 01 00 00       	jmp    802407 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	8b 50 08             	mov    0x8(%eax),%edx
  802231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802234:	8b 40 08             	mov    0x8(%eax),%eax
  802237:	39 c2                	cmp    %eax,%edx
  802239:	77 6c                	ja     8022a7 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80223b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80223f:	74 06                	je     802247 <insert_sorted_allocList+0xc9>
  802241:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802245:	75 14                	jne    80225b <insert_sorted_allocList+0xdd>
  802247:	83 ec 04             	sub    $0x4,%esp
  80224a:	68 54 40 80 00       	push   $0x804054
  80224f:	6a 6f                	push   $0x6f
  802251:	68 3b 40 80 00       	push   $0x80403b
  802256:	e8 42 e1 ff ff       	call   80039d <_panic>
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225e:	8b 50 04             	mov    0x4(%eax),%edx
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	89 50 04             	mov    %edx,0x4(%eax)
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80226d:	89 10                	mov    %edx,(%eax)
  80226f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802272:	8b 40 04             	mov    0x4(%eax),%eax
  802275:	85 c0                	test   %eax,%eax
  802277:	74 0d                	je     802286 <insert_sorted_allocList+0x108>
  802279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80227c:	8b 40 04             	mov    0x4(%eax),%eax
  80227f:	8b 55 08             	mov    0x8(%ebp),%edx
  802282:	89 10                	mov    %edx,(%eax)
  802284:	eb 08                	jmp    80228e <insert_sorted_allocList+0x110>
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	a3 40 50 80 00       	mov    %eax,0x805040
  80228e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802291:	8b 55 08             	mov    0x8(%ebp),%edx
  802294:	89 50 04             	mov    %edx,0x4(%eax)
  802297:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80229c:	40                   	inc    %eax
  80229d:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a2:	e9 60 01 00 00       	jmp    802407 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	8b 50 08             	mov    0x8(%eax),%edx
  8022ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022b0:	8b 40 08             	mov    0x8(%eax),%eax
  8022b3:	39 c2                	cmp    %eax,%edx
  8022b5:	0f 82 4c 01 00 00    	jb     802407 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8022bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022bf:	75 14                	jne    8022d5 <insert_sorted_allocList+0x157>
  8022c1:	83 ec 04             	sub    $0x4,%esp
  8022c4:	68 8c 40 80 00       	push   $0x80408c
  8022c9:	6a 73                	push   $0x73
  8022cb:	68 3b 40 80 00       	push   $0x80403b
  8022d0:	e8 c8 e0 ff ff       	call   80039d <_panic>
  8022d5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	89 50 04             	mov    %edx,0x4(%eax)
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	8b 40 04             	mov    0x4(%eax),%eax
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	74 0c                	je     8022f7 <insert_sorted_allocList+0x179>
  8022eb:	a1 44 50 80 00       	mov    0x805044,%eax
  8022f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f3:	89 10                	mov    %edx,(%eax)
  8022f5:	eb 08                	jmp    8022ff <insert_sorted_allocList+0x181>
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	a3 40 50 80 00       	mov    %eax,0x805040
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	a3 44 50 80 00       	mov    %eax,0x805044
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802310:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802315:	40                   	inc    %eax
  802316:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80231b:	e9 e7 00 00 00       	jmp    802407 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802323:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802326:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80232d:	a1 40 50 80 00       	mov    0x805040,%eax
  802332:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802335:	e9 9d 00 00 00       	jmp    8023d7 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	8b 50 08             	mov    0x8(%eax),%edx
  802348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234b:	8b 40 08             	mov    0x8(%eax),%eax
  80234e:	39 c2                	cmp    %eax,%edx
  802350:	76 7d                	jbe    8023cf <insert_sorted_allocList+0x251>
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	8b 50 08             	mov    0x8(%eax),%edx
  802358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80235b:	8b 40 08             	mov    0x8(%eax),%eax
  80235e:	39 c2                	cmp    %eax,%edx
  802360:	73 6d                	jae    8023cf <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802366:	74 06                	je     80236e <insert_sorted_allocList+0x1f0>
  802368:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80236c:	75 14                	jne    802382 <insert_sorted_allocList+0x204>
  80236e:	83 ec 04             	sub    $0x4,%esp
  802371:	68 b0 40 80 00       	push   $0x8040b0
  802376:	6a 7f                	push   $0x7f
  802378:	68 3b 40 80 00       	push   $0x80403b
  80237d:	e8 1b e0 ff ff       	call   80039d <_panic>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 10                	mov    (%eax),%edx
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	89 10                	mov    %edx,(%eax)
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	85 c0                	test   %eax,%eax
  802393:	74 0b                	je     8023a0 <insert_sorted_allocList+0x222>
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
  80239d:	89 50 04             	mov    %edx,0x4(%eax)
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a6:	89 10                	mov    %edx,(%eax)
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ae:	89 50 04             	mov    %edx,0x4(%eax)
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	75 08                	jne    8023c2 <insert_sorted_allocList+0x244>
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	a3 44 50 80 00       	mov    %eax,0x805044
  8023c2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023c7:	40                   	inc    %eax
  8023c8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8023cd:	eb 39                	jmp    802408 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023cf:	a1 48 50 80 00       	mov    0x805048,%eax
  8023d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023db:	74 07                	je     8023e4 <insert_sorted_allocList+0x266>
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	8b 00                	mov    (%eax),%eax
  8023e2:	eb 05                	jmp    8023e9 <insert_sorted_allocList+0x26b>
  8023e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e9:	a3 48 50 80 00       	mov    %eax,0x805048
  8023ee:	a1 48 50 80 00       	mov    0x805048,%eax
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	0f 85 3f ff ff ff    	jne    80233a <insert_sorted_allocList+0x1bc>
  8023fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ff:	0f 85 35 ff ff ff    	jne    80233a <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802405:	eb 01                	jmp    802408 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802407:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802408:	90                   	nop
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802411:	a1 38 51 80 00       	mov    0x805138,%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802419:	e9 85 01 00 00       	jmp    8025a3 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 40 0c             	mov    0xc(%eax),%eax
  802424:	3b 45 08             	cmp    0x8(%ebp),%eax
  802427:	0f 82 6e 01 00 00    	jb     80259b <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 0c             	mov    0xc(%eax),%eax
  802433:	3b 45 08             	cmp    0x8(%ebp),%eax
  802436:	0f 85 8a 00 00 00    	jne    8024c6 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80243c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802440:	75 17                	jne    802459 <alloc_block_FF+0x4e>
  802442:	83 ec 04             	sub    $0x4,%esp
  802445:	68 e4 40 80 00       	push   $0x8040e4
  80244a:	68 93 00 00 00       	push   $0x93
  80244f:	68 3b 40 80 00       	push   $0x80403b
  802454:	e8 44 df ff ff       	call   80039d <_panic>
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 00                	mov    (%eax),%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	74 10                	je     802472 <alloc_block_FF+0x67>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 00                	mov    (%eax),%eax
  802467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246a:	8b 52 04             	mov    0x4(%edx),%edx
  80246d:	89 50 04             	mov    %edx,0x4(%eax)
  802470:	eb 0b                	jmp    80247d <alloc_block_FF+0x72>
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 40 04             	mov    0x4(%eax),%eax
  802478:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 04             	mov    0x4(%eax),%eax
  802483:	85 c0                	test   %eax,%eax
  802485:	74 0f                	je     802496 <alloc_block_FF+0x8b>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 04             	mov    0x4(%eax),%eax
  80248d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802490:	8b 12                	mov    (%edx),%edx
  802492:	89 10                	mov    %edx,(%eax)
  802494:	eb 0a                	jmp    8024a0 <alloc_block_FF+0x95>
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 00                	mov    (%eax),%eax
  80249b:	a3 38 51 80 00       	mov    %eax,0x805138
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8024b8:	48                   	dec    %eax
  8024b9:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	e9 10 01 00 00       	jmp    8025d6 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024cf:	0f 86 c6 00 00 00    	jbe    80259b <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024d5:	a1 48 51 80 00       	mov    0x805148,%eax
  8024da:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 50 08             	mov    0x8(%eax),%edx
  8024e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e6:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ef:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f6:	75 17                	jne    80250f <alloc_block_FF+0x104>
  8024f8:	83 ec 04             	sub    $0x4,%esp
  8024fb:	68 e4 40 80 00       	push   $0x8040e4
  802500:	68 9b 00 00 00       	push   $0x9b
  802505:	68 3b 40 80 00       	push   $0x80403b
  80250a:	e8 8e de ff ff       	call   80039d <_panic>
  80250f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802512:	8b 00                	mov    (%eax),%eax
  802514:	85 c0                	test   %eax,%eax
  802516:	74 10                	je     802528 <alloc_block_FF+0x11d>
  802518:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251b:	8b 00                	mov    (%eax),%eax
  80251d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802520:	8b 52 04             	mov    0x4(%edx),%edx
  802523:	89 50 04             	mov    %edx,0x4(%eax)
  802526:	eb 0b                	jmp    802533 <alloc_block_FF+0x128>
  802528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252b:	8b 40 04             	mov    0x4(%eax),%eax
  80252e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	8b 40 04             	mov    0x4(%eax),%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	74 0f                	je     80254c <alloc_block_FF+0x141>
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802546:	8b 12                	mov    (%edx),%edx
  802548:	89 10                	mov    %edx,(%eax)
  80254a:	eb 0a                	jmp    802556 <alloc_block_FF+0x14b>
  80254c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	a3 48 51 80 00       	mov    %eax,0x805148
  802556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802562:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802569:	a1 54 51 80 00       	mov    0x805154,%eax
  80256e:	48                   	dec    %eax
  80256f:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 50 08             	mov    0x8(%eax),%edx
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	01 c2                	add    %eax,%edx
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 40 0c             	mov    0xc(%eax),%eax
  80258b:	2b 45 08             	sub    0x8(%ebp),%eax
  80258e:	89 c2                	mov    %eax,%edx
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802599:	eb 3b                	jmp    8025d6 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80259b:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a7:	74 07                	je     8025b0 <alloc_block_FF+0x1a5>
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	eb 05                	jmp    8025b5 <alloc_block_FF+0x1aa>
  8025b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	0f 85 57 fe ff ff    	jne    80241e <alloc_block_FF+0x13>
  8025c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cb:	0f 85 4d fe ff ff    	jne    80241e <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8025d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d6:	c9                   	leave  
  8025d7:	c3                   	ret    

008025d8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025d8:	55                   	push   %ebp
  8025d9:	89 e5                	mov    %esp,%ebp
  8025db:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8025ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ed:	e9 df 00 00 00       	jmp    8026d1 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025fb:	0f 82 c8 00 00 00    	jb     8026c9 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 40 0c             	mov    0xc(%eax),%eax
  802607:	3b 45 08             	cmp    0x8(%ebp),%eax
  80260a:	0f 85 8a 00 00 00    	jne    80269a <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802610:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802614:	75 17                	jne    80262d <alloc_block_BF+0x55>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 e4 40 80 00       	push   $0x8040e4
  80261e:	68 b7 00 00 00       	push   $0xb7
  802623:	68 3b 40 80 00       	push   $0x80403b
  802628:	e8 70 dd ff ff       	call   80039d <_panic>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	85 c0                	test   %eax,%eax
  802634:	74 10                	je     802646 <alloc_block_BF+0x6e>
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80263e:	8b 52 04             	mov    0x4(%edx),%edx
  802641:	89 50 04             	mov    %edx,0x4(%eax)
  802644:	eb 0b                	jmp    802651 <alloc_block_BF+0x79>
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 04             	mov    0x4(%eax),%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	74 0f                	je     80266a <alloc_block_BF+0x92>
  80265b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802664:	8b 12                	mov    (%edx),%edx
  802666:	89 10                	mov    %edx,(%eax)
  802668:	eb 0a                	jmp    802674 <alloc_block_BF+0x9c>
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 00                	mov    (%eax),%eax
  80266f:	a3 38 51 80 00       	mov    %eax,0x805138
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802687:	a1 44 51 80 00       	mov    0x805144,%eax
  80268c:	48                   	dec    %eax
  80268d:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	e9 4d 01 00 00       	jmp    8027e7 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a3:	76 24                	jbe    8026c9 <alloc_block_BF+0xf1>
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026ae:	73 19                	jae    8026c9 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026b0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 08             	mov    0x8(%eax),%eax
  8026c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8026c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d5:	74 07                	je     8026de <alloc_block_BF+0x106>
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 00                	mov    (%eax),%eax
  8026dc:	eb 05                	jmp    8026e3 <alloc_block_BF+0x10b>
  8026de:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e3:	a3 40 51 80 00       	mov    %eax,0x805140
  8026e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	0f 85 fd fe ff ff    	jne    8025f2 <alloc_block_BF+0x1a>
  8026f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f9:	0f 85 f3 fe ff ff    	jne    8025f2 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802703:	0f 84 d9 00 00 00    	je     8027e2 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802709:	a1 48 51 80 00       	mov    0x805148,%eax
  80270e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802714:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802717:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80271a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271d:	8b 55 08             	mov    0x8(%ebp),%edx
  802720:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802723:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802727:	75 17                	jne    802740 <alloc_block_BF+0x168>
  802729:	83 ec 04             	sub    $0x4,%esp
  80272c:	68 e4 40 80 00       	push   $0x8040e4
  802731:	68 c7 00 00 00       	push   $0xc7
  802736:	68 3b 40 80 00       	push   $0x80403b
  80273b:	e8 5d dc ff ff       	call   80039d <_panic>
  802740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	85 c0                	test   %eax,%eax
  802747:	74 10                	je     802759 <alloc_block_BF+0x181>
  802749:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274c:	8b 00                	mov    (%eax),%eax
  80274e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802751:	8b 52 04             	mov    0x4(%edx),%edx
  802754:	89 50 04             	mov    %edx,0x4(%eax)
  802757:	eb 0b                	jmp    802764 <alloc_block_BF+0x18c>
  802759:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275c:	8b 40 04             	mov    0x4(%eax),%eax
  80275f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802764:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802767:	8b 40 04             	mov    0x4(%eax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	74 0f                	je     80277d <alloc_block_BF+0x1a5>
  80276e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802777:	8b 12                	mov    (%edx),%edx
  802779:	89 10                	mov    %edx,(%eax)
  80277b:	eb 0a                	jmp    802787 <alloc_block_BF+0x1af>
  80277d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	a3 48 51 80 00       	mov    %eax,0x805148
  802787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802793:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279a:	a1 54 51 80 00       	mov    0x805154,%eax
  80279f:	48                   	dec    %eax
  8027a0:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027a5:	83 ec 08             	sub    $0x8,%esp
  8027a8:	ff 75 ec             	pushl  -0x14(%ebp)
  8027ab:	68 38 51 80 00       	push   $0x805138
  8027b0:	e8 71 f9 ff ff       	call   802126 <find_block>
  8027b5:	83 c4 10             	add    $0x10,%esp
  8027b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8027bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027be:	8b 50 08             	mov    0x8(%eax),%edx
  8027c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c4:	01 c2                	add    %eax,%edx
  8027c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c9:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8027cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d5:	89 c2                	mov    %eax,%edx
  8027d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027da:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e0:	eb 05                	jmp    8027e7 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e7:	c9                   	leave  
  8027e8:	c3                   	ret    

008027e9 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027e9:	55                   	push   %ebp
  8027ea:	89 e5                	mov    %esp,%ebp
  8027ec:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027ef:	a1 28 50 80 00       	mov    0x805028,%eax
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	0f 85 de 01 00 00    	jne    8029da <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027fc:	a1 38 51 80 00       	mov    0x805138,%eax
  802801:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802804:	e9 9e 01 00 00       	jmp    8029a7 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 40 0c             	mov    0xc(%eax),%eax
  80280f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802812:	0f 82 87 01 00 00    	jb     80299f <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 40 0c             	mov    0xc(%eax),%eax
  80281e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802821:	0f 85 95 00 00 00    	jne    8028bc <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802827:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282b:	75 17                	jne    802844 <alloc_block_NF+0x5b>
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	68 e4 40 80 00       	push   $0x8040e4
  802835:	68 e0 00 00 00       	push   $0xe0
  80283a:	68 3b 40 80 00       	push   $0x80403b
  80283f:	e8 59 db ff ff       	call   80039d <_panic>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	74 10                	je     80285d <alloc_block_NF+0x74>
  80284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802855:	8b 52 04             	mov    0x4(%edx),%edx
  802858:	89 50 04             	mov    %edx,0x4(%eax)
  80285b:	eb 0b                	jmp    802868 <alloc_block_NF+0x7f>
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	85 c0                	test   %eax,%eax
  802870:	74 0f                	je     802881 <alloc_block_NF+0x98>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287b:	8b 12                	mov    (%edx),%edx
  80287d:	89 10                	mov    %edx,(%eax)
  80287f:	eb 0a                	jmp    80288b <alloc_block_NF+0xa2>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	a3 38 51 80 00       	mov    %eax,0x805138
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289e:	a1 44 51 80 00       	mov    0x805144,%eax
  8028a3:	48                   	dec    %eax
  8028a4:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 40 08             	mov    0x8(%eax),%eax
  8028af:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	e9 f8 04 00 00       	jmp    802db4 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c5:	0f 86 d4 00 00 00    	jbe    80299f <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8028d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	8b 50 08             	mov    0x8(%eax),%edx
  8028d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dc:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e5:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ec:	75 17                	jne    802905 <alloc_block_NF+0x11c>
  8028ee:	83 ec 04             	sub    $0x4,%esp
  8028f1:	68 e4 40 80 00       	push   $0x8040e4
  8028f6:	68 e9 00 00 00       	push   $0xe9
  8028fb:	68 3b 40 80 00       	push   $0x80403b
  802900:	e8 98 da ff ff       	call   80039d <_panic>
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 10                	je     80291e <alloc_block_NF+0x135>
  80290e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802911:	8b 00                	mov    (%eax),%eax
  802913:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802916:	8b 52 04             	mov    0x4(%edx),%edx
  802919:	89 50 04             	mov    %edx,0x4(%eax)
  80291c:	eb 0b                	jmp    802929 <alloc_block_NF+0x140>
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	85 c0                	test   %eax,%eax
  802931:	74 0f                	je     802942 <alloc_block_NF+0x159>
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293c:	8b 12                	mov    (%edx),%edx
  80293e:	89 10                	mov    %edx,(%eax)
  802940:	eb 0a                	jmp    80294c <alloc_block_NF+0x163>
  802942:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802945:	8b 00                	mov    (%eax),%eax
  802947:	a3 48 51 80 00       	mov    %eax,0x805148
  80294c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295f:	a1 54 51 80 00       	mov    0x805154,%eax
  802964:	48                   	dec    %eax
  802965:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80296a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296d:	8b 40 08             	mov    0x8(%eax),%eax
  802970:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 50 08             	mov    0x8(%eax),%edx
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	01 c2                	add    %eax,%edx
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	8b 40 0c             	mov    0xc(%eax),%eax
  80298c:	2b 45 08             	sub    0x8(%ebp),%eax
  80298f:	89 c2                	mov    %eax,%edx
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299a:	e9 15 04 00 00       	jmp    802db4 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80299f:	a1 40 51 80 00       	mov    0x805140,%eax
  8029a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ab:	74 07                	je     8029b4 <alloc_block_NF+0x1cb>
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	eb 05                	jmp    8029b9 <alloc_block_NF+0x1d0>
  8029b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b9:	a3 40 51 80 00       	mov    %eax,0x805140
  8029be:	a1 40 51 80 00       	mov    0x805140,%eax
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	0f 85 3e fe ff ff    	jne    802809 <alloc_block_NF+0x20>
  8029cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cf:	0f 85 34 fe ff ff    	jne    802809 <alloc_block_NF+0x20>
  8029d5:	e9 d5 03 00 00       	jmp    802daf <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029da:	a1 38 51 80 00       	mov    0x805138,%eax
  8029df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e2:	e9 b1 01 00 00       	jmp    802b98 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 50 08             	mov    0x8(%eax),%edx
  8029ed:	a1 28 50 80 00       	mov    0x805028,%eax
  8029f2:	39 c2                	cmp    %eax,%edx
  8029f4:	0f 82 96 01 00 00    	jb     802b90 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802a00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a03:	0f 82 87 01 00 00    	jb     802b90 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a12:	0f 85 95 00 00 00    	jne    802aad <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1c:	75 17                	jne    802a35 <alloc_block_NF+0x24c>
  802a1e:	83 ec 04             	sub    $0x4,%esp
  802a21:	68 e4 40 80 00       	push   $0x8040e4
  802a26:	68 fc 00 00 00       	push   $0xfc
  802a2b:	68 3b 40 80 00       	push   $0x80403b
  802a30:	e8 68 d9 ff ff       	call   80039d <_panic>
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	74 10                	je     802a4e <alloc_block_NF+0x265>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a46:	8b 52 04             	mov    0x4(%edx),%edx
  802a49:	89 50 04             	mov    %edx,0x4(%eax)
  802a4c:	eb 0b                	jmp    802a59 <alloc_block_NF+0x270>
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 40 04             	mov    0x4(%eax),%eax
  802a54:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 0f                	je     802a72 <alloc_block_NF+0x289>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 40 04             	mov    0x4(%eax),%eax
  802a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6c:	8b 12                	mov    (%edx),%edx
  802a6e:	89 10                	mov    %edx,(%eax)
  802a70:	eb 0a                	jmp    802a7c <alloc_block_NF+0x293>
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	a3 38 51 80 00       	mov    %eax,0x805138
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8f:	a1 44 51 80 00       	mov    0x805144,%eax
  802a94:	48                   	dec    %eax
  802a95:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	e9 07 03 00 00       	jmp    802db4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab6:	0f 86 d4 00 00 00    	jbe    802b90 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802abc:	a1 48 51 80 00       	mov    0x805148,%eax
  802ac1:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 50 08             	mov    0x8(%eax),%edx
  802aca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acd:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ad9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802add:	75 17                	jne    802af6 <alloc_block_NF+0x30d>
  802adf:	83 ec 04             	sub    $0x4,%esp
  802ae2:	68 e4 40 80 00       	push   $0x8040e4
  802ae7:	68 04 01 00 00       	push   $0x104
  802aec:	68 3b 40 80 00       	push   $0x80403b
  802af1:	e8 a7 d8 ff ff       	call   80039d <_panic>
  802af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 10                	je     802b0f <alloc_block_NF+0x326>
  802aff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b07:	8b 52 04             	mov    0x4(%edx),%edx
  802b0a:	89 50 04             	mov    %edx,0x4(%eax)
  802b0d:	eb 0b                	jmp    802b1a <alloc_block_NF+0x331>
  802b0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1d:	8b 40 04             	mov    0x4(%eax),%eax
  802b20:	85 c0                	test   %eax,%eax
  802b22:	74 0f                	je     802b33 <alloc_block_NF+0x34a>
  802b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b2d:	8b 12                	mov    (%edx),%edx
  802b2f:	89 10                	mov    %edx,(%eax)
  802b31:	eb 0a                	jmp    802b3d <alloc_block_NF+0x354>
  802b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	a3 48 51 80 00       	mov    %eax,0x805148
  802b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b50:	a1 54 51 80 00       	mov    0x805154,%eax
  802b55:	48                   	dec    %eax
  802b56:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5e:	8b 40 08             	mov    0x8(%eax),%eax
  802b61:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 50 08             	mov    0x8(%eax),%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	01 c2                	add    %eax,%edx
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b80:	89 c2                	mov    %eax,%edx
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8b:	e9 24 02 00 00       	jmp    802db4 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b90:	a1 40 51 80 00       	mov    0x805140,%eax
  802b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9c:	74 07                	je     802ba5 <alloc_block_NF+0x3bc>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	eb 05                	jmp    802baa <alloc_block_NF+0x3c1>
  802ba5:	b8 00 00 00 00       	mov    $0x0,%eax
  802baa:	a3 40 51 80 00       	mov    %eax,0x805140
  802baf:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	0f 85 2b fe ff ff    	jne    8029e7 <alloc_block_NF+0x1fe>
  802bbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc0:	0f 85 21 fe ff ff    	jne    8029e7 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bc6:	a1 38 51 80 00       	mov    0x805138,%eax
  802bcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bce:	e9 ae 01 00 00       	jmp    802d81 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 50 08             	mov    0x8(%eax),%edx
  802bd9:	a1 28 50 80 00       	mov    0x805028,%eax
  802bde:	39 c2                	cmp    %eax,%edx
  802be0:	0f 83 93 01 00 00    	jae    802d79 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bec:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bef:	0f 82 84 01 00 00    	jb     802d79 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfe:	0f 85 95 00 00 00    	jne    802c99 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	75 17                	jne    802c21 <alloc_block_NF+0x438>
  802c0a:	83 ec 04             	sub    $0x4,%esp
  802c0d:	68 e4 40 80 00       	push   $0x8040e4
  802c12:	68 14 01 00 00       	push   $0x114
  802c17:	68 3b 40 80 00       	push   $0x80403b
  802c1c:	e8 7c d7 ff ff       	call   80039d <_panic>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	74 10                	je     802c3a <alloc_block_NF+0x451>
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c32:	8b 52 04             	mov    0x4(%edx),%edx
  802c35:	89 50 04             	mov    %edx,0x4(%eax)
  802c38:	eb 0b                	jmp    802c45 <alloc_block_NF+0x45c>
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 40 04             	mov    0x4(%eax),%eax
  802c40:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	85 c0                	test   %eax,%eax
  802c4d:	74 0f                	je     802c5e <alloc_block_NF+0x475>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 04             	mov    0x4(%eax),%eax
  802c55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c58:	8b 12                	mov    (%edx),%edx
  802c5a:	89 10                	mov    %edx,(%eax)
  802c5c:	eb 0a                	jmp    802c68 <alloc_block_NF+0x47f>
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	a3 38 51 80 00       	mov    %eax,0x805138
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c80:	48                   	dec    %eax
  802c81:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 08             	mov    0x8(%eax),%eax
  802c8c:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	e9 1b 01 00 00       	jmp    802db4 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca2:	0f 86 d1 00 00 00    	jbe    802d79 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ca8:	a1 48 51 80 00       	mov    0x805148,%eax
  802cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 50 08             	mov    0x8(%eax),%edx
  802cb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc2:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802cc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cc9:	75 17                	jne    802ce2 <alloc_block_NF+0x4f9>
  802ccb:	83 ec 04             	sub    $0x4,%esp
  802cce:	68 e4 40 80 00       	push   $0x8040e4
  802cd3:	68 1c 01 00 00       	push   $0x11c
  802cd8:	68 3b 40 80 00       	push   $0x80403b
  802cdd:	e8 bb d6 ff ff       	call   80039d <_panic>
  802ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	74 10                	je     802cfb <alloc_block_NF+0x512>
  802ceb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cf3:	8b 52 04             	mov    0x4(%edx),%edx
  802cf6:	89 50 04             	mov    %edx,0x4(%eax)
  802cf9:	eb 0b                	jmp    802d06 <alloc_block_NF+0x51d>
  802cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	74 0f                	je     802d1f <alloc_block_NF+0x536>
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d19:	8b 12                	mov    (%edx),%edx
  802d1b:	89 10                	mov    %edx,(%eax)
  802d1d:	eb 0a                	jmp    802d29 <alloc_block_NF+0x540>
  802d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	a3 48 51 80 00       	mov    %eax,0x805148
  802d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d41:	48                   	dec    %eax
  802d42:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4a:	8b 40 08             	mov    0x8(%eax),%eax
  802d4d:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d55:	8b 50 08             	mov    0x8(%eax),%edx
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	01 c2                	add    %eax,%edx
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d66:	8b 40 0c             	mov    0xc(%eax),%eax
  802d69:	2b 45 08             	sub    0x8(%ebp),%eax
  802d6c:	89 c2                	mov    %eax,%edx
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d77:	eb 3b                	jmp    802db4 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d79:	a1 40 51 80 00       	mov    0x805140,%eax
  802d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d85:	74 07                	je     802d8e <alloc_block_NF+0x5a5>
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 00                	mov    (%eax),%eax
  802d8c:	eb 05                	jmp    802d93 <alloc_block_NF+0x5aa>
  802d8e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d93:	a3 40 51 80 00       	mov    %eax,0x805140
  802d98:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	0f 85 2e fe ff ff    	jne    802bd3 <alloc_block_NF+0x3ea>
  802da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da9:	0f 85 24 fe ff ff    	jne    802bd3 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802db4:	c9                   	leave  
  802db5:	c3                   	ret    

00802db6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802db6:	55                   	push   %ebp
  802db7:	89 e5                	mov    %esp,%ebp
  802db9:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802dbc:	a1 38 51 80 00       	mov    0x805138,%eax
  802dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802dc4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dc9:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802dcc:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd1:	85 c0                	test   %eax,%eax
  802dd3:	74 14                	je     802de9 <insert_sorted_with_merge_freeList+0x33>
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	8b 50 08             	mov    0x8(%eax),%edx
  802ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dde:	8b 40 08             	mov    0x8(%eax),%eax
  802de1:	39 c2                	cmp    %eax,%edx
  802de3:	0f 87 9b 01 00 00    	ja     802f84 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802de9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ded:	75 17                	jne    802e06 <insert_sorted_with_merge_freeList+0x50>
  802def:	83 ec 04             	sub    $0x4,%esp
  802df2:	68 18 40 80 00       	push   $0x804018
  802df7:	68 38 01 00 00       	push   $0x138
  802dfc:	68 3b 40 80 00       	push   $0x80403b
  802e01:	e8 97 d5 ff ff       	call   80039d <_panic>
  802e06:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0f:	89 10                	mov    %edx,(%eax)
  802e11:	8b 45 08             	mov    0x8(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 0d                	je     802e27 <insert_sorted_with_merge_freeList+0x71>
  802e1a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e22:	89 50 04             	mov    %edx,0x4(%eax)
  802e25:	eb 08                	jmp    802e2f <insert_sorted_with_merge_freeList+0x79>
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	a3 38 51 80 00       	mov    %eax,0x805138
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e41:	a1 44 51 80 00       	mov    0x805144,%eax
  802e46:	40                   	inc    %eax
  802e47:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e50:	0f 84 a8 06 00 00    	je     8034fe <insert_sorted_with_merge_freeList+0x748>
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	8b 50 08             	mov    0x8(%eax),%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
  802e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e67:	8b 40 08             	mov    0x8(%eax),%eax
  802e6a:	39 c2                	cmp    %eax,%edx
  802e6c:	0f 85 8c 06 00 00    	jne    8034fe <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	8b 50 0c             	mov    0xc(%eax),%edx
  802e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	01 c2                	add    %eax,%edx
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e8a:	75 17                	jne    802ea3 <insert_sorted_with_merge_freeList+0xed>
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 e4 40 80 00       	push   $0x8040e4
  802e94:	68 3c 01 00 00       	push   $0x13c
  802e99:	68 3b 40 80 00       	push   $0x80403b
  802e9e:	e8 fa d4 ff ff       	call   80039d <_panic>
  802ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	74 10                	je     802ebc <insert_sorted_with_merge_freeList+0x106>
  802eac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb4:	8b 52 04             	mov    0x4(%edx),%edx
  802eb7:	89 50 04             	mov    %edx,0x4(%eax)
  802eba:	eb 0b                	jmp    802ec7 <insert_sorted_with_merge_freeList+0x111>
  802ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebf:	8b 40 04             	mov    0x4(%eax),%eax
  802ec2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eca:	8b 40 04             	mov    0x4(%eax),%eax
  802ecd:	85 c0                	test   %eax,%eax
  802ecf:	74 0f                	je     802ee0 <insert_sorted_with_merge_freeList+0x12a>
  802ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eda:	8b 12                	mov    (%edx),%edx
  802edc:	89 10                	mov    %edx,(%eax)
  802ede:	eb 0a                	jmp    802eea <insert_sorted_with_merge_freeList+0x134>
  802ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee3:	8b 00                	mov    (%eax),%eax
  802ee5:	a3 38 51 80 00       	mov    %eax,0x805138
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efd:	a1 44 51 80 00       	mov    0x805144,%eax
  802f02:	48                   	dec    %eax
  802f03:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f20:	75 17                	jne    802f39 <insert_sorted_with_merge_freeList+0x183>
  802f22:	83 ec 04             	sub    $0x4,%esp
  802f25:	68 18 40 80 00       	push   $0x804018
  802f2a:	68 3f 01 00 00       	push   $0x13f
  802f2f:	68 3b 40 80 00       	push   $0x80403b
  802f34:	e8 64 d4 ff ff       	call   80039d <_panic>
  802f39:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	74 0d                	je     802f5a <insert_sorted_with_merge_freeList+0x1a4>
  802f4d:	a1 48 51 80 00       	mov    0x805148,%eax
  802f52:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f55:	89 50 04             	mov    %edx,0x4(%eax)
  802f58:	eb 08                	jmp    802f62 <insert_sorted_with_merge_freeList+0x1ac>
  802f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	a3 48 51 80 00       	mov    %eax,0x805148
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f74:	a1 54 51 80 00       	mov    0x805154,%eax
  802f79:	40                   	inc    %eax
  802f7a:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f7f:	e9 7a 05 00 00       	jmp    8034fe <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	8b 50 08             	mov    0x8(%eax),%edx
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	8b 40 08             	mov    0x8(%eax),%eax
  802f90:	39 c2                	cmp    %eax,%edx
  802f92:	0f 82 14 01 00 00    	jb     8030ac <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9b:	8b 50 08             	mov    0x8(%eax),%edx
  802f9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa4:	01 c2                	add    %eax,%edx
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	8b 40 08             	mov    0x8(%eax),%eax
  802fac:	39 c2                	cmp    %eax,%edx
  802fae:	0f 85 90 00 00 00    	jne    803044 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb7:	8b 50 0c             	mov    0xc(%eax),%edx
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc0:	01 c2                	add    %eax,%edx
  802fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc5:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe0:	75 17                	jne    802ff9 <insert_sorted_with_merge_freeList+0x243>
  802fe2:	83 ec 04             	sub    $0x4,%esp
  802fe5:	68 18 40 80 00       	push   $0x804018
  802fea:	68 49 01 00 00       	push   $0x149
  802fef:	68 3b 40 80 00       	push   $0x80403b
  802ff4:	e8 a4 d3 ff ff       	call   80039d <_panic>
  802ff9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	89 10                	mov    %edx,(%eax)
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	8b 00                	mov    (%eax),%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	74 0d                	je     80301a <insert_sorted_with_merge_freeList+0x264>
  80300d:	a1 48 51 80 00       	mov    0x805148,%eax
  803012:	8b 55 08             	mov    0x8(%ebp),%edx
  803015:	89 50 04             	mov    %edx,0x4(%eax)
  803018:	eb 08                	jmp    803022 <insert_sorted_with_merge_freeList+0x26c>
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	a3 48 51 80 00       	mov    %eax,0x805148
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803034:	a1 54 51 80 00       	mov    0x805154,%eax
  803039:	40                   	inc    %eax
  80303a:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80303f:	e9 bb 04 00 00       	jmp    8034ff <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803044:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803048:	75 17                	jne    803061 <insert_sorted_with_merge_freeList+0x2ab>
  80304a:	83 ec 04             	sub    $0x4,%esp
  80304d:	68 8c 40 80 00       	push   $0x80408c
  803052:	68 4c 01 00 00       	push   $0x14c
  803057:	68 3b 40 80 00       	push   $0x80403b
  80305c:	e8 3c d3 ff ff       	call   80039d <_panic>
  803061:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	89 50 04             	mov    %edx,0x4(%eax)
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	8b 40 04             	mov    0x4(%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 0c                	je     803083 <insert_sorted_with_merge_freeList+0x2cd>
  803077:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80307c:	8b 55 08             	mov    0x8(%ebp),%edx
  80307f:	89 10                	mov    %edx,(%eax)
  803081:	eb 08                	jmp    80308b <insert_sorted_with_merge_freeList+0x2d5>
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	a3 38 51 80 00       	mov    %eax,0x805138
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80309c:	a1 44 51 80 00       	mov    0x805144,%eax
  8030a1:	40                   	inc    %eax
  8030a2:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030a7:	e9 53 04 00 00       	jmp    8034ff <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8030b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030b4:	e9 15 04 00 00       	jmp    8034ce <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	8b 50 08             	mov    0x8(%eax),%edx
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	8b 40 08             	mov    0x8(%eax),%eax
  8030cd:	39 c2                	cmp    %eax,%edx
  8030cf:	0f 86 f1 03 00 00    	jbe    8034c6 <insert_sorted_with_merge_freeList+0x710>
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	8b 50 08             	mov    0x8(%eax),%edx
  8030db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030de:	8b 40 08             	mov    0x8(%eax),%eax
  8030e1:	39 c2                	cmp    %eax,%edx
  8030e3:	0f 83 dd 03 00 00    	jae    8034c6 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 50 08             	mov    0x8(%eax),%edx
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f5:	01 c2                	add    %eax,%edx
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	8b 40 08             	mov    0x8(%eax),%eax
  8030fd:	39 c2                	cmp    %eax,%edx
  8030ff:	0f 85 b9 01 00 00    	jne    8032be <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	8b 50 08             	mov    0x8(%eax),%edx
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	8b 40 0c             	mov    0xc(%eax),%eax
  803111:	01 c2                	add    %eax,%edx
  803113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803116:	8b 40 08             	mov    0x8(%eax),%eax
  803119:	39 c2                	cmp    %eax,%edx
  80311b:	0f 85 0d 01 00 00    	jne    80322e <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803124:	8b 50 0c             	mov    0xc(%eax),%edx
  803127:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312a:	8b 40 0c             	mov    0xc(%eax),%eax
  80312d:	01 c2                	add    %eax,%edx
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803135:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803139:	75 17                	jne    803152 <insert_sorted_with_merge_freeList+0x39c>
  80313b:	83 ec 04             	sub    $0x4,%esp
  80313e:	68 e4 40 80 00       	push   $0x8040e4
  803143:	68 5c 01 00 00       	push   $0x15c
  803148:	68 3b 40 80 00       	push   $0x80403b
  80314d:	e8 4b d2 ff ff       	call   80039d <_panic>
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	85 c0                	test   %eax,%eax
  803159:	74 10                	je     80316b <insert_sorted_with_merge_freeList+0x3b5>
  80315b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315e:	8b 00                	mov    (%eax),%eax
  803160:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803163:	8b 52 04             	mov    0x4(%edx),%edx
  803166:	89 50 04             	mov    %edx,0x4(%eax)
  803169:	eb 0b                	jmp    803176 <insert_sorted_with_merge_freeList+0x3c0>
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	8b 40 04             	mov    0x4(%eax),%eax
  803171:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803179:	8b 40 04             	mov    0x4(%eax),%eax
  80317c:	85 c0                	test   %eax,%eax
  80317e:	74 0f                	je     80318f <insert_sorted_with_merge_freeList+0x3d9>
  803180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803183:	8b 40 04             	mov    0x4(%eax),%eax
  803186:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803189:	8b 12                	mov    (%edx),%edx
  80318b:	89 10                	mov    %edx,(%eax)
  80318d:	eb 0a                	jmp    803199 <insert_sorted_with_merge_freeList+0x3e3>
  80318f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803192:	8b 00                	mov    (%eax),%eax
  803194:	a3 38 51 80 00       	mov    %eax,0x805138
  803199:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ac:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b1:	48                   	dec    %eax
  8031b2:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031cf:	75 17                	jne    8031e8 <insert_sorted_with_merge_freeList+0x432>
  8031d1:	83 ec 04             	sub    $0x4,%esp
  8031d4:	68 18 40 80 00       	push   $0x804018
  8031d9:	68 5f 01 00 00       	push   $0x15f
  8031de:	68 3b 40 80 00       	push   $0x80403b
  8031e3:	e8 b5 d1 ff ff       	call   80039d <_panic>
  8031e8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	89 10                	mov    %edx,(%eax)
  8031f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f6:	8b 00                	mov    (%eax),%eax
  8031f8:	85 c0                	test   %eax,%eax
  8031fa:	74 0d                	je     803209 <insert_sorted_with_merge_freeList+0x453>
  8031fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803201:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803204:	89 50 04             	mov    %edx,0x4(%eax)
  803207:	eb 08                	jmp    803211 <insert_sorted_with_merge_freeList+0x45b>
  803209:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803214:	a3 48 51 80 00       	mov    %eax,0x805148
  803219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803223:	a1 54 51 80 00       	mov    0x805154,%eax
  803228:	40                   	inc    %eax
  803229:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 50 0c             	mov    0xc(%eax),%edx
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	8b 40 0c             	mov    0xc(%eax),%eax
  80323a:	01 c2                	add    %eax,%edx
  80323c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323f:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325a:	75 17                	jne    803273 <insert_sorted_with_merge_freeList+0x4bd>
  80325c:	83 ec 04             	sub    $0x4,%esp
  80325f:	68 18 40 80 00       	push   $0x804018
  803264:	68 64 01 00 00       	push   $0x164
  803269:	68 3b 40 80 00       	push   $0x80403b
  80326e:	e8 2a d1 ff ff       	call   80039d <_panic>
  803273:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	8b 00                	mov    (%eax),%eax
  803283:	85 c0                	test   %eax,%eax
  803285:	74 0d                	je     803294 <insert_sorted_with_merge_freeList+0x4de>
  803287:	a1 48 51 80 00       	mov    0x805148,%eax
  80328c:	8b 55 08             	mov    0x8(%ebp),%edx
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	eb 08                	jmp    80329c <insert_sorted_with_merge_freeList+0x4e6>
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ae:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b3:	40                   	inc    %eax
  8032b4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032b9:	e9 41 02 00 00       	jmp    8034ff <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	8b 50 08             	mov    0x8(%eax),%edx
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ca:	01 c2                	add    %eax,%edx
  8032cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cf:	8b 40 08             	mov    0x8(%eax),%eax
  8032d2:	39 c2                	cmp    %eax,%edx
  8032d4:	0f 85 7c 01 00 00    	jne    803456 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032de:	74 06                	je     8032e6 <insert_sorted_with_merge_freeList+0x530>
  8032e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e4:	75 17                	jne    8032fd <insert_sorted_with_merge_freeList+0x547>
  8032e6:	83 ec 04             	sub    $0x4,%esp
  8032e9:	68 54 40 80 00       	push   $0x804054
  8032ee:	68 69 01 00 00       	push   $0x169
  8032f3:	68 3b 40 80 00       	push   $0x80403b
  8032f8:	e8 a0 d0 ff ff       	call   80039d <_panic>
  8032fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803300:	8b 50 04             	mov    0x4(%eax),%edx
  803303:	8b 45 08             	mov    0x8(%ebp),%eax
  803306:	89 50 04             	mov    %edx,0x4(%eax)
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330f:	89 10                	mov    %edx,(%eax)
  803311:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803314:	8b 40 04             	mov    0x4(%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 0d                	je     803328 <insert_sorted_with_merge_freeList+0x572>
  80331b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331e:	8b 40 04             	mov    0x4(%eax),%eax
  803321:	8b 55 08             	mov    0x8(%ebp),%edx
  803324:	89 10                	mov    %edx,(%eax)
  803326:	eb 08                	jmp    803330 <insert_sorted_with_merge_freeList+0x57a>
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	a3 38 51 80 00       	mov    %eax,0x805138
  803330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803333:	8b 55 08             	mov    0x8(%ebp),%edx
  803336:	89 50 04             	mov    %edx,0x4(%eax)
  803339:	a1 44 51 80 00       	mov    0x805144,%eax
  80333e:	40                   	inc    %eax
  80333f:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	8b 50 0c             	mov    0xc(%eax),%edx
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	8b 40 0c             	mov    0xc(%eax),%eax
  803350:	01 c2                	add    %eax,%edx
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803358:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80335c:	75 17                	jne    803375 <insert_sorted_with_merge_freeList+0x5bf>
  80335e:	83 ec 04             	sub    $0x4,%esp
  803361:	68 e4 40 80 00       	push   $0x8040e4
  803366:	68 6b 01 00 00       	push   $0x16b
  80336b:	68 3b 40 80 00       	push   $0x80403b
  803370:	e8 28 d0 ff ff       	call   80039d <_panic>
  803375:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803378:	8b 00                	mov    (%eax),%eax
  80337a:	85 c0                	test   %eax,%eax
  80337c:	74 10                	je     80338e <insert_sorted_with_merge_freeList+0x5d8>
  80337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803381:	8b 00                	mov    (%eax),%eax
  803383:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803386:	8b 52 04             	mov    0x4(%edx),%edx
  803389:	89 50 04             	mov    %edx,0x4(%eax)
  80338c:	eb 0b                	jmp    803399 <insert_sorted_with_merge_freeList+0x5e3>
  80338e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803391:	8b 40 04             	mov    0x4(%eax),%eax
  803394:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803399:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339c:	8b 40 04             	mov    0x4(%eax),%eax
  80339f:	85 c0                	test   %eax,%eax
  8033a1:	74 0f                	je     8033b2 <insert_sorted_with_merge_freeList+0x5fc>
  8033a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a6:	8b 40 04             	mov    0x4(%eax),%eax
  8033a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033ac:	8b 12                	mov    (%edx),%edx
  8033ae:	89 10                	mov    %edx,(%eax)
  8033b0:	eb 0a                	jmp    8033bc <insert_sorted_with_merge_freeList+0x606>
  8033b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b5:	8b 00                	mov    (%eax),%eax
  8033b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8033bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033cf:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d4:	48                   	dec    %eax
  8033d5:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033f2:	75 17                	jne    80340b <insert_sorted_with_merge_freeList+0x655>
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	68 18 40 80 00       	push   $0x804018
  8033fc:	68 6e 01 00 00       	push   $0x16e
  803401:	68 3b 40 80 00       	push   $0x80403b
  803406:	e8 92 cf ff ff       	call   80039d <_panic>
  80340b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803411:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803414:	89 10                	mov    %edx,(%eax)
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 0d                	je     80342c <insert_sorted_with_merge_freeList+0x676>
  80341f:	a1 48 51 80 00       	mov    0x805148,%eax
  803424:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803427:	89 50 04             	mov    %edx,0x4(%eax)
  80342a:	eb 08                	jmp    803434 <insert_sorted_with_merge_freeList+0x67e>
  80342c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803434:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803437:	a3 48 51 80 00       	mov    %eax,0x805148
  80343c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803446:	a1 54 51 80 00       	mov    0x805154,%eax
  80344b:	40                   	inc    %eax
  80344c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803451:	e9 a9 00 00 00       	jmp    8034ff <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345a:	74 06                	je     803462 <insert_sorted_with_merge_freeList+0x6ac>
  80345c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803460:	75 17                	jne    803479 <insert_sorted_with_merge_freeList+0x6c3>
  803462:	83 ec 04             	sub    $0x4,%esp
  803465:	68 b0 40 80 00       	push   $0x8040b0
  80346a:	68 73 01 00 00       	push   $0x173
  80346f:	68 3b 40 80 00       	push   $0x80403b
  803474:	e8 24 cf ff ff       	call   80039d <_panic>
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347c:	8b 10                	mov    (%eax),%edx
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	89 10                	mov    %edx,(%eax)
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	8b 00                	mov    (%eax),%eax
  803488:	85 c0                	test   %eax,%eax
  80348a:	74 0b                	je     803497 <insert_sorted_with_merge_freeList+0x6e1>
  80348c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348f:	8b 00                	mov    (%eax),%eax
  803491:	8b 55 08             	mov    0x8(%ebp),%edx
  803494:	89 50 04             	mov    %edx,0x4(%eax)
  803497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349a:	8b 55 08             	mov    0x8(%ebp),%edx
  80349d:	89 10                	mov    %edx,(%eax)
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034a5:	89 50 04             	mov    %edx,0x4(%eax)
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	8b 00                	mov    (%eax),%eax
  8034ad:	85 c0                	test   %eax,%eax
  8034af:	75 08                	jne    8034b9 <insert_sorted_with_merge_freeList+0x703>
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8034be:	40                   	inc    %eax
  8034bf:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8034c4:	eb 39                	jmp    8034ff <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8034c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8034cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034d2:	74 07                	je     8034db <insert_sorted_with_merge_freeList+0x725>
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	8b 00                	mov    (%eax),%eax
  8034d9:	eb 05                	jmp    8034e0 <insert_sorted_with_merge_freeList+0x72a>
  8034db:	b8 00 00 00 00       	mov    $0x0,%eax
  8034e0:	a3 40 51 80 00       	mov    %eax,0x805140
  8034e5:	a1 40 51 80 00       	mov    0x805140,%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	0f 85 c7 fb ff ff    	jne    8030b9 <insert_sorted_with_merge_freeList+0x303>
  8034f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034f6:	0f 85 bd fb ff ff    	jne    8030b9 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034fc:	eb 01                	jmp    8034ff <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034fe:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034ff:	90                   	nop
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
