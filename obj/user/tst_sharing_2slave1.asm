
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
  80008d:	68 a0 36 80 00       	push   $0x8036a0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 36 80 00       	push   $0x8036bc
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
  8000ab:	e8 aa 1a 00 00       	call   801b5a <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 96 18 00 00       	call   80194e <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 a4 17 00 00       	call   801861 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 d7 36 80 00       	push   $0x8036d7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 ed 15 00 00       	call   8016bd <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 dc 36 80 00       	push   $0x8036dc
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 bc 36 80 00       	push   $0x8036bc
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 66 17 00 00       	call   801861 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 3c 37 80 00       	push   $0x80373c
  80010c:	6a 21                	push   $0x21
  80010e:	68 bc 36 80 00       	push   $0x8036bc
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 4b 18 00 00       	call   801968 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 2c 18 00 00       	call   80194e <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 3a 17 00 00       	call   801861 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 cd 37 80 00       	push   $0x8037cd
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 83 15 00 00       	call   8016bd <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 dc 36 80 00       	push   $0x8036dc
  800151:	6a 27                	push   $0x27
  800153:	68 bc 36 80 00       	push   $0x8036bc
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 ff 16 00 00       	call   801861 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 3c 37 80 00       	push   $0x80373c
  800173:	6a 28                	push   $0x28
  800175:	68 bc 36 80 00       	push   $0x8036bc
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 e4 17 00 00       	call   801968 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 d0 37 80 00       	push   $0x8037d0
  800196:	6a 2b                	push   $0x2b
  800198:	68 bc 36 80 00       	push   $0x8036bc
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 a7 17 00 00       	call   80194e <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 b5 16 00 00       	call   801861 <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 07 38 80 00       	push   $0x803807
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 fe 14 00 00       	call   8016bd <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 dc 36 80 00       	push   $0x8036dc
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 bc 36 80 00       	push   $0x8036bc
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 7a 16 00 00       	call   801861 <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 3c 37 80 00       	push   $0x80373c
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 bc 36 80 00       	push   $0x8036bc
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 5f 17 00 00       	call   801968 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 d0 37 80 00       	push   $0x8037d0
  80021b:	6a 34                	push   $0x34
  80021d:	68 bc 36 80 00       	push   $0x8036bc
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
  800245:	68 d0 37 80 00       	push   $0x8037d0
  80024a:	6a 37                	push   $0x37
  80024c:	68 bc 36 80 00       	push   $0x8036bc
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 24 1a 00 00       	call   801c7f <inctst>

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
  800267:	e8 d5 18 00 00       	call   801b41 <sys_getenvindex>
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
  8002d2:	e8 77 16 00 00       	call   80194e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 24 38 80 00       	push   $0x803824
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
  800302:	68 4c 38 80 00       	push   $0x80384c
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
  800333:	68 74 38 80 00       	push   $0x803874
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 50 80 00       	mov    0x805020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 cc 38 80 00       	push   $0x8038cc
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 24 38 80 00       	push   $0x803824
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 f7 15 00 00       	call   801968 <sys_enable_interrupt>

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
  800384:	e8 84 17 00 00       	call   801b0d <sys_destroy_env>
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
  800395:	e8 d9 17 00 00       	call   801b73 <sys_exit_env>
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
  8003be:	68 e0 38 80 00       	push   $0x8038e0
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 e5 38 80 00       	push   $0x8038e5
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
  8003fb:	68 01 39 80 00       	push   $0x803901
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
  800427:	68 04 39 80 00       	push   $0x803904
  80042c:	6a 26                	push   $0x26
  80042e:	68 50 39 80 00       	push   $0x803950
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
  8004f9:	68 5c 39 80 00       	push   $0x80395c
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 50 39 80 00       	push   $0x803950
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
  800569:	68 b0 39 80 00       	push   $0x8039b0
  80056e:	6a 44                	push   $0x44
  800570:	68 50 39 80 00       	push   $0x803950
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
  8005c3:	e8 d8 11 00 00       	call   8017a0 <sys_cputs>
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
  80063a:	e8 61 11 00 00       	call   8017a0 <sys_cputs>
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
  800684:	e8 c5 12 00 00       	call   80194e <sys_disable_interrupt>
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
  8006a4:	e8 bf 12 00 00       	call   801968 <sys_enable_interrupt>
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
  8006ee:	e8 31 2d 00 00       	call   803424 <__udivdi3>
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
  80073e:	e8 f1 2d 00 00       	call   803534 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 14 3c 80 00       	add    $0x803c14,%eax
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
  800899:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
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
  80097a:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 25 3c 80 00       	push   $0x803c25
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
  80099f:	68 2e 3c 80 00       	push   $0x803c2e
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
  8009cc:	be 31 3c 80 00       	mov    $0x803c31,%esi
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
  8013f2:	68 90 3d 80 00       	push   $0x803d90
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
  8014c2:	e8 1d 04 00 00       	call   8018e4 <sys_allocate_chunk>
  8014c7:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ca:	a1 20 51 80 00       	mov    0x805120,%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 92 0a 00 00       	call   801f6a <initialize_MemBlocksList>
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
  801500:	68 b5 3d 80 00       	push   $0x803db5
  801505:	6a 33                	push   $0x33
  801507:	68 d3 3d 80 00       	push   $0x803dd3
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
  80157f:	68 e0 3d 80 00       	push   $0x803de0
  801584:	6a 34                	push   $0x34
  801586:	68 d3 3d 80 00       	push   $0x803dd3
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
  8015f4:	68 04 3e 80 00       	push   $0x803e04
  8015f9:	6a 46                	push   $0x46
  8015fb:	68 d3 3d 80 00       	push   $0x803dd3
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
  801610:	68 2c 3e 80 00       	push   $0x803e2c
  801615:	6a 61                	push   $0x61
  801617:	68 d3 3d 80 00       	push   $0x803dd3
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
  801636:	75 07                	jne    80163f <smalloc+0x1e>
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	eb 7c                	jmp    8016bb <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80163f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801646:	8b 55 0c             	mov    0xc(%ebp),%edx
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164c:	01 d0                	add    %edx,%eax
  80164e:	48                   	dec    %eax
  80164f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801652:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801655:	ba 00 00 00 00       	mov    $0x0,%edx
  80165a:	f7 75 f0             	divl   -0x10(%ebp)
  80165d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801660:	29 d0                	sub    %edx,%eax
  801662:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801665:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80166c:	e8 41 06 00 00       	call   801cb2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801671:	85 c0                	test   %eax,%eax
  801673:	74 11                	je     801686 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801675:	83 ec 0c             	sub    $0xc,%esp
  801678:	ff 75 e8             	pushl  -0x18(%ebp)
  80167b:	e8 ac 0c 00 00       	call   80232c <alloc_block_FF>
  801680:	83 c4 10             	add    $0x10,%esp
  801683:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80168a:	74 2a                	je     8016b6 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80168c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168f:	8b 40 08             	mov    0x8(%eax),%eax
  801692:	89 c2                	mov    %eax,%edx
  801694:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801698:	52                   	push   %edx
  801699:	50                   	push   %eax
  80169a:	ff 75 0c             	pushl  0xc(%ebp)
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	e8 92 03 00 00       	call   801a37 <sys_createSharedObject>
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8016ab:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8016af:	74 05                	je     8016b6 <smalloc+0x95>
			return (void*)virtual_address;
  8016b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b4:	eb 05                	jmp    8016bb <smalloc+0x9a>
	}
	return NULL;
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c3:	e8 13 fd ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016c8:	83 ec 04             	sub    $0x4,%esp
  8016cb:	68 50 3e 80 00       	push   $0x803e50
  8016d0:	68 a2 00 00 00       	push   $0xa2
  8016d5:	68 d3 3d 80 00       	push   $0x803dd3
  8016da:	e8 be ec ff ff       	call   80039d <_panic>

008016df <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e5:	e8 f1 fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016ea:	83 ec 04             	sub    $0x4,%esp
  8016ed:	68 74 3e 80 00       	push   $0x803e74
  8016f2:	68 e6 00 00 00       	push   $0xe6
  8016f7:	68 d3 3d 80 00       	push   $0x803dd3
  8016fc:	e8 9c ec ff ff       	call   80039d <_panic>

00801701 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801707:	83 ec 04             	sub    $0x4,%esp
  80170a:	68 9c 3e 80 00       	push   $0x803e9c
  80170f:	68 fa 00 00 00       	push   $0xfa
  801714:	68 d3 3d 80 00       	push   $0x803dd3
  801719:	e8 7f ec ff ff       	call   80039d <_panic>

0080171e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	68 c0 3e 80 00       	push   $0x803ec0
  80172c:	68 05 01 00 00       	push   $0x105
  801731:	68 d3 3d 80 00       	push   $0x803dd3
  801736:	e8 62 ec ff ff       	call   80039d <_panic>

0080173b <shrink>:

}
void shrink(uint32 newSize)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801741:	83 ec 04             	sub    $0x4,%esp
  801744:	68 c0 3e 80 00       	push   $0x803ec0
  801749:	68 0a 01 00 00       	push   $0x10a
  80174e:	68 d3 3d 80 00       	push   $0x803dd3
  801753:	e8 45 ec ff ff       	call   80039d <_panic>

00801758 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801758:	55                   	push   %ebp
  801759:	89 e5                	mov    %esp,%ebp
  80175b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80175e:	83 ec 04             	sub    $0x4,%esp
  801761:	68 c0 3e 80 00       	push   $0x803ec0
  801766:	68 0f 01 00 00       	push   $0x10f
  80176b:	68 d3 3d 80 00       	push   $0x803dd3
  801770:	e8 28 ec ff ff       	call   80039d <_panic>

00801775 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	57                   	push   %edi
  801779:	56                   	push   %esi
  80177a:	53                   	push   %ebx
  80177b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80177e:	8b 45 08             	mov    0x8(%ebp),%eax
  801781:	8b 55 0c             	mov    0xc(%ebp),%edx
  801784:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801787:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80178a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80178d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801790:	cd 30                	int    $0x30
  801792:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5e                   	pop    %esi
  80179d:	5f                   	pop    %edi
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017ac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	52                   	push   %edx
  8017b8:	ff 75 0c             	pushl  0xc(%ebp)
  8017bb:	50                   	push   %eax
  8017bc:	6a 00                	push   $0x0
  8017be:	e8 b2 ff ff ff       	call   801775 <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
}
  8017c6:	90                   	nop
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 01                	push   $0x1
  8017d8:	e8 98 ff ff ff       	call   801775 <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	52                   	push   %edx
  8017f2:	50                   	push   %eax
  8017f3:	6a 05                	push   $0x5
  8017f5:	e8 7b ff ff ff       	call   801775 <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	56                   	push   %esi
  801803:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801804:	8b 75 18             	mov    0x18(%ebp),%esi
  801807:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	56                   	push   %esi
  801814:	53                   	push   %ebx
  801815:	51                   	push   %ecx
  801816:	52                   	push   %edx
  801817:	50                   	push   %eax
  801818:	6a 06                	push   $0x6
  80181a:	e8 56 ff ff ff       	call   801775 <syscall>
  80181f:	83 c4 18             	add    $0x18,%esp
}
  801822:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801825:	5b                   	pop    %ebx
  801826:	5e                   	pop    %esi
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    

