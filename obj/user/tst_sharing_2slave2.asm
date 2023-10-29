
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 c3 01 00 00       	call   8001f9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
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
  80008d:	68 c0 37 80 00       	push   $0x8037c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 37 80 00       	push   $0x8037dc
  800099:	e8 97 02 00 00       	call   800335 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 c9 14 00 00       	call   801571 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 d7 1b 00 00       	call   801c87 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 c3 19 00 00       	call   801a7b <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 d1 18 00 00       	call   80198e <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f7 37 80 00       	push   $0x8037f7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 9a 16 00 00       	call   80176a <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 fc 37 80 00       	push   $0x8037fc
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 dc 37 80 00       	push   $0x8037dc
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 93 18 00 00       	call   80198e <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 5c 38 80 00       	push   $0x80385c
  80010c:	6a 22                	push   $0x22
  80010e:	68 dc 37 80 00       	push   $0x8037dc
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 78 19 00 00       	call   801a95 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 59 19 00 00       	call   801a7b <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 67 18 00 00       	call   80198e <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ed 38 80 00       	push   $0x8038ed
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 30 16 00 00       	call   80176a <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 fc 37 80 00       	push   $0x8037fc
  800151:	6a 28                	push   $0x28
  800153:	68 dc 37 80 00       	push   $0x8037dc
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 2c 18 00 00       	call   80198e <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 5c 38 80 00       	push   $0x80385c
  800173:	6a 29                	push   $0x29
  800175:	68 dc 37 80 00       	push   $0x8037dc
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 11 19 00 00       	call   801a95 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 f0 38 80 00       	push   $0x8038f0
  800196:	6a 2c                	push   $0x2c
  800198:	68 dc 37 80 00       	push   $0x8037dc
  80019d:	e8 93 01 00 00       	call   800335 <_panic>

	//Edit the writable object
	*z = 30;
  8001a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a5:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8001ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	83 f8 1e             	cmp    $0x1e,%eax
  8001b3:	74 14                	je     8001c9 <_main+0x191>
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 f0 38 80 00       	push   $0x8038f0
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 dc 37 80 00       	push   $0x8037dc
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 28 39 80 00       	push   $0x803928
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 58 39 80 00       	push   $0x803958
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 dc 37 80 00       	push   $0x8037dc
  8001f4:	e8 3c 01 00 00       	call   800335 <_panic>

008001f9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ff:	e8 6a 1a 00 00       	call   801c6e <sys_getenvindex>
  800204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	c1 e0 03             	shl    $0x3,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021c:	01 d0                	add    %edx,%eax
  80021e:	c1 e0 04             	shl    $0x4,%eax
  800221:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800226:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022b:	a1 20 50 80 00       	mov    0x805020,%eax
  800230:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800236:	84 c0                	test   %al,%al
  800238:	74 0f                	je     800249 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80023a:	a1 20 50 80 00       	mov    0x805020,%eax
  80023f:	05 5c 05 00 00       	add    $0x55c,%eax
  800244:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024d:	7e 0a                	jle    800259 <libmain+0x60>
		binaryname = argv[0];
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 d1 fd ff ff       	call   800038 <_main>
  800267:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026a:	e8 0c 18 00 00       	call   801a7b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 b4 39 80 00       	push   $0x8039b4
  800277:	e8 6d 03 00 00       	call   8005e9 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 50 80 00       	mov    0x805020,%eax
  800284:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80028a:	a1 20 50 80 00       	mov    0x805020,%eax
  80028f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 dc 39 80 00       	push   $0x8039dc
  80029f:	e8 45 03 00 00       	call   8005e9 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ac:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002b2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	68 04 3a 80 00       	push   $0x803a04
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 5c 3a 80 00       	push   $0x803a5c
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 b4 39 80 00       	push   $0x8039b4
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 8c 17 00 00       	call   801a95 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800309:	e8 19 00 00 00       	call   800327 <exit>
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 19 19 00 00       	call   801c3a <sys_destroy_env>
  800321:	83 c4 10             	add    $0x10,%esp
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <exit>:

void
exit(void)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80032d:	e8 6e 19 00 00       	call   801ca0 <sys_exit_env>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80033b:	8d 45 10             	lea    0x10(%ebp),%eax
  80033e:	83 c0 04             	add    $0x4,%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800344:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	74 16                	je     800363 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80034d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	68 70 3a 80 00       	push   $0x803a70
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 50 80 00       	mov    0x805000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 75 3a 80 00       	push   $0x803a75
  800374:	e8 70 02 00 00       	call   8005e9 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 f3 01 00 00       	call   80057e <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	6a 00                	push   $0x0
  800393:	68 91 3a 80 00       	push   $0x803a91
  800398:	e8 e1 01 00 00       	call   80057e <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a0:	e8 82 ff ff ff       	call   800327 <exit>

	// should not return here
	while (1) ;
  8003a5:	eb fe                	jmp    8003a5 <_panic+0x70>

