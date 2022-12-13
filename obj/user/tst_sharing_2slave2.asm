
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
  80008d:	68 00 37 80 00       	push   $0x803700
  800092:	6a 13                	push   $0x13
  800094:	68 1c 37 80 00       	push   $0x80371c
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
  8000ab:	e8 21 1b 00 00       	call   801bd1 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 0d 19 00 00       	call   8019c5 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 1b 18 00 00       	call   8018d8 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 37 37 80 00       	push   $0x803737
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 e4 15 00 00       	call   8016b4 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 3c 37 80 00       	push   $0x80373c
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 1c 37 80 00       	push   $0x80371c
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 dd 17 00 00       	call   8018d8 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 9c 37 80 00       	push   $0x80379c
  80010c:	6a 22                	push   $0x22
  80010e:	68 1c 37 80 00       	push   $0x80371c
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 c2 18 00 00       	call   8019df <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 a3 18 00 00       	call   8019c5 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 b1 17 00 00       	call   8018d8 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 2d 38 80 00       	push   $0x80382d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 7a 15 00 00       	call   8016b4 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 3c 37 80 00       	push   $0x80373c
  800151:	6a 28                	push   $0x28
  800153:	68 1c 37 80 00       	push   $0x80371c
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 76 17 00 00       	call   8018d8 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 9c 37 80 00       	push   $0x80379c
  800173:	6a 29                	push   $0x29
  800175:	68 1c 37 80 00       	push   $0x80371c
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 5b 18 00 00       	call   8019df <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 30 38 80 00       	push   $0x803830
  800196:	6a 2c                	push   $0x2c
  800198:	68 1c 37 80 00       	push   $0x80371c
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
  8001b8:	68 30 38 80 00       	push   $0x803830
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 1c 37 80 00       	push   $0x80371c
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 68 38 80 00       	push   $0x803868
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 98 38 80 00       	push   $0x803898
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 1c 37 80 00       	push   $0x80371c
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
  8001ff:	e8 b4 19 00 00       	call   801bb8 <sys_getenvindex>
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
  80026a:	e8 56 17 00 00       	call   8019c5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 f4 38 80 00       	push   $0x8038f4
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
  80029a:	68 1c 39 80 00       	push   $0x80391c
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
  8002cb:	68 44 39 80 00       	push   $0x803944
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 9c 39 80 00       	push   $0x80399c
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 f4 38 80 00       	push   $0x8038f4
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 d6 16 00 00       	call   8019df <sys_enable_interrupt>

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
  80031c:	e8 63 18 00 00       	call   801b84 <sys_destroy_env>
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
  80032d:	e8 b8 18 00 00       	call   801bea <sys_exit_env>
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
  800356:	68 b0 39 80 00       	push   $0x8039b0
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 50 80 00       	mov    0x805000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 b5 39 80 00       	push   $0x8039b5
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
  800393:	68 d1 39 80 00       	push   $0x8039d1
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
  8003bf:	68 d4 39 80 00       	push   $0x8039d4
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 20 3a 80 00       	push   $0x803a20
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
  800491:	68 2c 3a 80 00       	push   $0x803a2c
  800496:	6a 3a                	push   $0x3a
  800498:	68 20 3a 80 00       	push   $0x803a20
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
  800501:	68 80 3a 80 00       	push   $0x803a80
  800506:	6a 44                	push   $0x44
  800508:	68 20 3a 80 00       	push   $0x803a20
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
  80055b:	e8 b7 12 00 00       	call   801817 <sys_cputs>
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
  8005d2:	e8 40 12 00 00       	call   801817 <sys_cputs>
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
  80061c:	e8 a4 13 00 00       	call   8019c5 <sys_disable_interrupt>
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
  80063c:	e8 9e 13 00 00       	call   8019df <sys_enable_interrupt>
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
  800686:	e8 11 2e 00 00       	call   80349c <__udivdi3>
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
  8006d6:	e8 d1 2e 00 00       	call   8035ac <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 f4 3c 80 00       	add    $0x803cf4,%eax
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
  800831:	8b 04 85 18 3d 80 00 	mov    0x803d18(,%eax,4),%eax
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
  800912:	8b 34 9d 60 3b 80 00 	mov    0x803b60(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 05 3d 80 00       	push   $0x803d05
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
  800937:	68 0e 3d 80 00       	push   $0x803d0e
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
  800964:	be 11 3d 80 00       	mov    $0x803d11,%esi
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
  80138a:	68 70 3e 80 00       	push   $0x803e70
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
  80145a:	e8 fc 04 00 00       	call   80195b <sys_allocate_chunk>
  80145f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801462:	a1 20 51 80 00       	mov    0x805120,%eax
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	50                   	push   %eax
  80146b:	e8 71 0b 00 00       	call   801fe1 <initialize_MemBlocksList>
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
  801498:	68 95 3e 80 00       	push   $0x803e95
  80149d:	6a 33                	push   $0x33
  80149f:	68 b3 3e 80 00       	push   $0x803eb3
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
  801517:	68 c0 3e 80 00       	push   $0x803ec0
  80151c:	6a 34                	push   $0x34
  80151e:	68 b3 3e 80 00       	push   $0x803eb3
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
  8015af:	e8 75 07 00 00       	call   801d29 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	74 11                	je     8015c9 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015b8:	83 ec 0c             	sub    $0xc,%esp
  8015bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8015be:	e8 e0 0d 00 00       	call   8023a3 <alloc_block_FF>
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
  8015d5:	e8 3c 0b 00 00       	call   802116 <insert_sorted_allocList>
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
  8015ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 e4 3e 80 00       	push   $0x803ee4
  8015fa:	6a 6f                	push   $0x6f
  8015fc:	68 b3 3e 80 00       	push   $0x803eb3
  801601:	e8 2f ed ff ff       	call   800335 <_panic>

00801606 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 38             	sub    $0x38,%esp
  80160c:	8b 45 10             	mov    0x10(%ebp),%eax
  80160f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801612:	e8 5c fd ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  801617:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161b:	75 0a                	jne    801627 <smalloc+0x21>
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
  801622:	e9 8b 00 00 00       	jmp    8016b2 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801627:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80162e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801634:	01 d0                	add    %edx,%eax
  801636:	48                   	dec    %eax
  801637:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80163a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163d:	ba 00 00 00 00       	mov    $0x0,%edx
  801642:	f7 75 f0             	divl   -0x10(%ebp)
  801645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801648:	29 d0                	sub    %edx,%eax
  80164a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80164d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801654:	e8 d0 06 00 00       	call   801d29 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801659:	85 c0                	test   %eax,%eax
  80165b:	74 11                	je     80166e <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80165d:	83 ec 0c             	sub    $0xc,%esp
  801660:	ff 75 e8             	pushl  -0x18(%ebp)
  801663:	e8 3b 0d 00 00       	call   8023a3 <alloc_block_FF>
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80166e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801672:	74 39                	je     8016ad <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801677:	8b 40 08             	mov    0x8(%eax),%eax
  80167a:	89 c2                	mov    %eax,%edx
  80167c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801680:	52                   	push   %edx
  801681:	50                   	push   %eax
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	ff 75 08             	pushl  0x8(%ebp)
  801688:	e8 21 04 00 00       	call   801aae <sys_createSharedObject>
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801693:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801697:	74 14                	je     8016ad <smalloc+0xa7>
  801699:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80169d:	74 0e                	je     8016ad <smalloc+0xa7>
  80169f:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016a3:	74 08                	je     8016ad <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a8:	8b 40 08             	mov    0x8(%eax),%eax
  8016ab:	eb 05                	jmp    8016b2 <smalloc+0xac>
	}
	return NULL;
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ba:	e8 b4 fc ff ff       	call   801373 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016bf:	83 ec 08             	sub    $0x8,%esp
  8016c2:	ff 75 0c             	pushl  0xc(%ebp)
  8016c5:	ff 75 08             	pushl  0x8(%ebp)
  8016c8:	e8 0b 04 00 00       	call   801ad8 <sys_getSizeOfSharedObject>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8016d3:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8016d7:	74 76                	je     80174f <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016d9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e6:	01 d0                	add    %edx,%eax
  8016e8:	48                   	dec    %eax
  8016e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f4:	f7 75 ec             	divl   -0x14(%ebp)
  8016f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016fa:	29 d0                	sub    %edx,%eax
  8016fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8016ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801706:	e8 1e 06 00 00       	call   801d29 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170b:	85 c0                	test   %eax,%eax
  80170d:	74 11                	je     801720 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80170f:	83 ec 0c             	sub    $0xc,%esp
  801712:	ff 75 e4             	pushl  -0x1c(%ebp)
  801715:	e8 89 0c 00 00       	call   8023a3 <alloc_block_FF>
  80171a:	83 c4 10             	add    $0x10,%esp
  80171d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801724:	74 29                	je     80174f <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801729:	8b 40 08             	mov    0x8(%eax),%eax
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	50                   	push   %eax
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	e8 ba 03 00 00       	call   801af5 <sys_getSharedObject>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801741:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801745:	74 08                	je     80174f <sget+0x9b>
				return (void *)mem_block->sva;
  801747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174a:	8b 40 08             	mov    0x8(%eax),%eax
  80174d:	eb 05                	jmp    801754 <sget+0xa0>
		}
	}
	return (void *)NULL;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80175c:	e8 12 fc ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 08 3f 80 00       	push   $0x803f08
  801769:	68 f1 00 00 00       	push   $0xf1
  80176e:	68 b3 3e 80 00       	push   $0x803eb3
  801773:	e8 bd eb ff ff       	call   800335 <_panic>

00801778 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	68 30 3f 80 00       	push   $0x803f30
  801786:	68 05 01 00 00       	push   $0x105
  80178b:	68 b3 3e 80 00       	push   $0x803eb3
  801790:	e8 a0 eb ff ff       	call   800335 <_panic>

00801795 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	68 54 3f 80 00       	push   $0x803f54
  8017a3:	68 10 01 00 00       	push   $0x110
  8017a8:	68 b3 3e 80 00       	push   $0x803eb3
  8017ad:	e8 83 eb ff ff       	call   800335 <_panic>

008017b2 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b8:	83 ec 04             	sub    $0x4,%esp
  8017bb:	68 54 3f 80 00       	push   $0x803f54
  8017c0:	68 15 01 00 00       	push   $0x115
  8017c5:	68 b3 3e 80 00       	push   $0x803eb3
  8017ca:	e8 66 eb ff ff       	call   800335 <_panic>

008017cf <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 54 3f 80 00       	push   $0x803f54
  8017dd:	68 1a 01 00 00       	push   $0x11a
  8017e2:	68 b3 3e 80 00       	push   $0x803eb3
  8017e7:	e8 49 eb ff ff       	call   800335 <_panic>

008017ec <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	57                   	push   %edi
  8017f0:	56                   	push   %esi
  8017f1:	53                   	push   %ebx
  8017f2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017fe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801801:	8b 7d 18             	mov    0x18(%ebp),%edi
  801804:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801807:	cd 30                	int    $0x30
  801809:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80180c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80180f:	83 c4 10             	add    $0x10,%esp
  801812:	5b                   	pop    %ebx
  801813:	5e                   	pop    %esi
  801814:	5f                   	pop    %edi
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 04             	sub    $0x4,%esp
  80181d:	8b 45 10             	mov    0x10(%ebp),%eax
  801820:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801823:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	52                   	push   %edx
  80182f:	ff 75 0c             	pushl  0xc(%ebp)
  801832:	50                   	push   %eax
  801833:	6a 00                	push   $0x0
  801835:	e8 b2 ff ff ff       	call   8017ec <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_cgetc>:

int
sys_cgetc(void)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 01                	push   $0x1
  80184f:	e8 98 ff ff ff       	call   8017ec <syscall>
  801854:	83 c4 18             	add    $0x18,%esp
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80185c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	6a 05                	push   $0x5
  80186c:	e8 7b ff ff ff       	call   8017ec <syscall>
  801871:	83 c4 18             	add    $0x18,%esp
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80187b:	8b 75 18             	mov    0x18(%ebp),%esi
  80187e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801881:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801884:	8b 55 0c             	mov    0xc(%ebp),%edx
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	51                   	push   %ecx
  80188d:	52                   	push   %edx
  80188e:	50                   	push   %eax
  80188f:	6a 06                	push   $0x6
  801891:	e8 56 ff ff ff       	call   8017ec <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80189c:	5b                   	pop    %ebx
  80189d:	5e                   	pop    %esi
  80189e:	5d                   	pop    %ebp
  80189f:	c3                   	ret    

008018a0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	52                   	push   %edx
  8018b0:	50                   	push   %eax
  8018b1:	6a 07                	push   $0x7
  8018b3:	e8 34 ff ff ff       	call   8017ec <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	6a 08                	push   $0x8
  8018ce:	e8 19 ff ff ff       	call   8017ec <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 09                	push   $0x9
  8018e7:	e8 00 ff ff ff       	call   8017ec <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 0a                	push   $0xa
  801900:	e8 e7 fe ff ff       	call   8017ec <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    

0080190a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 0b                	push   $0xb
  801919:	e8 ce fe ff ff       	call   8017ec <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	ff 75 08             	pushl  0x8(%ebp)
  801932:	6a 0f                	push   $0xf
  801934:	e8 b3 fe ff ff       	call   8017ec <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
	return;
  80193c:	90                   	nop
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	6a 10                	push   $0x10
  801950:	e8 97 fe ff ff       	call   8017ec <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
	return ;
  801958:	90                   	nop
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	ff 75 10             	pushl  0x10(%ebp)
  801965:	ff 75 0c             	pushl  0xc(%ebp)
  801968:	ff 75 08             	pushl  0x8(%ebp)
  80196b:	6a 11                	push   $0x11
  80196d:	e8 7a fe ff ff       	call   8017ec <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
	return ;
  801975:	90                   	nop
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 0c                	push   $0xc
  801987:	e8 60 fe ff ff       	call   8017ec <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	ff 75 08             	pushl  0x8(%ebp)
  80199f:	6a 0d                	push   $0xd
  8019a1:	e8 46 fe ff ff       	call   8017ec <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 0e                	push   $0xe
  8019ba:	e8 2d fe ff ff       	call   8017ec <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	90                   	nop
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 13                	push   $0x13
  8019d4:	e8 13 fe ff ff       	call   8017ec <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	90                   	nop
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 14                	push   $0x14
  8019ee:	e8 f9 fd ff ff       	call   8017ec <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	90                   	nop
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 04             	sub    $0x4,%esp
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a05:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	50                   	push   %eax
  801a12:	6a 15                	push   $0x15
  801a14:	e8 d3 fd ff ff       	call   8017ec <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	90                   	nop
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 16                	push   $0x16
  801a2e:	e8 b9 fd ff ff       	call   8017ec <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	90                   	nop
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	50                   	push   %eax
  801a49:	6a 17                	push   $0x17
  801a4b:	e8 9c fd ff ff       	call   8017ec <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	52                   	push   %edx
  801a65:	50                   	push   %eax
  801a66:	6a 1a                	push   $0x1a
  801a68:	e8 7f fd ff ff       	call   8017ec <syscall>
  801a6d:	83 c4 18             	add    $0x18,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	52                   	push   %edx
  801a82:	50                   	push   %eax
  801a83:	6a 18                	push   $0x18
  801a85:	e8 62 fd ff ff       	call   8017ec <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	90                   	nop
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	6a 19                	push   $0x19
  801aa3:	e8 44 fd ff ff       	call   8017ec <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	90                   	nop
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 04             	sub    $0x4,%esp
  801ab4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aba:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801abd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	51                   	push   %ecx
  801ac7:	52                   	push   %edx
  801ac8:	ff 75 0c             	pushl  0xc(%ebp)
  801acb:	50                   	push   %eax
  801acc:	6a 1b                	push   $0x1b
  801ace:	e8 19 fd ff ff       	call   8017ec <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	52                   	push   %edx
  801ae8:	50                   	push   %eax
  801ae9:	6a 1c                	push   $0x1c
  801aeb:	e8 fc fc ff ff       	call   8017ec <syscall>
  801af0:	83 c4 18             	add    $0x18,%esp
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801afb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801afe:	8b 45 08             	mov    0x8(%ebp),%eax
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	51                   	push   %ecx
  801b06:	52                   	push   %edx
  801b07:	50                   	push   %eax
  801b08:	6a 1d                	push   $0x1d
  801b0a:	e8 dd fc ff ff       	call   8017ec <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	52                   	push   %edx
  801b24:	50                   	push   %eax
  801b25:	6a 1e                	push   $0x1e
  801b27:	e8 c0 fc ff ff       	call   8017ec <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
}
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 1f                	push   $0x1f
  801b40:	e8 a7 fc ff ff       	call   8017ec <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 14             	pushl  0x14(%ebp)
  801b55:	ff 75 10             	pushl  0x10(%ebp)
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	50                   	push   %eax
  801b5c:	6a 20                	push   $0x20
  801b5e:	e8 89 fc ff ff       	call   8017ec <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	50                   	push   %eax
  801b77:	6a 21                	push   $0x21
  801b79:	e8 6e fc ff ff       	call   8017ec <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	50                   	push   %eax
  801b93:	6a 22                	push   $0x22
  801b95:	e8 52 fc ff ff       	call   8017ec <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 02                	push   $0x2
  801bae:	e8 39 fc ff ff       	call   8017ec <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 03                	push   $0x3
  801bc7:	e8 20 fc ff ff       	call   8017ec <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 04                	push   $0x4
  801be0:	e8 07 fc ff ff       	call   8017ec <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_exit_env>:


void sys_exit_env(void)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 23                	push   $0x23
  801bf9:	e8 ee fb ff ff       	call   8017ec <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	90                   	nop
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0d:	8d 50 04             	lea    0x4(%eax),%edx
  801c10:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	52                   	push   %edx
  801c1a:	50                   	push   %eax
  801c1b:	6a 24                	push   $0x24
  801c1d:	e8 ca fb ff ff       	call   8017ec <syscall>
  801c22:	83 c4 18             	add    $0x18,%esp
	return result;
  801c25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c28:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c2b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c2e:	89 01                	mov    %eax,(%ecx)
  801c30:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	c9                   	leave  
  801c37:	c2 04 00             	ret    $0x4

00801c3a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	ff 75 10             	pushl  0x10(%ebp)
  801c44:	ff 75 0c             	pushl  0xc(%ebp)
  801c47:	ff 75 08             	pushl  0x8(%ebp)
  801c4a:	6a 12                	push   $0x12
  801c4c:	e8 9b fb ff ff       	call   8017ec <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
	return ;
  801c54:	90                   	nop
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 25                	push   $0x25
  801c66:	e8 81 fb ff ff       	call   8017ec <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 04             	sub    $0x4,%esp
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c7c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	50                   	push   %eax
  801c89:	6a 26                	push   $0x26
  801c8b:	e8 5c fb ff ff       	call   8017ec <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
	return ;
  801c93:	90                   	nop
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <rsttst>:
void rsttst()
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 28                	push   $0x28
  801ca5:	e8 42 fb ff ff       	call   8017ec <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cad:	90                   	nop
}
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 04             	sub    $0x4,%esp
  801cb6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cbc:	8b 55 18             	mov    0x18(%ebp),%edx
  801cbf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc3:	52                   	push   %edx
  801cc4:	50                   	push   %eax
  801cc5:	ff 75 10             	pushl  0x10(%ebp)
  801cc8:	ff 75 0c             	pushl  0xc(%ebp)
  801ccb:	ff 75 08             	pushl  0x8(%ebp)
  801cce:	6a 27                	push   $0x27
  801cd0:	e8 17 fb ff ff       	call   8017ec <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd8:	90                   	nop
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <chktst>:
void chktst(uint32 n)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	ff 75 08             	pushl  0x8(%ebp)
  801ce9:	6a 29                	push   $0x29
  801ceb:	e8 fc fa ff ff       	call   8017ec <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <inctst>:

void inctst()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 2a                	push   $0x2a
  801d05:	e8 e2 fa ff ff       	call   8017ec <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0d:	90                   	nop
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <gettst>:
uint32 gettst()
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 2b                	push   $0x2b
  801d1f:	e8 c8 fa ff ff       	call   8017ec <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 2c                	push   $0x2c
  801d3b:	e8 ac fa ff ff       	call   8017ec <syscall>
  801d40:	83 c4 18             	add    $0x18,%esp
  801d43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d46:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d4a:	75 07                	jne    801d53 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d51:	eb 05                	jmp    801d58 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 2c                	push   $0x2c
  801d6c:	e8 7b fa ff ff       	call   8017ec <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
  801d74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d77:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d7b:	75 07                	jne    801d84 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d82:	eb 05                	jmp    801d89 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 2c                	push   $0x2c
  801d9d:	e8 4a fa ff ff       	call   8017ec <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
  801da5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dac:	75 07                	jne    801db5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dae:	b8 01 00 00 00       	mov    $0x1,%eax
  801db3:	eb 05                	jmp    801dba <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801db5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 2c                	push   $0x2c
  801dce:	e8 19 fa ff ff       	call   8017ec <syscall>
  801dd3:	83 c4 18             	add    $0x18,%esp
  801dd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dd9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ddd:	75 07                	jne    801de6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ddf:	b8 01 00 00 00       	mov    $0x1,%eax
  801de4:	eb 05                	jmp    801deb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	6a 2d                	push   $0x2d
  801dfd:	e8 ea f9 ff ff       	call   8017ec <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return ;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e0c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e15:	8b 45 08             	mov    0x8(%ebp),%eax
  801e18:	6a 00                	push   $0x0
  801e1a:	53                   	push   %ebx
  801e1b:	51                   	push   %ecx
  801e1c:	52                   	push   %edx
  801e1d:	50                   	push   %eax
  801e1e:	6a 2e                	push   $0x2e
  801e20:	e8 c7 f9 ff ff       	call   8017ec <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e33:	8b 45 08             	mov    0x8(%ebp),%eax
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	52                   	push   %edx
  801e3d:	50                   	push   %eax
  801e3e:	6a 2f                	push   $0x2f
  801e40:	e8 a7 f9 ff ff       	call   8017ec <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	68 64 3f 80 00       	push   $0x803f64
  801e58:	e8 8c e7 ff ff       	call   8005e9 <cprintf>
  801e5d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	68 90 3f 80 00       	push   $0x803f90
  801e6f:	e8 75 e7 ff ff       	call   8005e9 <cprintf>
  801e74:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e77:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e7b:	a1 38 51 80 00       	mov    0x805138,%eax
  801e80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e83:	eb 56                	jmp    801edb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e89:	74 1c                	je     801ea7 <print_mem_block_lists+0x5d>
  801e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8e:	8b 50 08             	mov    0x8(%eax),%edx
  801e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e94:	8b 48 08             	mov    0x8(%eax),%ecx
  801e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9d:	01 c8                	add    %ecx,%eax
  801e9f:	39 c2                	cmp    %eax,%edx
  801ea1:	73 04                	jae    801ea7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ea3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaa:	8b 50 08             	mov    0x8(%eax),%edx
  801ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb3:	01 c2                	add    %eax,%edx
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	8b 40 08             	mov    0x8(%eax),%eax
  801ebb:	83 ec 04             	sub    $0x4,%esp
  801ebe:	52                   	push   %edx
  801ebf:	50                   	push   %eax
  801ec0:	68 a5 3f 80 00       	push   $0x803fa5
  801ec5:	e8 1f e7 ff ff       	call   8005e9 <cprintf>
  801eca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed3:	a1 40 51 80 00       	mov    0x805140,%eax
  801ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edf:	74 07                	je     801ee8 <print_mem_block_lists+0x9e>
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	8b 00                	mov    (%eax),%eax
  801ee6:	eb 05                	jmp    801eed <print_mem_block_lists+0xa3>
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  801eed:	a3 40 51 80 00       	mov    %eax,0x805140
  801ef2:	a1 40 51 80 00       	mov    0x805140,%eax
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	75 8a                	jne    801e85 <print_mem_block_lists+0x3b>
  801efb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eff:	75 84                	jne    801e85 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f01:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f05:	75 10                	jne    801f17 <print_mem_block_lists+0xcd>
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	68 b4 3f 80 00       	push   $0x803fb4
  801f0f:	e8 d5 e6 ff ff       	call   8005e9 <cprintf>
  801f14:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f1e:	83 ec 0c             	sub    $0xc,%esp
  801f21:	68 d8 3f 80 00       	push   $0x803fd8
  801f26:	e8 be e6 ff ff       	call   8005e9 <cprintf>
  801f2b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f2e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f32:	a1 40 50 80 00       	mov    0x805040,%eax
  801f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3a:	eb 56                	jmp    801f92 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f40:	74 1c                	je     801f5e <print_mem_block_lists+0x114>
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 50 08             	mov    0x8(%eax),%edx
  801f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f51:	8b 40 0c             	mov    0xc(%eax),%eax
  801f54:	01 c8                	add    %ecx,%eax
  801f56:	39 c2                	cmp    %eax,%edx
  801f58:	73 04                	jae    801f5e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f5a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 50 08             	mov    0x8(%eax),%edx
  801f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f67:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6a:	01 c2                	add    %eax,%edx
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 40 08             	mov    0x8(%eax),%eax
  801f72:	83 ec 04             	sub    $0x4,%esp
  801f75:	52                   	push   %edx
  801f76:	50                   	push   %eax
  801f77:	68 a5 3f 80 00       	push   $0x803fa5
  801f7c:	e8 68 e6 ff ff       	call   8005e9 <cprintf>
  801f81:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8a:	a1 48 50 80 00       	mov    0x805048,%eax
  801f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f96:	74 07                	je     801f9f <print_mem_block_lists+0x155>
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	8b 00                	mov    (%eax),%eax
  801f9d:	eb 05                	jmp    801fa4 <print_mem_block_lists+0x15a>
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa4:	a3 48 50 80 00       	mov    %eax,0x805048
  801fa9:	a1 48 50 80 00       	mov    0x805048,%eax
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	75 8a                	jne    801f3c <print_mem_block_lists+0xf2>
  801fb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb6:	75 84                	jne    801f3c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fb8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fbc:	75 10                	jne    801fce <print_mem_block_lists+0x184>
  801fbe:	83 ec 0c             	sub    $0xc,%esp
  801fc1:	68 f0 3f 80 00       	push   $0x803ff0
  801fc6:	e8 1e e6 ff ff       	call   8005e9 <cprintf>
  801fcb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fce:	83 ec 0c             	sub    $0xc,%esp
  801fd1:	68 64 3f 80 00       	push   $0x803f64
  801fd6:	e8 0e e6 ff ff       	call   8005e9 <cprintf>
  801fdb:	83 c4 10             	add    $0x10,%esp

}
  801fde:	90                   	nop
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fe7:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801fee:	00 00 00 
  801ff1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801ff8:	00 00 00 
  801ffb:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802002:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  802005:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80200c:	e9 9e 00 00 00       	jmp    8020af <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802011:	a1 50 50 80 00       	mov    0x805050,%eax
  802016:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802019:	c1 e2 04             	shl    $0x4,%edx
  80201c:	01 d0                	add    %edx,%eax
  80201e:	85 c0                	test   %eax,%eax
  802020:	75 14                	jne    802036 <initialize_MemBlocksList+0x55>
  802022:	83 ec 04             	sub    $0x4,%esp
  802025:	68 18 40 80 00       	push   $0x804018
  80202a:	6a 46                	push   $0x46
  80202c:	68 3b 40 80 00       	push   $0x80403b
  802031:	e8 ff e2 ff ff       	call   800335 <_panic>
  802036:	a1 50 50 80 00       	mov    0x805050,%eax
  80203b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203e:	c1 e2 04             	shl    $0x4,%edx
  802041:	01 d0                	add    %edx,%eax
  802043:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802049:	89 10                	mov    %edx,(%eax)
  80204b:	8b 00                	mov    (%eax),%eax
  80204d:	85 c0                	test   %eax,%eax
  80204f:	74 18                	je     802069 <initialize_MemBlocksList+0x88>
  802051:	a1 48 51 80 00       	mov    0x805148,%eax
  802056:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80205c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80205f:	c1 e1 04             	shl    $0x4,%ecx
  802062:	01 ca                	add    %ecx,%edx
  802064:	89 50 04             	mov    %edx,0x4(%eax)
  802067:	eb 12                	jmp    80207b <initialize_MemBlocksList+0x9a>
  802069:	a1 50 50 80 00       	mov    0x805050,%eax
  80206e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802071:	c1 e2 04             	shl    $0x4,%edx
  802074:	01 d0                	add    %edx,%eax
  802076:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80207b:	a1 50 50 80 00       	mov    0x805050,%eax
  802080:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802083:	c1 e2 04             	shl    $0x4,%edx
  802086:	01 d0                	add    %edx,%eax
  802088:	a3 48 51 80 00       	mov    %eax,0x805148
  80208d:	a1 50 50 80 00       	mov    0x805050,%eax
  802092:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802095:	c1 e2 04             	shl    $0x4,%edx
  802098:	01 d0                	add    %edx,%eax
  80209a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8020a6:	40                   	inc    %eax
  8020a7:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020ac:	ff 45 f4             	incl   -0xc(%ebp)
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020b5:	0f 82 56 ff ff ff    	jb     802011 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020bb:	90                   	nop
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	8b 00                	mov    (%eax),%eax
  8020c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020cc:	eb 19                	jmp    8020e7 <find_block+0x29>
	{
		if(va==point->sva)
  8020ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d1:	8b 40 08             	mov    0x8(%eax),%eax
  8020d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020d7:	75 05                	jne    8020de <find_block+0x20>
		   return point;
  8020d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020dc:	eb 36                	jmp    802114 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	8b 40 08             	mov    0x8(%eax),%eax
  8020e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020e7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020eb:	74 07                	je     8020f4 <find_block+0x36>
  8020ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f0:	8b 00                	mov    (%eax),%eax
  8020f2:	eb 05                	jmp    8020f9 <find_block+0x3b>
  8020f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8020fc:	89 42 08             	mov    %eax,0x8(%edx)
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	8b 40 08             	mov    0x8(%eax),%eax
  802105:	85 c0                	test   %eax,%eax
  802107:	75 c5                	jne    8020ce <find_block+0x10>
  802109:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80210d:	75 bf                	jne    8020ce <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80211c:	a1 40 50 80 00       	mov    0x805040,%eax
  802121:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802124:	a1 44 50 80 00       	mov    0x805044,%eax
  802129:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80212c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802132:	74 24                	je     802158 <insert_sorted_allocList+0x42>
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	8b 50 08             	mov    0x8(%eax),%edx
  80213a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213d:	8b 40 08             	mov    0x8(%eax),%eax
  802140:	39 c2                	cmp    %eax,%edx
  802142:	76 14                	jbe    802158 <insert_sorted_allocList+0x42>
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	8b 50 08             	mov    0x8(%eax),%edx
  80214a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80214d:	8b 40 08             	mov    0x8(%eax),%eax
  802150:	39 c2                	cmp    %eax,%edx
  802152:	0f 82 60 01 00 00    	jb     8022b8 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802158:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215c:	75 65                	jne    8021c3 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80215e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802162:	75 14                	jne    802178 <insert_sorted_allocList+0x62>
  802164:	83 ec 04             	sub    $0x4,%esp
  802167:	68 18 40 80 00       	push   $0x804018
  80216c:	6a 6b                	push   $0x6b
  80216e:	68 3b 40 80 00       	push   $0x80403b
  802173:	e8 bd e1 ff ff       	call   800335 <_panic>
  802178:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	89 10                	mov    %edx,(%eax)
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	74 0d                	je     802199 <insert_sorted_allocList+0x83>
  80218c:	a1 40 50 80 00       	mov    0x805040,%eax
  802191:	8b 55 08             	mov    0x8(%ebp),%edx
  802194:	89 50 04             	mov    %edx,0x4(%eax)
  802197:	eb 08                	jmp    8021a1 <insert_sorted_allocList+0x8b>
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 44 50 80 00       	mov    %eax,0x805044
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021b8:	40                   	inc    %eax
  8021b9:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021be:	e9 dc 01 00 00       	jmp    80239f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c6:	8b 50 08             	mov    0x8(%eax),%edx
  8021c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cc:	8b 40 08             	mov    0x8(%eax),%eax
  8021cf:	39 c2                	cmp    %eax,%edx
  8021d1:	77 6c                	ja     80223f <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021d7:	74 06                	je     8021df <insert_sorted_allocList+0xc9>
  8021d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021dd:	75 14                	jne    8021f3 <insert_sorted_allocList+0xdd>
  8021df:	83 ec 04             	sub    $0x4,%esp
  8021e2:	68 54 40 80 00       	push   $0x804054
  8021e7:	6a 6f                	push   $0x6f
  8021e9:	68 3b 40 80 00       	push   $0x80403b
  8021ee:	e8 42 e1 ff ff       	call   800335 <_panic>
  8021f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f6:	8b 50 04             	mov    0x4(%eax),%edx
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	89 50 04             	mov    %edx,0x4(%eax)
  8021ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802202:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802205:	89 10                	mov    %edx,(%eax)
  802207:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220a:	8b 40 04             	mov    0x4(%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	74 0d                	je     80221e <insert_sorted_allocList+0x108>
  802211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802214:	8b 40 04             	mov    0x4(%eax),%eax
  802217:	8b 55 08             	mov    0x8(%ebp),%edx
  80221a:	89 10                	mov    %edx,(%eax)
  80221c:	eb 08                	jmp    802226 <insert_sorted_allocList+0x110>
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	a3 40 50 80 00       	mov    %eax,0x805040
  802226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802229:	8b 55 08             	mov    0x8(%ebp),%edx
  80222c:	89 50 04             	mov    %edx,0x4(%eax)
  80222f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802234:	40                   	inc    %eax
  802235:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80223a:	e9 60 01 00 00       	jmp    80239f <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	8b 50 08             	mov    0x8(%eax),%edx
  802245:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802248:	8b 40 08             	mov    0x8(%eax),%eax
  80224b:	39 c2                	cmp    %eax,%edx
  80224d:	0f 82 4c 01 00 00    	jb     80239f <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802253:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802257:	75 14                	jne    80226d <insert_sorted_allocList+0x157>
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	68 8c 40 80 00       	push   $0x80408c
  802261:	6a 73                	push   $0x73
  802263:	68 3b 40 80 00       	push   $0x80403b
  802268:	e8 c8 e0 ff ff       	call   800335 <_panic>
  80226d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	89 50 04             	mov    %edx,0x4(%eax)
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	8b 40 04             	mov    0x4(%eax),%eax
  80227f:	85 c0                	test   %eax,%eax
  802281:	74 0c                	je     80228f <insert_sorted_allocList+0x179>
  802283:	a1 44 50 80 00       	mov    0x805044,%eax
  802288:	8b 55 08             	mov    0x8(%ebp),%edx
  80228b:	89 10                	mov    %edx,(%eax)
  80228d:	eb 08                	jmp    802297 <insert_sorted_allocList+0x181>
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	a3 40 50 80 00       	mov    %eax,0x805040
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	a3 44 50 80 00       	mov    %eax,0x805044
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022ad:	40                   	inc    %eax
  8022ae:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022b3:	e9 e7 00 00 00       	jmp    80239f <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022c5:	a1 40 50 80 00       	mov    0x805040,%eax
  8022ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cd:	e9 9d 00 00 00       	jmp    80236f <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 00                	mov    (%eax),%eax
  8022d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	8b 50 08             	mov    0x8(%eax),%edx
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	8b 40 08             	mov    0x8(%eax),%eax
  8022e6:	39 c2                	cmp    %eax,%edx
  8022e8:	76 7d                	jbe    802367 <insert_sorted_allocList+0x251>
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	8b 50 08             	mov    0x8(%eax),%edx
  8022f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f3:	8b 40 08             	mov    0x8(%eax),%eax
  8022f6:	39 c2                	cmp    %eax,%edx
  8022f8:	73 6d                	jae    802367 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fe:	74 06                	je     802306 <insert_sorted_allocList+0x1f0>
  802300:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802304:	75 14                	jne    80231a <insert_sorted_allocList+0x204>
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	68 b0 40 80 00       	push   $0x8040b0
  80230e:	6a 7f                	push   $0x7f
  802310:	68 3b 40 80 00       	push   $0x80403b
  802315:	e8 1b e0 ff ff       	call   800335 <_panic>
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	8b 10                	mov    (%eax),%edx
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	89 10                	mov    %edx,(%eax)
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	8b 00                	mov    (%eax),%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 0b                	je     802338 <insert_sorted_allocList+0x222>
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	8b 55 08             	mov    0x8(%ebp),%edx
  802335:	89 50 04             	mov    %edx,0x4(%eax)
  802338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233b:	8b 55 08             	mov    0x8(%ebp),%edx
  80233e:	89 10                	mov    %edx,(%eax)
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802346:	89 50 04             	mov    %edx,0x4(%eax)
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8b 00                	mov    (%eax),%eax
  80234e:	85 c0                	test   %eax,%eax
  802350:	75 08                	jne    80235a <insert_sorted_allocList+0x244>
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	a3 44 50 80 00       	mov    %eax,0x805044
  80235a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80235f:	40                   	inc    %eax
  802360:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802365:	eb 39                	jmp    8023a0 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802367:	a1 48 50 80 00       	mov    0x805048,%eax
  80236c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802373:	74 07                	je     80237c <insert_sorted_allocList+0x266>
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 00                	mov    (%eax),%eax
  80237a:	eb 05                	jmp    802381 <insert_sorted_allocList+0x26b>
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
  802381:	a3 48 50 80 00       	mov    %eax,0x805048
  802386:	a1 48 50 80 00       	mov    0x805048,%eax
  80238b:	85 c0                	test   %eax,%eax
  80238d:	0f 85 3f ff ff ff    	jne    8022d2 <insert_sorted_allocList+0x1bc>
  802393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802397:	0f 85 35 ff ff ff    	jne    8022d2 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80239d:	eb 01                	jmp    8023a0 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80239f:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023a0:	90                   	nop
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023a9:	a1 38 51 80 00       	mov    0x805138,%eax
  8023ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b1:	e9 85 01 00 00       	jmp    80253b <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023bf:	0f 82 6e 01 00 00    	jb     802533 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ce:	0f 85 8a 00 00 00    	jne    80245e <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d8:	75 17                	jne    8023f1 <alloc_block_FF+0x4e>
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	68 e4 40 80 00       	push   $0x8040e4
  8023e2:	68 93 00 00 00       	push   $0x93
  8023e7:	68 3b 40 80 00       	push   $0x80403b
  8023ec:	e8 44 df ff ff       	call   800335 <_panic>
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 00                	mov    (%eax),%eax
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	74 10                	je     80240a <alloc_block_FF+0x67>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 00                	mov    (%eax),%eax
  8023ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802402:	8b 52 04             	mov    0x4(%edx),%edx
  802405:	89 50 04             	mov    %edx,0x4(%eax)
  802408:	eb 0b                	jmp    802415 <alloc_block_FF+0x72>
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 40 04             	mov    0x4(%eax),%eax
  802410:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 40 04             	mov    0x4(%eax),%eax
  80241b:	85 c0                	test   %eax,%eax
  80241d:	74 0f                	je     80242e <alloc_block_FF+0x8b>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 04             	mov    0x4(%eax),%eax
  802425:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802428:	8b 12                	mov    (%edx),%edx
  80242a:	89 10                	mov    %edx,(%eax)
  80242c:	eb 0a                	jmp    802438 <alloc_block_FF+0x95>
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 00                	mov    (%eax),%eax
  802433:	a3 38 51 80 00       	mov    %eax,0x805138
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244b:	a1 44 51 80 00       	mov    0x805144,%eax
  802450:	48                   	dec    %eax
  802451:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802459:	e9 10 01 00 00       	jmp    80256e <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 0c             	mov    0xc(%eax),%eax
  802464:	3b 45 08             	cmp    0x8(%ebp),%eax
  802467:	0f 86 c6 00 00 00    	jbe    802533 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80246d:	a1 48 51 80 00       	mov    0x805148,%eax
  802472:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 50 08             	mov    0x8(%eax),%edx
  80247b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247e:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802484:	8b 55 08             	mov    0x8(%ebp),%edx
  802487:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80248a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80248e:	75 17                	jne    8024a7 <alloc_block_FF+0x104>
  802490:	83 ec 04             	sub    $0x4,%esp
  802493:	68 e4 40 80 00       	push   $0x8040e4
  802498:	68 9b 00 00 00       	push   $0x9b
  80249d:	68 3b 40 80 00       	push   $0x80403b
  8024a2:	e8 8e de ff ff       	call   800335 <_panic>
  8024a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	74 10                	je     8024c0 <alloc_block_FF+0x11d>
  8024b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b3:	8b 00                	mov    (%eax),%eax
  8024b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b8:	8b 52 04             	mov    0x4(%edx),%edx
  8024bb:	89 50 04             	mov    %edx,0x4(%eax)
  8024be:	eb 0b                	jmp    8024cb <alloc_block_FF+0x128>
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	8b 40 04             	mov    0x4(%eax),%eax
  8024c6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8024cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	74 0f                	je     8024e4 <alloc_block_FF+0x141>
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	8b 40 04             	mov    0x4(%eax),%eax
  8024db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024de:	8b 12                	mov    (%edx),%edx
  8024e0:	89 10                	mov    %edx,(%eax)
  8024e2:	eb 0a                	jmp    8024ee <alloc_block_FF+0x14b>
  8024e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8024ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802501:	a1 54 51 80 00       	mov    0x805154,%eax
  802506:	48                   	dec    %eax
  802507:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 50 08             	mov    0x8(%eax),%edx
  802512:	8b 45 08             	mov    0x8(%ebp),%eax
  802515:	01 c2                	add    %eax,%edx
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 40 0c             	mov    0xc(%eax),%eax
  802523:	2b 45 08             	sub    0x8(%ebp),%eax
  802526:	89 c2                	mov    %eax,%edx
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80252e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802531:	eb 3b                	jmp    80256e <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802533:	a1 40 51 80 00       	mov    0x805140,%eax
  802538:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253f:	74 07                	je     802548 <alloc_block_FF+0x1a5>
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 00                	mov    (%eax),%eax
  802546:	eb 05                	jmp    80254d <alloc_block_FF+0x1aa>
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
  80254d:	a3 40 51 80 00       	mov    %eax,0x805140
  802552:	a1 40 51 80 00       	mov    0x805140,%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	0f 85 57 fe ff ff    	jne    8023b6 <alloc_block_FF+0x13>
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	0f 85 4d fe ff ff    	jne    8023b6 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802576:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80257d:	a1 38 51 80 00       	mov    0x805138,%eax
  802582:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802585:	e9 df 00 00 00       	jmp    802669 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 0c             	mov    0xc(%eax),%eax
  802590:	3b 45 08             	cmp    0x8(%ebp),%eax
  802593:	0f 82 c8 00 00 00    	jb     802661 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 40 0c             	mov    0xc(%eax),%eax
  80259f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a2:	0f 85 8a 00 00 00    	jne    802632 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ac:	75 17                	jne    8025c5 <alloc_block_BF+0x55>
  8025ae:	83 ec 04             	sub    $0x4,%esp
  8025b1:	68 e4 40 80 00       	push   $0x8040e4
  8025b6:	68 b7 00 00 00       	push   $0xb7
  8025bb:	68 3b 40 80 00       	push   $0x80403b
  8025c0:	e8 70 dd ff ff       	call   800335 <_panic>
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 00                	mov    (%eax),%eax
  8025ca:	85 c0                	test   %eax,%eax
  8025cc:	74 10                	je     8025de <alloc_block_BF+0x6e>
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d6:	8b 52 04             	mov    0x4(%edx),%edx
  8025d9:	89 50 04             	mov    %edx,0x4(%eax)
  8025dc:	eb 0b                	jmp    8025e9 <alloc_block_BF+0x79>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 04             	mov    0x4(%eax),%eax
  8025e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 04             	mov    0x4(%eax),%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	74 0f                	je     802602 <alloc_block_BF+0x92>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fc:	8b 12                	mov    (%edx),%edx
  8025fe:	89 10                	mov    %edx,(%eax)
  802600:	eb 0a                	jmp    80260c <alloc_block_BF+0x9c>
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	a3 38 51 80 00       	mov    %eax,0x805138
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261f:	a1 44 51 80 00       	mov    0x805144,%eax
  802624:	48                   	dec    %eax
  802625:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	e9 4d 01 00 00       	jmp    80277f <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 40 0c             	mov    0xc(%eax),%eax
  802638:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263b:	76 24                	jbe    802661 <alloc_block_BF+0xf1>
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 40 0c             	mov    0xc(%eax),%eax
  802643:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802646:	73 19                	jae    802661 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802648:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 40 0c             	mov    0xc(%eax),%eax
  802655:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 40 08             	mov    0x8(%eax),%eax
  80265e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802661:	a1 40 51 80 00       	mov    0x805140,%eax
  802666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	74 07                	je     802676 <alloc_block_BF+0x106>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	eb 05                	jmp    80267b <alloc_block_BF+0x10b>
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
  80267b:	a3 40 51 80 00       	mov    %eax,0x805140
  802680:	a1 40 51 80 00       	mov    0x805140,%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	0f 85 fd fe ff ff    	jne    80258a <alloc_block_BF+0x1a>
  80268d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802691:	0f 85 f3 fe ff ff    	jne    80258a <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802697:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80269b:	0f 84 d9 00 00 00    	je     80277a <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026a1:	a1 48 51 80 00       	mov    0x805148,%eax
  8026a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026af:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b8:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026bf:	75 17                	jne    8026d8 <alloc_block_BF+0x168>
  8026c1:	83 ec 04             	sub    $0x4,%esp
  8026c4:	68 e4 40 80 00       	push   $0x8040e4
  8026c9:	68 c7 00 00 00       	push   $0xc7
  8026ce:	68 3b 40 80 00       	push   $0x80403b
  8026d3:	e8 5d dc ff ff       	call   800335 <_panic>
  8026d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026db:	8b 00                	mov    (%eax),%eax
  8026dd:	85 c0                	test   %eax,%eax
  8026df:	74 10                	je     8026f1 <alloc_block_BF+0x181>
  8026e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e4:	8b 00                	mov    (%eax),%eax
  8026e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e9:	8b 52 04             	mov    0x4(%edx),%edx
  8026ec:	89 50 04             	mov    %edx,0x4(%eax)
  8026ef:	eb 0b                	jmp    8026fc <alloc_block_BF+0x18c>
  8026f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f4:	8b 40 04             	mov    0x4(%eax),%eax
  8026f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ff:	8b 40 04             	mov    0x4(%eax),%eax
  802702:	85 c0                	test   %eax,%eax
  802704:	74 0f                	je     802715 <alloc_block_BF+0x1a5>
  802706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80270f:	8b 12                	mov    (%edx),%edx
  802711:	89 10                	mov    %edx,(%eax)
  802713:	eb 0a                	jmp    80271f <alloc_block_BF+0x1af>
  802715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	a3 48 51 80 00       	mov    %eax,0x805148
  80271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802732:	a1 54 51 80 00       	mov    0x805154,%eax
  802737:	48                   	dec    %eax
  802738:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80273d:	83 ec 08             	sub    $0x8,%esp
  802740:	ff 75 ec             	pushl  -0x14(%ebp)
  802743:	68 38 51 80 00       	push   $0x805138
  802748:	e8 71 f9 ff ff       	call   8020be <find_block>
  80274d:	83 c4 10             	add    $0x10,%esp
  802750:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802753:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802756:	8b 50 08             	mov    0x8(%eax),%edx
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	01 c2                	add    %eax,%edx
  80275e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802761:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802764:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802767:	8b 40 0c             	mov    0xc(%eax),%eax
  80276a:	2b 45 08             	sub    0x8(%ebp),%eax
  80276d:	89 c2                	mov    %eax,%edx
  80276f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802772:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802778:	eb 05                	jmp    80277f <alloc_block_BF+0x20f>
	}
	return NULL;
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802787:	a1 28 50 80 00       	mov    0x805028,%eax
  80278c:	85 c0                	test   %eax,%eax
  80278e:	0f 85 de 01 00 00    	jne    802972 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802794:	a1 38 51 80 00       	mov    0x805138,%eax
  802799:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279c:	e9 9e 01 00 00       	jmp    80293f <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027aa:	0f 82 87 01 00 00    	jb     802937 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b9:	0f 85 95 00 00 00    	jne    802854 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c3:	75 17                	jne    8027dc <alloc_block_NF+0x5b>
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	68 e4 40 80 00       	push   $0x8040e4
  8027cd:	68 e0 00 00 00       	push   $0xe0
  8027d2:	68 3b 40 80 00       	push   $0x80403b
  8027d7:	e8 59 db ff ff       	call   800335 <_panic>
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	74 10                	je     8027f5 <alloc_block_NF+0x74>
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ed:	8b 52 04             	mov    0x4(%edx),%edx
  8027f0:	89 50 04             	mov    %edx,0x4(%eax)
  8027f3:	eb 0b                	jmp    802800 <alloc_block_NF+0x7f>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 0f                	je     802819 <alloc_block_NF+0x98>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802813:	8b 12                	mov    (%edx),%edx
  802815:	89 10                	mov    %edx,(%eax)
  802817:	eb 0a                	jmp    802823 <alloc_block_NF+0xa2>
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	a3 38 51 80 00       	mov    %eax,0x805138
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802836:	a1 44 51 80 00       	mov    0x805144,%eax
  80283b:	48                   	dec    %eax
  80283c:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 40 08             	mov    0x8(%eax),%eax
  802847:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	e9 f8 04 00 00       	jmp    802d4c <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 40 0c             	mov    0xc(%eax),%eax
  80285a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285d:	0f 86 d4 00 00 00    	jbe    802937 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802863:	a1 48 51 80 00       	mov    0x805148,%eax
  802868:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 50 08             	mov    0x8(%eax),%edx
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	8b 55 08             	mov    0x8(%ebp),%edx
  80287d:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802880:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802884:	75 17                	jne    80289d <alloc_block_NF+0x11c>
  802886:	83 ec 04             	sub    $0x4,%esp
  802889:	68 e4 40 80 00       	push   $0x8040e4
  80288e:	68 e9 00 00 00       	push   $0xe9
  802893:	68 3b 40 80 00       	push   $0x80403b
  802898:	e8 98 da ff ff       	call   800335 <_panic>
  80289d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 10                	je     8028b6 <alloc_block_NF+0x135>
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	8b 00                	mov    (%eax),%eax
  8028ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ae:	8b 52 04             	mov    0x4(%edx),%edx
  8028b1:	89 50 04             	mov    %edx,0x4(%eax)
  8028b4:	eb 0b                	jmp    8028c1 <alloc_block_NF+0x140>
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	85 c0                	test   %eax,%eax
  8028c9:	74 0f                	je     8028da <alloc_block_NF+0x159>
  8028cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ce:	8b 40 04             	mov    0x4(%eax),%eax
  8028d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d4:	8b 12                	mov    (%edx),%edx
  8028d6:	89 10                	mov    %edx,(%eax)
  8028d8:	eb 0a                	jmp    8028e4 <alloc_block_NF+0x163>
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 00                	mov    (%eax),%eax
  8028df:	a3 48 51 80 00       	mov    %eax,0x805148
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f7:	a1 54 51 80 00       	mov    0x805154,%eax
  8028fc:	48                   	dec    %eax
  8028fd:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8b 40 08             	mov    0x8(%eax),%eax
  802908:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 50 08             	mov    0x8(%eax),%edx
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	01 c2                	add    %eax,%edx
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	2b 45 08             	sub    0x8(%ebp),%eax
  802927:	89 c2                	mov    %eax,%edx
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	e9 15 04 00 00       	jmp    802d4c <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802937:	a1 40 51 80 00       	mov    0x805140,%eax
  80293c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802943:	74 07                	je     80294c <alloc_block_NF+0x1cb>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 00                	mov    (%eax),%eax
  80294a:	eb 05                	jmp    802951 <alloc_block_NF+0x1d0>
  80294c:	b8 00 00 00 00       	mov    $0x0,%eax
  802951:	a3 40 51 80 00       	mov    %eax,0x805140
  802956:	a1 40 51 80 00       	mov    0x805140,%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	0f 85 3e fe ff ff    	jne    8027a1 <alloc_block_NF+0x20>
  802963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802967:	0f 85 34 fe ff ff    	jne    8027a1 <alloc_block_NF+0x20>
  80296d:	e9 d5 03 00 00       	jmp    802d47 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802972:	a1 38 51 80 00       	mov    0x805138,%eax
  802977:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297a:	e9 b1 01 00 00       	jmp    802b30 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 50 08             	mov    0x8(%eax),%edx
  802985:	a1 28 50 80 00       	mov    0x805028,%eax
  80298a:	39 c2                	cmp    %eax,%edx
  80298c:	0f 82 96 01 00 00    	jb     802b28 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 40 0c             	mov    0xc(%eax),%eax
  802998:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299b:	0f 82 87 01 00 00    	jb     802b28 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029aa:	0f 85 95 00 00 00    	jne    802a45 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b4:	75 17                	jne    8029cd <alloc_block_NF+0x24c>
  8029b6:	83 ec 04             	sub    $0x4,%esp
  8029b9:	68 e4 40 80 00       	push   $0x8040e4
  8029be:	68 fc 00 00 00       	push   $0xfc
  8029c3:	68 3b 40 80 00       	push   $0x80403b
  8029c8:	e8 68 d9 ff ff       	call   800335 <_panic>
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 10                	je     8029e6 <alloc_block_NF+0x265>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029de:	8b 52 04             	mov    0x4(%edx),%edx
  8029e1:	89 50 04             	mov    %edx,0x4(%eax)
  8029e4:	eb 0b                	jmp    8029f1 <alloc_block_NF+0x270>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ec:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 40 04             	mov    0x4(%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	74 0f                	je     802a0a <alloc_block_NF+0x289>
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 04             	mov    0x4(%eax),%eax
  802a01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a04:	8b 12                	mov    (%edx),%edx
  802a06:	89 10                	mov    %edx,(%eax)
  802a08:	eb 0a                	jmp    802a14 <alloc_block_NF+0x293>
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 00                	mov    (%eax),%eax
  802a0f:	a3 38 51 80 00       	mov    %eax,0x805138
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a27:	a1 44 51 80 00       	mov    0x805144,%eax
  802a2c:	48                   	dec    %eax
  802a2d:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 08             	mov    0x8(%eax),%eax
  802a38:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	e9 07 03 00 00       	jmp    802d4c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4e:	0f 86 d4 00 00 00    	jbe    802b28 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a54:	a1 48 51 80 00       	mov    0x805148,%eax
  802a59:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 50 08             	mov    0x8(%eax),%edx
  802a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a65:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6e:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a71:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a75:	75 17                	jne    802a8e <alloc_block_NF+0x30d>
  802a77:	83 ec 04             	sub    $0x4,%esp
  802a7a:	68 e4 40 80 00       	push   $0x8040e4
  802a7f:	68 04 01 00 00       	push   $0x104
  802a84:	68 3b 40 80 00       	push   $0x80403b
  802a89:	e8 a7 d8 ff ff       	call   800335 <_panic>
  802a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a91:	8b 00                	mov    (%eax),%eax
  802a93:	85 c0                	test   %eax,%eax
  802a95:	74 10                	je     802aa7 <alloc_block_NF+0x326>
  802a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9a:	8b 00                	mov    (%eax),%eax
  802a9c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a9f:	8b 52 04             	mov    0x4(%edx),%edx
  802aa2:	89 50 04             	mov    %edx,0x4(%eax)
  802aa5:	eb 0b                	jmp    802ab2 <alloc_block_NF+0x331>
  802aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aaa:	8b 40 04             	mov    0x4(%eax),%eax
  802aad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab5:	8b 40 04             	mov    0x4(%eax),%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	74 0f                	je     802acb <alloc_block_NF+0x34a>
  802abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abf:	8b 40 04             	mov    0x4(%eax),%eax
  802ac2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac5:	8b 12                	mov    (%edx),%edx
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	eb 0a                	jmp    802ad5 <alloc_block_NF+0x354>
  802acb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ad5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae8:	a1 54 51 80 00       	mov    0x805154,%eax
  802aed:	48                   	dec    %eax
  802aee:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802af3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af6:	8b 40 08             	mov    0x8(%eax),%eax
  802af9:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 50 08             	mov    0x8(%eax),%edx
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	01 c2                	add    %eax,%edx
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 0c             	mov    0xc(%eax),%eax
  802b15:	2b 45 08             	sub    0x8(%ebp),%eax
  802b18:	89 c2                	mov    %eax,%edx
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b23:	e9 24 02 00 00       	jmp    802d4c <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b28:	a1 40 51 80 00       	mov    0x805140,%eax
  802b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b34:	74 07                	je     802b3d <alloc_block_NF+0x3bc>
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	eb 05                	jmp    802b42 <alloc_block_NF+0x3c1>
  802b3d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b42:	a3 40 51 80 00       	mov    %eax,0x805140
  802b47:	a1 40 51 80 00       	mov    0x805140,%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	0f 85 2b fe ff ff    	jne    80297f <alloc_block_NF+0x1fe>
  802b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b58:	0f 85 21 fe ff ff    	jne    80297f <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b5e:	a1 38 51 80 00       	mov    0x805138,%eax
  802b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b66:	e9 ae 01 00 00       	jmp    802d19 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 50 08             	mov    0x8(%eax),%edx
  802b71:	a1 28 50 80 00       	mov    0x805028,%eax
  802b76:	39 c2                	cmp    %eax,%edx
  802b78:	0f 83 93 01 00 00    	jae    802d11 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b87:	0f 82 84 01 00 00    	jb     802d11 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 40 0c             	mov    0xc(%eax),%eax
  802b93:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b96:	0f 85 95 00 00 00    	jne    802c31 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba0:	75 17                	jne    802bb9 <alloc_block_NF+0x438>
  802ba2:	83 ec 04             	sub    $0x4,%esp
  802ba5:	68 e4 40 80 00       	push   $0x8040e4
  802baa:	68 14 01 00 00       	push   $0x114
  802baf:	68 3b 40 80 00       	push   $0x80403b
  802bb4:	e8 7c d7 ff ff       	call   800335 <_panic>
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 10                	je     802bd2 <alloc_block_NF+0x451>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 00                	mov    (%eax),%eax
  802bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bca:	8b 52 04             	mov    0x4(%edx),%edx
  802bcd:	89 50 04             	mov    %edx,0x4(%eax)
  802bd0:	eb 0b                	jmp    802bdd <alloc_block_NF+0x45c>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 40 04             	mov    0x4(%eax),%eax
  802bd8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 0f                	je     802bf6 <alloc_block_NF+0x475>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 04             	mov    0x4(%eax),%eax
  802bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf0:	8b 12                	mov    (%edx),%edx
  802bf2:	89 10                	mov    %edx,(%eax)
  802bf4:	eb 0a                	jmp    802c00 <alloc_block_NF+0x47f>
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	a3 38 51 80 00       	mov    %eax,0x805138
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c13:	a1 44 51 80 00       	mov    0x805144,%eax
  802c18:	48                   	dec    %eax
  802c19:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	8b 40 08             	mov    0x8(%eax),%eax
  802c24:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	e9 1b 01 00 00       	jmp    802d4c <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3a:	0f 86 d1 00 00 00    	jbe    802d11 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c40:	a1 48 51 80 00       	mov    0x805148,%eax
  802c45:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 50 08             	mov    0x8(%eax),%edx
  802c4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c51:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c57:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c61:	75 17                	jne    802c7a <alloc_block_NF+0x4f9>
  802c63:	83 ec 04             	sub    $0x4,%esp
  802c66:	68 e4 40 80 00       	push   $0x8040e4
  802c6b:	68 1c 01 00 00       	push   $0x11c
  802c70:	68 3b 40 80 00       	push   $0x80403b
  802c75:	e8 bb d6 ff ff       	call   800335 <_panic>
  802c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	74 10                	je     802c93 <alloc_block_NF+0x512>
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c86:	8b 00                	mov    (%eax),%eax
  802c88:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c8b:	8b 52 04             	mov    0x4(%edx),%edx
  802c8e:	89 50 04             	mov    %edx,0x4(%eax)
  802c91:	eb 0b                	jmp    802c9e <alloc_block_NF+0x51d>
  802c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca1:	8b 40 04             	mov    0x4(%eax),%eax
  802ca4:	85 c0                	test   %eax,%eax
  802ca6:	74 0f                	je     802cb7 <alloc_block_NF+0x536>
  802ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cab:	8b 40 04             	mov    0x4(%eax),%eax
  802cae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cb1:	8b 12                	mov    (%edx),%edx
  802cb3:	89 10                	mov    %edx,(%eax)
  802cb5:	eb 0a                	jmp    802cc1 <alloc_block_NF+0x540>
  802cb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	a3 48 51 80 00       	mov    %eax,0x805148
  802cc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd4:	a1 54 51 80 00       	mov    0x805154,%eax
  802cd9:	48                   	dec    %eax
  802cda:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802cdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce2:	8b 40 08             	mov    0x8(%eax),%eax
  802ce5:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 50 08             	mov    0x8(%eax),%edx
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	01 c2                	add    %eax,%edx
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	2b 45 08             	sub    0x8(%ebp),%eax
  802d04:	89 c2                	mov    %eax,%edx
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0f:	eb 3b                	jmp    802d4c <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d11:	a1 40 51 80 00       	mov    0x805140,%eax
  802d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1d:	74 07                	je     802d26 <alloc_block_NF+0x5a5>
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	eb 05                	jmp    802d2b <alloc_block_NF+0x5aa>
  802d26:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2b:	a3 40 51 80 00       	mov    %eax,0x805140
  802d30:	a1 40 51 80 00       	mov    0x805140,%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	0f 85 2e fe ff ff    	jne    802b6b <alloc_block_NF+0x3ea>
  802d3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d41:	0f 85 24 fe ff ff    	jne    802b6b <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4c:	c9                   	leave  
  802d4d:	c3                   	ret    

00802d4e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d4e:	55                   	push   %ebp
  802d4f:	89 e5                	mov    %esp,%ebp
  802d51:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d54:	a1 38 51 80 00       	mov    0x805138,%eax
  802d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d5c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d61:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d64:	a1 38 51 80 00       	mov    0x805138,%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	74 14                	je     802d81 <insert_sorted_with_merge_freeList+0x33>
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	8b 50 08             	mov    0x8(%eax),%edx
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	8b 40 08             	mov    0x8(%eax),%eax
  802d79:	39 c2                	cmp    %eax,%edx
  802d7b:	0f 87 9b 01 00 00    	ja     802f1c <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d85:	75 17                	jne    802d9e <insert_sorted_with_merge_freeList+0x50>
  802d87:	83 ec 04             	sub    $0x4,%esp
  802d8a:	68 18 40 80 00       	push   $0x804018
  802d8f:	68 38 01 00 00       	push   $0x138
  802d94:	68 3b 40 80 00       	push   $0x80403b
  802d99:	e8 97 d5 ff ff       	call   800335 <_panic>
  802d9e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	89 10                	mov    %edx,(%eax)
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	74 0d                	je     802dbf <insert_sorted_with_merge_freeList+0x71>
  802db2:	a1 38 51 80 00       	mov    0x805138,%eax
  802db7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dba:	89 50 04             	mov    %edx,0x4(%eax)
  802dbd:	eb 08                	jmp    802dc7 <insert_sorted_with_merge_freeList+0x79>
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	a3 38 51 80 00       	mov    %eax,0x805138
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd9:	a1 44 51 80 00       	mov    0x805144,%eax
  802dde:	40                   	inc    %eax
  802ddf:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802de4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de8:	0f 84 a8 06 00 00    	je     803496 <insert_sorted_with_merge_freeList+0x748>
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	8b 50 08             	mov    0x8(%eax),%edx
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfa:	01 c2                	add    %eax,%edx
  802dfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dff:	8b 40 08             	mov    0x8(%eax),%eax
  802e02:	39 c2                	cmp    %eax,%edx
  802e04:	0f 85 8c 06 00 00    	jne    803496 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e13:	8b 40 0c             	mov    0xc(%eax),%eax
  802e16:	01 c2                	add    %eax,%edx
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e22:	75 17                	jne    802e3b <insert_sorted_with_merge_freeList+0xed>
  802e24:	83 ec 04             	sub    $0x4,%esp
  802e27:	68 e4 40 80 00       	push   $0x8040e4
  802e2c:	68 3c 01 00 00       	push   $0x13c
  802e31:	68 3b 40 80 00       	push   $0x80403b
  802e36:	e8 fa d4 ff ff       	call   800335 <_panic>
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	85 c0                	test   %eax,%eax
  802e42:	74 10                	je     802e54 <insert_sorted_with_merge_freeList+0x106>
  802e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e47:	8b 00                	mov    (%eax),%eax
  802e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4c:	8b 52 04             	mov    0x4(%edx),%edx
  802e4f:	89 50 04             	mov    %edx,0x4(%eax)
  802e52:	eb 0b                	jmp    802e5f <insert_sorted_with_merge_freeList+0x111>
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	8b 40 04             	mov    0x4(%eax),%eax
  802e5a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e62:	8b 40 04             	mov    0x4(%eax),%eax
  802e65:	85 c0                	test   %eax,%eax
  802e67:	74 0f                	je     802e78 <insert_sorted_with_merge_freeList+0x12a>
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	8b 40 04             	mov    0x4(%eax),%eax
  802e6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e72:	8b 12                	mov    (%edx),%edx
  802e74:	89 10                	mov    %edx,(%eax)
  802e76:	eb 0a                	jmp    802e82 <insert_sorted_with_merge_freeList+0x134>
  802e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	a3 38 51 80 00       	mov    %eax,0x805138
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e95:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9a:	48                   	dec    %eax
  802e9b:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802eb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eb8:	75 17                	jne    802ed1 <insert_sorted_with_merge_freeList+0x183>
  802eba:	83 ec 04             	sub    $0x4,%esp
  802ebd:	68 18 40 80 00       	push   $0x804018
  802ec2:	68 3f 01 00 00       	push   $0x13f
  802ec7:	68 3b 40 80 00       	push   $0x80403b
  802ecc:	e8 64 d4 ff ff       	call   800335 <_panic>
  802ed1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eda:	89 10                	mov    %edx,(%eax)
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	85 c0                	test   %eax,%eax
  802ee3:	74 0d                	je     802ef2 <insert_sorted_with_merge_freeList+0x1a4>
  802ee5:	a1 48 51 80 00       	mov    0x805148,%eax
  802eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eed:	89 50 04             	mov    %edx,0x4(%eax)
  802ef0:	eb 08                	jmp    802efa <insert_sorted_with_merge_freeList+0x1ac>
  802ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	a3 48 51 80 00       	mov    %eax,0x805148
  802f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0c:	a1 54 51 80 00       	mov    0x805154,%eax
  802f11:	40                   	inc    %eax
  802f12:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f17:	e9 7a 05 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 50 08             	mov    0x8(%eax),%edx
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	8b 40 08             	mov    0x8(%eax),%eax
  802f28:	39 c2                	cmp    %eax,%edx
  802f2a:	0f 82 14 01 00 00    	jb     803044 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f33:	8b 50 08             	mov    0x8(%eax),%edx
  802f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f39:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3c:	01 c2                	add    %eax,%edx
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	8b 40 08             	mov    0x8(%eax),%eax
  802f44:	39 c2                	cmp    %eax,%edx
  802f46:	0f 85 90 00 00 00    	jne    802fdc <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	01 c2                	add    %eax,%edx
  802f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5d:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f78:	75 17                	jne    802f91 <insert_sorted_with_merge_freeList+0x243>
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	68 18 40 80 00       	push   $0x804018
  802f82:	68 49 01 00 00       	push   $0x149
  802f87:	68 3b 40 80 00       	push   $0x80403b
  802f8c:	e8 a4 d3 ff ff       	call   800335 <_panic>
  802f91:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	89 10                	mov    %edx,(%eax)
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 0d                	je     802fb2 <insert_sorted_with_merge_freeList+0x264>
  802fa5:	a1 48 51 80 00       	mov    0x805148,%eax
  802faa:	8b 55 08             	mov    0x8(%ebp),%edx
  802fad:	89 50 04             	mov    %edx,0x4(%eax)
  802fb0:	eb 08                	jmp    802fba <insert_sorted_with_merge_freeList+0x26c>
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	a3 48 51 80 00       	mov    %eax,0x805148
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcc:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd1:	40                   	inc    %eax
  802fd2:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fd7:	e9 bb 04 00 00       	jmp    803497 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe0:	75 17                	jne    802ff9 <insert_sorted_with_merge_freeList+0x2ab>
  802fe2:	83 ec 04             	sub    $0x4,%esp
  802fe5:	68 8c 40 80 00       	push   $0x80408c
  802fea:	68 4c 01 00 00       	push   $0x14c
  802fef:	68 3b 40 80 00       	push   $0x80403b
  802ff4:	e8 3c d3 ff ff       	call   800335 <_panic>
  802ff9:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	89 50 04             	mov    %edx,0x4(%eax)
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	8b 40 04             	mov    0x4(%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 0c                	je     80301b <insert_sorted_with_merge_freeList+0x2cd>
  80300f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803014:	8b 55 08             	mov    0x8(%ebp),%edx
  803017:	89 10                	mov    %edx,(%eax)
  803019:	eb 08                	jmp    803023 <insert_sorted_with_merge_freeList+0x2d5>
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	a3 38 51 80 00       	mov    %eax,0x805138
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803034:	a1 44 51 80 00       	mov    0x805144,%eax
  803039:	40                   	inc    %eax
  80303a:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80303f:	e9 53 04 00 00       	jmp    803497 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803044:	a1 38 51 80 00       	mov    0x805138,%eax
  803049:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80304c:	e9 15 04 00 00       	jmp    803466 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	8b 50 08             	mov    0x8(%eax),%edx
  80305f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803062:	8b 40 08             	mov    0x8(%eax),%eax
  803065:	39 c2                	cmp    %eax,%edx
  803067:	0f 86 f1 03 00 00    	jbe    80345e <insert_sorted_with_merge_freeList+0x710>
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	8b 50 08             	mov    0x8(%eax),%edx
  803073:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803076:	8b 40 08             	mov    0x8(%eax),%eax
  803079:	39 c2                	cmp    %eax,%edx
  80307b:	0f 83 dd 03 00 00    	jae    80345e <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 50 08             	mov    0x8(%eax),%edx
  803087:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308a:	8b 40 0c             	mov    0xc(%eax),%eax
  80308d:	01 c2                	add    %eax,%edx
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	8b 40 08             	mov    0x8(%eax),%eax
  803095:	39 c2                	cmp    %eax,%edx
  803097:	0f 85 b9 01 00 00    	jne    803256 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 50 08             	mov    0x8(%eax),%edx
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a9:	01 c2                	add    %eax,%edx
  8030ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ae:	8b 40 08             	mov    0x8(%eax),%eax
  8030b1:	39 c2                	cmp    %eax,%edx
  8030b3:	0f 85 0d 01 00 00    	jne    8031c6 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c5:	01 c2                	add    %eax,%edx
  8030c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ca:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d1:	75 17                	jne    8030ea <insert_sorted_with_merge_freeList+0x39c>
  8030d3:	83 ec 04             	sub    $0x4,%esp
  8030d6:	68 e4 40 80 00       	push   $0x8040e4
  8030db:	68 5c 01 00 00       	push   $0x15c
  8030e0:	68 3b 40 80 00       	push   $0x80403b
  8030e5:	e8 4b d2 ff ff       	call   800335 <_panic>
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 00                	mov    (%eax),%eax
  8030ef:	85 c0                	test   %eax,%eax
  8030f1:	74 10                	je     803103 <insert_sorted_with_merge_freeList+0x3b5>
  8030f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f6:	8b 00                	mov    (%eax),%eax
  8030f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fb:	8b 52 04             	mov    0x4(%edx),%edx
  8030fe:	89 50 04             	mov    %edx,0x4(%eax)
  803101:	eb 0b                	jmp    80310e <insert_sorted_with_merge_freeList+0x3c0>
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 40 04             	mov    0x4(%eax),%eax
  803109:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	8b 40 04             	mov    0x4(%eax),%eax
  803114:	85 c0                	test   %eax,%eax
  803116:	74 0f                	je     803127 <insert_sorted_with_merge_freeList+0x3d9>
  803118:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311b:	8b 40 04             	mov    0x4(%eax),%eax
  80311e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803121:	8b 12                	mov    (%edx),%edx
  803123:	89 10                	mov    %edx,(%eax)
  803125:	eb 0a                	jmp    803131 <insert_sorted_with_merge_freeList+0x3e3>
  803127:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	a3 38 51 80 00       	mov    %eax,0x805138
  803131:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803134:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803144:	a1 44 51 80 00       	mov    0x805144,%eax
  803149:	48                   	dec    %eax
  80314a:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80314f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803152:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803159:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803163:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803167:	75 17                	jne    803180 <insert_sorted_with_merge_freeList+0x432>
  803169:	83 ec 04             	sub    $0x4,%esp
  80316c:	68 18 40 80 00       	push   $0x804018
  803171:	68 5f 01 00 00       	push   $0x15f
  803176:	68 3b 40 80 00       	push   $0x80403b
  80317b:	e8 b5 d1 ff ff       	call   800335 <_panic>
  803180:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	89 10                	mov    %edx,(%eax)
  80318b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318e:	8b 00                	mov    (%eax),%eax
  803190:	85 c0                	test   %eax,%eax
  803192:	74 0d                	je     8031a1 <insert_sorted_with_merge_freeList+0x453>
  803194:	a1 48 51 80 00       	mov    0x805148,%eax
  803199:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319c:	89 50 04             	mov    %edx,0x4(%eax)
  80319f:	eb 08                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x45b>
  8031a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bb:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c0:	40                   	inc    %eax
  8031c1:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	8b 50 0c             	mov    0xc(%eax),%edx
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d2:	01 c2                	add    %eax,%edx
  8031d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d7:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f2:	75 17                	jne    80320b <insert_sorted_with_merge_freeList+0x4bd>
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	68 18 40 80 00       	push   $0x804018
  8031fc:	68 64 01 00 00       	push   $0x164
  803201:	68 3b 40 80 00       	push   $0x80403b
  803206:	e8 2a d1 ff ff       	call   800335 <_panic>
  80320b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0d                	je     80322c <insert_sorted_with_merge_freeList+0x4de>
  80321f:	a1 48 51 80 00       	mov    0x805148,%eax
  803224:	8b 55 08             	mov    0x8(%ebp),%edx
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	eb 08                	jmp    803234 <insert_sorted_with_merge_freeList+0x4e6>
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	a3 48 51 80 00       	mov    %eax,0x805148
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 54 51 80 00       	mov    0x805154,%eax
  80324b:	40                   	inc    %eax
  80324c:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803251:	e9 41 02 00 00       	jmp    803497 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	8b 50 08             	mov    0x8(%eax),%edx
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 40 0c             	mov    0xc(%eax),%eax
  803262:	01 c2                	add    %eax,%edx
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	8b 40 08             	mov    0x8(%eax),%eax
  80326a:	39 c2                	cmp    %eax,%edx
  80326c:	0f 85 7c 01 00 00    	jne    8033ee <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803272:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803276:	74 06                	je     80327e <insert_sorted_with_merge_freeList+0x530>
  803278:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327c:	75 17                	jne    803295 <insert_sorted_with_merge_freeList+0x547>
  80327e:	83 ec 04             	sub    $0x4,%esp
  803281:	68 54 40 80 00       	push   $0x804054
  803286:	68 69 01 00 00       	push   $0x169
  80328b:	68 3b 40 80 00       	push   $0x80403b
  803290:	e8 a0 d0 ff ff       	call   800335 <_panic>
  803295:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803298:	8b 50 04             	mov    0x4(%eax),%edx
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	89 50 04             	mov    %edx,0x4(%eax)
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a7:	89 10                	mov    %edx,(%eax)
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 0d                	je     8032c0 <insert_sorted_with_merge_freeList+0x572>
  8032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b6:	8b 40 04             	mov    0x4(%eax),%eax
  8032b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bc:	89 10                	mov    %edx,(%eax)
  8032be:	eb 08                	jmp    8032c8 <insert_sorted_with_merge_freeList+0x57a>
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ce:	89 50 04             	mov    %edx,0x4(%eax)
  8032d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8032d6:	40                   	inc    %eax
  8032d7:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032e8:	01 c2                	add    %eax,%edx
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032f0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f4:	75 17                	jne    80330d <insert_sorted_with_merge_freeList+0x5bf>
  8032f6:	83 ec 04             	sub    $0x4,%esp
  8032f9:	68 e4 40 80 00       	push   $0x8040e4
  8032fe:	68 6b 01 00 00       	push   $0x16b
  803303:	68 3b 40 80 00       	push   $0x80403b
  803308:	e8 28 d0 ff ff       	call   800335 <_panic>
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	74 10                	je     803326 <insert_sorted_with_merge_freeList+0x5d8>
  803316:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80331e:	8b 52 04             	mov    0x4(%edx),%edx
  803321:	89 50 04             	mov    %edx,0x4(%eax)
  803324:	eb 0b                	jmp    803331 <insert_sorted_with_merge_freeList+0x5e3>
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	8b 40 04             	mov    0x4(%eax),%eax
  80332c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803334:	8b 40 04             	mov    0x4(%eax),%eax
  803337:	85 c0                	test   %eax,%eax
  803339:	74 0f                	je     80334a <insert_sorted_with_merge_freeList+0x5fc>
  80333b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333e:	8b 40 04             	mov    0x4(%eax),%eax
  803341:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803344:	8b 12                	mov    (%edx),%edx
  803346:	89 10                	mov    %edx,(%eax)
  803348:	eb 0a                	jmp    803354 <insert_sorted_with_merge_freeList+0x606>
  80334a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	a3 38 51 80 00       	mov    %eax,0x805138
  803354:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803367:	a1 44 51 80 00       	mov    0x805144,%eax
  80336c:	48                   	dec    %eax
  80336d:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803375:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803386:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80338a:	75 17                	jne    8033a3 <insert_sorted_with_merge_freeList+0x655>
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	68 18 40 80 00       	push   $0x804018
  803394:	68 6e 01 00 00       	push   $0x16e
  803399:	68 3b 40 80 00       	push   $0x80403b
  80339e:	e8 92 cf ff ff       	call   800335 <_panic>
  8033a3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ac:	89 10                	mov    %edx,(%eax)
  8033ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	85 c0                	test   %eax,%eax
  8033b5:	74 0d                	je     8033c4 <insert_sorted_with_merge_freeList+0x676>
  8033b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8033bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033bf:	89 50 04             	mov    %edx,0x4(%eax)
  8033c2:	eb 08                	jmp    8033cc <insert_sorted_with_merge_freeList+0x67e>
  8033c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033cf:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033de:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e3:	40                   	inc    %eax
  8033e4:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8033e9:	e9 a9 00 00 00       	jmp    803497 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033f2:	74 06                	je     8033fa <insert_sorted_with_merge_freeList+0x6ac>
  8033f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f8:	75 17                	jne    803411 <insert_sorted_with_merge_freeList+0x6c3>
  8033fa:	83 ec 04             	sub    $0x4,%esp
  8033fd:	68 b0 40 80 00       	push   $0x8040b0
  803402:	68 73 01 00 00       	push   $0x173
  803407:	68 3b 40 80 00       	push   $0x80403b
  80340c:	e8 24 cf ff ff       	call   800335 <_panic>
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	8b 10                	mov    (%eax),%edx
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	89 10                	mov    %edx,(%eax)
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	8b 00                	mov    (%eax),%eax
  803420:	85 c0                	test   %eax,%eax
  803422:	74 0b                	je     80342f <insert_sorted_with_merge_freeList+0x6e1>
  803424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	8b 55 08             	mov    0x8(%ebp),%edx
  80342c:	89 50 04             	mov    %edx,0x4(%eax)
  80342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803432:	8b 55 08             	mov    0x8(%ebp),%edx
  803435:	89 10                	mov    %edx,(%eax)
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80343d:	89 50 04             	mov    %edx,0x4(%eax)
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	85 c0                	test   %eax,%eax
  803447:	75 08                	jne    803451 <insert_sorted_with_merge_freeList+0x703>
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803451:	a1 44 51 80 00       	mov    0x805144,%eax
  803456:	40                   	inc    %eax
  803457:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  80345c:	eb 39                	jmp    803497 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80345e:	a1 40 51 80 00       	mov    0x805140,%eax
  803463:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346a:	74 07                	je     803473 <insert_sorted_with_merge_freeList+0x725>
  80346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346f:	8b 00                	mov    (%eax),%eax
  803471:	eb 05                	jmp    803478 <insert_sorted_with_merge_freeList+0x72a>
  803473:	b8 00 00 00 00       	mov    $0x0,%eax
  803478:	a3 40 51 80 00       	mov    %eax,0x805140
  80347d:	a1 40 51 80 00       	mov    0x805140,%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	0f 85 c7 fb ff ff    	jne    803051 <insert_sorted_with_merge_freeList+0x303>
  80348a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348e:	0f 85 bd fb ff ff    	jne    803051 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803494:	eb 01                	jmp    803497 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803496:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803497:	90                   	nop
  803498:	c9                   	leave  
  803499:	c3                   	ret    
  80349a:	66 90                	xchg   %ax,%ax

0080349c <__udivdi3>:
  80349c:	55                   	push   %ebp
  80349d:	57                   	push   %edi
  80349e:	56                   	push   %esi
  80349f:	53                   	push   %ebx
  8034a0:	83 ec 1c             	sub    $0x1c,%esp
  8034a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034b3:	89 ca                	mov    %ecx,%edx
  8034b5:	89 f8                	mov    %edi,%eax
  8034b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034bb:	85 f6                	test   %esi,%esi
  8034bd:	75 2d                	jne    8034ec <__udivdi3+0x50>
  8034bf:	39 cf                	cmp    %ecx,%edi
  8034c1:	77 65                	ja     803528 <__udivdi3+0x8c>
  8034c3:	89 fd                	mov    %edi,%ebp
  8034c5:	85 ff                	test   %edi,%edi
  8034c7:	75 0b                	jne    8034d4 <__udivdi3+0x38>
  8034c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ce:	31 d2                	xor    %edx,%edx
  8034d0:	f7 f7                	div    %edi
  8034d2:	89 c5                	mov    %eax,%ebp
  8034d4:	31 d2                	xor    %edx,%edx
  8034d6:	89 c8                	mov    %ecx,%eax
  8034d8:	f7 f5                	div    %ebp
  8034da:	89 c1                	mov    %eax,%ecx
  8034dc:	89 d8                	mov    %ebx,%eax
  8034de:	f7 f5                	div    %ebp
  8034e0:	89 cf                	mov    %ecx,%edi
  8034e2:	89 fa                	mov    %edi,%edx
  8034e4:	83 c4 1c             	add    $0x1c,%esp
  8034e7:	5b                   	pop    %ebx
  8034e8:	5e                   	pop    %esi
  8034e9:	5f                   	pop    %edi
  8034ea:	5d                   	pop    %ebp
  8034eb:	c3                   	ret    
  8034ec:	39 ce                	cmp    %ecx,%esi
  8034ee:	77 28                	ja     803518 <__udivdi3+0x7c>
  8034f0:	0f bd fe             	bsr    %esi,%edi
  8034f3:	83 f7 1f             	xor    $0x1f,%edi
  8034f6:	75 40                	jne    803538 <__udivdi3+0x9c>
  8034f8:	39 ce                	cmp    %ecx,%esi
  8034fa:	72 0a                	jb     803506 <__udivdi3+0x6a>
  8034fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803500:	0f 87 9e 00 00 00    	ja     8035a4 <__udivdi3+0x108>
  803506:	b8 01 00 00 00       	mov    $0x1,%eax
  80350b:	89 fa                	mov    %edi,%edx
  80350d:	83 c4 1c             	add    $0x1c,%esp
  803510:	5b                   	pop    %ebx
  803511:	5e                   	pop    %esi
  803512:	5f                   	pop    %edi
  803513:	5d                   	pop    %ebp
  803514:	c3                   	ret    
  803515:	8d 76 00             	lea    0x0(%esi),%esi
  803518:	31 ff                	xor    %edi,%edi
  80351a:	31 c0                	xor    %eax,%eax
  80351c:	89 fa                	mov    %edi,%edx
  80351e:	83 c4 1c             	add    $0x1c,%esp
  803521:	5b                   	pop    %ebx
  803522:	5e                   	pop    %esi
  803523:	5f                   	pop    %edi
  803524:	5d                   	pop    %ebp
  803525:	c3                   	ret    
  803526:	66 90                	xchg   %ax,%ax
  803528:	89 d8                	mov    %ebx,%eax
  80352a:	f7 f7                	div    %edi
  80352c:	31 ff                	xor    %edi,%edi
  80352e:	89 fa                	mov    %edi,%edx
  803530:	83 c4 1c             	add    $0x1c,%esp
  803533:	5b                   	pop    %ebx
  803534:	5e                   	pop    %esi
  803535:	5f                   	pop    %edi
  803536:	5d                   	pop    %ebp
  803537:	c3                   	ret    
  803538:	bd 20 00 00 00       	mov    $0x20,%ebp
  80353d:	89 eb                	mov    %ebp,%ebx
  80353f:	29 fb                	sub    %edi,%ebx
  803541:	89 f9                	mov    %edi,%ecx
  803543:	d3 e6                	shl    %cl,%esi
  803545:	89 c5                	mov    %eax,%ebp
  803547:	88 d9                	mov    %bl,%cl
  803549:	d3 ed                	shr    %cl,%ebp
  80354b:	89 e9                	mov    %ebp,%ecx
  80354d:	09 f1                	or     %esi,%ecx
  80354f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803553:	89 f9                	mov    %edi,%ecx
  803555:	d3 e0                	shl    %cl,%eax
  803557:	89 c5                	mov    %eax,%ebp
  803559:	89 d6                	mov    %edx,%esi
  80355b:	88 d9                	mov    %bl,%cl
  80355d:	d3 ee                	shr    %cl,%esi
  80355f:	89 f9                	mov    %edi,%ecx
  803561:	d3 e2                	shl    %cl,%edx
  803563:	8b 44 24 08          	mov    0x8(%esp),%eax
  803567:	88 d9                	mov    %bl,%cl
  803569:	d3 e8                	shr    %cl,%eax
  80356b:	09 c2                	or     %eax,%edx
  80356d:	89 d0                	mov    %edx,%eax
  80356f:	89 f2                	mov    %esi,%edx
  803571:	f7 74 24 0c          	divl   0xc(%esp)
  803575:	89 d6                	mov    %edx,%esi
  803577:	89 c3                	mov    %eax,%ebx
  803579:	f7 e5                	mul    %ebp
  80357b:	39 d6                	cmp    %edx,%esi
  80357d:	72 19                	jb     803598 <__udivdi3+0xfc>
  80357f:	74 0b                	je     80358c <__udivdi3+0xf0>
  803581:	89 d8                	mov    %ebx,%eax
  803583:	31 ff                	xor    %edi,%edi
  803585:	e9 58 ff ff ff       	jmp    8034e2 <__udivdi3+0x46>
  80358a:	66 90                	xchg   %ax,%ax
  80358c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803590:	89 f9                	mov    %edi,%ecx
  803592:	d3 e2                	shl    %cl,%edx
  803594:	39 c2                	cmp    %eax,%edx
  803596:	73 e9                	jae    803581 <__udivdi3+0xe5>
  803598:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80359b:	31 ff                	xor    %edi,%edi
  80359d:	e9 40 ff ff ff       	jmp    8034e2 <__udivdi3+0x46>
  8035a2:	66 90                	xchg   %ax,%ax
  8035a4:	31 c0                	xor    %eax,%eax
  8035a6:	e9 37 ff ff ff       	jmp    8034e2 <__udivdi3+0x46>
  8035ab:	90                   	nop

008035ac <__umoddi3>:
  8035ac:	55                   	push   %ebp
  8035ad:	57                   	push   %edi
  8035ae:	56                   	push   %esi
  8035af:	53                   	push   %ebx
  8035b0:	83 ec 1c             	sub    $0x1c,%esp
  8035b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035cb:	89 f3                	mov    %esi,%ebx
  8035cd:	89 fa                	mov    %edi,%edx
  8035cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035d3:	89 34 24             	mov    %esi,(%esp)
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	75 1a                	jne    8035f4 <__umoddi3+0x48>
  8035da:	39 f7                	cmp    %esi,%edi
  8035dc:	0f 86 a2 00 00 00    	jbe    803684 <__umoddi3+0xd8>
  8035e2:	89 c8                	mov    %ecx,%eax
  8035e4:	89 f2                	mov    %esi,%edx
  8035e6:	f7 f7                	div    %edi
  8035e8:	89 d0                	mov    %edx,%eax
  8035ea:	31 d2                	xor    %edx,%edx
  8035ec:	83 c4 1c             	add    $0x1c,%esp
  8035ef:	5b                   	pop    %ebx
  8035f0:	5e                   	pop    %esi
  8035f1:	5f                   	pop    %edi
  8035f2:	5d                   	pop    %ebp
  8035f3:	c3                   	ret    
  8035f4:	39 f0                	cmp    %esi,%eax
  8035f6:	0f 87 ac 00 00 00    	ja     8036a8 <__umoddi3+0xfc>
  8035fc:	0f bd e8             	bsr    %eax,%ebp
  8035ff:	83 f5 1f             	xor    $0x1f,%ebp
  803602:	0f 84 ac 00 00 00    	je     8036b4 <__umoddi3+0x108>
  803608:	bf 20 00 00 00       	mov    $0x20,%edi
  80360d:	29 ef                	sub    %ebp,%edi
  80360f:	89 fe                	mov    %edi,%esi
  803611:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803615:	89 e9                	mov    %ebp,%ecx
  803617:	d3 e0                	shl    %cl,%eax
  803619:	89 d7                	mov    %edx,%edi
  80361b:	89 f1                	mov    %esi,%ecx
  80361d:	d3 ef                	shr    %cl,%edi
  80361f:	09 c7                	or     %eax,%edi
  803621:	89 e9                	mov    %ebp,%ecx
  803623:	d3 e2                	shl    %cl,%edx
  803625:	89 14 24             	mov    %edx,(%esp)
  803628:	89 d8                	mov    %ebx,%eax
  80362a:	d3 e0                	shl    %cl,%eax
  80362c:	89 c2                	mov    %eax,%edx
  80362e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803632:	d3 e0                	shl    %cl,%eax
  803634:	89 44 24 04          	mov    %eax,0x4(%esp)
  803638:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363c:	89 f1                	mov    %esi,%ecx
  80363e:	d3 e8                	shr    %cl,%eax
  803640:	09 d0                	or     %edx,%eax
  803642:	d3 eb                	shr    %cl,%ebx
  803644:	89 da                	mov    %ebx,%edx
  803646:	f7 f7                	div    %edi
  803648:	89 d3                	mov    %edx,%ebx
  80364a:	f7 24 24             	mull   (%esp)
  80364d:	89 c6                	mov    %eax,%esi
  80364f:	89 d1                	mov    %edx,%ecx
  803651:	39 d3                	cmp    %edx,%ebx
  803653:	0f 82 87 00 00 00    	jb     8036e0 <__umoddi3+0x134>
  803659:	0f 84 91 00 00 00    	je     8036f0 <__umoddi3+0x144>
  80365f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803663:	29 f2                	sub    %esi,%edx
  803665:	19 cb                	sbb    %ecx,%ebx
  803667:	89 d8                	mov    %ebx,%eax
  803669:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80366d:	d3 e0                	shl    %cl,%eax
  80366f:	89 e9                	mov    %ebp,%ecx
  803671:	d3 ea                	shr    %cl,%edx
  803673:	09 d0                	or     %edx,%eax
  803675:	89 e9                	mov    %ebp,%ecx
  803677:	d3 eb                	shr    %cl,%ebx
  803679:	89 da                	mov    %ebx,%edx
  80367b:	83 c4 1c             	add    $0x1c,%esp
  80367e:	5b                   	pop    %ebx
  80367f:	5e                   	pop    %esi
  803680:	5f                   	pop    %edi
  803681:	5d                   	pop    %ebp
  803682:	c3                   	ret    
  803683:	90                   	nop
  803684:	89 fd                	mov    %edi,%ebp
  803686:	85 ff                	test   %edi,%edi
  803688:	75 0b                	jne    803695 <__umoddi3+0xe9>
  80368a:	b8 01 00 00 00       	mov    $0x1,%eax
  80368f:	31 d2                	xor    %edx,%edx
  803691:	f7 f7                	div    %edi
  803693:	89 c5                	mov    %eax,%ebp
  803695:	89 f0                	mov    %esi,%eax
  803697:	31 d2                	xor    %edx,%edx
  803699:	f7 f5                	div    %ebp
  80369b:	89 c8                	mov    %ecx,%eax
  80369d:	f7 f5                	div    %ebp
  80369f:	89 d0                	mov    %edx,%eax
  8036a1:	e9 44 ff ff ff       	jmp    8035ea <__umoddi3+0x3e>
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	89 c8                	mov    %ecx,%eax
  8036aa:	89 f2                	mov    %esi,%edx
  8036ac:	83 c4 1c             	add    $0x1c,%esp
  8036af:	5b                   	pop    %ebx
  8036b0:	5e                   	pop    %esi
  8036b1:	5f                   	pop    %edi
  8036b2:	5d                   	pop    %ebp
  8036b3:	c3                   	ret    
  8036b4:	3b 04 24             	cmp    (%esp),%eax
  8036b7:	72 06                	jb     8036bf <__umoddi3+0x113>
  8036b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036bd:	77 0f                	ja     8036ce <__umoddi3+0x122>
  8036bf:	89 f2                	mov    %esi,%edx
  8036c1:	29 f9                	sub    %edi,%ecx
  8036c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036c7:	89 14 24             	mov    %edx,(%esp)
  8036ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036d2:	8b 14 24             	mov    (%esp),%edx
  8036d5:	83 c4 1c             	add    $0x1c,%esp
  8036d8:	5b                   	pop    %ebx
  8036d9:	5e                   	pop    %esi
  8036da:	5f                   	pop    %edi
  8036db:	5d                   	pop    %ebp
  8036dc:	c3                   	ret    
  8036dd:	8d 76 00             	lea    0x0(%esi),%esi
  8036e0:	2b 04 24             	sub    (%esp),%eax
  8036e3:	19 fa                	sbb    %edi,%edx
  8036e5:	89 d1                	mov    %edx,%ecx
  8036e7:	89 c6                	mov    %eax,%esi
  8036e9:	e9 71 ff ff ff       	jmp    80365f <__umoddi3+0xb3>
  8036ee:	66 90                	xchg   %ax,%ax
  8036f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036f4:	72 ea                	jb     8036e0 <__umoddi3+0x134>
  8036f6:	89 d9                	mov    %ebx,%ecx
  8036f8:	e9 62 ff ff ff       	jmp    80365f <__umoddi3+0xb3>