00801829 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80182c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	52                   	push   %edx
  801839:	50                   	push   %eax
  80183a:	6a 07                	push   $0x7
  80183c:	e8 34 ff ff ff       	call   801775 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	ff 75 08             	pushl  0x8(%ebp)
  801855:	6a 08                	push   $0x8
  801857:	e8 19 ff ff ff       	call   801775 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 09                	push   $0x9
  801870:	e8 00 ff ff ff       	call   801775 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 0a                	push   $0xa
  801889:	e8 e7 fe ff ff       	call   801775 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 0b                	push   $0xb
  8018a2:	e8 ce fe ff ff       	call   801775 <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 0c             	pushl  0xc(%ebp)
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	6a 0f                	push   $0xf
  8018bd:	e8 b3 fe ff ff       	call   801775 <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
	return;
  8018c5:	90                   	nop
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	ff 75 0c             	pushl  0xc(%ebp)
  8018d4:	ff 75 08             	pushl  0x8(%ebp)
  8018d7:	6a 10                	push   $0x10
  8018d9:	e8 97 fe ff ff       	call   801775 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e1:	90                   	nop
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	ff 75 10             	pushl  0x10(%ebp)
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	6a 11                	push   $0x11
  8018f6:	e8 7a fe ff ff       	call   801775 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fe:	90                   	nop
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 0c                	push   $0xc
  801910:	e8 60 fe ff ff       	call   801775 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 0d                	push   $0xd
  80192a:	e8 46 fe ff ff       	call   801775 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 0e                	push   $0xe
  801943:	e8 2d fe ff ff       	call   801775 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	90                   	nop
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 13                	push   $0x13
  80195d:	e8 13 fe ff ff       	call   801775 <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	90                   	nop
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 14                	push   $0x14
  801977:	e8 f9 fd ff ff       	call   801775 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	90                   	nop
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_cputc>:


void
sys_cputc(const char c)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
  801985:	83 ec 04             	sub    $0x4,%esp
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80198e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	50                   	push   %eax
  80199b:	6a 15                	push   $0x15
  80199d:	e8 d3 fd ff ff       	call   801775 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	90                   	nop
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 16                	push   $0x16
  8019b7:	e8 b9 fd ff ff       	call   801775 <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	90                   	nop
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	50                   	push   %eax
  8019d2:	6a 17                	push   $0x17
  8019d4:	e8 9c fd ff ff       	call   801775 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	52                   	push   %edx
  8019ee:	50                   	push   %eax
  8019ef:	6a 1a                	push   $0x1a
  8019f1:	e8 7f fd ff ff       	call   801775 <syscall>
  8019f6:	83 c4 18             	add    $0x18,%esp
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	52                   	push   %edx
  801a0b:	50                   	push   %eax
  801a0c:	6a 18                	push   $0x18
  801a0e:	e8 62 fd ff ff       	call   801775 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	52                   	push   %edx
  801a29:	50                   	push   %eax
  801a2a:	6a 19                	push   $0x19
  801a2c:	e8 44 fd ff ff       	call   801775 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	90                   	nop
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 04             	sub    $0x4,%esp
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a43:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a46:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	51                   	push   %ecx
  801a50:	52                   	push   %edx
  801a51:	ff 75 0c             	pushl  0xc(%ebp)
  801a54:	50                   	push   %eax
  801a55:	6a 1b                	push   $0x1b
  801a57:	e8 19 fd ff ff       	call   801775 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 1c                	push   $0x1c
  801a74:	e8 fc fc ff ff       	call   801775 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a81:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	51                   	push   %ecx
  801a8f:	52                   	push   %edx
  801a90:	50                   	push   %eax
  801a91:	6a 1d                	push   $0x1d
  801a93:	e8 dd fc ff ff       	call   801775 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 1e                	push   $0x1e
  801ab0:	e8 c0 fc ff ff       	call   801775 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 1f                	push   $0x1f
  801ac9:	e8 a7 fc ff ff       	call   801775 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	6a 00                	push   $0x0
  801adb:	ff 75 14             	pushl  0x14(%ebp)
  801ade:	ff 75 10             	pushl  0x10(%ebp)
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	50                   	push   %eax
  801ae5:	6a 20                	push   $0x20
  801ae7:	e8 89 fc ff ff       	call   801775 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	50                   	push   %eax
  801b00:	6a 21                	push   $0x21
  801b02:	e8 6e fc ff ff       	call   801775 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	90                   	nop
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	50                   	push   %eax
  801b1c:	6a 22                	push   $0x22
  801b1e:	e8 52 fc ff ff       	call   801775 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 02                	push   $0x2
  801b37:	e8 39 fc ff ff       	call   801775 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 03                	push   $0x3
  801b50:	e8 20 fc ff ff       	call   801775 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 04                	push   $0x4
  801b69:	e8 07 fc ff ff       	call   801775 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_exit_env>:


void sys_exit_env(void)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 23                	push   $0x23
  801b82:	e8 ee fb ff ff       	call   801775 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
}
  801b8a:	90                   	nop
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b93:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b96:	8d 50 04             	lea    0x4(%eax),%edx
  801b99:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	52                   	push   %edx
  801ba3:	50                   	push   %eax
  801ba4:	6a 24                	push   $0x24
  801ba6:	e8 ca fb ff ff       	call   801775 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
	return result;
  801bae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bb1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bb7:	89 01                	mov    %eax,(%ecx)
  801bb9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	c9                   	leave  
  801bc0:	c2 04 00             	ret    $0x4

00801bc3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	ff 75 10             	pushl  0x10(%ebp)
  801bcd:	ff 75 0c             	pushl  0xc(%ebp)
  801bd0:	ff 75 08             	pushl  0x8(%ebp)
  801bd3:	6a 12                	push   $0x12
  801bd5:	e8 9b fb ff ff       	call   801775 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdd:	90                   	nop
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 25                	push   $0x25
  801bef:	e8 81 fb ff ff       	call   801775 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 04             	sub    $0x4,%esp
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c05:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	50                   	push   %eax
  801c12:	6a 26                	push   $0x26
  801c14:	e8 5c fb ff ff       	call   801775 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1c:	90                   	nop
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <rsttst>:
void rsttst()
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 28                	push   $0x28
  801c2e:	e8 42 fb ff ff       	call   801775 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
	return ;
  801c36:	90                   	nop
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801c42:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c45:	8b 55 18             	mov    0x18(%ebp),%edx
  801c48:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c4c:	52                   	push   %edx
  801c4d:	50                   	push   %eax
  801c4e:	ff 75 10             	pushl  0x10(%ebp)
  801c51:	ff 75 0c             	pushl  0xc(%ebp)
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	6a 27                	push   $0x27
  801c59:	e8 17 fb ff ff       	call   801775 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <chktst>:
void chktst(uint32 n)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	ff 75 08             	pushl  0x8(%ebp)
  801c72:	6a 29                	push   $0x29
  801c74:	e8 fc fa ff ff       	call   801775 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7c:	90                   	nop
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <inctst>:

void inctst()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 2a                	push   $0x2a
  801c8e:	e8 e2 fa ff ff       	call   801775 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <gettst>:
uint32 gettst()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 2b                	push   $0x2b
  801ca8:	e8 c8 fa ff ff       	call   801775 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 2c                	push   $0x2c
  801cc4:	e8 ac fa ff ff       	call   801775 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
  801ccc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ccf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cd3:	75 07                	jne    801cdc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cd5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cda:	eb 05                	jmp    801ce1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 2c                	push   $0x2c
  801cf5:	e8 7b fa ff ff       	call   801775 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
  801cfd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d00:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d04:	75 07                	jne    801d0d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	eb 05                	jmp    801d12 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 2c                	push   $0x2c
  801d26:	e8 4a fa ff ff       	call   801775 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
  801d2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d31:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d35:	75 07                	jne    801d3e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d37:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3c:	eb 05                	jmp    801d43 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 2c                	push   $0x2c
  801d57:	e8 19 fa ff ff       	call   801775 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
  801d5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d62:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d66:	75 07                	jne    801d6f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d68:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6d:	eb 05                	jmp    801d74 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	ff 75 08             	pushl  0x8(%ebp)
  801d84:	6a 2d                	push   $0x2d
  801d86:	e8 ea f9 ff ff       	call   801775 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8e:	90                   	nop
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d95:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801da1:	6a 00                	push   $0x0
  801da3:	53                   	push   %ebx
  801da4:	51                   	push   %ecx
  801da5:	52                   	push   %edx
  801da6:	50                   	push   %eax
  801da7:	6a 2e                	push   $0x2e
  801da9:	e8 c7 f9 ff ff       	call   801775 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	52                   	push   %edx
  801dc6:	50                   	push   %eax
  801dc7:	6a 2f                	push   $0x2f
  801dc9:	e8 a7 f9 ff ff       	call   801775 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dd9:	83 ec 0c             	sub    $0xc,%esp
  801ddc:	68 d0 3e 80 00       	push   $0x803ed0
  801de1:	e8 6b e8 ff ff       	call   800651 <cprintf>
  801de6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801de9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801df0:	83 ec 0c             	sub    $0xc,%esp
  801df3:	68 fc 3e 80 00       	push   $0x803efc
  801df8:	e8 54 e8 ff ff       	call   800651 <cprintf>
  801dfd:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e00:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e04:	a1 38 51 80 00       	mov    0x805138,%eax
  801e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e0c:	eb 56                	jmp    801e64 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e12:	74 1c                	je     801e30 <print_mem_block_lists+0x5d>
  801e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e17:	8b 50 08             	mov    0x8(%eax),%edx
  801e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e23:	8b 40 0c             	mov    0xc(%eax),%eax
  801e26:	01 c8                	add    %ecx,%eax
  801e28:	39 c2                	cmp    %eax,%edx
  801e2a:	73 04                	jae    801e30 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e2c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	8b 50 08             	mov    0x8(%eax),%edx
  801e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e39:	8b 40 0c             	mov    0xc(%eax),%eax
  801e3c:	01 c2                	add    %eax,%edx
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	8b 40 08             	mov    0x8(%eax),%eax
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	52                   	push   %edx
  801e48:	50                   	push   %eax
  801e49:	68 11 3f 80 00       	push   $0x803f11
  801e4e:	e8 fe e7 ff ff       	call   800651 <cprintf>
  801e53:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e5c:	a1 40 51 80 00       	mov    0x805140,%eax
  801e61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e68:	74 07                	je     801e71 <print_mem_block_lists+0x9e>
  801e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6d:	8b 00                	mov    (%eax),%eax
  801e6f:	eb 05                	jmp    801e76 <print_mem_block_lists+0xa3>
  801e71:	b8 00 00 00 00       	mov    $0x0,%eax
  801e76:	a3 40 51 80 00       	mov    %eax,0x805140
  801e7b:	a1 40 51 80 00       	mov    0x805140,%eax
  801e80:	85 c0                	test   %eax,%eax
  801e82:	75 8a                	jne    801e0e <print_mem_block_lists+0x3b>
  801e84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e88:	75 84                	jne    801e0e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e8a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e8e:	75 10                	jne    801ea0 <print_mem_block_lists+0xcd>
  801e90:	83 ec 0c             	sub    $0xc,%esp
  801e93:	68 20 3f 80 00       	push   $0x803f20
  801e98:	e8 b4 e7 ff ff       	call   800651 <cprintf>
  801e9d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ea0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ea7:	83 ec 0c             	sub    $0xc,%esp
  801eaa:	68 44 3f 80 00       	push   $0x803f44
  801eaf:	e8 9d e7 ff ff       	call   800651 <cprintf>
  801eb4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801eb7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ebb:	a1 40 50 80 00       	mov    0x805040,%eax
  801ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec3:	eb 56                	jmp    801f1b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ec5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ec9:	74 1c                	je     801ee7 <print_mem_block_lists+0x114>
  801ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ece:	8b 50 08             	mov    0x8(%eax),%edx
  801ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed4:	8b 48 08             	mov    0x8(%eax),%ecx
  801ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eda:	8b 40 0c             	mov    0xc(%eax),%eax
  801edd:	01 c8                	add    %ecx,%eax
  801edf:	39 c2                	cmp    %eax,%edx
  801ee1:	73 04                	jae    801ee7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ee3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eea:	8b 50 08             	mov    0x8(%eax),%edx
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef3:	01 c2                	add    %eax,%edx
  801ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef8:	8b 40 08             	mov    0x8(%eax),%eax
  801efb:	83 ec 04             	sub    $0x4,%esp
  801efe:	52                   	push   %edx
  801eff:	50                   	push   %eax
  801f00:	68 11 3f 80 00       	push   $0x803f11
  801f05:	e8 47 e7 ff ff       	call   800651 <cprintf>
  801f0a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f13:	a1 48 50 80 00       	mov    0x805048,%eax
  801f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f1f:	74 07                	je     801f28 <print_mem_block_lists+0x155>
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	8b 00                	mov    (%eax),%eax
  801f26:	eb 05                	jmp    801f2d <print_mem_block_lists+0x15a>
  801f28:	b8 00 00 00 00       	mov    $0x0,%eax
  801f2d:	a3 48 50 80 00       	mov    %eax,0x805048
  801f32:	a1 48 50 80 00       	mov    0x805048,%eax
  801f37:	85 c0                	test   %eax,%eax
  801f39:	75 8a                	jne    801ec5 <print_mem_block_lists+0xf2>
  801f3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3f:	75 84                	jne    801ec5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f41:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f45:	75 10                	jne    801f57 <print_mem_block_lists+0x184>
  801f47:	83 ec 0c             	sub    $0xc,%esp
  801f4a:	68 5c 3f 80 00       	push   $0x803f5c
  801f4f:	e8 fd e6 ff ff       	call   800651 <cprintf>
  801f54:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f57:	83 ec 0c             	sub    $0xc,%esp
  801f5a:	68 d0 3e 80 00       	push   $0x803ed0
  801f5f:	e8 ed e6 ff ff       	call   800651 <cprintf>
  801f64:	83 c4 10             	add    $0x10,%esp

}
  801f67:	90                   	nop
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
  801f6d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f70:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f77:	00 00 00 
  801f7a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f81:	00 00 00 
  801f84:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f8b:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f95:	e9 9e 00 00 00       	jmp    802038 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f9a:	a1 50 50 80 00       	mov    0x805050,%eax
  801f9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa2:	c1 e2 04             	shl    $0x4,%edx
  801fa5:	01 d0                	add    %edx,%eax
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	75 14                	jne    801fbf <initialize_MemBlocksList+0x55>
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	68 84 3f 80 00       	push   $0x803f84
  801fb3:	6a 46                	push   $0x46
  801fb5:	68 a7 3f 80 00       	push   $0x803fa7
  801fba:	e8 de e3 ff ff       	call   80039d <_panic>
  801fbf:	a1 50 50 80 00       	mov    0x805050,%eax
  801fc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc7:	c1 e2 04             	shl    $0x4,%edx
  801fca:	01 d0                	add    %edx,%eax
  801fcc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fd2:	89 10                	mov    %edx,(%eax)
  801fd4:	8b 00                	mov    (%eax),%eax
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	74 18                	je     801ff2 <initialize_MemBlocksList+0x88>
  801fda:	a1 48 51 80 00       	mov    0x805148,%eax
  801fdf:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fe5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fe8:	c1 e1 04             	shl    $0x4,%ecx
  801feb:	01 ca                	add    %ecx,%edx
  801fed:	89 50 04             	mov    %edx,0x4(%eax)
  801ff0:	eb 12                	jmp    802004 <initialize_MemBlocksList+0x9a>
  801ff2:	a1 50 50 80 00       	mov    0x805050,%eax
  801ff7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffa:	c1 e2 04             	shl    $0x4,%edx
  801ffd:	01 d0                	add    %edx,%eax
  801fff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802004:	a1 50 50 80 00       	mov    0x805050,%eax
  802009:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200c:	c1 e2 04             	shl    $0x4,%edx
  80200f:	01 d0                	add    %edx,%eax
  802011:	a3 48 51 80 00       	mov    %eax,0x805148
  802016:	a1 50 50 80 00       	mov    0x805050,%eax
  80201b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201e:	c1 e2 04             	shl    $0x4,%edx
  802021:	01 d0                	add    %edx,%eax
  802023:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80202a:	a1 54 51 80 00       	mov    0x805154,%eax
  80202f:	40                   	inc    %eax
  802030:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802035:	ff 45 f4             	incl   -0xc(%ebp)
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80203e:	0f 82 56 ff ff ff    	jb     801f9a <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802044:	90                   	nop
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	8b 00                	mov    (%eax),%eax
  802052:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802055:	eb 19                	jmp    802070 <find_block+0x29>
	{
		if(va==point->sva)
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8b 40 08             	mov    0x8(%eax),%eax
  80205d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802060:	75 05                	jne    802067 <find_block+0x20>
		   return point;
  802062:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802065:	eb 36                	jmp    80209d <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	8b 40 08             	mov    0x8(%eax),%eax
  80206d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802070:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802074:	74 07                	je     80207d <find_block+0x36>
  802076:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802079:	8b 00                	mov    (%eax),%eax
  80207b:	eb 05                	jmp    802082 <find_block+0x3b>
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	8b 55 08             	mov    0x8(%ebp),%edx
  802085:	89 42 08             	mov    %eax,0x8(%edx)
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	8b 40 08             	mov    0x8(%eax),%eax
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 c5                	jne    802057 <find_block+0x10>
  802092:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802096:	75 bf                	jne    802057 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
  8020a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8020aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020ad:	a1 44 50 80 00       	mov    0x805044,%eax
  8020b2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020bb:	74 24                	je     8020e1 <insert_sorted_allocList+0x42>
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	8b 50 08             	mov    0x8(%eax),%edx
  8020c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c6:	8b 40 08             	mov    0x8(%eax),%eax
  8020c9:	39 c2                	cmp    %eax,%edx
  8020cb:	76 14                	jbe    8020e1 <insert_sorted_allocList+0x42>
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 50 08             	mov    0x8(%eax),%edx
  8020d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d6:	8b 40 08             	mov    0x8(%eax),%eax
  8020d9:	39 c2                	cmp    %eax,%edx
  8020db:	0f 82 60 01 00 00    	jb     802241 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e5:	75 65                	jne    80214c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020eb:	75 14                	jne    802101 <insert_sorted_allocList+0x62>
  8020ed:	83 ec 04             	sub    $0x4,%esp
  8020f0:	68 84 3f 80 00       	push   $0x803f84
  8020f5:	6a 6b                	push   $0x6b
  8020f7:	68 a7 3f 80 00       	push   $0x803fa7
  8020fc:	e8 9c e2 ff ff       	call   80039d <_panic>
  802101:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	89 10                	mov    %edx,(%eax)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	8b 00                	mov    (%eax),%eax
  802111:	85 c0                	test   %eax,%eax
  802113:	74 0d                	je     802122 <insert_sorted_allocList+0x83>
  802115:	a1 40 50 80 00       	mov    0x805040,%eax
  80211a:	8b 55 08             	mov    0x8(%ebp),%edx
  80211d:	89 50 04             	mov    %edx,0x4(%eax)
  802120:	eb 08                	jmp    80212a <insert_sorted_allocList+0x8b>
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	a3 44 50 80 00       	mov    %eax,0x805044
  80212a:	8b 45 08             	mov    0x8(%ebp),%eax
  80212d:	a3 40 50 80 00       	mov    %eax,0x805040
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802141:	40                   	inc    %eax
  802142:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802147:	e9 dc 01 00 00       	jmp    802328 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	8b 50 08             	mov    0x8(%eax),%edx
  802152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802155:	8b 40 08             	mov    0x8(%eax),%eax
  802158:	39 c2                	cmp    %eax,%edx
  80215a:	77 6c                	ja     8021c8 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80215c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802160:	74 06                	je     802168 <insert_sorted_allocList+0xc9>
  802162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802166:	75 14                	jne    80217c <insert_sorted_allocList+0xdd>
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	68 c0 3f 80 00       	push   $0x803fc0
  802170:	6a 6f                	push   $0x6f
  802172:	68 a7 3f 80 00       	push   $0x803fa7
  802177:	e8 21 e2 ff ff       	call   80039d <_panic>
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	8b 50 04             	mov    0x4(%eax),%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	89 50 04             	mov    %edx,0x4(%eax)
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80218e:	89 10                	mov    %edx,(%eax)
  802190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802193:	8b 40 04             	mov    0x4(%eax),%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	74 0d                	je     8021a7 <insert_sorted_allocList+0x108>
  80219a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219d:	8b 40 04             	mov    0x4(%eax),%eax
  8021a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a3:	89 10                	mov    %edx,(%eax)
  8021a5:	eb 08                	jmp    8021af <insert_sorted_allocList+0x110>
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	a3 40 50 80 00       	mov    %eax,0x805040
  8021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b5:	89 50 04             	mov    %edx,0x4(%eax)
  8021b8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021bd:	40                   	inc    %eax
  8021be:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021c3:	e9 60 01 00 00       	jmp    802328 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	8b 50 08             	mov    0x8(%eax),%edx
  8021ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021d1:	8b 40 08             	mov    0x8(%eax),%eax
  8021d4:	39 c2                	cmp    %eax,%edx
  8021d6:	0f 82 4c 01 00 00    	jb     802328 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e0:	75 14                	jne    8021f6 <insert_sorted_allocList+0x157>
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	68 f8 3f 80 00       	push   $0x803ff8
  8021ea:	6a 73                	push   $0x73
  8021ec:	68 a7 3f 80 00       	push   $0x803fa7
  8021f1:	e8 a7 e1 ff ff       	call   80039d <_panic>
  8021f6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	89 50 04             	mov    %edx,0x4(%eax)
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	8b 40 04             	mov    0x4(%eax),%eax
  802208:	85 c0                	test   %eax,%eax
  80220a:	74 0c                	je     802218 <insert_sorted_allocList+0x179>
  80220c:	a1 44 50 80 00       	mov    0x805044,%eax
  802211:	8b 55 08             	mov    0x8(%ebp),%edx
  802214:	89 10                	mov    %edx,(%eax)
  802216:	eb 08                	jmp    802220 <insert_sorted_allocList+0x181>
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	a3 40 50 80 00       	mov    %eax,0x805040
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	a3 44 50 80 00       	mov    %eax,0x805044
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802231:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802236:	40                   	inc    %eax
  802237:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80223c:	e9 e7 00 00 00       	jmp    802328 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802244:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802247:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80224e:	a1 40 50 80 00       	mov    0x805040,%eax
  802253:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802256:	e9 9d 00 00 00       	jmp    8022f8 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8b 50 08             	mov    0x8(%eax),%edx
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 40 08             	mov    0x8(%eax),%eax
  80226f:	39 c2                	cmp    %eax,%edx
  802271:	76 7d                	jbe    8022f0 <insert_sorted_allocList+0x251>
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	8b 50 08             	mov    0x8(%eax),%edx
  802279:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80227c:	8b 40 08             	mov    0x8(%eax),%eax
  80227f:	39 c2                	cmp    %eax,%edx
  802281:	73 6d                	jae    8022f0 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802287:	74 06                	je     80228f <insert_sorted_allocList+0x1f0>
  802289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228d:	75 14                	jne    8022a3 <insert_sorted_allocList+0x204>
  80228f:	83 ec 04             	sub    $0x4,%esp
  802292:	68 1c 40 80 00       	push   $0x80401c
  802297:	6a 7f                	push   $0x7f
  802299:	68 a7 3f 80 00       	push   $0x803fa7
  80229e:	e8 fa e0 ff ff       	call   80039d <_panic>
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 10                	mov    (%eax),%edx
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	89 10                	mov    %edx,(%eax)
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	8b 00                	mov    (%eax),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	74 0b                	je     8022c1 <insert_sorted_allocList+0x222>
  8022b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b9:	8b 00                	mov    (%eax),%eax
  8022bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c7:	89 10                	mov    %edx,(%eax)
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	75 08                	jne    8022e3 <insert_sorted_allocList+0x244>
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	a3 44 50 80 00       	mov    %eax,0x805044
  8022e3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e8:	40                   	inc    %eax
  8022e9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022ee:	eb 39                	jmp    802329 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022f0:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fc:	74 07                	je     802305 <insert_sorted_allocList+0x266>
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	8b 00                	mov    (%eax),%eax
  802303:	eb 05                	jmp    80230a <insert_sorted_allocList+0x26b>
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
  80230a:	a3 48 50 80 00       	mov    %eax,0x805048
  80230f:	a1 48 50 80 00       	mov    0x805048,%eax
  802314:	85 c0                	test   %eax,%eax
  802316:	0f 85 3f ff ff ff    	jne    80225b <insert_sorted_allocList+0x1bc>
  80231c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802320:	0f 85 35 ff ff ff    	jne    80225b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802326:	eb 01                	jmp    802329 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802328:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802329:	90                   	nop
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802332:	a1 38 51 80 00       	mov    0x805138,%eax
  802337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80233a:	e9 85 01 00 00       	jmp    8024c4 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 40 0c             	mov    0xc(%eax),%eax
  802345:	3b 45 08             	cmp    0x8(%ebp),%eax
  802348:	0f 82 6e 01 00 00    	jb     8024bc <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80234e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802351:	8b 40 0c             	mov    0xc(%eax),%eax
  802354:	3b 45 08             	cmp    0x8(%ebp),%eax
  802357:	0f 85 8a 00 00 00    	jne    8023e7 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80235d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802361:	75 17                	jne    80237a <alloc_block_FF+0x4e>
  802363:	83 ec 04             	sub    $0x4,%esp
  802366:	68 50 40 80 00       	push   $0x804050
  80236b:	68 93 00 00 00       	push   $0x93
  802370:	68 a7 3f 80 00       	push   $0x803fa7
  802375:	e8 23 e0 ff ff       	call   80039d <_panic>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 00                	mov    (%eax),%eax
  80237f:	85 c0                	test   %eax,%eax
  802381:	74 10                	je     802393 <alloc_block_FF+0x67>
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 00                	mov    (%eax),%eax
  802388:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238b:	8b 52 04             	mov    0x4(%edx),%edx
  80238e:	89 50 04             	mov    %edx,0x4(%eax)
  802391:	eb 0b                	jmp    80239e <alloc_block_FF+0x72>
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 40 04             	mov    0x4(%eax),%eax
  802399:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 04             	mov    0x4(%eax),%eax
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	74 0f                	je     8023b7 <alloc_block_FF+0x8b>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 40 04             	mov    0x4(%eax),%eax
  8023ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b1:	8b 12                	mov    (%edx),%edx
  8023b3:	89 10                	mov    %edx,(%eax)
  8023b5:	eb 0a                	jmp    8023c1 <alloc_block_FF+0x95>
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 00                	mov    (%eax),%eax
  8023bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d4:	a1 44 51 80 00       	mov    0x805144,%eax
  8023d9:	48                   	dec    %eax
  8023da:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	e9 10 01 00 00       	jmp    8024f7 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f0:	0f 86 c6 00 00 00    	jbe    8024bc <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8023fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802401:	8b 50 08             	mov    0x8(%eax),%edx
  802404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802407:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240d:	8b 55 08             	mov    0x8(%ebp),%edx
  802410:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802413:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802417:	75 17                	jne    802430 <alloc_block_FF+0x104>
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	68 50 40 80 00       	push   $0x804050
  802421:	68 9b 00 00 00       	push   $0x9b
  802426:	68 a7 3f 80 00       	push   $0x803fa7
  80242b:	e8 6d df ff ff       	call   80039d <_panic>
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 10                	je     802449 <alloc_block_FF+0x11d>
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802441:	8b 52 04             	mov    0x4(%edx),%edx
  802444:	89 50 04             	mov    %edx,0x4(%eax)
  802447:	eb 0b                	jmp    802454 <alloc_block_FF+0x128>
  802449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244c:	8b 40 04             	mov    0x4(%eax),%eax
  80244f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 0f                	je     80246d <alloc_block_FF+0x141>
  80245e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802467:	8b 12                	mov    (%edx),%edx
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	eb 0a                	jmp    802477 <alloc_block_FF+0x14b>
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	a3 48 51 80 00       	mov    %eax,0x805148
  802477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248a:	a1 54 51 80 00       	mov    0x805154,%eax
  80248f:	48                   	dec    %eax
  802490:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 50 08             	mov    0x8(%eax),%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	01 c2                	add    %eax,%edx
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ac:	2b 45 08             	sub    0x8(%ebp),%eax
  8024af:	89 c2                	mov    %eax,%edx
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ba:	eb 3b                	jmp    8024f7 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8024c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c8:	74 07                	je     8024d1 <alloc_block_FF+0x1a5>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	eb 05                	jmp    8024d6 <alloc_block_FF+0x1aa>
  8024d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8024db:	a1 40 51 80 00       	mov    0x805140,%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	0f 85 57 fe ff ff    	jne    80233f <alloc_block_FF+0x13>
  8024e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ec:	0f 85 4d fe ff ff    	jne    80233f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024ff:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802506:	a1 38 51 80 00       	mov    0x805138,%eax
  80250b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250e:	e9 df 00 00 00       	jmp    8025f2 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 40 0c             	mov    0xc(%eax),%eax
  802519:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251c:	0f 82 c8 00 00 00    	jb     8025ea <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 40 0c             	mov    0xc(%eax),%eax
  802528:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252b:	0f 85 8a 00 00 00    	jne    8025bb <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802531:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802535:	75 17                	jne    80254e <alloc_block_BF+0x55>
  802537:	83 ec 04             	sub    $0x4,%esp
  80253a:	68 50 40 80 00       	push   $0x804050
  80253f:	68 b7 00 00 00       	push   $0xb7
  802544:	68 a7 3f 80 00       	push   $0x803fa7
  802549:	e8 4f de ff ff       	call   80039d <_panic>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 00                	mov    (%eax),%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	74 10                	je     802567 <alloc_block_BF+0x6e>
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255f:	8b 52 04             	mov    0x4(%edx),%edx
  802562:	89 50 04             	mov    %edx,0x4(%eax)
  802565:	eb 0b                	jmp    802572 <alloc_block_BF+0x79>
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 40 04             	mov    0x4(%eax),%eax
  80256d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 0f                	je     80258b <alloc_block_BF+0x92>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 40 04             	mov    0x4(%eax),%eax
  802582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802585:	8b 12                	mov    (%edx),%edx
  802587:	89 10                	mov    %edx,(%eax)
  802589:	eb 0a                	jmp    802595 <alloc_block_BF+0x9c>
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	a3 38 51 80 00       	mov    %eax,0x805138
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8025ad:	48                   	dec    %eax
  8025ae:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	e9 4d 01 00 00       	jmp    802708 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c4:	76 24                	jbe    8025ea <alloc_block_BF+0xf1>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025cf:	73 19                	jae    8025ea <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025d1:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 0c             	mov    0xc(%eax),%eax
  8025de:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 08             	mov    0x8(%eax),%eax
  8025e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025ea:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f6:	74 07                	je     8025ff <alloc_block_BF+0x106>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	eb 05                	jmp    802604 <alloc_block_BF+0x10b>
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802604:	a3 40 51 80 00       	mov    %eax,0x805140
  802609:	a1 40 51 80 00       	mov    0x805140,%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	0f 85 fd fe ff ff    	jne    802513 <alloc_block_BF+0x1a>
  802616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261a:	0f 85 f3 fe ff ff    	jne    802513 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802620:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802624:	0f 84 d9 00 00 00    	je     802703 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80262a:	a1 48 51 80 00       	mov    0x805148,%eax
  80262f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802635:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802638:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80263b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263e:	8b 55 08             	mov    0x8(%ebp),%edx
  802641:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802644:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802648:	75 17                	jne    802661 <alloc_block_BF+0x168>
  80264a:	83 ec 04             	sub    $0x4,%esp
  80264d:	68 50 40 80 00       	push   $0x804050
  802652:	68 c7 00 00 00       	push   $0xc7
  802657:	68 a7 3f 80 00       	push   $0x803fa7
  80265c:	e8 3c dd ff ff       	call   80039d <_panic>
  802661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	85 c0                	test   %eax,%eax
  802668:	74 10                	je     80267a <alloc_block_BF+0x181>
  80266a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266d:	8b 00                	mov    (%eax),%eax
  80266f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802672:	8b 52 04             	mov    0x4(%edx),%edx
  802675:	89 50 04             	mov    %edx,0x4(%eax)
  802678:	eb 0b                	jmp    802685 <alloc_block_BF+0x18c>
  80267a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267d:	8b 40 04             	mov    0x4(%eax),%eax
  802680:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 0f                	je     80269e <alloc_block_BF+0x1a5>
  80268f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802692:	8b 40 04             	mov    0x4(%eax),%eax
  802695:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802698:	8b 12                	mov    (%edx),%edx
  80269a:	89 10                	mov    %edx,(%eax)
  80269c:	eb 0a                	jmp    8026a8 <alloc_block_BF+0x1af>
  80269e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	a3 48 51 80 00       	mov    %eax,0x805148
  8026a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8026c0:	48                   	dec    %eax
  8026c1:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026c6:	83 ec 08             	sub    $0x8,%esp
  8026c9:	ff 75 ec             	pushl  -0x14(%ebp)
  8026cc:	68 38 51 80 00       	push   $0x805138
  8026d1:	e8 71 f9 ff ff       	call   802047 <find_block>
  8026d6:	83 c4 10             	add    $0x10,%esp
  8026d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026df:	8b 50 08             	mov    0x8(%eax),%edx
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	01 c2                	add    %eax,%edx
  8026e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ea:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8026f6:	89 c2                	mov    %eax,%edx
  8026f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fb:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802701:	eb 05                	jmp    802708 <alloc_block_BF+0x20f>
	}
	return NULL;
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    