008003a7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b2:	8b 50 74             	mov    0x74(%eax),%edx
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b8:	39 c2                	cmp    %eax,%edx
  8003ba:	74 14                	je     8003d0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 94 3a 80 00       	push   $0x803a94
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 e0 3a 80 00       	push   $0x803ae0
  8003cb:	e8 65 ff ff ff       	call   800335 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003de:	e9 c2 00 00 00       	jmp    8004a5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	75 08                	jne    800400 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003fb:	e9 a2 00 00 00       	jmp    8004a2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80040e:	eb 69                	jmp    800479 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800410:	a1 20 50 80 00       	mov    0x805020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8a 40 04             	mov    0x4(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	75 46                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	a1 20 50 80 00       	mov    0x805020,%eax
  800435:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80043b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	c1 e0 03             	shl    $0x3,%eax
  800447:	01 c8                	add    %ecx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800456:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c8                	add    %ecx,%eax
  800467:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	75 09                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80046d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800474:	eb 12                	jmp    800488 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	ff 45 e8             	incl   -0x18(%ebp)
  800479:	a1 20 50 80 00       	mov    0x805020,%eax
  80047e:	8b 50 74             	mov    0x74(%eax),%edx
  800481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800484:	39 c2                	cmp    %eax,%edx
  800486:	77 88                	ja     800410 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80048c:	75 14                	jne    8004a2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	68 ec 3a 80 00       	push   $0x803aec
  800496:	6a 3a                	push   $0x3a
  800498:	68 e0 3a 80 00       	push   $0x803ae0
  80049d:	e8 93 fe ff ff       	call   800335 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a2:	ff 45 f0             	incl   -0x10(%ebp)
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ab:	0f 8c 32 ff ff ff    	jl     8003e3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004bf:	eb 26                	jmp    8004e7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	89 d0                	mov    %edx,%eax
  8004d1:	01 c0                	add    %eax,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 03             	shl    $0x3,%eax
  8004d8:	01 c8                	add    %ecx,%eax
  8004da:	8a 40 04             	mov    0x4(%eax),%al
  8004dd:	3c 01                	cmp    $0x1,%al
  8004df:	75 03                	jne    8004e4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e4:	ff 45 e0             	incl   -0x20(%ebp)
  8004e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ec:	8b 50 74             	mov    0x74(%eax),%edx
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 cb                	ja     8004c1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fc:	74 14                	je     800512 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 40 3b 80 00       	push   $0x803b40
  800506:	6a 44                	push   $0x44
  800508:	68 e0 3a 80 00       	push   $0x803ae0
  80050d:	e8 23 fe ff ff       	call   800335 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800512:	90                   	nop
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 48 01             	lea    0x1(%eax),%ecx
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	89 0a                	mov    %ecx,(%edx)
  800528:	8b 55 08             	mov    0x8(%ebp),%edx
  80052b:	88 d1                	mov    %dl,%cl
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053e:	75 2c                	jne    80056c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800540:	a0 24 50 80 00       	mov    0x805024,%al
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	8b 12                	mov    (%edx),%edx
  80054d:	89 d1                	mov    %edx,%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	83 c2 08             	add    $0x8,%edx
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	52                   	push   %edx
  80055b:	e8 6d 13 00 00       	call   8018cd <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	8b 40 04             	mov    0x4(%eax),%eax
  800572:	8d 50 01             	lea    0x1(%eax),%edx
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058e:	00 00 00 
	b.cnt = 0;
  800591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800598:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	50                   	push   %eax
  8005a8:	68 15 05 80 00       	push   $0x800515
  8005ad:	e8 11 02 00 00       	call   8007c3 <vprintfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005b5:	a0 24 50 80 00       	mov    0x805024,%al
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	52                   	push   %edx
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 f6 12 00 00       	call   8018cd <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005da:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8005e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ef:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 73 ff ff ff       	call   80057e <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80061c:	e8 5a 14 00 00       	call   801a7b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 48 ff ff ff       	call   80057e <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80063c:	e8 54 14 00 00       	call   801a95 <sys_enable_interrupt>
	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	53                   	push   %ebx
  80064a:	83 ec 14             	sub    $0x14,%esp
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800659:	8b 45 18             	mov    0x18(%ebp),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800664:	77 55                	ja     8006bb <printnum+0x75>
  800666:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800669:	72 05                	jb     800670 <printnum+0x2a>
  80066b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066e:	77 4b                	ja     8006bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800670:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800673:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800676:	8b 45 18             	mov    0x18(%ebp),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	ff 75 f0             	pushl  -0x10(%ebp)
  800686:	e8 c5 2e 00 00       	call   803550 <__udivdi3>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	53                   	push   %ebx
  800695:	ff 75 18             	pushl  0x18(%ebp)
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 a1 ff ff ff       	call   800646 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	eb 1a                	jmp    8006c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c2:	7f e6                	jg     8006aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	53                   	push   %ebx
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	e8 85 2f 00 00       	call   803660 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 b4 3d 80 00       	add    $0x803db4,%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 40                	jmp    800762 <getuint+0x65>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1e                	je     800746 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 1c                	jmp    800762 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076b:	7e 1c                	jle    800789 <getint+0x25>
		return va_arg(*ap, long long);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 08             	lea    0x8(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 08             	sub    $0x8,%eax
  800782:	8b 50 04             	mov    0x4(%eax),%edx
  800785:	8b 00                	mov    (%eax),%eax
  800787:	eb 38                	jmp    8007c1 <getint+0x5d>
	else if (lflag)
  800789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078d:	74 1a                	je     8007a9 <getint+0x45>
		return va_arg(*ap, long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	99                   	cltd   
  8007a7:	eb 18                	jmp    8007c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 04             	lea    0x4(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	eb 17                	jmp    8007e4 <vprintfmt+0x21>
			if (ch == '\0')
  8007cd:	85 db                	test   %ebx,%ebx
  8007cf:	0f 84 af 03 00 00    	je     800b84 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f b6 d8             	movzbl %al,%ebx
  8007f2:	83 fb 25             	cmp    $0x25,%ebx
  8007f5:	75 d6                	jne    8007cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800802:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 2b 03 00 00    	ja     800b5c <vprintfmt+0x399>
  800831:	8b 04 85 d8 3d 80 00 	mov    0x803dd8(,%eax,4),%eax
  800838:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083e:	eb d7                	jmp    800817 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800844:	eb d1                	jmp    800817 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800869:	83 fb 2f             	cmp    $0x2f,%ebx
  80086c:	7e 3e                	jle    8008ac <vprintfmt+0xe9>
  80086e:	83 fb 39             	cmp    $0x39,%ebx
  800871:	7f 39                	jg     8008ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb d5                	jmp    80084d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	83 c0 04             	add    $0x4,%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088c:	eb 1f                	jmp    8008ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	79 83                	jns    800817 <vprintfmt+0x54>
				width = 0;
  800894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80089b:	e9 77 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a7:	e9 6b ff ff ff       	jmp    800817 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	0f 89 60 ff ff ff    	jns    800817 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c4:	e9 4e ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008cc:	e9 46 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	50                   	push   %eax
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			break;
  8008f1:	e9 89 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800907:	85 db                	test   %ebx,%ebx
  800909:	79 02                	jns    80090d <vprintfmt+0x14a>
				err = -err;
  80090b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090d:	83 fb 64             	cmp    $0x64,%ebx
  800910:	7f 0b                	jg     80091d <vprintfmt+0x15a>
  800912:	8b 34 9d 20 3c 80 00 	mov    0x803c20(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 c5 3d 80 00       	push   $0x803dc5
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 5e 02 00 00       	call   800b8c <printfmt>
  80092e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800931:	e9 49 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800936:	56                   	push   %esi
  800937:	68 ce 3d 80 00       	push   $0x803dce
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 45 02 00 00       	call   800b8c <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			break;
  80094a:	e9 30 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 30                	mov    (%eax),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 05                	jne    800969 <vprintfmt+0x1a6>
				p = "(null)";
  800964:	be d1 3d 80 00       	mov    $0x803dd1,%esi
			if (width > 0 && padc != '-')
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7e 6d                	jle    8009dc <vprintfmt+0x219>
  80096f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800973:	74 67                	je     8009dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	50                   	push   %eax
  80097c:	56                   	push   %esi
  80097d:	e8 0c 03 00 00       	call   800c8e <strnlen>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80098a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	50                   	push   %eax
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 34                	jmp    8009dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	74 1c                	je     8009ca <vprintfmt+0x207>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x1f5>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 12                	jle    8009ca <vprintfmt+0x207>
					putch('?', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 3f                	push   $0x3f
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	eb 0f                	jmp    8009d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	8d 70 01             	lea    0x1(%eax),%esi
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 24                	je     800a0e <vprintfmt+0x24b>
  8009ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ee:	78 b8                	js     8009a8 <vprintfmt+0x1e5>
  8009f0:	ff 4d e0             	decl   -0x20(%ebp)
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	79 af                	jns    8009a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 13                	jmp    800a0e <vprintfmt+0x24b>
				putch(' ', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 20                	push   $0x20
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e7                	jg     8009fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a14:	e9 66 01 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 3c fd ff ff       	call   800764 <getint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	85 d2                	test   %edx,%edx
  800a39:	79 23                	jns    800a5e <vprintfmt+0x29b>
				putch('-', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 2d                	push   $0x2d
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	f7 d8                	neg    %eax
  800a53:	83 d2 00             	adc    $0x0,%edx
  800a56:	f7 da                	neg    %edx
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a65:	e9 bc 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 84 fc ff ff       	call   8006fd <getuint>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a89:	e9 98 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 58                	push   $0x58
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 bc 00 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 30                	push   $0x30
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 78                	push   $0x78
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b05:	eb 1f                	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 e7 fb ff ff       	call   8006fd <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	52                   	push   %edx
  800b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 f4             	pushl  -0xc(%ebp)
  800b38:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 00 fb ff ff       	call   800646 <printnum>
  800b46:	83 c4 20             	add    $0x20,%esp
			break;
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			break;
  800b5a:	eb 23                	jmp    800b7f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 25                	push   $0x25
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6c:	ff 4d 10             	decl   0x10(%ebp)
  800b6f:	eb 03                	jmp    800b74 <vprintfmt+0x3b1>
  800b71:	ff 4d 10             	decl   0x10(%ebp)
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	48                   	dec    %eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	3c 25                	cmp    $0x25,%al
  800b7c:	75 f3                	jne    800b71 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b7e:	90                   	nop
		}
	}
  800b7f:	e9 47 fc ff ff       	jmp    8007cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 16 fc ff ff       	call   8007c3 <vprintfmt>
  800bad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb0:	90                   	nop
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 40 08             	mov    0x8(%eax),%eax
  800bbc:	8d 50 01             	lea    0x1(%eax),%edx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 10                	mov    (%eax),%edx
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8b 40 04             	mov    0x4(%eax),%eax
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	73 12                	jae    800be6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdf:	89 0a                	mov    %ecx,(%edx)
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	88 10                	mov    %dl,(%eax)
}
  800be6:	90                   	nop
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
  800c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0e:	74 06                	je     800c16 <vsnprintf+0x2d>
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	7f 07                	jg     800c1d <vsnprintf+0x34>
		return -E_INVAL;
  800c16:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1b:	eb 20                	jmp    800c3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1d:	ff 75 14             	pushl  0x14(%ebp)
  800c20:	ff 75 10             	pushl  0x10(%ebp)
  800c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	68 b3 0b 80 00       	push   $0x800bb3
  800c2c:	e8 92 fb ff ff       	call   8007c3 <vprintfmt>
  800c31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c45:	8d 45 10             	lea    0x10(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	50                   	push   %eax
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	ff 75 08             	pushl  0x8(%ebp)
  800c5b:	e8 89 ff ff ff       	call   800be9 <vsnprintf>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 06                	jmp    800c80 <strlen+0x15>
		n++;
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	75 f1                	jne    800c7a <strlen+0xf>
		n++;
	return n;
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9b:	eb 09                	jmp    800ca6 <strnlen+0x18>
		n++;
  800c9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	ff 4d 0c             	decl   0xc(%ebp)
  800ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caa:	74 09                	je     800cb5 <strnlen+0x27>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 e8                	jne    800c9d <strnlen+0xf>
		n++;
	return n;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc6:	90                   	nop
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd9:	8a 12                	mov    (%edx),%dl
  800cdb:	88 10                	mov    %dl,(%eax)
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e4                	jne    800cc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfb:	eb 1f                	jmp    800d1c <strncpy+0x34>
		*dst++ = *src;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 08             	mov    %edx,0x8(%ebp)
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 03                	je     800d19 <strncpy+0x31>
			src++;
  800d16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d19:	ff 45 fc             	incl   -0x4(%ebp)
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d22:	72 d9                	jb     800cfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	74 30                	je     800d6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3b:	eb 16                	jmp    800d53 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 08             	mov    %edx,0x8(%ebp)
  800d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 09                	je     800d65 <strlcpy+0x3c>
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 d8                	jne    800d3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	29 c2                	sub    %eax,%edx
  800d73:	89 d0                	mov    %edx,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7a:	eb 06                	jmp    800d82 <strcmp+0xb>
		p++, q++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	74 0e                	je     800d99 <strcmp+0x22>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 10                	mov    (%eax),%dl
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	38 c2                	cmp    %al,%dl
  800d97:	74 e3                	je     800d7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	0f b6 d0             	movzbl %al,%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	29 c2                	sub    %eax,%edx
  800dab:	89 d0                	mov    %edx,%eax
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db2:	eb 09                	jmp    800dbd <strncmp+0xe>
		n--, p++, q++;
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	74 17                	je     800dda <strncmp+0x2b>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	74 0e                	je     800dda <strncmp+0x2b>
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 10                	mov    (%eax),%dl
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	38 c2                	cmp    %al,%dl
  800dd8:	74 da                	je     800db4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dde:	75 07                	jne    800de7 <strncmp+0x38>
		return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	eb 14                	jmp    800dfb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 04             	sub    $0x4,%esp
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e09:	eb 12                	jmp    800e1d <strchr+0x20>
		if (*s == c)
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e13:	75 05                	jne    800e1a <strchr+0x1d>
			return (char *) s;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	eb 11                	jmp    800e2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 e5                	jne    800e0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 0d                	jmp    800e48 <strfind+0x1b>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	74 0e                	je     800e53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e45:	ff 45 08             	incl   0x8(%ebp)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	84 c0                	test   %al,%al
  800e4f:	75 ea                	jne    800e3b <strfind+0xe>
  800e51:	eb 01                	jmp    800e54 <strfind+0x27>
		if (*s == c)
			break;
  800e53:	90                   	nop
	return (char *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x22>
		*p++ = c;
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e82:	79 e9                	jns    800e6d <memset+0x14>
		*p++ = c;

	return v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e9b:	eb 16                	jmp    800eb3 <memcpy+0x2a>
		*d++ = *s++;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaf:	8a 12                	mov    (%edx),%dl
  800eb1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	75 dd                	jne    800e9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	73 50                	jae    800f2f <memmove+0x6a>
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	76 43                	jbe    800f2f <memmove+0x6a>
		s += n;
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef8:	eb 10                	jmp    800f0a <memmove+0x45>
			*--d = *--s;
  800efa:	ff 4d f8             	decl   -0x8(%ebp)
  800efd:	ff 4d fc             	decl   -0x4(%ebp)
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f10:	89 55 10             	mov    %edx,0x10(%ebp)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	75 e3                	jne    800efa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f17:	eb 23                	jmp    800f3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f35:	89 55 10             	mov    %edx,0x10(%ebp)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	75 dd                	jne    800f19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f53:	eb 2a                	jmp    800f7f <memcmp+0x3e>
		if (*s1 != *s2)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	38 c2                	cmp    %al,%dl
  800f61:	74 16                	je     800f79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 d0             	movzbl %al,%edx
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f b6 c0             	movzbl %al,%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
  800f77:	eb 18                	jmp    800f91 <memcmp+0x50>
		s1++, s2++;
  800f79:	ff 45 fc             	incl   -0x4(%ebp)
  800f7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f85:	89 55 10             	mov    %edx,0x10(%ebp)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	75 c9                	jne    800f55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa4:	eb 15                	jmp    800fbb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f b6 d0             	movzbl %al,%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	39 c2                	cmp    %eax,%edx
  800fb6:	74 0d                	je     800fc5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc1:	72 e3                	jb     800fa6 <memfind+0x13>
  800fc3:	eb 01                	jmp    800fc6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc5:	90                   	nop
	return (void *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	eb 03                	jmp    800fe4 <strtol+0x19>
		s++;
  800fe1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 20                	cmp    $0x20,%al
  800feb:	74 f4                	je     800fe1 <strtol+0x16>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 eb                	je     800fe1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 2b                	cmp    $0x2b,%al
  800ffd:	75 05                	jne    801004 <strtol+0x39>
		s++;
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	eb 13                	jmp    801017 <strtol+0x4c>
	else if (*s == '-')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2d                	cmp    $0x2d,%al
  80100b:	75 0a                	jne    801017 <strtol+0x4c>
		s++, neg = 1;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101b:	74 06                	je     801023 <strtol+0x58>
  80101d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801021:	75 20                	jne    801043 <strtol+0x78>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 30                	cmp    $0x30,%al
  80102a:	75 17                	jne    801043 <strtol+0x78>
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	40                   	inc    %eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 78                	cmp    $0x78,%al
  801034:	75 0d                	jne    801043 <strtol+0x78>
		s += 2, base = 16;
  801036:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801041:	eb 28                	jmp    80106b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	75 15                	jne    80105e <strtol+0x93>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 30                	cmp    $0x30,%al
  801050:	75 0c                	jne    80105e <strtol+0x93>
		s++, base = 8;
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105c:	eb 0d                	jmp    80106b <strtol+0xa0>
	else if (base == 0)
  80105e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801062:	75 07                	jne    80106b <strtol+0xa0>
		base = 10;
  801064:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 2f                	cmp    $0x2f,%al
  801072:	7e 19                	jle    80108d <strtol+0xc2>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 39                	cmp    $0x39,%al
  80107b:	7f 10                	jg     80108d <strtol+0xc2>
			dig = *s - '0';
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	83 e8 30             	sub    $0x30,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108b:	eb 42                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 60                	cmp    $0x60,%al
  801094:	7e 19                	jle    8010af <strtol+0xe4>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 7a                	cmp    $0x7a,%al
  80109d:	7f 10                	jg     8010af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 57             	sub    $0x57,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 20                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 40                	cmp    $0x40,%al
  8010b6:	7e 39                	jle    8010f1 <strtol+0x126>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 5a                	cmp    $0x5a,%al
  8010bf:	7f 30                	jg     8010f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	83 e8 37             	sub    $0x37,%eax
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d5:	7d 19                	jge    8010f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010eb:	e9 7b ff ff ff       	jmp    80106b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 08                	je     8010ff <strtol+0x134>
		*endptr = (char *) s;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 07                	je     80110c <strtol+0x141>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	f7 d8                	neg    %eax
  80110a:	eb 03                	jmp    80110f <strtol+0x144>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <ltostr>:

void
ltostr(long value, char *str)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80111e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801129:	79 13                	jns    80113e <ltostr+0x2d>
	{
		neg = 1;
  80112b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801138:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801146:	99                   	cltd   
  801147:	f7 f9                	idiv   %ecx
  801149:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114f:	8d 50 01             	lea    0x1(%eax),%edx
  801152:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801155:	89 c2                	mov    %eax,%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 d0                	add    %edx,%eax
  80115c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115f:	83 c2 30             	add    $0x30,%edx
  801162:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801167:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116c:	f7 e9                	imul   %ecx
  80116e:	c1 fa 02             	sar    $0x2,%edx
  801171:	89 c8                	mov    %ecx,%eax
  801173:	c1 f8 1f             	sar    $0x1f,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
  80117a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80117d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801180:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801185:	f7 e9                	imul   %ecx
  801187:	c1 fa 02             	sar    $0x2,%edx
  80118a:	89 c8                	mov    %ecx,%eax
  80118c:	c1 f8 1f             	sar    $0x1f,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
  801193:	c1 e0 02             	shl    $0x2,%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	01 c0                	add    %eax,%eax
  80119a:	29 c1                	sub    %eax,%ecx
  80119c:	89 ca                	mov    %ecx,%edx
  80119e:	85 d2                	test   %edx,%edx
  8011a0:	75 9c                	jne    80113e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	48                   	dec    %eax
  8011ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b4:	74 3d                	je     8011f3 <ltostr+0xe2>
		start = 1 ;
  8011b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011bd:	eb 34                	jmp    8011f3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 c8                	add    %ecx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f9:	7c c4                	jl     8011bf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 54 fa ff ff       	call   800c6b <strlen>
  801217:	83 c4 04             	add    $0x4,%esp
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 46 fa ff ff       	call   800c6b <strlen>
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80122b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801239:	eb 17                	jmp    801252 <strcconcat+0x49>
		final[s] = str1[s] ;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	01 c8                	add    %ecx,%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80124f:	ff 45 fc             	incl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801258:	7c e1                	jl     80123b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801261:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801268:	eb 1f                	jmp    801289 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c8                	add    %ecx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801286:	ff 45 f8             	incl   -0x8(%ebp)
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128f:	7c d9                	jl     80126a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	c6 00 00             	movb   $0x0,(%eax)
}
  80129c:	90                   	nop
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	8b 00                	mov    (%eax),%eax
  8012b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c2:	eb 0c                	jmp    8012d0 <strsplit+0x31>
			*string++ = 0;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8012cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 18                	je     8012f1 <strsplit+0x52>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 13 fb ff ff       	call   800dfd <strchr>
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	75 d3                	jne    8012c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 5a                	je     801354 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	83 f8 0f             	cmp    $0xf,%eax
  801302:	75 07                	jne    80130b <strsplit+0x6c>
		{
			return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	eb 66                	jmp    801371 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80130b:	8b 45 14             	mov    0x14(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	8d 48 01             	lea    0x1(%eax),%ecx
  801313:	8b 55 14             	mov    0x14(%ebp),%edx
  801316:	89 0a                	mov    %ecx,(%edx)
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801329:	eb 03                	jmp    80132e <strsplit+0x8f>
			string++;
  80132b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	84 c0                	test   %al,%al
  801335:	74 8b                	je     8012c2 <strsplit+0x23>
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	50                   	push   %eax
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	e8 b5 fa ff ff       	call   800dfd <strchr>
  801348:	83 c4 08             	add    $0x8,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	74 dc                	je     80132b <strsplit+0x8c>
			string++;
	}
  80134f:	e9 6e ff ff ff       	jmp    8012c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801354:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80136c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801379:	a1 04 50 80 00       	mov    0x805004,%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	74 1f                	je     8013a1 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801382:	e8 1d 00 00 00       	call   8013a4 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	68 30 3f 80 00       	push   $0x803f30
  80138f:	e8 55 f2 ff ff       	call   8005e9 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801397:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80139e:	00 00 00 
	}
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8013aa:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8013b1:	00 00 00 
  8013b4:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8013bb:	00 00 00 
  8013be:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8013c5:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013c8:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8013cf:	00 00 00 
  8013d2:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8013d9:	00 00 00 
  8013dc:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8013e3:	00 00 00 
	uint32 arr_size = 0;
  8013e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  8013ed:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013fc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801401:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801406:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  80140d:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801410:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801417:	a1 20 51 80 00       	mov    0x805120,%eax
  80141c:	c1 e0 04             	shl    $0x4,%eax
  80141f:	89 c2                	mov    %eax,%edx
  801421:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801424:	01 d0                	add    %edx,%eax
  801426:	48                   	dec    %eax
  801427:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80142a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80142d:	ba 00 00 00 00       	mov    $0x0,%edx
  801432:	f7 75 ec             	divl   -0x14(%ebp)
  801435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801438:	29 d0                	sub    %edx,%eax
  80143a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80143d:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80144c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	6a 06                	push   $0x6
  801456:	ff 75 f4             	pushl  -0xc(%ebp)
  801459:	50                   	push   %eax
  80145a:	e8 b2 05 00 00       	call   801a11 <sys_allocate_chunk>
  80145f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801462:	a1 20 51 80 00       	mov    0x805120,%eax
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	50                   	push   %eax
  80146b:	e8 27 0c 00 00       	call   802097 <initialize_MemBlocksList>
  801470:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801473:	a1 48 51 80 00       	mov    0x805148,%eax
  801478:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  80147b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  801485:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801488:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  80148f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801493:	75 14                	jne    8014a9 <initialize_dyn_block_system+0x105>
  801495:	83 ec 04             	sub    $0x4,%esp
  801498:	68 55 3f 80 00       	push   $0x803f55
  80149d:	6a 33                	push   $0x33
  80149f:	68 73 3f 80 00       	push   $0x803f73
  8014a4:	e8 8c ee ff ff       	call   800335 <_panic>
  8014a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	74 10                	je     8014c2 <initialize_dyn_block_system+0x11e>
  8014b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b5:	8b 00                	mov    (%eax),%eax
  8014b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014ba:	8b 52 04             	mov    0x4(%edx),%edx
  8014bd:	89 50 04             	mov    %edx,0x4(%eax)
  8014c0:	eb 0b                	jmp    8014cd <initialize_dyn_block_system+0x129>
  8014c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c5:	8b 40 04             	mov    0x4(%eax),%eax
  8014c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8014cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d0:	8b 40 04             	mov    0x4(%eax),%eax
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 0f                	je     8014e6 <initialize_dyn_block_system+0x142>
  8014d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014da:	8b 40 04             	mov    0x4(%eax),%eax
  8014dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014e0:	8b 12                	mov    (%edx),%edx
  8014e2:	89 10                	mov    %edx,(%eax)
  8014e4:	eb 0a                	jmp    8014f0 <initialize_dyn_block_system+0x14c>
  8014e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e9:	8b 00                	mov    (%eax),%eax
  8014eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8014f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801503:	a1 54 51 80 00       	mov    0x805154,%eax
  801508:	48                   	dec    %eax
  801509:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80150e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801512:	75 14                	jne    801528 <initialize_dyn_block_system+0x184>
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	68 80 3f 80 00       	push   $0x803f80
  80151c:	6a 34                	push   $0x34
  80151e:	68 73 3f 80 00       	push   $0x803f73
  801523:	e8 0d ee ff ff       	call   800335 <_panic>
  801528:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80152e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801531:	89 10                	mov    %edx,(%eax)
  801533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801536:	8b 00                	mov    (%eax),%eax
  801538:	85 c0                	test   %eax,%eax
  80153a:	74 0d                	je     801549 <initialize_dyn_block_system+0x1a5>
  80153c:	a1 38 51 80 00       	mov    0x805138,%eax
  801541:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801544:	89 50 04             	mov    %edx,0x4(%eax)
  801547:	eb 08                	jmp    801551 <initialize_dyn_block_system+0x1ad>
  801549:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801551:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801554:	a3 38 51 80 00       	mov    %eax,0x805138
  801559:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801563:	a1 44 51 80 00       	mov    0x805144,%eax
  801568:	40                   	inc    %eax
  801569:	a3 44 51 80 00       	mov    %eax,0x805144
}
  80156e:	90                   	nop
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
  801574:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801577:	e8 f7 fd ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  80157c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801580:	75 07                	jne    801589 <malloc+0x18>
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
  801587:	eb 61                	jmp    8015ea <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  801589:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	48                   	dec    %eax
  801599:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80159c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159f:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a4:	f7 75 f0             	divl   -0x10(%ebp)
  8015a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015aa:	29 d0                	sub    %edx,%eax
  8015ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015af:	e8 2b 08 00 00       	call   801ddf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	74 11                	je     8015c9 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015b8:	83 ec 0c             	sub    $0xc,%esp
  8015bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8015be:	e8 96 0e 00 00       	call   802459 <alloc_block_FF>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8015c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015cd:	74 16                	je     8015e5 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  8015cf:	83 ec 0c             	sub    $0xc,%esp
  8015d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d5:	e8 f2 0b 00 00       	call   8021cc <insert_sorted_allocList>
  8015da:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  8015dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e0:	8b 40 08             	mov    0x8(%eax),%eax
  8015e3:	eb 05                	jmp    8015ea <malloc+0x79>
	}

    return NULL;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 18             	sub    $0x18,%esp
<<<<<<< HEAD
=======
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	50                   	push   %eax
  8015f9:	68 40 50 80 00       	push   $0x805040
  8015fe:	e8 71 0b 00 00       	call   802174 <find_block>
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80160d:	0f 84 a6 00 00 00    	je     8016b9 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801616:	8b 50 0c             	mov    0xc(%eax),%edx
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	8b 40 08             	mov    0x8(%eax),%eax
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	52                   	push   %edx
  801623:	50                   	push   %eax
  801624:	e8 b0 03 00 00       	call   8019d9 <sys_free_user_mem>
  801629:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  80162c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801630:	75 14                	jne    801646 <free+0x5a>
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	68 55 3f 80 00       	push   $0x803f55
  80163a:	6a 74                	push   $0x74
  80163c:	68 73 3f 80 00       	push   $0x803f73
  801641:	e8 ef ec ff ff       	call   800335 <_panic>
  801646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801649:	8b 00                	mov    (%eax),%eax
  80164b:	85 c0                	test   %eax,%eax
  80164d:	74 10                	je     80165f <free+0x73>
  80164f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801652:	8b 00                	mov    (%eax),%eax
  801654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801657:	8b 52 04             	mov    0x4(%edx),%edx
  80165a:	89 50 04             	mov    %edx,0x4(%eax)
  80165d:	eb 0b                	jmp    80166a <free+0x7e>
  80165f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801662:	8b 40 04             	mov    0x4(%eax),%eax
  801665:	a3 44 50 80 00       	mov    %eax,0x805044
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	8b 40 04             	mov    0x4(%eax),%eax
  801670:	85 c0                	test   %eax,%eax
  801672:	74 0f                	je     801683 <free+0x97>
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	8b 40 04             	mov    0x4(%eax),%eax
  80167a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167d:	8b 12                	mov    (%edx),%edx
  80167f:	89 10                	mov    %edx,(%eax)
  801681:	eb 0a                	jmp    80168d <free+0xa1>
  801683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801686:	8b 00                	mov    (%eax),%eax
  801688:	a3 40 50 80 00       	mov    %eax,0x805040
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801699:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8016a5:	48                   	dec    %eax
  8016a6:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  8016ab:	83 ec 0c             	sub    $0xc,%esp
  8016ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b1:	e8 4e 17 00 00       	call   802e04 <insert_sorted_with_merge_freeList>
  8016b6:	83 c4 10             	add    $0x10,%esp
	}
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
<<<<<<< HEAD

	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	50                   	push   %eax
  8015f9:	68 40 50 80 00       	push   $0x805040
  8015fe:	e8 71 0b 00 00       	call   802174 <find_block>
  801603:	83 c4 10             	add    $0x10,%esp
  801606:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    if(free_block!=NULL)
  801609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80160d:	0f 84 a6 00 00 00    	je     8016b9 <free+0xcd>
	    {
	    	sys_free_user_mem(free_block->sva,free_block->size);
  801613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801616:	8b 50 0c             	mov    0xc(%eax),%edx
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	8b 40 08             	mov    0x8(%eax),%eax
  80161f:	83 ec 08             	sub    $0x8,%esp
  801622:	52                   	push   %edx
  801623:	50                   	push   %eax
  801624:	e8 b0 03 00 00       	call   8019d9 <sys_free_user_mem>
  801629:	83 c4 10             	add    $0x10,%esp
	    	LIST_REMOVE(&AllocMemBlocksList,free_block);
  80162c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801630:	75 14                	jne    801646 <free+0x5a>
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	68 55 3f 80 00       	push   $0x803f55
  80163a:	6a 7a                	push   $0x7a
  80163c:	68 73 3f 80 00       	push   $0x803f73
  801641:	e8 ef ec ff ff       	call   800335 <_panic>
  801646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801649:	8b 00                	mov    (%eax),%eax
  80164b:	85 c0                	test   %eax,%eax
  80164d:	74 10                	je     80165f <free+0x73>
  80164f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801652:	8b 00                	mov    (%eax),%eax
  801654:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801657:	8b 52 04             	mov    0x4(%edx),%edx
  80165a:	89 50 04             	mov    %edx,0x4(%eax)
  80165d:	eb 0b                	jmp    80166a <free+0x7e>
  80165f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801662:	8b 40 04             	mov    0x4(%eax),%eax
  801665:	a3 44 50 80 00       	mov    %eax,0x805044
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	8b 40 04             	mov    0x4(%eax),%eax
  801670:	85 c0                	test   %eax,%eax
  801672:	74 0f                	je     801683 <free+0x97>
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	8b 40 04             	mov    0x4(%eax),%eax
  80167a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167d:	8b 12                	mov    (%edx),%edx
  80167f:	89 10                	mov    %edx,(%eax)
  801681:	eb 0a                	jmp    80168d <free+0xa1>
  801683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801686:	8b 00                	mov    (%eax),%eax
  801688:	a3 40 50 80 00       	mov    %eax,0x805040
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801699:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8016a5:	48                   	dec    %eax
  8016a6:	a3 4c 50 80 00       	mov    %eax,0x80504c
	        insert_sorted_with_merge_freeList(free_block);
  8016ab:	83 ec 0c             	sub    $0xc,%esp
  8016ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b1:	e8 4e 17 00 00       	call   802e04 <insert_sorted_with_merge_freeList>
  8016b6:	83 c4 10             	add    $0x10,%esp



	    }
=======
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
}
  8016b9:	90                   	nop
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
  8016bf:	83 ec 38             	sub    $0x38,%esp
  8016c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c8:	e8 a6 fc ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d1:	75 0a                	jne    8016dd <smalloc+0x21>
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d8:	e9 8b 00 00 00       	jmp    801768 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016dd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	01 d0                	add    %edx,%eax
  8016ec:	48                   	dec    %eax
  8016ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f8:	f7 75 f0             	divl   -0x10(%ebp)
  8016fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fe:	29 d0                	sub    %edx,%eax
  801700:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801703:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80170a:	e8 d0 06 00 00       	call   801ddf <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170f:	85 c0                	test   %eax,%eax
  801711:	74 11                	je     801724 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801713:	83 ec 0c             	sub    $0xc,%esp
  801716:	ff 75 e8             	pushl  -0x18(%ebp)
  801719:	e8 3b 0d 00 00       	call   802459 <alloc_block_FF>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801724:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801728:	74 39                	je     801763 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80172a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172d:	8b 40 08             	mov    0x8(%eax),%eax
  801730:	89 c2                	mov    %eax,%edx
  801732:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801736:	52                   	push   %edx
  801737:	50                   	push   %eax
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	ff 75 08             	pushl  0x8(%ebp)
  80173e:	e8 21 04 00 00       	call   801b64 <sys_createSharedObject>
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801749:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80174d:	74 14                	je     801763 <smalloc+0xa7>
  80174f:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801753:	74 0e                	je     801763 <smalloc+0xa7>
  801755:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801759:	74 08                	je     801763 <smalloc+0xa7>
			return (void*) mem_block->sva;
  80175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175e:	8b 40 08             	mov    0x8(%eax),%eax
  801761:	eb 05                	jmp    801768 <smalloc+0xac>
	}
	return NULL;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801770:	e8 fe fb ff ff       	call   801373 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	ff 75 0c             	pushl  0xc(%ebp)
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	e8 0b 04 00 00       	call   801b8e <sys_getSizeOfSharedObject>
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801789:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80178d:	74 76                	je     801805 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80178f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801796:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	48                   	dec    %eax
  80179f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017aa:	f7 75 ec             	divl   -0x14(%ebp)
  8017ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b0:	29 d0                	sub    %edx,%eax
  8017b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8017b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017bc:	e8 1e 06 00 00       	call   801ddf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	74 11                	je     8017d6 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8017c5:	83 ec 0c             	sub    $0xc,%esp
  8017c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017cb:	e8 89 0c 00 00       	call   802459 <alloc_block_FF>
  8017d0:	83 c4 10             	add    $0x10,%esp
  8017d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8017d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017da:	74 29                	je     801805 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  8017dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017df:	8b 40 08             	mov    0x8(%eax),%eax
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	50                   	push   %eax
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	e8 ba 03 00 00       	call   801bab <sys_getSharedObject>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  8017f7:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  8017fb:	74 08                	je     801805 <sget+0x9b>
				return (void *)mem_block->sva;
  8017fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801800:	8b 40 08             	mov    0x8(%eax),%eax
  801803:	eb 05                	jmp    80180a <sget+0xa0>
		}
	}
	return NULL;
  801805:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801812:	e8 5c fb ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	68 a4 3f 80 00       	push   $0x803fa4
<<<<<<< HEAD
  80181f:	68 fc 00 00 00       	push   $0xfc
=======
  80181f:	68 f7 00 00 00       	push   $0xf7
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801824:	68 73 3f 80 00       	push   $0x803f73
  801829:	e8 07 eb ff ff       	call   800335 <_panic>

0080182e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()


	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	68 cc 3f 80 00       	push   $0x803fcc
<<<<<<< HEAD
  80183c:	68 10 01 00 00       	push   $0x110
=======
  80183c:	68 0c 01 00 00       	push   $0x10c
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801841:	68 73 3f 80 00       	push   $0x803f73
  801846:	e8 ea ea ff ff       	call   800335 <_panic>

0080184b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801851:	83 ec 04             	sub    $0x4,%esp
  801854:	68 f0 3f 80 00       	push   $0x803ff0
<<<<<<< HEAD
  801859:	68 1b 01 00 00       	push   $0x11b
=======
  801859:	68 44 01 00 00       	push   $0x144
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  80185e:	68 73 3f 80 00       	push   $0x803f73
  801863:	e8 cd ea ff ff       	call   800335 <_panic>

00801868 <shrink>:

}
void shrink(uint32 newSize)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186e:	83 ec 04             	sub    $0x4,%esp
  801871:	68 f0 3f 80 00       	push   $0x803ff0
