
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
  80008d:	68 60 36 80 00       	push   $0x803660
  800092:	6a 13                	push   $0x13
  800094:	68 7c 36 80 00       	push   $0x80367c
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
  8000ab:	e8 67 1a 00 00       	call   801b17 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 53 18 00 00       	call   80190b <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 61 17 00 00       	call   80181e <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 97 36 80 00       	push   $0x803697
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 aa 15 00 00       	call   80167a <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 9c 36 80 00       	push   $0x80369c
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 7c 36 80 00       	push   $0x80367c
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 23 17 00 00       	call   80181e <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 fc 36 80 00       	push   $0x8036fc
  80010c:	6a 22                	push   $0x22
  80010e:	68 7c 36 80 00       	push   $0x80367c
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 08 18 00 00       	call   801925 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 e9 17 00 00       	call   80190b <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 f7 16 00 00       	call   80181e <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 8d 37 80 00       	push   $0x80378d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 40 15 00 00       	call   80167a <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 9c 36 80 00       	push   $0x80369c
  800151:	6a 28                	push   $0x28
  800153:	68 7c 36 80 00       	push   $0x80367c
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 bc 16 00 00       	call   80181e <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 fc 36 80 00       	push   $0x8036fc
  800173:	6a 29                	push   $0x29
  800175:	68 7c 36 80 00       	push   $0x80367c
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 a1 17 00 00       	call   801925 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 90 37 80 00       	push   $0x803790
  800196:	6a 2c                	push   $0x2c
  800198:	68 7c 36 80 00       	push   $0x80367c
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
  8001b8:	68 90 37 80 00       	push   $0x803790
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 7c 36 80 00       	push   $0x80367c
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 c8 37 80 00       	push   $0x8037c8
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 f8 37 80 00       	push   $0x8037f8
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 7c 36 80 00       	push   $0x80367c
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
  8001ff:	e8 fa 18 00 00       	call   801afe <sys_getenvindex>
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
  80026a:	e8 9c 16 00 00       	call   80190b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 54 38 80 00       	push   $0x803854
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
  80029a:	68 7c 38 80 00       	push   $0x80387c
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
  8002cb:	68 a4 38 80 00       	push   $0x8038a4
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 fc 38 80 00       	push   $0x8038fc
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 54 38 80 00       	push   $0x803854
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 1c 16 00 00       	call   801925 <sys_enable_interrupt>

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
  80031c:	e8 a9 17 00 00       	call   801aca <sys_destroy_env>
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
  80032d:	e8 fe 17 00 00       	call   801b30 <sys_exit_env>
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
  800356:	68 10 39 80 00       	push   $0x803910
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 50 80 00       	mov    0x805000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 15 39 80 00       	push   $0x803915
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
  800393:	68 31 39 80 00       	push   $0x803931
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
  8003bf:	68 34 39 80 00       	push   $0x803934
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 80 39 80 00       	push   $0x803980
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
  800491:	68 8c 39 80 00       	push   $0x80398c
  800496:	6a 3a                	push   $0x3a
  800498:	68 80 39 80 00       	push   $0x803980
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
  800501:	68 e0 39 80 00       	push   $0x8039e0
  800506:	6a 44                	push   $0x44
  800508:	68 80 39 80 00       	push   $0x803980
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
  80055b:	e8 fd 11 00 00       	call   80175d <sys_cputs>
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
  8005d2:	e8 86 11 00 00       	call   80175d <sys_cputs>
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
  80061c:	e8 ea 12 00 00       	call   80190b <sys_disable_interrupt>
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
  80063c:	e8 e4 12 00 00       	call   801925 <sys_enable_interrupt>
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
  800686:	e8 55 2d 00 00       	call   8033e0 <__udivdi3>
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
  8006d6:	e8 15 2e 00 00       	call   8034f0 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 54 3c 80 00       	add    $0x803c54,%eax
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
  800831:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
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
  800912:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 65 3c 80 00       	push   $0x803c65
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
  800937:	68 6e 3c 80 00       	push   $0x803c6e
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
  800964:	be 71 3c 80 00       	mov    $0x803c71,%esi
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
  80138a:	68 d0 3d 80 00       	push   $0x803dd0
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
  80145a:	e8 42 04 00 00       	call   8018a1 <sys_allocate_chunk>
  80145f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801462:	a1 20 51 80 00       	mov    0x805120,%eax
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	50                   	push   %eax
  80146b:	e8 b7 0a 00 00       	call   801f27 <initialize_MemBlocksList>
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
  801498:	68 f5 3d 80 00       	push   $0x803df5
  80149d:	6a 33                	push   $0x33
  80149f:	68 13 3e 80 00       	push   $0x803e13
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
  801517:	68 20 3e 80 00       	push   $0x803e20
  80151c:	6a 34                	push   $0x34
  80151e:	68 13 3e 80 00       	push   $0x803e13
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
  80158c:	68 44 3e 80 00       	push   $0x803e44
  801591:	6a 46                	push   $0x46
  801593:	68 13 3e 80 00       	push   $0x803e13
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
  8015a8:	68 6c 3e 80 00       	push   $0x803e6c
  8015ad:	6a 61                	push   $0x61
  8015af:	68 13 3e 80 00       	push   $0x803e13
  8015b4:	e8 7c ed ff ff       	call   800335 <_panic>

008015b9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 38             	sub    $0x38,%esp
  8015bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c2:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c5:	e8 a9 fd ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ce:	75 0a                	jne    8015da <smalloc+0x21>
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	e9 9e 00 00 00       	jmp    801678 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015da:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e7:	01 d0                	add    %edx,%eax
  8015e9:	48                   	dec    %eax
  8015ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f5:	f7 75 f0             	divl   -0x10(%ebp)
  8015f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015fb:	29 d0                	sub    %edx,%eax
  8015fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801600:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801607:	e8 63 06 00 00       	call   801c6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160c:	85 c0                	test   %eax,%eax
  80160e:	74 11                	je     801621 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801610:	83 ec 0c             	sub    $0xc,%esp
  801613:	ff 75 e8             	pushl  -0x18(%ebp)
  801616:	e8 ce 0c 00 00       	call   8022e9 <alloc_block_FF>
  80161b:	83 c4 10             	add    $0x10,%esp
  80161e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801625:	74 4c                	je     801673 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162a:	8b 40 08             	mov    0x8(%eax),%eax
  80162d:	89 c2                	mov    %eax,%edx
  80162f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801633:	52                   	push   %edx
  801634:	50                   	push   %eax
  801635:	ff 75 0c             	pushl  0xc(%ebp)
  801638:	ff 75 08             	pushl  0x8(%ebp)
  80163b:	e8 b4 03 00 00       	call   8019f4 <sys_createSharedObject>
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801646:	83 ec 08             	sub    $0x8,%esp
  801649:	ff 75 e0             	pushl  -0x20(%ebp)
  80164c:	68 8f 3e 80 00       	push   $0x803e8f
  801651:	e8 93 ef ff ff       	call   8005e9 <cprintf>
  801656:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801659:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80165d:	74 14                	je     801673 <smalloc+0xba>
  80165f:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801663:	74 0e                	je     801673 <smalloc+0xba>
  801665:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801669:	74 08                	je     801673 <smalloc+0xba>
			return (void*) mem_block->sva;
  80166b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166e:	8b 40 08             	mov    0x8(%eax),%eax
  801671:	eb 05                	jmp    801678 <smalloc+0xbf>
	}
	return NULL;
  801673:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801680:	e8 ee fc ff ff       	call   801373 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801685:	83 ec 04             	sub    $0x4,%esp
  801688:	68 a4 3e 80 00       	push   $0x803ea4
  80168d:	68 ab 00 00 00       	push   $0xab
  801692:	68 13 3e 80 00       	push   $0x803e13
  801697:	e8 99 ec ff ff       	call   800335 <_panic>

0080169c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a2:	e8 cc fc ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016a7:	83 ec 04             	sub    $0x4,%esp
  8016aa:	68 c8 3e 80 00       	push   $0x803ec8
  8016af:	68 ef 00 00 00       	push   $0xef
  8016b4:	68 13 3e 80 00       	push   $0x803e13
  8016b9:	e8 77 ec ff ff       	call   800335 <_panic>

008016be <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	68 f0 3e 80 00       	push   $0x803ef0
  8016cc:	68 03 01 00 00       	push   $0x103
  8016d1:	68 13 3e 80 00       	push   $0x803e13
  8016d6:	e8 5a ec ff ff       	call   800335 <_panic>

008016db <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016e1:	83 ec 04             	sub    $0x4,%esp
  8016e4:	68 14 3f 80 00       	push   $0x803f14
  8016e9:	68 0e 01 00 00       	push   $0x10e
  8016ee:	68 13 3e 80 00       	push   $0x803e13
  8016f3:	e8 3d ec ff ff       	call   800335 <_panic>

008016f8 <shrink>:

}
void shrink(uint32 newSize)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016fe:	83 ec 04             	sub    $0x4,%esp
  801701:	68 14 3f 80 00       	push   $0x803f14
  801706:	68 13 01 00 00       	push   $0x113
  80170b:	68 13 3e 80 00       	push   $0x803e13
  801710:	e8 20 ec ff ff       	call   800335 <_panic>

00801715 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80171b:	83 ec 04             	sub    $0x4,%esp
  80171e:	68 14 3f 80 00       	push   $0x803f14
  801723:	68 18 01 00 00       	push   $0x118
  801728:	68 13 3e 80 00       	push   $0x803e13
  80172d:	e8 03 ec ff ff       	call   800335 <_panic>

00801732 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	57                   	push   %edi
  801736:	56                   	push   %esi
  801737:	53                   	push   %ebx
  801738:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80173b:	8b 45 08             	mov    0x8(%ebp),%eax
  80173e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801741:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801744:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801747:	8b 7d 18             	mov    0x18(%ebp),%edi
  80174a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80174d:	cd 30                	int    $0x30
  80174f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	5b                   	pop    %ebx
  801759:	5e                   	pop    %esi
  80175a:	5f                   	pop    %edi
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 04             	sub    $0x4,%esp
  801763:	8b 45 10             	mov    0x10(%ebp),%eax
  801766:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801769:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	52                   	push   %edx
  801775:	ff 75 0c             	pushl  0xc(%ebp)
  801778:	50                   	push   %eax
  801779:	6a 00                	push   $0x0
  80177b:	e8 b2 ff ff ff       	call   801732 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	90                   	nop
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_cgetc>:

int
sys_cgetc(void)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 01                	push   $0x1
  801795:	e8 98 ff ff ff       	call   801732 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	52                   	push   %edx
  8017af:	50                   	push   %eax
  8017b0:	6a 05                	push   $0x5
  8017b2:	e8 7b ff ff ff       	call   801732 <syscall>
  8017b7:	83 c4 18             	add    $0x18,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    