0080270a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80270a:	55                   	push   %ebp
  80270b:	89 e5                	mov    %esp,%ebp
  80270d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802710:	a1 28 50 80 00       	mov    0x805028,%eax
  802715:	85 c0                	test   %eax,%eax
  802717:	0f 85 de 01 00 00    	jne    8028fb <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80271d:	a1 38 51 80 00       	mov    0x805138,%eax
  802722:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802725:	e9 9e 01 00 00       	jmp    8028c8 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 40 0c             	mov    0xc(%eax),%eax
  802730:	3b 45 08             	cmp    0x8(%ebp),%eax
  802733:	0f 82 87 01 00 00    	jb     8028c0 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 40 0c             	mov    0xc(%eax),%eax
  80273f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802742:	0f 85 95 00 00 00    	jne    8027dd <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802748:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274c:	75 17                	jne    802765 <alloc_block_NF+0x5b>
  80274e:	83 ec 04             	sub    $0x4,%esp
  802751:	68 50 40 80 00       	push   $0x804050
  802756:	68 e0 00 00 00       	push   $0xe0
  80275b:	68 a7 3f 80 00       	push   $0x803fa7
  802760:	e8 38 dc ff ff       	call   80039d <_panic>
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 00                	mov    (%eax),%eax
  80276a:	85 c0                	test   %eax,%eax
  80276c:	74 10                	je     80277e <alloc_block_NF+0x74>
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802776:	8b 52 04             	mov    0x4(%edx),%edx
  802779:	89 50 04             	mov    %edx,0x4(%eax)
  80277c:	eb 0b                	jmp    802789 <alloc_block_NF+0x7f>
  80277e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802781:	8b 40 04             	mov    0x4(%eax),%eax
  802784:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 40 04             	mov    0x4(%eax),%eax
  80278f:	85 c0                	test   %eax,%eax
  802791:	74 0f                	je     8027a2 <alloc_block_NF+0x98>
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 40 04             	mov    0x4(%eax),%eax
  802799:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279c:	8b 12                	mov    (%edx),%edx
  80279e:	89 10                	mov    %edx,(%eax)
  8027a0:	eb 0a                	jmp    8027ac <alloc_block_NF+0xa2>
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 00                	mov    (%eax),%eax
  8027a7:	a3 38 51 80 00       	mov    %eax,0x805138
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8027c4:	48                   	dec    %eax
  8027c5:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 40 08             	mov    0x8(%eax),%eax
  8027d0:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	e9 f8 04 00 00       	jmp    802cd5 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e6:	0f 86 d4 00 00 00    	jbe    8028c0 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8027f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 50 08             	mov    0x8(%eax),%edx
  8027fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fd:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	8b 55 08             	mov    0x8(%ebp),%edx
  802806:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802809:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280d:	75 17                	jne    802826 <alloc_block_NF+0x11c>
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	68 50 40 80 00       	push   $0x804050
  802817:	68 e9 00 00 00       	push   $0xe9
  80281c:	68 a7 3f 80 00       	push   $0x803fa7
  802821:	e8 77 db ff ff       	call   80039d <_panic>
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	74 10                	je     80283f <alloc_block_NF+0x135>
  80282f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802837:	8b 52 04             	mov    0x4(%edx),%edx
  80283a:	89 50 04             	mov    %edx,0x4(%eax)
  80283d:	eb 0b                	jmp    80284a <alloc_block_NF+0x140>
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80284a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284d:	8b 40 04             	mov    0x4(%eax),%eax
  802850:	85 c0                	test   %eax,%eax
  802852:	74 0f                	je     802863 <alloc_block_NF+0x159>
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 40 04             	mov    0x4(%eax),%eax
  80285a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285d:	8b 12                	mov    (%edx),%edx
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	eb 0a                	jmp    80286d <alloc_block_NF+0x163>
  802863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802866:	8b 00                	mov    (%eax),%eax
  802868:	a3 48 51 80 00       	mov    %eax,0x805148
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802880:	a1 54 51 80 00       	mov    0x805154,%eax
  802885:	48                   	dec    %eax
  802886:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80288b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288e:	8b 40 08             	mov    0x8(%eax),%eax
  802891:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 50 08             	mov    0x8(%eax),%edx
  80289c:	8b 45 08             	mov    0x8(%ebp),%eax
  80289f:	01 c2                	add    %eax,%edx
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ad:	2b 45 08             	sub    0x8(%ebp),%eax
  8028b0:	89 c2                	mov    %eax,%edx
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bb:	e9 15 04 00 00       	jmp    802cd5 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8028c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028cc:	74 07                	je     8028d5 <alloc_block_NF+0x1cb>
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 00                	mov    (%eax),%eax
  8028d3:	eb 05                	jmp    8028da <alloc_block_NF+0x1d0>
  8028d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028da:	a3 40 51 80 00       	mov    %eax,0x805140
  8028df:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	0f 85 3e fe ff ff    	jne    80272a <alloc_block_NF+0x20>
  8028ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f0:	0f 85 34 fe ff ff    	jne    80272a <alloc_block_NF+0x20>
  8028f6:	e9 d5 03 00 00       	jmp    802cd0 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028fb:	a1 38 51 80 00       	mov    0x805138,%eax
  802900:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802903:	e9 b1 01 00 00       	jmp    802ab9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 50 08             	mov    0x8(%eax),%edx
  80290e:	a1 28 50 80 00       	mov    0x805028,%eax
  802913:	39 c2                	cmp    %eax,%edx
  802915:	0f 82 96 01 00 00    	jb     802ab1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 40 0c             	mov    0xc(%eax),%eax
  802921:	3b 45 08             	cmp    0x8(%ebp),%eax
  802924:	0f 82 87 01 00 00    	jb     802ab1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 40 0c             	mov    0xc(%eax),%eax
  802930:	3b 45 08             	cmp    0x8(%ebp),%eax
  802933:	0f 85 95 00 00 00    	jne    8029ce <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	75 17                	jne    802956 <alloc_block_NF+0x24c>
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	68 50 40 80 00       	push   $0x804050
  802947:	68 fc 00 00 00       	push   $0xfc
  80294c:	68 a7 3f 80 00       	push   $0x803fa7
  802951:	e8 47 da ff ff       	call   80039d <_panic>
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	74 10                	je     80296f <alloc_block_NF+0x265>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802967:	8b 52 04             	mov    0x4(%edx),%edx
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	eb 0b                	jmp    80297a <alloc_block_NF+0x270>
  80296f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802972:	8b 40 04             	mov    0x4(%eax),%eax
  802975:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 04             	mov    0x4(%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	74 0f                	je     802993 <alloc_block_NF+0x289>
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298d:	8b 12                	mov    (%edx),%edx
  80298f:	89 10                	mov    %edx,(%eax)
  802991:	eb 0a                	jmp    80299d <alloc_block_NF+0x293>
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 00                	mov    (%eax),%eax
  802998:	a3 38 51 80 00       	mov    %eax,0x805138
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b5:	48                   	dec    %eax
  8029b6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 40 08             	mov    0x8(%eax),%eax
  8029c1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	e9 07 03 00 00       	jmp    802cd5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d7:	0f 86 d4 00 00 00    	jbe    802ab1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029dd:	a1 48 51 80 00       	mov    0x805148,%eax
  8029e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	8b 50 08             	mov    0x8(%eax),%edx
  8029eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ee:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029fe:	75 17                	jne    802a17 <alloc_block_NF+0x30d>
  802a00:	83 ec 04             	sub    $0x4,%esp
  802a03:	68 50 40 80 00       	push   $0x804050
  802a08:	68 04 01 00 00       	push   $0x104
  802a0d:	68 a7 3f 80 00       	push   $0x803fa7
  802a12:	e8 86 d9 ff ff       	call   80039d <_panic>
  802a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	74 10                	je     802a30 <alloc_block_NF+0x326>
  802a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a28:	8b 52 04             	mov    0x4(%edx),%edx
  802a2b:	89 50 04             	mov    %edx,0x4(%eax)
  802a2e:	eb 0b                	jmp    802a3b <alloc_block_NF+0x331>
  802a30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3e:	8b 40 04             	mov    0x4(%eax),%eax
  802a41:	85 c0                	test   %eax,%eax
  802a43:	74 0f                	je     802a54 <alloc_block_NF+0x34a>
  802a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a48:	8b 40 04             	mov    0x4(%eax),%eax
  802a4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a4e:	8b 12                	mov    (%edx),%edx
  802a50:	89 10                	mov    %edx,(%eax)
  802a52:	eb 0a                	jmp    802a5e <alloc_block_NF+0x354>
  802a54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a57:	8b 00                	mov    (%eax),%eax
  802a59:	a3 48 51 80 00       	mov    %eax,0x805148
  802a5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a71:	a1 54 51 80 00       	mov    0x805154,%eax
  802a76:	48                   	dec    %eax
  802a77:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7f:	8b 40 08             	mov    0x8(%eax),%eax
  802a82:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 50 08             	mov    0x8(%eax),%edx
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	01 c2                	add    %eax,%edx
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a9e:	2b 45 08             	sub    0x8(%ebp),%eax
  802aa1:	89 c2                	mov    %eax,%edx
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802aa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aac:	e9 24 02 00 00       	jmp    802cd5 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ab1:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abd:	74 07                	je     802ac6 <alloc_block_NF+0x3bc>
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	eb 05                	jmp    802acb <alloc_block_NF+0x3c1>
  802ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  802acb:	a3 40 51 80 00       	mov    %eax,0x805140
  802ad0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	0f 85 2b fe ff ff    	jne    802908 <alloc_block_NF+0x1fe>
  802add:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae1:	0f 85 21 fe ff ff    	jne    802908 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ae7:	a1 38 51 80 00       	mov    0x805138,%eax
  802aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aef:	e9 ae 01 00 00       	jmp    802ca2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	a1 28 50 80 00       	mov    0x805028,%eax
  802aff:	39 c2                	cmp    %eax,%edx
  802b01:	0f 83 93 01 00 00    	jae    802c9a <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b10:	0f 82 84 01 00 00    	jb     802c9a <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1f:	0f 85 95 00 00 00    	jne    802bba <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b29:	75 17                	jne    802b42 <alloc_block_NF+0x438>
  802b2b:	83 ec 04             	sub    $0x4,%esp
  802b2e:	68 50 40 80 00       	push   $0x804050
  802b33:	68 14 01 00 00       	push   $0x114
  802b38:	68 a7 3f 80 00       	push   $0x803fa7
  802b3d:	e8 5b d8 ff ff       	call   80039d <_panic>
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 10                	je     802b5b <alloc_block_NF+0x451>
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b53:	8b 52 04             	mov    0x4(%edx),%edx
  802b56:	89 50 04             	mov    %edx,0x4(%eax)
  802b59:	eb 0b                	jmp    802b66 <alloc_block_NF+0x45c>
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	8b 40 04             	mov    0x4(%eax),%eax
  802b61:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 04             	mov    0x4(%eax),%eax
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	74 0f                	je     802b7f <alloc_block_NF+0x475>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b79:	8b 12                	mov    (%edx),%edx
  802b7b:	89 10                	mov    %edx,(%eax)
  802b7d:	eb 0a                	jmp    802b89 <alloc_block_NF+0x47f>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 00                	mov    (%eax),%eax
  802b84:	a3 38 51 80 00       	mov    %eax,0x805138
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9c:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba1:	48                   	dec    %eax
  802ba2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 40 08             	mov    0x8(%eax),%eax
  802bad:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	e9 1b 01 00 00       	jmp    802cd5 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc3:	0f 86 d1 00 00 00    	jbe    802c9a <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bc9:	a1 48 51 80 00       	mov    0x805148,%eax
  802bce:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 50 08             	mov    0x8(%eax),%edx
  802bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bda:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	8b 55 08             	mov    0x8(%ebp),%edx
  802be3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802be6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bea:	75 17                	jne    802c03 <alloc_block_NF+0x4f9>
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	68 50 40 80 00       	push   $0x804050
  802bf4:	68 1c 01 00 00       	push   $0x11c
  802bf9:	68 a7 3f 80 00       	push   $0x803fa7
  802bfe:	e8 9a d7 ff ff       	call   80039d <_panic>
  802c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 10                	je     802c1c <alloc_block_NF+0x512>
  802c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0f:	8b 00                	mov    (%eax),%eax
  802c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c14:	8b 52 04             	mov    0x4(%edx),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	eb 0b                	jmp    802c27 <alloc_block_NF+0x51d>
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0f                	je     802c40 <alloc_block_NF+0x536>
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	8b 40 04             	mov    0x4(%eax),%eax
  802c37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3a:	8b 12                	mov    (%edx),%edx
  802c3c:	89 10                	mov    %edx,(%eax)
  802c3e:	eb 0a                	jmp    802c4a <alloc_block_NF+0x540>
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	a3 48 51 80 00       	mov    %eax,0x805148
  802c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5d:	a1 54 51 80 00       	mov    0x805154,%eax
  802c62:	48                   	dec    %eax
  802c63:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6b:	8b 40 08             	mov    0x8(%eax),%eax
  802c6e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 50 08             	mov    0x8(%eax),%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	01 c2                	add    %eax,%edx
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8a:	2b 45 08             	sub    0x8(%ebp),%eax
  802c8d:	89 c2                	mov    %eax,%edx
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c98:	eb 3b                	jmp    802cd5 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca6:	74 07                	je     802caf <alloc_block_NF+0x5a5>
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	eb 05                	jmp    802cb4 <alloc_block_NF+0x5aa>
  802caf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb4:	a3 40 51 80 00       	mov    %eax,0x805140
  802cb9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	0f 85 2e fe ff ff    	jne    802af4 <alloc_block_NF+0x3ea>
  802cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cca:	0f 85 24 fe ff ff    	jne    802af4 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cd5:	c9                   	leave  
  802cd6:	c3                   	ret    

00802cd7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cd7:	55                   	push   %ebp
  802cd8:	89 e5                	mov    %esp,%ebp
  802cda:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cdd:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ce5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cea:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ced:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf2:	85 c0                	test   %eax,%eax
  802cf4:	74 14                	je     802d0a <insert_sorted_with_merge_freeList+0x33>
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	8b 50 08             	mov    0x8(%eax),%edx
  802cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cff:	8b 40 08             	mov    0x8(%eax),%eax
  802d02:	39 c2                	cmp    %eax,%edx
  802d04:	0f 87 9b 01 00 00    	ja     802ea5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0e:	75 17                	jne    802d27 <insert_sorted_with_merge_freeList+0x50>
  802d10:	83 ec 04             	sub    $0x4,%esp
  802d13:	68 84 3f 80 00       	push   $0x803f84
  802d18:	68 38 01 00 00       	push   $0x138
  802d1d:	68 a7 3f 80 00       	push   $0x803fa7
  802d22:	e8 76 d6 ff ff       	call   80039d <_panic>
  802d27:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	89 10                	mov    %edx,(%eax)
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 00                	mov    (%eax),%eax
  802d37:	85 c0                	test   %eax,%eax
  802d39:	74 0d                	je     802d48 <insert_sorted_with_merge_freeList+0x71>
  802d3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d40:	8b 55 08             	mov    0x8(%ebp),%edx
  802d43:	89 50 04             	mov    %edx,0x4(%eax)
  802d46:	eb 08                	jmp    802d50 <insert_sorted_with_merge_freeList+0x79>
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	a3 38 51 80 00       	mov    %eax,0x805138
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d62:	a1 44 51 80 00       	mov    0x805144,%eax
  802d67:	40                   	inc    %eax
  802d68:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d71:	0f 84 a8 06 00 00    	je     80341f <insert_sorted_with_merge_freeList+0x748>
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	8b 50 08             	mov    0x8(%eax),%edx
  802d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d80:	8b 40 0c             	mov    0xc(%eax),%eax
  802d83:	01 c2                	add    %eax,%edx
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	8b 40 08             	mov    0x8(%eax),%eax
  802d8b:	39 c2                	cmp    %eax,%edx
  802d8d:	0f 85 8c 06 00 00    	jne    80341f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	8b 50 0c             	mov    0xc(%eax),%edx
  802d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9f:	01 c2                	add    %eax,%edx
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802da7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dab:	75 17                	jne    802dc4 <insert_sorted_with_merge_freeList+0xed>
  802dad:	83 ec 04             	sub    $0x4,%esp
  802db0:	68 50 40 80 00       	push   $0x804050
  802db5:	68 3c 01 00 00       	push   $0x13c
  802dba:	68 a7 3f 80 00       	push   $0x803fa7
  802dbf:	e8 d9 d5 ff ff       	call   80039d <_panic>
  802dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	85 c0                	test   %eax,%eax
  802dcb:	74 10                	je     802ddd <insert_sorted_with_merge_freeList+0x106>
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	8b 00                	mov    (%eax),%eax
  802dd2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dd5:	8b 52 04             	mov    0x4(%edx),%edx
  802dd8:	89 50 04             	mov    %edx,0x4(%eax)
  802ddb:	eb 0b                	jmp    802de8 <insert_sorted_with_merge_freeList+0x111>
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	8b 40 04             	mov    0x4(%eax),%eax
  802de3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802deb:	8b 40 04             	mov    0x4(%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 0f                	je     802e01 <insert_sorted_with_merge_freeList+0x12a>
  802df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df5:	8b 40 04             	mov    0x4(%eax),%eax
  802df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dfb:	8b 12                	mov    (%edx),%edx
  802dfd:	89 10                	mov    %edx,(%eax)
  802dff:	eb 0a                	jmp    802e0b <insert_sorted_with_merge_freeList+0x134>
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	a3 38 51 80 00       	mov    %eax,0x805138
  802e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e23:	48                   	dec    %eax
  802e24:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e41:	75 17                	jne    802e5a <insert_sorted_with_merge_freeList+0x183>
  802e43:	83 ec 04             	sub    $0x4,%esp
  802e46:	68 84 3f 80 00       	push   $0x803f84
  802e4b:	68 3f 01 00 00       	push   $0x13f
  802e50:	68 a7 3f 80 00       	push   $0x803fa7
  802e55:	e8 43 d5 ff ff       	call   80039d <_panic>
  802e5a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e63:	89 10                	mov    %edx,(%eax)
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	85 c0                	test   %eax,%eax
  802e6c:	74 0d                	je     802e7b <insert_sorted_with_merge_freeList+0x1a4>
  802e6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e76:	89 50 04             	mov    %edx,0x4(%eax)
  802e79:	eb 08                	jmp    802e83 <insert_sorted_with_merge_freeList+0x1ac>
  802e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e86:	a3 48 51 80 00       	mov    %eax,0x805148
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e95:	a1 54 51 80 00       	mov    0x805154,%eax
  802e9a:	40                   	inc    %eax
  802e9b:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ea0:	e9 7a 05 00 00       	jmp    80341f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	8b 50 08             	mov    0x8(%eax),%edx
  802eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eae:	8b 40 08             	mov    0x8(%eax),%eax
  802eb1:	39 c2                	cmp    %eax,%edx
  802eb3:	0f 82 14 01 00 00    	jb     802fcd <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebc:	8b 50 08             	mov    0x8(%eax),%edx
  802ebf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec5:	01 c2                	add    %eax,%edx
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	8b 40 08             	mov    0x8(%eax),%eax
  802ecd:	39 c2                	cmp    %eax,%edx
  802ecf:	0f 85 90 00 00 00    	jne    802f65 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed8:	8b 50 0c             	mov    0xc(%eax),%edx
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee1:	01 c2                	add    %eax,%edx
  802ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee6:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802efd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f01:	75 17                	jne    802f1a <insert_sorted_with_merge_freeList+0x243>
  802f03:	83 ec 04             	sub    $0x4,%esp
  802f06:	68 84 3f 80 00       	push   $0x803f84
  802f0b:	68 49 01 00 00       	push   $0x149
  802f10:	68 a7 3f 80 00       	push   $0x803fa7
  802f15:	e8 83 d4 ff ff       	call   80039d <_panic>
  802f1a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	89 10                	mov    %edx,(%eax)
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 00                	mov    (%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	74 0d                	je     802f3b <insert_sorted_with_merge_freeList+0x264>
  802f2e:	a1 48 51 80 00       	mov    0x805148,%eax
  802f33:	8b 55 08             	mov    0x8(%ebp),%edx
  802f36:	89 50 04             	mov    %edx,0x4(%eax)
  802f39:	eb 08                	jmp    802f43 <insert_sorted_with_merge_freeList+0x26c>
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	a3 48 51 80 00       	mov    %eax,0x805148
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f55:	a1 54 51 80 00       	mov    0x805154,%eax
  802f5a:	40                   	inc    %eax
  802f5b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f60:	e9 bb 04 00 00       	jmp    803420 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f69:	75 17                	jne    802f82 <insert_sorted_with_merge_freeList+0x2ab>
  802f6b:	83 ec 04             	sub    $0x4,%esp
  802f6e:	68 f8 3f 80 00       	push   $0x803ff8
  802f73:	68 4c 01 00 00       	push   $0x14c
  802f78:	68 a7 3f 80 00       	push   $0x803fa7
  802f7d:	e8 1b d4 ff ff       	call   80039d <_panic>
  802f82:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	89 50 04             	mov    %edx,0x4(%eax)
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	8b 40 04             	mov    0x4(%eax),%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	74 0c                	je     802fa4 <insert_sorted_with_merge_freeList+0x2cd>
  802f98:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa0:	89 10                	mov    %edx,(%eax)
  802fa2:	eb 08                	jmp    802fac <insert_sorted_with_merge_freeList+0x2d5>
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	a3 38 51 80 00       	mov    %eax,0x805138
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbd:	a1 44 51 80 00       	mov    0x805144,%eax
  802fc2:	40                   	inc    %eax
  802fc3:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fc8:	e9 53 04 00 00       	jmp    803420 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fcd:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd5:	e9 15 04 00 00       	jmp    8033ef <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 00                	mov    (%eax),%eax
  802fdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	8b 50 08             	mov    0x8(%eax),%edx
  802fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802feb:	8b 40 08             	mov    0x8(%eax),%eax
  802fee:	39 c2                	cmp    %eax,%edx
  802ff0:	0f 86 f1 03 00 00    	jbe    8033e7 <insert_sorted_with_merge_freeList+0x710>
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 50 08             	mov    0x8(%eax),%edx
  802ffc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fff:	8b 40 08             	mov    0x8(%eax),%eax
  803002:	39 c2                	cmp    %eax,%edx
  803004:	0f 83 dd 03 00 00    	jae    8033e7 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 50 08             	mov    0x8(%eax),%edx
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 40 0c             	mov    0xc(%eax),%eax
  803016:	01 c2                	add    %eax,%edx
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	8b 40 08             	mov    0x8(%eax),%eax
  80301e:	39 c2                	cmp    %eax,%edx
  803020:	0f 85 b9 01 00 00    	jne    8031df <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	8b 50 08             	mov    0x8(%eax),%edx
  80302c:	8b 45 08             	mov    0x8(%ebp),%eax
  80302f:	8b 40 0c             	mov    0xc(%eax),%eax
  803032:	01 c2                	add    %eax,%edx
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	8b 40 08             	mov    0x8(%eax),%eax
  80303a:	39 c2                	cmp    %eax,%edx
  80303c:	0f 85 0d 01 00 00    	jne    80314f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 50 0c             	mov    0xc(%eax),%edx
  803048:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304b:	8b 40 0c             	mov    0xc(%eax),%eax
  80304e:	01 c2                	add    %eax,%edx
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803056:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80305a:	75 17                	jne    803073 <insert_sorted_with_merge_freeList+0x39c>
  80305c:	83 ec 04             	sub    $0x4,%esp
  80305f:	68 50 40 80 00       	push   $0x804050
  803064:	68 5c 01 00 00       	push   $0x15c
  803069:	68 a7 3f 80 00       	push   $0x803fa7
  80306e:	e8 2a d3 ff ff       	call   80039d <_panic>
  803073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	74 10                	je     80308c <insert_sorted_with_merge_freeList+0x3b5>
  80307c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307f:	8b 00                	mov    (%eax),%eax
  803081:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803084:	8b 52 04             	mov    0x4(%edx),%edx
  803087:	89 50 04             	mov    %edx,0x4(%eax)
  80308a:	eb 0b                	jmp    803097 <insert_sorted_with_merge_freeList+0x3c0>
  80308c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308f:	8b 40 04             	mov    0x4(%eax),%eax
  803092:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803097:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309a:	8b 40 04             	mov    0x4(%eax),%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	74 0f                	je     8030b0 <insert_sorted_with_merge_freeList+0x3d9>
  8030a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a4:	8b 40 04             	mov    0x4(%eax),%eax
  8030a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030aa:	8b 12                	mov    (%edx),%edx
  8030ac:	89 10                	mov    %edx,(%eax)
  8030ae:	eb 0a                	jmp    8030ba <insert_sorted_with_merge_freeList+0x3e3>
  8030b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030cd:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d2:	48                   	dec    %eax
  8030d3:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030f0:	75 17                	jne    803109 <insert_sorted_with_merge_freeList+0x432>
  8030f2:	83 ec 04             	sub    $0x4,%esp
  8030f5:	68 84 3f 80 00       	push   $0x803f84
  8030fa:	68 5f 01 00 00       	push   $0x15f
  8030ff:	68 a7 3f 80 00       	push   $0x803fa7
  803104:	e8 94 d2 ff ff       	call   80039d <_panic>
  803109:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80310f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803112:	89 10                	mov    %edx,(%eax)
  803114:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803117:	8b 00                	mov    (%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 0d                	je     80312a <insert_sorted_with_merge_freeList+0x453>
  80311d:	a1 48 51 80 00       	mov    0x805148,%eax
  803122:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803125:	89 50 04             	mov    %edx,0x4(%eax)
  803128:	eb 08                	jmp    803132 <insert_sorted_with_merge_freeList+0x45b>
  80312a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803135:	a3 48 51 80 00       	mov    %eax,0x805148
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803144:	a1 54 51 80 00       	mov    0x805154,%eax
  803149:	40                   	inc    %eax
  80314a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 50 0c             	mov    0xc(%eax),%edx
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	01 c2                	add    %eax,%edx
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803177:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317b:	75 17                	jne    803194 <insert_sorted_with_merge_freeList+0x4bd>
  80317d:	83 ec 04             	sub    $0x4,%esp
  803180:	68 84 3f 80 00       	push   $0x803f84
  803185:	68 64 01 00 00       	push   $0x164
  80318a:	68 a7 3f 80 00       	push   $0x803fa7
  80318f:	e8 09 d2 ff ff       	call   80039d <_panic>
  803194:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	89 10                	mov    %edx,(%eax)
  80319f:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	74 0d                	je     8031b5 <insert_sorted_with_merge_freeList+0x4de>
  8031a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b0:	89 50 04             	mov    %edx,0x4(%eax)
  8031b3:	eb 08                	jmp    8031bd <insert_sorted_with_merge_freeList+0x4e6>
  8031b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8031d4:	40                   	inc    %eax
  8031d5:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031da:	e9 41 02 00 00       	jmp    803420 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 50 08             	mov    0x8(%eax),%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031eb:	01 c2                	add    %eax,%edx
  8031ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f0:	8b 40 08             	mov    0x8(%eax),%eax
  8031f3:	39 c2                	cmp    %eax,%edx
  8031f5:	0f 85 7c 01 00 00    	jne    803377 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ff:	74 06                	je     803207 <insert_sorted_with_merge_freeList+0x530>
  803201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803205:	75 17                	jne    80321e <insert_sorted_with_merge_freeList+0x547>
  803207:	83 ec 04             	sub    $0x4,%esp
  80320a:	68 c0 3f 80 00       	push   $0x803fc0
  80320f:	68 69 01 00 00       	push   $0x169
  803214:	68 a7 3f 80 00       	push   $0x803fa7
  803219:	e8 7f d1 ff ff       	call   80039d <_panic>
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	8b 50 04             	mov    0x4(%eax),%edx
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	8b 45 08             	mov    0x8(%ebp),%eax
  80322d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803230:	89 10                	mov    %edx,(%eax)
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	8b 40 04             	mov    0x4(%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 0d                	je     803249 <insert_sorted_with_merge_freeList+0x572>
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	8b 40 04             	mov    0x4(%eax),%eax
  803242:	8b 55 08             	mov    0x8(%ebp),%edx
  803245:	89 10                	mov    %edx,(%eax)
  803247:	eb 08                	jmp    803251 <insert_sorted_with_merge_freeList+0x57a>
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	a3 38 51 80 00       	mov    %eax,0x805138
  803251:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803254:	8b 55 08             	mov    0x8(%ebp),%edx
  803257:	89 50 04             	mov    %edx,0x4(%eax)
  80325a:	a1 44 51 80 00       	mov    0x805144,%eax
  80325f:	40                   	inc    %eax
  803260:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	8b 50 0c             	mov    0xc(%eax),%edx
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	8b 40 0c             	mov    0xc(%eax),%eax
  803271:	01 c2                	add    %eax,%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803279:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80327d:	75 17                	jne    803296 <insert_sorted_with_merge_freeList+0x5bf>
  80327f:	83 ec 04             	sub    $0x4,%esp
  803282:	68 50 40 80 00       	push   $0x804050
  803287:	68 6b 01 00 00       	push   $0x16b
  80328c:	68 a7 3f 80 00       	push   $0x803fa7
  803291:	e8 07 d1 ff ff       	call   80039d <_panic>
  803296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803299:	8b 00                	mov    (%eax),%eax
  80329b:	85 c0                	test   %eax,%eax
  80329d:	74 10                	je     8032af <insert_sorted_with_merge_freeList+0x5d8>
  80329f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a2:	8b 00                	mov    (%eax),%eax
  8032a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a7:	8b 52 04             	mov    0x4(%edx),%edx
  8032aa:	89 50 04             	mov    %edx,0x4(%eax)
  8032ad:	eb 0b                	jmp    8032ba <insert_sorted_with_merge_freeList+0x5e3>
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	8b 40 04             	mov    0x4(%eax),%eax
  8032b5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	8b 40 04             	mov    0x4(%eax),%eax
  8032c0:	85 c0                	test   %eax,%eax
  8032c2:	74 0f                	je     8032d3 <insert_sorted_with_merge_freeList+0x5fc>
  8032c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c7:	8b 40 04             	mov    0x4(%eax),%eax
  8032ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032cd:	8b 12                	mov    (%edx),%edx
  8032cf:	89 10                	mov    %edx,(%eax)
  8032d1:	eb 0a                	jmp    8032dd <insert_sorted_with_merge_freeList+0x606>
  8032d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f5:	48                   	dec    %eax
  8032f6:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803308:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80330f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803313:	75 17                	jne    80332c <insert_sorted_with_merge_freeList+0x655>
  803315:	83 ec 04             	sub    $0x4,%esp
  803318:	68 84 3f 80 00       	push   $0x803f84
  80331d:	68 6e 01 00 00       	push   $0x16e
  803322:	68 a7 3f 80 00       	push   $0x803fa7
  803327:	e8 71 d0 ff ff       	call   80039d <_panic>
  80332c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803335:	89 10                	mov    %edx,(%eax)
  803337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333a:	8b 00                	mov    (%eax),%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	74 0d                	je     80334d <insert_sorted_with_merge_freeList+0x676>
  803340:	a1 48 51 80 00       	mov    0x805148,%eax
  803345:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803348:	89 50 04             	mov    %edx,0x4(%eax)
  80334b:	eb 08                	jmp    803355 <insert_sorted_with_merge_freeList+0x67e>
  80334d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803350:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803355:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803358:	a3 48 51 80 00       	mov    %eax,0x805148
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803367:	a1 54 51 80 00       	mov    0x805154,%eax
  80336c:	40                   	inc    %eax
  80336d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803372:	e9 a9 00 00 00       	jmp    803420 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80337b:	74 06                	je     803383 <insert_sorted_with_merge_freeList+0x6ac>
  80337d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803381:	75 17                	jne    80339a <insert_sorted_with_merge_freeList+0x6c3>
  803383:	83 ec 04             	sub    $0x4,%esp
  803386:	68 1c 40 80 00       	push   $0x80401c
  80338b:	68 73 01 00 00       	push   $0x173
  803390:	68 a7 3f 80 00       	push   $0x803fa7
  803395:	e8 03 d0 ff ff       	call   80039d <_panic>
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	8b 10                	mov    (%eax),%edx
  80339f:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a2:	89 10                	mov    %edx,(%eax)
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	8b 00                	mov    (%eax),%eax
  8033a9:	85 c0                	test   %eax,%eax
  8033ab:	74 0b                	je     8033b8 <insert_sorted_with_merge_freeList+0x6e1>
  8033ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b0:	8b 00                	mov    (%eax),%eax
  8033b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b5:	89 50 04             	mov    %edx,0x4(%eax)
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033be:	89 10                	mov    %edx,(%eax)
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033c6:	89 50 04             	mov    %edx,0x4(%eax)
  8033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	85 c0                	test   %eax,%eax
  8033d0:	75 08                	jne    8033da <insert_sorted_with_merge_freeList+0x703>
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033da:	a1 44 51 80 00       	mov    0x805144,%eax
  8033df:	40                   	inc    %eax
  8033e0:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033e5:	eb 39                	jmp    803420 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8033ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f3:	74 07                	je     8033fc <insert_sorted_with_merge_freeList+0x725>
  8033f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f8:	8b 00                	mov    (%eax),%eax
  8033fa:	eb 05                	jmp    803401 <insert_sorted_with_merge_freeList+0x72a>
  8033fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803401:	a3 40 51 80 00       	mov    %eax,0x805140
  803406:	a1 40 51 80 00       	mov    0x805140,%eax
  80340b:	85 c0                	test   %eax,%eax
  80340d:	0f 85 c7 fb ff ff    	jne    802fda <insert_sorted_with_merge_freeList+0x303>
  803413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803417:	0f 85 bd fb ff ff    	jne    802fda <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80341d:	eb 01                	jmp    803420 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80341f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803420:	90                   	nop
  803421:	c9                   	leave  
  803422:	c3                   	ret    
  803423:	90                   	nop

00803424 <__udivdi3>:
  803424:	55                   	push   %ebp
  803425:	57                   	push   %edi
  803426:	56                   	push   %esi
  803427:	53                   	push   %ebx
  803428:	83 ec 1c             	sub    $0x1c,%esp
  80342b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80342f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803437:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80343b:	89 ca                	mov    %ecx,%edx
  80343d:	89 f8                	mov    %edi,%eax
  80343f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803443:	85 f6                	test   %esi,%esi
  803445:	75 2d                	jne    803474 <__udivdi3+0x50>
  803447:	39 cf                	cmp    %ecx,%edi
  803449:	77 65                	ja     8034b0 <__udivdi3+0x8c>
  80344b:	89 fd                	mov    %edi,%ebp
  80344d:	85 ff                	test   %edi,%edi
  80344f:	75 0b                	jne    80345c <__udivdi3+0x38>
  803451:	b8 01 00 00 00       	mov    $0x1,%eax
  803456:	31 d2                	xor    %edx,%edx
  803458:	f7 f7                	div    %edi
  80345a:	89 c5                	mov    %eax,%ebp
  80345c:	31 d2                	xor    %edx,%edx
  80345e:	89 c8                	mov    %ecx,%eax
  803460:	f7 f5                	div    %ebp
  803462:	89 c1                	mov    %eax,%ecx
  803464:	89 d8                	mov    %ebx,%eax
  803466:	f7 f5                	div    %ebp
  803468:	89 cf                	mov    %ecx,%edi
  80346a:	89 fa                	mov    %edi,%edx
  80346c:	83 c4 1c             	add    $0x1c,%esp
  80346f:	5b                   	pop    %ebx
  803470:	5e                   	pop    %esi
  803471:	5f                   	pop    %edi
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    
  803474:	39 ce                	cmp    %ecx,%esi
  803476:	77 28                	ja     8034a0 <__udivdi3+0x7c>
  803478:	0f bd fe             	bsr    %esi,%edi
  80347b:	83 f7 1f             	xor    $0x1f,%edi
  80347e:	75 40                	jne    8034c0 <__udivdi3+0x9c>
  803480:	39 ce                	cmp    %ecx,%esi
  803482:	72 0a                	jb     80348e <__udivdi3+0x6a>
  803484:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803488:	0f 87 9e 00 00 00    	ja     80352c <__udivdi3+0x108>
  80348e:	b8 01 00 00 00       	mov    $0x1,%eax
  803493:	89 fa                	mov    %edi,%edx
  803495:	83 c4 1c             	add    $0x1c,%esp
  803498:	5b                   	pop    %ebx
  803499:	5e                   	pop    %esi
  80349a:	5f                   	pop    %edi
  80349b:	5d                   	pop    %ebp
  80349c:	c3                   	ret    
  80349d:	8d 76 00             	lea    0x0(%esi),%esi
  8034a0:	31 ff                	xor    %edi,%edi
  8034a2:	31 c0                	xor    %eax,%eax
  8034a4:	89 fa                	mov    %edi,%edx
  8034a6:	83 c4 1c             	add    $0x1c,%esp
  8034a9:	5b                   	pop    %ebx
  8034aa:	5e                   	pop    %esi
  8034ab:	5f                   	pop    %edi
  8034ac:	5d                   	pop    %ebp
  8034ad:	c3                   	ret    
  8034ae:	66 90                	xchg   %ax,%ax
  8034b0:	89 d8                	mov    %ebx,%eax
  8034b2:	f7 f7                	div    %edi
  8034b4:	31 ff                	xor    %edi,%edi
  8034b6:	89 fa                	mov    %edi,%edx
  8034b8:	83 c4 1c             	add    $0x1c,%esp
  8034bb:	5b                   	pop    %ebx
  8034bc:	5e                   	pop    %esi
  8034bd:	5f                   	pop    %edi
  8034be:	5d                   	pop    %ebp
  8034bf:	c3                   	ret    
  8034c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034c5:	89 eb                	mov    %ebp,%ebx
  8034c7:	29 fb                	sub    %edi,%ebx
  8034c9:	89 f9                	mov    %edi,%ecx
  8034cb:	d3 e6                	shl    %cl,%esi
  8034cd:	89 c5                	mov    %eax,%ebp
  8034cf:	88 d9                	mov    %bl,%cl
  8034d1:	d3 ed                	shr    %cl,%ebp
  8034d3:	89 e9                	mov    %ebp,%ecx
  8034d5:	09 f1                	or     %esi,%ecx
  8034d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034db:	89 f9                	mov    %edi,%ecx
  8034dd:	d3 e0                	shl    %cl,%eax
  8034df:	89 c5                	mov    %eax,%ebp
  8034e1:	89 d6                	mov    %edx,%esi
  8034e3:	88 d9                	mov    %bl,%cl
  8034e5:	d3 ee                	shr    %cl,%esi
  8034e7:	89 f9                	mov    %edi,%ecx
  8034e9:	d3 e2                	shl    %cl,%edx
  8034eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ef:	88 d9                	mov    %bl,%cl
  8034f1:	d3 e8                	shr    %cl,%eax
  8034f3:	09 c2                	or     %eax,%edx
  8034f5:	89 d0                	mov    %edx,%eax
  8034f7:	89 f2                	mov    %esi,%edx
  8034f9:	f7 74 24 0c          	divl   0xc(%esp)
  8034fd:	89 d6                	mov    %edx,%esi
  8034ff:	89 c3                	mov    %eax,%ebx
  803501:	f7 e5                	mul    %ebp
  803503:	39 d6                	cmp    %edx,%esi
  803505:	72 19                	jb     803520 <__udivdi3+0xfc>
  803507:	74 0b                	je     803514 <__udivdi3+0xf0>
  803509:	89 d8                	mov    %ebx,%eax
  80350b:	31 ff                	xor    %edi,%edi
  80350d:	e9 58 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  803512:	66 90                	xchg   %ax,%ax
  803514:	8b 54 24 08          	mov    0x8(%esp),%edx
  803518:	89 f9                	mov    %edi,%ecx
  80351a:	d3 e2                	shl    %cl,%edx
  80351c:	39 c2                	cmp    %eax,%edx
  80351e:	73 e9                	jae    803509 <__udivdi3+0xe5>
  803520:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803523:	31 ff                	xor    %edi,%edi
  803525:	e9 40 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  80352a:	66 90                	xchg   %ax,%ax
  80352c:	31 c0                	xor    %eax,%eax
  80352e:	e9 37 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  803533:	90                   	nop

00803534 <__umoddi3>:
  803534:	55                   	push   %ebp
  803535:	57                   	push   %edi
  803536:	56                   	push   %esi
  803537:	53                   	push   %ebx
  803538:	83 ec 1c             	sub    $0x1c,%esp
  80353b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80353f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803543:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803547:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80354b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80354f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803553:	89 f3                	mov    %esi,%ebx
  803555:	89 fa                	mov    %edi,%edx
  803557:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80355b:	89 34 24             	mov    %esi,(%esp)
  80355e:	85 c0                	test   %eax,%eax
  803560:	75 1a                	jne    80357c <__umoddi3+0x48>
  803562:	39 f7                	cmp    %esi,%edi
  803564:	0f 86 a2 00 00 00    	jbe    80360c <__umoddi3+0xd8>
  80356a:	89 c8                	mov    %ecx,%eax
  80356c:	89 f2                	mov    %esi,%edx
  80356e:	f7 f7                	div    %edi
  803570:	89 d0                	mov    %edx,%eax
  803572:	31 d2                	xor    %edx,%edx
  803574:	83 c4 1c             	add    $0x1c,%esp
  803577:	5b                   	pop    %ebx
  803578:	5e                   	pop    %esi
  803579:	5f                   	pop    %edi
  80357a:	5d                   	pop    %ebp
  80357b:	c3                   	ret    
  80357c:	39 f0                	cmp    %esi,%eax
  80357e:	0f 87 ac 00 00 00    	ja     803630 <__umoddi3+0xfc>
  803584:	0f bd e8             	bsr    %eax,%ebp
  803587:	83 f5 1f             	xor    $0x1f,%ebp
  80358a:	0f 84 ac 00 00 00    	je     80363c <__umoddi3+0x108>
  803590:	bf 20 00 00 00       	mov    $0x20,%edi
  803595:	29 ef                	sub    %ebp,%edi
  803597:	89 fe                	mov    %edi,%esi
  803599:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80359d:	89 e9                	mov    %ebp,%ecx
  80359f:	d3 e0                	shl    %cl,%eax
  8035a1:	89 d7                	mov    %edx,%edi
  8035a3:	89 f1                	mov    %esi,%ecx
  8035a5:	d3 ef                	shr    %cl,%edi
  8035a7:	09 c7                	or     %eax,%edi
  8035a9:	89 e9                	mov    %ebp,%ecx
  8035ab:	d3 e2                	shl    %cl,%edx
  8035ad:	89 14 24             	mov    %edx,(%esp)
  8035b0:	89 d8                	mov    %ebx,%eax
  8035b2:	d3 e0                	shl    %cl,%eax
  8035b4:	89 c2                	mov    %eax,%edx
  8035b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ba:	d3 e0                	shl    %cl,%eax
  8035bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c4:	89 f1                	mov    %esi,%ecx
  8035c6:	d3 e8                	shr    %cl,%eax
  8035c8:	09 d0                	or     %edx,%eax
  8035ca:	d3 eb                	shr    %cl,%ebx
  8035cc:	89 da                	mov    %ebx,%edx
  8035ce:	f7 f7                	div    %edi
  8035d0:	89 d3                	mov    %edx,%ebx
  8035d2:	f7 24 24             	mull   (%esp)
  8035d5:	89 c6                	mov    %eax,%esi
  8035d7:	89 d1                	mov    %edx,%ecx
  8035d9:	39 d3                	cmp    %edx,%ebx
  8035db:	0f 82 87 00 00 00    	jb     803668 <__umoddi3+0x134>
  8035e1:	0f 84 91 00 00 00    	je     803678 <__umoddi3+0x144>
  8035e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035eb:	29 f2                	sub    %esi,%edx
  8035ed:	19 cb                	sbb    %ecx,%ebx
  8035ef:	89 d8                	mov    %ebx,%eax
  8035f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035f5:	d3 e0                	shl    %cl,%eax
  8035f7:	89 e9                	mov    %ebp,%ecx
  8035f9:	d3 ea                	shr    %cl,%edx
  8035fb:	09 d0                	or     %edx,%eax
  8035fd:	89 e9                	mov    %ebp,%ecx
  8035ff:	d3 eb                	shr    %cl,%ebx
  803601:	89 da                	mov    %ebx,%edx
  803603:	83 c4 1c             	add    $0x1c,%esp
  803606:	5b                   	pop    %ebx
  803607:	5e                   	pop    %esi
  803608:	5f                   	pop    %edi
  803609:	5d                   	pop    %ebp
  80360a:	c3                   	ret    
  80360b:	90                   	nop
  80360c:	89 fd                	mov    %edi,%ebp
  80360e:	85 ff                	test   %edi,%edi
  803610:	75 0b                	jne    80361d <__umoddi3+0xe9>
  803612:	b8 01 00 00 00       	mov    $0x1,%eax
  803617:	31 d2                	xor    %edx,%edx
  803619:	f7 f7                	div    %edi
  80361b:	89 c5                	mov    %eax,%ebp
  80361d:	89 f0                	mov    %esi,%eax
  80361f:	31 d2                	xor    %edx,%edx
  803621:	f7 f5                	div    %ebp
  803623:	89 c8                	mov    %ecx,%eax
  803625:	f7 f5                	div    %ebp
  803627:	89 d0                	mov    %edx,%eax
  803629:	e9 44 ff ff ff       	jmp    803572 <__umoddi3+0x3e>
  80362e:	66 90                	xchg   %ax,%ax
  803630:	89 c8                	mov    %ecx,%eax
  803632:	89 f2                	mov    %esi,%edx
  803634:	83 c4 1c             	add    $0x1c,%esp
  803637:	5b                   	pop    %ebx
  803638:	5e                   	pop    %esi
  803639:	5f                   	pop    %edi
  80363a:	5d                   	pop    %ebp
  80363b:	c3                   	ret    
  80363c:	3b 04 24             	cmp    (%esp),%eax
  80363f:	72 06                	jb     803647 <__umoddi3+0x113>
  803641:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803645:	77 0f                	ja     803656 <__umoddi3+0x122>
  803647:	89 f2                	mov    %esi,%edx
  803649:	29 f9                	sub    %edi,%ecx
  80364b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80364f:	89 14 24             	mov    %edx,(%esp)
  803652:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803656:	8b 44 24 04          	mov    0x4(%esp),%eax
  80365a:	8b 14 24             	mov    (%esp),%edx
  80365d:	83 c4 1c             	add    $0x1c,%esp
  803660:	5b                   	pop    %ebx
  803661:	5e                   	pop    %esi
  803662:	5f                   	pop    %edi
  803663:	5d                   	pop    %ebp
  803664:	c3                   	ret    
  803665:	8d 76 00             	lea    0x0(%esi),%esi
  803668:	2b 04 24             	sub    (%esp),%eax
  80366b:	19 fa                	sbb    %edi,%edx
  80366d:	89 d1                	mov    %edx,%ecx
  80366f:	89 c6                	mov    %eax,%esi
  803671:	e9 71 ff ff ff       	jmp    8035e7 <__umoddi3+0xb3>
  803676:	66 90                	xchg   %ax,%ax
  803678:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80367c:	72 ea                	jb     803668 <__umoddi3+0x134>
  80367e:	89 d9                	mov    %ebx,%ecx
  803680:	e9 62 ff ff ff       	jmp    8035e7 <__umoddi3+0xb3>