<<<<<<< HEAD
  801876:	68 20 01 00 00       	push   $0x120
=======
  801876:	68 49 01 00 00       	push   $0x149
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  80187b:	68 73 3f 80 00       	push   $0x803f73
  801880:	e8 b0 ea ff ff       	call   800335 <_panic>

00801885 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188b:	83 ec 04             	sub    $0x4,%esp
  80188e:	68 f0 3f 80 00       	push   $0x803ff0
<<<<<<< HEAD
  801893:	68 25 01 00 00       	push   $0x125
=======
  801893:	68 4e 01 00 00       	push   $0x14e
>>>>>>> 6d683e8a06489828f6050ec354ed0ccdd03af7f9
  801898:	68 73 3f 80 00       	push   $0x803f73
  80189d:	e8 93 ea ff ff       	call   800335 <_panic>

008018a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	57                   	push   %edi
  8018a6:	56                   	push   %esi
  8018a7:	53                   	push   %ebx
  8018a8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018bd:	cd 30                	int    $0x30
  8018bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	5b                   	pop    %ebx
  8018c9:	5e                   	pop    %esi
  8018ca:	5f                   	pop    %edi
  8018cb:	5d                   	pop    %ebp
  8018cc:	c3                   	ret    

008018cd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 04             	sub    $0x4,%esp
  8018d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	50                   	push   %eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	e8 b2 ff ff ff       	call   8018a2 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	90                   	nop
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 01                	push   $0x1
  801905:	e8 98 ff ff ff       	call   8018a2 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801912:	8b 55 0c             	mov    0xc(%ebp),%edx
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	6a 05                	push   $0x5
  801922:	e8 7b ff ff ff       	call   8018a2 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801931:	8b 75 18             	mov    0x18(%ebp),%esi
  801934:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801937:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	51                   	push   %ecx
  801943:	52                   	push   %edx
  801944:	50                   	push   %eax
  801945:	6a 06                	push   $0x6
  801947:	e8 56 ff ff ff       	call   8018a2 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801952:	5b                   	pop    %ebx
  801953:	5e                   	pop    %esi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    

00801956 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	52                   	push   %edx
  801966:	50                   	push   %eax
  801967:	6a 07                	push   $0x7
  801969:	e8 34 ff ff ff       	call   8018a2 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 08                	push   $0x8
  801984:	e8 19 ff ff ff       	call   8018a2 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 09                	push   $0x9
  80199d:	e8 00 ff ff ff       	call   8018a2 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 0a                	push   $0xa
  8019b6:	e8 e7 fe ff ff       	call   8018a2 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 0b                	push   $0xb
  8019cf:	e8 ce fe ff ff       	call   8018a2 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 0c             	pushl  0xc(%ebp)
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	6a 0f                	push   $0xf
  8019ea:	e8 b3 fe ff ff       	call   8018a2 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
	return;
  8019f2:	90                   	nop
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	ff 75 0c             	pushl  0xc(%ebp)
  801a01:	ff 75 08             	pushl  0x8(%ebp)
  801a04:	6a 10                	push   $0x10
  801a06:	e8 97 fe ff ff       	call   8018a2 <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0e:	90                   	nop
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	ff 75 10             	pushl  0x10(%ebp)
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	ff 75 08             	pushl  0x8(%ebp)
  801a21:	6a 11                	push   $0x11
  801a23:	e8 7a fe ff ff       	call   8018a2 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2b:	90                   	nop
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 0c                	push   $0xc
  801a3d:	e8 60 fe ff ff       	call   8018a2 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	6a 0d                	push   $0xd
  801a57:	e8 46 fe ff ff       	call   8018a2 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 0e                	push   $0xe
  801a70:	e8 2d fe ff ff       	call   8018a2 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	90                   	nop
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 13                	push   $0x13
  801a8a:	e8 13 fe ff ff       	call   8018a2 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	90                   	nop
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 14                	push   $0x14
  801aa4:	e8 f9 fd ff ff       	call   8018a2 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_cputc>:


