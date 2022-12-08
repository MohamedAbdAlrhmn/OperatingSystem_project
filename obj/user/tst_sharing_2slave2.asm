
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
  80008d:	68 c0 35 80 00       	push   $0x8035c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 35 80 00       	push   $0x8035dc
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
  8000ab:	e8 da 19 00 00       	call   801a8a <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 c6 17 00 00       	call   80187e <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 d4 16 00 00       	call   801791 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f7 35 80 00       	push   $0x8035f7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 1d 15 00 00       	call   8015ed <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 fc 35 80 00       	push   $0x8035fc
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 dc 35 80 00       	push   $0x8035dc
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 96 16 00 00       	call   801791 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 5c 36 80 00       	push   $0x80365c
  80010c:	6a 22                	push   $0x22
  80010e:	68 dc 35 80 00       	push   $0x8035dc
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 7b 17 00 00       	call   801898 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 5c 17 00 00       	call   80187e <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 6a 16 00 00       	call   801791 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ed 36 80 00       	push   $0x8036ed
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 b3 14 00 00       	call   8015ed <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 fc 35 80 00       	push   $0x8035fc
  800151:	6a 28                	push   $0x28
  800153:	68 dc 35 80 00       	push   $0x8035dc
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 2f 16 00 00       	call   801791 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 5c 36 80 00       	push   $0x80365c
  800173:	6a 29                	push   $0x29
  800175:	68 dc 35 80 00       	push   $0x8035dc
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 14 17 00 00       	call   801898 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 f0 36 80 00       	push   $0x8036f0
  800196:	6a 2c                	push   $0x2c
  800198:	68 dc 35 80 00       	push   $0x8035dc
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
  8001b8:	68 f0 36 80 00       	push   $0x8036f0
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 dc 35 80 00       	push   $0x8035dc
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 28 37 80 00       	push   $0x803728
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 58 37 80 00       	push   $0x803758
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 dc 35 80 00       	push   $0x8035dc
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
  8001ff:	e8 6d 18 00 00       	call   801a71 <sys_getenvindex>
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
  80026a:	e8 0f 16 00 00       	call   80187e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 b4 37 80 00       	push   $0x8037b4
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
  80029a:	68 dc 37 80 00       	push   $0x8037dc
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
  8002cb:	68 04 38 80 00       	push   $0x803804
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 5c 38 80 00       	push   $0x80385c
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 b4 37 80 00       	push   $0x8037b4
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 8f 15 00 00       	call   801898 <sys_enable_interrupt>

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
  80031c:	e8 1c 17 00 00       	call   801a3d <sys_destroy_env>
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
  80032d:	e8 71 17 00 00       	call   801aa3 <sys_exit_env>
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
  800356:	68 70 38 80 00       	push   $0x803870
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 50 80 00       	mov    0x805000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 75 38 80 00       	push   $0x803875
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
  800393:	68 91 38 80 00       	push   $0x803891
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
  8003bf:	68 94 38 80 00       	push   $0x803894
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 e0 38 80 00       	push   $0x8038e0
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
  800491:	68 ec 38 80 00       	push   $0x8038ec
  800496:	6a 3a                	push   $0x3a
  800498:	68 e0 38 80 00       	push   $0x8038e0
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
  800501:	68 40 39 80 00       	push   $0x803940
  800506:	6a 44                	push   $0x44
  800508:	68 e0 38 80 00       	push   $0x8038e0
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
  80055b:	e8 70 11 00 00       	call   8016d0 <sys_cputs>
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
  8005d2:	e8 f9 10 00 00       	call   8016d0 <sys_cputs>
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
  80061c:	e8 5d 12 00 00       	call   80187e <sys_disable_interrupt>
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
  80063c:	e8 57 12 00 00       	call   801898 <sys_enable_interrupt>
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
  800686:	e8 c9 2c 00 00       	call   803354 <__udivdi3>
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
  8006d6:	e8 89 2d 00 00       	call   803464 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 b4 3b 80 00       	add    $0x803bb4,%eax
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
  800831:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
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
  800912:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 c5 3b 80 00       	push   $0x803bc5
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
  800937:	68 ce 3b 80 00       	push   $0x803bce
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
  800964:	be d1 3b 80 00       	mov    $0x803bd1,%esi
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
  80138a:	68 30 3d 80 00       	push   $0x803d30
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
  80145a:	e8 b5 03 00 00       	call   801814 <sys_allocate_chunk>
  80145f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801462:	a1 20 51 80 00       	mov    0x805120,%eax
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	50                   	push   %eax
  80146b:	e8 2a 0a 00 00       	call   801e9a <initialize_MemBlocksList>
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
  801498:	68 55 3d 80 00       	push   $0x803d55
  80149d:	6a 33                	push   $0x33
  80149f:	68 73 3d 80 00       	push   $0x803d73
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
  801517:	68 80 3d 80 00       	push   $0x803d80
  80151c:	6a 34                	push   $0x34
  80151e:	68 73 3d 80 00       	push   $0x803d73
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
  801574:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801577:	e8 f7 fd ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  80157c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801580:	75 07                	jne    801589 <malloc+0x18>
  801582:	b8 00 00 00 00       	mov    $0x0,%eax
  801587:	eb 14                	jmp    80159d <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801589:	83 ec 04             	sub    $0x4,%esp
  80158c:	68 a4 3d 80 00       	push   $0x803da4
  801591:	6a 46                	push   $0x46
  801593:	68 73 3d 80 00       	push   $0x803d73
  801598:	e8 98 ed ff ff       	call   800335 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
  8015a2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015a5:	83 ec 04             	sub    $0x4,%esp
  8015a8:	68 cc 3d 80 00       	push   $0x803dcc
  8015ad:	6a 61                	push   $0x61
  8015af:	68 73 3d 80 00       	push   $0x803d73
  8015b4:	e8 7c ed ff ff       	call   800335 <_panic>

008015b9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 18             	sub    $0x18,%esp
  8015bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c2:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c5:	e8 a9 fd ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ce:	75 07                	jne    8015d7 <smalloc+0x1e>
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	eb 14                	jmp    8015eb <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8015d7:	83 ec 04             	sub    $0x4,%esp
  8015da:	68 f0 3d 80 00       	push   $0x803df0
  8015df:	6a 76                	push   $0x76
  8015e1:	68 73 3d 80 00       	push   $0x803d73
  8015e6:	e8 4a ed ff ff       	call   800335 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f3:	e8 7b fd ff ff       	call   801373 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 18 3e 80 00       	push   $0x803e18
  801600:	68 93 00 00 00       	push   $0x93
  801605:	68 73 3d 80 00       	push   $0x803d73
  80160a:	e8 26 ed ff ff       	call   800335 <_panic>

0080160f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801615:	e8 59 fd ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80161a:	83 ec 04             	sub    $0x4,%esp
  80161d:	68 3c 3e 80 00       	push   $0x803e3c
  801622:	68 c5 00 00 00       	push   $0xc5
  801627:	68 73 3d 80 00       	push   $0x803d73
  80162c:	e8 04 ed ff ff       	call   800335 <_panic>

00801631 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	68 64 3e 80 00       	push   $0x803e64
  80163f:	68 d9 00 00 00       	push   $0xd9
  801644:	68 73 3d 80 00       	push   $0x803d73
  801649:	e8 e7 ec ff ff       	call   800335 <_panic>

0080164e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801654:	83 ec 04             	sub    $0x4,%esp
  801657:	68 88 3e 80 00       	push   $0x803e88
  80165c:	68 e4 00 00 00       	push   $0xe4
  801661:	68 73 3d 80 00       	push   $0x803d73
  801666:	e8 ca ec ff ff       	call   800335 <_panic>

0080166b <shrink>:

}
void shrink(uint32 newSize)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	68 88 3e 80 00       	push   $0x803e88
  801679:	68 e9 00 00 00       	push   $0xe9
  80167e:	68 73 3d 80 00       	push   $0x803d73
  801683:	e8 ad ec ff ff       	call   800335 <_panic>

00801688 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80168e:	83 ec 04             	sub    $0x4,%esp
  801691:	68 88 3e 80 00       	push   $0x803e88
  801696:	68 ee 00 00 00       	push   $0xee
  80169b:	68 73 3d 80 00       	push   $0x803d73
  8016a0:	e8 90 ec ff ff       	call   800335 <_panic>

008016a5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	57                   	push   %edi
  8016a9:	56                   	push   %esi
  8016aa:	53                   	push   %ebx
  8016ab:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ba:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016bd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016c0:	cd 30                	int    $0x30
  8016c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016c8:	83 c4 10             	add    $0x10,%esp
  8016cb:	5b                   	pop    %ebx
  8016cc:	5e                   	pop    %esi
  8016cd:	5f                   	pop    %edi
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    

008016d0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 04             	sub    $0x4,%esp
  8016d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016dc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	52                   	push   %edx
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	50                   	push   %eax
  8016ec:	6a 00                	push   $0x0
  8016ee:	e8 b2 ff ff ff       	call   8016a5 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	90                   	nop
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 01                	push   $0x1
  801708:	e8 98 ff ff ff       	call   8016a5 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
}
  801710:	c9                   	leave  
  801711:	c3                   	ret    

00801712 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801715:	8b 55 0c             	mov    0xc(%ebp),%edx
  801718:	8b 45 08             	mov    0x8(%ebp),%eax
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 05                	push   $0x5
  801725:	e8 7b ff ff ff       	call   8016a5 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	56                   	push   %esi
  801733:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801734:	8b 75 18             	mov    0x18(%ebp),%esi
  801737:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	51                   	push   %ecx
  801746:	52                   	push   %edx
  801747:	50                   	push   %eax
  801748:	6a 06                	push   $0x6
  80174a:	e8 56 ff ff ff       	call   8016a5 <syscall>
  80174f:	83 c4 18             	add    $0x18,%esp
}
  801752:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80175c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	52                   	push   %edx
  801769:	50                   	push   %eax
  80176a:	6a 07                	push   $0x7
  80176c:	e8 34 ff ff ff       	call   8016a5 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	ff 75 08             	pushl  0x8(%ebp)
  801785:	6a 08                	push   $0x8
  801787:	e8 19 ff ff ff       	call   8016a5 <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 09                	push   $0x9
  8017a0:	e8 00 ff ff ff       	call   8016a5 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
}
  8017a8:	c9                   	leave  
  8017a9:	c3                   	ret    

008017aa <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 0a                	push   $0xa
  8017b9:	e8 e7 fe ff ff       	call   8016a5 <syscall>
  8017be:	83 c4 18             	add    $0x18,%esp
}
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 0b                	push   $0xb
  8017d2:	e8 ce fe ff ff       	call   8016a5 <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
}
  8017da:	c9                   	leave  
  8017db:	c3                   	ret    

