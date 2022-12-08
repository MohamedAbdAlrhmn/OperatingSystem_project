
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
  80008d:	68 20 36 80 00       	push   $0x803620
  800092:	6a 13                	push   $0x13
  800094:	68 3c 36 80 00       	push   $0x80363c
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
  8000ab:	e8 42 1a 00 00       	call   801af2 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 2e 18 00 00       	call   8018e6 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 3c 17 00 00       	call   8017f9 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 57 36 80 00       	push   $0x803657
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 85 15 00 00       	call   801655 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 5c 36 80 00       	push   $0x80365c
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 3c 36 80 00       	push   $0x80363c
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 fe 16 00 00       	call   8017f9 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 bc 36 80 00       	push   $0x8036bc
  80010c:	6a 21                	push   $0x21
  80010e:	68 3c 36 80 00       	push   $0x80363c
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 e3 17 00 00       	call   801900 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 c4 17 00 00       	call   8018e6 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 d2 16 00 00       	call   8017f9 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 4d 37 80 00       	push   $0x80374d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 1b 15 00 00       	call   801655 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 5c 36 80 00       	push   $0x80365c
  800151:	6a 27                	push   $0x27
  800153:	68 3c 36 80 00       	push   $0x80363c
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 97 16 00 00       	call   8017f9 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 bc 36 80 00       	push   $0x8036bc
  800173:	6a 28                	push   $0x28
  800175:	68 3c 36 80 00       	push   $0x80363c
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 7c 17 00 00       	call   801900 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 50 37 80 00       	push   $0x803750
  800196:	6a 2b                	push   $0x2b
  800198:	68 3c 36 80 00       	push   $0x80363c
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 3f 17 00 00       	call   8018e6 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 4d 16 00 00       	call   8017f9 <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 87 37 80 00       	push   $0x803787
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 96 14 00 00       	call   801655 <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 5c 36 80 00       	push   $0x80365c
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 3c 36 80 00       	push   $0x80363c
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 12 16 00 00       	call   8017f9 <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 bc 36 80 00       	push   $0x8036bc
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 3c 36 80 00       	push   $0x80363c
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 f7 16 00 00       	call   801900 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 50 37 80 00       	push   $0x803750
  80021b:	6a 34                	push   $0x34
  80021d:	68 3c 36 80 00       	push   $0x80363c
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
  800245:	68 50 37 80 00       	push   $0x803750
  80024a:	6a 37                	push   $0x37
  80024c:	68 3c 36 80 00       	push   $0x80363c
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 bc 19 00 00       	call   801c17 <inctst>

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
  800267:	e8 6d 18 00 00       	call   801ad9 <sys_getenvindex>
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
  8002d2:	e8 0f 16 00 00       	call   8018e6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 a4 37 80 00       	push   $0x8037a4
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
  800302:	68 cc 37 80 00       	push   $0x8037cc
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
  800333:	68 f4 37 80 00       	push   $0x8037f4
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 50 80 00       	mov    0x805020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 4c 38 80 00       	push   $0x80384c
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 a4 37 80 00       	push   $0x8037a4
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 8f 15 00 00       	call   801900 <sys_enable_interrupt>

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
  800384:	e8 1c 17 00 00       	call   801aa5 <sys_destroy_env>
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
  800395:	e8 71 17 00 00       	call   801b0b <sys_exit_env>
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
  8003be:	68 60 38 80 00       	push   $0x803860
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 65 38 80 00       	push   $0x803865
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
  8003fb:	68 81 38 80 00       	push   $0x803881
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
  800427:	68 84 38 80 00       	push   $0x803884
  80042c:	6a 26                	push   $0x26
  80042e:	68 d0 38 80 00       	push   $0x8038d0
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
  8004f9:	68 dc 38 80 00       	push   $0x8038dc
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 d0 38 80 00       	push   $0x8038d0
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
  800569:	68 30 39 80 00       	push   $0x803930
  80056e:	6a 44                	push   $0x44
  800570:	68 d0 38 80 00       	push   $0x8038d0
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
  8005c3:	e8 70 11 00 00       	call   801738 <sys_cputs>
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
  80063a:	e8 f9 10 00 00       	call   801738 <sys_cputs>
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
  800684:	e8 5d 12 00 00       	call   8018e6 <sys_disable_interrupt>
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
  8006a4:	e8 57 12 00 00       	call   801900 <sys_enable_interrupt>
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
  8006ee:	e8 c9 2c 00 00       	call   8033bc <__udivdi3>
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
  80073e:	e8 89 2d 00 00       	call   8034cc <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 94 3b 80 00       	add    $0x803b94,%eax
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
  800899:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
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
  80097a:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 a5 3b 80 00       	push   $0x803ba5
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
  80099f:	68 ae 3b 80 00       	push   $0x803bae
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
  8009cc:	be b1 3b 80 00       	mov    $0x803bb1,%esi
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
  8013f2:	68 10 3d 80 00       	push   $0x803d10
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
  8014c2:	e8 b5 03 00 00       	call   80187c <sys_allocate_chunk>
  8014c7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 2a 0a 00 00       	call   801f02 <initialize_MemBlocksList>
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
  801500:	68 35 3d 80 00       	push   $0x803d35
  801505:	6a 33                	push   $0x33
  801507:	68 53 3d 80 00       	push   $0x803d53
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
  80157f:	68 60 3d 80 00       	push   $0x803d60
  801584:	6a 34                	push   $0x34
  801586:	68 53 3d 80 00       	push   $0x803d53
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
  8015f4:	68 84 3d 80 00       	push   $0x803d84
  8015f9:	6a 46                	push   $0x46
  8015fb:	68 53 3d 80 00       	push   $0x803d53
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
  801610:	68 ac 3d 80 00       	push   $0x803dac
  801615:	6a 61                	push   $0x61
  801617:	68 53 3d 80 00       	push   $0x803d53
  80161c:	e8 7c ed ff ff       	call   80039d <_panic>

00801621 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 18             	sub    $0x18,%esp
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162d:	e8 a9 fd ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  801632:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801636:	75 07                	jne    80163f <smalloc+0x1e>
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	eb 14                	jmp    801653 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80163f:	83 ec 04             	sub    $0x4,%esp
  801642:	68 d0 3d 80 00       	push   $0x803dd0
  801647:	6a 76                	push   $0x76
  801649:	68 53 3d 80 00       	push   $0x803d53
  80164e:	e8 4a ed ff ff       	call   80039d <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165b:	e8 7b fd ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801660:	83 ec 04             	sub    $0x4,%esp
  801663:	68 f8 3d 80 00       	push   $0x803df8
  801668:	68 93 00 00 00       	push   $0x93
  80166d:	68 53 3d 80 00       	push   $0x803d53
  801672:	e8 26 ed ff ff       	call   80039d <_panic>

00801677 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80167d:	e8 59 fd ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801682:	83 ec 04             	sub    $0x4,%esp
  801685:	68 1c 3e 80 00       	push   $0x803e1c
  80168a:	68 c5 00 00 00       	push   $0xc5
  80168f:	68 53 3d 80 00       	push   $0x803d53
  801694:	e8 04 ed ff ff       	call   80039d <_panic>

00801699 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80169f:	83 ec 04             	sub    $0x4,%esp
  8016a2:	68 44 3e 80 00       	push   $0x803e44
  8016a7:	68 d9 00 00 00       	push   $0xd9
  8016ac:	68 53 3d 80 00       	push   $0x803d53
  8016b1:	e8 e7 ec ff ff       	call   80039d <_panic>

008016b6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016bc:	83 ec 04             	sub    $0x4,%esp
  8016bf:	68 68 3e 80 00       	push   $0x803e68
  8016c4:	68 e4 00 00 00       	push   $0xe4
  8016c9:	68 53 3d 80 00       	push   $0x803d53
  8016ce:	e8 ca ec ff ff       	call   80039d <_panic>

008016d3 <shrink>:

}
void shrink(uint32 newSize)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d9:	83 ec 04             	sub    $0x4,%esp
  8016dc:	68 68 3e 80 00       	push   $0x803e68
  8016e1:	68 e9 00 00 00       	push   $0xe9
  8016e6:	68 53 3d 80 00       	push   $0x803d53
  8016eb:	e8 ad ec ff ff       	call   80039d <_panic>

008016f0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f6:	83 ec 04             	sub    $0x4,%esp
  8016f9:	68 68 3e 80 00       	push   $0x803e68
  8016fe:	68 ee 00 00 00       	push   $0xee
  801703:	68 53 3d 80 00       	push   $0x803d53
  801708:	e8 90 ec ff ff       	call   80039d <_panic>

0080170d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	57                   	push   %edi
  801711:	56                   	push   %esi
  801712:	53                   	push   %ebx
  801713:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801722:	8b 7d 18             	mov    0x18(%ebp),%edi
  801725:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801728:	cd 30                	int    $0x30
  80172a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80172d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	5b                   	pop    %ebx
  801734:	5e                   	pop    %esi
  801735:	5f                   	pop    %edi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 04             	sub    $0x4,%esp
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801744:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	52                   	push   %edx
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	50                   	push   %eax
  801754:	6a 00                	push   $0x0
  801756:	e8 b2 ff ff ff       	call   80170d <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	90                   	nop
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_cgetc>:

int
sys_cgetc(void)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 01                	push   $0x1
  801770:	e8 98 ff ff ff       	call   80170d <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80177d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801780:	8b 45 08             	mov    0x8(%ebp),%eax
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	52                   	push   %edx
  80178a:	50                   	push   %eax
  80178b:	6a 05                	push   $0x5
  80178d:	e8 7b ff ff ff       	call   80170d <syscall>
  801792:	83 c4 18             	add    $0x18,%esp
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	56                   	push   %esi
  80179b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80179c:	8b 75 18             	mov    0x18(%ebp),%esi
  80179f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ab:	56                   	push   %esi
  8017ac:	53                   	push   %ebx
  8017ad:	51                   	push   %ecx
  8017ae:	52                   	push   %edx
  8017af:	50                   	push   %eax
  8017b0:	6a 06                	push   $0x6
  8017b2:	e8 56 ff ff ff       	call   80170d <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017bd:	5b                   	pop    %ebx
  8017be:	5e                   	pop    %esi
  8017bf:	5d                   	pop    %ebp
  8017c0:	c3                   	ret    

008017c1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	52                   	push   %edx
  8017d1:	50                   	push   %eax
  8017d2:	6a 07                	push   $0x7
  8017d4:	e8 34 ff ff ff       	call   80170d <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	6a 08                	push   $0x8
  8017ef:	e8 19 ff ff ff       	call   80170d <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 09                	push   $0x9
  801808:	e8 00 ff ff ff       	call   80170d <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 0a                	push   $0xa
  801821:	e8 e7 fe ff ff       	call   80170d <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 0b                	push   $0xb
  80183a:	e8 ce fe ff ff       	call   80170d <syscall>
  80183f:	83 c4 18             	add    $0x18,%esp
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	ff 75 08             	pushl  0x8(%ebp)
  801853:	6a 0f                	push   $0xf
  801855:	e8 b3 fe ff ff       	call   80170d <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
	return;
  80185d:	90                   	nop
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	ff 75 0c             	pushl  0xc(%ebp)
  80186c:	ff 75 08             	pushl  0x8(%ebp)
  80186f:	6a 10                	push   $0x10
  801871:	e8 97 fe ff ff       	call   80170d <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
	return ;
  801879:	90                   	nop
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	ff 75 10             	pushl  0x10(%ebp)
  801886:	ff 75 0c             	pushl  0xc(%ebp)
  801889:	ff 75 08             	pushl  0x8(%ebp)
  80188c:	6a 11                	push   $0x11
  80188e:	e8 7a fe ff ff       	call   80170d <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
	return ;
  801896:	90                   	nop
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 0c                	push   $0xc
  8018a8:	e8 60 fe ff ff       	call   80170d <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	6a 0d                	push   $0xd
  8018c2:	e8 46 fe ff ff       	call   80170d <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    