void
sys_cputc(const char c)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 04             	sub    $0x4,%esp
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801abb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	50                   	push   %eax
  801ac8:	6a 15                	push   $0x15
  801aca:	e8 d3 fd ff ff       	call   8018a2 <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	90                   	nop
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 16                	push   $0x16
  801ae4:	e8 b9 fd ff ff       	call   8018a2 <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	50                   	push   %eax
  801aff:	6a 17                	push   $0x17
  801b01:	e8 9c fd ff ff       	call   8018a2 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 1a                	push   $0x1a
  801b1e:	e8 7f fd ff ff       	call   8018a2 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	52                   	push   %edx
  801b38:	50                   	push   %eax
  801b39:	6a 18                	push   $0x18
  801b3b:	e8 62 fd ff ff       	call   8018a2 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	90                   	nop
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 19                	push   $0x19
  801b59:	e8 44 fd ff ff       	call   8018a2 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
}
  801b61:	90                   	nop
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 04             	sub    $0x4,%esp
  801b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	51                   	push   %ecx
  801b7d:	52                   	push   %edx
  801b7e:	ff 75 0c             	pushl  0xc(%ebp)
  801b81:	50                   	push   %eax
  801b82:	6a 1b                	push   $0x1b
  801b84:	e8 19 fd ff ff       	call   8018a2 <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	52                   	push   %edx
  801b9e:	50                   	push   %eax
  801b9f:	6a 1c                	push   $0x1c
  801ba1:	e8 fc fc ff ff       	call   8018a2 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	51                   	push   %ecx
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 1d                	push   $0x1d
  801bc0:	e8 dd fc ff ff       	call   8018a2 <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	52                   	push   %edx
  801bda:	50                   	push   %eax
  801bdb:	6a 1e                	push   $0x1e
  801bdd:	e8 c0 fc ff ff       	call   8018a2 <syscall>
  801be2:	83 c4 18             	add    $0x18,%esp
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 1f                	push   $0x1f
  801bf6:	e8 a7 fc ff ff       	call   8018a2 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	ff 75 14             	pushl  0x14(%ebp)
  801c0b:	ff 75 10             	pushl  0x10(%ebp)
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	50                   	push   %eax
  801c12:	6a 20                	push   $0x20
  801c14:	e8 89 fc ff ff       	call   8018a2 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	50                   	push   %eax
  801c2d:	6a 21                	push   $0x21
  801c2f:	e8 6e fc ff ff       	call   8018a2 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	90                   	nop
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	50                   	push   %eax
  801c49:	6a 22                	push   $0x22
  801c4b:	e8 52 fc ff ff       	call   8018a2 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 02                	push   $0x2
  801c64:	e8 39 fc ff ff       	call   8018a2 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 03                	push   $0x3
  801c7d:	e8 20 fc ff ff       	call   8018a2 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 04                	push   $0x4
  801c96:	e8 07 fc ff ff       	call   8018a2 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_exit_env>:


void sys_exit_env(void)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 23                	push   $0x23
  801caf:	e8 ee fb ff ff       	call   8018a2 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	90                   	nop
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
  801cbd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cc0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc3:	8d 50 04             	lea    0x4(%eax),%edx
  801cc6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	6a 24                	push   $0x24
  801cd3:	e8 ca fb ff ff       	call   8018a2 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return result;
  801cdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ce1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ce4:	89 01                	mov    %eax,(%ecx)
  801ce6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	c9                   	leave  
  801ced:	c2 04 00             	ret    $0x4

00801cf0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	ff 75 10             	pushl  0x10(%ebp)
  801cfa:	ff 75 0c             	pushl  0xc(%ebp)
  801cfd:	ff 75 08             	pushl  0x8(%ebp)
  801d00:	6a 12                	push   $0x12
  801d02:	e8 9b fb ff ff       	call   8018a2 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0a:	90                   	nop
}
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_rcr2>:
uint32 sys_rcr2()
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 25                	push   $0x25
  801d1c:	e8 81 fb ff ff       	call   8018a2 <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d32:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	50                   	push   %eax
  801d3f:	6a 26                	push   $0x26
  801d41:	e8 5c fb ff ff       	call   8018a2 <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
	return ;
  801d49:	90                   	nop
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <rsttst>:
void rsttst()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 28                	push   $0x28
  801d5b:	e8 42 fb ff ff       	call   8018a2 <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
	return ;
  801d63:	90                   	nop
}
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 04             	sub    $0x4,%esp
  801d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d72:	8b 55 18             	mov    0x18(%ebp),%edx
  801d75:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d79:	52                   	push   %edx
  801d7a:	50                   	push   %eax
  801d7b:	ff 75 10             	pushl  0x10(%ebp)
  801d7e:	ff 75 0c             	pushl  0xc(%ebp)
  801d81:	ff 75 08             	pushl  0x8(%ebp)
  801d84:	6a 27                	push   $0x27
  801d86:	e8 17 fb ff ff       	call   8018a2 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8e:	90                   	nop
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <chktst>:
void chktst(uint32 n)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	6a 29                	push   $0x29
  801da1:	e8 fc fa ff ff       	call   8018a2 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
	return ;
  801da9:	90                   	nop
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <inctst>:

void inctst()
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 2a                	push   $0x2a
  801dbb:	e8 e2 fa ff ff       	call   8018a2 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc3:	90                   	nop
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <gettst>:
uint32 gettst()
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 2b                	push   $0x2b
  801dd5:	e8 c8 fa ff ff       	call   8018a2 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 2c                	push   $0x2c
  801df1:	e8 ac fa ff ff       	call   8018a2 <syscall>
  801df6:	83 c4 18             	add    $0x18,%esp
  801df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dfc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e00:	75 07                	jne    801e09 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e02:	b8 01 00 00 00       	mov    $0x1,%eax
  801e07:	eb 05                	jmp    801e0e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 2c                	push   $0x2c
  801e22:	e8 7b fa ff ff       	call   8018a2 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
  801e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e2d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e31:	75 07                	jne    801e3a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e33:	b8 01 00 00 00       	mov    $0x1,%eax
  801e38:	eb 05                	jmp    801e3f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 2c                	push   $0x2c
  801e53:	e8 4a fa ff ff       	call   8018a2 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
  801e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e5e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e62:	75 07                	jne    801e6b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e64:	b8 01 00 00 00       	mov    $0x1,%eax
  801e69:	eb 05                	jmp    801e70 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 2c                	push   $0x2c
  801e84:	e8 19 fa ff ff       	call   8018a2 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
  801e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e8f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e93:	75 07                	jne    801e9c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9a:	eb 05                	jmp    801ea1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	ff 75 08             	pushl  0x8(%ebp)
  801eb1:	6a 2d                	push   $0x2d
  801eb3:	e8 ea f9 ff ff       	call   8018a2 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebb:	90                   	nop
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ec2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	53                   	push   %ebx
  801ed1:	51                   	push   %ecx
  801ed2:	52                   	push   %edx
  801ed3:	50                   	push   %eax
  801ed4:	6a 2e                	push   $0x2e
  801ed6:	e8 c7 f9 ff ff       	call   8018a2 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	52                   	push   %edx
  801ef3:	50                   	push   %eax
  801ef4:	6a 2f                	push   $0x2f
  801ef6:	e8 a7 f9 ff ff       	call   8018a2 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f06:	83 ec 0c             	sub    $0xc,%esp
  801f09:	68 00 40 80 00       	push   $0x804000
  801f0e:	e8 d6 e6 ff ff       	call   8005e9 <cprintf>
  801f13:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	68 2c 40 80 00       	push   $0x80402c
  801f25:	e8 bf e6 ff ff       	call   8005e9 <cprintf>
  801f2a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f2d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f31:	a1 38 51 80 00       	mov    0x805138,%eax
  801f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f39:	eb 56                	jmp    801f91 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f3f:	74 1c                	je     801f5d <print_mem_block_lists+0x5d>
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	8b 50 08             	mov    0x8(%eax),%edx
  801f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f50:	8b 40 0c             	mov    0xc(%eax),%eax
  801f53:	01 c8                	add    %ecx,%eax
  801f55:	39 c2                	cmp    %eax,%edx
  801f57:	73 04                	jae    801f5d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f59:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	8b 50 08             	mov    0x8(%eax),%edx
  801f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f66:	8b 40 0c             	mov    0xc(%eax),%eax
  801f69:	01 c2                	add    %eax,%edx
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 40 08             	mov    0x8(%eax),%eax
  801f71:	83 ec 04             	sub    $0x4,%esp
  801f74:	52                   	push   %edx
  801f75:	50                   	push   %eax
  801f76:	68 41 40 80 00       	push   $0x804041
  801f7b:	e8 69 e6 ff ff       	call   8005e9 <cprintf>
  801f80:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f89:	a1 40 51 80 00       	mov    0x805140,%eax
  801f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f95:	74 07                	je     801f9e <print_mem_block_lists+0x9e>
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 00                	mov    (%eax),%eax
  801f9c:	eb 05                	jmp    801fa3 <print_mem_block_lists+0xa3>
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa3:	a3 40 51 80 00       	mov    %eax,0x805140
  801fa8:	a1 40 51 80 00       	mov    0x805140,%eax
  801fad:	85 c0                	test   %eax,%eax
  801faf:	75 8a                	jne    801f3b <print_mem_block_lists+0x3b>
  801fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb5:	75 84                	jne    801f3b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fb7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fbb:	75 10                	jne    801fcd <print_mem_block_lists+0xcd>
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 50 40 80 00       	push   $0x804050
  801fc5:	e8 1f e6 ff ff       	call   8005e9 <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fd4:	83 ec 0c             	sub    $0xc,%esp
  801fd7:	68 74 40 80 00       	push   $0x804074
  801fdc:	e8 08 e6 ff ff       	call   8005e9 <cprintf>
  801fe1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fe4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fe8:	a1 40 50 80 00       	mov    0x805040,%eax
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff0:	eb 56                	jmp    802048 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ff2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ff6:	74 1c                	je     802014 <print_mem_block_lists+0x114>
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	8b 50 08             	mov    0x8(%eax),%edx
  801ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802001:	8b 48 08             	mov    0x8(%eax),%ecx
  802004:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802007:	8b 40 0c             	mov    0xc(%eax),%eax
  80200a:	01 c8                	add    %ecx,%eax
  80200c:	39 c2                	cmp    %eax,%edx
  80200e:	73 04                	jae    802014 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802010:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	8b 50 08             	mov    0x8(%eax),%edx
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	8b 40 0c             	mov    0xc(%eax),%eax
  802020:	01 c2                	add    %eax,%edx
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 40 08             	mov    0x8(%eax),%eax
  802028:	83 ec 04             	sub    $0x4,%esp
  80202b:	52                   	push   %edx
  80202c:	50                   	push   %eax
  80202d:	68 41 40 80 00       	push   $0x804041
  802032:	e8 b2 e5 ff ff       	call   8005e9 <cprintf>
  802037:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802040:	a1 48 50 80 00       	mov    0x805048,%eax
  802045:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802048:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204c:	74 07                	je     802055 <print_mem_block_lists+0x155>
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 00                	mov    (%eax),%eax
  802053:	eb 05                	jmp    80205a <print_mem_block_lists+0x15a>
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
  80205a:	a3 48 50 80 00       	mov    %eax,0x805048
  80205f:	a1 48 50 80 00       	mov    0x805048,%eax
  802064:	85 c0                	test   %eax,%eax
  802066:	75 8a                	jne    801ff2 <print_mem_block_lists+0xf2>
  802068:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206c:	75 84                	jne    801ff2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80206e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802072:	75 10                	jne    802084 <print_mem_block_lists+0x184>
  802074:	83 ec 0c             	sub    $0xc,%esp
  802077:	68 8c 40 80 00       	push   $0x80408c
  80207c:	e8 68 e5 ff ff       	call   8005e9 <cprintf>
  802081:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802084:	83 ec 0c             	sub    $0xc,%esp
  802087:	68 00 40 80 00       	push   $0x804000
  80208c:	e8 58 e5 ff ff       	call   8005e9 <cprintf>
  802091:	83 c4 10             	add    $0x10,%esp

}
  802094:	90                   	nop
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
  80209a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80209d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020a4:	00 00 00 
  8020a7:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020ae:	00 00 00 
  8020b1:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020b8:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020c2:	e9 9e 00 00 00       	jmp    802165 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020c7:	a1 50 50 80 00       	mov    0x805050,%eax
  8020cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cf:	c1 e2 04             	shl    $0x4,%edx
  8020d2:	01 d0                	add    %edx,%eax
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	75 14                	jne    8020ec <initialize_MemBlocksList+0x55>
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	68 b4 40 80 00       	push   $0x8040b4
  8020e0:	6a 46                	push   $0x46
  8020e2:	68 d7 40 80 00       	push   $0x8040d7
  8020e7:	e8 49 e2 ff ff       	call   800335 <_panic>
  8020ec:	a1 50 50 80 00       	mov    0x805050,%eax
  8020f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f4:	c1 e2 04             	shl    $0x4,%edx
  8020f7:	01 d0                	add    %edx,%eax
  8020f9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8020ff:	89 10                	mov    %edx,(%eax)
  802101:	8b 00                	mov    (%eax),%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	74 18                	je     80211f <initialize_MemBlocksList+0x88>
  802107:	a1 48 51 80 00       	mov    0x805148,%eax
  80210c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802112:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802115:	c1 e1 04             	shl    $0x4,%ecx
  802118:	01 ca                	add    %ecx,%edx
  80211a:	89 50 04             	mov    %edx,0x4(%eax)
  80211d:	eb 12                	jmp    802131 <initialize_MemBlocksList+0x9a>
  80211f:	a1 50 50 80 00       	mov    0x805050,%eax
  802124:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802127:	c1 e2 04             	shl    $0x4,%edx
  80212a:	01 d0                	add    %edx,%eax
  80212c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802131:	a1 50 50 80 00       	mov    0x805050,%eax
  802136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802139:	c1 e2 04             	shl    $0x4,%edx
  80213c:	01 d0                	add    %edx,%eax
  80213e:	a3 48 51 80 00       	mov    %eax,0x805148
  802143:	a1 50 50 80 00       	mov    0x805050,%eax
  802148:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214b:	c1 e2 04             	shl    $0x4,%edx
  80214e:	01 d0                	add    %edx,%eax
  802150:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802157:	a1 54 51 80 00       	mov    0x805154,%eax
  80215c:	40                   	inc    %eax
  80215d:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802162:	ff 45 f4             	incl   -0xc(%ebp)
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	3b 45 08             	cmp    0x8(%ebp),%eax
  80216b:	0f 82 56 ff ff ff    	jb     8020c7 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802171:	90                   	nop
  802172:	c9                   	leave  
  802173:	c3                   	ret    