008017dc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	ff 75 0c             	pushl  0xc(%ebp)
  8017e8:	ff 75 08             	pushl  0x8(%ebp)
  8017eb:	6a 0f                	push   $0xf
  8017ed:	e8 b3 fe ff ff       	call   8016a5 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
	return;
  8017f5:	90                   	nop
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	ff 75 0c             	pushl  0xc(%ebp)
  801804:	ff 75 08             	pushl  0x8(%ebp)
  801807:	6a 10                	push   $0x10
  801809:	e8 97 fe ff ff       	call   8016a5 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
	return ;
  801811:	90                   	nop
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	ff 75 10             	pushl  0x10(%ebp)
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	ff 75 08             	pushl  0x8(%ebp)
  801824:	6a 11                	push   $0x11
  801826:	e8 7a fe ff ff       	call   8016a5 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
	return ;
  80182e:	90                   	nop
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 0c                	push   $0xc
  801840:	e8 60 fe ff ff       	call   8016a5 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	6a 0d                	push   $0xd
  80185a:	e8 46 fe ff ff       	call   8016a5 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 0e                	push   $0xe
  801873:	e8 2d fe ff ff       	call   8016a5 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	90                   	nop
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 13                	push   $0x13
  80188d:	e8 13 fe ff ff       	call   8016a5 <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	90                   	nop
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 14                	push   $0x14
  8018a7:	e8 f9 fd ff ff       	call   8016a5 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	90                   	nop
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018be:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	50                   	push   %eax
  8018cb:	6a 15                	push   $0x15
  8018cd:	e8 d3 fd ff ff       	call   8016a5 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	90                   	nop
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 16                	push   $0x16
  8018e7:	e8 b9 fd ff ff       	call   8016a5 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	90                   	nop
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	50                   	push   %eax
  801902:	6a 17                	push   $0x17
  801904:	e8 9c fd ff ff       	call   8016a5 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801911:	8b 55 0c             	mov    0xc(%ebp),%edx
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 1a                	push   $0x1a
  801921:	e8 7f fd ff ff       	call   8016a5 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80192e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	52                   	push   %edx
  80193b:	50                   	push   %eax
  80193c:	6a 18                	push   $0x18
  80193e:	e8 62 fd ff ff       	call   8016a5 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	90                   	nop
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80194c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	6a 19                	push   $0x19
  80195c:	e8 44 fd ff ff       	call   8016a5 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	90                   	nop
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	8b 45 10             	mov    0x10(%ebp),%eax
  801970:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801973:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801976:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	6a 00                	push   $0x0
  80197f:	51                   	push   %ecx
  801980:	52                   	push   %edx
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	50                   	push   %eax
  801985:	6a 1b                	push   $0x1b
  801987:	e8 19 fd ff ff       	call   8016a5 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801994:	8b 55 0c             	mov    0xc(%ebp),%edx
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	52                   	push   %edx
  8019a1:	50                   	push   %eax
  8019a2:	6a 1c                	push   $0x1c
  8019a4:	e8 fc fc ff ff       	call   8016a5 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	51                   	push   %ecx
  8019bf:	52                   	push   %edx
  8019c0:	50                   	push   %eax
  8019c1:	6a 1d                	push   $0x1d
  8019c3:	e8 dd fc ff ff       	call   8016a5 <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	52                   	push   %edx
  8019dd:	50                   	push   %eax
  8019de:	6a 1e                	push   $0x1e
  8019e0:	e8 c0 fc ff ff       	call   8016a5 <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 1f                	push   $0x1f
  8019f9:	e8 a7 fc ff ff       	call   8016a5 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	ff 75 14             	pushl  0x14(%ebp)
  801a0e:	ff 75 10             	pushl  0x10(%ebp)
  801a11:	ff 75 0c             	pushl  0xc(%ebp)
  801a14:	50                   	push   %eax
  801a15:	6a 20                	push   $0x20
  801a17:	e8 89 fc ff ff       	call   8016a5 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	50                   	push   %eax
  801a30:	6a 21                	push   $0x21
  801a32:	e8 6e fc ff ff       	call   8016a5 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	50                   	push   %eax
  801a4c:	6a 22                	push   $0x22
  801a4e:	e8 52 fc ff ff       	call   8016a5 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 02                	push   $0x2
  801a67:	e8 39 fc ff ff       	call   8016a5 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 03                	push   $0x3
  801a80:	e8 20 fc ff ff       	call   8016a5 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 04                	push   $0x4
  801a99:	e8 07 fc ff ff       	call   8016a5 <syscall>
  801a9e:	83 c4 18             	add    $0x18,%esp
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <sys_exit_env>:


void sys_exit_env(void)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 23                	push   $0x23
  801ab2:	e8 ee fb ff ff       	call   8016a5 <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	90                   	nop
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ac3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ac6:	8d 50 04             	lea    0x4(%eax),%edx
  801ac9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 24                	push   $0x24
  801ad6:	e8 ca fb ff ff       	call   8016a5 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
	return result;
  801ade:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ae1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ae4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ae7:	89 01                	mov    %eax,(%ecx)
  801ae9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	c9                   	leave  
  801af0:	c2 04 00             	ret    $0x4

00801af3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	ff 75 10             	pushl  0x10(%ebp)
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	ff 75 08             	pushl  0x8(%ebp)
  801b03:	6a 12                	push   $0x12
  801b05:	e8 9b fb ff ff       	call   8016a5 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0d:	90                   	nop
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 25                	push   $0x25
  801b1f:	e8 81 fb ff ff       	call   8016a5 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	83 ec 04             	sub    $0x4,%esp
  801b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b32:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b35:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	50                   	push   %eax
  801b42:	6a 26                	push   $0x26
  801b44:	e8 5c fb ff ff       	call   8016a5 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
	return ;
  801b4c:	90                   	nop
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <rsttst>:
void rsttst()
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 28                	push   $0x28
  801b5e:	e8 42 fb ff ff       	call   8016a5 <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
	return ;
  801b66:	90                   	nop
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 04             	sub    $0x4,%esp
  801b6f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b72:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b75:	8b 55 18             	mov    0x18(%ebp),%edx
  801b78:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	ff 75 10             	pushl  0x10(%ebp)
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	6a 27                	push   $0x27
  801b89:	e8 17 fb ff ff       	call   8016a5 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b91:	90                   	nop
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <chktst>:
void chktst(uint32 n)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	ff 75 08             	pushl  0x8(%ebp)
  801ba2:	6a 29                	push   $0x29
  801ba4:	e8 fc fa ff ff       	call   8016a5 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
	return ;
  801bac:	90                   	nop
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <inctst>:

void inctst()
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 2a                	push   $0x2a
  801bbe:	e8 e2 fa ff ff       	call   8016a5 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc6:	90                   	nop
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <gettst>:
uint32 gettst()
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 2b                	push   $0x2b
  801bd8:	e8 c8 fa ff ff       	call   8016a5 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 2c                	push   $0x2c
  801bf4:	e8 ac fa ff ff       	call   8016a5 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
  801bfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bff:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c03:	75 07                	jne    801c0c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c05:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0a:	eb 05                	jmp    801c11 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 2c                	push   $0x2c
  801c25:	e8 7b fa ff ff       	call   8016a5 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
  801c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c30:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c34:	75 07                	jne    801c3d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c36:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3b:	eb 05                	jmp    801c42 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c42:	c9                   	leave  
  801c43:	c3                   	ret    

