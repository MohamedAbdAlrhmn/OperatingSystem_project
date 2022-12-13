
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
  80008d:	68 80 36 80 00       	push   $0x803680
  800092:	6a 13                	push   $0x13
  800094:	68 9c 36 80 00       	push   $0x80369c
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
  8000ab:	e8 8f 1a 00 00       	call   801b3f <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 7b 18 00 00       	call   801933 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 89 17 00 00       	call   801846 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 b7 36 80 00       	push   $0x8036b7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 d2 15 00 00       	call   8016a2 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 bc 36 80 00       	push   $0x8036bc
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 9c 36 80 00       	push   $0x80369c
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 4b 17 00 00       	call   801846 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 1c 37 80 00       	push   $0x80371c
  80010c:	6a 22                	push   $0x22
  80010e:	68 9c 36 80 00       	push   $0x80369c
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 30 18 00 00       	call   80194d <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 11 18 00 00       	call   801933 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 1f 17 00 00       	call   801846 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ad 37 80 00       	push   $0x8037ad
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 68 15 00 00       	call   8016a2 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 bc 36 80 00       	push   $0x8036bc
  800151:	6a 28                	push   $0x28
  800153:	68 9c 36 80 00       	push   $0x80369c
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 e4 16 00 00       	call   801846 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 1c 37 80 00       	push   $0x80371c
  800173:	6a 29                	push   $0x29
  800175:	68 9c 36 80 00       	push   $0x80369c
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 c9 17 00 00       	call   80194d <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 b0 37 80 00       	push   $0x8037b0
  800196:	6a 2c                	push   $0x2c
  800198:	68 9c 36 80 00       	push   $0x80369c
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
  8001b8:	68 b0 37 80 00       	push   $0x8037b0
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 9c 36 80 00       	push   $0x80369c
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 e8 37 80 00       	push   $0x8037e8
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 18 38 80 00       	push   $0x803818
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 9c 36 80 00       	push   $0x80369c
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
  8001ff:	e8 22 19 00 00       	call   801b26 <sys_getenvindex>
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
  80026a:	e8 c4 16 00 00       	call   801933 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 74 38 80 00       	push   $0x803874
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
  80029a:	68 9c 38 80 00       	push   $0x80389c
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
  8002cb:	68 c4 38 80 00       	push   $0x8038c4
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 1c 39 80 00       	push   $0x80391c
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 74 38 80 00       	push   $0x803874
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 44 16 00 00       	call   80194d <sys_enable_interrupt>

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
  80031c:	e8 d1 17 00 00       	call   801af2 <sys_destroy_env>
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
  80032d:	e8 26 18 00 00       	call   801b58 <sys_exit_env>
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
  800356:	68 30 39 80 00       	push   $0x803930
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 50 80 00       	mov    0x805000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 35 39 80 00       	push   $0x803935
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
  800393:	68 51 39 80 00       	push   $0x803951
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
  8003bf:	68 54 39 80 00       	push   $0x803954
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 a0 39 80 00       	push   $0x8039a0
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
  800491:	68 ac 39 80 00       	push   $0x8039ac
  800496:	6a 3a                	push   $0x3a
  800498:	68 a0 39 80 00       	push   $0x8039a0
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
  800501:	68 00 3a 80 00       	push   $0x803a00
  800506:	6a 44                	push   $0x44
  800508:	68 a0 39 80 00       	push   $0x8039a0
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
  80055b:	e8 25 12 00 00       	call   801785 <sys_cputs>
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
  8005d2:	e8 ae 11 00 00       	call   801785 <sys_cputs>
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
  80061c:	e8 12 13 00 00       	call   801933 <sys_disable_interrupt>
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
  80063c:	e8 0c 13 00 00       	call   80194d <sys_enable_interrupt>
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
  800686:	e8 7d 2d 00 00       	call   803408 <__udivdi3>
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
  8006d6:	e8 3d 2e 00 00       	call   803518 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 74 3c 80 00       	add    $0x803c74,%eax
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
  800831:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
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
  800912:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 85 3c 80 00       	push   $0x803c85
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
  800937:	68 8e 3c 80 00       	push   $0x803c8e
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
  800964:	be 91 3c 80 00       	mov    $0x803c91,%esi
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
  80138a:	68 f0 3d 80 00       	push   $0x803df0
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
  80145a:	e8 6a 04 00 00       	call   8018c9 <sys_allocate_chunk>
  80145f:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801462:	a1 20 51 80 00       	mov    0x805120,%eax
  801467:	83 ec 0c             	sub    $0xc,%esp
  80146a:	50                   	push   %eax
  80146b:	e8 df 0a 00 00       	call   801f4f <initialize_MemBlocksList>
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
  801498:	68 15 3e 80 00       	push   $0x803e15
  80149d:	6a 33                	push   $0x33
  80149f:	68 33 3e 80 00       	push   $0x803e33
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
  801517:	68 40 3e 80 00       	push   $0x803e40
  80151c:	6a 34                	push   $0x34
  80151e:	68 33 3e 80 00       	push   $0x803e33
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
  8015af:	e8 e3 06 00 00       	call   801c97 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	74 11                	je     8015c9 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015b8:	83 ec 0c             	sub    $0xc,%esp
  8015bb:	ff 75 e8             	pushl  -0x18(%ebp)
  8015be:	e8 4e 0d 00 00       	call   802311 <alloc_block_FF>
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
  8015d5:	e8 aa 0a 00 00       	call   802084 <insert_sorted_allocList>
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
  8015f5:	68 64 3e 80 00       	push   $0x803e64
  8015fa:	6a 6f                	push   $0x6f
  8015fc:	68 33 3e 80 00       	push   $0x803e33
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
  80161b:	75 07                	jne    801624 <smalloc+0x1e>
  80161d:	b8 00 00 00 00       	mov    $0x0,%eax
  801622:	eb 7c                	jmp    8016a0 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801624:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80162b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	48                   	dec    %eax
  801634:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	f7 75 f0             	divl   -0x10(%ebp)
  801642:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801645:	29 d0                	sub    %edx,%eax
  801647:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80164a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801651:	e8 41 06 00 00       	call   801c97 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801656:	85 c0                	test   %eax,%eax
  801658:	74 11                	je     80166b <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80165a:	83 ec 0c             	sub    $0xc,%esp
  80165d:	ff 75 e8             	pushl  -0x18(%ebp)
  801660:	e8 ac 0c 00 00       	call   802311 <alloc_block_FF>
  801665:	83 c4 10             	add    $0x10,%esp
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80166b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80166f:	74 2a                	je     80169b <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801674:	8b 40 08             	mov    0x8(%eax),%eax
  801677:	89 c2                	mov    %eax,%edx
  801679:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80167d:	52                   	push   %edx
  80167e:	50                   	push   %eax
  80167f:	ff 75 0c             	pushl  0xc(%ebp)
  801682:	ff 75 08             	pushl  0x8(%ebp)
  801685:	e8 92 03 00 00       	call   801a1c <sys_createSharedObject>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801690:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801694:	74 05                	je     80169b <smalloc+0x95>
			return (void*)virtual_address;
  801696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801699:	eb 05                	jmp    8016a0 <smalloc+0x9a>
	}
	return NULL;
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a8:	e8 c6 fc ff ff       	call   801373 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	68 88 3e 80 00       	push   $0x803e88
  8016b5:	68 b0 00 00 00       	push   $0xb0
  8016ba:	68 33 3e 80 00       	push   $0x803e33
  8016bf:	e8 71 ec ff ff       	call   800335 <_panic>

008016c4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016c4:	55                   	push   %ebp
  8016c5:	89 e5                	mov    %esp,%ebp
  8016c7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ca:	e8 a4 fc ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016cf:	83 ec 04             	sub    $0x4,%esp
  8016d2:	68 ac 3e 80 00       	push   $0x803eac
  8016d7:	68 f4 00 00 00       	push   $0xf4
  8016dc:	68 33 3e 80 00       	push   $0x803e33
  8016e1:	e8 4f ec ff ff       	call   800335 <_panic>

008016e6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	68 d4 3e 80 00       	push   $0x803ed4
  8016f4:	68 08 01 00 00       	push   $0x108
  8016f9:	68 33 3e 80 00       	push   $0x803e33
  8016fe:	e8 32 ec ff ff       	call   800335 <_panic>

00801703 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801709:	83 ec 04             	sub    $0x4,%esp
  80170c:	68 f8 3e 80 00       	push   $0x803ef8
  801711:	68 13 01 00 00       	push   $0x113
  801716:	68 33 3e 80 00       	push   $0x803e33
  80171b:	e8 15 ec ff ff       	call   800335 <_panic>

00801720 <shrink>:

}
void shrink(uint32 newSize)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	68 f8 3e 80 00       	push   $0x803ef8
  80172e:	68 18 01 00 00       	push   $0x118
  801733:	68 33 3e 80 00       	push   $0x803e33
  801738:	e8 f8 eb ff ff       	call   800335 <_panic>

0080173d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801743:	83 ec 04             	sub    $0x4,%esp
  801746:	68 f8 3e 80 00       	push   $0x803ef8
  80174b:	68 1d 01 00 00       	push   $0x11d
  801750:	68 33 3e 80 00       	push   $0x803e33
  801755:	e8 db eb ff ff       	call   800335 <_panic>

0080175a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	57                   	push   %edi
  80175e:	56                   	push   %esi
  80175f:	53                   	push   %ebx
  801760:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	8b 55 0c             	mov    0xc(%ebp),%edx
  801769:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80176c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80176f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801772:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801775:	cd 30                	int    $0x30
  801777:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80177a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	5b                   	pop    %ebx
  801781:	5e                   	pop    %esi
  801782:	5f                   	pop    %edi
  801783:	5d                   	pop    %ebp
  801784:	c3                   	ret    

00801785 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 04             	sub    $0x4,%esp
  80178b:	8b 45 10             	mov    0x10(%ebp),%eax
  80178e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801791:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	52                   	push   %edx
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	50                   	push   %eax
  8017a1:	6a 00                	push   $0x0
  8017a3:	e8 b2 ff ff ff       	call   80175a <syscall>
  8017a8:	83 c4 18             	add    $0x18,%esp
}
  8017ab:	90                   	nop
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 01                	push   $0x1
  8017bd:	e8 98 ff ff ff       	call   80175a <syscall>
  8017c2:	83 c4 18             	add    $0x18,%esp
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	52                   	push   %edx
  8017d7:	50                   	push   %eax
  8017d8:	6a 05                	push   $0x5
  8017da:	e8 7b ff ff ff       	call   80175a <syscall>
  8017df:	83 c4 18             	add    $0x18,%esp
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	56                   	push   %esi
  8017e8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017e9:	8b 75 18             	mov    0x18(%ebp),%esi
  8017ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	56                   	push   %esi
  8017f9:	53                   	push   %ebx
  8017fa:	51                   	push   %ecx
  8017fb:	52                   	push   %edx
  8017fc:	50                   	push   %eax
  8017fd:	6a 06                	push   $0x6
  8017ff:	e8 56 ff ff ff       	call   80175a <syscall>
  801804:	83 c4 18             	add    $0x18,%esp
}
  801807:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801811:	8b 55 0c             	mov    0xc(%ebp),%edx
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	52                   	push   %edx
  80181e:	50                   	push   %eax
  80181f:	6a 07                	push   $0x7
  801821:	e8 34 ff ff ff       	call   80175a <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	ff 75 08             	pushl  0x8(%ebp)
  80183a:	6a 08                	push   $0x8
  80183c:	e8 19 ff ff ff       	call   80175a <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 09                	push   $0x9
  801855:	e8 00 ff ff ff       	call   80175a <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 0a                	push   $0xa
  80186e:	e8 e7 fe ff ff       	call   80175a <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 0b                	push   $0xb
  801887:	e8 ce fe ff ff       	call   80175a <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
}
  80188f:	c9                   	leave  
  801890:	c3                   	ret    