00802174 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	8b 00                	mov    (%eax),%eax
  80217f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802182:	eb 19                	jmp    80219d <find_block+0x29>
	{
		if(va==point->sva)
  802184:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802187:	8b 40 08             	mov    0x8(%eax),%eax
  80218a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80218d:	75 05                	jne    802194 <find_block+0x20>
		   return point;
  80218f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802192:	eb 36                	jmp    8021ca <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8b 40 08             	mov    0x8(%eax),%eax
  80219a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80219d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021a1:	74 07                	je     8021aa <find_block+0x36>
  8021a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a6:	8b 00                	mov    (%eax),%eax
  8021a8:	eb 05                	jmp    8021af <find_block+0x3b>
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b2:	89 42 08             	mov    %eax,0x8(%edx)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8b 40 08             	mov    0x8(%eax),%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	75 c5                	jne    802184 <find_block+0x10>
  8021bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021c3:	75 bf                	jne    802184 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ca:	c9                   	leave  
  8021cb:	c3                   	ret    

008021cc <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021cc:	55                   	push   %ebp
  8021cd:	89 e5                	mov    %esp,%ebp
  8021cf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8021d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8021d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8021da:	a1 44 50 80 00       	mov    0x805044,%eax
  8021df:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8021e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021e8:	74 24                	je     80220e <insert_sorted_allocList+0x42>
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8b 50 08             	mov    0x8(%eax),%edx
  8021f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f3:	8b 40 08             	mov    0x8(%eax),%eax
  8021f6:	39 c2                	cmp    %eax,%edx
  8021f8:	76 14                	jbe    80220e <insert_sorted_allocList+0x42>
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	8b 50 08             	mov    0x8(%eax),%edx
  802200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802203:	8b 40 08             	mov    0x8(%eax),%eax
  802206:	39 c2                	cmp    %eax,%edx
  802208:	0f 82 60 01 00 00    	jb     80236e <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80220e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802212:	75 65                	jne    802279 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802218:	75 14                	jne    80222e <insert_sorted_allocList+0x62>
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	68 b4 40 80 00       	push   $0x8040b4
  802222:	6a 6b                	push   $0x6b
  802224:	68 d7 40 80 00       	push   $0x8040d7
  802229:	e8 07 e1 ff ff       	call   800335 <_panic>
  80222e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	89 10                	mov    %edx,(%eax)
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	74 0d                	je     80224f <insert_sorted_allocList+0x83>
  802242:	a1 40 50 80 00       	mov    0x805040,%eax
  802247:	8b 55 08             	mov    0x8(%ebp),%edx
  80224a:	89 50 04             	mov    %edx,0x4(%eax)
  80224d:	eb 08                	jmp    802257 <insert_sorted_allocList+0x8b>
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	a3 44 50 80 00       	mov    %eax,0x805044
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	a3 40 50 80 00       	mov    %eax,0x805040
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802269:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80226e:	40                   	inc    %eax
  80226f:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802274:	e9 dc 01 00 00       	jmp    802455 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	8b 50 08             	mov    0x8(%eax),%edx
  80227f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802282:	8b 40 08             	mov    0x8(%eax),%eax
  802285:	39 c2                	cmp    %eax,%edx
  802287:	77 6c                	ja     8022f5 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802289:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80228d:	74 06                	je     802295 <insert_sorted_allocList+0xc9>
  80228f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802293:	75 14                	jne    8022a9 <insert_sorted_allocList+0xdd>
  802295:	83 ec 04             	sub    $0x4,%esp
  802298:	68 f0 40 80 00       	push   $0x8040f0
  80229d:	6a 6f                	push   $0x6f
  80229f:	68 d7 40 80 00       	push   $0x8040d7
  8022a4:	e8 8c e0 ff ff       	call   800335 <_panic>
  8022a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ac:	8b 50 04             	mov    0x4(%eax),%edx
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	89 50 04             	mov    %edx,0x4(%eax)
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bb:	89 10                	mov    %edx,(%eax)
  8022bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c0:	8b 40 04             	mov    0x4(%eax),%eax
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 0d                	je     8022d4 <insert_sorted_allocList+0x108>
  8022c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ca:	8b 40 04             	mov    0x4(%eax),%eax
  8022cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d0:	89 10                	mov    %edx,(%eax)
  8022d2:	eb 08                	jmp    8022dc <insert_sorted_allocList+0x110>
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 40 50 80 00       	mov    %eax,0x805040
  8022dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022df:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e2:	89 50 04             	mov    %edx,0x4(%eax)
  8022e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ea:	40                   	inc    %eax
  8022eb:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022f0:	e9 60 01 00 00       	jmp    802455 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	8b 50 08             	mov    0x8(%eax),%edx
  8022fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022fe:	8b 40 08             	mov    0x8(%eax),%eax
  802301:	39 c2                	cmp    %eax,%edx
  802303:	0f 82 4c 01 00 00    	jb     802455 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802309:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80230d:	75 14                	jne    802323 <insert_sorted_allocList+0x157>
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	68 28 41 80 00       	push   $0x804128
  802317:	6a 73                	push   $0x73
  802319:	68 d7 40 80 00       	push   $0x8040d7
  80231e:	e8 12 e0 ff ff       	call   800335 <_panic>
  802323:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	89 50 04             	mov    %edx,0x4(%eax)
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	8b 40 04             	mov    0x4(%eax),%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	74 0c                	je     802345 <insert_sorted_allocList+0x179>
  802339:	a1 44 50 80 00       	mov    0x805044,%eax
  80233e:	8b 55 08             	mov    0x8(%ebp),%edx
  802341:	89 10                	mov    %edx,(%eax)
  802343:	eb 08                	jmp    80234d <insert_sorted_allocList+0x181>
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	a3 40 50 80 00       	mov    %eax,0x805040
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	a3 44 50 80 00       	mov    %eax,0x805044
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80235e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802363:	40                   	inc    %eax
  802364:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802369:	e9 e7 00 00 00       	jmp    802455 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80236e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802371:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802374:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80237b:	a1 40 50 80 00       	mov    0x805040,%eax
  802380:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802383:	e9 9d 00 00 00       	jmp    802425 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	8b 50 08             	mov    0x8(%eax),%edx
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 40 08             	mov    0x8(%eax),%eax
  80239c:	39 c2                	cmp    %eax,%edx
  80239e:	76 7d                	jbe    80241d <insert_sorted_allocList+0x251>
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	8b 50 08             	mov    0x8(%eax),%edx
  8023a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a9:	8b 40 08             	mov    0x8(%eax),%eax
  8023ac:	39 c2                	cmp    %eax,%edx
  8023ae:	73 6d                	jae    80241d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b4:	74 06                	je     8023bc <insert_sorted_allocList+0x1f0>
  8023b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ba:	75 14                	jne    8023d0 <insert_sorted_allocList+0x204>
  8023bc:	83 ec 04             	sub    $0x4,%esp
  8023bf:	68 4c 41 80 00       	push   $0x80414c
  8023c4:	6a 7f                	push   $0x7f
  8023c6:	68 d7 40 80 00       	push   $0x8040d7
  8023cb:	e8 65 df ff ff       	call   800335 <_panic>
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 10                	mov    (%eax),%edx
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	89 10                	mov    %edx,(%eax)
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 0b                	je     8023ee <insert_sorted_allocList+0x222>
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023eb:	89 50 04             	mov    %edx,0x4(%eax)
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f4:	89 10                	mov    %edx,(%eax)
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023fc:	89 50 04             	mov    %edx,0x4(%eax)
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	85 c0                	test   %eax,%eax
  802406:	75 08                	jne    802410 <insert_sorted_allocList+0x244>
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	a3 44 50 80 00       	mov    %eax,0x805044
  802410:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802415:	40                   	inc    %eax
  802416:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80241b:	eb 39                	jmp    802456 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80241d:	a1 48 50 80 00       	mov    0x805048,%eax
  802422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802425:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802429:	74 07                	je     802432 <insert_sorted_allocList+0x266>
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 00                	mov    (%eax),%eax
  802430:	eb 05                	jmp    802437 <insert_sorted_allocList+0x26b>
  802432:	b8 00 00 00 00       	mov    $0x0,%eax
  802437:	a3 48 50 80 00       	mov    %eax,0x805048
  80243c:	a1 48 50 80 00       	mov    0x805048,%eax
  802441:	85 c0                	test   %eax,%eax
  802443:	0f 85 3f ff ff ff    	jne    802388 <insert_sorted_allocList+0x1bc>
  802449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244d:	0f 85 35 ff ff ff    	jne    802388 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802453:	eb 01                	jmp    802456 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802455:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802456:	90                   	nop
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80245f:	a1 38 51 80 00       	mov    0x805138,%eax
  802464:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802467:	e9 85 01 00 00       	jmp    8025f1 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 0c             	mov    0xc(%eax),%eax
  802472:	3b 45 08             	cmp    0x8(%ebp),%eax
  802475:	0f 82 6e 01 00 00    	jb     8025e9 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 40 0c             	mov    0xc(%eax),%eax
  802481:	3b 45 08             	cmp    0x8(%ebp),%eax
  802484:	0f 85 8a 00 00 00    	jne    802514 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80248a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248e:	75 17                	jne    8024a7 <alloc_block_FF+0x4e>
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	68 80 41 80 00       	push   $0x804180
  802498:	68 93 00 00 00       	push   $0x93
  80249d:	68 d7 40 80 00       	push   $0x8040d7
  8024a2:	e8 8e de ff ff       	call   800335 <_panic>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 10                	je     8024c0 <alloc_block_FF+0x67>
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b8:	8b 52 04             	mov    0x4(%edx),%edx
  8024bb:	89 50 04             	mov    %edx,0x4(%eax)
  8024be:	eb 0b                	jmp    8024cb <alloc_block_FF+0x72>
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 04             	mov    0x4(%eax),%eax
  8024c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 0f                	je     8024e4 <alloc_block_FF+0x8b>
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 40 04             	mov    0x4(%eax),%eax
  8024db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024de:	8b 12                	mov    (%edx),%edx
  8024e0:	89 10                	mov    %edx,(%eax)
  8024e2:	eb 0a                	jmp    8024ee <alloc_block_FF+0x95>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802501:	a1 44 51 80 00       	mov    0x805144,%eax
  802506:	48                   	dec    %eax
  802507:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	e9 10 01 00 00       	jmp    802624 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 40 0c             	mov    0xc(%eax),%eax
  80251a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251d:	0f 86 c6 00 00 00    	jbe    8025e9 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802523:	a1 48 51 80 00       	mov    0x805148,%eax
  802528:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 50 08             	mov    0x8(%eax),%edx
  802531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802534:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	8b 55 08             	mov    0x8(%ebp),%edx
  80253d:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802540:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802544:	75 17                	jne    80255d <alloc_block_FF+0x104>
  802546:	83 ec 04             	sub    $0x4,%esp
  802549:	68 80 41 80 00       	push   $0x804180
  80254e:	68 9b 00 00 00       	push   $0x9b
  802553:	68 d7 40 80 00       	push   $0x8040d7
  802558:	e8 d8 dd ff ff       	call   800335 <_panic>
  80255d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	85 c0                	test   %eax,%eax
  802564:	74 10                	je     802576 <alloc_block_FF+0x11d>
  802566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80256e:	8b 52 04             	mov    0x4(%edx),%edx
  802571:	89 50 04             	mov    %edx,0x4(%eax)
  802574:	eb 0b                	jmp    802581 <alloc_block_FF+0x128>
  802576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802579:	8b 40 04             	mov    0x4(%eax),%eax
  80257c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802581:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802584:	8b 40 04             	mov    0x4(%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 0f                	je     80259a <alloc_block_FF+0x141>
  80258b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258e:	8b 40 04             	mov    0x4(%eax),%eax
  802591:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802594:	8b 12                	mov    (%edx),%edx
  802596:	89 10                	mov    %edx,(%eax)
  802598:	eb 0a                	jmp    8025a4 <alloc_block_FF+0x14b>
  80259a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259d:	8b 00                	mov    (%eax),%eax
  80259f:	a3 48 51 80 00       	mov    %eax,0x805148
  8025a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8025bc:	48                   	dec    %eax
  8025bd:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 50 08             	mov    0x8(%eax),%edx
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	01 c2                	add    %eax,%edx
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d9:	2b 45 08             	sub    0x8(%ebp),%eax
  8025dc:	89 c2                	mov    %eax,%edx
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8025e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e7:	eb 3b                	jmp    802624 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8025e9:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	74 07                	je     8025fe <alloc_block_FF+0x1a5>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	eb 05                	jmp    802603 <alloc_block_FF+0x1aa>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	a3 40 51 80 00       	mov    %eax,0x805140
  802608:	a1 40 51 80 00       	mov    0x805140,%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	0f 85 57 fe ff ff    	jne    80246c <alloc_block_FF+0x13>
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	0f 85 4d fe ff ff    	jne    80246c <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802624:	c9                   	leave  
  802625:	c3                   	ret    

00802626 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80262c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802633:	a1 38 51 80 00       	mov    0x805138,%eax
  802638:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263b:	e9 df 00 00 00       	jmp    80271f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 40 0c             	mov    0xc(%eax),%eax
  802646:	3b 45 08             	cmp    0x8(%ebp),%eax
  802649:	0f 82 c8 00 00 00    	jb     802717 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 40 0c             	mov    0xc(%eax),%eax
  802655:	3b 45 08             	cmp    0x8(%ebp),%eax
  802658:	0f 85 8a 00 00 00    	jne    8026e8 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80265e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802662:	75 17                	jne    80267b <alloc_block_BF+0x55>
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 80 41 80 00       	push   $0x804180
  80266c:	68 b7 00 00 00       	push   $0xb7
  802671:	68 d7 40 80 00       	push   $0x8040d7
  802676:	e8 ba dc ff ff       	call   800335 <_panic>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	74 10                	je     802694 <alloc_block_BF+0x6e>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268c:	8b 52 04             	mov    0x4(%edx),%edx
  80268f:	89 50 04             	mov    %edx,0x4(%eax)
  802692:	eb 0b                	jmp    80269f <alloc_block_BF+0x79>
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 40 04             	mov    0x4(%eax),%eax
  80269a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 0f                	je     8026b8 <alloc_block_BF+0x92>
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 40 04             	mov    0x4(%eax),%eax
  8026af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b2:	8b 12                	mov    (%edx),%edx
  8026b4:	89 10                	mov    %edx,(%eax)
  8026b6:	eb 0a                	jmp    8026c2 <alloc_block_BF+0x9c>
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 00                	mov    (%eax),%eax
  8026bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8026da:	48                   	dec    %eax
  8026db:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	e9 4d 01 00 00       	jmp    802835 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f1:	76 24                	jbe    802717 <alloc_block_BF+0xf1>
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026fc:	73 19                	jae    802717 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8026fe:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 0c             	mov    0xc(%eax),%eax
  80270b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 40 08             	mov    0x8(%eax),%eax
  802714:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802717:	a1 40 51 80 00       	mov    0x805140,%eax
  80271c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802723:	74 07                	je     80272c <alloc_block_BF+0x106>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	eb 05                	jmp    802731 <alloc_block_BF+0x10b>
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	a3 40 51 80 00       	mov    %eax,0x805140
  802736:	a1 40 51 80 00       	mov    0x805140,%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	0f 85 fd fe ff ff    	jne    802640 <alloc_block_BF+0x1a>
  802743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802747:	0f 85 f3 fe ff ff    	jne    802640 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80274d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802751:	0f 84 d9 00 00 00    	je     802830 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802757:	a1 48 51 80 00       	mov    0x805148,%eax
  80275c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80275f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802762:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802765:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276b:	8b 55 08             	mov    0x8(%ebp),%edx
  80276e:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802771:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802775:	75 17                	jne    80278e <alloc_block_BF+0x168>
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	68 80 41 80 00       	push   $0x804180
  80277f:	68 c7 00 00 00       	push   $0xc7
  802784:	68 d7 40 80 00       	push   $0x8040d7
  802789:	e8 a7 db ff ff       	call   800335 <_panic>
  80278e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	74 10                	je     8027a7 <alloc_block_BF+0x181>
  802797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80279a:	8b 00                	mov    (%eax),%eax
  80279c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80279f:	8b 52 04             	mov    0x4(%edx),%edx
  8027a2:	89 50 04             	mov    %edx,0x4(%eax)
  8027a5:	eb 0b                	jmp    8027b2 <alloc_block_BF+0x18c>
  8027a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027aa:	8b 40 04             	mov    0x4(%eax),%eax
  8027ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027b5:	8b 40 04             	mov    0x4(%eax),%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	74 0f                	je     8027cb <alloc_block_BF+0x1a5>
  8027bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027c5:	8b 12                	mov    (%edx),%edx
  8027c7:	89 10                	mov    %edx,(%eax)
  8027c9:	eb 0a                	jmp    8027d5 <alloc_block_BF+0x1af>
  8027cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8027d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8027ed:	48                   	dec    %eax
  8027ee:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8027f3:	83 ec 08             	sub    $0x8,%esp
  8027f6:	ff 75 ec             	pushl  -0x14(%ebp)
  8027f9:	68 38 51 80 00       	push   $0x805138
  8027fe:	e8 71 f9 ff ff       	call   802174 <find_block>
  802803:	83 c4 10             	add    $0x10,%esp
  802806:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802809:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80280c:	8b 50 08             	mov    0x8(%eax),%edx
  80280f:	8b 45 08             	mov    0x8(%ebp),%eax
  802812:	01 c2                	add    %eax,%edx
  802814:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802817:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80281a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	2b 45 08             	sub    0x8(%ebp),%eax
  802823:	89 c2                	mov    %eax,%edx
  802825:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802828:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80282b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282e:	eb 05                	jmp    802835 <alloc_block_BF+0x20f>
	}
	return NULL;
  802830:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802835:	c9                   	leave  
  802836:	c3                   	ret    

00802837 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802837:	55                   	push   %ebp
  802838:	89 e5                	mov    %esp,%ebp
  80283a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80283d:	a1 28 50 80 00       	mov    0x805028,%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	0f 85 de 01 00 00    	jne    802a28 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80284a:	a1 38 51 80 00       	mov    0x805138,%eax
  80284f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802852:	e9 9e 01 00 00       	jmp    8029f5 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802860:	0f 82 87 01 00 00    	jb     8029ed <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 40 0c             	mov    0xc(%eax),%eax
  80286c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286f:	0f 85 95 00 00 00    	jne    80290a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	75 17                	jne    802892 <alloc_block_NF+0x5b>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 80 41 80 00       	push   $0x804180
  802883:	68 e0 00 00 00       	push   $0xe0
  802888:	68 d7 40 80 00       	push   $0x8040d7
  80288d:	e8 a3 da ff ff       	call   800335 <_panic>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 10                	je     8028ab <alloc_block_NF+0x74>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a3:	8b 52 04             	mov    0x4(%edx),%edx
  8028a6:	89 50 04             	mov    %edx,0x4(%eax)
  8028a9:	eb 0b                	jmp    8028b6 <alloc_block_NF+0x7f>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 0f                	je     8028cf <alloc_block_NF+0x98>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c9:	8b 12                	mov    (%edx),%edx
  8028cb:	89 10                	mov    %edx,(%eax)
  8028cd:	eb 0a                	jmp    8028d9 <alloc_block_NF+0xa2>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ec:	a1 44 51 80 00       	mov    0x805144,%eax
  8028f1:	48                   	dec    %eax
  8028f2:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 40 08             	mov    0x8(%eax),%eax
  8028fd:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	e9 f8 04 00 00       	jmp    802e02 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	3b 45 08             	cmp    0x8(%ebp),%eax
  802913:	0f 86 d4 00 00 00    	jbe    8029ed <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802919:	a1 48 51 80 00       	mov    0x805148,%eax
  80291e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 50 08             	mov    0x8(%eax),%edx
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80292d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802930:	8b 55 08             	mov    0x8(%ebp),%edx
  802933:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802936:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80293a:	75 17                	jne    802953 <alloc_block_NF+0x11c>
  80293c:	83 ec 04             	sub    $0x4,%esp
  80293f:	68 80 41 80 00       	push   $0x804180
  802944:	68 e9 00 00 00       	push   $0xe9
  802949:	68 d7 40 80 00       	push   $0x8040d7
  80294e:	e8 e2 d9 ff ff       	call   800335 <_panic>
  802953:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	85 c0                	test   %eax,%eax
  80295a:	74 10                	je     80296c <alloc_block_NF+0x135>
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	8b 00                	mov    (%eax),%eax
  802961:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802964:	8b 52 04             	mov    0x4(%edx),%edx
  802967:	89 50 04             	mov    %edx,0x4(%eax)
  80296a:	eb 0b                	jmp    802977 <alloc_block_NF+0x140>
  80296c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297a:	8b 40 04             	mov    0x4(%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	74 0f                	je     802990 <alloc_block_NF+0x159>
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 40 04             	mov    0x4(%eax),%eax
  802987:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80298a:	8b 12                	mov    (%edx),%edx
  80298c:	89 10                	mov    %edx,(%eax)
  80298e:	eb 0a                	jmp    80299a <alloc_block_NF+0x163>
  802990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	a3 48 51 80 00       	mov    %eax,0x805148
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8029b2:	48                   	dec    %eax
  8029b3:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	8b 40 08             	mov    0x8(%eax),%eax
  8029be:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 50 08             	mov    0x8(%eax),%edx
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	01 c2                	add    %eax,%edx
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029da:	2b 45 08             	sub    0x8(%ebp),%eax
  8029dd:	89 c2                	mov    %eax,%edx
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8029e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e8:	e9 15 04 00 00       	jmp    802e02 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8029ed:	a1 40 51 80 00       	mov    0x805140,%eax
  8029f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f9:	74 07                	je     802a02 <alloc_block_NF+0x1cb>
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	eb 05                	jmp    802a07 <alloc_block_NF+0x1d0>
  802a02:	b8 00 00 00 00       	mov    $0x0,%eax
  802a07:	a3 40 51 80 00       	mov    %eax,0x805140
  802a0c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a11:	85 c0                	test   %eax,%eax
  802a13:	0f 85 3e fe ff ff    	jne    802857 <alloc_block_NF+0x20>
  802a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1d:	0f 85 34 fe ff ff    	jne    802857 <alloc_block_NF+0x20>
  802a23:	e9 d5 03 00 00       	jmp    802dfd <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a28:	a1 38 51 80 00       	mov    0x805138,%eax
  802a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a30:	e9 b1 01 00 00       	jmp    802be6 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 50 08             	mov    0x8(%eax),%edx
  802a3b:	a1 28 50 80 00       	mov    0x805028,%eax
  802a40:	39 c2                	cmp    %eax,%edx
  802a42:	0f 82 96 01 00 00    	jb     802bde <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a51:	0f 82 87 01 00 00    	jb     802bde <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a60:	0f 85 95 00 00 00    	jne    802afb <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6a:	75 17                	jne    802a83 <alloc_block_NF+0x24c>
  802a6c:	83 ec 04             	sub    $0x4,%esp
  802a6f:	68 80 41 80 00       	push   $0x804180
  802a74:	68 fc 00 00 00       	push   $0xfc
  802a79:	68 d7 40 80 00       	push   $0x8040d7
  802a7e:	e8 b2 d8 ff ff       	call   800335 <_panic>
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 00                	mov    (%eax),%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	74 10                	je     802a9c <alloc_block_NF+0x265>
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a94:	8b 52 04             	mov    0x4(%edx),%edx
  802a97:	89 50 04             	mov    %edx,0x4(%eax)
  802a9a:	eb 0b                	jmp    802aa7 <alloc_block_NF+0x270>
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 04             	mov    0x4(%eax),%eax
  802aa2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 40 04             	mov    0x4(%eax),%eax
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	74 0f                	je     802ac0 <alloc_block_NF+0x289>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 40 04             	mov    0x4(%eax),%eax
  802ab7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aba:	8b 12                	mov    (%edx),%edx
  802abc:	89 10                	mov    %edx,(%eax)
  802abe:	eb 0a                	jmp    802aca <alloc_block_NF+0x293>
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	a3 38 51 80 00       	mov    %eax,0x805138
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802add:	a1 44 51 80 00       	mov    0x805144,%eax
  802ae2:	48                   	dec    %eax
  802ae3:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 40 08             	mov    0x8(%eax),%eax
  802aee:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af6:	e9 07 03 00 00       	jmp    802e02 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 40 0c             	mov    0xc(%eax),%eax
  802b01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b04:	0f 86 d4 00 00 00    	jbe    802bde <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b0a:	a1 48 51 80 00       	mov    0x805148,%eax
  802b0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 50 08             	mov    0x8(%eax),%edx
  802b18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b21:	8b 55 08             	mov    0x8(%ebp),%edx
  802b24:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b27:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b2b:	75 17                	jne    802b44 <alloc_block_NF+0x30d>
  802b2d:	83 ec 04             	sub    $0x4,%esp
  802b30:	68 80 41 80 00       	push   $0x804180
  802b35:	68 04 01 00 00       	push   $0x104
  802b3a:	68 d7 40 80 00       	push   $0x8040d7
  802b3f:	e8 f1 d7 ff ff       	call   800335 <_panic>
  802b44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	85 c0                	test   %eax,%eax
  802b4b:	74 10                	je     802b5d <alloc_block_NF+0x326>
  802b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b50:	8b 00                	mov    (%eax),%eax
  802b52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b55:	8b 52 04             	mov    0x4(%edx),%edx
  802b58:	89 50 04             	mov    %edx,0x4(%eax)
  802b5b:	eb 0b                	jmp    802b68 <alloc_block_NF+0x331>
  802b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b60:	8b 40 04             	mov    0x4(%eax),%eax
  802b63:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6b:	8b 40 04             	mov    0x4(%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	74 0f                	je     802b81 <alloc_block_NF+0x34a>
  802b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b75:	8b 40 04             	mov    0x4(%eax),%eax
  802b78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b7b:	8b 12                	mov    (%edx),%edx
  802b7d:	89 10                	mov    %edx,(%eax)
  802b7f:	eb 0a                	jmp    802b8b <alloc_block_NF+0x354>
  802b81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b84:	8b 00                	mov    (%eax),%eax
  802b86:	a3 48 51 80 00       	mov    %eax,0x805148
  802b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9e:	a1 54 51 80 00       	mov    0x805154,%eax
  802ba3:	48                   	dec    %eax
  802ba4:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bac:	8b 40 08             	mov    0x8(%eax),%eax
  802baf:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 50 08             	mov    0x8(%eax),%edx
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	01 c2                	add    %eax,%edx
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bcb:	2b 45 08             	sub    0x8(%ebp),%eax
  802bce:	89 c2                	mov    %eax,%edx
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd9:	e9 24 02 00 00       	jmp    802e02 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bde:	a1 40 51 80 00       	mov    0x805140,%eax
  802be3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bea:	74 07                	je     802bf3 <alloc_block_NF+0x3bc>
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	eb 05                	jmp    802bf8 <alloc_block_NF+0x3c1>
  802bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bfd:	a1 40 51 80 00       	mov    0x805140,%eax
  802c02:	85 c0                	test   %eax,%eax
  802c04:	0f 85 2b fe ff ff    	jne    802a35 <alloc_block_NF+0x1fe>
  802c0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0e:	0f 85 21 fe ff ff    	jne    802a35 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c14:	a1 38 51 80 00       	mov    0x805138,%eax
  802c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1c:	e9 ae 01 00 00       	jmp    802dcf <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 50 08             	mov    0x8(%eax),%edx
  802c27:	a1 28 50 80 00       	mov    0x805028,%eax
  802c2c:	39 c2                	cmp    %eax,%edx
  802c2e:	0f 83 93 01 00 00    	jae    802dc7 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3d:	0f 82 84 01 00 00    	jb     802dc7 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 40 0c             	mov    0xc(%eax),%eax
  802c49:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4c:	0f 85 95 00 00 00    	jne    802ce7 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c56:	75 17                	jne    802c6f <alloc_block_NF+0x438>
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	68 80 41 80 00       	push   $0x804180
  802c60:	68 14 01 00 00       	push   $0x114
  802c65:	68 d7 40 80 00       	push   $0x8040d7
  802c6a:	e8 c6 d6 ff ff       	call   800335 <_panic>
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	85 c0                	test   %eax,%eax
  802c76:	74 10                	je     802c88 <alloc_block_NF+0x451>
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c80:	8b 52 04             	mov    0x4(%edx),%edx
  802c83:	89 50 04             	mov    %edx,0x4(%eax)
  802c86:	eb 0b                	jmp    802c93 <alloc_block_NF+0x45c>
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 04             	mov    0x4(%eax),%eax
  802c8e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	74 0f                	je     802cac <alloc_block_NF+0x475>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 40 04             	mov    0x4(%eax),%eax
  802ca3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca6:	8b 12                	mov    (%edx),%edx
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	eb 0a                	jmp    802cb6 <alloc_block_NF+0x47f>
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc9:	a1 44 51 80 00       	mov    0x805144,%eax
  802cce:	48                   	dec    %eax
  802ccf:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 40 08             	mov    0x8(%eax),%eax
  802cda:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	e9 1b 01 00 00       	jmp    802e02 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 40 0c             	mov    0xc(%eax),%eax
  802ced:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf0:	0f 86 d1 00 00 00    	jbe    802dc7 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802cf6:	a1 48 51 80 00       	mov    0x805148,%eax
  802cfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 50 08             	mov    0x8(%eax),%edx
  802d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d07:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d10:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d17:	75 17                	jne    802d30 <alloc_block_NF+0x4f9>
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	68 80 41 80 00       	push   $0x804180
  802d21:	68 1c 01 00 00       	push   $0x11c
  802d26:	68 d7 40 80 00       	push   $0x8040d7
  802d2b:	e8 05 d6 ff ff       	call   800335 <_panic>
  802d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 10                	je     802d49 <alloc_block_NF+0x512>
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d41:	8b 52 04             	mov    0x4(%edx),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	eb 0b                	jmp    802d54 <alloc_block_NF+0x51d>
  802d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4c:	8b 40 04             	mov    0x4(%eax),%eax
  802d4f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 0f                	je     802d6d <alloc_block_NF+0x536>
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d67:	8b 12                	mov    (%edx),%edx
  802d69:	89 10                	mov    %edx,(%eax)
  802d6b:	eb 0a                	jmp    802d77 <alloc_block_NF+0x540>
  802d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	a3 48 51 80 00       	mov    %eax,0x805148
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8a:	a1 54 51 80 00       	mov    0x805154,%eax
  802d8f:	48                   	dec    %eax
  802d90:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d98:	8b 40 08             	mov    0x8(%eax),%eax
  802d9b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 50 08             	mov    0x8(%eax),%edx
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	01 c2                	add    %eax,%edx
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 0c             	mov    0xc(%eax),%eax
  802db7:	2b 45 08             	sub    0x8(%ebp),%eax
  802dba:	89 c2                	mov    %eax,%edx
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc5:	eb 3b                	jmp    802e02 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dc7:	a1 40 51 80 00       	mov    0x805140,%eax
  802dcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dcf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd3:	74 07                	je     802ddc <alloc_block_NF+0x5a5>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	eb 05                	jmp    802de1 <alloc_block_NF+0x5aa>
  802ddc:	b8 00 00 00 00       	mov    $0x0,%eax
  802de1:	a3 40 51 80 00       	mov    %eax,0x805140
  802de6:	a1 40 51 80 00       	mov    0x805140,%eax
  802deb:	85 c0                	test   %eax,%eax
  802ded:	0f 85 2e fe ff ff    	jne    802c21 <alloc_block_NF+0x3ea>
  802df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df7:	0f 85 24 fe ff ff    	jne    802c21 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e02:	c9                   	leave  
  802e03:	c3                   	ret    

00802e04 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e04:	55                   	push   %ebp
  802e05:	89 e5                	mov    %esp,%ebp
  802e07:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e0a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e12:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e17:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e1a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 14                	je     802e37 <insert_sorted_with_merge_freeList+0x33>
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	8b 50 08             	mov    0x8(%eax),%edx
  802e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2c:	8b 40 08             	mov    0x8(%eax),%eax
  802e2f:	39 c2                	cmp    %eax,%edx
  802e31:	0f 87 9b 01 00 00    	ja     802fd2 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3b:	75 17                	jne    802e54 <insert_sorted_with_merge_freeList+0x50>
  802e3d:	83 ec 04             	sub    $0x4,%esp
  802e40:	68 b4 40 80 00       	push   $0x8040b4
  802e45:	68 38 01 00 00       	push   $0x138
  802e4a:	68 d7 40 80 00       	push   $0x8040d7
  802e4f:	e8 e1 d4 ff ff       	call   800335 <_panic>
  802e54:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	89 10                	mov    %edx,(%eax)
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	85 c0                	test   %eax,%eax
  802e66:	74 0d                	je     802e75 <insert_sorted_with_merge_freeList+0x71>
  802e68:	a1 38 51 80 00       	mov    0x805138,%eax
  802e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e70:	89 50 04             	mov    %edx,0x4(%eax)
  802e73:	eb 08                	jmp    802e7d <insert_sorted_with_merge_freeList+0x79>
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	a3 38 51 80 00       	mov    %eax,0x805138
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e94:	40                   	inc    %eax
  802e95:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e9e:	0f 84 a8 06 00 00    	je     80354c <insert_sorted_with_merge_freeList+0x748>
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 50 08             	mov    0x8(%eax),%edx
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb0:	01 c2                	add    %eax,%edx
  802eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb5:	8b 40 08             	mov    0x8(%eax),%eax
  802eb8:	39 c2                	cmp    %eax,%edx
  802eba:	0f 85 8c 06 00 00    	jne    80354c <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecc:	01 c2                	add    %eax,%edx
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ed4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed8:	75 17                	jne    802ef1 <insert_sorted_with_merge_freeList+0xed>
  802eda:	83 ec 04             	sub    $0x4,%esp
  802edd:	68 80 41 80 00       	push   $0x804180
  802ee2:	68 3c 01 00 00       	push   $0x13c
  802ee7:	68 d7 40 80 00       	push   $0x8040d7
  802eec:	e8 44 d4 ff ff       	call   800335 <_panic>
  802ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	74 10                	je     802f0a <insert_sorted_with_merge_freeList+0x106>
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f02:	8b 52 04             	mov    0x4(%edx),%edx
  802f05:	89 50 04             	mov    %edx,0x4(%eax)
  802f08:	eb 0b                	jmp    802f15 <insert_sorted_with_merge_freeList+0x111>
  802f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0d:	8b 40 04             	mov    0x4(%eax),%eax
  802f10:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	8b 40 04             	mov    0x4(%eax),%eax
  802f1b:	85 c0                	test   %eax,%eax
  802f1d:	74 0f                	je     802f2e <insert_sorted_with_merge_freeList+0x12a>
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	8b 40 04             	mov    0x4(%eax),%eax
  802f25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f28:	8b 12                	mov    (%edx),%edx
  802f2a:	89 10                	mov    %edx,(%eax)
  802f2c:	eb 0a                	jmp    802f38 <insert_sorted_with_merge_freeList+0x134>
  802f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f31:	8b 00                	mov    (%eax),%eax
  802f33:	a3 38 51 80 00       	mov    %eax,0x805138
  802f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4b:	a1 44 51 80 00       	mov    0x805144,%eax
  802f50:	48                   	dec    %eax
  802f51:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f59:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f6e:	75 17                	jne    802f87 <insert_sorted_with_merge_freeList+0x183>
  802f70:	83 ec 04             	sub    $0x4,%esp
  802f73:	68 b4 40 80 00       	push   $0x8040b4
  802f78:	68 3f 01 00 00       	push   $0x13f
  802f7d:	68 d7 40 80 00       	push   $0x8040d7
  802f82:	e8 ae d3 ff ff       	call   800335 <_panic>
  802f87:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	74 0d                	je     802fa8 <insert_sorted_with_merge_freeList+0x1a4>
  802f9b:	a1 48 51 80 00       	mov    0x805148,%eax
  802fa0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fa3:	89 50 04             	mov    %edx,0x4(%eax)
  802fa6:	eb 08                	jmp    802fb0 <insert_sorted_with_merge_freeList+0x1ac>
  802fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb3:	a3 48 51 80 00       	mov    %eax,0x805148
  802fb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc2:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc7:	40                   	inc    %eax
  802fc8:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802fcd:	e9 7a 05 00 00       	jmp    80354c <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	8b 50 08             	mov    0x8(%eax),%edx
  802fd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdb:	8b 40 08             	mov    0x8(%eax),%eax
  802fde:	39 c2                	cmp    %eax,%edx
  802fe0:	0f 82 14 01 00 00    	jb     8030fa <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802fe6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe9:	8b 50 08             	mov    0x8(%eax),%edx
  802fec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff2:	01 c2                	add    %eax,%edx
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	8b 40 08             	mov    0x8(%eax),%eax
  802ffa:	39 c2                	cmp    %eax,%edx
  802ffc:	0f 85 90 00 00 00    	jne    803092 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803005:	8b 50 0c             	mov    0xc(%eax),%edx
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	8b 40 0c             	mov    0xc(%eax),%eax
  80300e:	01 c2                	add    %eax,%edx
  803010:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803013:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80302a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302e:	75 17                	jne    803047 <insert_sorted_with_merge_freeList+0x243>
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 b4 40 80 00       	push   $0x8040b4
  803038:	68 49 01 00 00       	push   $0x149
  80303d:	68 d7 40 80 00       	push   $0x8040d7
  803042:	e8 ee d2 ff ff       	call   800335 <_panic>
  803047:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	89 10                	mov    %edx,(%eax)
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	8b 00                	mov    (%eax),%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	74 0d                	je     803068 <insert_sorted_with_merge_freeList+0x264>
  80305b:	a1 48 51 80 00       	mov    0x805148,%eax
  803060:	8b 55 08             	mov    0x8(%ebp),%edx
  803063:	89 50 04             	mov    %edx,0x4(%eax)
  803066:	eb 08                	jmp    803070 <insert_sorted_with_merge_freeList+0x26c>
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	a3 48 51 80 00       	mov    %eax,0x805148
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803082:	a1 54 51 80 00       	mov    0x805154,%eax
  803087:	40                   	inc    %eax
  803088:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80308d:	e9 bb 04 00 00       	jmp    80354d <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803096:	75 17                	jne    8030af <insert_sorted_with_merge_freeList+0x2ab>
  803098:	83 ec 04             	sub    $0x4,%esp
  80309b:	68 28 41 80 00       	push   $0x804128
  8030a0:	68 4c 01 00 00       	push   $0x14c
  8030a5:	68 d7 40 80 00       	push   $0x8040d7
  8030aa:	e8 86 d2 ff ff       	call   800335 <_panic>
  8030af:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	89 50 04             	mov    %edx,0x4(%eax)
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	8b 40 04             	mov    0x4(%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 0c                	je     8030d1 <insert_sorted_with_merge_freeList+0x2cd>
  8030c5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	eb 08                	jmp    8030d9 <insert_sorted_with_merge_freeList+0x2d5>
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ef:	40                   	inc    %eax
  8030f0:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030f5:	e9 53 04 00 00       	jmp    80354d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8030fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803102:	e9 15 04 00 00       	jmp    80351c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	8b 50 08             	mov    0x8(%eax),%edx
  803115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803118:	8b 40 08             	mov    0x8(%eax),%eax
  80311b:	39 c2                	cmp    %eax,%edx
  80311d:	0f 86 f1 03 00 00    	jbe    803514 <insert_sorted_with_merge_freeList+0x710>
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 50 08             	mov    0x8(%eax),%edx
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	8b 40 08             	mov    0x8(%eax),%eax
  80312f:	39 c2                	cmp    %eax,%edx
  803131:	0f 83 dd 03 00 00    	jae    803514 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313a:	8b 50 08             	mov    0x8(%eax),%edx
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 40 0c             	mov    0xc(%eax),%eax
  803143:	01 c2                	add    %eax,%edx
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	8b 40 08             	mov    0x8(%eax),%eax
  80314b:	39 c2                	cmp    %eax,%edx
  80314d:	0f 85 b9 01 00 00    	jne    80330c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	8b 50 08             	mov    0x8(%eax),%edx
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8b 40 0c             	mov    0xc(%eax),%eax
  80315f:	01 c2                	add    %eax,%edx
  803161:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803164:	8b 40 08             	mov    0x8(%eax),%eax
  803167:	39 c2                	cmp    %eax,%edx
  803169:	0f 85 0d 01 00 00    	jne    80327c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 50 0c             	mov    0xc(%eax),%edx
  803175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803178:	8b 40 0c             	mov    0xc(%eax),%eax
  80317b:	01 c2                	add    %eax,%edx
  80317d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803180:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803183:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803187:	75 17                	jne    8031a0 <insert_sorted_with_merge_freeList+0x39c>
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	68 80 41 80 00       	push   $0x804180
  803191:	68 5c 01 00 00       	push   $0x15c
  803196:	68 d7 40 80 00       	push   $0x8040d7
  80319b:	e8 95 d1 ff ff       	call   800335 <_panic>
  8031a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 10                	je     8031b9 <insert_sorted_with_merge_freeList+0x3b5>
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b1:	8b 52 04             	mov    0x4(%edx),%edx
  8031b4:	89 50 04             	mov    %edx,0x4(%eax)
  8031b7:	eb 0b                	jmp    8031c4 <insert_sorted_with_merge_freeList+0x3c0>
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	8b 40 04             	mov    0x4(%eax),%eax
  8031bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	74 0f                	je     8031dd <insert_sorted_with_merge_freeList+0x3d9>
  8031ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d1:	8b 40 04             	mov    0x4(%eax),%eax
  8031d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d7:	8b 12                	mov    (%edx),%edx
  8031d9:	89 10                	mov    %edx,(%eax)
  8031db:	eb 0a                	jmp    8031e7 <insert_sorted_with_merge_freeList+0x3e3>
  8031dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ff:	48                   	dec    %eax
  803200:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803205:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803208:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80320f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803212:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803219:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321d:	75 17                	jne    803236 <insert_sorted_with_merge_freeList+0x432>
  80321f:	83 ec 04             	sub    $0x4,%esp
  803222:	68 b4 40 80 00       	push   $0x8040b4
  803227:	68 5f 01 00 00       	push   $0x15f
  80322c:	68 d7 40 80 00       	push   $0x8040d7
  803231:	e8 ff d0 ff ff       	call   800335 <_panic>
  803236:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	89 10                	mov    %edx,(%eax)
  803241:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	74 0d                	je     803257 <insert_sorted_with_merge_freeList+0x453>
  80324a:	a1 48 51 80 00       	mov    0x805148,%eax
  80324f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803252:	89 50 04             	mov    %edx,0x4(%eax)
  803255:	eb 08                	jmp    80325f <insert_sorted_with_merge_freeList+0x45b>
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803262:	a3 48 51 80 00       	mov    %eax,0x805148
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803271:	a1 54 51 80 00       	mov    0x805154,%eax
  803276:	40                   	inc    %eax
  803277:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80327c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327f:	8b 50 0c             	mov    0xc(%eax),%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	8b 40 0c             	mov    0xc(%eax),%eax
  803288:	01 c2                	add    %eax,%edx
  80328a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a8:	75 17                	jne    8032c1 <insert_sorted_with_merge_freeList+0x4bd>
  8032aa:	83 ec 04             	sub    $0x4,%esp
  8032ad:	68 b4 40 80 00       	push   $0x8040b4
  8032b2:	68 64 01 00 00       	push   $0x164
  8032b7:	68 d7 40 80 00       	push   $0x8040d7
  8032bc:	e8 74 d0 ff ff       	call   800335 <_panic>
  8032c1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	89 10                	mov    %edx,(%eax)
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	8b 00                	mov    (%eax),%eax
  8032d1:	85 c0                	test   %eax,%eax
  8032d3:	74 0d                	je     8032e2 <insert_sorted_with_merge_freeList+0x4de>
  8032d5:	a1 48 51 80 00       	mov    0x805148,%eax
  8032da:	8b 55 08             	mov    0x8(%ebp),%edx
  8032dd:	89 50 04             	mov    %edx,0x4(%eax)
  8032e0:	eb 08                	jmp    8032ea <insert_sorted_with_merge_freeList+0x4e6>
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	a3 48 51 80 00       	mov    %eax,0x805148
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032fc:	a1 54 51 80 00       	mov    0x805154,%eax
  803301:	40                   	inc    %eax
  803302:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803307:	e9 41 02 00 00       	jmp    80354d <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	8b 50 08             	mov    0x8(%eax),%edx
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	8b 40 0c             	mov    0xc(%eax),%eax
  803318:	01 c2                	add    %eax,%edx
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	8b 40 08             	mov    0x8(%eax),%eax
  803320:	39 c2                	cmp    %eax,%edx
  803322:	0f 85 7c 01 00 00    	jne    8034a4 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803328:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80332c:	74 06                	je     803334 <insert_sorted_with_merge_freeList+0x530>
  80332e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803332:	75 17                	jne    80334b <insert_sorted_with_merge_freeList+0x547>
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	68 f0 40 80 00       	push   $0x8040f0
  80333c:	68 69 01 00 00       	push   $0x169
  803341:	68 d7 40 80 00       	push   $0x8040d7
  803346:	e8 ea cf ff ff       	call   800335 <_panic>
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	8b 50 04             	mov    0x4(%eax),%edx
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	89 50 04             	mov    %edx,0x4(%eax)
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80335d:	89 10                	mov    %edx,(%eax)
  80335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803362:	8b 40 04             	mov    0x4(%eax),%eax
  803365:	85 c0                	test   %eax,%eax
  803367:	74 0d                	je     803376 <insert_sorted_with_merge_freeList+0x572>
  803369:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336c:	8b 40 04             	mov    0x4(%eax),%eax
  80336f:	8b 55 08             	mov    0x8(%ebp),%edx
  803372:	89 10                	mov    %edx,(%eax)
  803374:	eb 08                	jmp    80337e <insert_sorted_with_merge_freeList+0x57a>
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	a3 38 51 80 00       	mov    %eax,0x805138
  80337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803381:	8b 55 08             	mov    0x8(%ebp),%edx
  803384:	89 50 04             	mov    %edx,0x4(%eax)
  803387:	a1 44 51 80 00       	mov    0x805144,%eax
  80338c:	40                   	inc    %eax
  80338d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803392:	8b 45 08             	mov    0x8(%ebp),%eax
  803395:	8b 50 0c             	mov    0xc(%eax),%edx
  803398:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339b:	8b 40 0c             	mov    0xc(%eax),%eax
  80339e:	01 c2                	add    %eax,%edx
  8033a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a3:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033aa:	75 17                	jne    8033c3 <insert_sorted_with_merge_freeList+0x5bf>
  8033ac:	83 ec 04             	sub    $0x4,%esp
  8033af:	68 80 41 80 00       	push   $0x804180
  8033b4:	68 6b 01 00 00       	push   $0x16b
  8033b9:	68 d7 40 80 00       	push   $0x8040d7
  8033be:	e8 72 cf ff ff       	call   800335 <_panic>
  8033c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	74 10                	je     8033dc <insert_sorted_with_merge_freeList+0x5d8>
  8033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cf:	8b 00                	mov    (%eax),%eax
  8033d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033d4:	8b 52 04             	mov    0x4(%edx),%edx
  8033d7:	89 50 04             	mov    %edx,0x4(%eax)
  8033da:	eb 0b                	jmp    8033e7 <insert_sorted_with_merge_freeList+0x5e3>
  8033dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033df:	8b 40 04             	mov    0x4(%eax),%eax
  8033e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ea:	8b 40 04             	mov    0x4(%eax),%eax
  8033ed:	85 c0                	test   %eax,%eax
  8033ef:	74 0f                	je     803400 <insert_sorted_with_merge_freeList+0x5fc>
  8033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f4:	8b 40 04             	mov    0x4(%eax),%eax
  8033f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033fa:	8b 12                	mov    (%edx),%edx
  8033fc:	89 10                	mov    %edx,(%eax)
  8033fe:	eb 0a                	jmp    80340a <insert_sorted_with_merge_freeList+0x606>
  803400:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	a3 38 51 80 00       	mov    %eax,0x805138
  80340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803413:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803416:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341d:	a1 44 51 80 00       	mov    0x805144,%eax
  803422:	48                   	dec    %eax
  803423:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80342b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803432:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803435:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80343c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803440:	75 17                	jne    803459 <insert_sorted_with_merge_freeList+0x655>
  803442:	83 ec 04             	sub    $0x4,%esp
  803445:	68 b4 40 80 00       	push   $0x8040b4
  80344a:	68 6e 01 00 00       	push   $0x16e
  80344f:	68 d7 40 80 00       	push   $0x8040d7
  803454:	e8 dc ce ff ff       	call   800335 <_panic>
  803459:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80345f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803462:	89 10                	mov    %edx,(%eax)
  803464:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803467:	8b 00                	mov    (%eax),%eax
  803469:	85 c0                	test   %eax,%eax
  80346b:	74 0d                	je     80347a <insert_sorted_with_merge_freeList+0x676>
  80346d:	a1 48 51 80 00       	mov    0x805148,%eax
  803472:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803475:	89 50 04             	mov    %edx,0x4(%eax)
  803478:	eb 08                	jmp    803482 <insert_sorted_with_merge_freeList+0x67e>
  80347a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803482:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803485:	a3 48 51 80 00       	mov    %eax,0x805148
  80348a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803494:	a1 54 51 80 00       	mov    0x805154,%eax
  803499:	40                   	inc    %eax
  80349a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80349f:	e9 a9 00 00 00       	jmp    80354d <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a8:	74 06                	je     8034b0 <insert_sorted_with_merge_freeList+0x6ac>
  8034aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ae:	75 17                	jne    8034c7 <insert_sorted_with_merge_freeList+0x6c3>
  8034b0:	83 ec 04             	sub    $0x4,%esp
  8034b3:	68 4c 41 80 00       	push   $0x80414c
  8034b8:	68 73 01 00 00       	push   $0x173
  8034bd:	68 d7 40 80 00       	push   $0x8040d7
  8034c2:	e8 6e ce ff ff       	call   800335 <_panic>
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 10                	mov    (%eax),%edx
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	89 10                	mov    %edx,(%eax)
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	8b 00                	mov    (%eax),%eax
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	74 0b                	je     8034e5 <insert_sorted_with_merge_freeList+0x6e1>
  8034da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e2:	89 50 04             	mov    %edx,0x4(%eax)
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034eb:	89 10                	mov    %edx,(%eax)
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f3:	89 50 04             	mov    %edx,0x4(%eax)
  8034f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f9:	8b 00                	mov    (%eax),%eax
  8034fb:	85 c0                	test   %eax,%eax
  8034fd:	75 08                	jne    803507 <insert_sorted_with_merge_freeList+0x703>
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803507:	a1 44 51 80 00       	mov    0x805144,%eax
  80350c:	40                   	inc    %eax
  80350d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803512:	eb 39                	jmp    80354d <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803514:	a1 40 51 80 00       	mov    0x805140,%eax
  803519:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80351c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803520:	74 07                	je     803529 <insert_sorted_with_merge_freeList+0x725>
  803522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803525:	8b 00                	mov    (%eax),%eax
  803527:	eb 05                	jmp    80352e <insert_sorted_with_merge_freeList+0x72a>
  803529:	b8 00 00 00 00       	mov    $0x0,%eax
  80352e:	a3 40 51 80 00       	mov    %eax,0x805140
  803533:	a1 40 51 80 00       	mov    0x805140,%eax
  803538:	85 c0                	test   %eax,%eax
  80353a:	0f 85 c7 fb ff ff    	jne    803107 <insert_sorted_with_merge_freeList+0x303>
  803540:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803544:	0f 85 bd fb ff ff    	jne    803107 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80354a:	eb 01                	jmp    80354d <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80354c:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80354d:	90                   	nop
  80354e:	c9                   	leave  
  80354f:	c3                   	ret    

00803550 <__udivdi3>:
  803550:	55                   	push   %ebp
  803551:	57                   	push   %edi
  803552:	56                   	push   %esi
  803553:	53                   	push   %ebx
  803554:	83 ec 1c             	sub    $0x1c,%esp
  803557:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80355b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80355f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803563:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803567:	89 ca                	mov    %ecx,%edx
  803569:	89 f8                	mov    %edi,%eax
  80356b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80356f:	85 f6                	test   %esi,%esi
  803571:	75 2d                	jne    8035a0 <__udivdi3+0x50>
  803573:	39 cf                	cmp    %ecx,%edi
  803575:	77 65                	ja     8035dc <__udivdi3+0x8c>
  803577:	89 fd                	mov    %edi,%ebp
  803579:	85 ff                	test   %edi,%edi
  80357b:	75 0b                	jne    803588 <__udivdi3+0x38>
  80357d:	b8 01 00 00 00       	mov    $0x1,%eax
  803582:	31 d2                	xor    %edx,%edx
  803584:	f7 f7                	div    %edi
  803586:	89 c5                	mov    %eax,%ebp
  803588:	31 d2                	xor    %edx,%edx
  80358a:	89 c8                	mov    %ecx,%eax
  80358c:	f7 f5                	div    %ebp
  80358e:	89 c1                	mov    %eax,%ecx
  803590:	89 d8                	mov    %ebx,%eax
  803592:	f7 f5                	div    %ebp
  803594:	89 cf                	mov    %ecx,%edi
  803596:	89 fa                	mov    %edi,%edx
  803598:	83 c4 1c             	add    $0x1c,%esp
  80359b:	5b                   	pop    %ebx
  80359c:	5e                   	pop    %esi
  80359d:	5f                   	pop    %edi
  80359e:	5d                   	pop    %ebp
  80359f:	c3                   	ret    
  8035a0:	39 ce                	cmp    %ecx,%esi
  8035a2:	77 28                	ja     8035cc <__udivdi3+0x7c>
  8035a4:	0f bd fe             	bsr    %esi,%edi
  8035a7:	83 f7 1f             	xor    $0x1f,%edi
  8035aa:	75 40                	jne    8035ec <__udivdi3+0x9c>
  8035ac:	39 ce                	cmp    %ecx,%esi
  8035ae:	72 0a                	jb     8035ba <__udivdi3+0x6a>
  8035b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035b4:	0f 87 9e 00 00 00    	ja     803658 <__udivdi3+0x108>
  8035ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8035bf:	89 fa                	mov    %edi,%edx
  8035c1:	83 c4 1c             	add    $0x1c,%esp
  8035c4:	5b                   	pop    %ebx
  8035c5:	5e                   	pop    %esi
  8035c6:	5f                   	pop    %edi
  8035c7:	5d                   	pop    %ebp
  8035c8:	c3                   	ret    
  8035c9:	8d 76 00             	lea    0x0(%esi),%esi
  8035cc:	31 ff                	xor    %edi,%edi
  8035ce:	31 c0                	xor    %eax,%eax
  8035d0:	89 fa                	mov    %edi,%edx
  8035d2:	83 c4 1c             	add    $0x1c,%esp
  8035d5:	5b                   	pop    %ebx
  8035d6:	5e                   	pop    %esi
  8035d7:	5f                   	pop    %edi
  8035d8:	5d                   	pop    %ebp
  8035d9:	c3                   	ret    
  8035da:	66 90                	xchg   %ax,%ax
  8035dc:	89 d8                	mov    %ebx,%eax
  8035de:	f7 f7                	div    %edi
  8035e0:	31 ff                	xor    %edi,%edi
  8035e2:	89 fa                	mov    %edi,%edx
  8035e4:	83 c4 1c             	add    $0x1c,%esp
  8035e7:	5b                   	pop    %ebx
  8035e8:	5e                   	pop    %esi
  8035e9:	5f                   	pop    %edi
  8035ea:	5d                   	pop    %ebp
  8035eb:	c3                   	ret    
  8035ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035f1:	89 eb                	mov    %ebp,%ebx
  8035f3:	29 fb                	sub    %edi,%ebx
  8035f5:	89 f9                	mov    %edi,%ecx
  8035f7:	d3 e6                	shl    %cl,%esi
  8035f9:	89 c5                	mov    %eax,%ebp
  8035fb:	88 d9                	mov    %bl,%cl
  8035fd:	d3 ed                	shr    %cl,%ebp
  8035ff:	89 e9                	mov    %ebp,%ecx
  803601:	09 f1                	or     %esi,%ecx
  803603:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803607:	89 f9                	mov    %edi,%ecx
  803609:	d3 e0                	shl    %cl,%eax
  80360b:	89 c5                	mov    %eax,%ebp
  80360d:	89 d6                	mov    %edx,%esi
  80360f:	88 d9                	mov    %bl,%cl
  803611:	d3 ee                	shr    %cl,%esi
  803613:	89 f9                	mov    %edi,%ecx
  803615:	d3 e2                	shl    %cl,%edx
  803617:	8b 44 24 08          	mov    0x8(%esp),%eax
  80361b:	88 d9                	mov    %bl,%cl
  80361d:	d3 e8                	shr    %cl,%eax
  80361f:	09 c2                	or     %eax,%edx
  803621:	89 d0                	mov    %edx,%eax
  803623:	89 f2                	mov    %esi,%edx
  803625:	f7 74 24 0c          	divl   0xc(%esp)
  803629:	89 d6                	mov    %edx,%esi
  80362b:	89 c3                	mov    %eax,%ebx
  80362d:	f7 e5                	mul    %ebp
  80362f:	39 d6                	cmp    %edx,%esi
  803631:	72 19                	jb     80364c <__udivdi3+0xfc>
  803633:	74 0b                	je     803640 <__udivdi3+0xf0>
  803635:	89 d8                	mov    %ebx,%eax
  803637:	31 ff                	xor    %edi,%edi
  803639:	e9 58 ff ff ff       	jmp    803596 <__udivdi3+0x46>
  80363e:	66 90                	xchg   %ax,%ax
  803640:	8b 54 24 08          	mov    0x8(%esp),%edx
  803644:	89 f9                	mov    %edi,%ecx
  803646:	d3 e2                	shl    %cl,%edx
  803648:	39 c2                	cmp    %eax,%edx
  80364a:	73 e9                	jae    803635 <__udivdi3+0xe5>
  80364c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80364f:	31 ff                	xor    %edi,%edi
  803651:	e9 40 ff ff ff       	jmp    803596 <__udivdi3+0x46>
  803656:	66 90                	xchg   %ax,%ax
  803658:	31 c0                	xor    %eax,%eax
  80365a:	e9 37 ff ff ff       	jmp    803596 <__udivdi3+0x46>
  80365f:	90                   	nop

00803660 <__umoddi3>:
  803660:	55                   	push   %ebp
  803661:	57                   	push   %edi
  803662:	56                   	push   %esi
  803663:	53                   	push   %ebx
  803664:	83 ec 1c             	sub    $0x1c,%esp
  803667:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80366b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80366f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803673:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803677:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80367b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80367f:	89 f3                	mov    %esi,%ebx
  803681:	89 fa                	mov    %edi,%edx
  803683:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803687:	89 34 24             	mov    %esi,(%esp)
  80368a:	85 c0                	test   %eax,%eax
  80368c:	75 1a                	jne    8036a8 <__umoddi3+0x48>
  80368e:	39 f7                	cmp    %esi,%edi
  803690:	0f 86 a2 00 00 00    	jbe    803738 <__umoddi3+0xd8>
  803696:	89 c8                	mov    %ecx,%eax
  803698:	89 f2                	mov    %esi,%edx
  80369a:	f7 f7                	div    %edi
  80369c:	89 d0                	mov    %edx,%eax
  80369e:	31 d2                	xor    %edx,%edx
  8036a0:	83 c4 1c             	add    $0x1c,%esp
  8036a3:	5b                   	pop    %ebx
  8036a4:	5e                   	pop    %esi
  8036a5:	5f                   	pop    %edi
  8036a6:	5d                   	pop    %ebp
  8036a7:	c3                   	ret    
  8036a8:	39 f0                	cmp    %esi,%eax
  8036aa:	0f 87 ac 00 00 00    	ja     80375c <__umoddi3+0xfc>
  8036b0:	0f bd e8             	bsr    %eax,%ebp
  8036b3:	83 f5 1f             	xor    $0x1f,%ebp
  8036b6:	0f 84 ac 00 00 00    	je     803768 <__umoddi3+0x108>
  8036bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8036c1:	29 ef                	sub    %ebp,%edi
  8036c3:	89 fe                	mov    %edi,%esi
  8036c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036c9:	89 e9                	mov    %ebp,%ecx
  8036cb:	d3 e0                	shl    %cl,%eax
  8036cd:	89 d7                	mov    %edx,%edi
  8036cf:	89 f1                	mov    %esi,%ecx
  8036d1:	d3 ef                	shr    %cl,%edi
  8036d3:	09 c7                	or     %eax,%edi
  8036d5:	89 e9                	mov    %ebp,%ecx
  8036d7:	d3 e2                	shl    %cl,%edx
  8036d9:	89 14 24             	mov    %edx,(%esp)
  8036dc:	89 d8                	mov    %ebx,%eax
  8036de:	d3 e0                	shl    %cl,%eax
  8036e0:	89 c2                	mov    %eax,%edx
  8036e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036e6:	d3 e0                	shl    %cl,%eax
  8036e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f0:	89 f1                	mov    %esi,%ecx
  8036f2:	d3 e8                	shr    %cl,%eax
  8036f4:	09 d0                	or     %edx,%eax
  8036f6:	d3 eb                	shr    %cl,%ebx
  8036f8:	89 da                	mov    %ebx,%edx
  8036fa:	f7 f7                	div    %edi
  8036fc:	89 d3                	mov    %edx,%ebx
  8036fe:	f7 24 24             	mull   (%esp)
  803701:	89 c6                	mov    %eax,%esi
  803703:	89 d1                	mov    %edx,%ecx
  803705:	39 d3                	cmp    %edx,%ebx
  803707:	0f 82 87 00 00 00    	jb     803794 <__umoddi3+0x134>
  80370d:	0f 84 91 00 00 00    	je     8037a4 <__umoddi3+0x144>
  803713:	8b 54 24 04          	mov    0x4(%esp),%edx
  803717:	29 f2                	sub    %esi,%edx
  803719:	19 cb                	sbb    %ecx,%ebx
  80371b:	89 d8                	mov    %ebx,%eax
  80371d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803721:	d3 e0                	shl    %cl,%eax
  803723:	89 e9                	mov    %ebp,%ecx
  803725:	d3 ea                	shr    %cl,%edx
  803727:	09 d0                	or     %edx,%eax
  803729:	89 e9                	mov    %ebp,%ecx
  80372b:	d3 eb                	shr    %cl,%ebx
  80372d:	89 da                	mov    %ebx,%edx
  80372f:	83 c4 1c             	add    $0x1c,%esp
  803732:	5b                   	pop    %ebx
  803733:	5e                   	pop    %esi
  803734:	5f                   	pop    %edi
  803735:	5d                   	pop    %ebp
  803736:	c3                   	ret    
  803737:	90                   	nop
  803738:	89 fd                	mov    %edi,%ebp
  80373a:	85 ff                	test   %edi,%edi
  80373c:	75 0b                	jne    803749 <__umoddi3+0xe9>
  80373e:	b8 01 00 00 00       	mov    $0x1,%eax
  803743:	31 d2                	xor    %edx,%edx
  803745:	f7 f7                	div    %edi
  803747:	89 c5                	mov    %eax,%ebp
  803749:	89 f0                	mov    %esi,%eax
  80374b:	31 d2                	xor    %edx,%edx
  80374d:	f7 f5                	div    %ebp
  80374f:	89 c8                	mov    %ecx,%eax
  803751:	f7 f5                	div    %ebp
  803753:	89 d0                	mov    %edx,%eax
  803755:	e9 44 ff ff ff       	jmp    80369e <__umoddi3+0x3e>
  80375a:	66 90                	xchg   %ax,%ax
  80375c:	89 c8                	mov    %ecx,%eax
  80375e:	89 f2                	mov    %esi,%edx
  803760:	83 c4 1c             	add    $0x1c,%esp
  803763:	5b                   	pop    %ebx
  803764:	5e                   	pop    %esi
  803765:	5f                   	pop    %edi
  803766:	5d                   	pop    %ebp
  803767:	c3                   	ret    
  803768:	3b 04 24             	cmp    (%esp),%eax
  80376b:	72 06                	jb     803773 <__umoddi3+0x113>
  80376d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803771:	77 0f                	ja     803782 <__umoddi3+0x122>
  803773:	89 f2                	mov    %esi,%edx
  803775:	29 f9                	sub    %edi,%ecx
  803777:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80377b:	89 14 24             	mov    %edx,(%esp)
  80377e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803782:	8b 44 24 04          	mov    0x4(%esp),%eax
  803786:	8b 14 24             	mov    (%esp),%edx
  803789:	83 c4 1c             	add    $0x1c,%esp
  80378c:	5b                   	pop    %ebx
  80378d:	5e                   	pop    %esi
  80378e:	5f                   	pop    %edi
  80378f:	5d                   	pop    %ebp
  803790:	c3                   	ret    
  803791:	8d 76 00             	lea    0x0(%esi),%esi
  803794:	2b 04 24             	sub    (%esp),%eax
  803797:	19 fa                	sbb    %edi,%edx
  803799:	89 d1                	mov    %edx,%ecx
  80379b:	89 c6                	mov    %eax,%esi
  80379d:	e9 71 ff ff ff       	jmp    803713 <__umoddi3+0xb3>
  8037a2:	66 90                	xchg   %ax,%ax
  8037a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037a8:	72 ea                	jb     803794 <__umoddi3+0x134>
  8037aa:	89 d9                	mov    %ebx,%ecx
  8037ac:	e9 62 ff ff ff       	jmp    803713 <__umoddi3+0xb3>