00801c44 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 2c                	push   $0x2c
  801c56:	e8 4a fa ff ff       	call   8016a5 <syscall>
  801c5b:	83 c4 18             	add    $0x18,%esp
  801c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c61:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c65:	75 07                	jne    801c6e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c67:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6c:	eb 05                	jmp    801c73 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 2c                	push   $0x2c
  801c87:	e8 19 fa ff ff       	call   8016a5 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
  801c8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c92:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c96:	75 07                	jne    801c9f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c98:	b8 01 00 00 00       	mov    $0x1,%eax
  801c9d:	eb 05                	jmp    801ca4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	ff 75 08             	pushl  0x8(%ebp)
  801cb4:	6a 2d                	push   $0x2d
  801cb6:	e8 ea f9 ff ff       	call   8016a5 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbe:	90                   	nop
}
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cc5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	53                   	push   %ebx
  801cd4:	51                   	push   %ecx
  801cd5:	52                   	push   %edx
  801cd6:	50                   	push   %eax
  801cd7:	6a 2e                	push   $0x2e
  801cd9:	e8 c7 f9 ff ff       	call   8016a5 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
}
  801ce1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ce9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cec:	8b 45 08             	mov    0x8(%ebp),%eax
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	52                   	push   %edx
  801cf6:	50                   	push   %eax
  801cf7:	6a 2f                	push   $0x2f
  801cf9:	e8 a7 f9 ff ff       	call   8016a5 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d09:	83 ec 0c             	sub    $0xc,%esp
  801d0c:	68 98 3e 80 00       	push   $0x803e98
  801d11:	e8 d3 e8 ff ff       	call   8005e9 <cprintf>
  801d16:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d20:	83 ec 0c             	sub    $0xc,%esp
  801d23:	68 c4 3e 80 00       	push   $0x803ec4
  801d28:	e8 bc e8 ff ff       	call   8005e9 <cprintf>
  801d2d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d30:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d34:	a1 38 51 80 00       	mov    0x805138,%eax
  801d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d3c:	eb 56                	jmp    801d94 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d42:	74 1c                	je     801d60 <print_mem_block_lists+0x5d>
  801d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d47:	8b 50 08             	mov    0x8(%eax),%edx
  801d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4d:	8b 48 08             	mov    0x8(%eax),%ecx
  801d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d53:	8b 40 0c             	mov    0xc(%eax),%eax
  801d56:	01 c8                	add    %ecx,%eax
  801d58:	39 c2                	cmp    %eax,%edx
  801d5a:	73 04                	jae    801d60 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d5c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d63:	8b 50 08             	mov    0x8(%eax),%edx
  801d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d69:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6c:	01 c2                	add    %eax,%edx
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	8b 40 08             	mov    0x8(%eax),%eax
  801d74:	83 ec 04             	sub    $0x4,%esp
  801d77:	52                   	push   %edx
  801d78:	50                   	push   %eax
  801d79:	68 d9 3e 80 00       	push   $0x803ed9
  801d7e:	e8 66 e8 ff ff       	call   8005e9 <cprintf>
  801d83:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d8c:	a1 40 51 80 00       	mov    0x805140,%eax
  801d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d98:	74 07                	je     801da1 <print_mem_block_lists+0x9e>
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	8b 00                	mov    (%eax),%eax
  801d9f:	eb 05                	jmp    801da6 <print_mem_block_lists+0xa3>
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
  801da6:	a3 40 51 80 00       	mov    %eax,0x805140
  801dab:	a1 40 51 80 00       	mov    0x805140,%eax
  801db0:	85 c0                	test   %eax,%eax
  801db2:	75 8a                	jne    801d3e <print_mem_block_lists+0x3b>
  801db4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db8:	75 84                	jne    801d3e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dba:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801dbe:	75 10                	jne    801dd0 <print_mem_block_lists+0xcd>
  801dc0:	83 ec 0c             	sub    $0xc,%esp
  801dc3:	68 e8 3e 80 00       	push   $0x803ee8
  801dc8:	e8 1c e8 ff ff       	call   8005e9 <cprintf>
  801dcd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dd0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dd7:	83 ec 0c             	sub    $0xc,%esp
  801dda:	68 0c 3f 80 00       	push   $0x803f0c
  801ddf:	e8 05 e8 ff ff       	call   8005e9 <cprintf>
  801de4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801de7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801deb:	a1 40 50 80 00       	mov    0x805040,%eax
  801df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df3:	eb 56                	jmp    801e4b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801df5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801df9:	74 1c                	je     801e17 <print_mem_block_lists+0x114>
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	8b 50 08             	mov    0x8(%eax),%edx
  801e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e04:	8b 48 08             	mov    0x8(%eax),%ecx
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	39 c2                	cmp    %eax,%edx
  801e11:	73 04                	jae    801e17 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e13:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1a:	8b 50 08             	mov    0x8(%eax),%edx
  801e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e20:	8b 40 0c             	mov    0xc(%eax),%eax
  801e23:	01 c2                	add    %eax,%edx
  801e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e28:	8b 40 08             	mov    0x8(%eax),%eax
  801e2b:	83 ec 04             	sub    $0x4,%esp
  801e2e:	52                   	push   %edx
  801e2f:	50                   	push   %eax
  801e30:	68 d9 3e 80 00       	push   $0x803ed9
  801e35:	e8 af e7 ff ff       	call   8005e9 <cprintf>
  801e3a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e43:	a1 48 50 80 00       	mov    0x805048,%eax
  801e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e4f:	74 07                	je     801e58 <print_mem_block_lists+0x155>
  801e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e54:	8b 00                	mov    (%eax),%eax
  801e56:	eb 05                	jmp    801e5d <print_mem_block_lists+0x15a>
  801e58:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5d:	a3 48 50 80 00       	mov    %eax,0x805048
  801e62:	a1 48 50 80 00       	mov    0x805048,%eax
  801e67:	85 c0                	test   %eax,%eax
  801e69:	75 8a                	jne    801df5 <print_mem_block_lists+0xf2>
  801e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6f:	75 84                	jne    801df5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e71:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e75:	75 10                	jne    801e87 <print_mem_block_lists+0x184>
  801e77:	83 ec 0c             	sub    $0xc,%esp
  801e7a:	68 24 3f 80 00       	push   $0x803f24
  801e7f:	e8 65 e7 ff ff       	call   8005e9 <cprintf>
  801e84:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	68 98 3e 80 00       	push   $0x803e98
  801e8f:	e8 55 e7 ff ff       	call   8005e9 <cprintf>
  801e94:	83 c4 10             	add    $0x10,%esp

}
  801e97:	90                   	nop
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ea0:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801ea7:	00 00 00 
  801eaa:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801eb1:	00 00 00 
  801eb4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801ebb:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ebe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ec5:	e9 9e 00 00 00       	jmp    801f68 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801eca:	a1 50 50 80 00       	mov    0x805050,%eax
  801ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed2:	c1 e2 04             	shl    $0x4,%edx
  801ed5:	01 d0                	add    %edx,%eax
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	75 14                	jne    801eef <initialize_MemBlocksList+0x55>
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	68 4c 3f 80 00       	push   $0x803f4c
  801ee3:	6a 46                	push   $0x46
  801ee5:	68 6f 3f 80 00       	push   $0x803f6f
  801eea:	e8 46 e4 ff ff       	call   800335 <_panic>
  801eef:	a1 50 50 80 00       	mov    0x805050,%eax
  801ef4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef7:	c1 e2 04             	shl    $0x4,%edx
  801efa:	01 d0                	add    %edx,%eax
  801efc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f02:	89 10                	mov    %edx,(%eax)
  801f04:	8b 00                	mov    (%eax),%eax
  801f06:	85 c0                	test   %eax,%eax
  801f08:	74 18                	je     801f22 <initialize_MemBlocksList+0x88>
  801f0a:	a1 48 51 80 00       	mov    0x805148,%eax
  801f0f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801f15:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f18:	c1 e1 04             	shl    $0x4,%ecx
  801f1b:	01 ca                	add    %ecx,%edx
  801f1d:	89 50 04             	mov    %edx,0x4(%eax)
  801f20:	eb 12                	jmp    801f34 <initialize_MemBlocksList+0x9a>
  801f22:	a1 50 50 80 00       	mov    0x805050,%eax
  801f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2a:	c1 e2 04             	shl    $0x4,%edx
  801f2d:	01 d0                	add    %edx,%eax
  801f2f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801f34:	a1 50 50 80 00       	mov    0x805050,%eax
  801f39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3c:	c1 e2 04             	shl    $0x4,%edx
  801f3f:	01 d0                	add    %edx,%eax
  801f41:	a3 48 51 80 00       	mov    %eax,0x805148
  801f46:	a1 50 50 80 00       	mov    0x805050,%eax
  801f4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4e:	c1 e2 04             	shl    $0x4,%edx
  801f51:	01 d0                	add    %edx,%eax
  801f53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f5a:	a1 54 51 80 00       	mov    0x805154,%eax
  801f5f:	40                   	inc    %eax
  801f60:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f65:	ff 45 f4             	incl   -0xc(%ebp)
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f6e:	0f 82 56 ff ff ff    	jb     801eca <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f74:	90                   	nop
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f80:	8b 00                	mov    (%eax),%eax
  801f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f85:	eb 19                	jmp    801fa0 <find_block+0x29>
	{
		if(va==point->sva)
  801f87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f8a:	8b 40 08             	mov    0x8(%eax),%eax
  801f8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f90:	75 05                	jne    801f97 <find_block+0x20>
		   return point;
  801f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f95:	eb 36                	jmp    801fcd <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8b 40 08             	mov    0x8(%eax),%eax
  801f9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fa0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fa4:	74 07                	je     801fad <find_block+0x36>
  801fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fa9:	8b 00                	mov    (%eax),%eax
  801fab:	eb 05                	jmp    801fb2 <find_block+0x3b>
  801fad:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  801fb5:	89 42 08             	mov    %eax,0x8(%edx)
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	8b 40 08             	mov    0x8(%eax),%eax
  801fbe:	85 c0                	test   %eax,%eax
  801fc0:	75 c5                	jne    801f87 <find_block+0x10>
  801fc2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fc6:	75 bf                	jne    801f87 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcd:	c9                   	leave  
  801fce:	c3                   	ret    

00801fcf <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fd5:	a1 40 50 80 00       	mov    0x805040,%eax
  801fda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fdd:	a1 44 50 80 00       	mov    0x805044,%eax
  801fe2:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801feb:	74 24                	je     802011 <insert_sorted_allocList+0x42>
  801fed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff0:	8b 50 08             	mov    0x8(%eax),%edx
  801ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff6:	8b 40 08             	mov    0x8(%eax),%eax
  801ff9:	39 c2                	cmp    %eax,%edx
  801ffb:	76 14                	jbe    802011 <insert_sorted_allocList+0x42>
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	8b 50 08             	mov    0x8(%eax),%edx
  802003:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802006:	8b 40 08             	mov    0x8(%eax),%eax
  802009:	39 c2                	cmp    %eax,%edx
  80200b:	0f 82 60 01 00 00    	jb     802171 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802011:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802015:	75 65                	jne    80207c <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802017:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80201b:	75 14                	jne    802031 <insert_sorted_allocList+0x62>
  80201d:	83 ec 04             	sub    $0x4,%esp
  802020:	68 4c 3f 80 00       	push   $0x803f4c
  802025:	6a 6b                	push   $0x6b
  802027:	68 6f 3f 80 00       	push   $0x803f6f
  80202c:	e8 04 e3 ff ff       	call   800335 <_panic>
  802031:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	89 10                	mov    %edx,(%eax)
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	8b 00                	mov    (%eax),%eax
  802041:	85 c0                	test   %eax,%eax
  802043:	74 0d                	je     802052 <insert_sorted_allocList+0x83>
  802045:	a1 40 50 80 00       	mov    0x805040,%eax
  80204a:	8b 55 08             	mov    0x8(%ebp),%edx
  80204d:	89 50 04             	mov    %edx,0x4(%eax)
  802050:	eb 08                	jmp    80205a <insert_sorted_allocList+0x8b>
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	a3 44 50 80 00       	mov    %eax,0x805044
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	a3 40 50 80 00       	mov    %eax,0x805040
  802062:	8b 45 08             	mov    0x8(%ebp),%eax
  802065:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80206c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802071:	40                   	inc    %eax
  802072:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802077:	e9 dc 01 00 00       	jmp    802258 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	8b 50 08             	mov    0x8(%eax),%edx
  802082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802085:	8b 40 08             	mov    0x8(%eax),%eax
  802088:	39 c2                	cmp    %eax,%edx
  80208a:	77 6c                	ja     8020f8 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80208c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802090:	74 06                	je     802098 <insert_sorted_allocList+0xc9>
  802092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802096:	75 14                	jne    8020ac <insert_sorted_allocList+0xdd>
  802098:	83 ec 04             	sub    $0x4,%esp
  80209b:	68 88 3f 80 00       	push   $0x803f88
  8020a0:	6a 6f                	push   $0x6f
  8020a2:	68 6f 3f 80 00       	push   $0x803f6f
  8020a7:	e8 89 e2 ff ff       	call   800335 <_panic>
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	8b 50 04             	mov    0x4(%eax),%edx
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	89 50 04             	mov    %edx,0x4(%eax)
  8020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020be:	89 10                	mov    %edx,(%eax)
  8020c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c3:	8b 40 04             	mov    0x4(%eax),%eax
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	74 0d                	je     8020d7 <insert_sorted_allocList+0x108>
  8020ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cd:	8b 40 04             	mov    0x4(%eax),%eax
  8020d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d3:	89 10                	mov    %edx,(%eax)
  8020d5:	eb 08                	jmp    8020df <insert_sorted_allocList+0x110>
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	a3 40 50 80 00       	mov    %eax,0x805040
  8020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e5:	89 50 04             	mov    %edx,0x4(%eax)
  8020e8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020ed:	40                   	inc    %eax
  8020ee:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020f3:	e9 60 01 00 00       	jmp    802258 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8b 50 08             	mov    0x8(%eax),%edx
  8020fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802101:	8b 40 08             	mov    0x8(%eax),%eax
  802104:	39 c2                	cmp    %eax,%edx
  802106:	0f 82 4c 01 00 00    	jb     802258 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80210c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802110:	75 14                	jne    802126 <insert_sorted_allocList+0x157>
  802112:	83 ec 04             	sub    $0x4,%esp
  802115:	68 c0 3f 80 00       	push   $0x803fc0
  80211a:	6a 73                	push   $0x73
  80211c:	68 6f 3f 80 00       	push   $0x803f6f
  802121:	e8 0f e2 ff ff       	call   800335 <_panic>
  802126:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	89 50 04             	mov    %edx,0x4(%eax)
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	8b 40 04             	mov    0x4(%eax),%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	74 0c                	je     802148 <insert_sorted_allocList+0x179>
  80213c:	a1 44 50 80 00       	mov    0x805044,%eax
  802141:	8b 55 08             	mov    0x8(%ebp),%edx
  802144:	89 10                	mov    %edx,(%eax)
  802146:	eb 08                	jmp    802150 <insert_sorted_allocList+0x181>
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	a3 40 50 80 00       	mov    %eax,0x805040
  802150:	8b 45 08             	mov    0x8(%ebp),%eax
  802153:	a3 44 50 80 00       	mov    %eax,0x805044
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802161:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802166:	40                   	inc    %eax
  802167:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80216c:	e9 e7 00 00 00       	jmp    802258 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802174:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802177:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80217e:	a1 40 50 80 00       	mov    0x805040,%eax
  802183:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802186:	e9 9d 00 00 00       	jmp    802228 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	8b 00                	mov    (%eax),%eax
  802190:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8b 50 08             	mov    0x8(%eax),%edx
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 40 08             	mov    0x8(%eax),%eax
  80219f:	39 c2                	cmp    %eax,%edx
  8021a1:	76 7d                	jbe    802220 <insert_sorted_allocList+0x251>
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8b 50 08             	mov    0x8(%eax),%edx
  8021a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ac:	8b 40 08             	mov    0x8(%eax),%eax
  8021af:	39 c2                	cmp    %eax,%edx
  8021b1:	73 6d                	jae    802220 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b7:	74 06                	je     8021bf <insert_sorted_allocList+0x1f0>
  8021b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021bd:	75 14                	jne    8021d3 <insert_sorted_allocList+0x204>
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 e4 3f 80 00       	push   $0x803fe4
  8021c7:	6a 7f                	push   $0x7f
  8021c9:	68 6f 3f 80 00       	push   $0x803f6f
  8021ce:	e8 62 e1 ff ff       	call   800335 <_panic>
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	8b 10                	mov    (%eax),%edx
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	89 10                	mov    %edx,(%eax)
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	74 0b                	je     8021f1 <insert_sorted_allocList+0x222>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 00                	mov    (%eax),%eax
  8021eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ee:	89 50 04             	mov    %edx,0x4(%eax)
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f7:	89 10                	mov    %edx,(%eax)
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ff:	89 50 04             	mov    %edx,0x4(%eax)
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	85 c0                	test   %eax,%eax
  802209:	75 08                	jne    802213 <insert_sorted_allocList+0x244>
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	a3 44 50 80 00       	mov    %eax,0x805044
  802213:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802218:	40                   	inc    %eax
  802219:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80221e:	eb 39                	jmp    802259 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802220:	a1 48 50 80 00       	mov    0x805048,%eax
  802225:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802228:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222c:	74 07                	je     802235 <insert_sorted_allocList+0x266>
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 00                	mov    (%eax),%eax
  802233:	eb 05                	jmp    80223a <insert_sorted_allocList+0x26b>
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
  80223a:	a3 48 50 80 00       	mov    %eax,0x805048
  80223f:	a1 48 50 80 00       	mov    0x805048,%eax
  802244:	85 c0                	test   %eax,%eax
  802246:	0f 85 3f ff ff ff    	jne    80218b <insert_sorted_allocList+0x1bc>
  80224c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802250:	0f 85 35 ff ff ff    	jne    80218b <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802256:	eb 01                	jmp    802259 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802258:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802259:	90                   	nop
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802262:	a1 38 51 80 00       	mov    0x805138,%eax
  802267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226a:	e9 85 01 00 00       	jmp    8023f4 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 0c             	mov    0xc(%eax),%eax
  802275:	3b 45 08             	cmp    0x8(%ebp),%eax
  802278:	0f 82 6e 01 00 00    	jb     8023ec <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 40 0c             	mov    0xc(%eax),%eax
  802284:	3b 45 08             	cmp    0x8(%ebp),%eax
  802287:	0f 85 8a 00 00 00    	jne    802317 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80228d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802291:	75 17                	jne    8022aa <alloc_block_FF+0x4e>
  802293:	83 ec 04             	sub    $0x4,%esp
  802296:	68 18 40 80 00       	push   $0x804018
  80229b:	68 93 00 00 00       	push   $0x93
  8022a0:	68 6f 3f 80 00       	push   $0x803f6f
  8022a5:	e8 8b e0 ff ff       	call   800335 <_panic>
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 00                	mov    (%eax),%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	74 10                	je     8022c3 <alloc_block_FF+0x67>
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	8b 52 04             	mov    0x4(%edx),%edx
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	eb 0b                	jmp    8022ce <alloc_block_FF+0x72>
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 04             	mov    0x4(%eax),%eax
  8022c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 40 04             	mov    0x4(%eax),%eax
  8022d4:	85 c0                	test   %eax,%eax
  8022d6:	74 0f                	je     8022e7 <alloc_block_FF+0x8b>
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e1:	8b 12                	mov    (%edx),%edx
  8022e3:	89 10                	mov    %edx,(%eax)
  8022e5:	eb 0a                	jmp    8022f1 <alloc_block_FF+0x95>
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 00                	mov    (%eax),%eax
  8022ec:	a3 38 51 80 00       	mov    %eax,0x805138
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802304:	a1 44 51 80 00       	mov    0x805144,%eax
  802309:	48                   	dec    %eax
  80230a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	e9 10 01 00 00       	jmp    802427 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 40 0c             	mov    0xc(%eax),%eax
  80231d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802320:	0f 86 c6 00 00 00    	jbe    8023ec <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802326:	a1 48 51 80 00       	mov    0x805148,%eax
  80232b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 50 08             	mov    0x8(%eax),%edx
  802334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802337:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233d:	8b 55 08             	mov    0x8(%ebp),%edx
  802340:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802343:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802347:	75 17                	jne    802360 <alloc_block_FF+0x104>
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	68 18 40 80 00       	push   $0x804018
  802351:	68 9b 00 00 00       	push   $0x9b
  802356:	68 6f 3f 80 00       	push   $0x803f6f
  80235b:	e8 d5 df ff ff       	call   800335 <_panic>
  802360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	74 10                	je     802379 <alloc_block_FF+0x11d>
  802369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236c:	8b 00                	mov    (%eax),%eax
  80236e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802371:	8b 52 04             	mov    0x4(%edx),%edx
  802374:	89 50 04             	mov    %edx,0x4(%eax)
  802377:	eb 0b                	jmp    802384 <alloc_block_FF+0x128>
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	8b 40 04             	mov    0x4(%eax),%eax
  80237f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802387:	8b 40 04             	mov    0x4(%eax),%eax
  80238a:	85 c0                	test   %eax,%eax
  80238c:	74 0f                	je     80239d <alloc_block_FF+0x141>
  80238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802391:	8b 40 04             	mov    0x4(%eax),%eax
  802394:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802397:	8b 12                	mov    (%edx),%edx
  802399:	89 10                	mov    %edx,(%eax)
  80239b:	eb 0a                	jmp    8023a7 <alloc_block_FF+0x14b>
  80239d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	a3 48 51 80 00       	mov    %eax,0x805148
  8023a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8023bf:	48                   	dec    %eax
  8023c0:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 50 08             	mov    0x8(%eax),%edx
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	01 c2                	add    %eax,%edx
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dc:	2b 45 08             	sub    0x8(%ebp),%eax
  8023df:	89 c2                	mov    %eax,%edx
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ea:	eb 3b                	jmp    802427 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023ec:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f8:	74 07                	je     802401 <alloc_block_FF+0x1a5>
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 00                	mov    (%eax),%eax
  8023ff:	eb 05                	jmp    802406 <alloc_block_FF+0x1aa>
  802401:	b8 00 00 00 00       	mov    $0x0,%eax
  802406:	a3 40 51 80 00       	mov    %eax,0x805140
  80240b:	a1 40 51 80 00       	mov    0x805140,%eax
  802410:	85 c0                	test   %eax,%eax
  802412:	0f 85 57 fe ff ff    	jne    80226f <alloc_block_FF+0x13>
  802418:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241c:	0f 85 4d fe ff ff    	jne    80226f <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802422:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80242f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802436:	a1 38 51 80 00       	mov    0x805138,%eax
  80243b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243e:	e9 df 00 00 00       	jmp    802522 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244c:	0f 82 c8 00 00 00    	jb     80251a <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 40 0c             	mov    0xc(%eax),%eax
  802458:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245b:	0f 85 8a 00 00 00    	jne    8024eb <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802465:	75 17                	jne    80247e <alloc_block_BF+0x55>
  802467:	83 ec 04             	sub    $0x4,%esp
  80246a:	68 18 40 80 00       	push   $0x804018
  80246f:	68 b7 00 00 00       	push   $0xb7
  802474:	68 6f 3f 80 00       	push   $0x803f6f
  802479:	e8 b7 de ff ff       	call   800335 <_panic>
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 00                	mov    (%eax),%eax
  802483:	85 c0                	test   %eax,%eax
  802485:	74 10                	je     802497 <alloc_block_BF+0x6e>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248f:	8b 52 04             	mov    0x4(%edx),%edx
  802492:	89 50 04             	mov    %edx,0x4(%eax)
  802495:	eb 0b                	jmp    8024a2 <alloc_block_BF+0x79>
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	8b 40 04             	mov    0x4(%eax),%eax
  80249d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 40 04             	mov    0x4(%eax),%eax
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	74 0f                	je     8024bb <alloc_block_BF+0x92>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 04             	mov    0x4(%eax),%eax
  8024b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b5:	8b 12                	mov    (%edx),%edx
  8024b7:	89 10                	mov    %edx,(%eax)
  8024b9:	eb 0a                	jmp    8024c5 <alloc_block_BF+0x9c>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 00                	mov    (%eax),%eax
  8024c0:	a3 38 51 80 00       	mov    %eax,0x805138
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8024dd:	48                   	dec    %eax
  8024de:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	e9 4d 01 00 00       	jmp    802638 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f4:	76 24                	jbe    80251a <alloc_block_BF+0xf1>
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024ff:	73 19                	jae    80251a <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802501:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	8b 40 0c             	mov    0xc(%eax),%eax
  80250e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 40 08             	mov    0x8(%eax),%eax
  802517:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80251a:	a1 40 51 80 00       	mov    0x805140,%eax
  80251f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802526:	74 07                	je     80252f <alloc_block_BF+0x106>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	eb 05                	jmp    802534 <alloc_block_BF+0x10b>
  80252f:	b8 00 00 00 00       	mov    $0x0,%eax
  802534:	a3 40 51 80 00       	mov    %eax,0x805140
  802539:	a1 40 51 80 00       	mov    0x805140,%eax
  80253e:	85 c0                	test   %eax,%eax
  802540:	0f 85 fd fe ff ff    	jne    802443 <alloc_block_BF+0x1a>
  802546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254a:	0f 85 f3 fe ff ff    	jne    802443 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802550:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802554:	0f 84 d9 00 00 00    	je     802633 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80255a:	a1 48 51 80 00       	mov    0x805148,%eax
  80255f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802562:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802565:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802568:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80256b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256e:	8b 55 08             	mov    0x8(%ebp),%edx
  802571:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802574:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802578:	75 17                	jne    802591 <alloc_block_BF+0x168>
  80257a:	83 ec 04             	sub    $0x4,%esp
  80257d:	68 18 40 80 00       	push   $0x804018
  802582:	68 c7 00 00 00       	push   $0xc7
  802587:	68 6f 3f 80 00       	push   $0x803f6f
  80258c:	e8 a4 dd ff ff       	call   800335 <_panic>
  802591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802594:	8b 00                	mov    (%eax),%eax
  802596:	85 c0                	test   %eax,%eax
  802598:	74 10                	je     8025aa <alloc_block_BF+0x181>
  80259a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259d:	8b 00                	mov    (%eax),%eax
  80259f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a2:	8b 52 04             	mov    0x4(%edx),%edx
  8025a5:	89 50 04             	mov    %edx,0x4(%eax)
  8025a8:	eb 0b                	jmp    8025b5 <alloc_block_BF+0x18c>
  8025aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ad:	8b 40 04             	mov    0x4(%eax),%eax
  8025b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b8:	8b 40 04             	mov    0x4(%eax),%eax
  8025bb:	85 c0                	test   %eax,%eax
  8025bd:	74 0f                	je     8025ce <alloc_block_BF+0x1a5>
  8025bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c2:	8b 40 04             	mov    0x4(%eax),%eax
  8025c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025c8:	8b 12                	mov    (%edx),%edx
  8025ca:	89 10                	mov    %edx,(%eax)
  8025cc:	eb 0a                	jmp    8025d8 <alloc_block_BF+0x1af>
  8025ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d1:	8b 00                	mov    (%eax),%eax
  8025d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8025d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8025f0:	48                   	dec    %eax
  8025f1:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025f6:	83 ec 08             	sub    $0x8,%esp
  8025f9:	ff 75 ec             	pushl  -0x14(%ebp)
  8025fc:	68 38 51 80 00       	push   $0x805138
  802601:	e8 71 f9 ff ff       	call   801f77 <find_block>
  802606:	83 c4 10             	add    $0x10,%esp
  802609:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80260c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260f:	8b 50 08             	mov    0x8(%eax),%edx
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	01 c2                	add    %eax,%edx
  802617:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261a:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80261d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802620:	8b 40 0c             	mov    0xc(%eax),%eax
  802623:	2b 45 08             	sub    0x8(%ebp),%eax
  802626:	89 c2                	mov    %eax,%edx
  802628:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262b:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80262e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802631:	eb 05                	jmp    802638 <alloc_block_BF+0x20f>
	}
	return NULL;
  802633:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802638:	c9                   	leave  
  802639:	c3                   	ret    