008018cc <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 0e                	push   $0xe
  8018db:	e8 2d fe ff ff       	call   80170d <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	90                   	nop
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 13                	push   $0x13
  8018f5:	e8 13 fe ff ff       	call   80170d <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 14                	push   $0x14
  80190f:	e8 f9 fd ff ff       	call   80170d <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_cputc>:


void
sys_cputc(const char c)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801926:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	50                   	push   %eax
  801933:	6a 15                	push   $0x15
  801935:	e8 d3 fd ff ff       	call   80170d <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	90                   	nop
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 16                	push   $0x16
  80194f:	e8 b9 fd ff ff       	call   80170d <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	90                   	nop
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	ff 75 0c             	pushl  0xc(%ebp)
  801969:	50                   	push   %eax
  80196a:	6a 17                	push   $0x17
  80196c:	e8 9c fd ff ff       	call   80170d <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 1a                	push   $0x1a
  801989:	e8 7f fd ff ff       	call   80170d <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801996:	8b 55 0c             	mov    0xc(%ebp),%edx
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	52                   	push   %edx
  8019a3:	50                   	push   %eax
  8019a4:	6a 18                	push   $0x18
  8019a6:	e8 62 fd ff ff       	call   80170d <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	52                   	push   %edx
  8019c1:	50                   	push   %eax
  8019c2:	6a 19                	push   $0x19
  8019c4:	e8 44 fd ff ff       	call   80170d <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
}
  8019cc:	90                   	nop
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	83 ec 04             	sub    $0x4,%esp
  8019d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019db:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019de:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	6a 00                	push   $0x0
  8019e7:	51                   	push   %ecx
  8019e8:	52                   	push   %edx
  8019e9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ec:	50                   	push   %eax
  8019ed:	6a 1b                	push   $0x1b
  8019ef:	e8 19 fd ff ff       	call   80170d <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	52                   	push   %edx
  801a09:	50                   	push   %eax
  801a0a:	6a 1c                	push   $0x1c
  801a0c:	e8 fc fc ff ff       	call   80170d <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a19:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	51                   	push   %ecx
  801a27:	52                   	push   %edx
  801a28:	50                   	push   %eax
  801a29:	6a 1d                	push   $0x1d
  801a2b:	e8 dd fc ff ff       	call   80170d <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	52                   	push   %edx
  801a45:	50                   	push   %eax
  801a46:	6a 1e                	push   $0x1e
  801a48:	e8 c0 fc ff ff       	call   80170d <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 1f                	push   $0x1f
  801a61:	e8 a7 fc ff ff       	call   80170d <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	c9                   	leave  
  801a6a:	c3                   	ret    

00801a6b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	ff 75 14             	pushl  0x14(%ebp)
  801a76:	ff 75 10             	pushl  0x10(%ebp)
  801a79:	ff 75 0c             	pushl  0xc(%ebp)
  801a7c:	50                   	push   %eax
  801a7d:	6a 20                	push   $0x20
  801a7f:	e8 89 fc ff ff       	call   80170d <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	50                   	push   %eax
  801a98:	6a 21                	push   $0x21
  801a9a:	e8 6e fc ff ff       	call   80170d <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	50                   	push   %eax
  801ab4:	6a 22                	push   $0x22
  801ab6:	e8 52 fc ff ff       	call   80170d <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 02                	push   $0x2
  801acf:	e8 39 fc ff ff       	call   80170d <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 03                	push   $0x3
  801ae8:	e8 20 fc ff ff       	call   80170d <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 04                	push   $0x4
  801b01:	e8 07 fc ff ff       	call   80170d <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_exit_env>:


void sys_exit_env(void)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 23                	push   $0x23
  801b1a:	e8 ee fb ff ff       	call   80170d <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	90                   	nop
  801b23:	c9                   	leave  
  801b24:	c3                   	ret    

00801b25 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b2b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b2e:	8d 50 04             	lea    0x4(%eax),%edx
  801b31:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	52                   	push   %edx
  801b3b:	50                   	push   %eax
  801b3c:	6a 24                	push   $0x24
  801b3e:	e8 ca fb ff ff       	call   80170d <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return result;
  801b46:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4f:	89 01                	mov    %eax,(%ecx)
  801b51:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	c9                   	leave  
  801b58:	c2 04 00             	ret    $0x4

00801b5b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	ff 75 10             	pushl  0x10(%ebp)
  801b65:	ff 75 0c             	pushl  0xc(%ebp)
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	6a 12                	push   $0x12
  801b6d:	e8 9b fb ff ff       	call   80170d <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 25                	push   $0x25
  801b87:	e8 81 fb ff ff       	call   80170d <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b9d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	50                   	push   %eax
  801baa:	6a 26                	push   $0x26
  801bac:	e8 5c fb ff ff       	call   80170d <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb4:	90                   	nop
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <rsttst>:
void rsttst()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 28                	push   $0x28
  801bc6:	e8 42 fb ff ff       	call   80170d <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bce:	90                   	nop
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 04             	sub    $0x4,%esp
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bdd:	8b 55 18             	mov    0x18(%ebp),%edx
  801be0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be4:	52                   	push   %edx
  801be5:	50                   	push   %eax
  801be6:	ff 75 10             	pushl  0x10(%ebp)
  801be9:	ff 75 0c             	pushl  0xc(%ebp)
  801bec:	ff 75 08             	pushl  0x8(%ebp)
  801bef:	6a 27                	push   $0x27
  801bf1:	e8 17 fb ff ff       	call   80170d <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf9:	90                   	nop
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <chktst>:
void chktst(uint32 n)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	ff 75 08             	pushl  0x8(%ebp)
  801c0a:	6a 29                	push   $0x29
  801c0c:	e8 fc fa ff ff       	call   80170d <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
	return ;
  801c14:	90                   	nop
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <inctst>:

void inctst()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 2a                	push   $0x2a
  801c26:	e8 e2 fa ff ff       	call   80170d <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2e:	90                   	nop
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <gettst>:
uint32 gettst()
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 2b                	push   $0x2b
  801c40:	e8 c8 fa ff ff       	call   80170d <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 2c                	push   $0x2c
  801c5c:	e8 ac fa ff ff       	call   80170d <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
  801c64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c67:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c6b:	75 07                	jne    801c74 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c72:	eb 05                	jmp    801c79 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 2c                	push   $0x2c
  801c8d:	e8 7b fa ff ff       	call   80170d <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
  801c95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c98:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c9c:	75 07                	jne    801ca5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca3:	eb 05                	jmp    801caa <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ca5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 2c                	push   $0x2c
  801cbe:	e8 4a fa ff ff       	call   80170d <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
  801cc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cc9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ccd:	75 07                	jne    801cd6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ccf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd4:	eb 05                	jmp    801cdb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 2c                	push   $0x2c
  801cef:	e8 19 fa ff ff       	call   80170d <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
  801cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cfa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cfe:	75 07                	jne    801d07 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d00:	b8 01 00 00 00       	mov    $0x1,%eax
  801d05:	eb 05                	jmp    801d0c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	ff 75 08             	pushl  0x8(%ebp)
  801d1c:	6a 2d                	push   $0x2d
  801d1e:	e8 ea f9 ff ff       	call   80170d <syscall>
  801d23:	83 c4 18             	add    $0x18,%esp
	return ;
  801d26:	90                   	nop
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d30:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	6a 00                	push   $0x0
  801d3b:	53                   	push   %ebx
  801d3c:	51                   	push   %ecx
  801d3d:	52                   	push   %edx
  801d3e:	50                   	push   %eax
  801d3f:	6a 2e                	push   $0x2e
  801d41:	e8 c7 f9 ff ff       	call   80170d <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	52                   	push   %edx
  801d5e:	50                   	push   %eax
  801d5f:	6a 2f                	push   $0x2f
  801d61:	e8 a7 f9 ff ff       	call   80170d <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d71:	83 ec 0c             	sub    $0xc,%esp
  801d74:	68 78 3e 80 00       	push   $0x803e78
  801d79:	e8 d3 e8 ff ff       	call   800651 <cprintf>
  801d7e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d81:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d88:	83 ec 0c             	sub    $0xc,%esp
  801d8b:	68 a4 3e 80 00       	push   $0x803ea4
  801d90:	e8 bc e8 ff ff       	call   800651 <cprintf>
  801d95:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d98:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d9c:	a1 38 51 80 00       	mov    0x805138,%eax
  801da1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da4:	eb 56                	jmp    801dfc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801da6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801daa:	74 1c                	je     801dc8 <print_mem_block_lists+0x5d>
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	8b 50 08             	mov    0x8(%eax),%edx
  801db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db5:	8b 48 08             	mov    0x8(%eax),%ecx
  801db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbb:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbe:	01 c8                	add    %ecx,%eax
  801dc0:	39 c2                	cmp    %eax,%edx
  801dc2:	73 04                	jae    801dc8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dc4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	8b 50 08             	mov    0x8(%eax),%edx
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd4:	01 c2                	add    %eax,%edx
  801dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd9:	8b 40 08             	mov    0x8(%eax),%eax
  801ddc:	83 ec 04             	sub    $0x4,%esp
  801ddf:	52                   	push   %edx
  801de0:	50                   	push   %eax
  801de1:	68 b9 3e 80 00       	push   $0x803eb9
  801de6:	e8 66 e8 ff ff       	call   800651 <cprintf>
  801deb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df4:	a1 40 51 80 00       	mov    0x805140,%eax
  801df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e00:	74 07                	je     801e09 <print_mem_block_lists+0x9e>
  801e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e05:	8b 00                	mov    (%eax),%eax
  801e07:	eb 05                	jmp    801e0e <print_mem_block_lists+0xa3>
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0e:	a3 40 51 80 00       	mov    %eax,0x805140
  801e13:	a1 40 51 80 00       	mov    0x805140,%eax
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	75 8a                	jne    801da6 <print_mem_block_lists+0x3b>
  801e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e20:	75 84                	jne    801da6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e22:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e26:	75 10                	jne    801e38 <print_mem_block_lists+0xcd>
  801e28:	83 ec 0c             	sub    $0xc,%esp
  801e2b:	68 c8 3e 80 00       	push   $0x803ec8
  801e30:	e8 1c e8 ff ff       	call   800651 <cprintf>
  801e35:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	68 ec 3e 80 00       	push   $0x803eec
  801e47:	e8 05 e8 ff ff       	call   800651 <cprintf>
  801e4c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e4f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e53:	a1 40 50 80 00       	mov    0x805040,%eax
  801e58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5b:	eb 56                	jmp    801eb3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e61:	74 1c                	je     801e7f <print_mem_block_lists+0x114>
  801e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e66:	8b 50 08             	mov    0x8(%eax),%edx
  801e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e72:	8b 40 0c             	mov    0xc(%eax),%eax
  801e75:	01 c8                	add    %ecx,%eax
  801e77:	39 c2                	cmp    %eax,%edx
  801e79:	73 04                	jae    801e7f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e7b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e82:	8b 50 08             	mov    0x8(%eax),%edx
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8b:	01 c2                	add    %eax,%edx
  801e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e90:	8b 40 08             	mov    0x8(%eax),%eax
  801e93:	83 ec 04             	sub    $0x4,%esp
  801e96:	52                   	push   %edx
  801e97:	50                   	push   %eax
  801e98:	68 b9 3e 80 00       	push   $0x803eb9
  801e9d:	e8 af e7 ff ff       	call   800651 <cprintf>
  801ea2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eab:	a1 48 50 80 00       	mov    0x805048,%eax
  801eb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb7:	74 07                	je     801ec0 <print_mem_block_lists+0x155>
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	8b 00                	mov    (%eax),%eax
  801ebe:	eb 05                	jmp    801ec5 <print_mem_block_lists+0x15a>
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec5:	a3 48 50 80 00       	mov    %eax,0x805048
  801eca:	a1 48 50 80 00       	mov    0x805048,%eax
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	75 8a                	jne    801e5d <print_mem_block_lists+0xf2>
  801ed3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed7:	75 84                	jne    801e5d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ed9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801edd:	75 10                	jne    801eef <print_mem_block_lists+0x184>
  801edf:	83 ec 0c             	sub    $0xc,%esp
  801ee2:	68 04 3f 80 00       	push   $0x803f04
  801ee7:	e8 65 e7 ff ff       	call   800651 <cprintf>
  801eec:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801eef:	83 ec 0c             	sub    $0xc,%esp
  801ef2:	68 78 3e 80 00       	push   $0x803e78
  801ef7:	e8 55 e7 ff ff       	call   800651 <cprintf>
  801efc:	83 c4 10             	add    $0x10,%esp

}
  801eff:	90                   	nop
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f08:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f0f:	00 00 00 
  801f12:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f19:	00 00 00 
  801f1c:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f23:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f2d:	e9 9e 00 00 00       	jmp    801fd0 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f32:	a1 50 50 80 00       	mov    0x805050,%eax
  801f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3a:	c1 e2 04             	shl    $0x4,%edx
  801f3d:	01 d0                	add    %edx,%eax
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	75 14                	jne    801f57 <initialize_MemBlocksList+0x55>
  801f43:	83 ec 04             	sub    $0x4,%esp
  801f46:	68 2c 3f 80 00       	push   $0x803f2c
  801f4b:	6a 46                	push   $0x46
  801f4d:	68 4f 3f 80 00       	push   $0x803f4f
  801f52:	e8 46 e4 ff ff       	call   80039d <_panic>
  801f57:	a1 50 50 80 00       	mov    0x805050,%eax
  801f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5f:	c1 e2 04             	shl    $0x4,%edx
  801f62:	01 d0                	add    %edx,%eax
  801f64:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f6a:	89 10                	mov    %edx,(%eax)
  801f6c:	8b 00                	mov    (%eax),%eax
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	74 18                	je     801f8a <initialize_MemBlocksList+0x88>
  801f72:	a1 48 51 80 00       	mov    0x805148,%eax
  801f77:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f7d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f80:	c1 e1 04             	shl    $0x4,%ecx
  801f83:	01 ca                	add    %ecx,%edx
  801f85:	89 50 04             	mov    %edx,0x4(%eax)
  801f88:	eb 12                	jmp    801f9c <initialize_MemBlocksList+0x9a>
  801f8a:	a1 50 50 80 00       	mov    0x805050,%eax
  801f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f92:	c1 e2 04             	shl    $0x4,%edx
  801f95:	01 d0                	add    %edx,%eax
  801f97:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f9c:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa4:	c1 e2 04             	shl    $0x4,%edx
  801fa7:	01 d0                	add    %edx,%eax
  801fa9:	a3 48 51 80 00       	mov    %eax,0x805148
  801fae:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb6:	c1 e2 04             	shl    $0x4,%edx
  801fb9:	01 d0                	add    %edx,%eax
  801fbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc2:	a1 54 51 80 00       	mov    0x805154,%eax
  801fc7:	40                   	inc    %eax
  801fc8:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fcd:	ff 45 f4             	incl   -0xc(%ebp)
  801fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fd6:	0f 82 56 ff ff ff    	jb     801f32 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fdc:	90                   	nop
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8b 00                	mov    (%eax),%eax
  801fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fed:	eb 19                	jmp    802008 <find_block+0x29>
	{
		if(va==point->sva)
  801fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff2:	8b 40 08             	mov    0x8(%eax),%eax
  801ff5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ff8:	75 05                	jne    801fff <find_block+0x20>
		   return point;
  801ffa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffd:	eb 36                	jmp    802035 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	8b 40 08             	mov    0x8(%eax),%eax
  802005:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802008:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80200c:	74 07                	je     802015 <find_block+0x36>
  80200e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802011:	8b 00                	mov    (%eax),%eax
  802013:	eb 05                	jmp    80201a <find_block+0x3b>
  802015:	b8 00 00 00 00       	mov    $0x0,%eax
  80201a:	8b 55 08             	mov    0x8(%ebp),%edx
  80201d:	89 42 08             	mov    %eax,0x8(%edx)
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	8b 40 08             	mov    0x8(%eax),%eax
  802026:	85 c0                	test   %eax,%eax
  802028:	75 c5                	jne    801fef <find_block+0x10>
  80202a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80202e:	75 bf                	jne    801fef <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80203d:	a1 40 50 80 00       	mov    0x805040,%eax
  802042:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802045:	a1 44 50 80 00       	mov    0x805044,%eax
  80204a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802050:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802053:	74 24                	je     802079 <insert_sorted_allocList+0x42>
  802055:	8b 45 08             	mov    0x8(%ebp),%eax
  802058:	8b 50 08             	mov    0x8(%eax),%edx
  80205b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205e:	8b 40 08             	mov    0x8(%eax),%eax
  802061:	39 c2                	cmp    %eax,%edx
  802063:	76 14                	jbe    802079 <insert_sorted_allocList+0x42>
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8b 50 08             	mov    0x8(%eax),%edx
  80206b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80206e:	8b 40 08             	mov    0x8(%eax),%eax
  802071:	39 c2                	cmp    %eax,%edx
  802073:	0f 82 60 01 00 00    	jb     8021d9 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802079:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80207d:	75 65                	jne    8020e4 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80207f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802083:	75 14                	jne    802099 <insert_sorted_allocList+0x62>
  802085:	83 ec 04             	sub    $0x4,%esp
  802088:	68 2c 3f 80 00       	push   $0x803f2c
  80208d:	6a 6b                	push   $0x6b
  80208f:	68 4f 3f 80 00       	push   $0x803f4f
  802094:	e8 04 e3 ff ff       	call   80039d <_panic>
  802099:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	89 10                	mov    %edx,(%eax)
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	8b 00                	mov    (%eax),%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 0d                	je     8020ba <insert_sorted_allocList+0x83>
  8020ad:	a1 40 50 80 00       	mov    0x805040,%eax
  8020b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020b5:	89 50 04             	mov    %edx,0x4(%eax)
  8020b8:	eb 08                	jmp    8020c2 <insert_sorted_allocList+0x8b>
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	a3 44 50 80 00       	mov    %eax,0x805044
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	a3 40 50 80 00       	mov    %eax,0x805040
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020d9:	40                   	inc    %eax
  8020da:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020df:	e9 dc 01 00 00       	jmp    8022c0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	8b 50 08             	mov    0x8(%eax),%edx
  8020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ed:	8b 40 08             	mov    0x8(%eax),%eax
  8020f0:	39 c2                	cmp    %eax,%edx
  8020f2:	77 6c                	ja     802160 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f8:	74 06                	je     802100 <insert_sorted_allocList+0xc9>
  8020fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020fe:	75 14                	jne    802114 <insert_sorted_allocList+0xdd>
  802100:	83 ec 04             	sub    $0x4,%esp
  802103:	68 68 3f 80 00       	push   $0x803f68
  802108:	6a 6f                	push   $0x6f
  80210a:	68 4f 3f 80 00       	push   $0x803f4f
  80210f:	e8 89 e2 ff ff       	call   80039d <_panic>
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	8b 50 04             	mov    0x4(%eax),%edx
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	89 50 04             	mov    %edx,0x4(%eax)
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802126:	89 10                	mov    %edx,(%eax)
  802128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212b:	8b 40 04             	mov    0x4(%eax),%eax
  80212e:	85 c0                	test   %eax,%eax
  802130:	74 0d                	je     80213f <insert_sorted_allocList+0x108>
  802132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802135:	8b 40 04             	mov    0x4(%eax),%eax
  802138:	8b 55 08             	mov    0x8(%ebp),%edx
  80213b:	89 10                	mov    %edx,(%eax)
  80213d:	eb 08                	jmp    802147 <insert_sorted_allocList+0x110>
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	a3 40 50 80 00       	mov    %eax,0x805040
  802147:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214a:	8b 55 08             	mov    0x8(%ebp),%edx
  80214d:	89 50 04             	mov    %edx,0x4(%eax)
  802150:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802155:	40                   	inc    %eax
  802156:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80215b:	e9 60 01 00 00       	jmp    8022c0 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	8b 50 08             	mov    0x8(%eax),%edx
  802166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802169:	8b 40 08             	mov    0x8(%eax),%eax
  80216c:	39 c2                	cmp    %eax,%edx
  80216e:	0f 82 4c 01 00 00    	jb     8022c0 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802174:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802178:	75 14                	jne    80218e <insert_sorted_allocList+0x157>
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	68 a0 3f 80 00       	push   $0x803fa0
  802182:	6a 73                	push   $0x73
  802184:	68 4f 3f 80 00       	push   $0x803f4f
  802189:	e8 0f e2 ff ff       	call   80039d <_panic>
  80218e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	89 50 04             	mov    %edx,0x4(%eax)
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8b 40 04             	mov    0x4(%eax),%eax
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	74 0c                	je     8021b0 <insert_sorted_allocList+0x179>
  8021a4:	a1 44 50 80 00       	mov    0x805044,%eax
  8021a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ac:	89 10                	mov    %edx,(%eax)
  8021ae:	eb 08                	jmp    8021b8 <insert_sorted_allocList+0x181>
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	a3 40 50 80 00       	mov    %eax,0x805040
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	a3 44 50 80 00       	mov    %eax,0x805044
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021c9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021ce:	40                   	inc    %eax
  8021cf:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021d4:	e9 e7 00 00 00       	jmp    8022c0 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021e6:	a1 40 50 80 00       	mov    0x805040,%eax
  8021eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ee:	e9 9d 00 00 00       	jmp    802290 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f6:	8b 00                	mov    (%eax),%eax
  8021f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	8b 50 08             	mov    0x8(%eax),%edx
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	8b 40 08             	mov    0x8(%eax),%eax
  802207:	39 c2                	cmp    %eax,%edx
  802209:	76 7d                	jbe    802288 <insert_sorted_allocList+0x251>
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	8b 50 08             	mov    0x8(%eax),%edx
  802211:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802214:	8b 40 08             	mov    0x8(%eax),%eax
  802217:	39 c2                	cmp    %eax,%edx
  802219:	73 6d                	jae    802288 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80221b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221f:	74 06                	je     802227 <insert_sorted_allocList+0x1f0>
  802221:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802225:	75 14                	jne    80223b <insert_sorted_allocList+0x204>
  802227:	83 ec 04             	sub    $0x4,%esp
  80222a:	68 c4 3f 80 00       	push   $0x803fc4
  80222f:	6a 7f                	push   $0x7f
  802231:	68 4f 3f 80 00       	push   $0x803f4f
  802236:	e8 62 e1 ff ff       	call   80039d <_panic>
  80223b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223e:	8b 10                	mov    (%eax),%edx
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	89 10                	mov    %edx,(%eax)
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 00                	mov    (%eax),%eax
  80224a:	85 c0                	test   %eax,%eax
  80224c:	74 0b                	je     802259 <insert_sorted_allocList+0x222>
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	8b 00                	mov    (%eax),%eax
  802253:	8b 55 08             	mov    0x8(%ebp),%edx
  802256:	89 50 04             	mov    %edx,0x4(%eax)
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	8b 55 08             	mov    0x8(%ebp),%edx
  80225f:	89 10                	mov    %edx,(%eax)
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802267:	89 50 04             	mov    %edx,0x4(%eax)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	85 c0                	test   %eax,%eax
  802271:	75 08                	jne    80227b <insert_sorted_allocList+0x244>
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	a3 44 50 80 00       	mov    %eax,0x805044
  80227b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802280:	40                   	inc    %eax
  802281:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802286:	eb 39                	jmp    8022c1 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802288:	a1 48 50 80 00       	mov    0x805048,%eax
  80228d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802294:	74 07                	je     80229d <insert_sorted_allocList+0x266>
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 00                	mov    (%eax),%eax
  80229b:	eb 05                	jmp    8022a2 <insert_sorted_allocList+0x26b>
  80229d:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a2:	a3 48 50 80 00       	mov    %eax,0x805048
  8022a7:	a1 48 50 80 00       	mov    0x805048,%eax
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	0f 85 3f ff ff ff    	jne    8021f3 <insert_sorted_allocList+0x1bc>
  8022b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b8:	0f 85 35 ff ff ff    	jne    8021f3 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022be:	eb 01                	jmp    8022c1 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c0:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022c1:	90                   	nop
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022ca:	a1 38 51 80 00       	mov    0x805138,%eax
  8022cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d2:	e9 85 01 00 00       	jmp    80245c <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 0c             	mov    0xc(%eax),%eax
  8022dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e0:	0f 82 6e 01 00 00    	jb     802454 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ef:	0f 85 8a 00 00 00    	jne    80237f <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f9:	75 17                	jne    802312 <alloc_block_FF+0x4e>
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 f8 3f 80 00       	push   $0x803ff8
  802303:	68 93 00 00 00       	push   $0x93
  802308:	68 4f 3f 80 00       	push   $0x803f4f
  80230d:	e8 8b e0 ff ff       	call   80039d <_panic>
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 00                	mov    (%eax),%eax
  802317:	85 c0                	test   %eax,%eax
  802319:	74 10                	je     80232b <alloc_block_FF+0x67>
  80231b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231e:	8b 00                	mov    (%eax),%eax
  802320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802323:	8b 52 04             	mov    0x4(%edx),%edx
  802326:	89 50 04             	mov    %edx,0x4(%eax)
  802329:	eb 0b                	jmp    802336 <alloc_block_FF+0x72>
  80232b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232e:	8b 40 04             	mov    0x4(%eax),%eax
  802331:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 40 04             	mov    0x4(%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 0f                	je     80234f <alloc_block_FF+0x8b>
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 40 04             	mov    0x4(%eax),%eax
  802346:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802349:	8b 12                	mov    (%edx),%edx
  80234b:	89 10                	mov    %edx,(%eax)
  80234d:	eb 0a                	jmp    802359 <alloc_block_FF+0x95>
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	a3 38 51 80 00       	mov    %eax,0x805138
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236c:	a1 44 51 80 00       	mov    0x805144,%eax
  802371:	48                   	dec    %eax
  802372:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	e9 10 01 00 00       	jmp    80248f <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 40 0c             	mov    0xc(%eax),%eax
  802385:	3b 45 08             	cmp    0x8(%ebp),%eax
  802388:	0f 86 c6 00 00 00    	jbe    802454 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80238e:	a1 48 51 80 00       	mov    0x805148,%eax
  802393:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 50 08             	mov    0x8(%eax),%edx
  80239c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239f:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a8:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023af:	75 17                	jne    8023c8 <alloc_block_FF+0x104>
  8023b1:	83 ec 04             	sub    $0x4,%esp
  8023b4:	68 f8 3f 80 00       	push   $0x803ff8
  8023b9:	68 9b 00 00 00       	push   $0x9b
  8023be:	68 4f 3f 80 00       	push   $0x803f4f
  8023c3:	e8 d5 df ff ff       	call   80039d <_panic>
  8023c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cb:	8b 00                	mov    (%eax),%eax
  8023cd:	85 c0                	test   %eax,%eax
  8023cf:	74 10                	je     8023e1 <alloc_block_FF+0x11d>
  8023d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023d9:	8b 52 04             	mov    0x4(%edx),%edx
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
  8023df:	eb 0b                	jmp    8023ec <alloc_block_FF+0x128>
  8023e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e4:	8b 40 04             	mov    0x4(%eax),%eax
  8023e7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ef:	8b 40 04             	mov    0x4(%eax),%eax
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	74 0f                	je     802405 <alloc_block_FF+0x141>
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	8b 40 04             	mov    0x4(%eax),%eax
  8023fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023ff:	8b 12                	mov    (%edx),%edx
  802401:	89 10                	mov    %edx,(%eax)
  802403:	eb 0a                	jmp    80240f <alloc_block_FF+0x14b>
  802405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802408:	8b 00                	mov    (%eax),%eax
  80240a:	a3 48 51 80 00       	mov    %eax,0x805148
  80240f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802412:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802422:	a1 54 51 80 00       	mov    0x805154,%eax
  802427:	48                   	dec    %eax
  802428:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 50 08             	mov    0x8(%eax),%edx
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	01 c2                	add    %eax,%edx
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 0c             	mov    0xc(%eax),%eax
  802444:	2b 45 08             	sub    0x8(%ebp),%eax
  802447:	89 c2                	mov    %eax,%edx
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	eb 3b                	jmp    80248f <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802454:	a1 40 51 80 00       	mov    0x805140,%eax
  802459:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802460:	74 07                	je     802469 <alloc_block_FF+0x1a5>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 00                	mov    (%eax),%eax
  802467:	eb 05                	jmp    80246e <alloc_block_FF+0x1aa>
  802469:	b8 00 00 00 00       	mov    $0x0,%eax
  80246e:	a3 40 51 80 00       	mov    %eax,0x805140
  802473:	a1 40 51 80 00       	mov    0x805140,%eax
  802478:	85 c0                	test   %eax,%eax
  80247a:	0f 85 57 fe ff ff    	jne    8022d7 <alloc_block_FF+0x13>
  802480:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802484:	0f 85 4d fe ff ff    	jne    8022d7 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802497:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80249e:	a1 38 51 80 00       	mov    0x805138,%eax
  8024a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a6:	e9 df 00 00 00       	jmp    80258a <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b4:	0f 82 c8 00 00 00    	jb     802582 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c3:	0f 85 8a 00 00 00    	jne    802553 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cd:	75 17                	jne    8024e6 <alloc_block_BF+0x55>
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	68 f8 3f 80 00       	push   $0x803ff8
  8024d7:	68 b7 00 00 00       	push   $0xb7
  8024dc:	68 4f 3f 80 00       	push   $0x803f4f
  8024e1:	e8 b7 de ff ff       	call   80039d <_panic>
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 10                	je     8024ff <alloc_block_BF+0x6e>
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 00                	mov    (%eax),%eax
  8024f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f7:	8b 52 04             	mov    0x4(%edx),%edx
  8024fa:	89 50 04             	mov    %edx,0x4(%eax)
  8024fd:	eb 0b                	jmp    80250a <alloc_block_BF+0x79>
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	8b 40 04             	mov    0x4(%eax),%eax
  802505:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	85 c0                	test   %eax,%eax
  802512:	74 0f                	je     802523 <alloc_block_BF+0x92>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 40 04             	mov    0x4(%eax),%eax
  80251a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251d:	8b 12                	mov    (%edx),%edx
  80251f:	89 10                	mov    %edx,(%eax)
  802521:	eb 0a                	jmp    80252d <alloc_block_BF+0x9c>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	a3 38 51 80 00       	mov    %eax,0x805138
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802540:	a1 44 51 80 00       	mov    0x805144,%eax
  802545:	48                   	dec    %eax
  802546:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	e9 4d 01 00 00       	jmp    8026a0 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 40 0c             	mov    0xc(%eax),%eax
  802559:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255c:	76 24                	jbe    802582 <alloc_block_BF+0xf1>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 40 0c             	mov    0xc(%eax),%eax
  802564:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802567:	73 19                	jae    802582 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802569:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 40 0c             	mov    0xc(%eax),%eax
  802576:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 08             	mov    0x8(%eax),%eax
  80257f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802582:	a1 40 51 80 00       	mov    0x805140,%eax
  802587:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80258e:	74 07                	je     802597 <alloc_block_BF+0x106>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	eb 05                	jmp    80259c <alloc_block_BF+0x10b>
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	a3 40 51 80 00       	mov    %eax,0x805140
  8025a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	0f 85 fd fe ff ff    	jne    8024ab <alloc_block_BF+0x1a>
  8025ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b2:	0f 85 f3 fe ff ff    	jne    8024ab <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025bc:	0f 84 d9 00 00 00    	je     80269b <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8025c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d0:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8025d9:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025e0:	75 17                	jne    8025f9 <alloc_block_BF+0x168>
  8025e2:	83 ec 04             	sub    $0x4,%esp
  8025e5:	68 f8 3f 80 00       	push   $0x803ff8
  8025ea:	68 c7 00 00 00       	push   $0xc7
  8025ef:	68 4f 3f 80 00       	push   $0x803f4f
  8025f4:	e8 a4 dd ff ff       	call   80039d <_panic>
  8025f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fc:	8b 00                	mov    (%eax),%eax
  8025fe:	85 c0                	test   %eax,%eax
  802600:	74 10                	je     802612 <alloc_block_BF+0x181>
  802602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260a:	8b 52 04             	mov    0x4(%edx),%edx
  80260d:	89 50 04             	mov    %edx,0x4(%eax)
  802610:	eb 0b                	jmp    80261d <alloc_block_BF+0x18c>
  802612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802615:	8b 40 04             	mov    0x4(%eax),%eax
  802618:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80261d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802620:	8b 40 04             	mov    0x4(%eax),%eax
  802623:	85 c0                	test   %eax,%eax
  802625:	74 0f                	je     802636 <alloc_block_BF+0x1a5>
  802627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262a:	8b 40 04             	mov    0x4(%eax),%eax
  80262d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802630:	8b 12                	mov    (%edx),%edx
  802632:	89 10                	mov    %edx,(%eax)
  802634:	eb 0a                	jmp    802640 <alloc_block_BF+0x1af>
  802636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	a3 48 51 80 00       	mov    %eax,0x805148
  802640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802643:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802653:	a1 54 51 80 00       	mov    0x805154,%eax
  802658:	48                   	dec    %eax
  802659:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80265e:	83 ec 08             	sub    $0x8,%esp
  802661:	ff 75 ec             	pushl  -0x14(%ebp)
  802664:	68 38 51 80 00       	push   $0x805138
  802669:	e8 71 f9 ff ff       	call   801fdf <find_block>
  80266e:	83 c4 10             	add    $0x10,%esp
  802671:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802674:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802677:	8b 50 08             	mov    0x8(%eax),%edx
  80267a:	8b 45 08             	mov    0x8(%ebp),%eax
  80267d:	01 c2                	add    %eax,%edx
  80267f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802682:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802688:	8b 40 0c             	mov    0xc(%eax),%eax
  80268b:	2b 45 08             	sub    0x8(%ebp),%eax
  80268e:	89 c2                	mov    %eax,%edx
  802690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802693:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802699:	eb 05                	jmp    8026a0 <alloc_block_BF+0x20f>
	}
	return NULL;
  80269b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a0:	c9                   	leave  
  8026a1:	c3                   	ret    

008026a2 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026a8:	a1 28 50 80 00       	mov    0x805028,%eax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	0f 85 de 01 00 00    	jne    802893 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bd:	e9 9e 01 00 00       	jmp    802860 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cb:	0f 82 87 01 00 00    	jb     802858 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026da:	0f 85 95 00 00 00    	jne    802775 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e4:	75 17                	jne    8026fd <alloc_block_NF+0x5b>
  8026e6:	83 ec 04             	sub    $0x4,%esp
  8026e9:	68 f8 3f 80 00       	push   $0x803ff8
  8026ee:	68 e0 00 00 00       	push   $0xe0
  8026f3:	68 4f 3f 80 00       	push   $0x803f4f
  8026f8:	e8 a0 dc ff ff       	call   80039d <_panic>
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 00                	mov    (%eax),%eax
  802702:	85 c0                	test   %eax,%eax
  802704:	74 10                	je     802716 <alloc_block_NF+0x74>
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270e:	8b 52 04             	mov    0x4(%edx),%edx
  802711:	89 50 04             	mov    %edx,0x4(%eax)
  802714:	eb 0b                	jmp    802721 <alloc_block_NF+0x7f>
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	8b 40 04             	mov    0x4(%eax),%eax
  80271c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 04             	mov    0x4(%eax),%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	74 0f                	je     80273a <alloc_block_NF+0x98>
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 40 04             	mov    0x4(%eax),%eax
  802731:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802734:	8b 12                	mov    (%edx),%edx
  802736:	89 10                	mov    %edx,(%eax)
  802738:	eb 0a                	jmp    802744 <alloc_block_NF+0xa2>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	a3 38 51 80 00       	mov    %eax,0x805138
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802757:	a1 44 51 80 00       	mov    0x805144,%eax
  80275c:	48                   	dec    %eax
  80275d:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 40 08             	mov    0x8(%eax),%eax
  802768:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	e9 f8 04 00 00       	jmp    802c6d <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 40 0c             	mov    0xc(%eax),%eax
  80277b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277e:	0f 86 d4 00 00 00    	jbe    802858 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802784:	a1 48 51 80 00       	mov    0x805148,%eax
  802789:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 50 08             	mov    0x8(%eax),%edx
  802792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802795:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 55 08             	mov    0x8(%ebp),%edx
  80279e:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a5:	75 17                	jne    8027be <alloc_block_NF+0x11c>
  8027a7:	83 ec 04             	sub    $0x4,%esp
  8027aa:	68 f8 3f 80 00       	push   $0x803ff8
  8027af:	68 e9 00 00 00       	push   $0xe9
  8027b4:	68 4f 3f 80 00       	push   $0x803f4f
  8027b9:	e8 df db ff ff       	call   80039d <_panic>
  8027be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	85 c0                	test   %eax,%eax
  8027c5:	74 10                	je     8027d7 <alloc_block_NF+0x135>
  8027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027cf:	8b 52 04             	mov    0x4(%edx),%edx
  8027d2:	89 50 04             	mov    %edx,0x4(%eax)
  8027d5:	eb 0b                	jmp    8027e2 <alloc_block_NF+0x140>
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027da:	8b 40 04             	mov    0x4(%eax),%eax
  8027dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e5:	8b 40 04             	mov    0x4(%eax),%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	74 0f                	je     8027fb <alloc_block_NF+0x159>
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ef:	8b 40 04             	mov    0x4(%eax),%eax
  8027f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f5:	8b 12                	mov    (%edx),%edx
  8027f7:	89 10                	mov    %edx,(%eax)
  8027f9:	eb 0a                	jmp    802805 <alloc_block_NF+0x163>
  8027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fe:	8b 00                	mov    (%eax),%eax
  802800:	a3 48 51 80 00       	mov    %eax,0x805148
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802818:	a1 54 51 80 00       	mov    0x805154,%eax
  80281d:	48                   	dec    %eax
  80281e:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802826:	8b 40 08             	mov    0x8(%eax),%eax
  802829:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 50 08             	mov    0x8(%eax),%edx
  802834:	8b 45 08             	mov    0x8(%ebp),%eax
  802837:	01 c2                	add    %eax,%edx
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 40 0c             	mov    0xc(%eax),%eax
  802845:	2b 45 08             	sub    0x8(%ebp),%eax
  802848:	89 c2                	mov    %eax,%edx
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802850:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802853:	e9 15 04 00 00       	jmp    802c6d <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802858:	a1 40 51 80 00       	mov    0x805140,%eax
  80285d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802860:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802864:	74 07                	je     80286d <alloc_block_NF+0x1cb>
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	eb 05                	jmp    802872 <alloc_block_NF+0x1d0>
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax
  802872:	a3 40 51 80 00       	mov    %eax,0x805140
  802877:	a1 40 51 80 00       	mov    0x805140,%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	0f 85 3e fe ff ff    	jne    8026c2 <alloc_block_NF+0x20>
  802884:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802888:	0f 85 34 fe ff ff    	jne    8026c2 <alloc_block_NF+0x20>
  80288e:	e9 d5 03 00 00       	jmp    802c68 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802893:	a1 38 51 80 00       	mov    0x805138,%eax
  802898:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289b:	e9 b1 01 00 00       	jmp    802a51 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 50 08             	mov    0x8(%eax),%edx
  8028a6:	a1 28 50 80 00       	mov    0x805028,%eax
  8028ab:	39 c2                	cmp    %eax,%edx
  8028ad:	0f 82 96 01 00 00    	jb     802a49 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bc:	0f 82 87 01 00 00    	jb     802a49 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028cb:	0f 85 95 00 00 00    	jne    802966 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d5:	75 17                	jne    8028ee <alloc_block_NF+0x24c>
  8028d7:	83 ec 04             	sub    $0x4,%esp
  8028da:	68 f8 3f 80 00       	push   $0x803ff8
  8028df:	68 fc 00 00 00       	push   $0xfc
  8028e4:	68 4f 3f 80 00       	push   $0x803f4f
  8028e9:	e8 af da ff ff       	call   80039d <_panic>
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 00                	mov    (%eax),%eax
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	74 10                	je     802907 <alloc_block_NF+0x265>
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ff:	8b 52 04             	mov    0x4(%edx),%edx
  802902:	89 50 04             	mov    %edx,0x4(%eax)
  802905:	eb 0b                	jmp    802912 <alloc_block_NF+0x270>
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 40 04             	mov    0x4(%eax),%eax
  80290d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	85 c0                	test   %eax,%eax
  80291a:	74 0f                	je     80292b <alloc_block_NF+0x289>
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 04             	mov    0x4(%eax),%eax
  802922:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802925:	8b 12                	mov    (%edx),%edx
  802927:	89 10                	mov    %edx,(%eax)
  802929:	eb 0a                	jmp    802935 <alloc_block_NF+0x293>
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	a3 38 51 80 00       	mov    %eax,0x805138
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802948:	a1 44 51 80 00       	mov    0x805144,%eax
  80294d:	48                   	dec    %eax
  80294e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 40 08             	mov    0x8(%eax),%eax
  802959:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	e9 07 03 00 00       	jmp    802c6d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 40 0c             	mov    0xc(%eax),%eax
  80296c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80296f:	0f 86 d4 00 00 00    	jbe    802a49 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802975:	a1 48 51 80 00       	mov    0x805148,%eax
  80297a:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 50 08             	mov    0x8(%eax),%edx
  802983:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802986:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802989:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298c:	8b 55 08             	mov    0x8(%ebp),%edx
  80298f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802992:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802996:	75 17                	jne    8029af <alloc_block_NF+0x30d>
  802998:	83 ec 04             	sub    $0x4,%esp
  80299b:	68 f8 3f 80 00       	push   $0x803ff8
  8029a0:	68 04 01 00 00       	push   $0x104
  8029a5:	68 4f 3f 80 00       	push   $0x803f4f
  8029aa:	e8 ee d9 ff ff       	call   80039d <_panic>
  8029af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	74 10                	je     8029c8 <alloc_block_NF+0x326>
  8029b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c0:	8b 52 04             	mov    0x4(%edx),%edx
  8029c3:	89 50 04             	mov    %edx,0x4(%eax)
  8029c6:	eb 0b                	jmp    8029d3 <alloc_block_NF+0x331>
  8029c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d6:	8b 40 04             	mov    0x4(%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 0f                	je     8029ec <alloc_block_NF+0x34a>
  8029dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e0:	8b 40 04             	mov    0x4(%eax),%eax
  8029e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e6:	8b 12                	mov    (%edx),%edx
  8029e8:	89 10                	mov    %edx,(%eax)
  8029ea:	eb 0a                	jmp    8029f6 <alloc_block_NF+0x354>
  8029ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8029f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a09:	a1 54 51 80 00       	mov    0x805154,%eax
  802a0e:	48                   	dec    %eax
  802a0f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a17:	8b 40 08             	mov    0x8(%eax),%eax
  802a1a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 50 08             	mov    0x8(%eax),%edx
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	01 c2                	add    %eax,%edx
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 40 0c             	mov    0xc(%eax),%eax
  802a36:	2b 45 08             	sub    0x8(%ebp),%eax
  802a39:	89 c2                	mov    %eax,%edx
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a44:	e9 24 02 00 00       	jmp    802c6d <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a49:	a1 40 51 80 00       	mov    0x805140,%eax
  802a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a55:	74 07                	je     802a5e <alloc_block_NF+0x3bc>
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 00                	mov    (%eax),%eax
  802a5c:	eb 05                	jmp    802a63 <alloc_block_NF+0x3c1>
  802a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a63:	a3 40 51 80 00       	mov    %eax,0x805140
  802a68:	a1 40 51 80 00       	mov    0x805140,%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	0f 85 2b fe ff ff    	jne    8028a0 <alloc_block_NF+0x1fe>
  802a75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a79:	0f 85 21 fe ff ff    	jne    8028a0 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a7f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a87:	e9 ae 01 00 00       	jmp    802c3a <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 50 08             	mov    0x8(%eax),%edx
  802a92:	a1 28 50 80 00       	mov    0x805028,%eax
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	0f 83 93 01 00 00    	jae    802c32 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa8:	0f 82 84 01 00 00    	jb     802c32 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab7:	0f 85 95 00 00 00    	jne    802b52 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802abd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac1:	75 17                	jne    802ada <alloc_block_NF+0x438>
  802ac3:	83 ec 04             	sub    $0x4,%esp
  802ac6:	68 f8 3f 80 00       	push   $0x803ff8
  802acb:	68 14 01 00 00       	push   $0x114
  802ad0:	68 4f 3f 80 00       	push   $0x803f4f
  802ad5:	e8 c3 d8 ff ff       	call   80039d <_panic>
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 00                	mov    (%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	74 10                	je     802af3 <alloc_block_NF+0x451>
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 00                	mov    (%eax),%eax
  802ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aeb:	8b 52 04             	mov    0x4(%edx),%edx
  802aee:	89 50 04             	mov    %edx,0x4(%eax)
  802af1:	eb 0b                	jmp    802afe <alloc_block_NF+0x45c>
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	8b 40 04             	mov    0x4(%eax),%eax
  802af9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	74 0f                	je     802b17 <alloc_block_NF+0x475>
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 40 04             	mov    0x4(%eax),%eax
  802b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b11:	8b 12                	mov    (%edx),%edx
  802b13:	89 10                	mov    %edx,(%eax)
  802b15:	eb 0a                	jmp    802b21 <alloc_block_NF+0x47f>
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	a3 38 51 80 00       	mov    %eax,0x805138
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b34:	a1 44 51 80 00       	mov    0x805144,%eax
  802b39:	48                   	dec    %eax
  802b3a:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b42:	8b 40 08             	mov    0x8(%eax),%eax
  802b45:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4d:	e9 1b 01 00 00       	jmp    802c6d <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 40 0c             	mov    0xc(%eax),%eax
  802b58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b5b:	0f 86 d1 00 00 00    	jbe    802c32 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b61:	a1 48 51 80 00       	mov    0x805148,%eax
  802b66:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 50 08             	mov    0x8(%eax),%edx
  802b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b72:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7b:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b82:	75 17                	jne    802b9b <alloc_block_NF+0x4f9>
  802b84:	83 ec 04             	sub    $0x4,%esp
  802b87:	68 f8 3f 80 00       	push   $0x803ff8
  802b8c:	68 1c 01 00 00       	push   $0x11c
  802b91:	68 4f 3f 80 00       	push   $0x803f4f
  802b96:	e8 02 d8 ff ff       	call   80039d <_panic>
  802b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 10                	je     802bb4 <alloc_block_NF+0x512>
  802ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba7:	8b 00                	mov    (%eax),%eax
  802ba9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bac:	8b 52 04             	mov    0x4(%edx),%edx
  802baf:	89 50 04             	mov    %edx,0x4(%eax)
  802bb2:	eb 0b                	jmp    802bbf <alloc_block_NF+0x51d>
  802bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb7:	8b 40 04             	mov    0x4(%eax),%eax
  802bba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc2:	8b 40 04             	mov    0x4(%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	74 0f                	je     802bd8 <alloc_block_NF+0x536>
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd2:	8b 12                	mov    (%edx),%edx
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	eb 0a                	jmp    802be2 <alloc_block_NF+0x540>
  802bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdb:	8b 00                	mov    (%eax),%eax
  802bdd:	a3 48 51 80 00       	mov    %eax,0x805148
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf5:	a1 54 51 80 00       	mov    0x805154,%eax
  802bfa:	48                   	dec    %eax
  802bfb:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c03:	8b 40 08             	mov    0x8(%eax),%eax
  802c06:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 50 08             	mov    0x8(%eax),%edx
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	01 c2                	add    %eax,%edx
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c22:	2b 45 08             	sub    0x8(%ebp),%eax
  802c25:	89 c2                	mov    %eax,%edx
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c30:	eb 3b                	jmp    802c6d <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c32:	a1 40 51 80 00       	mov    0x805140,%eax
  802c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3e:	74 07                	je     802c47 <alloc_block_NF+0x5a5>
  802c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	eb 05                	jmp    802c4c <alloc_block_NF+0x5aa>
  802c47:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4c:	a3 40 51 80 00       	mov    %eax,0x805140
  802c51:	a1 40 51 80 00       	mov    0x805140,%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	0f 85 2e fe ff ff    	jne    802a8c <alloc_block_NF+0x3ea>
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	0f 85 24 fe ff ff    	jne    802a8c <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6d:	c9                   	leave  
  802c6e:	c3                   	ret    

00802c6f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c6f:	55                   	push   %ebp
  802c70:	89 e5                	mov    %esp,%ebp
  802c72:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c75:	a1 38 51 80 00       	mov    0x805138,%eax
  802c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c7d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c82:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c85:	a1 38 51 80 00       	mov    0x805138,%eax
  802c8a:	85 c0                	test   %eax,%eax
  802c8c:	74 14                	je     802ca2 <insert_sorted_with_merge_freeList+0x33>
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 50 08             	mov    0x8(%eax),%edx
  802c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c97:	8b 40 08             	mov    0x8(%eax),%eax
  802c9a:	39 c2                	cmp    %eax,%edx
  802c9c:	0f 87 9b 01 00 00    	ja     802e3d <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ca2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca6:	75 17                	jne    802cbf <insert_sorted_with_merge_freeList+0x50>
  802ca8:	83 ec 04             	sub    $0x4,%esp
  802cab:	68 2c 3f 80 00       	push   $0x803f2c
  802cb0:	68 38 01 00 00       	push   $0x138
  802cb5:	68 4f 3f 80 00       	push   $0x803f4f
  802cba:	e8 de d6 ff ff       	call   80039d <_panic>
  802cbf:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	89 10                	mov    %edx,(%eax)
  802cca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	85 c0                	test   %eax,%eax
  802cd1:	74 0d                	je     802ce0 <insert_sorted_with_merge_freeList+0x71>
  802cd3:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdb:	89 50 04             	mov    %edx,0x4(%eax)
  802cde:	eb 08                	jmp    802ce8 <insert_sorted_with_merge_freeList+0x79>
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	a3 38 51 80 00       	mov    %eax,0x805138
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfa:	a1 44 51 80 00       	mov    0x805144,%eax
  802cff:	40                   	inc    %eax
  802d00:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d09:	0f 84 a8 06 00 00    	je     8033b7 <insert_sorted_with_merge_freeList+0x748>
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	8b 50 08             	mov    0x8(%eax),%edx
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1b:	01 c2                	add    %eax,%edx
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	8b 40 08             	mov    0x8(%eax),%eax
  802d23:	39 c2                	cmp    %eax,%edx
  802d25:	0f 85 8c 06 00 00    	jne    8033b7 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c2                	add    %eax,%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d43:	75 17                	jne    802d5c <insert_sorted_with_merge_freeList+0xed>
  802d45:	83 ec 04             	sub    $0x4,%esp
  802d48:	68 f8 3f 80 00       	push   $0x803ff8
  802d4d:	68 3c 01 00 00       	push   $0x13c
  802d52:	68 4f 3f 80 00       	push   $0x803f4f
  802d57:	e8 41 d6 ff ff       	call   80039d <_panic>
  802d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5f:	8b 00                	mov    (%eax),%eax
  802d61:	85 c0                	test   %eax,%eax
  802d63:	74 10                	je     802d75 <insert_sorted_with_merge_freeList+0x106>
  802d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6d:	8b 52 04             	mov    0x4(%edx),%edx
  802d70:	89 50 04             	mov    %edx,0x4(%eax)
  802d73:	eb 0b                	jmp    802d80 <insert_sorted_with_merge_freeList+0x111>
  802d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d78:	8b 40 04             	mov    0x4(%eax),%eax
  802d7b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 0f                	je     802d99 <insert_sorted_with_merge_freeList+0x12a>
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d93:	8b 12                	mov    (%edx),%edx
  802d95:	89 10                	mov    %edx,(%eax)
  802d97:	eb 0a                	jmp    802da3 <insert_sorted_with_merge_freeList+0x134>
  802d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9c:	8b 00                	mov    (%eax),%eax
  802d9e:	a3 38 51 80 00       	mov    %eax,0x805138
  802da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db6:	a1 44 51 80 00       	mov    0x805144,%eax
  802dbb:	48                   	dec    %eax
  802dbc:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dd9:	75 17                	jne    802df2 <insert_sorted_with_merge_freeList+0x183>
  802ddb:	83 ec 04             	sub    $0x4,%esp
  802dde:	68 2c 3f 80 00       	push   $0x803f2c
  802de3:	68 3f 01 00 00       	push   $0x13f
  802de8:	68 4f 3f 80 00       	push   $0x803f4f
  802ded:	e8 ab d5 ff ff       	call   80039d <_panic>
  802df2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfb:	89 10                	mov    %edx,(%eax)
  802dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	74 0d                	je     802e13 <insert_sorted_with_merge_freeList+0x1a4>
  802e06:	a1 48 51 80 00       	mov    0x805148,%eax
  802e0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0e:	89 50 04             	mov    %edx,0x4(%eax)
  802e11:	eb 08                	jmp    802e1b <insert_sorted_with_merge_freeList+0x1ac>
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	a3 48 51 80 00       	mov    %eax,0x805148
  802e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2d:	a1 54 51 80 00       	mov    0x805154,%eax
  802e32:	40                   	inc    %eax
  802e33:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e38:	e9 7a 05 00 00       	jmp    8033b7 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 50 08             	mov    0x8(%eax),%edx
  802e43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e46:	8b 40 08             	mov    0x8(%eax),%eax
  802e49:	39 c2                	cmp    %eax,%edx
  802e4b:	0f 82 14 01 00 00    	jb     802f65 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e54:	8b 50 08             	mov    0x8(%eax),%edx
  802e57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5d:	01 c2                	add    %eax,%edx
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	8b 40 08             	mov    0x8(%eax),%eax
  802e65:	39 c2                	cmp    %eax,%edx
  802e67:	0f 85 90 00 00 00    	jne    802efd <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e70:	8b 50 0c             	mov    0xc(%eax),%edx
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 40 0c             	mov    0xc(%eax),%eax
  802e79:	01 c2                	add    %eax,%edx
  802e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7e:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e99:	75 17                	jne    802eb2 <insert_sorted_with_merge_freeList+0x243>
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	68 2c 3f 80 00       	push   $0x803f2c
  802ea3:	68 49 01 00 00       	push   $0x149
  802ea8:	68 4f 3f 80 00       	push   $0x803f4f
  802ead:	e8 eb d4 ff ff       	call   80039d <_panic>
  802eb2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	89 10                	mov    %edx,(%eax)
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 0d                	je     802ed3 <insert_sorted_with_merge_freeList+0x264>
  802ec6:	a1 48 51 80 00       	mov    0x805148,%eax
  802ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ece:	89 50 04             	mov    %edx,0x4(%eax)
  802ed1:	eb 08                	jmp    802edb <insert_sorted_with_merge_freeList+0x26c>
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eed:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef2:	40                   	inc    %eax
  802ef3:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ef8:	e9 bb 04 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802efd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f01:	75 17                	jne    802f1a <insert_sorted_with_merge_freeList+0x2ab>
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	68 a0 3f 80 00       	push   $0x803fa0
  802f0b:	68 4c 01 00 00       	push   $0x14c
  802f10:	68 4f 3f 80 00       	push   $0x803f4f
  802f15:	e8 83 d4 ff ff       	call   80039d <_panic>
  802f1a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	89 50 04             	mov    %edx,0x4(%eax)
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 40 04             	mov    0x4(%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0c                	je     802f3c <insert_sorted_with_merge_freeList+0x2cd>
  802f30:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f35:	8b 55 08             	mov    0x8(%ebp),%edx
  802f38:	89 10                	mov    %edx,(%eax)
  802f3a:	eb 08                	jmp    802f44 <insert_sorted_with_merge_freeList+0x2d5>
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	a3 38 51 80 00       	mov    %eax,0x805138
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f55:	a1 44 51 80 00       	mov    0x805144,%eax
  802f5a:	40                   	inc    %eax
  802f5b:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f60:	e9 53 04 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f65:	a1 38 51 80 00       	mov    0x805138,%eax
  802f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f6d:	e9 15 04 00 00       	jmp    803387 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	8b 50 08             	mov    0x8(%eax),%edx
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 40 08             	mov    0x8(%eax),%eax
  802f86:	39 c2                	cmp    %eax,%edx
  802f88:	0f 86 f1 03 00 00    	jbe    80337f <insert_sorted_with_merge_freeList+0x710>
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	8b 50 08             	mov    0x8(%eax),%edx
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	8b 40 08             	mov    0x8(%eax),%eax
  802f9a:	39 c2                	cmp    %eax,%edx
  802f9c:	0f 83 dd 03 00 00    	jae    80337f <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 50 08             	mov    0x8(%eax),%edx
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 40 0c             	mov    0xc(%eax),%eax
  802fae:	01 c2                	add    %eax,%edx
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	8b 40 08             	mov    0x8(%eax),%eax
  802fb6:	39 c2                	cmp    %eax,%edx
  802fb8:	0f 85 b9 01 00 00    	jne    803177 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	8b 50 08             	mov    0x8(%eax),%edx
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fca:	01 c2                	add    %eax,%edx
  802fcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fcf:	8b 40 08             	mov    0x8(%eax),%eax
  802fd2:	39 c2                	cmp    %eax,%edx
  802fd4:	0f 85 0d 01 00 00    	jne    8030e7 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe6:	01 c2                	add    %eax,%edx
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802fee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff2:	75 17                	jne    80300b <insert_sorted_with_merge_freeList+0x39c>
  802ff4:	83 ec 04             	sub    $0x4,%esp
  802ff7:	68 f8 3f 80 00       	push   $0x803ff8
  802ffc:	68 5c 01 00 00       	push   $0x15c
  803001:	68 4f 3f 80 00       	push   $0x803f4f
  803006:	e8 92 d3 ff ff       	call   80039d <_panic>
  80300b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 10                	je     803024 <insert_sorted_with_merge_freeList+0x3b5>
  803014:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803017:	8b 00                	mov    (%eax),%eax
  803019:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301c:	8b 52 04             	mov    0x4(%edx),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 0b                	jmp    80302f <insert_sorted_with_merge_freeList+0x3c0>
  803024:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803032:	8b 40 04             	mov    0x4(%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 0f                	je     803048 <insert_sorted_with_merge_freeList+0x3d9>
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	8b 40 04             	mov    0x4(%eax),%eax
  80303f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803042:	8b 12                	mov    (%edx),%edx
  803044:	89 10                	mov    %edx,(%eax)
  803046:	eb 0a                	jmp    803052 <insert_sorted_with_merge_freeList+0x3e3>
  803048:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	a3 38 51 80 00       	mov    %eax,0x805138
  803052:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803055:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803065:	a1 44 51 80 00       	mov    0x805144,%eax
  80306a:	48                   	dec    %eax
  80306b:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803070:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803073:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80307a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803084:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803088:	75 17                	jne    8030a1 <insert_sorted_with_merge_freeList+0x432>
  80308a:	83 ec 04             	sub    $0x4,%esp
  80308d:	68 2c 3f 80 00       	push   $0x803f2c
  803092:	68 5f 01 00 00       	push   $0x15f
  803097:	68 4f 3f 80 00       	push   $0x803f4f
  80309c:	e8 fc d2 ff ff       	call   80039d <_panic>
  8030a1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	89 10                	mov    %edx,(%eax)
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	74 0d                	je     8030c2 <insert_sorted_with_merge_freeList+0x453>
  8030b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030bd:	89 50 04             	mov    %edx,0x4(%eax)
  8030c0:	eb 08                	jmp    8030ca <insert_sorted_with_merge_freeList+0x45b>
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8030d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8030e1:	40                   	inc    %eax
  8030e2:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f3:	01 c2                	add    %eax,%edx
  8030f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f8:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80310f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803113:	75 17                	jne    80312c <insert_sorted_with_merge_freeList+0x4bd>
  803115:	83 ec 04             	sub    $0x4,%esp
  803118:	68 2c 3f 80 00       	push   $0x803f2c
  80311d:	68 64 01 00 00       	push   $0x164
  803122:	68 4f 3f 80 00       	push   $0x803f4f
  803127:	e8 71 d2 ff ff       	call   80039d <_panic>
  80312c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	89 10                	mov    %edx,(%eax)
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	85 c0                	test   %eax,%eax
  80313e:	74 0d                	je     80314d <insert_sorted_with_merge_freeList+0x4de>
  803140:	a1 48 51 80 00       	mov    0x805148,%eax
  803145:	8b 55 08             	mov    0x8(%ebp),%edx
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	eb 08                	jmp    803155 <insert_sorted_with_merge_freeList+0x4e6>
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	a3 48 51 80 00       	mov    %eax,0x805148
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803167:	a1 54 51 80 00       	mov    0x805154,%eax
  80316c:	40                   	inc    %eax
  80316d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803172:	e9 41 02 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	8b 50 08             	mov    0x8(%eax),%edx
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	8b 40 0c             	mov    0xc(%eax),%eax
  803183:	01 c2                	add    %eax,%edx
  803185:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803188:	8b 40 08             	mov    0x8(%eax),%eax
  80318b:	39 c2                	cmp    %eax,%edx
  80318d:	0f 85 7c 01 00 00    	jne    80330f <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803193:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803197:	74 06                	je     80319f <insert_sorted_with_merge_freeList+0x530>
  803199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319d:	75 17                	jne    8031b6 <insert_sorted_with_merge_freeList+0x547>
  80319f:	83 ec 04             	sub    $0x4,%esp
  8031a2:	68 68 3f 80 00       	push   $0x803f68
  8031a7:	68 69 01 00 00       	push   $0x169
  8031ac:	68 4f 3f 80 00       	push   $0x803f4f
  8031b1:	e8 e7 d1 ff ff       	call   80039d <_panic>
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	8b 50 04             	mov    0x4(%eax),%edx
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	89 50 04             	mov    %edx,0x4(%eax)
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c8:	89 10                	mov    %edx,(%eax)
  8031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cd:	8b 40 04             	mov    0x4(%eax),%eax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	74 0d                	je     8031e1 <insert_sorted_with_merge_freeList+0x572>
  8031d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d7:	8b 40 04             	mov    0x4(%eax),%eax
  8031da:	8b 55 08             	mov    0x8(%ebp),%edx
  8031dd:	89 10                	mov    %edx,(%eax)
  8031df:	eb 08                	jmp    8031e9 <insert_sorted_with_merge_freeList+0x57a>
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	a3 38 51 80 00       	mov    %eax,0x805138
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ef:	89 50 04             	mov    %edx,0x4(%eax)
  8031f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f7:	40                   	inc    %eax
  8031f8:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	8b 50 0c             	mov    0xc(%eax),%edx
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	8b 40 0c             	mov    0xc(%eax),%eax
  803209:	01 c2                	add    %eax,%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803211:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803215:	75 17                	jne    80322e <insert_sorted_with_merge_freeList+0x5bf>
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	68 f8 3f 80 00       	push   $0x803ff8
  80321f:	68 6b 01 00 00       	push   $0x16b
  803224:	68 4f 3f 80 00       	push   $0x803f4f
  803229:	e8 6f d1 ff ff       	call   80039d <_panic>
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	85 c0                	test   %eax,%eax
  803235:	74 10                	je     803247 <insert_sorted_with_merge_freeList+0x5d8>
  803237:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323a:	8b 00                	mov    (%eax),%eax
  80323c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80323f:	8b 52 04             	mov    0x4(%edx),%edx
  803242:	89 50 04             	mov    %edx,0x4(%eax)
  803245:	eb 0b                	jmp    803252 <insert_sorted_with_merge_freeList+0x5e3>
  803247:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324a:	8b 40 04             	mov    0x4(%eax),%eax
  80324d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803255:	8b 40 04             	mov    0x4(%eax),%eax
  803258:	85 c0                	test   %eax,%eax
  80325a:	74 0f                	je     80326b <insert_sorted_with_merge_freeList+0x5fc>
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	8b 40 04             	mov    0x4(%eax),%eax
  803262:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803265:	8b 12                	mov    (%edx),%edx
  803267:	89 10                	mov    %edx,(%eax)
  803269:	eb 0a                	jmp    803275 <insert_sorted_with_merge_freeList+0x606>
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	a3 38 51 80 00       	mov    %eax,0x805138
  803275:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803288:	a1 44 51 80 00       	mov    0x805144,%eax
  80328d:	48                   	dec    %eax
  80328e:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803296:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ab:	75 17                	jne    8032c4 <insert_sorted_with_merge_freeList+0x655>
  8032ad:	83 ec 04             	sub    $0x4,%esp
  8032b0:	68 2c 3f 80 00       	push   $0x803f2c
  8032b5:	68 6e 01 00 00       	push   $0x16e
  8032ba:	68 4f 3f 80 00       	push   $0x803f4f
  8032bf:	e8 d9 d0 ff ff       	call   80039d <_panic>
  8032c4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	89 10                	mov    %edx,(%eax)
  8032cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d2:	8b 00                	mov    (%eax),%eax
  8032d4:	85 c0                	test   %eax,%eax
  8032d6:	74 0d                	je     8032e5 <insert_sorted_with_merge_freeList+0x676>
  8032d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8032dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e0:	89 50 04             	mov    %edx,0x4(%eax)
  8032e3:	eb 08                	jmp    8032ed <insert_sorted_with_merge_freeList+0x67e>
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ff:	a1 54 51 80 00       	mov    0x805154,%eax
  803304:	40                   	inc    %eax
  803305:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80330a:	e9 a9 00 00 00       	jmp    8033b8 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80330f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803313:	74 06                	je     80331b <insert_sorted_with_merge_freeList+0x6ac>
  803315:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803319:	75 17                	jne    803332 <insert_sorted_with_merge_freeList+0x6c3>
  80331b:	83 ec 04             	sub    $0x4,%esp
  80331e:	68 c4 3f 80 00       	push   $0x803fc4
  803323:	68 73 01 00 00       	push   $0x173
  803328:	68 4f 3f 80 00       	push   $0x803f4f
  80332d:	e8 6b d0 ff ff       	call   80039d <_panic>
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	8b 10                	mov    (%eax),%edx
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	89 10                	mov    %edx,(%eax)
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	8b 00                	mov    (%eax),%eax
  803341:	85 c0                	test   %eax,%eax
  803343:	74 0b                	je     803350 <insert_sorted_with_merge_freeList+0x6e1>
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	8b 55 08             	mov    0x8(%ebp),%edx
  80334d:	89 50 04             	mov    %edx,0x4(%eax)
  803350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803353:	8b 55 08             	mov    0x8(%ebp),%edx
  803356:	89 10                	mov    %edx,(%eax)
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80335e:	89 50 04             	mov    %edx,0x4(%eax)
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	8b 00                	mov    (%eax),%eax
  803366:	85 c0                	test   %eax,%eax
  803368:	75 08                	jne    803372 <insert_sorted_with_merge_freeList+0x703>
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803372:	a1 44 51 80 00       	mov    0x805144,%eax
  803377:	40                   	inc    %eax
  803378:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80337d:	eb 39                	jmp    8033b8 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80337f:	a1 40 51 80 00       	mov    0x805140,%eax
  803384:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338b:	74 07                	je     803394 <insert_sorted_with_merge_freeList+0x725>
  80338d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803390:	8b 00                	mov    (%eax),%eax
  803392:	eb 05                	jmp    803399 <insert_sorted_with_merge_freeList+0x72a>
  803394:	b8 00 00 00 00       	mov    $0x0,%eax
  803399:	a3 40 51 80 00       	mov    %eax,0x805140
  80339e:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a3:	85 c0                	test   %eax,%eax
  8033a5:	0f 85 c7 fb ff ff    	jne    802f72 <insert_sorted_with_merge_freeList+0x303>
  8033ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033af:	0f 85 bd fb ff ff    	jne    802f72 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033b5:	eb 01                	jmp    8033b8 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033b7:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033b8:	90                   	nop
  8033b9:	c9                   	leave  
  8033ba:	c3                   	ret    
  8033bb:	90                   	nop

008033bc <__udivdi3>:
  8033bc:	55                   	push   %ebp
  8033bd:	57                   	push   %edi
  8033be:	56                   	push   %esi
  8033bf:	53                   	push   %ebx
  8033c0:	83 ec 1c             	sub    $0x1c,%esp
  8033c3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033c7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033d3:	89 ca                	mov    %ecx,%edx
  8033d5:	89 f8                	mov    %edi,%eax
  8033d7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033db:	85 f6                	test   %esi,%esi
  8033dd:	75 2d                	jne    80340c <__udivdi3+0x50>
  8033df:	39 cf                	cmp    %ecx,%edi
  8033e1:	77 65                	ja     803448 <__udivdi3+0x8c>
  8033e3:	89 fd                	mov    %edi,%ebp
  8033e5:	85 ff                	test   %edi,%edi
  8033e7:	75 0b                	jne    8033f4 <__udivdi3+0x38>
  8033e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ee:	31 d2                	xor    %edx,%edx
  8033f0:	f7 f7                	div    %edi
  8033f2:	89 c5                	mov    %eax,%ebp
  8033f4:	31 d2                	xor    %edx,%edx
  8033f6:	89 c8                	mov    %ecx,%eax
  8033f8:	f7 f5                	div    %ebp
  8033fa:	89 c1                	mov    %eax,%ecx
  8033fc:	89 d8                	mov    %ebx,%eax
  8033fe:	f7 f5                	div    %ebp
  803400:	89 cf                	mov    %ecx,%edi
  803402:	89 fa                	mov    %edi,%edx
  803404:	83 c4 1c             	add    $0x1c,%esp
  803407:	5b                   	pop    %ebx
  803408:	5e                   	pop    %esi
  803409:	5f                   	pop    %edi
  80340a:	5d                   	pop    %ebp
  80340b:	c3                   	ret    
  80340c:	39 ce                	cmp    %ecx,%esi
  80340e:	77 28                	ja     803438 <__udivdi3+0x7c>
  803410:	0f bd fe             	bsr    %esi,%edi
  803413:	83 f7 1f             	xor    $0x1f,%edi
  803416:	75 40                	jne    803458 <__udivdi3+0x9c>
  803418:	39 ce                	cmp    %ecx,%esi
  80341a:	72 0a                	jb     803426 <__udivdi3+0x6a>
  80341c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803420:	0f 87 9e 00 00 00    	ja     8034c4 <__udivdi3+0x108>
  803426:	b8 01 00 00 00       	mov    $0x1,%eax
  80342b:	89 fa                	mov    %edi,%edx
  80342d:	83 c4 1c             	add    $0x1c,%esp
  803430:	5b                   	pop    %ebx
  803431:	5e                   	pop    %esi
  803432:	5f                   	pop    %edi
  803433:	5d                   	pop    %ebp
  803434:	c3                   	ret    
  803435:	8d 76 00             	lea    0x0(%esi),%esi
  803438:	31 ff                	xor    %edi,%edi
  80343a:	31 c0                	xor    %eax,%eax
  80343c:	89 fa                	mov    %edi,%edx
  80343e:	83 c4 1c             	add    $0x1c,%esp
  803441:	5b                   	pop    %ebx
  803442:	5e                   	pop    %esi
  803443:	5f                   	pop    %edi
  803444:	5d                   	pop    %ebp
  803445:	c3                   	ret    
  803446:	66 90                	xchg   %ax,%ax
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	f7 f7                	div    %edi
  80344c:	31 ff                	xor    %edi,%edi
  80344e:	89 fa                	mov    %edi,%edx
  803450:	83 c4 1c             	add    $0x1c,%esp
  803453:	5b                   	pop    %ebx
  803454:	5e                   	pop    %esi
  803455:	5f                   	pop    %edi
  803456:	5d                   	pop    %ebp
  803457:	c3                   	ret    
  803458:	bd 20 00 00 00       	mov    $0x20,%ebp
  80345d:	89 eb                	mov    %ebp,%ebx
  80345f:	29 fb                	sub    %edi,%ebx
  803461:	89 f9                	mov    %edi,%ecx
  803463:	d3 e6                	shl    %cl,%esi
  803465:	89 c5                	mov    %eax,%ebp
  803467:	88 d9                	mov    %bl,%cl
  803469:	d3 ed                	shr    %cl,%ebp
  80346b:	89 e9                	mov    %ebp,%ecx
  80346d:	09 f1                	or     %esi,%ecx
  80346f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803473:	89 f9                	mov    %edi,%ecx
  803475:	d3 e0                	shl    %cl,%eax
  803477:	89 c5                	mov    %eax,%ebp
  803479:	89 d6                	mov    %edx,%esi
  80347b:	88 d9                	mov    %bl,%cl
  80347d:	d3 ee                	shr    %cl,%esi
  80347f:	89 f9                	mov    %edi,%ecx
  803481:	d3 e2                	shl    %cl,%edx
  803483:	8b 44 24 08          	mov    0x8(%esp),%eax
  803487:	88 d9                	mov    %bl,%cl
  803489:	d3 e8                	shr    %cl,%eax
  80348b:	09 c2                	or     %eax,%edx
  80348d:	89 d0                	mov    %edx,%eax
  80348f:	89 f2                	mov    %esi,%edx
  803491:	f7 74 24 0c          	divl   0xc(%esp)
  803495:	89 d6                	mov    %edx,%esi
  803497:	89 c3                	mov    %eax,%ebx
  803499:	f7 e5                	mul    %ebp
  80349b:	39 d6                	cmp    %edx,%esi
  80349d:	72 19                	jb     8034b8 <__udivdi3+0xfc>
  80349f:	74 0b                	je     8034ac <__udivdi3+0xf0>
  8034a1:	89 d8                	mov    %ebx,%eax
  8034a3:	31 ff                	xor    %edi,%edi
  8034a5:	e9 58 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034aa:	66 90                	xchg   %ax,%ax
  8034ac:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034b0:	89 f9                	mov    %edi,%ecx
  8034b2:	d3 e2                	shl    %cl,%edx
  8034b4:	39 c2                	cmp    %eax,%edx
  8034b6:	73 e9                	jae    8034a1 <__udivdi3+0xe5>
  8034b8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034bb:	31 ff                	xor    %edi,%edi
  8034bd:	e9 40 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034c2:	66 90                	xchg   %ax,%ax
  8034c4:	31 c0                	xor    %eax,%eax
  8034c6:	e9 37 ff ff ff       	jmp    803402 <__udivdi3+0x46>
  8034cb:	90                   	nop

008034cc <__umoddi3>:
  8034cc:	55                   	push   %ebp
  8034cd:	57                   	push   %edi
  8034ce:	56                   	push   %esi
  8034cf:	53                   	push   %ebx
  8034d0:	83 ec 1c             	sub    $0x1c,%esp
  8034d3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034d7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034df:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034eb:	89 f3                	mov    %esi,%ebx
  8034ed:	89 fa                	mov    %edi,%edx
  8034ef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034f3:	89 34 24             	mov    %esi,(%esp)
  8034f6:	85 c0                	test   %eax,%eax
  8034f8:	75 1a                	jne    803514 <__umoddi3+0x48>
  8034fa:	39 f7                	cmp    %esi,%edi
  8034fc:	0f 86 a2 00 00 00    	jbe    8035a4 <__umoddi3+0xd8>
  803502:	89 c8                	mov    %ecx,%eax
  803504:	89 f2                	mov    %esi,%edx
  803506:	f7 f7                	div    %edi
  803508:	89 d0                	mov    %edx,%eax
  80350a:	31 d2                	xor    %edx,%edx
  80350c:	83 c4 1c             	add    $0x1c,%esp
  80350f:	5b                   	pop    %ebx
  803510:	5e                   	pop    %esi
  803511:	5f                   	pop    %edi
  803512:	5d                   	pop    %ebp
  803513:	c3                   	ret    
  803514:	39 f0                	cmp    %esi,%eax
  803516:	0f 87 ac 00 00 00    	ja     8035c8 <__umoddi3+0xfc>
  80351c:	0f bd e8             	bsr    %eax,%ebp
  80351f:	83 f5 1f             	xor    $0x1f,%ebp
  803522:	0f 84 ac 00 00 00    	je     8035d4 <__umoddi3+0x108>
  803528:	bf 20 00 00 00       	mov    $0x20,%edi
  80352d:	29 ef                	sub    %ebp,%edi
  80352f:	89 fe                	mov    %edi,%esi
  803531:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803535:	89 e9                	mov    %ebp,%ecx
  803537:	d3 e0                	shl    %cl,%eax
  803539:	89 d7                	mov    %edx,%edi
  80353b:	89 f1                	mov    %esi,%ecx
  80353d:	d3 ef                	shr    %cl,%edi
  80353f:	09 c7                	or     %eax,%edi
  803541:	89 e9                	mov    %ebp,%ecx
  803543:	d3 e2                	shl    %cl,%edx
  803545:	89 14 24             	mov    %edx,(%esp)
  803548:	89 d8                	mov    %ebx,%eax
  80354a:	d3 e0                	shl    %cl,%eax
  80354c:	89 c2                	mov    %eax,%edx
  80354e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803552:	d3 e0                	shl    %cl,%eax
  803554:	89 44 24 04          	mov    %eax,0x4(%esp)
  803558:	8b 44 24 08          	mov    0x8(%esp),%eax
  80355c:	89 f1                	mov    %esi,%ecx
  80355e:	d3 e8                	shr    %cl,%eax
  803560:	09 d0                	or     %edx,%eax
  803562:	d3 eb                	shr    %cl,%ebx
  803564:	89 da                	mov    %ebx,%edx
  803566:	f7 f7                	div    %edi
  803568:	89 d3                	mov    %edx,%ebx
  80356a:	f7 24 24             	mull   (%esp)
  80356d:	89 c6                	mov    %eax,%esi
  80356f:	89 d1                	mov    %edx,%ecx
  803571:	39 d3                	cmp    %edx,%ebx
  803573:	0f 82 87 00 00 00    	jb     803600 <__umoddi3+0x134>
  803579:	0f 84 91 00 00 00    	je     803610 <__umoddi3+0x144>
  80357f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803583:	29 f2                	sub    %esi,%edx
  803585:	19 cb                	sbb    %ecx,%ebx
  803587:	89 d8                	mov    %ebx,%eax
  803589:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80358d:	d3 e0                	shl    %cl,%eax
  80358f:	89 e9                	mov    %ebp,%ecx
  803591:	d3 ea                	shr    %cl,%edx
  803593:	09 d0                	or     %edx,%eax
  803595:	89 e9                	mov    %ebp,%ecx
  803597:	d3 eb                	shr    %cl,%ebx
  803599:	89 da                	mov    %ebx,%edx
  80359b:	83 c4 1c             	add    $0x1c,%esp
  80359e:	5b                   	pop    %ebx
  80359f:	5e                   	pop    %esi
  8035a0:	5f                   	pop    %edi
  8035a1:	5d                   	pop    %ebp
  8035a2:	c3                   	ret    
  8035a3:	90                   	nop
  8035a4:	89 fd                	mov    %edi,%ebp
  8035a6:	85 ff                	test   %edi,%edi
  8035a8:	75 0b                	jne    8035b5 <__umoddi3+0xe9>
  8035aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8035af:	31 d2                	xor    %edx,%edx
  8035b1:	f7 f7                	div    %edi
  8035b3:	89 c5                	mov    %eax,%ebp
  8035b5:	89 f0                	mov    %esi,%eax
  8035b7:	31 d2                	xor    %edx,%edx
  8035b9:	f7 f5                	div    %ebp
  8035bb:	89 c8                	mov    %ecx,%eax
  8035bd:	f7 f5                	div    %ebp
  8035bf:	89 d0                	mov    %edx,%eax
  8035c1:	e9 44 ff ff ff       	jmp    80350a <__umoddi3+0x3e>
  8035c6:	66 90                	xchg   %ax,%ax
  8035c8:	89 c8                	mov    %ecx,%eax
  8035ca:	89 f2                	mov    %esi,%edx
  8035cc:	83 c4 1c             	add    $0x1c,%esp
  8035cf:	5b                   	pop    %ebx
  8035d0:	5e                   	pop    %esi
  8035d1:	5f                   	pop    %edi
  8035d2:	5d                   	pop    %ebp
  8035d3:	c3                   	ret    
  8035d4:	3b 04 24             	cmp    (%esp),%eax
  8035d7:	72 06                	jb     8035df <__umoddi3+0x113>
  8035d9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035dd:	77 0f                	ja     8035ee <__umoddi3+0x122>
  8035df:	89 f2                	mov    %esi,%edx
  8035e1:	29 f9                	sub    %edi,%ecx
  8035e3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035e7:	89 14 24             	mov    %edx,(%esp)
  8035ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ee:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035f2:	8b 14 24             	mov    (%esp),%edx
  8035f5:	83 c4 1c             	add    $0x1c,%esp
  8035f8:	5b                   	pop    %ebx
  8035f9:	5e                   	pop    %esi
  8035fa:	5f                   	pop    %edi
  8035fb:	5d                   	pop    %ebp
  8035fc:	c3                   	ret    
  8035fd:	8d 76 00             	lea    0x0(%esi),%esi
  803600:	2b 04 24             	sub    (%esp),%eax
  803603:	19 fa                	sbb    %edi,%edx
  803605:	89 d1                	mov    %edx,%ecx
  803607:	89 c6                	mov    %eax,%esi
  803609:	e9 71 ff ff ff       	jmp    80357f <__umoddi3+0xb3>
  80360e:	66 90                	xchg   %ax,%ax
  803610:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803614:	72 ea                	jb     803600 <__umoddi3+0x134>
  803616:	89 d9                	mov    %ebx,%ecx
  803618:	e9 62 ff ff ff       	jmp    80357f <__umoddi3+0xb3>