00801891 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801891:	55                   	push   %ebp
  801892:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	ff 75 0c             	pushl  0xc(%ebp)
  80189d:	ff 75 08             	pushl  0x8(%ebp)
  8018a0:	6a 0f                	push   $0xf
  8018a2:	e8 b3 fe ff ff       	call   80175a <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
	return;
  8018aa:	90                   	nop
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	ff 75 08             	pushl  0x8(%ebp)
  8018bc:	6a 10                	push   $0x10
  8018be:	e8 97 fe ff ff       	call   80175a <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8018c6:	90                   	nop
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	ff 75 10             	pushl  0x10(%ebp)
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 11                	push   $0x11
  8018db:	e8 7a fe ff ff       	call   80175a <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e3:	90                   	nop
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 0c                	push   $0xc
  8018f5:	e8 60 fe ff ff       	call   80175a <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	ff 75 08             	pushl  0x8(%ebp)
  80190d:	6a 0d                	push   $0xd
  80190f:	e8 46 fe ff ff       	call   80175a <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 0e                	push   $0xe
  801928:	e8 2d fe ff ff       	call   80175a <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
}
  801930:	90                   	nop
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 13                	push   $0x13
  801942:	e8 13 fe ff ff       	call   80175a <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	90                   	nop
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 14                	push   $0x14
  80195c:	e8 f9 fd ff ff       	call   80175a <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	90                   	nop
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_cputc>:


void
sys_cputc(const char c)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801973:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	50                   	push   %eax
  801980:	6a 15                	push   $0x15
  801982:	e8 d3 fd ff ff       	call   80175a <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	90                   	nop
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 16                	push   $0x16
  80199c:	e8 b9 fd ff ff       	call   80175a <syscall>
  8019a1:	83 c4 18             	add    $0x18,%esp
}
  8019a4:	90                   	nop
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	50                   	push   %eax
  8019b7:	6a 17                	push   $0x17
  8019b9:	e8 9c fd ff ff       	call   80175a <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	52                   	push   %edx
  8019d3:	50                   	push   %eax
  8019d4:	6a 1a                	push   $0x1a
  8019d6:	e8 7f fd ff ff       	call   80175a <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	52                   	push   %edx
  8019f0:	50                   	push   %eax
  8019f1:	6a 18                	push   $0x18
  8019f3:	e8 62 fd ff ff       	call   80175a <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 19                	push   $0x19
  801a11:	e8 44 fd ff ff       	call   80175a <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	90                   	nop
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 04             	sub    $0x4,%esp
  801a22:	8b 45 10             	mov    0x10(%ebp),%eax
  801a25:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a28:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a2b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	51                   	push   %ecx
  801a35:	52                   	push   %edx
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	50                   	push   %eax
  801a3a:	6a 1b                	push   $0x1b
  801a3c:	e8 19 fd ff ff       	call   80175a <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	52                   	push   %edx
  801a56:	50                   	push   %eax
  801a57:	6a 1c                	push   $0x1c
  801a59:	e8 fc fc ff ff       	call   80175a <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	51                   	push   %ecx
  801a74:	52                   	push   %edx
  801a75:	50                   	push   %eax
  801a76:	6a 1d                	push   $0x1d
  801a78:	e8 dd fc ff ff       	call   80175a <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	52                   	push   %edx
  801a92:	50                   	push   %eax
  801a93:	6a 1e                	push   $0x1e
  801a95:	e8 c0 fc ff ff       	call   80175a <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 1f                	push   $0x1f
  801aae:	e8 a7 fc ff ff       	call   80175a <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	ff 75 14             	pushl  0x14(%ebp)
  801ac3:	ff 75 10             	pushl  0x10(%ebp)
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	50                   	push   %eax
  801aca:	6a 20                	push   $0x20
  801acc:	e8 89 fc ff ff       	call   80175a <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	50                   	push   %eax
  801ae5:	6a 21                	push   $0x21
  801ae7:	e8 6e fc ff ff       	call   80175a <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	90                   	nop
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	50                   	push   %eax
  801b01:	6a 22                	push   $0x22
  801b03:	e8 52 fc ff ff       	call   80175a <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 02                	push   $0x2
  801b1c:	e8 39 fc ff ff       	call   80175a <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 03                	push   $0x3
  801b35:	e8 20 fc ff ff       	call   80175a <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 04                	push   $0x4
  801b4e:	e8 07 fc ff ff       	call   80175a <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_exit_env>:


void sys_exit_env(void)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 23                	push   $0x23
  801b67:	e8 ee fb ff ff       	call   80175a <syscall>
  801b6c:	83 c4 18             	add    $0x18,%esp
}
  801b6f:	90                   	nop
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b78:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b7b:	8d 50 04             	lea    0x4(%eax),%edx
  801b7e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	52                   	push   %edx
  801b88:	50                   	push   %eax
  801b89:	6a 24                	push   $0x24
  801b8b:	e8 ca fb ff ff       	call   80175a <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
	return result;
  801b93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b9c:	89 01                	mov    %eax,(%ecx)
  801b9e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	c9                   	leave  
  801ba5:	c2 04 00             	ret    $0x4

00801ba8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	ff 75 10             	pushl  0x10(%ebp)
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	6a 12                	push   $0x12
  801bba:	e8 9b fb ff ff       	call   80175a <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc2:	90                   	nop
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 25                	push   $0x25
  801bd4:	e8 81 fb ff ff       	call   80175a <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	83 ec 04             	sub    $0x4,%esp
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	50                   	push   %eax
  801bf7:	6a 26                	push   $0x26
  801bf9:	e8 5c fb ff ff       	call   80175a <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801c01:	90                   	nop
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <rsttst>:
void rsttst()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 28                	push   $0x28
  801c13:	e8 42 fb ff ff       	call   80175a <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1b:	90                   	nop
}
  801c1c:	c9                   	leave  
  801c1d:	c3                   	ret    

00801c1e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	8b 45 14             	mov    0x14(%ebp),%eax
  801c27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c2a:	8b 55 18             	mov    0x18(%ebp),%edx
  801c2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c31:	52                   	push   %edx
  801c32:	50                   	push   %eax
  801c33:	ff 75 10             	pushl  0x10(%ebp)
  801c36:	ff 75 0c             	pushl  0xc(%ebp)
  801c39:	ff 75 08             	pushl  0x8(%ebp)
  801c3c:	6a 27                	push   $0x27
  801c3e:	e8 17 fb ff ff       	call   80175a <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
	return ;
  801c46:	90                   	nop
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <chktst>:
void chktst(uint32 n)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	ff 75 08             	pushl  0x8(%ebp)
  801c57:	6a 29                	push   $0x29
  801c59:	e8 fc fa ff ff       	call   80175a <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c61:	90                   	nop
}
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <inctst>:

void inctst()
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 2a                	push   $0x2a
  801c73:	e8 e2 fa ff ff       	call   80175a <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <gettst>:
uint32 gettst()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 2b                	push   $0x2b
  801c8d:	e8 c8 fa ff ff       	call   80175a <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 2c                	push   $0x2c
  801ca9:	e8 ac fa ff ff       	call   80175a <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
  801cb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cb4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cb8:	75 07                	jne    801cc1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cba:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbf:	eb 05                	jmp    801cc6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 2c                	push   $0x2c
  801cda:	e8 7b fa ff ff       	call   80175a <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
  801ce2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ce5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ce9:	75 07                	jne    801cf2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ceb:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf0:	eb 05                	jmp    801cf7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 2c                	push   $0x2c
  801d0b:	e8 4a fa ff ff       	call   80175a <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
  801d13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d16:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d1a:	75 07                	jne    801d23 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d1c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d21:	eb 05                	jmp    801d28 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 2c                	push   $0x2c
  801d3c:	e8 19 fa ff ff       	call   80175a <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
  801d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d47:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d4b:	75 07                	jne    801d54 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d52:	eb 05                	jmp    801d59 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	ff 75 08             	pushl  0x8(%ebp)
  801d69:	6a 2d                	push   $0x2d
  801d6b:	e8 ea f9 ff ff       	call   80175a <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
	return ;
  801d73:	90                   	nop
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d7a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	6a 00                	push   $0x0
  801d88:	53                   	push   %ebx
  801d89:	51                   	push   %ecx
  801d8a:	52                   	push   %edx
  801d8b:	50                   	push   %eax
  801d8c:	6a 2e                	push   $0x2e
  801d8e:	e8 c7 f9 ff ff       	call   80175a <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	6a 2f                	push   $0x2f
  801dae:	e8 a7 f9 ff ff       	call   80175a <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dbe:	83 ec 0c             	sub    $0xc,%esp
  801dc1:	68 08 3f 80 00       	push   $0x803f08
  801dc6:	e8 1e e8 ff ff       	call   8005e9 <cprintf>
  801dcb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801dce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801dd5:	83 ec 0c             	sub    $0xc,%esp
  801dd8:	68 34 3f 80 00       	push   $0x803f34
  801ddd:	e8 07 e8 ff ff       	call   8005e9 <cprintf>
  801de2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801de5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801de9:	a1 38 51 80 00       	mov    0x805138,%eax
  801dee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df1:	eb 56                	jmp    801e49 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801df3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801df7:	74 1c                	je     801e15 <print_mem_block_lists+0x5d>
  801df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfc:	8b 50 08             	mov    0x8(%eax),%edx
  801dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e02:	8b 48 08             	mov    0x8(%eax),%ecx
  801e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e08:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0b:	01 c8                	add    %ecx,%eax
  801e0d:	39 c2                	cmp    %eax,%edx
  801e0f:	73 04                	jae    801e15 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e11:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e18:	8b 50 08             	mov    0x8(%eax),%edx
  801e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e21:	01 c2                	add    %eax,%edx
  801e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e26:	8b 40 08             	mov    0x8(%eax),%eax
  801e29:	83 ec 04             	sub    $0x4,%esp
  801e2c:	52                   	push   %edx
  801e2d:	50                   	push   %eax
  801e2e:	68 49 3f 80 00       	push   $0x803f49
  801e33:	e8 b1 e7 ff ff       	call   8005e9 <cprintf>
  801e38:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e41:	a1 40 51 80 00       	mov    0x805140,%eax
  801e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e4d:	74 07                	je     801e56 <print_mem_block_lists+0x9e>
  801e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e52:	8b 00                	mov    (%eax),%eax
  801e54:	eb 05                	jmp    801e5b <print_mem_block_lists+0xa3>
  801e56:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5b:	a3 40 51 80 00       	mov    %eax,0x805140
  801e60:	a1 40 51 80 00       	mov    0x805140,%eax
  801e65:	85 c0                	test   %eax,%eax
  801e67:	75 8a                	jne    801df3 <print_mem_block_lists+0x3b>
  801e69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6d:	75 84                	jne    801df3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e6f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e73:	75 10                	jne    801e85 <print_mem_block_lists+0xcd>
  801e75:	83 ec 0c             	sub    $0xc,%esp
  801e78:	68 58 3f 80 00       	push   $0x803f58
  801e7d:	e8 67 e7 ff ff       	call   8005e9 <cprintf>
  801e82:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e85:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e8c:	83 ec 0c             	sub    $0xc,%esp
  801e8f:	68 7c 3f 80 00       	push   $0x803f7c
  801e94:	e8 50 e7 ff ff       	call   8005e9 <cprintf>
  801e99:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e9c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ea0:	a1 40 50 80 00       	mov    0x805040,%eax
  801ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea8:	eb 56                	jmp    801f00 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eaa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eae:	74 1c                	je     801ecc <print_mem_block_lists+0x114>
  801eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb3:	8b 50 08             	mov    0x8(%eax),%edx
  801eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb9:	8b 48 08             	mov    0x8(%eax),%ecx
  801ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec2:	01 c8                	add    %ecx,%eax
  801ec4:	39 c2                	cmp    %eax,%edx
  801ec6:	73 04                	jae    801ecc <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ec8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	8b 50 08             	mov    0x8(%eax),%edx
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed8:	01 c2                	add    %eax,%edx
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	8b 40 08             	mov    0x8(%eax),%eax
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	52                   	push   %edx
  801ee4:	50                   	push   %eax
  801ee5:	68 49 3f 80 00       	push   $0x803f49
  801eea:	e8 fa e6 ff ff       	call   8005e9 <cprintf>
  801eef:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ef8:	a1 48 50 80 00       	mov    0x805048,%eax
  801efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f04:	74 07                	je     801f0d <print_mem_block_lists+0x155>
  801f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f09:	8b 00                	mov    (%eax),%eax
  801f0b:	eb 05                	jmp    801f12 <print_mem_block_lists+0x15a>
  801f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f12:	a3 48 50 80 00       	mov    %eax,0x805048
  801f17:	a1 48 50 80 00       	mov    0x805048,%eax
  801f1c:	85 c0                	test   %eax,%eax
  801f1e:	75 8a                	jne    801eaa <print_mem_block_lists+0xf2>
  801f20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f24:	75 84                	jne    801eaa <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f26:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f2a:	75 10                	jne    801f3c <print_mem_block_lists+0x184>
  801f2c:	83 ec 0c             	sub    $0xc,%esp
  801f2f:	68 94 3f 80 00       	push   $0x803f94
  801f34:	e8 b0 e6 ff ff       	call   8005e9 <cprintf>
  801f39:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	68 08 3f 80 00       	push   $0x803f08
  801f44:	e8 a0 e6 ff ff       	call   8005e9 <cprintf>
  801f49:	83 c4 10             	add    $0x10,%esp

}
  801f4c:	90                   	nop
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f55:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f5c:	00 00 00 
  801f5f:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f66:	00 00 00 
  801f69:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f70:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f7a:	e9 9e 00 00 00       	jmp    80201d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f7f:	a1 50 50 80 00       	mov    0x805050,%eax
  801f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f87:	c1 e2 04             	shl    $0x4,%edx
  801f8a:	01 d0                	add    %edx,%eax
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	75 14                	jne    801fa4 <initialize_MemBlocksList+0x55>
  801f90:	83 ec 04             	sub    $0x4,%esp
  801f93:	68 bc 3f 80 00       	push   $0x803fbc
  801f98:	6a 46                	push   $0x46
  801f9a:	68 df 3f 80 00       	push   $0x803fdf
  801f9f:	e8 91 e3 ff ff       	call   800335 <_panic>
  801fa4:	a1 50 50 80 00       	mov    0x805050,%eax
  801fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fac:	c1 e2 04             	shl    $0x4,%edx
  801faf:	01 d0                	add    %edx,%eax
  801fb1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fb7:	89 10                	mov    %edx,(%eax)
  801fb9:	8b 00                	mov    (%eax),%eax
  801fbb:	85 c0                	test   %eax,%eax
  801fbd:	74 18                	je     801fd7 <initialize_MemBlocksList+0x88>
  801fbf:	a1 48 51 80 00       	mov    0x805148,%eax
  801fc4:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fcd:	c1 e1 04             	shl    $0x4,%ecx
  801fd0:	01 ca                	add    %ecx,%edx
  801fd2:	89 50 04             	mov    %edx,0x4(%eax)
  801fd5:	eb 12                	jmp    801fe9 <initialize_MemBlocksList+0x9a>
  801fd7:	a1 50 50 80 00       	mov    0x805050,%eax
  801fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdf:	c1 e2 04             	shl    $0x4,%edx
  801fe2:	01 d0                	add    %edx,%eax
  801fe4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801fe9:	a1 50 50 80 00       	mov    0x805050,%eax
  801fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff1:	c1 e2 04             	shl    $0x4,%edx
  801ff4:	01 d0                	add    %edx,%eax
  801ff6:	a3 48 51 80 00       	mov    %eax,0x805148
  801ffb:	a1 50 50 80 00       	mov    0x805050,%eax
  802000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802003:	c1 e2 04             	shl    $0x4,%edx
  802006:	01 d0                	add    %edx,%eax
  802008:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80200f:	a1 54 51 80 00       	mov    0x805154,%eax
  802014:	40                   	inc    %eax
  802015:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80201a:	ff 45 f4             	incl   -0xc(%ebp)
  80201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802020:	3b 45 08             	cmp    0x8(%ebp),%eax
  802023:	0f 82 56 ff ff ff    	jb     801f7f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802029:	90                   	nop
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
  80202f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	8b 00                	mov    (%eax),%eax
  802037:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80203a:	eb 19                	jmp    802055 <find_block+0x29>
	{
		if(va==point->sva)
  80203c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80203f:	8b 40 08             	mov    0x8(%eax),%eax
  802042:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802045:	75 05                	jne    80204c <find_block+0x20>
		   return point;
  802047:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204a:	eb 36                	jmp    802082 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	8b 40 08             	mov    0x8(%eax),%eax
  802052:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802055:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802059:	74 07                	je     802062 <find_block+0x36>
  80205b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205e:	8b 00                	mov    (%eax),%eax
  802060:	eb 05                	jmp    802067 <find_block+0x3b>
  802062:	b8 00 00 00 00       	mov    $0x0,%eax
  802067:	8b 55 08             	mov    0x8(%ebp),%edx
  80206a:	89 42 08             	mov    %eax,0x8(%edx)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 40 08             	mov    0x8(%eax),%eax
  802073:	85 c0                	test   %eax,%eax
  802075:	75 c5                	jne    80203c <find_block+0x10>
  802077:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80207b:	75 bf                	jne    80203c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80208a:	a1 40 50 80 00       	mov    0x805040,%eax
  80208f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802092:	a1 44 50 80 00       	mov    0x805044,%eax
  802097:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80209a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020a0:	74 24                	je     8020c6 <insert_sorted_allocList+0x42>
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8b 50 08             	mov    0x8(%eax),%edx
  8020a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ab:	8b 40 08             	mov    0x8(%eax),%eax
  8020ae:	39 c2                	cmp    %eax,%edx
  8020b0:	76 14                	jbe    8020c6 <insert_sorted_allocList+0x42>
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	8b 50 08             	mov    0x8(%eax),%edx
  8020b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020bb:	8b 40 08             	mov    0x8(%eax),%eax
  8020be:	39 c2                	cmp    %eax,%edx
  8020c0:	0f 82 60 01 00 00    	jb     802226 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ca:	75 65                	jne    802131 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020d0:	75 14                	jne    8020e6 <insert_sorted_allocList+0x62>
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	68 bc 3f 80 00       	push   $0x803fbc
  8020da:	6a 6b                	push   $0x6b
  8020dc:	68 df 3f 80 00       	push   $0x803fdf
  8020e1:	e8 4f e2 ff ff       	call   800335 <_panic>
  8020e6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	89 10                	mov    %edx,(%eax)
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 0d                	je     802107 <insert_sorted_allocList+0x83>
  8020fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8020ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802102:	89 50 04             	mov    %edx,0x4(%eax)
  802105:	eb 08                	jmp    80210f <insert_sorted_allocList+0x8b>
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	a3 44 50 80 00       	mov    %eax,0x805044
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	a3 40 50 80 00       	mov    %eax,0x805040
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802121:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802126:	40                   	inc    %eax
  802127:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80212c:	e9 dc 01 00 00       	jmp    80230d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8b 50 08             	mov    0x8(%eax),%edx
  802137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213a:	8b 40 08             	mov    0x8(%eax),%eax
  80213d:	39 c2                	cmp    %eax,%edx
  80213f:	77 6c                	ja     8021ad <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802141:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802145:	74 06                	je     80214d <insert_sorted_allocList+0xc9>
  802147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214b:	75 14                	jne    802161 <insert_sorted_allocList+0xdd>
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	68 f8 3f 80 00       	push   $0x803ff8
  802155:	6a 6f                	push   $0x6f
  802157:	68 df 3f 80 00       	push   $0x803fdf
  80215c:	e8 d4 e1 ff ff       	call   800335 <_panic>
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	8b 50 04             	mov    0x4(%eax),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	89 50 04             	mov    %edx,0x4(%eax)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802173:	89 10                	mov    %edx,(%eax)
  802175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802178:	8b 40 04             	mov    0x4(%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	74 0d                	je     80218c <insert_sorted_allocList+0x108>
  80217f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802182:	8b 40 04             	mov    0x4(%eax),%eax
  802185:	8b 55 08             	mov    0x8(%ebp),%edx
  802188:	89 10                	mov    %edx,(%eax)
  80218a:	eb 08                	jmp    802194 <insert_sorted_allocList+0x110>
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	a3 40 50 80 00       	mov    %eax,0x805040
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802197:	8b 55 08             	mov    0x8(%ebp),%edx
  80219a:	89 50 04             	mov    %edx,0x4(%eax)
  80219d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021a2:	40                   	inc    %eax
  8021a3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021a8:	e9 60 01 00 00       	jmp    80230d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	8b 50 08             	mov    0x8(%eax),%edx
  8021b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021b6:	8b 40 08             	mov    0x8(%eax),%eax
  8021b9:	39 c2                	cmp    %eax,%edx
  8021bb:	0f 82 4c 01 00 00    	jb     80230d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c5:	75 14                	jne    8021db <insert_sorted_allocList+0x157>
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	68 30 40 80 00       	push   $0x804030
  8021cf:	6a 73                	push   $0x73
  8021d1:	68 df 3f 80 00       	push   $0x803fdf
  8021d6:	e8 5a e1 ff ff       	call   800335 <_panic>
  8021db:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e4:	89 50 04             	mov    %edx,0x4(%eax)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	8b 40 04             	mov    0x4(%eax),%eax
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	74 0c                	je     8021fd <insert_sorted_allocList+0x179>
  8021f1:	a1 44 50 80 00       	mov    0x805044,%eax
  8021f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f9:	89 10                	mov    %edx,(%eax)
  8021fb:	eb 08                	jmp    802205 <insert_sorted_allocList+0x181>
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	a3 40 50 80 00       	mov    %eax,0x805040
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	a3 44 50 80 00       	mov    %eax,0x805044
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802216:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80221b:	40                   	inc    %eax
  80221c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802221:	e9 e7 00 00 00       	jmp    80230d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802229:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80222c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802233:	a1 40 50 80 00       	mov    0x805040,%eax
  802238:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223b:	e9 9d 00 00 00       	jmp    8022dd <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	8b 00                	mov    (%eax),%eax
  802245:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	8b 50 08             	mov    0x8(%eax),%edx
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	8b 40 08             	mov    0x8(%eax),%eax
  802254:	39 c2                	cmp    %eax,%edx
  802256:	76 7d                	jbe    8022d5 <insert_sorted_allocList+0x251>
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	8b 50 08             	mov    0x8(%eax),%edx
  80225e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802261:	8b 40 08             	mov    0x8(%eax),%eax
  802264:	39 c2                	cmp    %eax,%edx
  802266:	73 6d                	jae    8022d5 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226c:	74 06                	je     802274 <insert_sorted_allocList+0x1f0>
  80226e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802272:	75 14                	jne    802288 <insert_sorted_allocList+0x204>
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	68 54 40 80 00       	push   $0x804054
  80227c:	6a 7f                	push   $0x7f
  80227e:	68 df 3f 80 00       	push   $0x803fdf
  802283:	e8 ad e0 ff ff       	call   800335 <_panic>
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	8b 10                	mov    (%eax),%edx
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	89 10                	mov    %edx,(%eax)
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	8b 00                	mov    (%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 0b                	je     8022a6 <insert_sorted_allocList+0x222>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a3:	89 50 04             	mov    %edx,0x4(%eax)
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b4:	89 50 04             	mov    %edx,0x4(%eax)
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	8b 00                	mov    (%eax),%eax
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	75 08                	jne    8022c8 <insert_sorted_allocList+0x244>
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	a3 44 50 80 00       	mov    %eax,0x805044
  8022c8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022cd:	40                   	inc    %eax
  8022ce:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022d3:	eb 39                	jmp    80230e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022d5:	a1 48 50 80 00       	mov    0x805048,%eax
  8022da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e1:	74 07                	je     8022ea <insert_sorted_allocList+0x266>
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 00                	mov    (%eax),%eax
  8022e8:	eb 05                	jmp    8022ef <insert_sorted_allocList+0x26b>
  8022ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ef:	a3 48 50 80 00       	mov    %eax,0x805048
  8022f4:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	0f 85 3f ff ff ff    	jne    802240 <insert_sorted_allocList+0x1bc>
  802301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802305:	0f 85 35 ff ff ff    	jne    802240 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80230b:	eb 01                	jmp    80230e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80230d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80230e:	90                   	nop
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802317:	a1 38 51 80 00       	mov    0x805138,%eax
  80231c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231f:	e9 85 01 00 00       	jmp    8024a9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802327:	8b 40 0c             	mov    0xc(%eax),%eax
  80232a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80232d:	0f 82 6e 01 00 00    	jb     8024a1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 40 0c             	mov    0xc(%eax),%eax
  802339:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233c:	0f 85 8a 00 00 00    	jne    8023cc <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802346:	75 17                	jne    80235f <alloc_block_FF+0x4e>
  802348:	83 ec 04             	sub    $0x4,%esp
  80234b:	68 88 40 80 00       	push   $0x804088
  802350:	68 93 00 00 00       	push   $0x93
  802355:	68 df 3f 80 00       	push   $0x803fdf
  80235a:	e8 d6 df ff ff       	call   800335 <_panic>
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 00                	mov    (%eax),%eax
  802364:	85 c0                	test   %eax,%eax
  802366:	74 10                	je     802378 <alloc_block_FF+0x67>
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 00                	mov    (%eax),%eax
  80236d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802370:	8b 52 04             	mov    0x4(%edx),%edx
  802373:	89 50 04             	mov    %edx,0x4(%eax)
  802376:	eb 0b                	jmp    802383 <alloc_block_FF+0x72>
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 40 04             	mov    0x4(%eax),%eax
  80237e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 40 04             	mov    0x4(%eax),%eax
  802389:	85 c0                	test   %eax,%eax
  80238b:	74 0f                	je     80239c <alloc_block_FF+0x8b>
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 40 04             	mov    0x4(%eax),%eax
  802393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802396:	8b 12                	mov    (%edx),%edx
  802398:	89 10                	mov    %edx,(%eax)
  80239a:	eb 0a                	jmp    8023a6 <alloc_block_FF+0x95>
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 00                	mov    (%eax),%eax
  8023a1:	a3 38 51 80 00       	mov    %eax,0x805138
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b9:	a1 44 51 80 00       	mov    0x805144,%eax
  8023be:	48                   	dec    %eax
  8023bf:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	e9 10 01 00 00       	jmp    8024dc <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d5:	0f 86 c6 00 00 00    	jbe    8024a1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023db:	a1 48 51 80 00       	mov    0x805148,%eax
  8023e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 50 08             	mov    0x8(%eax),%edx
  8023e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ec:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023fc:	75 17                	jne    802415 <alloc_block_FF+0x104>
  8023fe:	83 ec 04             	sub    $0x4,%esp
  802401:	68 88 40 80 00       	push   $0x804088
  802406:	68 9b 00 00 00       	push   $0x9b
  80240b:	68 df 3f 80 00       	push   $0x803fdf
  802410:	e8 20 df ff ff       	call   800335 <_panic>
  802415:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	74 10                	je     80242e <alloc_block_FF+0x11d>
  80241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802421:	8b 00                	mov    (%eax),%eax
  802423:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802426:	8b 52 04             	mov    0x4(%edx),%edx
  802429:	89 50 04             	mov    %edx,0x4(%eax)
  80242c:	eb 0b                	jmp    802439 <alloc_block_FF+0x128>
  80242e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802431:	8b 40 04             	mov    0x4(%eax),%eax
  802434:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	8b 40 04             	mov    0x4(%eax),%eax
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 0f                	je     802452 <alloc_block_FF+0x141>
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	8b 40 04             	mov    0x4(%eax),%eax
  802449:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80244c:	8b 12                	mov    (%edx),%edx
  80244e:	89 10                	mov    %edx,(%eax)
  802450:	eb 0a                	jmp    80245c <alloc_block_FF+0x14b>
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	a3 48 51 80 00       	mov    %eax,0x805148
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246f:	a1 54 51 80 00       	mov    0x805154,%eax
  802474:	48                   	dec    %eax
  802475:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 50 08             	mov    0x8(%eax),%edx
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	01 c2                	add    %eax,%edx
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 0c             	mov    0xc(%eax),%eax
  802491:	2b 45 08             	sub    0x8(%ebp),%eax
  802494:	89 c2                	mov    %eax,%edx
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80249c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249f:	eb 3b                	jmp    8024dc <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024a1:	a1 40 51 80 00       	mov    0x805140,%eax
  8024a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ad:	74 07                	je     8024b6 <alloc_block_FF+0x1a5>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	eb 05                	jmp    8024bb <alloc_block_FF+0x1aa>
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024bb:	a3 40 51 80 00       	mov    %eax,0x805140
  8024c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	0f 85 57 fe ff ff    	jne    802324 <alloc_block_FF+0x13>
  8024cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d1:	0f 85 4d fe ff ff    	jne    802324 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8024f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f3:	e9 df 00 00 00       	jmp    8025d7 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802501:	0f 82 c8 00 00 00    	jb     8025cf <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802510:	0f 85 8a 00 00 00    	jne    8025a0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251a:	75 17                	jne    802533 <alloc_block_BF+0x55>
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	68 88 40 80 00       	push   $0x804088
  802524:	68 b7 00 00 00       	push   $0xb7
  802529:	68 df 3f 80 00       	push   $0x803fdf
  80252e:	e8 02 de ff ff       	call   800335 <_panic>
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 00                	mov    (%eax),%eax
  802538:	85 c0                	test   %eax,%eax
  80253a:	74 10                	je     80254c <alloc_block_BF+0x6e>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802544:	8b 52 04             	mov    0x4(%edx),%edx
  802547:	89 50 04             	mov    %edx,0x4(%eax)
  80254a:	eb 0b                	jmp    802557 <alloc_block_BF+0x79>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 40 04             	mov    0x4(%eax),%eax
  802552:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 04             	mov    0x4(%eax),%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	74 0f                	je     802570 <alloc_block_BF+0x92>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256a:	8b 12                	mov    (%edx),%edx
  80256c:	89 10                	mov    %edx,(%eax)
  80256e:	eb 0a                	jmp    80257a <alloc_block_BF+0x9c>
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 00                	mov    (%eax),%eax
  802575:	a3 38 51 80 00       	mov    %eax,0x805138
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258d:	a1 44 51 80 00       	mov    0x805144,%eax
  802592:	48                   	dec    %eax
  802593:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	e9 4d 01 00 00       	jmp    8026ed <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a9:	76 24                	jbe    8025cf <alloc_block_BF+0xf1>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025b4:	73 19                	jae    8025cf <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025b6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 08             	mov    0x8(%eax),%eax
  8025cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025cf:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025db:	74 07                	je     8025e4 <alloc_block_BF+0x106>
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	eb 05                	jmp    8025e9 <alloc_block_BF+0x10b>
  8025e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e9:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	0f 85 fd fe ff ff    	jne    8024f8 <alloc_block_BF+0x1a>
  8025fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ff:	0f 85 f3 fe ff ff    	jne    8024f8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802605:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802609:	0f 84 d9 00 00 00    	je     8026e8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80260f:	a1 48 51 80 00       	mov    0x805148,%eax
  802614:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80261d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802623:	8b 55 08             	mov    0x8(%ebp),%edx
  802626:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802629:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80262d:	75 17                	jne    802646 <alloc_block_BF+0x168>
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	68 88 40 80 00       	push   $0x804088
  802637:	68 c7 00 00 00       	push   $0xc7
  80263c:	68 df 3f 80 00       	push   $0x803fdf
  802641:	e8 ef dc ff ff       	call   800335 <_panic>
  802646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	74 10                	je     80265f <alloc_block_BF+0x181>
  80264f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802657:	8b 52 04             	mov    0x4(%edx),%edx
  80265a:	89 50 04             	mov    %edx,0x4(%eax)
  80265d:	eb 0b                	jmp    80266a <alloc_block_BF+0x18c>
  80265f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80266a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266d:	8b 40 04             	mov    0x4(%eax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 0f                	je     802683 <alloc_block_BF+0x1a5>
  802674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80267d:	8b 12                	mov    (%edx),%edx
  80267f:	89 10                	mov    %edx,(%eax)
  802681:	eb 0a                	jmp    80268d <alloc_block_BF+0x1af>
  802683:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	a3 48 51 80 00       	mov    %eax,0x805148
  80268d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802699:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8026a5:	48                   	dec    %eax
  8026a6:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026ab:	83 ec 08             	sub    $0x8,%esp
  8026ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8026b1:	68 38 51 80 00       	push   $0x805138
  8026b6:	e8 71 f9 ff ff       	call   80202c <find_block>
  8026bb:	83 c4 10             	add    $0x10,%esp
  8026be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c4:	8b 50 08             	mov    0x8(%eax),%edx
  8026c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ca:	01 c2                	add    %eax,%edx
  8026cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cf:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8026db:	89 c2                	mov    %eax,%edx
  8026dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e6:	eb 05                	jmp    8026ed <alloc_block_BF+0x20f>
	}
	return NULL;
  8026e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026f5:	a1 28 50 80 00       	mov    0x805028,%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	0f 85 de 01 00 00    	jne    8028e0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802702:	a1 38 51 80 00       	mov    0x805138,%eax
  802707:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270a:	e9 9e 01 00 00       	jmp    8028ad <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 0c             	mov    0xc(%eax),%eax
  802715:	3b 45 08             	cmp    0x8(%ebp),%eax
  802718:	0f 82 87 01 00 00    	jb     8028a5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 0c             	mov    0xc(%eax),%eax
  802724:	3b 45 08             	cmp    0x8(%ebp),%eax
  802727:	0f 85 95 00 00 00    	jne    8027c2 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80272d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802731:	75 17                	jne    80274a <alloc_block_NF+0x5b>
  802733:	83 ec 04             	sub    $0x4,%esp
  802736:	68 88 40 80 00       	push   $0x804088
  80273b:	68 e0 00 00 00       	push   $0xe0
  802740:	68 df 3f 80 00       	push   $0x803fdf
  802745:	e8 eb db ff ff       	call   800335 <_panic>
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	74 10                	je     802763 <alloc_block_NF+0x74>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275b:	8b 52 04             	mov    0x4(%edx),%edx
  80275e:	89 50 04             	mov    %edx,0x4(%eax)
  802761:	eb 0b                	jmp    80276e <alloc_block_NF+0x7f>
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 40 04             	mov    0x4(%eax),%eax
  802769:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	74 0f                	je     802787 <alloc_block_NF+0x98>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802781:	8b 12                	mov    (%edx),%edx
  802783:	89 10                	mov    %edx,(%eax)
  802785:	eb 0a                	jmp    802791 <alloc_block_NF+0xa2>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	a3 38 51 80 00       	mov    %eax,0x805138
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8027a9:	48                   	dec    %eax
  8027aa:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 08             	mov    0x8(%eax),%eax
  8027b5:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	e9 f8 04 00 00       	jmp    802cba <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027cb:	0f 86 d4 00 00 00    	jbe    8028a5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8027d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 50 08             	mov    0x8(%eax),%edx
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027eb:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027f2:	75 17                	jne    80280b <alloc_block_NF+0x11c>
  8027f4:	83 ec 04             	sub    $0x4,%esp
  8027f7:	68 88 40 80 00       	push   $0x804088
  8027fc:	68 e9 00 00 00       	push   $0xe9
  802801:	68 df 3f 80 00       	push   $0x803fdf
  802806:	e8 2a db ff ff       	call   800335 <_panic>
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	74 10                	je     802824 <alloc_block_NF+0x135>
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80281c:	8b 52 04             	mov    0x4(%edx),%edx
  80281f:	89 50 04             	mov    %edx,0x4(%eax)
  802822:	eb 0b                	jmp    80282f <alloc_block_NF+0x140>
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	8b 40 04             	mov    0x4(%eax),%eax
  80282a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80282f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802832:	8b 40 04             	mov    0x4(%eax),%eax
  802835:	85 c0                	test   %eax,%eax
  802837:	74 0f                	je     802848 <alloc_block_NF+0x159>
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802842:	8b 12                	mov    (%edx),%edx
  802844:	89 10                	mov    %edx,(%eax)
  802846:	eb 0a                	jmp    802852 <alloc_block_NF+0x163>
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	a3 48 51 80 00       	mov    %eax,0x805148
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802865:	a1 54 51 80 00       	mov    0x805154,%eax
  80286a:	48                   	dec    %eax
  80286b:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802870:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802873:	8b 40 08             	mov    0x8(%eax),%eax
  802876:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 50 08             	mov    0x8(%eax),%edx
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	01 c2                	add    %eax,%edx
  802886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802889:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	2b 45 08             	sub    0x8(%ebp),%eax
  802895:	89 c2                	mov    %eax,%edx
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80289d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a0:	e9 15 04 00 00       	jmp    802cba <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028a5:	a1 40 51 80 00       	mov    0x805140,%eax
  8028aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b1:	74 07                	je     8028ba <alloc_block_NF+0x1cb>
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 00                	mov    (%eax),%eax
  8028b8:	eb 05                	jmp    8028bf <alloc_block_NF+0x1d0>
  8028ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8028bf:	a3 40 51 80 00       	mov    %eax,0x805140
  8028c4:	a1 40 51 80 00       	mov    0x805140,%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	0f 85 3e fe ff ff    	jne    80270f <alloc_block_NF+0x20>
  8028d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d5:	0f 85 34 fe ff ff    	jne    80270f <alloc_block_NF+0x20>
  8028db:	e9 d5 03 00 00       	jmp    802cb5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8028e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e8:	e9 b1 01 00 00       	jmp    802a9e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 50 08             	mov    0x8(%eax),%edx
  8028f3:	a1 28 50 80 00       	mov    0x805028,%eax
  8028f8:	39 c2                	cmp    %eax,%edx
  8028fa:	0f 82 96 01 00 00    	jb     802a96 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 0c             	mov    0xc(%eax),%eax
  802906:	3b 45 08             	cmp    0x8(%ebp),%eax
  802909:	0f 82 87 01 00 00    	jb     802a96 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 40 0c             	mov    0xc(%eax),%eax
  802915:	3b 45 08             	cmp    0x8(%ebp),%eax
  802918:	0f 85 95 00 00 00    	jne    8029b3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80291e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802922:	75 17                	jne    80293b <alloc_block_NF+0x24c>
  802924:	83 ec 04             	sub    $0x4,%esp
  802927:	68 88 40 80 00       	push   $0x804088
  80292c:	68 fc 00 00 00       	push   $0xfc
  802931:	68 df 3f 80 00       	push   $0x803fdf
  802936:	e8 fa d9 ff ff       	call   800335 <_panic>
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	85 c0                	test   %eax,%eax
  802942:	74 10                	je     802954 <alloc_block_NF+0x265>
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294c:	8b 52 04             	mov    0x4(%edx),%edx
  80294f:	89 50 04             	mov    %edx,0x4(%eax)
  802952:	eb 0b                	jmp    80295f <alloc_block_NF+0x270>
  802954:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802957:	8b 40 04             	mov    0x4(%eax),%eax
  80295a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 40 04             	mov    0x4(%eax),%eax
  802965:	85 c0                	test   %eax,%eax
  802967:	74 0f                	je     802978 <alloc_block_NF+0x289>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 40 04             	mov    0x4(%eax),%eax
  80296f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802972:	8b 12                	mov    (%edx),%edx
  802974:	89 10                	mov    %edx,(%eax)
  802976:	eb 0a                	jmp    802982 <alloc_block_NF+0x293>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	a3 38 51 80 00       	mov    %eax,0x805138
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802995:	a1 44 51 80 00       	mov    0x805144,%eax
  80299a:	48                   	dec    %eax
  80299b:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 40 08             	mov    0x8(%eax),%eax
  8029a6:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	e9 07 03 00 00       	jmp    802cba <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029bc:	0f 86 d4 00 00 00    	jbe    802a96 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8029c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 50 08             	mov    0x8(%eax),%edx
  8029d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029dc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029e3:	75 17                	jne    8029fc <alloc_block_NF+0x30d>
  8029e5:	83 ec 04             	sub    $0x4,%esp
  8029e8:	68 88 40 80 00       	push   $0x804088
  8029ed:	68 04 01 00 00       	push   $0x104
  8029f2:	68 df 3f 80 00       	push   $0x803fdf
  8029f7:	e8 39 d9 ff ff       	call   800335 <_panic>
  8029fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	74 10                	je     802a15 <alloc_block_NF+0x326>
  802a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a0d:	8b 52 04             	mov    0x4(%edx),%edx
  802a10:	89 50 04             	mov    %edx,0x4(%eax)
  802a13:	eb 0b                	jmp    802a20 <alloc_block_NF+0x331>
  802a15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a23:	8b 40 04             	mov    0x4(%eax),%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	74 0f                	je     802a39 <alloc_block_NF+0x34a>
  802a2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2d:	8b 40 04             	mov    0x4(%eax),%eax
  802a30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a33:	8b 12                	mov    (%edx),%edx
  802a35:	89 10                	mov    %edx,(%eax)
  802a37:	eb 0a                	jmp    802a43 <alloc_block_NF+0x354>
  802a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3c:	8b 00                	mov    (%eax),%eax
  802a3e:	a3 48 51 80 00       	mov    %eax,0x805148
  802a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a56:	a1 54 51 80 00       	mov    0x805154,%eax
  802a5b:	48                   	dec    %eax
  802a5c:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a64:	8b 40 08             	mov    0x8(%eax),%eax
  802a67:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 50 08             	mov    0x8(%eax),%edx
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	01 c2                	add    %eax,%edx
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 0c             	mov    0xc(%eax),%eax
  802a83:	2b 45 08             	sub    0x8(%ebp),%eax
  802a86:	89 c2                	mov    %eax,%edx
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a91:	e9 24 02 00 00       	jmp    802cba <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a96:	a1 40 51 80 00       	mov    0x805140,%eax
  802a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa2:	74 07                	je     802aab <alloc_block_NF+0x3bc>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	eb 05                	jmp    802ab0 <alloc_block_NF+0x3c1>
  802aab:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab0:	a3 40 51 80 00       	mov    %eax,0x805140
  802ab5:	a1 40 51 80 00       	mov    0x805140,%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	0f 85 2b fe ff ff    	jne    8028ed <alloc_block_NF+0x1fe>
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	0f 85 21 fe ff ff    	jne    8028ed <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802acc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad4:	e9 ae 01 00 00       	jmp    802c87 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 50 08             	mov    0x8(%eax),%edx
  802adf:	a1 28 50 80 00       	mov    0x805028,%eax
  802ae4:	39 c2                	cmp    %eax,%edx
  802ae6:	0f 83 93 01 00 00    	jae    802c7f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 0c             	mov    0xc(%eax),%eax
  802af2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802af5:	0f 82 84 01 00 00    	jb     802c7f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	8b 40 0c             	mov    0xc(%eax),%eax
  802b01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b04:	0f 85 95 00 00 00    	jne    802b9f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0e:	75 17                	jne    802b27 <alloc_block_NF+0x438>
  802b10:	83 ec 04             	sub    $0x4,%esp
  802b13:	68 88 40 80 00       	push   $0x804088
  802b18:	68 14 01 00 00       	push   $0x114
  802b1d:	68 df 3f 80 00       	push   $0x803fdf
  802b22:	e8 0e d8 ff ff       	call   800335 <_panic>
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 00                	mov    (%eax),%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	74 10                	je     802b40 <alloc_block_NF+0x451>
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b38:	8b 52 04             	mov    0x4(%edx),%edx
  802b3b:	89 50 04             	mov    %edx,0x4(%eax)
  802b3e:	eb 0b                	jmp    802b4b <alloc_block_NF+0x45c>
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 40 04             	mov    0x4(%eax),%eax
  802b51:	85 c0                	test   %eax,%eax
  802b53:	74 0f                	je     802b64 <alloc_block_NF+0x475>
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5e:	8b 12                	mov    (%edx),%edx
  802b60:	89 10                	mov    %edx,(%eax)
  802b62:	eb 0a                	jmp    802b6e <alloc_block_NF+0x47f>
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	a3 38 51 80 00       	mov    %eax,0x805138
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b81:	a1 44 51 80 00       	mov    0x805144,%eax
  802b86:	48                   	dec    %eax
  802b87:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 40 08             	mov    0x8(%eax),%eax
  802b92:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	e9 1b 01 00 00       	jmp    802cba <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba8:	0f 86 d1 00 00 00    	jbe    802c7f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bae:	a1 48 51 80 00       	mov    0x805148,%eax
  802bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bcf:	75 17                	jne    802be8 <alloc_block_NF+0x4f9>
  802bd1:	83 ec 04             	sub    $0x4,%esp
  802bd4:	68 88 40 80 00       	push   $0x804088
  802bd9:	68 1c 01 00 00       	push   $0x11c
  802bde:	68 df 3f 80 00       	push   $0x803fdf
  802be3:	e8 4d d7 ff ff       	call   800335 <_panic>
  802be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	85 c0                	test   %eax,%eax
  802bef:	74 10                	je     802c01 <alloc_block_NF+0x512>
  802bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf9:	8b 52 04             	mov    0x4(%edx),%edx
  802bfc:	89 50 04             	mov    %edx,0x4(%eax)
  802bff:	eb 0b                	jmp    802c0c <alloc_block_NF+0x51d>
  802c01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c04:	8b 40 04             	mov    0x4(%eax),%eax
  802c07:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0f:	8b 40 04             	mov    0x4(%eax),%eax
  802c12:	85 c0                	test   %eax,%eax
  802c14:	74 0f                	je     802c25 <alloc_block_NF+0x536>
  802c16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c19:	8b 40 04             	mov    0x4(%eax),%eax
  802c1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c1f:	8b 12                	mov    (%edx),%edx
  802c21:	89 10                	mov    %edx,(%eax)
  802c23:	eb 0a                	jmp    802c2f <alloc_block_NF+0x540>
  802c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	a3 48 51 80 00       	mov    %eax,0x805148
  802c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c42:	a1 54 51 80 00       	mov    0x805154,%eax
  802c47:	48                   	dec    %eax
  802c48:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c50:	8b 40 08             	mov    0x8(%eax),%eax
  802c53:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	8b 50 08             	mov    0x8(%eax),%edx
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	01 c2                	add    %eax,%edx
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6f:	2b 45 08             	sub    0x8(%ebp),%eax
  802c72:	89 c2                	mov    %eax,%edx
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7d:	eb 3b                	jmp    802cba <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c7f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	74 07                	je     802c94 <alloc_block_NF+0x5a5>
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 00                	mov    (%eax),%eax
  802c92:	eb 05                	jmp    802c99 <alloc_block_NF+0x5aa>
  802c94:	b8 00 00 00 00       	mov    $0x0,%eax
  802c99:	a3 40 51 80 00       	mov    %eax,0x805140
  802c9e:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca3:	85 c0                	test   %eax,%eax
  802ca5:	0f 85 2e fe ff ff    	jne    802ad9 <alloc_block_NF+0x3ea>
  802cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802caf:	0f 85 24 fe ff ff    	jne    802ad9 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cba:	c9                   	leave  
  802cbb:	c3                   	ret    

00802cbc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cbc:	55                   	push   %ebp
  802cbd:	89 e5                	mov    %esp,%ebp
  802cbf:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cc2:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cca:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ccf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cd2:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 14                	je     802cef <insert_sorted_with_merge_freeList+0x33>
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 50 08             	mov    0x8(%eax),%edx
  802ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce4:	8b 40 08             	mov    0x8(%eax),%eax
  802ce7:	39 c2                	cmp    %eax,%edx
  802ce9:	0f 87 9b 01 00 00    	ja     802e8a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf3:	75 17                	jne    802d0c <insert_sorted_with_merge_freeList+0x50>
  802cf5:	83 ec 04             	sub    $0x4,%esp
  802cf8:	68 bc 3f 80 00       	push   $0x803fbc
  802cfd:	68 38 01 00 00       	push   $0x138
  802d02:	68 df 3f 80 00       	push   $0x803fdf
  802d07:	e8 29 d6 ff ff       	call   800335 <_panic>
  802d0c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	89 10                	mov    %edx,(%eax)
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	8b 00                	mov    (%eax),%eax
  802d1c:	85 c0                	test   %eax,%eax
  802d1e:	74 0d                	je     802d2d <insert_sorted_with_merge_freeList+0x71>
  802d20:	a1 38 51 80 00       	mov    0x805138,%eax
  802d25:	8b 55 08             	mov    0x8(%ebp),%edx
  802d28:	89 50 04             	mov    %edx,0x4(%eax)
  802d2b:	eb 08                	jmp    802d35 <insert_sorted_with_merge_freeList+0x79>
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d47:	a1 44 51 80 00       	mov    0x805144,%eax
  802d4c:	40                   	inc    %eax
  802d4d:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d56:	0f 84 a8 06 00 00    	je     803404 <insert_sorted_with_merge_freeList+0x748>
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	8b 50 08             	mov    0x8(%eax),%edx
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	8b 40 0c             	mov    0xc(%eax),%eax
  802d68:	01 c2                	add    %eax,%edx
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 40 08             	mov    0x8(%eax),%eax
  802d70:	39 c2                	cmp    %eax,%edx
  802d72:	0f 85 8c 06 00 00    	jne    803404 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d81:	8b 40 0c             	mov    0xc(%eax),%eax
  802d84:	01 c2                	add    %eax,%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d90:	75 17                	jne    802da9 <insert_sorted_with_merge_freeList+0xed>
  802d92:	83 ec 04             	sub    $0x4,%esp
  802d95:	68 88 40 80 00       	push   $0x804088
  802d9a:	68 3c 01 00 00       	push   $0x13c
  802d9f:	68 df 3f 80 00       	push   $0x803fdf
  802da4:	e8 8c d5 ff ff       	call   800335 <_panic>
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	74 10                	je     802dc2 <insert_sorted_with_merge_freeList+0x106>
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	8b 00                	mov    (%eax),%eax
  802db7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dba:	8b 52 04             	mov    0x4(%edx),%edx
  802dbd:	89 50 04             	mov    %edx,0x4(%eax)
  802dc0:	eb 0b                	jmp    802dcd <insert_sorted_with_merge_freeList+0x111>
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	8b 40 04             	mov    0x4(%eax),%eax
  802dc8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd0:	8b 40 04             	mov    0x4(%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 0f                	je     802de6 <insert_sorted_with_merge_freeList+0x12a>
  802dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dda:	8b 40 04             	mov    0x4(%eax),%eax
  802ddd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802de0:	8b 12                	mov    (%edx),%edx
  802de2:	89 10                	mov    %edx,(%eax)
  802de4:	eb 0a                	jmp    802df0 <insert_sorted_with_merge_freeList+0x134>
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	8b 00                	mov    (%eax),%eax
  802deb:	a3 38 51 80 00       	mov    %eax,0x805138
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e03:	a1 44 51 80 00       	mov    0x805144,%eax
  802e08:	48                   	dec    %eax
  802e09:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e26:	75 17                	jne    802e3f <insert_sorted_with_merge_freeList+0x183>
  802e28:	83 ec 04             	sub    $0x4,%esp
  802e2b:	68 bc 3f 80 00       	push   $0x803fbc
  802e30:	68 3f 01 00 00       	push   $0x13f
  802e35:	68 df 3f 80 00       	push   $0x803fdf
  802e3a:	e8 f6 d4 ff ff       	call   800335 <_panic>
  802e3f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	89 10                	mov    %edx,(%eax)
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	85 c0                	test   %eax,%eax
  802e51:	74 0d                	je     802e60 <insert_sorted_with_merge_freeList+0x1a4>
  802e53:	a1 48 51 80 00       	mov    0x805148,%eax
  802e58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e5b:	89 50 04             	mov    %edx,0x4(%eax)
  802e5e:	eb 08                	jmp    802e68 <insert_sorted_with_merge_freeList+0x1ac>
  802e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e63:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6b:	a3 48 51 80 00       	mov    %eax,0x805148
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e7f:	40                   	inc    %eax
  802e80:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e85:	e9 7a 05 00 00       	jmp    803404 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	8b 50 08             	mov    0x8(%eax),%edx
  802e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e93:	8b 40 08             	mov    0x8(%eax),%eax
  802e96:	39 c2                	cmp    %eax,%edx
  802e98:	0f 82 14 01 00 00    	jb     802fb2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea1:	8b 50 08             	mov    0x8(%eax),%edx
  802ea4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaa:	01 c2                	add    %eax,%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 40 08             	mov    0x8(%eax),%eax
  802eb2:	39 c2                	cmp    %eax,%edx
  802eb4:	0f 85 90 00 00 00    	jne    802f4a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802eba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ebd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec6:	01 c2                	add    %eax,%edx
  802ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ecb:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802ee2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee6:	75 17                	jne    802eff <insert_sorted_with_merge_freeList+0x243>
  802ee8:	83 ec 04             	sub    $0x4,%esp
  802eeb:	68 bc 3f 80 00       	push   $0x803fbc
  802ef0:	68 49 01 00 00       	push   $0x149
  802ef5:	68 df 3f 80 00       	push   $0x803fdf
  802efa:	e8 36 d4 ff ff       	call   800335 <_panic>
  802eff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f05:	8b 45 08             	mov    0x8(%ebp),%eax
  802f08:	89 10                	mov    %edx,(%eax)
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	8b 00                	mov    (%eax),%eax
  802f0f:	85 c0                	test   %eax,%eax
  802f11:	74 0d                	je     802f20 <insert_sorted_with_merge_freeList+0x264>
  802f13:	a1 48 51 80 00       	mov    0x805148,%eax
  802f18:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1b:	89 50 04             	mov    %edx,0x4(%eax)
  802f1e:	eb 08                	jmp    802f28 <insert_sorted_with_merge_freeList+0x26c>
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	a3 48 51 80 00       	mov    %eax,0x805148
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f3f:	40                   	inc    %eax
  802f40:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f45:	e9 bb 04 00 00       	jmp    803405 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4e:	75 17                	jne    802f67 <insert_sorted_with_merge_freeList+0x2ab>
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	68 30 40 80 00       	push   $0x804030
  802f58:	68 4c 01 00 00       	push   $0x14c
  802f5d:	68 df 3f 80 00       	push   $0x803fdf
  802f62:	e8 ce d3 ff ff       	call   800335 <_panic>
  802f67:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	89 50 04             	mov    %edx,0x4(%eax)
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 40 04             	mov    0x4(%eax),%eax
  802f79:	85 c0                	test   %eax,%eax
  802f7b:	74 0c                	je     802f89 <insert_sorted_with_merge_freeList+0x2cd>
  802f7d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f82:	8b 55 08             	mov    0x8(%ebp),%edx
  802f85:	89 10                	mov    %edx,(%eax)
  802f87:	eb 08                	jmp    802f91 <insert_sorted_with_merge_freeList+0x2d5>
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa2:	a1 44 51 80 00       	mov    0x805144,%eax
  802fa7:	40                   	inc    %eax
  802fa8:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fad:	e9 53 04 00 00       	jmp    803405 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fb2:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fba:	e9 15 04 00 00       	jmp    8033d4 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	8b 50 08             	mov    0x8(%eax),%edx
  802fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd0:	8b 40 08             	mov    0x8(%eax),%eax
  802fd3:	39 c2                	cmp    %eax,%edx
  802fd5:	0f 86 f1 03 00 00    	jbe    8033cc <insert_sorted_with_merge_freeList+0x710>
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	8b 50 08             	mov    0x8(%eax),%edx
  802fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe4:	8b 40 08             	mov    0x8(%eax),%eax
  802fe7:	39 c2                	cmp    %eax,%edx
  802fe9:	0f 83 dd 03 00 00    	jae    8033cc <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 50 08             	mov    0x8(%eax),%edx
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffb:	01 c2                	add    %eax,%edx
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	8b 40 08             	mov    0x8(%eax),%eax
  803003:	39 c2                	cmp    %eax,%edx
  803005:	0f 85 b9 01 00 00    	jne    8031c4 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	8b 50 08             	mov    0x8(%eax),%edx
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 40 0c             	mov    0xc(%eax),%eax
  803017:	01 c2                	add    %eax,%edx
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	8b 40 08             	mov    0x8(%eax),%eax
  80301f:	39 c2                	cmp    %eax,%edx
  803021:	0f 85 0d 01 00 00    	jne    803134 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 50 0c             	mov    0xc(%eax),%edx
  80302d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803030:	8b 40 0c             	mov    0xc(%eax),%eax
  803033:	01 c2                	add    %eax,%edx
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80303b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80303f:	75 17                	jne    803058 <insert_sorted_with_merge_freeList+0x39c>
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	68 88 40 80 00       	push   $0x804088
  803049:	68 5c 01 00 00       	push   $0x15c
  80304e:	68 df 3f 80 00       	push   $0x803fdf
  803053:	e8 dd d2 ff ff       	call   800335 <_panic>
  803058:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	74 10                	je     803071 <insert_sorted_with_merge_freeList+0x3b5>
  803061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803064:	8b 00                	mov    (%eax),%eax
  803066:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803069:	8b 52 04             	mov    0x4(%edx),%edx
  80306c:	89 50 04             	mov    %edx,0x4(%eax)
  80306f:	eb 0b                	jmp    80307c <insert_sorted_with_merge_freeList+0x3c0>
  803071:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80307c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307f:	8b 40 04             	mov    0x4(%eax),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	74 0f                	je     803095 <insert_sorted_with_merge_freeList+0x3d9>
  803086:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803089:	8b 40 04             	mov    0x4(%eax),%eax
  80308c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308f:	8b 12                	mov    (%edx),%edx
  803091:	89 10                	mov    %edx,(%eax)
  803093:	eb 0a                	jmp    80309f <insert_sorted_with_merge_freeList+0x3e3>
  803095:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803098:	8b 00                	mov    (%eax),%eax
  80309a:	a3 38 51 80 00       	mov    %eax,0x805138
  80309f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030b7:	48                   	dec    %eax
  8030b8:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d5:	75 17                	jne    8030ee <insert_sorted_with_merge_freeList+0x432>
  8030d7:	83 ec 04             	sub    $0x4,%esp
  8030da:	68 bc 3f 80 00       	push   $0x803fbc
  8030df:	68 5f 01 00 00       	push   $0x15f
  8030e4:	68 df 3f 80 00       	push   $0x803fdf
  8030e9:	e8 47 d2 ff ff       	call   800335 <_panic>
  8030ee:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	89 10                	mov    %edx,(%eax)
  8030f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	85 c0                	test   %eax,%eax
  803100:	74 0d                	je     80310f <insert_sorted_with_merge_freeList+0x453>
  803102:	a1 48 51 80 00       	mov    0x805148,%eax
  803107:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	eb 08                	jmp    803117 <insert_sorted_with_merge_freeList+0x45b>
  80310f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803112:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311a:	a3 48 51 80 00       	mov    %eax,0x805148
  80311f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803122:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803129:	a1 54 51 80 00       	mov    0x805154,%eax
  80312e:	40                   	inc    %eax
  80312f:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803134:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803137:	8b 50 0c             	mov    0xc(%eax),%edx
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	8b 40 0c             	mov    0xc(%eax),%eax
  803140:	01 c2                	add    %eax,%edx
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80315c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803160:	75 17                	jne    803179 <insert_sorted_with_merge_freeList+0x4bd>
  803162:	83 ec 04             	sub    $0x4,%esp
  803165:	68 bc 3f 80 00       	push   $0x803fbc
  80316a:	68 64 01 00 00       	push   $0x164
  80316f:	68 df 3f 80 00       	push   $0x803fdf
  803174:	e8 bc d1 ff ff       	call   800335 <_panic>
  803179:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	89 10                	mov    %edx,(%eax)
  803184:	8b 45 08             	mov    0x8(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	85 c0                	test   %eax,%eax
  80318b:	74 0d                	je     80319a <insert_sorted_with_merge_freeList+0x4de>
  80318d:	a1 48 51 80 00       	mov    0x805148,%eax
  803192:	8b 55 08             	mov    0x8(%ebp),%edx
  803195:	89 50 04             	mov    %edx,0x4(%eax)
  803198:	eb 08                	jmp    8031a2 <insert_sorted_with_merge_freeList+0x4e6>
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b9:	40                   	inc    %eax
  8031ba:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031bf:	e9 41 02 00 00       	jmp    803405 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d0:	01 c2                	add    %eax,%edx
  8031d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d5:	8b 40 08             	mov    0x8(%eax),%eax
  8031d8:	39 c2                	cmp    %eax,%edx
  8031da:	0f 85 7c 01 00 00    	jne    80335c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e4:	74 06                	je     8031ec <insert_sorted_with_merge_freeList+0x530>
  8031e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ea:	75 17                	jne    803203 <insert_sorted_with_merge_freeList+0x547>
  8031ec:	83 ec 04             	sub    $0x4,%esp
  8031ef:	68 f8 3f 80 00       	push   $0x803ff8
  8031f4:	68 69 01 00 00       	push   $0x169
  8031f9:	68 df 3f 80 00       	push   $0x803fdf
  8031fe:	e8 32 d1 ff ff       	call   800335 <_panic>
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	8b 50 04             	mov    0x4(%eax),%edx
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	89 50 04             	mov    %edx,0x4(%eax)
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803215:	89 10                	mov    %edx,(%eax)
  803217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321a:	8b 40 04             	mov    0x4(%eax),%eax
  80321d:	85 c0                	test   %eax,%eax
  80321f:	74 0d                	je     80322e <insert_sorted_with_merge_freeList+0x572>
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	8b 55 08             	mov    0x8(%ebp),%edx
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	eb 08                	jmp    803236 <insert_sorted_with_merge_freeList+0x57a>
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	a3 38 51 80 00       	mov    %eax,0x805138
  803236:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803239:	8b 55 08             	mov    0x8(%ebp),%edx
  80323c:	89 50 04             	mov    %edx,0x4(%eax)
  80323f:	a1 44 51 80 00       	mov    0x805144,%eax
  803244:	40                   	inc    %eax
  803245:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80324a:	8b 45 08             	mov    0x8(%ebp),%eax
  80324d:	8b 50 0c             	mov    0xc(%eax),%edx
  803250:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803253:	8b 40 0c             	mov    0xc(%eax),%eax
  803256:	01 c2                	add    %eax,%edx
  803258:	8b 45 08             	mov    0x8(%ebp),%eax
  80325b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80325e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803262:	75 17                	jne    80327b <insert_sorted_with_merge_freeList+0x5bf>
  803264:	83 ec 04             	sub    $0x4,%esp
  803267:	68 88 40 80 00       	push   $0x804088
  80326c:	68 6b 01 00 00       	push   $0x16b
  803271:	68 df 3f 80 00       	push   $0x803fdf
  803276:	e8 ba d0 ff ff       	call   800335 <_panic>
  80327b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327e:	8b 00                	mov    (%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 10                	je     803294 <insert_sorted_with_merge_freeList+0x5d8>
  803284:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803287:	8b 00                	mov    (%eax),%eax
  803289:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80328c:	8b 52 04             	mov    0x4(%edx),%edx
  80328f:	89 50 04             	mov    %edx,0x4(%eax)
  803292:	eb 0b                	jmp    80329f <insert_sorted_with_merge_freeList+0x5e3>
  803294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803297:	8b 40 04             	mov    0x4(%eax),%eax
  80329a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80329f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a2:	8b 40 04             	mov    0x4(%eax),%eax
  8032a5:	85 c0                	test   %eax,%eax
  8032a7:	74 0f                	je     8032b8 <insert_sorted_with_merge_freeList+0x5fc>
  8032a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032b2:	8b 12                	mov    (%edx),%edx
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	eb 0a                	jmp    8032c2 <insert_sorted_with_merge_freeList+0x606>
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032da:	48                   	dec    %eax
  8032db:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032f8:	75 17                	jne    803311 <insert_sorted_with_merge_freeList+0x655>
  8032fa:	83 ec 04             	sub    $0x4,%esp
  8032fd:	68 bc 3f 80 00       	push   $0x803fbc
  803302:	68 6e 01 00 00       	push   $0x16e
  803307:	68 df 3f 80 00       	push   $0x803fdf
  80330c:	e8 24 d0 ff ff       	call   800335 <_panic>
  803311:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331a:	89 10                	mov    %edx,(%eax)
  80331c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	85 c0                	test   %eax,%eax
  803323:	74 0d                	je     803332 <insert_sorted_with_merge_freeList+0x676>
  803325:	a1 48 51 80 00       	mov    0x805148,%eax
  80332a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332d:	89 50 04             	mov    %edx,0x4(%eax)
  803330:	eb 08                	jmp    80333a <insert_sorted_with_merge_freeList+0x67e>
  803332:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803335:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333d:	a3 48 51 80 00       	mov    %eax,0x805148
  803342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803345:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334c:	a1 54 51 80 00       	mov    0x805154,%eax
  803351:	40                   	inc    %eax
  803352:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803357:	e9 a9 00 00 00       	jmp    803405 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80335c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803360:	74 06                	je     803368 <insert_sorted_with_merge_freeList+0x6ac>
  803362:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803366:	75 17                	jne    80337f <insert_sorted_with_merge_freeList+0x6c3>
  803368:	83 ec 04             	sub    $0x4,%esp
  80336b:	68 54 40 80 00       	push   $0x804054
  803370:	68 73 01 00 00       	push   $0x173
  803375:	68 df 3f 80 00       	push   $0x803fdf
  80337a:	e8 b6 cf ff ff       	call   800335 <_panic>
  80337f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803382:	8b 10                	mov    (%eax),%edx
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	89 10                	mov    %edx,(%eax)
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	8b 00                	mov    (%eax),%eax
  80338e:	85 c0                	test   %eax,%eax
  803390:	74 0b                	je     80339d <insert_sorted_with_merge_freeList+0x6e1>
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	8b 55 08             	mov    0x8(%ebp),%edx
  80339a:	89 50 04             	mov    %edx,0x4(%eax)
  80339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a3:	89 10                	mov    %edx,(%eax)
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033ab:	89 50 04             	mov    %edx,0x4(%eax)
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	85 c0                	test   %eax,%eax
  8033b5:	75 08                	jne    8033bf <insert_sorted_with_merge_freeList+0x703>
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c4:	40                   	inc    %eax
  8033c5:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033ca:	eb 39                	jmp    803405 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033cc:	a1 40 51 80 00       	mov    0x805140,%eax
  8033d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d8:	74 07                	je     8033e1 <insert_sorted_with_merge_freeList+0x725>
  8033da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033dd:	8b 00                	mov    (%eax),%eax
  8033df:	eb 05                	jmp    8033e6 <insert_sorted_with_merge_freeList+0x72a>
  8033e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8033e6:	a3 40 51 80 00       	mov    %eax,0x805140
  8033eb:	a1 40 51 80 00       	mov    0x805140,%eax
  8033f0:	85 c0                	test   %eax,%eax
  8033f2:	0f 85 c7 fb ff ff    	jne    802fbf <insert_sorted_with_merge_freeList+0x303>
  8033f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fc:	0f 85 bd fb ff ff    	jne    802fbf <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803402:	eb 01                	jmp    803405 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803404:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803405:	90                   	nop
  803406:	c9                   	leave  
  803407:	c3                   	ret    

00803408 <__udivdi3>:
  803408:	55                   	push   %ebp
  803409:	57                   	push   %edi
  80340a:	56                   	push   %esi
  80340b:	53                   	push   %ebx
  80340c:	83 ec 1c             	sub    $0x1c,%esp
  80340f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803413:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80341f:	89 ca                	mov    %ecx,%edx
  803421:	89 f8                	mov    %edi,%eax
  803423:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803427:	85 f6                	test   %esi,%esi
  803429:	75 2d                	jne    803458 <__udivdi3+0x50>
  80342b:	39 cf                	cmp    %ecx,%edi
  80342d:	77 65                	ja     803494 <__udivdi3+0x8c>
  80342f:	89 fd                	mov    %edi,%ebp
  803431:	85 ff                	test   %edi,%edi
  803433:	75 0b                	jne    803440 <__udivdi3+0x38>
  803435:	b8 01 00 00 00       	mov    $0x1,%eax
  80343a:	31 d2                	xor    %edx,%edx
  80343c:	f7 f7                	div    %edi
  80343e:	89 c5                	mov    %eax,%ebp
  803440:	31 d2                	xor    %edx,%edx
  803442:	89 c8                	mov    %ecx,%eax
  803444:	f7 f5                	div    %ebp
  803446:	89 c1                	mov    %eax,%ecx
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	f7 f5                	div    %ebp
  80344c:	89 cf                	mov    %ecx,%edi
  80344e:	89 fa                	mov    %edi,%edx
  803450:	83 c4 1c             	add    $0x1c,%esp
  803453:	5b                   	pop    %ebx
  803454:	5e                   	pop    %esi
  803455:	5f                   	pop    %edi
  803456:	5d                   	pop    %ebp
  803457:	c3                   	ret    
  803458:	39 ce                	cmp    %ecx,%esi
  80345a:	77 28                	ja     803484 <__udivdi3+0x7c>
  80345c:	0f bd fe             	bsr    %esi,%edi
  80345f:	83 f7 1f             	xor    $0x1f,%edi
  803462:	75 40                	jne    8034a4 <__udivdi3+0x9c>
  803464:	39 ce                	cmp    %ecx,%esi
  803466:	72 0a                	jb     803472 <__udivdi3+0x6a>
  803468:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80346c:	0f 87 9e 00 00 00    	ja     803510 <__udivdi3+0x108>
  803472:	b8 01 00 00 00       	mov    $0x1,%eax
  803477:	89 fa                	mov    %edi,%edx
  803479:	83 c4 1c             	add    $0x1c,%esp
  80347c:	5b                   	pop    %ebx
  80347d:	5e                   	pop    %esi
  80347e:	5f                   	pop    %edi
  80347f:	5d                   	pop    %ebp
  803480:	c3                   	ret    
  803481:	8d 76 00             	lea    0x0(%esi),%esi
  803484:	31 ff                	xor    %edi,%edi
  803486:	31 c0                	xor    %eax,%eax
  803488:	89 fa                	mov    %edi,%edx
  80348a:	83 c4 1c             	add    $0x1c,%esp
  80348d:	5b                   	pop    %ebx
  80348e:	5e                   	pop    %esi
  80348f:	5f                   	pop    %edi
  803490:	5d                   	pop    %ebp
  803491:	c3                   	ret    
  803492:	66 90                	xchg   %ax,%ax
  803494:	89 d8                	mov    %ebx,%eax
  803496:	f7 f7                	div    %edi
  803498:	31 ff                	xor    %edi,%edi
  80349a:	89 fa                	mov    %edi,%edx
  80349c:	83 c4 1c             	add    $0x1c,%esp
  80349f:	5b                   	pop    %ebx
  8034a0:	5e                   	pop    %esi
  8034a1:	5f                   	pop    %edi
  8034a2:	5d                   	pop    %ebp
  8034a3:	c3                   	ret    
  8034a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034a9:	89 eb                	mov    %ebp,%ebx
  8034ab:	29 fb                	sub    %edi,%ebx
  8034ad:	89 f9                	mov    %edi,%ecx
  8034af:	d3 e6                	shl    %cl,%esi
  8034b1:	89 c5                	mov    %eax,%ebp
  8034b3:	88 d9                	mov    %bl,%cl
  8034b5:	d3 ed                	shr    %cl,%ebp
  8034b7:	89 e9                	mov    %ebp,%ecx
  8034b9:	09 f1                	or     %esi,%ecx
  8034bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034bf:	89 f9                	mov    %edi,%ecx
  8034c1:	d3 e0                	shl    %cl,%eax
  8034c3:	89 c5                	mov    %eax,%ebp
  8034c5:	89 d6                	mov    %edx,%esi
  8034c7:	88 d9                	mov    %bl,%cl
  8034c9:	d3 ee                	shr    %cl,%esi
  8034cb:	89 f9                	mov    %edi,%ecx
  8034cd:	d3 e2                	shl    %cl,%edx
  8034cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d3:	88 d9                	mov    %bl,%cl
  8034d5:	d3 e8                	shr    %cl,%eax
  8034d7:	09 c2                	or     %eax,%edx
  8034d9:	89 d0                	mov    %edx,%eax
  8034db:	89 f2                	mov    %esi,%edx
  8034dd:	f7 74 24 0c          	divl   0xc(%esp)
  8034e1:	89 d6                	mov    %edx,%esi
  8034e3:	89 c3                	mov    %eax,%ebx
  8034e5:	f7 e5                	mul    %ebp
  8034e7:	39 d6                	cmp    %edx,%esi
  8034e9:	72 19                	jb     803504 <__udivdi3+0xfc>
  8034eb:	74 0b                	je     8034f8 <__udivdi3+0xf0>
  8034ed:	89 d8                	mov    %ebx,%eax
  8034ef:	31 ff                	xor    %edi,%edi
  8034f1:	e9 58 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034fc:	89 f9                	mov    %edi,%ecx
  8034fe:	d3 e2                	shl    %cl,%edx
  803500:	39 c2                	cmp    %eax,%edx
  803502:	73 e9                	jae    8034ed <__udivdi3+0xe5>
  803504:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803507:	31 ff                	xor    %edi,%edi
  803509:	e9 40 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  80350e:	66 90                	xchg   %ax,%ax
  803510:	31 c0                	xor    %eax,%eax
  803512:	e9 37 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  803517:	90                   	nop

00803518 <__umoddi3>:
  803518:	55                   	push   %ebp
  803519:	57                   	push   %edi
  80351a:	56                   	push   %esi
  80351b:	53                   	push   %ebx
  80351c:	83 ec 1c             	sub    $0x1c,%esp
  80351f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803523:	8b 74 24 34          	mov    0x34(%esp),%esi
  803527:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80352b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80352f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803533:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803537:	89 f3                	mov    %esi,%ebx
  803539:	89 fa                	mov    %edi,%edx
  80353b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353f:	89 34 24             	mov    %esi,(%esp)
  803542:	85 c0                	test   %eax,%eax
  803544:	75 1a                	jne    803560 <__umoddi3+0x48>
  803546:	39 f7                	cmp    %esi,%edi
  803548:	0f 86 a2 00 00 00    	jbe    8035f0 <__umoddi3+0xd8>
  80354e:	89 c8                	mov    %ecx,%eax
  803550:	89 f2                	mov    %esi,%edx
  803552:	f7 f7                	div    %edi
  803554:	89 d0                	mov    %edx,%eax
  803556:	31 d2                	xor    %edx,%edx
  803558:	83 c4 1c             	add    $0x1c,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5e                   	pop    %esi
  80355d:	5f                   	pop    %edi
  80355e:	5d                   	pop    %ebp
  80355f:	c3                   	ret    
  803560:	39 f0                	cmp    %esi,%eax
  803562:	0f 87 ac 00 00 00    	ja     803614 <__umoddi3+0xfc>
  803568:	0f bd e8             	bsr    %eax,%ebp
  80356b:	83 f5 1f             	xor    $0x1f,%ebp
  80356e:	0f 84 ac 00 00 00    	je     803620 <__umoddi3+0x108>
  803574:	bf 20 00 00 00       	mov    $0x20,%edi
  803579:	29 ef                	sub    %ebp,%edi
  80357b:	89 fe                	mov    %edi,%esi
  80357d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803581:	89 e9                	mov    %ebp,%ecx
  803583:	d3 e0                	shl    %cl,%eax
  803585:	89 d7                	mov    %edx,%edi
  803587:	89 f1                	mov    %esi,%ecx
  803589:	d3 ef                	shr    %cl,%edi
  80358b:	09 c7                	or     %eax,%edi
  80358d:	89 e9                	mov    %ebp,%ecx
  80358f:	d3 e2                	shl    %cl,%edx
  803591:	89 14 24             	mov    %edx,(%esp)
  803594:	89 d8                	mov    %ebx,%eax
  803596:	d3 e0                	shl    %cl,%eax
  803598:	89 c2                	mov    %eax,%edx
  80359a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359e:	d3 e0                	shl    %cl,%eax
  8035a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a8:	89 f1                	mov    %esi,%ecx
  8035aa:	d3 e8                	shr    %cl,%eax
  8035ac:	09 d0                	or     %edx,%eax
  8035ae:	d3 eb                	shr    %cl,%ebx
  8035b0:	89 da                	mov    %ebx,%edx
  8035b2:	f7 f7                	div    %edi
  8035b4:	89 d3                	mov    %edx,%ebx
  8035b6:	f7 24 24             	mull   (%esp)
  8035b9:	89 c6                	mov    %eax,%esi
  8035bb:	89 d1                	mov    %edx,%ecx
  8035bd:	39 d3                	cmp    %edx,%ebx
  8035bf:	0f 82 87 00 00 00    	jb     80364c <__umoddi3+0x134>
  8035c5:	0f 84 91 00 00 00    	je     80365c <__umoddi3+0x144>
  8035cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035cf:	29 f2                	sub    %esi,%edx
  8035d1:	19 cb                	sbb    %ecx,%ebx
  8035d3:	89 d8                	mov    %ebx,%eax
  8035d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035d9:	d3 e0                	shl    %cl,%eax
  8035db:	89 e9                	mov    %ebp,%ecx
  8035dd:	d3 ea                	shr    %cl,%edx
  8035df:	09 d0                	or     %edx,%eax
  8035e1:	89 e9                	mov    %ebp,%ecx
  8035e3:	d3 eb                	shr    %cl,%ebx
  8035e5:	89 da                	mov    %ebx,%edx
  8035e7:	83 c4 1c             	add    $0x1c,%esp
  8035ea:	5b                   	pop    %ebx
  8035eb:	5e                   	pop    %esi
  8035ec:	5f                   	pop    %edi
  8035ed:	5d                   	pop    %ebp
  8035ee:	c3                   	ret    
  8035ef:	90                   	nop
  8035f0:	89 fd                	mov    %edi,%ebp
  8035f2:	85 ff                	test   %edi,%edi
  8035f4:	75 0b                	jne    803601 <__umoddi3+0xe9>
  8035f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fb:	31 d2                	xor    %edx,%edx
  8035fd:	f7 f7                	div    %edi
  8035ff:	89 c5                	mov    %eax,%ebp
  803601:	89 f0                	mov    %esi,%eax
  803603:	31 d2                	xor    %edx,%edx
  803605:	f7 f5                	div    %ebp
  803607:	89 c8                	mov    %ecx,%eax
  803609:	f7 f5                	div    %ebp
  80360b:	89 d0                	mov    %edx,%eax
  80360d:	e9 44 ff ff ff       	jmp    803556 <__umoddi3+0x3e>
  803612:	66 90                	xchg   %ax,%ax
  803614:	89 c8                	mov    %ecx,%eax
  803616:	89 f2                	mov    %esi,%edx
  803618:	83 c4 1c             	add    $0x1c,%esp
  80361b:	5b                   	pop    %ebx
  80361c:	5e                   	pop    %esi
  80361d:	5f                   	pop    %edi
  80361e:	5d                   	pop    %ebp
  80361f:	c3                   	ret    
  803620:	3b 04 24             	cmp    (%esp),%eax
  803623:	72 06                	jb     80362b <__umoddi3+0x113>
  803625:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803629:	77 0f                	ja     80363a <__umoddi3+0x122>
  80362b:	89 f2                	mov    %esi,%edx
  80362d:	29 f9                	sub    %edi,%ecx
  80362f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803633:	89 14 24             	mov    %edx,(%esp)
  803636:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80363e:	8b 14 24             	mov    (%esp),%edx
  803641:	83 c4 1c             	add    $0x1c,%esp
  803644:	5b                   	pop    %ebx
  803645:	5e                   	pop    %esi
  803646:	5f                   	pop    %edi
  803647:	5d                   	pop    %ebp
  803648:	c3                   	ret    
  803649:	8d 76 00             	lea    0x0(%esi),%esi
  80364c:	2b 04 24             	sub    (%esp),%eax
  80364f:	19 fa                	sbb    %edi,%edx
  803651:	89 d1                	mov    %edx,%ecx
  803653:	89 c6                	mov    %eax,%esi
  803655:	e9 71 ff ff ff       	jmp    8035cb <__umoddi3+0xb3>
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803660:	72 ea                	jb     80364c <__umoddi3+0x134>
  803662:	89 d9                	mov    %ebx,%ecx
  803664:	e9 62 ff ff ff       	jmp    8035cb <__umoddi3+0xb3>