0080263a <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80263a:	55                   	push   %ebp
  80263b:	89 e5                	mov    %esp,%ebp
  80263d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802640:	a1 28 50 80 00       	mov    0x805028,%eax
  802645:	85 c0                	test   %eax,%eax
  802647:	0f 85 de 01 00 00    	jne    80282b <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80264d:	a1 38 51 80 00       	mov    0x805138,%eax
  802652:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802655:	e9 9e 01 00 00       	jmp    8027f8 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	3b 45 08             	cmp    0x8(%ebp),%eax
  802663:	0f 82 87 01 00 00    	jb     8027f0 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 0c             	mov    0xc(%eax),%eax
  80266f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802672:	0f 85 95 00 00 00    	jne    80270d <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	75 17                	jne    802695 <alloc_block_NF+0x5b>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 18 40 80 00       	push   $0x804018
  802686:	68 e0 00 00 00       	push   $0xe0
  80268b:	68 6f 3f 80 00       	push   $0x803f6f
  802690:	e8 a0 dc ff ff       	call   800335 <_panic>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	74 10                	je     8026ae <alloc_block_NF+0x74>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a6:	8b 52 04             	mov    0x4(%edx),%edx
  8026a9:	89 50 04             	mov    %edx,0x4(%eax)
  8026ac:	eb 0b                	jmp    8026b9 <alloc_block_NF+0x7f>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 40 04             	mov    0x4(%eax),%eax
  8026b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 0f                	je     8026d2 <alloc_block_NF+0x98>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cc:	8b 12                	mov    (%edx),%edx
  8026ce:	89 10                	mov    %edx,(%eax)
  8026d0:	eb 0a                	jmp    8026dc <alloc_block_NF+0xa2>
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 00                	mov    (%eax),%eax
  8026d7:	a3 38 51 80 00       	mov    %eax,0x805138
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8026f4:	48                   	dec    %eax
  8026f5:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	8b 40 08             	mov    0x8(%eax),%eax
  802700:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	e9 f8 04 00 00       	jmp    802c05 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 40 0c             	mov    0xc(%eax),%eax
  802713:	3b 45 08             	cmp    0x8(%ebp),%eax
  802716:	0f 86 d4 00 00 00    	jbe    8027f0 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80271c:	a1 48 51 80 00       	mov    0x805148,%eax
  802721:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 50 08             	mov    0x8(%eax),%edx
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	8b 55 08             	mov    0x8(%ebp),%edx
  802736:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802739:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80273d:	75 17                	jne    802756 <alloc_block_NF+0x11c>
  80273f:	83 ec 04             	sub    $0x4,%esp
  802742:	68 18 40 80 00       	push   $0x804018
  802747:	68 e9 00 00 00       	push   $0xe9
  80274c:	68 6f 3f 80 00       	push   $0x803f6f
  802751:	e8 df db ff ff       	call   800335 <_panic>
  802756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	74 10                	je     80276f <alloc_block_NF+0x135>
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802767:	8b 52 04             	mov    0x4(%edx),%edx
  80276a:	89 50 04             	mov    %edx,0x4(%eax)
  80276d:	eb 0b                	jmp    80277a <alloc_block_NF+0x140>
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	8b 40 04             	mov    0x4(%eax),%eax
  802775:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80277a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277d:	8b 40 04             	mov    0x4(%eax),%eax
  802780:	85 c0                	test   %eax,%eax
  802782:	74 0f                	je     802793 <alloc_block_NF+0x159>
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80278d:	8b 12                	mov    (%edx),%edx
  80278f:	89 10                	mov    %edx,(%eax)
  802791:	eb 0a                	jmp    80279d <alloc_block_NF+0x163>
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	a3 48 51 80 00       	mov    %eax,0x805148
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8027b5:	48                   	dec    %eax
  8027b6:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	8b 40 08             	mov    0x8(%eax),%eax
  8027c1:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 50 08             	mov    0x8(%eax),%edx
  8027cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cf:	01 c2                	add    %eax,%edx
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dd:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e0:	89 c2                	mov    %eax,%edx
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	e9 15 04 00 00       	jmp    802c05 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	74 07                	je     802805 <alloc_block_NF+0x1cb>
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 00                	mov    (%eax),%eax
  802803:	eb 05                	jmp    80280a <alloc_block_NF+0x1d0>
  802805:	b8 00 00 00 00       	mov    $0x0,%eax
  80280a:	a3 40 51 80 00       	mov    %eax,0x805140
  80280f:	a1 40 51 80 00       	mov    0x805140,%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	0f 85 3e fe ff ff    	jne    80265a <alloc_block_NF+0x20>
  80281c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802820:	0f 85 34 fe ff ff    	jne    80265a <alloc_block_NF+0x20>
  802826:	e9 d5 03 00 00       	jmp    802c00 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80282b:	a1 38 51 80 00       	mov    0x805138,%eax
  802830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802833:	e9 b1 01 00 00       	jmp    8029e9 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 50 08             	mov    0x8(%eax),%edx
  80283e:	a1 28 50 80 00       	mov    0x805028,%eax
  802843:	39 c2                	cmp    %eax,%edx
  802845:	0f 82 96 01 00 00    	jb     8029e1 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	3b 45 08             	cmp    0x8(%ebp),%eax
  802854:	0f 82 87 01 00 00    	jb     8029e1 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 0c             	mov    0xc(%eax),%eax
  802860:	3b 45 08             	cmp    0x8(%ebp),%eax
  802863:	0f 85 95 00 00 00    	jne    8028fe <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286d:	75 17                	jne    802886 <alloc_block_NF+0x24c>
  80286f:	83 ec 04             	sub    $0x4,%esp
  802872:	68 18 40 80 00       	push   $0x804018
  802877:	68 fc 00 00 00       	push   $0xfc
  80287c:	68 6f 3f 80 00       	push   $0x803f6f
  802881:	e8 af da ff ff       	call   800335 <_panic>
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	8b 00                	mov    (%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 10                	je     80289f <alloc_block_NF+0x265>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802897:	8b 52 04             	mov    0x4(%edx),%edx
  80289a:	89 50 04             	mov    %edx,0x4(%eax)
  80289d:	eb 0b                	jmp    8028aa <alloc_block_NF+0x270>
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 04             	mov    0x4(%eax),%eax
  8028a5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 40 04             	mov    0x4(%eax),%eax
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	74 0f                	je     8028c3 <alloc_block_NF+0x289>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bd:	8b 12                	mov    (%edx),%edx
  8028bf:	89 10                	mov    %edx,(%eax)
  8028c1:	eb 0a                	jmp    8028cd <alloc_block_NF+0x293>
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	8b 00                	mov    (%eax),%eax
  8028c8:	a3 38 51 80 00       	mov    %eax,0x805138
  8028cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8028e5:	48                   	dec    %eax
  8028e6:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 08             	mov    0x8(%eax),%eax
  8028f1:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	e9 07 03 00 00       	jmp    802c05 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 40 0c             	mov    0xc(%eax),%eax
  802904:	3b 45 08             	cmp    0x8(%ebp),%eax
  802907:	0f 86 d4 00 00 00    	jbe    8029e1 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80290d:	a1 48 51 80 00       	mov    0x805148,%eax
  802912:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 50 08             	mov    0x8(%eax),%edx
  80291b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291e:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802921:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802924:	8b 55 08             	mov    0x8(%ebp),%edx
  802927:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80292a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80292e:	75 17                	jne    802947 <alloc_block_NF+0x30d>
  802930:	83 ec 04             	sub    $0x4,%esp
  802933:	68 18 40 80 00       	push   $0x804018
  802938:	68 04 01 00 00       	push   $0x104
  80293d:	68 6f 3f 80 00       	push   $0x803f6f
  802942:	e8 ee d9 ff ff       	call   800335 <_panic>
  802947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	74 10                	je     802960 <alloc_block_NF+0x326>
  802950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802958:	8b 52 04             	mov    0x4(%edx),%edx
  80295b:	89 50 04             	mov    %edx,0x4(%eax)
  80295e:	eb 0b                	jmp    80296b <alloc_block_NF+0x331>
  802960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802963:	8b 40 04             	mov    0x4(%eax),%eax
  802966:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80296b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296e:	8b 40 04             	mov    0x4(%eax),%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	74 0f                	je     802984 <alloc_block_NF+0x34a>
  802975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80297e:	8b 12                	mov    (%edx),%edx
  802980:	89 10                	mov    %edx,(%eax)
  802982:	eb 0a                	jmp    80298e <alloc_block_NF+0x354>
  802984:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	a3 48 51 80 00       	mov    %eax,0x805148
  80298e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802997:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8029a6:	48                   	dec    %eax
  8029a7:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  8029ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029af:	8b 40 08             	mov    0x8(%eax),%eax
  8029b2:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 50 08             	mov    0x8(%eax),%edx
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	01 c2                	add    %eax,%edx
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d1:	89 c2                	mov    %eax,%edx
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029dc:	e9 24 02 00 00       	jmp    802c05 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ed:	74 07                	je     8029f6 <alloc_block_NF+0x3bc>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	eb 05                	jmp    8029fb <alloc_block_NF+0x3c1>
  8029f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fb:	a3 40 51 80 00       	mov    %eax,0x805140
  802a00:	a1 40 51 80 00       	mov    0x805140,%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	0f 85 2b fe ff ff    	jne    802838 <alloc_block_NF+0x1fe>
  802a0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a11:	0f 85 21 fe ff ff    	jne    802838 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a17:	a1 38 51 80 00       	mov    0x805138,%eax
  802a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1f:	e9 ae 01 00 00       	jmp    802bd2 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 50 08             	mov    0x8(%eax),%edx
  802a2a:	a1 28 50 80 00       	mov    0x805028,%eax
  802a2f:	39 c2                	cmp    %eax,%edx
  802a31:	0f 83 93 01 00 00    	jae    802bca <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a40:	0f 82 84 01 00 00    	jb     802bca <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4f:	0f 85 95 00 00 00    	jne    802aea <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a59:	75 17                	jne    802a72 <alloc_block_NF+0x438>
  802a5b:	83 ec 04             	sub    $0x4,%esp
  802a5e:	68 18 40 80 00       	push   $0x804018
  802a63:	68 14 01 00 00       	push   $0x114
  802a68:	68 6f 3f 80 00       	push   $0x803f6f
  802a6d:	e8 c3 d8 ff ff       	call   800335 <_panic>
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	74 10                	je     802a8b <alloc_block_NF+0x451>
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a83:	8b 52 04             	mov    0x4(%edx),%edx
  802a86:	89 50 04             	mov    %edx,0x4(%eax)
  802a89:	eb 0b                	jmp    802a96 <alloc_block_NF+0x45c>
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 40 04             	mov    0x4(%eax),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	74 0f                	je     802aaf <alloc_block_NF+0x475>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa9:	8b 12                	mov    (%edx),%edx
  802aab:	89 10                	mov    %edx,(%eax)
  802aad:	eb 0a                	jmp    802ab9 <alloc_block_NF+0x47f>
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acc:	a1 44 51 80 00       	mov    0x805144,%eax
  802ad1:	48                   	dec    %eax
  802ad2:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 40 08             	mov    0x8(%eax),%eax
  802add:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	e9 1b 01 00 00       	jmp    802c05 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 40 0c             	mov    0xc(%eax),%eax
  802af0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af3:	0f 86 d1 00 00 00    	jbe    802bca <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802af9:	a1 48 51 80 00       	mov    0x805148,%eax
  802afe:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 50 08             	mov    0x8(%eax),%edx
  802b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b10:	8b 55 08             	mov    0x8(%ebp),%edx
  802b13:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b1a:	75 17                	jne    802b33 <alloc_block_NF+0x4f9>
  802b1c:	83 ec 04             	sub    $0x4,%esp
  802b1f:	68 18 40 80 00       	push   $0x804018
  802b24:	68 1c 01 00 00       	push   $0x11c
  802b29:	68 6f 3f 80 00       	push   $0x803f6f
  802b2e:	e8 02 d8 ff ff       	call   800335 <_panic>
  802b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b36:	8b 00                	mov    (%eax),%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	74 10                	je     802b4c <alloc_block_NF+0x512>
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b44:	8b 52 04             	mov    0x4(%edx),%edx
  802b47:	89 50 04             	mov    %edx,0x4(%eax)
  802b4a:	eb 0b                	jmp    802b57 <alloc_block_NF+0x51d>
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	8b 40 04             	mov    0x4(%eax),%eax
  802b52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b5a:	8b 40 04             	mov    0x4(%eax),%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	74 0f                	je     802b70 <alloc_block_NF+0x536>
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 40 04             	mov    0x4(%eax),%eax
  802b67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b6a:	8b 12                	mov    (%edx),%edx
  802b6c:	89 10                	mov    %edx,(%eax)
  802b6e:	eb 0a                	jmp    802b7a <alloc_block_NF+0x540>
  802b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	a3 48 51 80 00       	mov    %eax,0x805148
  802b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b92:	48                   	dec    %eax
  802b93:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9b:	8b 40 08             	mov    0x8(%eax),%eax
  802b9e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 50 08             	mov    0x8(%eax),%edx
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	01 c2                	add    %eax,%edx
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bba:	2b 45 08             	sub    0x8(%ebp),%eax
  802bbd:	89 c2                	mov    %eax,%edx
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc8:	eb 3b                	jmp    802c05 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bca:	a1 40 51 80 00       	mov    0x805140,%eax
  802bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd6:	74 07                	je     802bdf <alloc_block_NF+0x5a5>
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 00                	mov    (%eax),%eax
  802bdd:	eb 05                	jmp    802be4 <alloc_block_NF+0x5aa>
  802bdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802be4:	a3 40 51 80 00       	mov    %eax,0x805140
  802be9:	a1 40 51 80 00       	mov    0x805140,%eax
  802bee:	85 c0                	test   %eax,%eax
  802bf0:	0f 85 2e fe ff ff    	jne    802a24 <alloc_block_NF+0x3ea>
  802bf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfa:	0f 85 24 fe ff ff    	jne    802a24 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c05:	c9                   	leave  
  802c06:	c3                   	ret    

00802c07 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c07:	55                   	push   %ebp
  802c08:	89 e5                	mov    %esp,%ebp
  802c0a:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c15:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c1a:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c1d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 14                	je     802c3a <insert_sorted_with_merge_freeList+0x33>
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	8b 50 08             	mov    0x8(%eax),%edx
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	8b 40 08             	mov    0x8(%eax),%eax
  802c32:	39 c2                	cmp    %eax,%edx
  802c34:	0f 87 9b 01 00 00    	ja     802dd5 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3e:	75 17                	jne    802c57 <insert_sorted_with_merge_freeList+0x50>
  802c40:	83 ec 04             	sub    $0x4,%esp
  802c43:	68 4c 3f 80 00       	push   $0x803f4c
  802c48:	68 38 01 00 00       	push   $0x138
  802c4d:	68 6f 3f 80 00       	push   $0x803f6f
  802c52:	e8 de d6 ff ff       	call   800335 <_panic>
  802c57:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	89 10                	mov    %edx,(%eax)
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 0d                	je     802c78 <insert_sorted_with_merge_freeList+0x71>
  802c6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c70:	8b 55 08             	mov    0x8(%ebp),%edx
  802c73:	89 50 04             	mov    %edx,0x4(%eax)
  802c76:	eb 08                	jmp    802c80 <insert_sorted_with_merge_freeList+0x79>
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	a3 38 51 80 00       	mov    %eax,0x805138
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c92:	a1 44 51 80 00       	mov    0x805144,%eax
  802c97:	40                   	inc    %eax
  802c98:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca1:	0f 84 a8 06 00 00    	je     80334f <insert_sorted_with_merge_freeList+0x748>
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	8b 50 08             	mov    0x8(%eax),%edx
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb3:	01 c2                	add    %eax,%edx
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	8b 40 08             	mov    0x8(%eax),%eax
  802cbb:	39 c2                	cmp    %eax,%edx
  802cbd:	0f 85 8c 06 00 00    	jne    80334f <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccf:	01 c2                	add    %eax,%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cdb:	75 17                	jne    802cf4 <insert_sorted_with_merge_freeList+0xed>
  802cdd:	83 ec 04             	sub    $0x4,%esp
  802ce0:	68 18 40 80 00       	push   $0x804018
  802ce5:	68 3c 01 00 00       	push   $0x13c
  802cea:	68 6f 3f 80 00       	push   $0x803f6f
  802cef:	e8 41 d6 ff ff       	call   800335 <_panic>
  802cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	74 10                	je     802d0d <insert_sorted_with_merge_freeList+0x106>
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	8b 00                	mov    (%eax),%eax
  802d02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d05:	8b 52 04             	mov    0x4(%edx),%edx
  802d08:	89 50 04             	mov    %edx,0x4(%eax)
  802d0b:	eb 0b                	jmp    802d18 <insert_sorted_with_merge_freeList+0x111>
  802d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d10:	8b 40 04             	mov    0x4(%eax),%eax
  802d13:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	74 0f                	je     802d31 <insert_sorted_with_merge_freeList+0x12a>
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 40 04             	mov    0x4(%eax),%eax
  802d28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2b:	8b 12                	mov    (%edx),%edx
  802d2d:	89 10                	mov    %edx,(%eax)
  802d2f:	eb 0a                	jmp    802d3b <insert_sorted_with_merge_freeList+0x134>
  802d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d34:	8b 00                	mov    (%eax),%eax
  802d36:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802d53:	48                   	dec    %eax
  802d54:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d71:	75 17                	jne    802d8a <insert_sorted_with_merge_freeList+0x183>
  802d73:	83 ec 04             	sub    $0x4,%esp
  802d76:	68 4c 3f 80 00       	push   $0x803f4c
  802d7b:	68 3f 01 00 00       	push   $0x13f
  802d80:	68 6f 3f 80 00       	push   $0x803f6f
  802d85:	e8 ab d5 ff ff       	call   800335 <_panic>
  802d8a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	85 c0                	test   %eax,%eax
  802d9c:	74 0d                	je     802dab <insert_sorted_with_merge_freeList+0x1a4>
  802d9e:	a1 48 51 80 00       	mov    0x805148,%eax
  802da3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da6:	89 50 04             	mov    %edx,0x4(%eax)
  802da9:	eb 08                	jmp    802db3 <insert_sorted_with_merge_freeList+0x1ac>
  802dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db6:	a3 48 51 80 00       	mov    %eax,0x805148
  802dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc5:	a1 54 51 80 00       	mov    0x805154,%eax
  802dca:	40                   	inc    %eax
  802dcb:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dd0:	e9 7a 05 00 00       	jmp    80334f <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	8b 50 08             	mov    0x8(%eax),%edx
  802ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dde:	8b 40 08             	mov    0x8(%eax),%eax
  802de1:	39 c2                	cmp    %eax,%edx
  802de3:	0f 82 14 01 00 00    	jb     802efd <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dec:	8b 50 08             	mov    0x8(%eax),%edx
  802def:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df2:	8b 40 0c             	mov    0xc(%eax),%eax
  802df5:	01 c2                	add    %eax,%edx
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	8b 40 08             	mov    0x8(%eax),%eax
  802dfd:	39 c2                	cmp    %eax,%edx
  802dff:	0f 85 90 00 00 00    	jne    802e95 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e08:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e11:	01 c2                	add    %eax,%edx
  802e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e16:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e31:	75 17                	jne    802e4a <insert_sorted_with_merge_freeList+0x243>
  802e33:	83 ec 04             	sub    $0x4,%esp
  802e36:	68 4c 3f 80 00       	push   $0x803f4c
  802e3b:	68 49 01 00 00       	push   $0x149
  802e40:	68 6f 3f 80 00       	push   $0x803f6f
  802e45:	e8 eb d4 ff ff       	call   800335 <_panic>
  802e4a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	89 10                	mov    %edx,(%eax)
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	85 c0                	test   %eax,%eax
  802e5c:	74 0d                	je     802e6b <insert_sorted_with_merge_freeList+0x264>
  802e5e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e63:	8b 55 08             	mov    0x8(%ebp),%edx
  802e66:	89 50 04             	mov    %edx,0x4(%eax)
  802e69:	eb 08                	jmp    802e73 <insert_sorted_with_merge_freeList+0x26c>
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e85:	a1 54 51 80 00       	mov    0x805154,%eax
  802e8a:	40                   	inc    %eax
  802e8b:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e90:	e9 bb 04 00 00       	jmp    803350 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e99:	75 17                	jne    802eb2 <insert_sorted_with_merge_freeList+0x2ab>
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	68 c0 3f 80 00       	push   $0x803fc0
  802ea3:	68 4c 01 00 00       	push   $0x14c
  802ea8:	68 6f 3f 80 00       	push   $0x803f6f
  802ead:	e8 83 d4 ff ff       	call   800335 <_panic>
  802eb2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	89 50 04             	mov    %edx,0x4(%eax)
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 0c                	je     802ed4 <insert_sorted_with_merge_freeList+0x2cd>
  802ec8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed0:	89 10                	mov    %edx,(%eax)
  802ed2:	eb 08                	jmp    802edc <insert_sorted_with_merge_freeList+0x2d5>
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	a3 38 51 80 00       	mov    %eax,0x805138
  802edc:	8b 45 08             	mov    0x8(%ebp),%eax
  802edf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eed:	a1 44 51 80 00       	mov    0x805144,%eax
  802ef2:	40                   	inc    %eax
  802ef3:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ef8:	e9 53 04 00 00       	jmp    803350 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802efd:	a1 38 51 80 00       	mov    0x805138,%eax
  802f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f05:	e9 15 04 00 00       	jmp    80331f <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 50 08             	mov    0x8(%eax),%edx
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 40 08             	mov    0x8(%eax),%eax
  802f1e:	39 c2                	cmp    %eax,%edx
  802f20:	0f 86 f1 03 00 00    	jbe    803317 <insert_sorted_with_merge_freeList+0x710>
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 50 08             	mov    0x8(%eax),%edx
  802f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2f:	8b 40 08             	mov    0x8(%eax),%eax
  802f32:	39 c2                	cmp    %eax,%edx
  802f34:	0f 83 dd 03 00 00    	jae    803317 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 50 08             	mov    0x8(%eax),%edx
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 40 0c             	mov    0xc(%eax),%eax
  802f46:	01 c2                	add    %eax,%edx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	8b 40 08             	mov    0x8(%eax),%eax
  802f4e:	39 c2                	cmp    %eax,%edx
  802f50:	0f 85 b9 01 00 00    	jne    80310f <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 50 08             	mov    0x8(%eax),%edx
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f62:	01 c2                	add    %eax,%edx
  802f64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f67:	8b 40 08             	mov    0x8(%eax),%eax
  802f6a:	39 c2                	cmp    %eax,%edx
  802f6c:	0f 85 0d 01 00 00    	jne    80307f <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 50 0c             	mov    0xc(%eax),%edx
  802f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7e:	01 c2                	add    %eax,%edx
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f8a:	75 17                	jne    802fa3 <insert_sorted_with_merge_freeList+0x39c>
  802f8c:	83 ec 04             	sub    $0x4,%esp
  802f8f:	68 18 40 80 00       	push   $0x804018
  802f94:	68 5c 01 00 00       	push   $0x15c
  802f99:	68 6f 3f 80 00       	push   $0x803f6f
  802f9e:	e8 92 d3 ff ff       	call   800335 <_panic>
  802fa3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 10                	je     802fbc <insert_sorted_with_merge_freeList+0x3b5>
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb4:	8b 52 04             	mov    0x4(%edx),%edx
  802fb7:	89 50 04             	mov    %edx,0x4(%eax)
  802fba:	eb 0b                	jmp    802fc7 <insert_sorted_with_merge_freeList+0x3c0>
  802fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbf:	8b 40 04             	mov    0x4(%eax),%eax
  802fc2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fca:	8b 40 04             	mov    0x4(%eax),%eax
  802fcd:	85 c0                	test   %eax,%eax
  802fcf:	74 0f                	je     802fe0 <insert_sorted_with_merge_freeList+0x3d9>
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fda:	8b 12                	mov    (%edx),%edx
  802fdc:	89 10                	mov    %edx,(%eax)
  802fde:	eb 0a                	jmp    802fea <insert_sorted_with_merge_freeList+0x3e3>
  802fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	a3 38 51 80 00       	mov    %eax,0x805138
  802fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffd:	a1 44 51 80 00       	mov    0x805144,%eax
  803002:	48                   	dec    %eax
  803003:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803015:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80301c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803020:	75 17                	jne    803039 <insert_sorted_with_merge_freeList+0x432>
  803022:	83 ec 04             	sub    $0x4,%esp
  803025:	68 4c 3f 80 00       	push   $0x803f4c
  80302a:	68 5f 01 00 00       	push   $0x15f
  80302f:	68 6f 3f 80 00       	push   $0x803f6f
  803034:	e8 fc d2 ff ff       	call   800335 <_panic>
  803039:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	89 10                	mov    %edx,(%eax)
  803044:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	85 c0                	test   %eax,%eax
  80304b:	74 0d                	je     80305a <insert_sorted_with_merge_freeList+0x453>
  80304d:	a1 48 51 80 00       	mov    0x805148,%eax
  803052:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803055:	89 50 04             	mov    %edx,0x4(%eax)
  803058:	eb 08                	jmp    803062 <insert_sorted_with_merge_freeList+0x45b>
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803065:	a3 48 51 80 00       	mov    %eax,0x805148
  80306a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80306d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803074:	a1 54 51 80 00       	mov    0x805154,%eax
  803079:	40                   	inc    %eax
  80307a:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80307f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803082:	8b 50 0c             	mov    0xc(%eax),%edx
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	8b 40 0c             	mov    0xc(%eax),%eax
  80308b:	01 c2                	add    %eax,%edx
  80308d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803090:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8030a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ab:	75 17                	jne    8030c4 <insert_sorted_with_merge_freeList+0x4bd>
  8030ad:	83 ec 04             	sub    $0x4,%esp
  8030b0:	68 4c 3f 80 00       	push   $0x803f4c
  8030b5:	68 64 01 00 00       	push   $0x164
  8030ba:	68 6f 3f 80 00       	push   $0x803f6f
  8030bf:	e8 71 d2 ff ff       	call   800335 <_panic>
  8030c4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0d                	je     8030e5 <insert_sorted_with_merge_freeList+0x4de>
  8030d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8030dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	eb 08                	jmp    8030ed <insert_sorted_with_merge_freeList+0x4e6>
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ff:	a1 54 51 80 00       	mov    0x805154,%eax
  803104:	40                   	inc    %eax
  803105:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80310a:	e9 41 02 00 00       	jmp    803350 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	8b 50 08             	mov    0x8(%eax),%edx
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	8b 40 0c             	mov    0xc(%eax),%eax
  80311b:	01 c2                	add    %eax,%edx
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	8b 40 08             	mov    0x8(%eax),%eax
  803123:	39 c2                	cmp    %eax,%edx
  803125:	0f 85 7c 01 00 00    	jne    8032a7 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80312b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80312f:	74 06                	je     803137 <insert_sorted_with_merge_freeList+0x530>
  803131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803135:	75 17                	jne    80314e <insert_sorted_with_merge_freeList+0x547>
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	68 88 3f 80 00       	push   $0x803f88
  80313f:	68 69 01 00 00       	push   $0x169
  803144:	68 6f 3f 80 00       	push   $0x803f6f
  803149:	e8 e7 d1 ff ff       	call   800335 <_panic>
  80314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803151:	8b 50 04             	mov    0x4(%eax),%edx
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	89 50 04             	mov    %edx,0x4(%eax)
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803160:	89 10                	mov    %edx,(%eax)
  803162:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803165:	8b 40 04             	mov    0x4(%eax),%eax
  803168:	85 c0                	test   %eax,%eax
  80316a:	74 0d                	je     803179 <insert_sorted_with_merge_freeList+0x572>
  80316c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316f:	8b 40 04             	mov    0x4(%eax),%eax
  803172:	8b 55 08             	mov    0x8(%ebp),%edx
  803175:	89 10                	mov    %edx,(%eax)
  803177:	eb 08                	jmp    803181 <insert_sorted_with_merge_freeList+0x57a>
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	a3 38 51 80 00       	mov    %eax,0x805138
  803181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803184:	8b 55 08             	mov    0x8(%ebp),%edx
  803187:	89 50 04             	mov    %edx,0x4(%eax)
  80318a:	a1 44 51 80 00       	mov    0x805144,%eax
  80318f:	40                   	inc    %eax
  803190:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803195:	8b 45 08             	mov    0x8(%ebp),%eax
  803198:	8b 50 0c             	mov    0xc(%eax),%edx
  80319b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319e:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a1:	01 c2                	add    %eax,%edx
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031ad:	75 17                	jne    8031c6 <insert_sorted_with_merge_freeList+0x5bf>
  8031af:	83 ec 04             	sub    $0x4,%esp
  8031b2:	68 18 40 80 00       	push   $0x804018
  8031b7:	68 6b 01 00 00       	push   $0x16b
  8031bc:	68 6f 3f 80 00       	push   $0x803f6f
  8031c1:	e8 6f d1 ff ff       	call   800335 <_panic>
  8031c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 10                	je     8031df <insert_sorted_with_merge_freeList+0x5d8>
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 00                	mov    (%eax),%eax
  8031d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d7:	8b 52 04             	mov    0x4(%edx),%edx
  8031da:	89 50 04             	mov    %edx,0x4(%eax)
  8031dd:	eb 0b                	jmp    8031ea <insert_sorted_with_merge_freeList+0x5e3>
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	8b 40 04             	mov    0x4(%eax),%eax
  8031e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	8b 40 04             	mov    0x4(%eax),%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	74 0f                	je     803203 <insert_sorted_with_merge_freeList+0x5fc>
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	8b 40 04             	mov    0x4(%eax),%eax
  8031fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031fd:	8b 12                	mov    (%edx),%edx
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	eb 0a                	jmp    80320d <insert_sorted_with_merge_freeList+0x606>
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	a3 38 51 80 00       	mov    %eax,0x805138
  80320d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803219:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803220:	a1 44 51 80 00       	mov    0x805144,%eax
  803225:	48                   	dec    %eax
  803226:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80322b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803235:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803238:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80323f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803243:	75 17                	jne    80325c <insert_sorted_with_merge_freeList+0x655>
  803245:	83 ec 04             	sub    $0x4,%esp
  803248:	68 4c 3f 80 00       	push   $0x803f4c
  80324d:	68 6e 01 00 00       	push   $0x16e
  803252:	68 6f 3f 80 00       	push   $0x803f6f
  803257:	e8 d9 d0 ff ff       	call   800335 <_panic>
  80325c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803265:	89 10                	mov    %edx,(%eax)
  803267:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326a:	8b 00                	mov    (%eax),%eax
  80326c:	85 c0                	test   %eax,%eax
  80326e:	74 0d                	je     80327d <insert_sorted_with_merge_freeList+0x676>
  803270:	a1 48 51 80 00       	mov    0x805148,%eax
  803275:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803278:	89 50 04             	mov    %edx,0x4(%eax)
  80327b:	eb 08                	jmp    803285 <insert_sorted_with_merge_freeList+0x67e>
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	a3 48 51 80 00       	mov    %eax,0x805148
  80328d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803290:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803297:	a1 54 51 80 00       	mov    0x805154,%eax
  80329c:	40                   	inc    %eax
  80329d:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8032a2:	e9 a9 00 00 00       	jmp    803350 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8032a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ab:	74 06                	je     8032b3 <insert_sorted_with_merge_freeList+0x6ac>
  8032ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b1:	75 17                	jne    8032ca <insert_sorted_with_merge_freeList+0x6c3>
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 e4 3f 80 00       	push   $0x803fe4
  8032bb:	68 73 01 00 00       	push   $0x173
  8032c0:	68 6f 3f 80 00       	push   $0x803f6f
  8032c5:	e8 6b d0 ff ff       	call   800335 <_panic>
  8032ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cd:	8b 10                	mov    (%eax),%edx
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	89 10                	mov    %edx,(%eax)
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 0b                	je     8032e8 <insert_sorted_with_merge_freeList+0x6e1>
  8032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
  8032e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ee:	89 10                	mov    %edx,(%eax)
  8032f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032f6:	89 50 04             	mov    %edx,0x4(%eax)
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	75 08                	jne    80330a <insert_sorted_with_merge_freeList+0x703>
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80330a:	a1 44 51 80 00       	mov    0x805144,%eax
  80330f:	40                   	inc    %eax
  803310:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803315:	eb 39                	jmp    803350 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803317:	a1 40 51 80 00       	mov    0x805140,%eax
  80331c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80331f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803323:	74 07                	je     80332c <insert_sorted_with_merge_freeList+0x725>
  803325:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803328:	8b 00                	mov    (%eax),%eax
  80332a:	eb 05                	jmp    803331 <insert_sorted_with_merge_freeList+0x72a>
  80332c:	b8 00 00 00 00       	mov    $0x0,%eax
  803331:	a3 40 51 80 00       	mov    %eax,0x805140
  803336:	a1 40 51 80 00       	mov    0x805140,%eax
  80333b:	85 c0                	test   %eax,%eax
  80333d:	0f 85 c7 fb ff ff    	jne    802f0a <insert_sorted_with_merge_freeList+0x303>
  803343:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803347:	0f 85 bd fb ff ff    	jne    802f0a <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80334d:	eb 01                	jmp    803350 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80334f:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803350:	90                   	nop
  803351:	c9                   	leave  
  803352:	c3                   	ret    
  803353:	90                   	nop

00803354 <__udivdi3>:
  803354:	55                   	push   %ebp
  803355:	57                   	push   %edi
  803356:	56                   	push   %esi
  803357:	53                   	push   %ebx
  803358:	83 ec 1c             	sub    $0x1c,%esp
  80335b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80335f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803363:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803367:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80336b:	89 ca                	mov    %ecx,%edx
  80336d:	89 f8                	mov    %edi,%eax
  80336f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803373:	85 f6                	test   %esi,%esi
  803375:	75 2d                	jne    8033a4 <__udivdi3+0x50>
  803377:	39 cf                	cmp    %ecx,%edi
  803379:	77 65                	ja     8033e0 <__udivdi3+0x8c>
  80337b:	89 fd                	mov    %edi,%ebp
  80337d:	85 ff                	test   %edi,%edi
  80337f:	75 0b                	jne    80338c <__udivdi3+0x38>
  803381:	b8 01 00 00 00       	mov    $0x1,%eax
  803386:	31 d2                	xor    %edx,%edx
  803388:	f7 f7                	div    %edi
  80338a:	89 c5                	mov    %eax,%ebp
  80338c:	31 d2                	xor    %edx,%edx
  80338e:	89 c8                	mov    %ecx,%eax
  803390:	f7 f5                	div    %ebp
  803392:	89 c1                	mov    %eax,%ecx
  803394:	89 d8                	mov    %ebx,%eax
  803396:	f7 f5                	div    %ebp
  803398:	89 cf                	mov    %ecx,%edi
  80339a:	89 fa                	mov    %edi,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	39 ce                	cmp    %ecx,%esi
  8033a6:	77 28                	ja     8033d0 <__udivdi3+0x7c>
  8033a8:	0f bd fe             	bsr    %esi,%edi
  8033ab:	83 f7 1f             	xor    $0x1f,%edi
  8033ae:	75 40                	jne    8033f0 <__udivdi3+0x9c>
  8033b0:	39 ce                	cmp    %ecx,%esi
  8033b2:	72 0a                	jb     8033be <__udivdi3+0x6a>
  8033b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033b8:	0f 87 9e 00 00 00    	ja     80345c <__udivdi3+0x108>
  8033be:	b8 01 00 00 00       	mov    $0x1,%eax
  8033c3:	89 fa                	mov    %edi,%edx
  8033c5:	83 c4 1c             	add    $0x1c,%esp
  8033c8:	5b                   	pop    %ebx
  8033c9:	5e                   	pop    %esi
  8033ca:	5f                   	pop    %edi
  8033cb:	5d                   	pop    %ebp
  8033cc:	c3                   	ret    
  8033cd:	8d 76 00             	lea    0x0(%esi),%esi
  8033d0:	31 ff                	xor    %edi,%edi
  8033d2:	31 c0                	xor    %eax,%eax
  8033d4:	89 fa                	mov    %edi,%edx
  8033d6:	83 c4 1c             	add    $0x1c,%esp
  8033d9:	5b                   	pop    %ebx
  8033da:	5e                   	pop    %esi
  8033db:	5f                   	pop    %edi
  8033dc:	5d                   	pop    %ebp
  8033dd:	c3                   	ret    
  8033de:	66 90                	xchg   %ax,%ax
  8033e0:	89 d8                	mov    %ebx,%eax
  8033e2:	f7 f7                	div    %edi
  8033e4:	31 ff                	xor    %edi,%edi
  8033e6:	89 fa                	mov    %edi,%edx
  8033e8:	83 c4 1c             	add    $0x1c,%esp
  8033eb:	5b                   	pop    %ebx
  8033ec:	5e                   	pop    %esi
  8033ed:	5f                   	pop    %edi
  8033ee:	5d                   	pop    %ebp
  8033ef:	c3                   	ret    
  8033f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033f5:	89 eb                	mov    %ebp,%ebx
  8033f7:	29 fb                	sub    %edi,%ebx
  8033f9:	89 f9                	mov    %edi,%ecx
  8033fb:	d3 e6                	shl    %cl,%esi
  8033fd:	89 c5                	mov    %eax,%ebp
  8033ff:	88 d9                	mov    %bl,%cl
  803401:	d3 ed                	shr    %cl,%ebp
  803403:	89 e9                	mov    %ebp,%ecx
  803405:	09 f1                	or     %esi,%ecx
  803407:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80340b:	89 f9                	mov    %edi,%ecx
  80340d:	d3 e0                	shl    %cl,%eax
  80340f:	89 c5                	mov    %eax,%ebp
  803411:	89 d6                	mov    %edx,%esi
  803413:	88 d9                	mov    %bl,%cl
  803415:	d3 ee                	shr    %cl,%esi
  803417:	89 f9                	mov    %edi,%ecx
  803419:	d3 e2                	shl    %cl,%edx
  80341b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80341f:	88 d9                	mov    %bl,%cl
  803421:	d3 e8                	shr    %cl,%eax
  803423:	09 c2                	or     %eax,%edx
  803425:	89 d0                	mov    %edx,%eax
  803427:	89 f2                	mov    %esi,%edx
  803429:	f7 74 24 0c          	divl   0xc(%esp)
  80342d:	89 d6                	mov    %edx,%esi
  80342f:	89 c3                	mov    %eax,%ebx
  803431:	f7 e5                	mul    %ebp
  803433:	39 d6                	cmp    %edx,%esi
  803435:	72 19                	jb     803450 <__udivdi3+0xfc>
  803437:	74 0b                	je     803444 <__udivdi3+0xf0>
  803439:	89 d8                	mov    %ebx,%eax
  80343b:	31 ff                	xor    %edi,%edi
  80343d:	e9 58 ff ff ff       	jmp    80339a <__udivdi3+0x46>
  803442:	66 90                	xchg   %ax,%ax
  803444:	8b 54 24 08          	mov    0x8(%esp),%edx
  803448:	89 f9                	mov    %edi,%ecx
  80344a:	d3 e2                	shl    %cl,%edx
  80344c:	39 c2                	cmp    %eax,%edx
  80344e:	73 e9                	jae    803439 <__udivdi3+0xe5>
  803450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803453:	31 ff                	xor    %edi,%edi
  803455:	e9 40 ff ff ff       	jmp    80339a <__udivdi3+0x46>
  80345a:	66 90                	xchg   %ax,%ax
  80345c:	31 c0                	xor    %eax,%eax
  80345e:	e9 37 ff ff ff       	jmp    80339a <__udivdi3+0x46>
  803463:	90                   	nop

00803464 <__umoddi3>:
  803464:	55                   	push   %ebp
  803465:	57                   	push   %edi
  803466:	56                   	push   %esi
  803467:	53                   	push   %ebx
  803468:	83 ec 1c             	sub    $0x1c,%esp
  80346b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80346f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803477:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80347b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80347f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803483:	89 f3                	mov    %esi,%ebx
  803485:	89 fa                	mov    %edi,%edx
  803487:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80348b:	89 34 24             	mov    %esi,(%esp)
  80348e:	85 c0                	test   %eax,%eax
  803490:	75 1a                	jne    8034ac <__umoddi3+0x48>
  803492:	39 f7                	cmp    %esi,%edi
  803494:	0f 86 a2 00 00 00    	jbe    80353c <__umoddi3+0xd8>
  80349a:	89 c8                	mov    %ecx,%eax
  80349c:	89 f2                	mov    %esi,%edx
  80349e:	f7 f7                	div    %edi
  8034a0:	89 d0                	mov    %edx,%eax
  8034a2:	31 d2                	xor    %edx,%edx
  8034a4:	83 c4 1c             	add    $0x1c,%esp
  8034a7:	5b                   	pop    %ebx
  8034a8:	5e                   	pop    %esi
  8034a9:	5f                   	pop    %edi
  8034aa:	5d                   	pop    %ebp
  8034ab:	c3                   	ret    
  8034ac:	39 f0                	cmp    %esi,%eax
  8034ae:	0f 87 ac 00 00 00    	ja     803560 <__umoddi3+0xfc>
  8034b4:	0f bd e8             	bsr    %eax,%ebp
  8034b7:	83 f5 1f             	xor    $0x1f,%ebp
  8034ba:	0f 84 ac 00 00 00    	je     80356c <__umoddi3+0x108>
  8034c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034c5:	29 ef                	sub    %ebp,%edi
  8034c7:	89 fe                	mov    %edi,%esi
  8034c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034cd:	89 e9                	mov    %ebp,%ecx
  8034cf:	d3 e0                	shl    %cl,%eax
  8034d1:	89 d7                	mov    %edx,%edi
  8034d3:	89 f1                	mov    %esi,%ecx
  8034d5:	d3 ef                	shr    %cl,%edi
  8034d7:	09 c7                	or     %eax,%edi
  8034d9:	89 e9                	mov    %ebp,%ecx
  8034db:	d3 e2                	shl    %cl,%edx
  8034dd:	89 14 24             	mov    %edx,(%esp)
  8034e0:	89 d8                	mov    %ebx,%eax
  8034e2:	d3 e0                	shl    %cl,%eax
  8034e4:	89 c2                	mov    %eax,%edx
  8034e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ea:	d3 e0                	shl    %cl,%eax
  8034ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034f4:	89 f1                	mov    %esi,%ecx
  8034f6:	d3 e8                	shr    %cl,%eax
  8034f8:	09 d0                	or     %edx,%eax
  8034fa:	d3 eb                	shr    %cl,%ebx
  8034fc:	89 da                	mov    %ebx,%edx
  8034fe:	f7 f7                	div    %edi
  803500:	89 d3                	mov    %edx,%ebx
  803502:	f7 24 24             	mull   (%esp)
  803505:	89 c6                	mov    %eax,%esi
  803507:	89 d1                	mov    %edx,%ecx
  803509:	39 d3                	cmp    %edx,%ebx
  80350b:	0f 82 87 00 00 00    	jb     803598 <__umoddi3+0x134>
  803511:	0f 84 91 00 00 00    	je     8035a8 <__umoddi3+0x144>
  803517:	8b 54 24 04          	mov    0x4(%esp),%edx
  80351b:	29 f2                	sub    %esi,%edx
  80351d:	19 cb                	sbb    %ecx,%ebx
  80351f:	89 d8                	mov    %ebx,%eax
  803521:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803525:	d3 e0                	shl    %cl,%eax
  803527:	89 e9                	mov    %ebp,%ecx
  803529:	d3 ea                	shr    %cl,%edx
  80352b:	09 d0                	or     %edx,%eax
  80352d:	89 e9                	mov    %ebp,%ecx
  80352f:	d3 eb                	shr    %cl,%ebx
  803531:	89 da                	mov    %ebx,%edx
  803533:	83 c4 1c             	add    $0x1c,%esp
  803536:	5b                   	pop    %ebx
  803537:	5e                   	pop    %esi
  803538:	5f                   	pop    %edi
  803539:	5d                   	pop    %ebp
  80353a:	c3                   	ret    
  80353b:	90                   	nop
  80353c:	89 fd                	mov    %edi,%ebp
  80353e:	85 ff                	test   %edi,%edi
  803540:	75 0b                	jne    80354d <__umoddi3+0xe9>
  803542:	b8 01 00 00 00       	mov    $0x1,%eax
  803547:	31 d2                	xor    %edx,%edx
  803549:	f7 f7                	div    %edi
  80354b:	89 c5                	mov    %eax,%ebp
  80354d:	89 f0                	mov    %esi,%eax
  80354f:	31 d2                	xor    %edx,%edx
  803551:	f7 f5                	div    %ebp
  803553:	89 c8                	mov    %ecx,%eax
  803555:	f7 f5                	div    %ebp
  803557:	89 d0                	mov    %edx,%eax
  803559:	e9 44 ff ff ff       	jmp    8034a2 <__umoddi3+0x3e>
  80355e:	66 90                	xchg   %ax,%ax
  803560:	89 c8                	mov    %ecx,%eax
  803562:	89 f2                	mov    %esi,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	3b 04 24             	cmp    (%esp),%eax
  80356f:	72 06                	jb     803577 <__umoddi3+0x113>
  803571:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803575:	77 0f                	ja     803586 <__umoddi3+0x122>
  803577:	89 f2                	mov    %esi,%edx
  803579:	29 f9                	sub    %edi,%ecx
  80357b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80357f:	89 14 24             	mov    %edx,(%esp)
  803582:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803586:	8b 44 24 04          	mov    0x4(%esp),%eax
  80358a:	8b 14 24             	mov    (%esp),%edx
  80358d:	83 c4 1c             	add    $0x1c,%esp
  803590:	5b                   	pop    %ebx
  803591:	5e                   	pop    %esi
  803592:	5f                   	pop    %edi
  803593:	5d                   	pop    %ebp
  803594:	c3                   	ret    
  803595:	8d 76 00             	lea    0x0(%esi),%esi
  803598:	2b 04 24             	sub    (%esp),%eax
  80359b:	19 fa                	sbb    %edi,%edx
  80359d:	89 d1                	mov    %edx,%ecx
  80359f:	89 c6                	mov    %eax,%esi
  8035a1:	e9 71 ff ff ff       	jmp    803517 <__umoddi3+0xb3>
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035ac:	72 ea                	jb     803598 <__umoddi3+0x134>
  8035ae:	89 d9                	mov    %ebx,%ecx
  8035b0:	e9 62 ff ff ff       	jmp    803517 <__umoddi3+0xb3>