008017bc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	56                   	push   %esi
  8017c0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017c1:	8b 75 18             	mov    0x18(%ebp),%esi
  8017c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	56                   	push   %esi
  8017d1:	53                   	push   %ebx
  8017d2:	51                   	push   %ecx
  8017d3:	52                   	push   %edx
  8017d4:	50                   	push   %eax
  8017d5:	6a 06                	push   $0x6
  8017d7:	e8 56 ff ff ff       	call   801732 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
}
  8017df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017e2:	5b                   	pop    %ebx
  8017e3:	5e                   	pop    %esi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	52                   	push   %edx
  8017f6:	50                   	push   %eax
  8017f7:	6a 07                	push   $0x7
  8017f9:	e8 34 ff ff ff       	call   801732 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	ff 75 08             	pushl  0x8(%ebp)
  801812:	6a 08                	push   $0x8
  801814:	e8 19 ff ff ff       	call   801732 <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
}
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 09                	push   $0x9
  80182d:	e8 00 ff ff ff       	call   801732 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 0a                	push   $0xa
  801846:	e8 e7 fe ff ff       	call   801732 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 0b                	push   $0xb
  80185f:	e8 ce fe ff ff       	call   801732 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	ff 75 08             	pushl  0x8(%ebp)
  801878:	6a 0f                	push   $0xf
  80187a:	e8 b3 fe ff ff       	call   801732 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
	return;
  801882:	90                   	nop
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	ff 75 0c             	pushl  0xc(%ebp)
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	6a 10                	push   $0x10
  801896:	e8 97 fe ff ff       	call   801732 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
	return ;
  80189e:	90                   	nop
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	ff 75 10             	pushl  0x10(%ebp)
  8018ab:	ff 75 0c             	pushl  0xc(%ebp)
  8018ae:	ff 75 08             	pushl  0x8(%ebp)
  8018b1:	6a 11                	push   $0x11
  8018b3:	e8 7a fe ff ff       	call   801732 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018bb:	90                   	nop
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 0c                	push   $0xc
  8018cd:	e8 60 fe ff ff       	call   801732 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	6a 0d                	push   $0xd
  8018e7:	e8 46 fe ff ff       	call   801732 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 0e                	push   $0xe
  801900:	e8 2d fe ff ff       	call   801732 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 13                	push   $0x13
  80191a:	e8 13 fe ff ff       	call   801732 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	90                   	nop
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 14                	push   $0x14
  801934:	e8 f9 fd ff ff       	call   801732 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	90                   	nop
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_cputc>:


void
sys_cputc(const char c)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 04             	sub    $0x4,%esp
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80194b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	50                   	push   %eax
  801958:	6a 15                	push   $0x15
  80195a:	e8 d3 fd ff ff       	call   801732 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	90                   	nop
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 16                	push   $0x16
  801974:	e8 b9 fd ff ff       	call   801732 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	50                   	push   %eax
  80198f:	6a 17                	push   $0x17
  801991:	e8 9c fd ff ff       	call   801732 <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80199e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	52                   	push   %edx
  8019ab:	50                   	push   %eax
  8019ac:	6a 1a                	push   $0x1a
  8019ae:	e8 7f fd ff ff       	call   801732 <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	52                   	push   %edx
  8019c8:	50                   	push   %eax
  8019c9:	6a 18                	push   $0x18
  8019cb:	e8 62 fd ff ff       	call   801732 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	90                   	nop
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	52                   	push   %edx
  8019e6:	50                   	push   %eax
  8019e7:	6a 19                	push   $0x19
  8019e9:	e8 44 fd ff ff       	call   801732 <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	90                   	nop
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	51                   	push   %ecx
  801a0d:	52                   	push   %edx
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	50                   	push   %eax
  801a12:	6a 1b                	push   $0x1b
  801a14:	e8 19 fd ff ff       	call   801732 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 1c                	push   $0x1c
  801a31:	e8 fc fc ff ff       	call   801732 <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	51                   	push   %ecx
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 1d                	push   $0x1d
  801a50:	e8 dd fc ff ff       	call   801732 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 1e                	push   $0x1e
  801a6d:	e8 c0 fc ff ff       	call   801732 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 1f                	push   $0x1f
  801a86:	e8 a7 fc ff ff       	call   801732 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	ff 75 14             	pushl  0x14(%ebp)
  801a9b:	ff 75 10             	pushl  0x10(%ebp)
  801a9e:	ff 75 0c             	pushl  0xc(%ebp)
  801aa1:	50                   	push   %eax
  801aa2:	6a 20                	push   $0x20
  801aa4:	e8 89 fc ff ff       	call   801732 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	50                   	push   %eax
  801abd:	6a 21                	push   $0x21
  801abf:	e8 6e fc ff ff       	call   801732 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	90                   	nop
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	50                   	push   %eax
  801ad9:	6a 22                	push   $0x22
  801adb:	e8 52 fc ff ff       	call   801732 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 02                	push   $0x2
  801af4:	e8 39 fc ff ff       	call   801732 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 03                	push   $0x3
  801b0d:	e8 20 fc ff ff       	call   801732 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 04                	push   $0x4
  801b26:	e8 07 fc ff ff       	call   801732 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_exit_env>:


void sys_exit_env(void)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 23                	push   $0x23
  801b3f:	e8 ee fb ff ff       	call   801732 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b53:	8d 50 04             	lea    0x4(%eax),%edx
  801b56:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	52                   	push   %edx
  801b60:	50                   	push   %eax
  801b61:	6a 24                	push   $0x24
  801b63:	e8 ca fb ff ff       	call   801732 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
	return result;
  801b6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b74:	89 01                	mov    %eax,(%ecx)
  801b76:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	c9                   	leave  
  801b7d:	c2 04 00             	ret    $0x4

00801b80 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	ff 75 10             	pushl  0x10(%ebp)
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	ff 75 08             	pushl  0x8(%ebp)
  801b90:	6a 12                	push   $0x12
  801b92:	e8 9b fb ff ff       	call   801732 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9a:	90                   	nop
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_rcr2>:
uint32 sys_rcr2()
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 25                	push   $0x25
  801bac:	e8 81 fb ff ff       	call   801732 <syscall>
  801bb1:	83 c4 18             	add    $0x18,%esp
}
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 04             	sub    $0x4,%esp
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bc2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	50                   	push   %eax
  801bcf:	6a 26                	push   $0x26
  801bd1:	e8 5c fb ff ff       	call   801732 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd9:	90                   	nop
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <rsttst>:
void rsttst()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 28                	push   $0x28
  801beb:	e8 42 fb ff ff       	call   801732 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf3:	90                   	nop
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 04             	sub    $0x4,%esp
  801bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  801bff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c02:	8b 55 18             	mov    0x18(%ebp),%edx
  801c05:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c09:	52                   	push   %edx
  801c0a:	50                   	push   %eax
  801c0b:	ff 75 10             	pushl  0x10(%ebp)
  801c0e:	ff 75 0c             	pushl  0xc(%ebp)
  801c11:	ff 75 08             	pushl  0x8(%ebp)
  801c14:	6a 27                	push   $0x27
  801c16:	e8 17 fb ff ff       	call   801732 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1e:	90                   	nop
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <chktst>:
void chktst(uint32 n)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	ff 75 08             	pushl  0x8(%ebp)
  801c2f:	6a 29                	push   $0x29
  801c31:	e8 fc fa ff ff       	call   801732 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
	return ;
  801c39:	90                   	nop
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <inctst>:

void inctst()
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 2a                	push   $0x2a
  801c4b:	e8 e2 fa ff ff       	call   801732 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
	return ;
  801c53:	90                   	nop
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <gettst>:
uint32 gettst()
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 2b                	push   $0x2b
  801c65:	e8 c8 fa ff ff       	call   801732 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 2c                	push   $0x2c
  801c81:	e8 ac fa ff ff       	call   801732 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
  801c89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c8c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c90:	75 07                	jne    801c99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c92:	b8 01 00 00 00       	mov    $0x1,%eax
  801c97:	eb 05                	jmp    801c9e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 2c                	push   $0x2c
  801cb2:	e8 7b fa ff ff       	call   801732 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
  801cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cbd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cc1:	75 07                	jne    801cca <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc8:	eb 05                	jmp    801ccf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 2c                	push   $0x2c
  801ce3:	e8 4a fa ff ff       	call   801732 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
  801ceb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cee:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cf2:	75 07                	jne    801cfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cf4:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf9:	eb 05                	jmp    801d00 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 2c                	push   $0x2c
  801d14:	e8 19 fa ff ff       	call   801732 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
  801d1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d1f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d23:	75 07                	jne    801d2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d25:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2a:	eb 05                	jmp    801d31 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	ff 75 08             	pushl  0x8(%ebp)
  801d41:	6a 2d                	push   $0x2d
  801d43:	e8 ea f9 ff ff       	call   801732 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4b:	90                   	nop
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	6a 00                	push   $0x0
  801d60:	53                   	push   %ebx
  801d61:	51                   	push   %ecx
  801d62:	52                   	push   %edx
  801d63:	50                   	push   %eax
  801d64:	6a 2e                	push   $0x2e
  801d66:	e8 c7 f9 ff ff       	call   801732 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	52                   	push   %edx
  801d83:	50                   	push   %eax
  801d84:	6a 2f                	push   $0x2f
  801d86:	e8 a7 f9 ff ff       	call   801732 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d96:	83 ec 0c             	sub    $0xc,%esp
  801d99:	68 24 3f 80 00       	push   $0x803f24
  801d9e:	e8 46 e8 ff ff       	call   8005e9 <cprintf>
  801da3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801da6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	68 50 3f 80 00       	push   $0x803f50
  801db5:	e8 2f e8 ff ff       	call   8005e9 <cprintf>
  801dba:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801dbd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801dc1:	a1 38 51 80 00       	mov    0x805138,%eax
  801dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dc9:	eb 56                	jmp    801e21 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dcf:	74 1c                	je     801ded <print_mem_block_lists+0x5d>
  801dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd4:	8b 50 08             	mov    0x8(%eax),%edx
  801dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dda:	8b 48 08             	mov    0x8(%eax),%ecx
  801ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de0:	8b 40 0c             	mov    0xc(%eax),%eax
  801de3:	01 c8                	add    %ecx,%eax
  801de5:	39 c2                	cmp    %eax,%edx
  801de7:	73 04                	jae    801ded <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801de9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df0:	8b 50 08             	mov    0x8(%eax),%edx
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df6:	8b 40 0c             	mov    0xc(%eax),%eax
  801df9:	01 c2                	add    %eax,%edx
  801dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfe:	8b 40 08             	mov    0x8(%eax),%eax
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	52                   	push   %edx
  801e05:	50                   	push   %eax
  801e06:	68 65 3f 80 00       	push   $0x803f65
  801e0b:	e8 d9 e7 ff ff       	call   8005e9 <cprintf>
  801e10:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e19:	a1 40 51 80 00       	mov    0x805140,%eax
  801e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e25:	74 07                	je     801e2e <print_mem_block_lists+0x9e>
  801e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2a:	8b 00                	mov    (%eax),%eax
  801e2c:	eb 05                	jmp    801e33 <print_mem_block_lists+0xa3>
  801e2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e33:	a3 40 51 80 00       	mov    %eax,0x805140
  801e38:	a1 40 51 80 00       	mov    0x805140,%eax
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	75 8a                	jne    801dcb <print_mem_block_lists+0x3b>
  801e41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e45:	75 84                	jne    801dcb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e47:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e4b:	75 10                	jne    801e5d <print_mem_block_lists+0xcd>
  801e4d:	83 ec 0c             	sub    $0xc,%esp
  801e50:	68 74 3f 80 00       	push   $0x803f74
  801e55:	e8 8f e7 ff ff       	call   8005e9 <cprintf>
  801e5a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e64:	83 ec 0c             	sub    $0xc,%esp
  801e67:	68 98 3f 80 00       	push   $0x803f98
  801e6c:	e8 78 e7 ff ff       	call   8005e9 <cprintf>
  801e71:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e74:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e78:	a1 40 50 80 00       	mov    0x805040,%eax
  801e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e80:	eb 56                	jmp    801ed8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e86:	74 1c                	je     801ea4 <print_mem_block_lists+0x114>
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	8b 50 08             	mov    0x8(%eax),%edx
  801e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e91:	8b 48 08             	mov    0x8(%eax),%ecx
  801e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e97:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9a:	01 c8                	add    %ecx,%eax
  801e9c:	39 c2                	cmp    %eax,%edx
  801e9e:	73 04                	jae    801ea4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ea0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	8b 50 08             	mov    0x8(%eax),%edx
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb0:	01 c2                	add    %eax,%edx
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 40 08             	mov    0x8(%eax),%eax
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	52                   	push   %edx
  801ebc:	50                   	push   %eax
  801ebd:	68 65 3f 80 00       	push   $0x803f65
  801ec2:	e8 22 e7 ff ff       	call   8005e9 <cprintf>
  801ec7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ed0:	a1 48 50 80 00       	mov    0x805048,%eax
  801ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edc:	74 07                	je     801ee5 <print_mem_block_lists+0x155>
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	8b 00                	mov    (%eax),%eax
  801ee3:	eb 05                	jmp    801eea <print_mem_block_lists+0x15a>
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eea:	a3 48 50 80 00       	mov    %eax,0x805048
  801eef:	a1 48 50 80 00       	mov    0x805048,%eax
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	75 8a                	jne    801e82 <print_mem_block_lists+0xf2>
  801ef8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801efc:	75 84                	jne    801e82 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801efe:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f02:	75 10                	jne    801f14 <print_mem_block_lists+0x184>
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	68 b0 3f 80 00       	push   $0x803fb0
  801f0c:	e8 d8 e6 ff ff       	call   8005e9 <cprintf>
  801f11:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 24 3f 80 00       	push   $0x803f24
  801f1c:	e8 c8 e6 ff ff       	call   8005e9 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp

}
  801f24:	90                   	nop
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f2d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f34:	00 00 00 
  801f37:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f3e:	00 00 00 
  801f41:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f48:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f52:	e9 9e 00 00 00       	jmp    801ff5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f57:	a1 50 50 80 00       	mov    0x805050,%eax
  801f5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5f:	c1 e2 04             	shl    $0x4,%edx
  801f62:	01 d0                	add    %edx,%eax
  801f64:	85 c0                	test   %eax,%eax
  801f66:	75 14                	jne    801f7c <initialize_MemBlocksList+0x55>
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	68 d8 3f 80 00       	push   $0x803fd8
  801f70:	6a 46                	push   $0x46
  801f72:	68 fb 3f 80 00       	push   $0x803ffb
  801f77:	e8 b9 e3 ff ff       	call   800335 <_panic>
  801f7c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f84:	c1 e2 04             	shl    $0x4,%edx
  801f87:	01 d0                	add    %edx,%eax
  801f89:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801f8f:	89 10                	mov    %edx,(%eax)
  801f91:	8b 00                	mov    (%eax),%eax
  801f93:	85 c0                	test   %eax,%eax
  801f95:	74 18                	je     801faf <initialize_MemBlocksList+0x88>
  801f97:	a1 48 51 80 00       	mov    0x805148,%eax
  801f9c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fa2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fa5:	c1 e1 04             	shl    $0x4,%ecx
  801fa8:	01 ca                	add    %ecx,%edx
  801faa:	89 50 04             	mov    %edx,0x4(%eax)
  801fad:	eb 12                	jmp    801fc1 <initialize_MemBlocksList+0x9a>
  801faf:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb7:	c1 e2 04             	shl    $0x4,%edx
  801fba:	01 d0                	add    %edx,%eax
  801fbc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fc1:	a1 50 50 80 00       	mov    0x805050,%eax
  801fc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc9:	c1 e2 04             	shl    $0x4,%edx
  801fcc:	01 d0                	add    %edx,%eax
  801fce:	a3 48 51 80 00       	mov    %eax,0x805148
  801fd3:	a1 50 50 80 00       	mov    0x805050,%eax
  801fd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdb:	c1 e2 04             	shl    $0x4,%edx
  801fde:	01 d0                	add    %edx,%eax
  801fe0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fe7:	a1 54 51 80 00       	mov    0x805154,%eax
  801fec:	40                   	inc    %eax
  801fed:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ff2:	ff 45 f4             	incl   -0xc(%ebp)
  801ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ffb:	0f 82 56 ff ff ff    	jb     801f57 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802001:	90                   	nop
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	8b 00                	mov    (%eax),%eax
  80200f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802012:	eb 19                	jmp    80202d <find_block+0x29>
	{
		if(va==point->sva)
  802014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802017:	8b 40 08             	mov    0x8(%eax),%eax
  80201a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80201d:	75 05                	jne    802024 <find_block+0x20>
		   return point;
  80201f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802022:	eb 36                	jmp    80205a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	8b 40 08             	mov    0x8(%eax),%eax
  80202a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80202d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802031:	74 07                	je     80203a <find_block+0x36>
  802033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802036:	8b 00                	mov    (%eax),%eax
  802038:	eb 05                	jmp    80203f <find_block+0x3b>
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	8b 55 08             	mov    0x8(%ebp),%edx
  802042:	89 42 08             	mov    %eax,0x8(%edx)
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	8b 40 08             	mov    0x8(%eax),%eax
  80204b:	85 c0                	test   %eax,%eax
  80204d:	75 c5                	jne    802014 <find_block+0x10>
  80204f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802053:	75 bf                	jne    802014 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802062:	a1 40 50 80 00       	mov    0x805040,%eax
  802067:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80206a:	a1 44 50 80 00       	mov    0x805044,%eax
  80206f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802072:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802075:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802078:	74 24                	je     80209e <insert_sorted_allocList+0x42>
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	8b 50 08             	mov    0x8(%eax),%edx
  802080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802083:	8b 40 08             	mov    0x8(%eax),%eax
  802086:	39 c2                	cmp    %eax,%edx
  802088:	76 14                	jbe    80209e <insert_sorted_allocList+0x42>
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	8b 50 08             	mov    0x8(%eax),%edx
  802090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802093:	8b 40 08             	mov    0x8(%eax),%eax
  802096:	39 c2                	cmp    %eax,%edx
  802098:	0f 82 60 01 00 00    	jb     8021fe <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80209e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a2:	75 65                	jne    802109 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020a8:	75 14                	jne    8020be <insert_sorted_allocList+0x62>
  8020aa:	83 ec 04             	sub    $0x4,%esp
  8020ad:	68 d8 3f 80 00       	push   $0x803fd8
  8020b2:	6a 6b                	push   $0x6b
  8020b4:	68 fb 3f 80 00       	push   $0x803ffb
  8020b9:	e8 77 e2 ff ff       	call   800335 <_panic>
  8020be:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	89 10                	mov    %edx,(%eax)
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	8b 00                	mov    (%eax),%eax
  8020ce:	85 c0                	test   %eax,%eax
  8020d0:	74 0d                	je     8020df <insert_sorted_allocList+0x83>
  8020d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8020d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020da:	89 50 04             	mov    %edx,0x4(%eax)
  8020dd:	eb 08                	jmp    8020e7 <insert_sorted_allocList+0x8b>
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	a3 44 50 80 00       	mov    %eax,0x805044
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	a3 40 50 80 00       	mov    %eax,0x805040
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020f9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8020fe:	40                   	inc    %eax
  8020ff:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802104:	e9 dc 01 00 00       	jmp    8022e5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 50 08             	mov    0x8(%eax),%edx
  80210f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802112:	8b 40 08             	mov    0x8(%eax),%eax
  802115:	39 c2                	cmp    %eax,%edx
  802117:	77 6c                	ja     802185 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802119:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80211d:	74 06                	je     802125 <insert_sorted_allocList+0xc9>
  80211f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802123:	75 14                	jne    802139 <insert_sorted_allocList+0xdd>
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	68 14 40 80 00       	push   $0x804014
  80212d:	6a 6f                	push   $0x6f
  80212f:	68 fb 3f 80 00       	push   $0x803ffb
  802134:	e8 fc e1 ff ff       	call   800335 <_panic>
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	8b 50 04             	mov    0x4(%eax),%edx
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	89 50 04             	mov    %edx,0x4(%eax)
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80214b:	89 10                	mov    %edx,(%eax)
  80214d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802150:	8b 40 04             	mov    0x4(%eax),%eax
  802153:	85 c0                	test   %eax,%eax
  802155:	74 0d                	je     802164 <insert_sorted_allocList+0x108>
  802157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215a:	8b 40 04             	mov    0x4(%eax),%eax
  80215d:	8b 55 08             	mov    0x8(%ebp),%edx
  802160:	89 10                	mov    %edx,(%eax)
  802162:	eb 08                	jmp    80216c <insert_sorted_allocList+0x110>
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 40 50 80 00       	mov    %eax,0x805040
  80216c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216f:	8b 55 08             	mov    0x8(%ebp),%edx
  802172:	89 50 04             	mov    %edx,0x4(%eax)
  802175:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80217a:	40                   	inc    %eax
  80217b:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802180:	e9 60 01 00 00       	jmp    8022e5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	8b 50 08             	mov    0x8(%eax),%edx
  80218b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80218e:	8b 40 08             	mov    0x8(%eax),%eax
  802191:	39 c2                	cmp    %eax,%edx
  802193:	0f 82 4c 01 00 00    	jb     8022e5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802199:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219d:	75 14                	jne    8021b3 <insert_sorted_allocList+0x157>
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	68 4c 40 80 00       	push   $0x80404c
  8021a7:	6a 73                	push   $0x73
  8021a9:	68 fb 3f 80 00       	push   $0x803ffb
  8021ae:	e8 82 e1 ff ff       	call   800335 <_panic>
  8021b3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	89 50 04             	mov    %edx,0x4(%eax)
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	8b 40 04             	mov    0x4(%eax),%eax
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	74 0c                	je     8021d5 <insert_sorted_allocList+0x179>
  8021c9:	a1 44 50 80 00       	mov    0x805044,%eax
  8021ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d1:	89 10                	mov    %edx,(%eax)
  8021d3:	eb 08                	jmp    8021dd <insert_sorted_allocList+0x181>
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	a3 40 50 80 00       	mov    %eax,0x805040
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	a3 44 50 80 00       	mov    %eax,0x805044
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ee:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021f3:	40                   	inc    %eax
  8021f4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f9:	e9 e7 00 00 00       	jmp    8022e5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802201:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802204:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80220b:	a1 40 50 80 00       	mov    0x805040,%eax
  802210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802213:	e9 9d 00 00 00       	jmp    8022b5 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 00                	mov    (%eax),%eax
  80221d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	8b 50 08             	mov    0x8(%eax),%edx
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	8b 40 08             	mov    0x8(%eax),%eax
  80222c:	39 c2                	cmp    %eax,%edx
  80222e:	76 7d                	jbe    8022ad <insert_sorted_allocList+0x251>
  802230:	8b 45 08             	mov    0x8(%ebp),%eax
  802233:	8b 50 08             	mov    0x8(%eax),%edx
  802236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802239:	8b 40 08             	mov    0x8(%eax),%eax
  80223c:	39 c2                	cmp    %eax,%edx
  80223e:	73 6d                	jae    8022ad <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802244:	74 06                	je     80224c <insert_sorted_allocList+0x1f0>
  802246:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224a:	75 14                	jne    802260 <insert_sorted_allocList+0x204>
  80224c:	83 ec 04             	sub    $0x4,%esp
  80224f:	68 70 40 80 00       	push   $0x804070
  802254:	6a 7f                	push   $0x7f
  802256:	68 fb 3f 80 00       	push   $0x803ffb
  80225b:	e8 d5 e0 ff ff       	call   800335 <_panic>
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 10                	mov    (%eax),%edx
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	89 10                	mov    %edx,(%eax)
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8b 00                	mov    (%eax),%eax
  80226f:	85 c0                	test   %eax,%eax
  802271:	74 0b                	je     80227e <insert_sorted_allocList+0x222>
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	8b 55 08             	mov    0x8(%ebp),%edx
  80227b:	89 50 04             	mov    %edx,0x4(%eax)
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 55 08             	mov    0x8(%ebp),%edx
  802284:	89 10                	mov    %edx,(%eax)
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228c:	89 50 04             	mov    %edx,0x4(%eax)
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	85 c0                	test   %eax,%eax
  802296:	75 08                	jne    8022a0 <insert_sorted_allocList+0x244>
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	a3 44 50 80 00       	mov    %eax,0x805044
  8022a0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022a5:	40                   	inc    %eax
  8022a6:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022ab:	eb 39                	jmp    8022e6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022ad:	a1 48 50 80 00       	mov    0x805048,%eax
  8022b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b9:	74 07                	je     8022c2 <insert_sorted_allocList+0x266>
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	eb 05                	jmp    8022c7 <insert_sorted_allocList+0x26b>
  8022c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c7:	a3 48 50 80 00       	mov    %eax,0x805048
  8022cc:	a1 48 50 80 00       	mov    0x805048,%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	0f 85 3f ff ff ff    	jne    802218 <insert_sorted_allocList+0x1bc>
  8022d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022dd:	0f 85 35 ff ff ff    	jne    802218 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022e3:	eb 01                	jmp    8022e6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022e6:	90                   	nop
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8022f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f7:	e9 85 01 00 00       	jmp    802481 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802302:	3b 45 08             	cmp    0x8(%ebp),%eax
  802305:	0f 82 6e 01 00 00    	jb     802479 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80230b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230e:	8b 40 0c             	mov    0xc(%eax),%eax
  802311:	3b 45 08             	cmp    0x8(%ebp),%eax
  802314:	0f 85 8a 00 00 00    	jne    8023a4 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80231a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231e:	75 17                	jne    802337 <alloc_block_FF+0x4e>
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	68 a4 40 80 00       	push   $0x8040a4
  802328:	68 93 00 00 00       	push   $0x93
  80232d:	68 fb 3f 80 00       	push   $0x803ffb
  802332:	e8 fe df ff ff       	call   800335 <_panic>
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	8b 00                	mov    (%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 10                	je     802350 <alloc_block_FF+0x67>
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802348:	8b 52 04             	mov    0x4(%edx),%edx
  80234b:	89 50 04             	mov    %edx,0x4(%eax)
  80234e:	eb 0b                	jmp    80235b <alloc_block_FF+0x72>
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	8b 40 04             	mov    0x4(%eax),%eax
  802356:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 40 04             	mov    0x4(%eax),%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	74 0f                	je     802374 <alloc_block_FF+0x8b>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236e:	8b 12                	mov    (%edx),%edx
  802370:	89 10                	mov    %edx,(%eax)
  802372:	eb 0a                	jmp    80237e <alloc_block_FF+0x95>
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	8b 00                	mov    (%eax),%eax
  802379:	a3 38 51 80 00       	mov    %eax,0x805138
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802391:	a1 44 51 80 00       	mov    0x805144,%eax
  802396:	48                   	dec    %eax
  802397:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	e9 10 01 00 00       	jmp    8024b4 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ad:	0f 86 c6 00 00 00    	jbe    802479 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8023b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 50 08             	mov    0x8(%eax),%edx
  8023c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cd:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d4:	75 17                	jne    8023ed <alloc_block_FF+0x104>
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	68 a4 40 80 00       	push   $0x8040a4
  8023de:	68 9b 00 00 00       	push   $0x9b
  8023e3:	68 fb 3f 80 00       	push   $0x803ffb
  8023e8:	e8 48 df ff ff       	call   800335 <_panic>
  8023ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f0:	8b 00                	mov    (%eax),%eax
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	74 10                	je     802406 <alloc_block_FF+0x11d>
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fe:	8b 52 04             	mov    0x4(%edx),%edx
  802401:	89 50 04             	mov    %edx,0x4(%eax)
  802404:	eb 0b                	jmp    802411 <alloc_block_FF+0x128>
  802406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802409:	8b 40 04             	mov    0x4(%eax),%eax
  80240c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	74 0f                	je     80242a <alloc_block_FF+0x141>
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802424:	8b 12                	mov    (%edx),%edx
  802426:	89 10                	mov    %edx,(%eax)
  802428:	eb 0a                	jmp    802434 <alloc_block_FF+0x14b>
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	a3 48 51 80 00       	mov    %eax,0x805148
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80243d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802440:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802447:	a1 54 51 80 00       	mov    0x805154,%eax
  80244c:	48                   	dec    %eax
  80244d:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 50 08             	mov    0x8(%eax),%edx
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	01 c2                	add    %eax,%edx
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 40 0c             	mov    0xc(%eax),%eax
  802469:	2b 45 08             	sub    0x8(%ebp),%eax
  80246c:	89 c2                	mov    %eax,%edx
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802477:	eb 3b                	jmp    8024b4 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802479:	a1 40 51 80 00       	mov    0x805140,%eax
  80247e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802485:	74 07                	je     80248e <alloc_block_FF+0x1a5>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	eb 05                	jmp    802493 <alloc_block_FF+0x1aa>
  80248e:	b8 00 00 00 00       	mov    $0x0,%eax
  802493:	a3 40 51 80 00       	mov    %eax,0x805140
  802498:	a1 40 51 80 00       	mov    0x805140,%eax
  80249d:	85 c0                	test   %eax,%eax
  80249f:	0f 85 57 fe ff ff    	jne    8022fc <alloc_block_FF+0x13>
  8024a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a9:	0f 85 4d fe ff ff    	jne    8022fc <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024c3:	a1 38 51 80 00       	mov    0x805138,%eax
  8024c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cb:	e9 df 00 00 00       	jmp    8025af <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d9:	0f 82 c8 00 00 00    	jb     8025a7 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e8:	0f 85 8a 00 00 00    	jne    802578 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f2:	75 17                	jne    80250b <alloc_block_BF+0x55>
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	68 a4 40 80 00       	push   $0x8040a4
  8024fc:	68 b7 00 00 00       	push   $0xb7
  802501:	68 fb 3f 80 00       	push   $0x803ffb
  802506:	e8 2a de ff ff       	call   800335 <_panic>
  80250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250e:	8b 00                	mov    (%eax),%eax
  802510:	85 c0                	test   %eax,%eax
  802512:	74 10                	je     802524 <alloc_block_BF+0x6e>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 00                	mov    (%eax),%eax
  802519:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251c:	8b 52 04             	mov    0x4(%edx),%edx
  80251f:	89 50 04             	mov    %edx,0x4(%eax)
  802522:	eb 0b                	jmp    80252f <alloc_block_BF+0x79>
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	8b 40 04             	mov    0x4(%eax),%eax
  80252a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 40 04             	mov    0x4(%eax),%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	74 0f                	je     802548 <alloc_block_BF+0x92>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 04             	mov    0x4(%eax),%eax
  80253f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802542:	8b 12                	mov    (%edx),%edx
  802544:	89 10                	mov    %edx,(%eax)
  802546:	eb 0a                	jmp    802552 <alloc_block_BF+0x9c>
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 00                	mov    (%eax),%eax
  80254d:	a3 38 51 80 00       	mov    %eax,0x805138
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802565:	a1 44 51 80 00       	mov    0x805144,%eax
  80256a:	48                   	dec    %eax
  80256b:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	e9 4d 01 00 00       	jmp    8026c5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 40 0c             	mov    0xc(%eax),%eax
  80257e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802581:	76 24                	jbe    8025a7 <alloc_block_BF+0xf1>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 40 0c             	mov    0xc(%eax),%eax
  802589:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80258c:	73 19                	jae    8025a7 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80258e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 0c             	mov    0xc(%eax),%eax
  80259b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 40 08             	mov    0x8(%eax),%eax
  8025a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025a7:	a1 40 51 80 00       	mov    0x805140,%eax
  8025ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b3:	74 07                	je     8025bc <alloc_block_BF+0x106>
  8025b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b8:	8b 00                	mov    (%eax),%eax
  8025ba:	eb 05                	jmp    8025c1 <alloc_block_BF+0x10b>
  8025bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c1:	a3 40 51 80 00       	mov    %eax,0x805140
  8025c6:	a1 40 51 80 00       	mov    0x805140,%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	0f 85 fd fe ff ff    	jne    8024d0 <alloc_block_BF+0x1a>
  8025d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d7:	0f 85 f3 fe ff ff    	jne    8024d0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025e1:	0f 84 d9 00 00 00    	je     8026c0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8025ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8025fe:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802601:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802605:	75 17                	jne    80261e <alloc_block_BF+0x168>
  802607:	83 ec 04             	sub    $0x4,%esp
  80260a:	68 a4 40 80 00       	push   $0x8040a4
  80260f:	68 c7 00 00 00       	push   $0xc7
  802614:	68 fb 3f 80 00       	push   $0x803ffb
  802619:	e8 17 dd ff ff       	call   800335 <_panic>
  80261e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	85 c0                	test   %eax,%eax
  802625:	74 10                	je     802637 <alloc_block_BF+0x181>
  802627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80262f:	8b 52 04             	mov    0x4(%edx),%edx
  802632:	89 50 04             	mov    %edx,0x4(%eax)
  802635:	eb 0b                	jmp    802642 <alloc_block_BF+0x18c>
  802637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263a:	8b 40 04             	mov    0x4(%eax),%eax
  80263d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802645:	8b 40 04             	mov    0x4(%eax),%eax
  802648:	85 c0                	test   %eax,%eax
  80264a:	74 0f                	je     80265b <alloc_block_BF+0x1a5>
  80264c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802655:	8b 12                	mov    (%edx),%edx
  802657:	89 10                	mov    %edx,(%eax)
  802659:	eb 0a                	jmp    802665 <alloc_block_BF+0x1af>
  80265b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265e:	8b 00                	mov    (%eax),%eax
  802660:	a3 48 51 80 00       	mov    %eax,0x805148
  802665:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802671:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802678:	a1 54 51 80 00       	mov    0x805154,%eax
  80267d:	48                   	dec    %eax
  80267e:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802683:	83 ec 08             	sub    $0x8,%esp
  802686:	ff 75 ec             	pushl  -0x14(%ebp)
  802689:	68 38 51 80 00       	push   $0x805138
  80268e:	e8 71 f9 ff ff       	call   802004 <find_block>
  802693:	83 c4 10             	add    $0x10,%esp
  802696:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802699:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269c:	8b 50 08             	mov    0x8(%eax),%edx
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	01 c2                	add    %eax,%edx
  8026a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a7:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026b3:	89 c2                	mov    %eax,%edx
  8026b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b8:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026be:	eb 05                	jmp    8026c5 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c5:	c9                   	leave  
  8026c6:	c3                   	ret    

008026c7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026c7:	55                   	push   %ebp
  8026c8:	89 e5                	mov    %esp,%ebp
  8026ca:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026cd:	a1 28 50 80 00       	mov    0x805028,%eax
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	0f 85 de 01 00 00    	jne    8028b8 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026da:	a1 38 51 80 00       	mov    0x805138,%eax
  8026df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e2:	e9 9e 01 00 00       	jmp    802885 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f0:	0f 82 87 01 00 00    	jb     80287d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ff:	0f 85 95 00 00 00    	jne    80279a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802705:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802709:	75 17                	jne    802722 <alloc_block_NF+0x5b>
  80270b:	83 ec 04             	sub    $0x4,%esp
  80270e:	68 a4 40 80 00       	push   $0x8040a4
  802713:	68 e0 00 00 00       	push   $0xe0
  802718:	68 fb 3f 80 00       	push   $0x803ffb
  80271d:	e8 13 dc ff ff       	call   800335 <_panic>
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 00                	mov    (%eax),%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	74 10                	je     80273b <alloc_block_NF+0x74>
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 00                	mov    (%eax),%eax
  802730:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802733:	8b 52 04             	mov    0x4(%edx),%edx
  802736:	89 50 04             	mov    %edx,0x4(%eax)
  802739:	eb 0b                	jmp    802746 <alloc_block_NF+0x7f>
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	74 0f                	je     80275f <alloc_block_NF+0x98>
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802759:	8b 12                	mov    (%edx),%edx
  80275b:	89 10                	mov    %edx,(%eax)
  80275d:	eb 0a                	jmp    802769 <alloc_block_NF+0xa2>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	a3 38 51 80 00       	mov    %eax,0x805138
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277c:	a1 44 51 80 00       	mov    0x805144,%eax
  802781:	48                   	dec    %eax
  802782:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 08             	mov    0x8(%eax),%eax
  80278d:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	e9 f8 04 00 00       	jmp    802c92 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a3:	0f 86 d4 00 00 00    	jbe    80287d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8027ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 50 08             	mov    0x8(%eax),%edx
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027c3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ca:	75 17                	jne    8027e3 <alloc_block_NF+0x11c>
  8027cc:	83 ec 04             	sub    $0x4,%esp
  8027cf:	68 a4 40 80 00       	push   $0x8040a4
  8027d4:	68 e9 00 00 00       	push   $0xe9
  8027d9:	68 fb 3f 80 00       	push   $0x803ffb
  8027de:	e8 52 db ff ff       	call   800335 <_panic>
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	8b 00                	mov    (%eax),%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	74 10                	je     8027fc <alloc_block_NF+0x135>
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ef:	8b 00                	mov    (%eax),%eax
  8027f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f4:	8b 52 04             	mov    0x4(%edx),%edx
  8027f7:	89 50 04             	mov    %edx,0x4(%eax)
  8027fa:	eb 0b                	jmp    802807 <alloc_block_NF+0x140>
  8027fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ff:	8b 40 04             	mov    0x4(%eax),%eax
  802802:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	8b 40 04             	mov    0x4(%eax),%eax
  80280d:	85 c0                	test   %eax,%eax
  80280f:	74 0f                	je     802820 <alloc_block_NF+0x159>
  802811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80281a:	8b 12                	mov    (%edx),%edx
  80281c:	89 10                	mov    %edx,(%eax)
  80281e:	eb 0a                	jmp    80282a <alloc_block_NF+0x163>
  802820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802823:	8b 00                	mov    (%eax),%eax
  802825:	a3 48 51 80 00       	mov    %eax,0x805148
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802833:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802836:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80283d:	a1 54 51 80 00       	mov    0x805154,%eax
  802842:	48                   	dec    %eax
  802843:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	8b 40 08             	mov    0x8(%eax),%eax
  80284e:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802856:	8b 50 08             	mov    0x8(%eax),%edx
  802859:	8b 45 08             	mov    0x8(%ebp),%eax
  80285c:	01 c2                	add    %eax,%edx
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 40 0c             	mov    0xc(%eax),%eax
  80286a:	2b 45 08             	sub    0x8(%ebp),%eax
  80286d:	89 c2                	mov    %eax,%edx
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	e9 15 04 00 00       	jmp    802c92 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80287d:	a1 40 51 80 00       	mov    0x805140,%eax
  802882:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	74 07                	je     802892 <alloc_block_NF+0x1cb>
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 00                	mov    (%eax),%eax
  802890:	eb 05                	jmp    802897 <alloc_block_NF+0x1d0>
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	a3 40 51 80 00       	mov    %eax,0x805140
  80289c:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	0f 85 3e fe ff ff    	jne    8026e7 <alloc_block_NF+0x20>
  8028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ad:	0f 85 34 fe ff ff    	jne    8026e7 <alloc_block_NF+0x20>
  8028b3:	e9 d5 03 00 00       	jmp    802c8d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8028bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028c0:	e9 b1 01 00 00       	jmp    802a76 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	8b 50 08             	mov    0x8(%eax),%edx
  8028cb:	a1 28 50 80 00       	mov    0x805028,%eax
  8028d0:	39 c2                	cmp    %eax,%edx
  8028d2:	0f 82 96 01 00 00    	jb     802a6e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028db:	8b 40 0c             	mov    0xc(%eax),%eax
  8028de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e1:	0f 82 87 01 00 00    	jb     802a6e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f0:	0f 85 95 00 00 00    	jne    80298b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fa:	75 17                	jne    802913 <alloc_block_NF+0x24c>
  8028fc:	83 ec 04             	sub    $0x4,%esp
  8028ff:	68 a4 40 80 00       	push   $0x8040a4
  802904:	68 fc 00 00 00       	push   $0xfc
  802909:	68 fb 3f 80 00       	push   $0x803ffb
  80290e:	e8 22 da ff ff       	call   800335 <_panic>
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	85 c0                	test   %eax,%eax
  80291a:	74 10                	je     80292c <alloc_block_NF+0x265>
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802924:	8b 52 04             	mov    0x4(%edx),%edx
  802927:	89 50 04             	mov    %edx,0x4(%eax)
  80292a:	eb 0b                	jmp    802937 <alloc_block_NF+0x270>
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 40 04             	mov    0x4(%eax),%eax
  802932:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 0f                	je     802950 <alloc_block_NF+0x289>
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 40 04             	mov    0x4(%eax),%eax
  802947:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294a:	8b 12                	mov    (%edx),%edx
  80294c:	89 10                	mov    %edx,(%eax)
  80294e:	eb 0a                	jmp    80295a <alloc_block_NF+0x293>
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	a3 38 51 80 00       	mov    %eax,0x805138
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296d:	a1 44 51 80 00       	mov    0x805144,%eax
  802972:	48                   	dec    %eax
  802973:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 40 08             	mov    0x8(%eax),%eax
  80297e:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	e9 07 03 00 00       	jmp    802c92 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 40 0c             	mov    0xc(%eax),%eax
  802991:	3b 45 08             	cmp    0x8(%ebp),%eax
  802994:	0f 86 d4 00 00 00    	jbe    802a6e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80299a:	a1 48 51 80 00       	mov    0x805148,%eax
  80299f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 50 08             	mov    0x8(%eax),%edx
  8029a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ab:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b4:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029bb:	75 17                	jne    8029d4 <alloc_block_NF+0x30d>
  8029bd:	83 ec 04             	sub    $0x4,%esp
  8029c0:	68 a4 40 80 00       	push   $0x8040a4
  8029c5:	68 04 01 00 00       	push   $0x104
  8029ca:	68 fb 3f 80 00       	push   $0x803ffb
  8029cf:	e8 61 d9 ff ff       	call   800335 <_panic>
  8029d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	74 10                	je     8029ed <alloc_block_NF+0x326>
  8029dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e0:	8b 00                	mov    (%eax),%eax
  8029e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029e5:	8b 52 04             	mov    0x4(%edx),%edx
  8029e8:	89 50 04             	mov    %edx,0x4(%eax)
  8029eb:	eb 0b                	jmp    8029f8 <alloc_block_NF+0x331>
  8029ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f0:	8b 40 04             	mov    0x4(%eax),%eax
  8029f3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fb:	8b 40 04             	mov    0x4(%eax),%eax
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	74 0f                	je     802a11 <alloc_block_NF+0x34a>
  802a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a05:	8b 40 04             	mov    0x4(%eax),%eax
  802a08:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a0b:	8b 12                	mov    (%edx),%edx
  802a0d:	89 10                	mov    %edx,(%eax)
  802a0f:	eb 0a                	jmp    802a1b <alloc_block_NF+0x354>
  802a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	a3 48 51 80 00       	mov    %eax,0x805148
  802a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2e:	a1 54 51 80 00       	mov    0x805154,%eax
  802a33:	48                   	dec    %eax
  802a34:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3c:	8b 40 08             	mov    0x8(%eax),%eax
  802a3f:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 50 08             	mov    0x8(%eax),%edx
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	01 c2                	add    %eax,%edx
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a5e:	89 c2                	mov    %eax,%edx
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a69:	e9 24 02 00 00       	jmp    802c92 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a6e:	a1 40 51 80 00       	mov    0x805140,%eax
  802a73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7a:	74 07                	je     802a83 <alloc_block_NF+0x3bc>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	eb 05                	jmp    802a88 <alloc_block_NF+0x3c1>
  802a83:	b8 00 00 00 00       	mov    $0x0,%eax
  802a88:	a3 40 51 80 00       	mov    %eax,0x805140
  802a8d:	a1 40 51 80 00       	mov    0x805140,%eax
  802a92:	85 c0                	test   %eax,%eax
  802a94:	0f 85 2b fe ff ff    	jne    8028c5 <alloc_block_NF+0x1fe>
  802a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9e:	0f 85 21 fe ff ff    	jne    8028c5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa4:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aac:	e9 ae 01 00 00       	jmp    802c5f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 50 08             	mov    0x8(%eax),%edx
  802ab7:	a1 28 50 80 00       	mov    0x805028,%eax
  802abc:	39 c2                	cmp    %eax,%edx
  802abe:	0f 83 93 01 00 00    	jae    802c57 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aca:	3b 45 08             	cmp    0x8(%ebp),%eax
  802acd:	0f 82 84 01 00 00    	jb     802c57 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802adc:	0f 85 95 00 00 00    	jne    802b77 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ae6:	75 17                	jne    802aff <alloc_block_NF+0x438>
  802ae8:	83 ec 04             	sub    $0x4,%esp
  802aeb:	68 a4 40 80 00       	push   $0x8040a4
  802af0:	68 14 01 00 00       	push   $0x114
  802af5:	68 fb 3f 80 00       	push   $0x803ffb
  802afa:	e8 36 d8 ff ff       	call   800335 <_panic>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	74 10                	je     802b18 <alloc_block_NF+0x451>
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b10:	8b 52 04             	mov    0x4(%edx),%edx
  802b13:	89 50 04             	mov    %edx,0x4(%eax)
  802b16:	eb 0b                	jmp    802b23 <alloc_block_NF+0x45c>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 40 04             	mov    0x4(%eax),%eax
  802b1e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 40 04             	mov    0x4(%eax),%eax
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	74 0f                	je     802b3c <alloc_block_NF+0x475>
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 40 04             	mov    0x4(%eax),%eax
  802b33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b36:	8b 12                	mov    (%edx),%edx
  802b38:	89 10                	mov    %edx,(%eax)
  802b3a:	eb 0a                	jmp    802b46 <alloc_block_NF+0x47f>
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	8b 00                	mov    (%eax),%eax
  802b41:	a3 38 51 80 00       	mov    %eax,0x805138
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b59:	a1 44 51 80 00       	mov    0x805144,%eax
  802b5e:	48                   	dec    %eax
  802b5f:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 40 08             	mov    0x8(%eax),%eax
  802b6a:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	e9 1b 01 00 00       	jmp    802c92 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b80:	0f 86 d1 00 00 00    	jbe    802c57 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b86:	a1 48 51 80 00       	mov    0x805148,%eax
  802b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 50 08             	mov    0x8(%eax),%edx
  802b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b97:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ba3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ba7:	75 17                	jne    802bc0 <alloc_block_NF+0x4f9>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 a4 40 80 00       	push   $0x8040a4
  802bb1:	68 1c 01 00 00       	push   $0x11c
  802bb6:	68 fb 3f 80 00       	push   $0x803ffb
  802bbb:	e8 75 d7 ff ff       	call   800335 <_panic>
  802bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	74 10                	je     802bd9 <alloc_block_NF+0x512>
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd1:	8b 52 04             	mov    0x4(%edx),%edx
  802bd4:	89 50 04             	mov    %edx,0x4(%eax)
  802bd7:	eb 0b                	jmp    802be4 <alloc_block_NF+0x51d>
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	8b 40 04             	mov    0x4(%eax),%eax
  802bdf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be7:	8b 40 04             	mov    0x4(%eax),%eax
  802bea:	85 c0                	test   %eax,%eax
  802bec:	74 0f                	je     802bfd <alloc_block_NF+0x536>
  802bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf1:	8b 40 04             	mov    0x4(%eax),%eax
  802bf4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf7:	8b 12                	mov    (%edx),%edx
  802bf9:	89 10                	mov    %edx,(%eax)
  802bfb:	eb 0a                	jmp    802c07 <alloc_block_NF+0x540>
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	8b 00                	mov    (%eax),%eax
  802c02:	a3 48 51 80 00       	mov    %eax,0x805148
  802c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1a:	a1 54 51 80 00       	mov    0x805154,%eax
  802c1f:	48                   	dec    %eax
  802c20:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c28:	8b 40 08             	mov    0x8(%eax),%eax
  802c2b:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 50 08             	mov    0x8(%eax),%edx
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	01 c2                	add    %eax,%edx
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 40 0c             	mov    0xc(%eax),%eax
  802c47:	2b 45 08             	sub    0x8(%ebp),%eax
  802c4a:	89 c2                	mov    %eax,%edx
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c55:	eb 3b                	jmp    802c92 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c57:	a1 40 51 80 00       	mov    0x805140,%eax
  802c5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c63:	74 07                	je     802c6c <alloc_block_NF+0x5a5>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	eb 05                	jmp    802c71 <alloc_block_NF+0x5aa>
  802c6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c71:	a3 40 51 80 00       	mov    %eax,0x805140
  802c76:	a1 40 51 80 00       	mov    0x805140,%eax
  802c7b:	85 c0                	test   %eax,%eax
  802c7d:	0f 85 2e fe ff ff    	jne    802ab1 <alloc_block_NF+0x3ea>
  802c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c87:	0f 85 24 fe ff ff    	jne    802ab1 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c92:	c9                   	leave  
  802c93:	c3                   	ret    

00802c94 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c9a:	a1 38 51 80 00       	mov    0x805138,%eax
  802c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ca2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ca7:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802caa:	a1 38 51 80 00       	mov    0x805138,%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 14                	je     802cc7 <insert_sorted_with_merge_freeList+0x33>
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	8b 50 08             	mov    0x8(%eax),%edx
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	39 c2                	cmp    %eax,%edx
  802cc1:	0f 87 9b 01 00 00    	ja     802e62 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ccb:	75 17                	jne    802ce4 <insert_sorted_with_merge_freeList+0x50>
  802ccd:	83 ec 04             	sub    $0x4,%esp
  802cd0:	68 d8 3f 80 00       	push   $0x803fd8
  802cd5:	68 38 01 00 00       	push   $0x138
  802cda:	68 fb 3f 80 00       	push   $0x803ffb
  802cdf:	e8 51 d6 ff ff       	call   800335 <_panic>
  802ce4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	89 10                	mov    %edx,(%eax)
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	8b 00                	mov    (%eax),%eax
  802cf4:	85 c0                	test   %eax,%eax
  802cf6:	74 0d                	je     802d05 <insert_sorted_with_merge_freeList+0x71>
  802cf8:	a1 38 51 80 00       	mov    0x805138,%eax
  802cfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802d00:	89 50 04             	mov    %edx,0x4(%eax)
  802d03:	eb 08                	jmp    802d0d <insert_sorted_with_merge_freeList+0x79>
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	a3 38 51 80 00       	mov    %eax,0x805138
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d24:	40                   	inc    %eax
  802d25:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d2e:	0f 84 a8 06 00 00    	je     8033dc <insert_sorted_with_merge_freeList+0x748>
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	8b 50 08             	mov    0x8(%eax),%edx
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d40:	01 c2                	add    %eax,%edx
  802d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
  802d48:	39 c2                	cmp    %eax,%edx
  802d4a:	0f 85 8c 06 00 00    	jne    8033dc <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	8b 50 0c             	mov    0xc(%eax),%edx
  802d56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d59:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5c:	01 c2                	add    %eax,%edx
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d68:	75 17                	jne    802d81 <insert_sorted_with_merge_freeList+0xed>
  802d6a:	83 ec 04             	sub    $0x4,%esp
  802d6d:	68 a4 40 80 00       	push   $0x8040a4
  802d72:	68 3c 01 00 00       	push   $0x13c
  802d77:	68 fb 3f 80 00       	push   $0x803ffb
  802d7c:	e8 b4 d5 ff ff       	call   800335 <_panic>
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 00                	mov    (%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 10                	je     802d9a <insert_sorted_with_merge_freeList+0x106>
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d92:	8b 52 04             	mov    0x4(%edx),%edx
  802d95:	89 50 04             	mov    %edx,0x4(%eax)
  802d98:	eb 0b                	jmp    802da5 <insert_sorted_with_merge_freeList+0x111>
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	85 c0                	test   %eax,%eax
  802dad:	74 0f                	je     802dbe <insert_sorted_with_merge_freeList+0x12a>
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	8b 40 04             	mov    0x4(%eax),%eax
  802db5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802db8:	8b 12                	mov    (%edx),%edx
  802dba:	89 10                	mov    %edx,(%eax)
  802dbc:	eb 0a                	jmp    802dc8 <insert_sorted_with_merge_freeList+0x134>
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	8b 00                	mov    (%eax),%eax
  802dc3:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ddb:	a1 44 51 80 00       	mov    0x805144,%eax
  802de0:	48                   	dec    %eax
  802de1:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dfe:	75 17                	jne    802e17 <insert_sorted_with_merge_freeList+0x183>
  802e00:	83 ec 04             	sub    $0x4,%esp
  802e03:	68 d8 3f 80 00       	push   $0x803fd8
  802e08:	68 3f 01 00 00       	push   $0x13f
  802e0d:	68 fb 3f 80 00       	push   $0x803ffb
  802e12:	e8 1e d5 ff ff       	call   800335 <_panic>
  802e17:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e20:	89 10                	mov    %edx,(%eax)
  802e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	74 0d                	je     802e38 <insert_sorted_with_merge_freeList+0x1a4>
  802e2b:	a1 48 51 80 00       	mov    0x805148,%eax
  802e30:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e33:	89 50 04             	mov    %edx,0x4(%eax)
  802e36:	eb 08                	jmp    802e40 <insert_sorted_with_merge_freeList+0x1ac>
  802e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e43:	a3 48 51 80 00       	mov    %eax,0x805148
  802e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e52:	a1 54 51 80 00       	mov    0x805154,%eax
  802e57:	40                   	inc    %eax
  802e58:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e5d:	e9 7a 05 00 00       	jmp    8033dc <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	8b 50 08             	mov    0x8(%eax),%edx
  802e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6b:	8b 40 08             	mov    0x8(%eax),%eax
  802e6e:	39 c2                	cmp    %eax,%edx
  802e70:	0f 82 14 01 00 00    	jb     802f8a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e79:	8b 50 08             	mov    0x8(%eax),%edx
  802e7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e82:	01 c2                	add    %eax,%edx
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	8b 40 08             	mov    0x8(%eax),%eax
  802e8a:	39 c2                	cmp    %eax,%edx
  802e8c:	0f 85 90 00 00 00    	jne    802f22 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e95:	8b 50 0c             	mov    0xc(%eax),%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9e:	01 c2                	add    %eax,%edx
  802ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea3:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ebe:	75 17                	jne    802ed7 <insert_sorted_with_merge_freeList+0x243>
  802ec0:	83 ec 04             	sub    $0x4,%esp
  802ec3:	68 d8 3f 80 00       	push   $0x803fd8
  802ec8:	68 49 01 00 00       	push   $0x149
  802ecd:	68 fb 3f 80 00       	push   $0x803ffb
  802ed2:	e8 5e d4 ff ff       	call   800335 <_panic>
  802ed7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	89 10                	mov    %edx,(%eax)
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	74 0d                	je     802ef8 <insert_sorted_with_merge_freeList+0x264>
  802eeb:	a1 48 51 80 00       	mov    0x805148,%eax
  802ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef3:	89 50 04             	mov    %edx,0x4(%eax)
  802ef6:	eb 08                	jmp    802f00 <insert_sorted_with_merge_freeList+0x26c>
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	a3 48 51 80 00       	mov    %eax,0x805148
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f12:	a1 54 51 80 00       	mov    0x805154,%eax
  802f17:	40                   	inc    %eax
  802f18:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f1d:	e9 bb 04 00 00       	jmp    8033dd <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f26:	75 17                	jne    802f3f <insert_sorted_with_merge_freeList+0x2ab>
  802f28:	83 ec 04             	sub    $0x4,%esp
  802f2b:	68 4c 40 80 00       	push   $0x80404c
  802f30:	68 4c 01 00 00       	push   $0x14c
  802f35:	68 fb 3f 80 00       	push   $0x803ffb
  802f3a:	e8 f6 d3 ff ff       	call   800335 <_panic>
  802f3f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	89 50 04             	mov    %edx,0x4(%eax)
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	8b 40 04             	mov    0x4(%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 0c                	je     802f61 <insert_sorted_with_merge_freeList+0x2cd>
  802f55:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5d:	89 10                	mov    %edx,(%eax)
  802f5f:	eb 08                	jmp    802f69 <insert_sorted_with_merge_freeList+0x2d5>
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	a3 38 51 80 00       	mov    %eax,0x805138
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f7f:	40                   	inc    %eax
  802f80:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f85:	e9 53 04 00 00       	jmp    8033dd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f92:	e9 15 04 00 00       	jmp    8033ac <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	8b 50 08             	mov    0x8(%eax),%edx
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 40 08             	mov    0x8(%eax),%eax
  802fab:	39 c2                	cmp    %eax,%edx
  802fad:	0f 86 f1 03 00 00    	jbe    8033a4 <insert_sorted_with_merge_freeList+0x710>
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 50 08             	mov    0x8(%eax),%edx
  802fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbc:	8b 40 08             	mov    0x8(%eax),%eax
  802fbf:	39 c2                	cmp    %eax,%edx
  802fc1:	0f 83 dd 03 00 00    	jae    8033a4 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	8b 50 08             	mov    0x8(%eax),%edx
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd3:	01 c2                	add    %eax,%edx
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	8b 40 08             	mov    0x8(%eax),%eax
  802fdb:	39 c2                	cmp    %eax,%edx
  802fdd:	0f 85 b9 01 00 00    	jne    80319c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 50 08             	mov    0x8(%eax),%edx
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8b 40 0c             	mov    0xc(%eax),%eax
  802fef:	01 c2                	add    %eax,%edx
  802ff1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff4:	8b 40 08             	mov    0x8(%eax),%eax
  802ff7:	39 c2                	cmp    %eax,%edx
  802ff9:	0f 85 0d 01 00 00    	jne    80310c <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 50 0c             	mov    0xc(%eax),%edx
  803005:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	01 c2                	add    %eax,%edx
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803013:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803017:	75 17                	jne    803030 <insert_sorted_with_merge_freeList+0x39c>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 a4 40 80 00       	push   $0x8040a4
  803021:	68 5c 01 00 00       	push   $0x15c
  803026:	68 fb 3f 80 00       	push   $0x803ffb
  80302b:	e8 05 d3 ff ff       	call   800335 <_panic>
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	8b 00                	mov    (%eax),%eax
  803035:	85 c0                	test   %eax,%eax
  803037:	74 10                	je     803049 <insert_sorted_with_merge_freeList+0x3b5>
  803039:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303c:	8b 00                	mov    (%eax),%eax
  80303e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803041:	8b 52 04             	mov    0x4(%edx),%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	eb 0b                	jmp    803054 <insert_sorted_with_merge_freeList+0x3c0>
  803049:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304c:	8b 40 04             	mov    0x4(%eax),%eax
  80304f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0f                	je     80306d <insert_sorted_with_merge_freeList+0x3d9>
  80305e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803067:	8b 12                	mov    (%edx),%edx
  803069:	89 10                	mov    %edx,(%eax)
  80306b:	eb 0a                	jmp    803077 <insert_sorted_with_merge_freeList+0x3e3>
  80306d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	a3 38 51 80 00       	mov    %eax,0x805138
  803077:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308a:	a1 44 51 80 00       	mov    0x805144,%eax
  80308f:	48                   	dec    %eax
  803090:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803095:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803098:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ad:	75 17                	jne    8030c6 <insert_sorted_with_merge_freeList+0x432>
  8030af:	83 ec 04             	sub    $0x4,%esp
  8030b2:	68 d8 3f 80 00       	push   $0x803fd8
  8030b7:	68 5f 01 00 00       	push   $0x15f
  8030bc:	68 fb 3f 80 00       	push   $0x803ffb
  8030c1:	e8 6f d2 ff ff       	call   800335 <_panic>
  8030c6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	89 10                	mov    %edx,(%eax)
  8030d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d4:	8b 00                	mov    (%eax),%eax
  8030d6:	85 c0                	test   %eax,%eax
  8030d8:	74 0d                	je     8030e7 <insert_sorted_with_merge_freeList+0x453>
  8030da:	a1 48 51 80 00       	mov    0x805148,%eax
  8030df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030e2:	89 50 04             	mov    %edx,0x4(%eax)
  8030e5:	eb 08                	jmp    8030ef <insert_sorted_with_merge_freeList+0x45b>
  8030e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f2:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803101:	a1 54 51 80 00       	mov    0x805154,%eax
  803106:	40                   	inc    %eax
  803107:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  80310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310f:	8b 50 0c             	mov    0xc(%eax),%edx
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	8b 40 0c             	mov    0xc(%eax),%eax
  803118:	01 c2                	add    %eax,%edx
  80311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803134:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803138:	75 17                	jne    803151 <insert_sorted_with_merge_freeList+0x4bd>
  80313a:	83 ec 04             	sub    $0x4,%esp
  80313d:	68 d8 3f 80 00       	push   $0x803fd8
  803142:	68 64 01 00 00       	push   $0x164
  803147:	68 fb 3f 80 00       	push   $0x803ffb
  80314c:	e8 e4 d1 ff ff       	call   800335 <_panic>
  803151:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	89 10                	mov    %edx,(%eax)
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	85 c0                	test   %eax,%eax
  803163:	74 0d                	je     803172 <insert_sorted_with_merge_freeList+0x4de>
  803165:	a1 48 51 80 00       	mov    0x805148,%eax
  80316a:	8b 55 08             	mov    0x8(%ebp),%edx
  80316d:	89 50 04             	mov    %edx,0x4(%eax)
  803170:	eb 08                	jmp    80317a <insert_sorted_with_merge_freeList+0x4e6>
  803172:	8b 45 08             	mov    0x8(%ebp),%eax
  803175:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 48 51 80 00       	mov    %eax,0x805148
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80318c:	a1 54 51 80 00       	mov    0x805154,%eax
  803191:	40                   	inc    %eax
  803192:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803197:	e9 41 02 00 00       	jmp    8033dd <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	8b 50 08             	mov    0x8(%eax),%edx
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a8:	01 c2                	add    %eax,%edx
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 40 08             	mov    0x8(%eax),%eax
  8031b0:	39 c2                	cmp    %eax,%edx
  8031b2:	0f 85 7c 01 00 00    	jne    803334 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031bc:	74 06                	je     8031c4 <insert_sorted_with_merge_freeList+0x530>
  8031be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c2:	75 17                	jne    8031db <insert_sorted_with_merge_freeList+0x547>
  8031c4:	83 ec 04             	sub    $0x4,%esp
  8031c7:	68 14 40 80 00       	push   $0x804014
  8031cc:	68 69 01 00 00       	push   $0x169
  8031d1:	68 fb 3f 80 00       	push   $0x803ffb
  8031d6:	e8 5a d1 ff ff       	call   800335 <_panic>
  8031db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031de:	8b 50 04             	mov    0x4(%eax),%edx
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	89 50 04             	mov    %edx,0x4(%eax)
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ed:	89 10                	mov    %edx,(%eax)
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	85 c0                	test   %eax,%eax
  8031f7:	74 0d                	je     803206 <insert_sorted_with_merge_freeList+0x572>
  8031f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fc:	8b 40 04             	mov    0x4(%eax),%eax
  8031ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803202:	89 10                	mov    %edx,(%eax)
  803204:	eb 08                	jmp    80320e <insert_sorted_with_merge_freeList+0x57a>
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	a3 38 51 80 00       	mov    %eax,0x805138
  80320e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803211:	8b 55 08             	mov    0x8(%ebp),%edx
  803214:	89 50 04             	mov    %edx,0x4(%eax)
  803217:	a1 44 51 80 00       	mov    0x805144,%eax
  80321c:	40                   	inc    %eax
  80321d:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	8b 50 0c             	mov    0xc(%eax),%edx
  803228:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322b:	8b 40 0c             	mov    0xc(%eax),%eax
  80322e:	01 c2                	add    %eax,%edx
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803236:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80323a:	75 17                	jne    803253 <insert_sorted_with_merge_freeList+0x5bf>
  80323c:	83 ec 04             	sub    $0x4,%esp
  80323f:	68 a4 40 80 00       	push   $0x8040a4
  803244:	68 6b 01 00 00       	push   $0x16b
  803249:	68 fb 3f 80 00       	push   $0x803ffb
  80324e:	e8 e2 d0 ff ff       	call   800335 <_panic>
  803253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	85 c0                	test   %eax,%eax
  80325a:	74 10                	je     80326c <insert_sorted_with_merge_freeList+0x5d8>
  80325c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803264:	8b 52 04             	mov    0x4(%edx),%edx
  803267:	89 50 04             	mov    %edx,0x4(%eax)
  80326a:	eb 0b                	jmp    803277 <insert_sorted_with_merge_freeList+0x5e3>
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	8b 40 04             	mov    0x4(%eax),%eax
  803272:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	8b 40 04             	mov    0x4(%eax),%eax
  80327d:	85 c0                	test   %eax,%eax
  80327f:	74 0f                	je     803290 <insert_sorted_with_merge_freeList+0x5fc>
  803281:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803284:	8b 40 04             	mov    0x4(%eax),%eax
  803287:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328a:	8b 12                	mov    (%edx),%edx
  80328c:	89 10                	mov    %edx,(%eax)
  80328e:	eb 0a                	jmp    80329a <insert_sorted_with_merge_freeList+0x606>
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	a3 38 51 80 00       	mov    %eax,0x805138
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8032b2:	48                   	dec    %eax
  8032b3:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d0:	75 17                	jne    8032e9 <insert_sorted_with_merge_freeList+0x655>
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	68 d8 3f 80 00       	push   $0x803fd8
  8032da:	68 6e 01 00 00       	push   $0x16e
  8032df:	68 fb 3f 80 00       	push   $0x803ffb
  8032e4:	e8 4c d0 ff ff       	call   800335 <_panic>
  8032e9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f2:	89 10                	mov    %edx,(%eax)
  8032f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f7:	8b 00                	mov    (%eax),%eax
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	74 0d                	je     80330a <insert_sorted_with_merge_freeList+0x676>
  8032fd:	a1 48 51 80 00       	mov    0x805148,%eax
  803302:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803305:	89 50 04             	mov    %edx,0x4(%eax)
  803308:	eb 08                	jmp    803312 <insert_sorted_with_merge_freeList+0x67e>
  80330a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803312:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803315:	a3 48 51 80 00       	mov    %eax,0x805148
  80331a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803324:	a1 54 51 80 00       	mov    0x805154,%eax
  803329:	40                   	inc    %eax
  80332a:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80332f:	e9 a9 00 00 00       	jmp    8033dd <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	74 06                	je     803340 <insert_sorted_with_merge_freeList+0x6ac>
  80333a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80333e:	75 17                	jne    803357 <insert_sorted_with_merge_freeList+0x6c3>
  803340:	83 ec 04             	sub    $0x4,%esp
  803343:	68 70 40 80 00       	push   $0x804070
  803348:	68 73 01 00 00       	push   $0x173
  80334d:	68 fb 3f 80 00       	push   $0x803ffb
  803352:	e8 de cf ff ff       	call   800335 <_panic>
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	8b 10                	mov    (%eax),%edx
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	89 10                	mov    %edx,(%eax)
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	8b 00                	mov    (%eax),%eax
  803366:	85 c0                	test   %eax,%eax
  803368:	74 0b                	je     803375 <insert_sorted_with_merge_freeList+0x6e1>
  80336a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336d:	8b 00                	mov    (%eax),%eax
  80336f:	8b 55 08             	mov    0x8(%ebp),%edx
  803372:	89 50 04             	mov    %edx,0x4(%eax)
  803375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803378:	8b 55 08             	mov    0x8(%ebp),%edx
  80337b:	89 10                	mov    %edx,(%eax)
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803383:	89 50 04             	mov    %edx,0x4(%eax)
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	75 08                	jne    803397 <insert_sorted_with_merge_freeList+0x703>
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803397:	a1 44 51 80 00       	mov    0x805144,%eax
  80339c:	40                   	inc    %eax
  80339d:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033a2:	eb 39                	jmp    8033dd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8033a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b0:	74 07                	je     8033b9 <insert_sorted_with_merge_freeList+0x725>
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	8b 00                	mov    (%eax),%eax
  8033b7:	eb 05                	jmp    8033be <insert_sorted_with_merge_freeList+0x72a>
  8033b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8033be:	a3 40 51 80 00       	mov    %eax,0x805140
  8033c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	0f 85 c7 fb ff ff    	jne    802f97 <insert_sorted_with_merge_freeList+0x303>
  8033d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d4:	0f 85 bd fb ff ff    	jne    802f97 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033da:	eb 01                	jmp    8033dd <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033dc:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033dd:	90                   	nop
  8033de:	c9                   	leave  
  8033df:	c3                   	ret    

008033e0 <__udivdi3>:
  8033e0:	55                   	push   %ebp
  8033e1:	57                   	push   %edi
  8033e2:	56                   	push   %esi
  8033e3:	53                   	push   %ebx
  8033e4:	83 ec 1c             	sub    $0x1c,%esp
  8033e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033f7:	89 ca                	mov    %ecx,%edx
  8033f9:	89 f8                	mov    %edi,%eax
  8033fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033ff:	85 f6                	test   %esi,%esi
  803401:	75 2d                	jne    803430 <__udivdi3+0x50>
  803403:	39 cf                	cmp    %ecx,%edi
  803405:	77 65                	ja     80346c <__udivdi3+0x8c>
  803407:	89 fd                	mov    %edi,%ebp
  803409:	85 ff                	test   %edi,%edi
  80340b:	75 0b                	jne    803418 <__udivdi3+0x38>
  80340d:	b8 01 00 00 00       	mov    $0x1,%eax
  803412:	31 d2                	xor    %edx,%edx
  803414:	f7 f7                	div    %edi
  803416:	89 c5                	mov    %eax,%ebp
  803418:	31 d2                	xor    %edx,%edx
  80341a:	89 c8                	mov    %ecx,%eax
  80341c:	f7 f5                	div    %ebp
  80341e:	89 c1                	mov    %eax,%ecx
  803420:	89 d8                	mov    %ebx,%eax
  803422:	f7 f5                	div    %ebp
  803424:	89 cf                	mov    %ecx,%edi
  803426:	89 fa                	mov    %edi,%edx
  803428:	83 c4 1c             	add    $0x1c,%esp
  80342b:	5b                   	pop    %ebx
  80342c:	5e                   	pop    %esi
  80342d:	5f                   	pop    %edi
  80342e:	5d                   	pop    %ebp
  80342f:	c3                   	ret    
  803430:	39 ce                	cmp    %ecx,%esi
  803432:	77 28                	ja     80345c <__udivdi3+0x7c>
  803434:	0f bd fe             	bsr    %esi,%edi
  803437:	83 f7 1f             	xor    $0x1f,%edi
  80343a:	75 40                	jne    80347c <__udivdi3+0x9c>
  80343c:	39 ce                	cmp    %ecx,%esi
  80343e:	72 0a                	jb     80344a <__udivdi3+0x6a>
  803440:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803444:	0f 87 9e 00 00 00    	ja     8034e8 <__udivdi3+0x108>
  80344a:	b8 01 00 00 00       	mov    $0x1,%eax
  80344f:	89 fa                	mov    %edi,%edx
  803451:	83 c4 1c             	add    $0x1c,%esp
  803454:	5b                   	pop    %ebx
  803455:	5e                   	pop    %esi
  803456:	5f                   	pop    %edi
  803457:	5d                   	pop    %ebp
  803458:	c3                   	ret    
  803459:	8d 76 00             	lea    0x0(%esi),%esi
  80345c:	31 ff                	xor    %edi,%edi
  80345e:	31 c0                	xor    %eax,%eax
  803460:	89 fa                	mov    %edi,%edx
  803462:	83 c4 1c             	add    $0x1c,%esp
  803465:	5b                   	pop    %ebx
  803466:	5e                   	pop    %esi
  803467:	5f                   	pop    %edi
  803468:	5d                   	pop    %ebp
  803469:	c3                   	ret    
  80346a:	66 90                	xchg   %ax,%ax
  80346c:	89 d8                	mov    %ebx,%eax
  80346e:	f7 f7                	div    %edi
  803470:	31 ff                	xor    %edi,%edi
  803472:	89 fa                	mov    %edi,%edx
  803474:	83 c4 1c             	add    $0x1c,%esp
  803477:	5b                   	pop    %ebx
  803478:	5e                   	pop    %esi
  803479:	5f                   	pop    %edi
  80347a:	5d                   	pop    %ebp
  80347b:	c3                   	ret    
  80347c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803481:	89 eb                	mov    %ebp,%ebx
  803483:	29 fb                	sub    %edi,%ebx
  803485:	89 f9                	mov    %edi,%ecx
  803487:	d3 e6                	shl    %cl,%esi
  803489:	89 c5                	mov    %eax,%ebp
  80348b:	88 d9                	mov    %bl,%cl
  80348d:	d3 ed                	shr    %cl,%ebp
  80348f:	89 e9                	mov    %ebp,%ecx
  803491:	09 f1                	or     %esi,%ecx
  803493:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803497:	89 f9                	mov    %edi,%ecx
  803499:	d3 e0                	shl    %cl,%eax
  80349b:	89 c5                	mov    %eax,%ebp
  80349d:	89 d6                	mov    %edx,%esi
  80349f:	88 d9                	mov    %bl,%cl
  8034a1:	d3 ee                	shr    %cl,%esi
  8034a3:	89 f9                	mov    %edi,%ecx
  8034a5:	d3 e2                	shl    %cl,%edx
  8034a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ab:	88 d9                	mov    %bl,%cl
  8034ad:	d3 e8                	shr    %cl,%eax
  8034af:	09 c2                	or     %eax,%edx
  8034b1:	89 d0                	mov    %edx,%eax
  8034b3:	89 f2                	mov    %esi,%edx
  8034b5:	f7 74 24 0c          	divl   0xc(%esp)
  8034b9:	89 d6                	mov    %edx,%esi
  8034bb:	89 c3                	mov    %eax,%ebx
  8034bd:	f7 e5                	mul    %ebp
  8034bf:	39 d6                	cmp    %edx,%esi
  8034c1:	72 19                	jb     8034dc <__udivdi3+0xfc>
  8034c3:	74 0b                	je     8034d0 <__udivdi3+0xf0>
  8034c5:	89 d8                	mov    %ebx,%eax
  8034c7:	31 ff                	xor    %edi,%edi
  8034c9:	e9 58 ff ff ff       	jmp    803426 <__udivdi3+0x46>
  8034ce:	66 90                	xchg   %ax,%ax
  8034d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034d4:	89 f9                	mov    %edi,%ecx
  8034d6:	d3 e2                	shl    %cl,%edx
  8034d8:	39 c2                	cmp    %eax,%edx
  8034da:	73 e9                	jae    8034c5 <__udivdi3+0xe5>
  8034dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034df:	31 ff                	xor    %edi,%edi
  8034e1:	e9 40 ff ff ff       	jmp    803426 <__udivdi3+0x46>
  8034e6:	66 90                	xchg   %ax,%ax
  8034e8:	31 c0                	xor    %eax,%eax
  8034ea:	e9 37 ff ff ff       	jmp    803426 <__udivdi3+0x46>
  8034ef:	90                   	nop

008034f0 <__umoddi3>:
  8034f0:	55                   	push   %ebp
  8034f1:	57                   	push   %edi
  8034f2:	56                   	push   %esi
  8034f3:	53                   	push   %ebx
  8034f4:	83 ec 1c             	sub    $0x1c,%esp
  8034f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803503:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803507:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80350b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80350f:	89 f3                	mov    %esi,%ebx
  803511:	89 fa                	mov    %edi,%edx
  803513:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803517:	89 34 24             	mov    %esi,(%esp)
  80351a:	85 c0                	test   %eax,%eax
  80351c:	75 1a                	jne    803538 <__umoddi3+0x48>
  80351e:	39 f7                	cmp    %esi,%edi
  803520:	0f 86 a2 00 00 00    	jbe    8035c8 <__umoddi3+0xd8>
  803526:	89 c8                	mov    %ecx,%eax
  803528:	89 f2                	mov    %esi,%edx
  80352a:	f7 f7                	div    %edi
  80352c:	89 d0                	mov    %edx,%eax
  80352e:	31 d2                	xor    %edx,%edx
  803530:	83 c4 1c             	add    $0x1c,%esp
  803533:	5b                   	pop    %ebx
  803534:	5e                   	pop    %esi
  803535:	5f                   	pop    %edi
  803536:	5d                   	pop    %ebp
  803537:	c3                   	ret    
  803538:	39 f0                	cmp    %esi,%eax
  80353a:	0f 87 ac 00 00 00    	ja     8035ec <__umoddi3+0xfc>
  803540:	0f bd e8             	bsr    %eax,%ebp
  803543:	83 f5 1f             	xor    $0x1f,%ebp
  803546:	0f 84 ac 00 00 00    	je     8035f8 <__umoddi3+0x108>
  80354c:	bf 20 00 00 00       	mov    $0x20,%edi
  803551:	29 ef                	sub    %ebp,%edi
  803553:	89 fe                	mov    %edi,%esi
  803555:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803559:	89 e9                	mov    %ebp,%ecx
  80355b:	d3 e0                	shl    %cl,%eax
  80355d:	89 d7                	mov    %edx,%edi
  80355f:	89 f1                	mov    %esi,%ecx
  803561:	d3 ef                	shr    %cl,%edi
  803563:	09 c7                	or     %eax,%edi
  803565:	89 e9                	mov    %ebp,%ecx
  803567:	d3 e2                	shl    %cl,%edx
  803569:	89 14 24             	mov    %edx,(%esp)
  80356c:	89 d8                	mov    %ebx,%eax
  80356e:	d3 e0                	shl    %cl,%eax
  803570:	89 c2                	mov    %eax,%edx
  803572:	8b 44 24 08          	mov    0x8(%esp),%eax
  803576:	d3 e0                	shl    %cl,%eax
  803578:	89 44 24 04          	mov    %eax,0x4(%esp)
  80357c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803580:	89 f1                	mov    %esi,%ecx
  803582:	d3 e8                	shr    %cl,%eax
  803584:	09 d0                	or     %edx,%eax
  803586:	d3 eb                	shr    %cl,%ebx
  803588:	89 da                	mov    %ebx,%edx
  80358a:	f7 f7                	div    %edi
  80358c:	89 d3                	mov    %edx,%ebx
  80358e:	f7 24 24             	mull   (%esp)
  803591:	89 c6                	mov    %eax,%esi
  803593:	89 d1                	mov    %edx,%ecx
  803595:	39 d3                	cmp    %edx,%ebx
  803597:	0f 82 87 00 00 00    	jb     803624 <__umoddi3+0x134>
  80359d:	0f 84 91 00 00 00    	je     803634 <__umoddi3+0x144>
  8035a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035a7:	29 f2                	sub    %esi,%edx
  8035a9:	19 cb                	sbb    %ecx,%ebx
  8035ab:	89 d8                	mov    %ebx,%eax
  8035ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035b1:	d3 e0                	shl    %cl,%eax
  8035b3:	89 e9                	mov    %ebp,%ecx
  8035b5:	d3 ea                	shr    %cl,%edx
  8035b7:	09 d0                	or     %edx,%eax
  8035b9:	89 e9                	mov    %ebp,%ecx
  8035bb:	d3 eb                	shr    %cl,%ebx
  8035bd:	89 da                	mov    %ebx,%edx
  8035bf:	83 c4 1c             	add    $0x1c,%esp
  8035c2:	5b                   	pop    %ebx
  8035c3:	5e                   	pop    %esi
  8035c4:	5f                   	pop    %edi
  8035c5:	5d                   	pop    %ebp
  8035c6:	c3                   	ret    
  8035c7:	90                   	nop
  8035c8:	89 fd                	mov    %edi,%ebp
  8035ca:	85 ff                	test   %edi,%edi
  8035cc:	75 0b                	jne    8035d9 <__umoddi3+0xe9>
  8035ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d3:	31 d2                	xor    %edx,%edx
  8035d5:	f7 f7                	div    %edi
  8035d7:	89 c5                	mov    %eax,%ebp
  8035d9:	89 f0                	mov    %esi,%eax
  8035db:	31 d2                	xor    %edx,%edx
  8035dd:	f7 f5                	div    %ebp
  8035df:	89 c8                	mov    %ecx,%eax
  8035e1:	f7 f5                	div    %ebp
  8035e3:	89 d0                	mov    %edx,%eax
  8035e5:	e9 44 ff ff ff       	jmp    80352e <__umoddi3+0x3e>
  8035ea:	66 90                	xchg   %ax,%ax
  8035ec:	89 c8                	mov    %ecx,%eax
  8035ee:	89 f2                	mov    %esi,%edx
  8035f0:	83 c4 1c             	add    $0x1c,%esp
  8035f3:	5b                   	pop    %ebx
  8035f4:	5e                   	pop    %esi
  8035f5:	5f                   	pop    %edi
  8035f6:	5d                   	pop    %ebp
  8035f7:	c3                   	ret    
  8035f8:	3b 04 24             	cmp    (%esp),%eax
  8035fb:	72 06                	jb     803603 <__umoddi3+0x113>
  8035fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803601:	77 0f                	ja     803612 <__umoddi3+0x122>
  803603:	89 f2                	mov    %esi,%edx
  803605:	29 f9                	sub    %edi,%ecx
  803607:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80360b:	89 14 24             	mov    %edx,(%esp)
  80360e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803612:	8b 44 24 04          	mov    0x4(%esp),%eax
  803616:	8b 14 24             	mov    (%esp),%edx
  803619:	83 c4 1c             	add    $0x1c,%esp
  80361c:	5b                   	pop    %ebx
  80361d:	5e                   	pop    %esi
  80361e:	5f                   	pop    %edi
  80361f:	5d                   	pop    %ebp
  803620:	c3                   	ret    
  803621:	8d 76 00             	lea    0x0(%esi),%esi
  803624:	2b 04 24             	sub    (%esp),%eax
  803627:	19 fa                	sbb    %edi,%edx
  803629:	89 d1                	mov    %edx,%ecx
  80362b:	89 c6                	mov    %eax,%esi
  80362d:	e9 71 ff ff ff       	jmp    8035a3 <__umoddi3+0xb3>
  803632:	66 90                	xchg   %ax,%ax
  803634:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803638:	72 ea                	jb     803624 <__umoddi3+0x134>
  80363a:	89 d9                	mov    %ebx,%ecx
  80363c:	e9 62 ff ff ff       	jmp    8035a3 <__umoddi3+0xb3>
