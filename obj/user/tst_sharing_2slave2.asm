
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
  800031:	e8 b6 01 00 00       	call   8001ec <libmain>
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
  80004c:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800075:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80008d:	68 80 1d 80 00       	push   $0x801d80
  800092:	6a 13                	push   $0x13
  800094:	68 9c 1d 80 00       	push   $0x801d9c
  800099:	e8 8a 02 00 00       	call   800328 <_panic>
	}

	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 e5 17 00 00       	call   801888 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 d1 15 00 00       	call   80167c <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 df 14 00 00       	call   80158f <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 b7 1d 80 00       	push   $0x801db7
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 38 13 00 00       	call   8013fb <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 bc 1d 80 00       	push   $0x801dbc
  8000da:	6a 1e                	push   $0x1e
  8000dc:	68 9c 1d 80 00       	push   $0x801d9c
  8000e1:	e8 42 02 00 00       	call   800328 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 a1 14 00 00       	call   80158f <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 1c 1e 80 00       	push   $0x801e1c
  8000ff:	6a 1f                	push   $0x1f
  800101:	68 9c 1d 80 00       	push   $0x801d9c
  800106:	e8 1d 02 00 00       	call   800328 <_panic>
	sys_enable_interrupt();
  80010b:	e8 86 15 00 00       	call   801696 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 67 15 00 00       	call   80167c <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 75 14 00 00       	call   80158f <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 ad 1e 80 00       	push   $0x801ead
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 ce 12 00 00       	call   8013fb <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 bc 1d 80 00       	push   $0x801dbc
  800144:	6a 25                	push   $0x25
  800146:	68 9c 1d 80 00       	push   $0x801d9c
  80014b:	e8 d8 01 00 00       	call   800328 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 3a 14 00 00       	call   80158f <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 1c 1e 80 00       	push   $0x801e1c
  800166:	6a 26                	push   $0x26
  800168:	68 9c 1d 80 00       	push   $0x801d9c
  80016d:	e8 b6 01 00 00       	call   800328 <_panic>
	sys_enable_interrupt();
  800172:	e8 1f 15 00 00       	call   801696 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 0a             	cmp    $0xa,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 b0 1e 80 00       	push   $0x801eb0
  800189:	6a 29                	push   $0x29
  80018b:	68 9c 1d 80 00       	push   $0x801d9c
  800190:	e8 93 01 00 00       	call   800328 <_panic>

	//Edit the writable object
	*z = 30;
  800195:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800198:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80019e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a1:	8b 00                	mov    (%eax),%eax
  8001a3:	83 f8 1e             	cmp    $0x1e,%eax
  8001a6:	74 14                	je     8001bc <_main+0x184>
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	68 b0 1e 80 00       	push   $0x801eb0
  8001b0:	6a 2d                	push   $0x2d
  8001b2:	68 9c 1d 80 00       	push   $0x801d9c
  8001b7:	e8 6c 01 00 00       	call   800328 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001bc:	83 ec 08             	sub    $0x8,%esp
  8001bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8001c2:	68 e8 1e 80 00       	push   $0x801ee8
  8001c7:	e8 10 04 00 00       	call   8005dc <cprintf>
  8001cc:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d2:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 18 1f 80 00       	push   $0x801f18
  8001e0:	6a 33                	push   $0x33
  8001e2:	68 9c 1d 80 00       	push   $0x801d9c
  8001e7:	e8 3c 01 00 00       	call   800328 <_panic>

008001ec <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f2:	e8 78 16 00 00       	call   80186f <sys_getenvindex>
  8001f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fd:	89 d0                	mov    %edx,%eax
  8001ff:	c1 e0 03             	shl    $0x3,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	01 c0                	add    %eax,%eax
  800206:	01 d0                	add    %edx,%eax
  800208:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020f:	01 d0                	add    %edx,%eax
  800211:	c1 e0 04             	shl    $0x4,%eax
  800214:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800219:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021e:	a1 20 30 80 00       	mov    0x803020,%eax
  800223:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800229:	84 c0                	test   %al,%al
  80022b:	74 0f                	je     80023c <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022d:	a1 20 30 80 00       	mov    0x803020,%eax
  800232:	05 5c 05 00 00       	add    $0x55c,%eax
  800237:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800240:	7e 0a                	jle    80024c <libmain+0x60>
		binaryname = argv[0];
  800242:	8b 45 0c             	mov    0xc(%ebp),%eax
  800245:	8b 00                	mov    (%eax),%eax
  800247:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80024c:	83 ec 08             	sub    $0x8,%esp
  80024f:	ff 75 0c             	pushl  0xc(%ebp)
  800252:	ff 75 08             	pushl  0x8(%ebp)
  800255:	e8 de fd ff ff       	call   800038 <_main>
  80025a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025d:	e8 1a 14 00 00       	call   80167c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 74 1f 80 00       	push   $0x801f74
  80026a:	e8 6d 03 00 00       	call   8005dc <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800272:	a1 20 30 80 00       	mov    0x803020,%eax
  800277:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027d:	a1 20 30 80 00       	mov    0x803020,%eax
  800282:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800288:	83 ec 04             	sub    $0x4,%esp
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 9c 1f 80 00       	push   $0x801f9c
  800292:	e8 45 03 00 00       	call   8005dc <cprintf>
  800297:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80029a:	a1 20 30 80 00       	mov    0x803020,%eax
  80029f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002aa:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8002b5:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002bb:	51                   	push   %ecx
  8002bc:	52                   	push   %edx
  8002bd:	50                   	push   %eax
  8002be:	68 c4 1f 80 00       	push   $0x801fc4
  8002c3:	e8 14 03 00 00       	call   8005dc <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002cb:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d0:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d6:	83 ec 08             	sub    $0x8,%esp
  8002d9:	50                   	push   %eax
  8002da:	68 1c 20 80 00       	push   $0x80201c
  8002df:	e8 f8 02 00 00       	call   8005dc <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 74 1f 80 00       	push   $0x801f74
  8002ef:	e8 e8 02 00 00       	call   8005dc <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f7:	e8 9a 13 00 00       	call   801696 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002fc:	e8 19 00 00 00       	call   80031a <exit>
}
  800301:	90                   	nop
  800302:	c9                   	leave  
  800303:	c3                   	ret    

00800304 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	6a 00                	push   $0x0
  80030f:	e8 27 15 00 00       	call   80183b <sys_destroy_env>
  800314:	83 c4 10             	add    $0x10,%esp
}
  800317:	90                   	nop
  800318:	c9                   	leave  
  800319:	c3                   	ret    

0080031a <exit>:

void
exit(void)
{
  80031a:	55                   	push   %ebp
  80031b:	89 e5                	mov    %esp,%ebp
  80031d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800320:	e8 7c 15 00 00       	call   8018a1 <sys_exit_env>
}
  800325:	90                   	nop
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032e:	8d 45 10             	lea    0x10(%ebp),%eax
  800331:	83 c0 04             	add    $0x4,%eax
  800334:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800337:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80033c:	85 c0                	test   %eax,%eax
  80033e:	74 16                	je     800356 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800340:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800345:	83 ec 08             	sub    $0x8,%esp
  800348:	50                   	push   %eax
  800349:	68 30 20 80 00       	push   $0x802030
  80034e:	e8 89 02 00 00       	call   8005dc <cprintf>
  800353:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800356:	a1 00 30 80 00       	mov    0x803000,%eax
  80035b:	ff 75 0c             	pushl  0xc(%ebp)
  80035e:	ff 75 08             	pushl  0x8(%ebp)
  800361:	50                   	push   %eax
  800362:	68 35 20 80 00       	push   $0x802035
  800367:	e8 70 02 00 00       	call   8005dc <cprintf>
  80036c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036f:	8b 45 10             	mov    0x10(%ebp),%eax
  800372:	83 ec 08             	sub    $0x8,%esp
  800375:	ff 75 f4             	pushl  -0xc(%ebp)
  800378:	50                   	push   %eax
  800379:	e8 f3 01 00 00       	call   800571 <vcprintf>
  80037e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800381:	83 ec 08             	sub    $0x8,%esp
  800384:	6a 00                	push   $0x0
  800386:	68 51 20 80 00       	push   $0x802051
  80038b:	e8 e1 01 00 00       	call   800571 <vcprintf>
  800390:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800393:	e8 82 ff ff ff       	call   80031a <exit>

	// should not return here
	while (1) ;
  800398:	eb fe                	jmp    800398 <_panic+0x70>

0080039a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a5:	8b 50 74             	mov    0x74(%eax),%edx
  8003a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	74 14                	je     8003c3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003af:	83 ec 04             	sub    $0x4,%esp
  8003b2:	68 54 20 80 00       	push   $0x802054
  8003b7:	6a 26                	push   $0x26
  8003b9:	68 a0 20 80 00       	push   $0x8020a0
  8003be:	e8 65 ff ff ff       	call   800328 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d1:	e9 c2 00 00 00       	jmp    800498 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e3:	01 d0                	add    %edx,%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	85 c0                	test   %eax,%eax
  8003e9:	75 08                	jne    8003f3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003eb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ee:	e9 a2 00 00 00       	jmp    800495 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800401:	eb 69                	jmp    80046c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800403:	a1 20 30 80 00       	mov    0x803020,%eax
  800408:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800411:	89 d0                	mov    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 03             	shl    $0x3,%eax
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	8a 40 04             	mov    0x4(%eax),%al
  80041f:	84 c0                	test   %al,%al
  800421:	75 46                	jne    800469 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800423:	a1 20 30 80 00       	mov    0x803020,%eax
  800428:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80042e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800431:	89 d0                	mov    %edx,%eax
  800433:	01 c0                	add    %eax,%eax
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 03             	shl    $0x3,%eax
  80043a:	01 c8                	add    %ecx,%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800441:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800444:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800449:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80044b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	01 c8                	add    %ecx,%eax
  80045a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045c:	39 c2                	cmp    %eax,%edx
  80045e:	75 09                	jne    800469 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800460:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800467:	eb 12                	jmp    80047b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800469:	ff 45 e8             	incl   -0x18(%ebp)
  80046c:	a1 20 30 80 00       	mov    0x803020,%eax
  800471:	8b 50 74             	mov    0x74(%eax),%edx
  800474:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	77 88                	ja     800403 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80047b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047f:	75 14                	jne    800495 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800481:	83 ec 04             	sub    $0x4,%esp
  800484:	68 ac 20 80 00       	push   $0x8020ac
  800489:	6a 3a                	push   $0x3a
  80048b:	68 a0 20 80 00       	push   $0x8020a0
  800490:	e8 93 fe ff ff       	call   800328 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800495:	ff 45 f0             	incl   -0x10(%ebp)
  800498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049e:	0f 8c 32 ff ff ff    	jl     8003d6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b2:	eb 26                	jmp    8004da <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004b9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c2:	89 d0                	mov    %edx,%eax
  8004c4:	01 c0                	add    %eax,%eax
  8004c6:	01 d0                	add    %edx,%eax
  8004c8:	c1 e0 03             	shl    $0x3,%eax
  8004cb:	01 c8                	add    %ecx,%eax
  8004cd:	8a 40 04             	mov    0x4(%eax),%al
  8004d0:	3c 01                	cmp    $0x1,%al
  8004d2:	75 03                	jne    8004d7 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d7:	ff 45 e0             	incl   -0x20(%ebp)
  8004da:	a1 20 30 80 00       	mov    0x803020,%eax
  8004df:	8b 50 74             	mov    0x74(%eax),%edx
  8004e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e5:	39 c2                	cmp    %eax,%edx
  8004e7:	77 cb                	ja     8004b4 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ec:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ef:	74 14                	je     800505 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	68 00 21 80 00       	push   $0x802100
  8004f9:	6a 44                	push   $0x44
  8004fb:	68 a0 20 80 00       	push   $0x8020a0
  800500:	e8 23 fe ff ff       	call   800328 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800505:	90                   	nop
  800506:	c9                   	leave  
  800507:	c3                   	ret    

00800508 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800508:	55                   	push   %ebp
  800509:	89 e5                	mov    %esp,%ebp
  80050b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	8d 48 01             	lea    0x1(%eax),%ecx
  800516:	8b 55 0c             	mov    0xc(%ebp),%edx
  800519:	89 0a                	mov    %ecx,(%edx)
  80051b:	8b 55 08             	mov    0x8(%ebp),%edx
  80051e:	88 d1                	mov    %dl,%cl
  800520:	8b 55 0c             	mov    0xc(%ebp),%edx
  800523:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800531:	75 2c                	jne    80055f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800533:	a0 24 30 80 00       	mov    0x803024,%al
  800538:	0f b6 c0             	movzbl %al,%eax
  80053b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053e:	8b 12                	mov    (%edx),%edx
  800540:	89 d1                	mov    %edx,%ecx
  800542:	8b 55 0c             	mov    0xc(%ebp),%edx
  800545:	83 c2 08             	add    $0x8,%edx
  800548:	83 ec 04             	sub    $0x4,%esp
  80054b:	50                   	push   %eax
  80054c:	51                   	push   %ecx
  80054d:	52                   	push   %edx
  80054e:	e8 7b 0f 00 00       	call   8014ce <sys_cputs>
  800553:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800562:	8b 40 04             	mov    0x4(%eax),%eax
  800565:	8d 50 01             	lea    0x1(%eax),%edx
  800568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056e:	90                   	nop
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800581:	00 00 00 
	b.cnt = 0;
  800584:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80058b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058e:	ff 75 0c             	pushl  0xc(%ebp)
  800591:	ff 75 08             	pushl  0x8(%ebp)
  800594:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059a:	50                   	push   %eax
  80059b:	68 08 05 80 00       	push   $0x800508
  8005a0:	e8 11 02 00 00       	call   8007b6 <vprintfmt>
  8005a5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a8:	a0 24 30 80 00       	mov    0x803024,%al
  8005ad:	0f b6 c0             	movzbl %al,%eax
  8005b0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	50                   	push   %eax
  8005ba:	52                   	push   %edx
  8005bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c1:	83 c0 08             	add    $0x8,%eax
  8005c4:	50                   	push   %eax
  8005c5:	e8 04 0f 00 00       	call   8014ce <sys_cputs>
  8005ca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cd:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8005d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <cprintf>:

int cprintf(const char *fmt, ...) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e2:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8005e9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f8:	50                   	push   %eax
  8005f9:	e8 73 ff ff ff       	call   800571 <vcprintf>
  8005fe:	83 c4 10             	add    $0x10,%esp
  800601:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800604:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800607:	c9                   	leave  
  800608:	c3                   	ret    

00800609 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800609:	55                   	push   %ebp
  80060a:	89 e5                	mov    %esp,%ebp
  80060c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060f:	e8 68 10 00 00       	call   80167c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800614:	8d 45 0c             	lea    0xc(%ebp),%eax
  800617:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	ff 75 f4             	pushl  -0xc(%ebp)
  800623:	50                   	push   %eax
  800624:	e8 48 ff ff ff       	call   800571 <vcprintf>
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80062f:	e8 62 10 00 00       	call   801696 <sys_enable_interrupt>
	return cnt;
  800634:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
  80063c:	53                   	push   %ebx
  80063d:	83 ec 14             	sub    $0x14,%esp
  800640:	8b 45 10             	mov    0x10(%ebp),%eax
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800646:	8b 45 14             	mov    0x14(%ebp),%eax
  800649:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064c:	8b 45 18             	mov    0x18(%ebp),%eax
  80064f:	ba 00 00 00 00       	mov    $0x0,%edx
  800654:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800657:	77 55                	ja     8006ae <printnum+0x75>
  800659:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065c:	72 05                	jb     800663 <printnum+0x2a>
  80065e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800661:	77 4b                	ja     8006ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800663:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800666:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800669:	8b 45 18             	mov    0x18(%ebp),%eax
  80066c:	ba 00 00 00 00       	mov    $0x0,%edx
  800671:	52                   	push   %edx
  800672:	50                   	push   %eax
  800673:	ff 75 f4             	pushl  -0xc(%ebp)
  800676:	ff 75 f0             	pushl  -0x10(%ebp)
  800679:	e8 86 14 00 00       	call   801b04 <__udivdi3>
  80067e:	83 c4 10             	add    $0x10,%esp
  800681:	83 ec 04             	sub    $0x4,%esp
  800684:	ff 75 20             	pushl  0x20(%ebp)
  800687:	53                   	push   %ebx
  800688:	ff 75 18             	pushl  0x18(%ebp)
  80068b:	52                   	push   %edx
  80068c:	50                   	push   %eax
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 08             	pushl  0x8(%ebp)
  800693:	e8 a1 ff ff ff       	call   800639 <printnum>
  800698:	83 c4 20             	add    $0x20,%esp
  80069b:	eb 1a                	jmp    8006b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	ff 75 20             	pushl  0x20(%ebp)
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	ff d0                	call   *%eax
  8006ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8006b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b5:	7f e6                	jg     80069d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c5:	53                   	push   %ebx
  8006c6:	51                   	push   %ecx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	e8 46 15 00 00       	call   801c14 <__umoddi3>
  8006ce:	83 c4 10             	add    $0x10,%esp
  8006d1:	05 74 23 80 00       	add    $0x802374,%eax
  8006d6:	8a 00                	mov    (%eax),%al
  8006d8:	0f be c0             	movsbl %al,%eax
  8006db:	83 ec 08             	sub    $0x8,%esp
  8006de:	ff 75 0c             	pushl  0xc(%ebp)
  8006e1:	50                   	push   %eax
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	ff d0                	call   *%eax
  8006e7:	83 c4 10             	add    $0x10,%esp
}
  8006ea:	90                   	nop
  8006eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f7:	7e 1c                	jle    800715 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	8b 00                	mov    (%eax),%eax
  8006fe:	8d 50 08             	lea    0x8(%eax),%edx
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	89 10                	mov    %edx,(%eax)
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	83 e8 08             	sub    $0x8,%eax
  80070e:	8b 50 04             	mov    0x4(%eax),%edx
  800711:	8b 00                	mov    (%eax),%eax
  800713:	eb 40                	jmp    800755 <getuint+0x65>
	else if (lflag)
  800715:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800719:	74 1e                	je     800739 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	8d 50 04             	lea    0x4(%eax),%edx
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	89 10                	mov    %edx,(%eax)
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	83 e8 04             	sub    $0x4,%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	ba 00 00 00 00       	mov    $0x0,%edx
  800737:	eb 1c                	jmp    800755 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	8d 50 04             	lea    0x4(%eax),%edx
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	89 10                	mov    %edx,(%eax)
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	83 e8 04             	sub    $0x4,%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800755:	5d                   	pop    %ebp
  800756:	c3                   	ret    

00800757 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075e:	7e 1c                	jle    80077c <getint+0x25>
		return va_arg(*ap, long long);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	8d 50 08             	lea    0x8(%eax),%edx
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	89 10                	mov    %edx,(%eax)
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	83 e8 08             	sub    $0x8,%eax
  800775:	8b 50 04             	mov    0x4(%eax),%edx
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	eb 38                	jmp    8007b4 <getint+0x5d>
	else if (lflag)
  80077c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800780:	74 1a                	je     80079c <getint+0x45>
		return va_arg(*ap, long);
  800782:	8b 45 08             	mov    0x8(%ebp),%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	8d 50 04             	lea    0x4(%eax),%edx
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	89 10                	mov    %edx,(%eax)
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	83 e8 04             	sub    $0x4,%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	99                   	cltd   
  80079a:	eb 18                	jmp    8007b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a7:	89 10                	mov    %edx,(%eax)
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	83 e8 04             	sub    $0x4,%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	99                   	cltd   
}
  8007b4:	5d                   	pop    %ebp
  8007b5:	c3                   	ret    

008007b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	56                   	push   %esi
  8007ba:	53                   	push   %ebx
  8007bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007be:	eb 17                	jmp    8007d7 <vprintfmt+0x21>
			if (ch == '\0')
  8007c0:	85 db                	test   %ebx,%ebx
  8007c2:	0f 84 af 03 00 00    	je     800b77 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007c8:	83 ec 08             	sub    $0x8,%esp
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	53                   	push   %ebx
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	ff d0                	call   *%eax
  8007d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007da:	8d 50 01             	lea    0x1(%eax),%edx
  8007dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8007e0:	8a 00                	mov    (%eax),%al
  8007e2:	0f b6 d8             	movzbl %al,%ebx
  8007e5:	83 fb 25             	cmp    $0x25,%ebx
  8007e8:	75 d6                	jne    8007c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800803:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	8d 50 01             	lea    0x1(%eax),%edx
  800810:	89 55 10             	mov    %edx,0x10(%ebp)
  800813:	8a 00                	mov    (%eax),%al
  800815:	0f b6 d8             	movzbl %al,%ebx
  800818:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80081b:	83 f8 55             	cmp    $0x55,%eax
  80081e:	0f 87 2b 03 00 00    	ja     800b4f <vprintfmt+0x399>
  800824:	8b 04 85 98 23 80 00 	mov    0x802398(,%eax,4),%eax
  80082b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800831:	eb d7                	jmp    80080a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800833:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800837:	eb d1                	jmp    80080a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800839:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800840:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800843:	89 d0                	mov    %edx,%eax
  800845:	c1 e0 02             	shl    $0x2,%eax
  800848:	01 d0                	add    %edx,%eax
  80084a:	01 c0                	add    %eax,%eax
  80084c:	01 d8                	add    %ebx,%eax
  80084e:	83 e8 30             	sub    $0x30,%eax
  800851:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800854:	8b 45 10             	mov    0x10(%ebp),%eax
  800857:	8a 00                	mov    (%eax),%al
  800859:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085c:	83 fb 2f             	cmp    $0x2f,%ebx
  80085f:	7e 3e                	jle    80089f <vprintfmt+0xe9>
  800861:	83 fb 39             	cmp    $0x39,%ebx
  800864:	7f 39                	jg     80089f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800866:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800869:	eb d5                	jmp    800840 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80086b:	8b 45 14             	mov    0x14(%ebp),%eax
  80086e:	83 c0 04             	add    $0x4,%eax
  800871:	89 45 14             	mov    %eax,0x14(%ebp)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	83 e8 04             	sub    $0x4,%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087f:	eb 1f                	jmp    8008a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800881:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800885:	79 83                	jns    80080a <vprintfmt+0x54>
				width = 0;
  800887:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088e:	e9 77 ff ff ff       	jmp    80080a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800893:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80089a:	e9 6b ff ff ff       	jmp    80080a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a4:	0f 89 60 ff ff ff    	jns    80080a <vprintfmt+0x54>
				width = precision, precision = -1;
  8008aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b7:	e9 4e ff ff ff       	jmp    80080a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bf:	e9 46 ff ff ff       	jmp    80080a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c7:	83 c0 04             	add    $0x4,%eax
  8008ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	83 e8 04             	sub    $0x4,%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 ec 08             	sub    $0x8,%esp
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	50                   	push   %eax
  8008dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008df:	ff d0                	call   *%eax
  8008e1:	83 c4 10             	add    $0x10,%esp
			break;
  8008e4:	e9 89 02 00 00       	jmp    800b72 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 c0 04             	add    $0x4,%eax
  8008ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008fa:	85 db                	test   %ebx,%ebx
  8008fc:	79 02                	jns    800900 <vprintfmt+0x14a>
				err = -err;
  8008fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800900:	83 fb 64             	cmp    $0x64,%ebx
  800903:	7f 0b                	jg     800910 <vprintfmt+0x15a>
  800905:	8b 34 9d e0 21 80 00 	mov    0x8021e0(,%ebx,4),%esi
  80090c:	85 f6                	test   %esi,%esi
  80090e:	75 19                	jne    800929 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800910:	53                   	push   %ebx
  800911:	68 85 23 80 00       	push   $0x802385
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	ff 75 08             	pushl  0x8(%ebp)
  80091c:	e8 5e 02 00 00       	call   800b7f <printfmt>
  800921:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800924:	e9 49 02 00 00       	jmp    800b72 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800929:	56                   	push   %esi
  80092a:	68 8e 23 80 00       	push   $0x80238e
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	ff 75 08             	pushl  0x8(%ebp)
  800935:	e8 45 02 00 00       	call   800b7f <printfmt>
  80093a:	83 c4 10             	add    $0x10,%esp
			break;
  80093d:	e9 30 02 00 00       	jmp    800b72 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 c0 04             	add    $0x4,%eax
  800948:	89 45 14             	mov    %eax,0x14(%ebp)
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	83 e8 04             	sub    $0x4,%eax
  800951:	8b 30                	mov    (%eax),%esi
  800953:	85 f6                	test   %esi,%esi
  800955:	75 05                	jne    80095c <vprintfmt+0x1a6>
				p = "(null)";
  800957:	be 91 23 80 00       	mov    $0x802391,%esi
			if (width > 0 && padc != '-')
  80095c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800960:	7e 6d                	jle    8009cf <vprintfmt+0x219>
  800962:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800966:	74 67                	je     8009cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800968:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	50                   	push   %eax
  80096f:	56                   	push   %esi
  800970:	e8 0c 03 00 00       	call   800c81 <strnlen>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80097b:	eb 16                	jmp    800993 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800981:	83 ec 08             	sub    $0x8,%esp
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	50                   	push   %eax
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	ff d0                	call   *%eax
  80098d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800990:	ff 4d e4             	decl   -0x1c(%ebp)
  800993:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800997:	7f e4                	jg     80097d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800999:	eb 34                	jmp    8009cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80099b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099f:	74 1c                	je     8009bd <vprintfmt+0x207>
  8009a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a4:	7e 05                	jle    8009ab <vprintfmt+0x1f5>
  8009a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a9:	7e 12                	jle    8009bd <vprintfmt+0x207>
					putch('?', putdat);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 0c             	pushl  0xc(%ebp)
  8009b1:	6a 3f                	push   $0x3f
  8009b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b6:	ff d0                	call   *%eax
  8009b8:	83 c4 10             	add    $0x10,%esp
  8009bb:	eb 0f                	jmp    8009cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bd:	83 ec 08             	sub    $0x8,%esp
  8009c0:	ff 75 0c             	pushl  0xc(%ebp)
  8009c3:	53                   	push   %ebx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cf:	89 f0                	mov    %esi,%eax
  8009d1:	8d 70 01             	lea    0x1(%eax),%esi
  8009d4:	8a 00                	mov    (%eax),%al
  8009d6:	0f be d8             	movsbl %al,%ebx
  8009d9:	85 db                	test   %ebx,%ebx
  8009db:	74 24                	je     800a01 <vprintfmt+0x24b>
  8009dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e1:	78 b8                	js     80099b <vprintfmt+0x1e5>
  8009e3:	ff 4d e0             	decl   -0x20(%ebp)
  8009e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ea:	79 af                	jns    80099b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ec:	eb 13                	jmp    800a01 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	6a 20                	push   $0x20
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	ff d0                	call   *%eax
  8009fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fe:	ff 4d e4             	decl   -0x1c(%ebp)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	7f e7                	jg     8009ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a07:	e9 66 01 00 00       	jmp    800b72 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	ff 75 e8             	pushl  -0x18(%ebp)
  800a12:	8d 45 14             	lea    0x14(%ebp),%eax
  800a15:	50                   	push   %eax
  800a16:	e8 3c fd ff ff       	call   800757 <getint>
  800a1b:	83 c4 10             	add    $0x10,%esp
  800a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a21:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2a:	85 d2                	test   %edx,%edx
  800a2c:	79 23                	jns    800a51 <vprintfmt+0x29b>
				putch('-', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 2d                	push   $0x2d
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a44:	f7 d8                	neg    %eax
  800a46:	83 d2 00             	adc    $0x0,%edx
  800a49:	f7 da                	neg    %edx
  800a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a51:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a58:	e9 bc 00 00 00       	jmp    800b19 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5d:	83 ec 08             	sub    $0x8,%esp
  800a60:	ff 75 e8             	pushl  -0x18(%ebp)
  800a63:	8d 45 14             	lea    0x14(%ebp),%eax
  800a66:	50                   	push   %eax
  800a67:	e8 84 fc ff ff       	call   8006f0 <getuint>
  800a6c:	83 c4 10             	add    $0x10,%esp
  800a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a72:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a75:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7c:	e9 98 00 00 00       	jmp    800b19 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	6a 58                	push   $0x58
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	6a 58                	push   $0x58
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	ff d0                	call   *%eax
  800a9e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa1:	83 ec 08             	sub    $0x8,%esp
  800aa4:	ff 75 0c             	pushl  0xc(%ebp)
  800aa7:	6a 58                	push   $0x58
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	ff d0                	call   *%eax
  800aae:	83 c4 10             	add    $0x10,%esp
			break;
  800ab1:	e9 bc 00 00 00       	jmp    800b72 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	6a 30                	push   $0x30
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	6a 78                	push   $0x78
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	ff d0                	call   *%eax
  800ad3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	83 c0 04             	add    $0x4,%eax
  800adc:	89 45 14             	mov    %eax,0x14(%ebp)
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	83 e8 04             	sub    $0x4,%eax
  800ae5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800af1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af8:	eb 1f                	jmp    800b19 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 e8             	pushl  -0x18(%ebp)
  800b00:	8d 45 14             	lea    0x14(%ebp),%eax
  800b03:	50                   	push   %eax
  800b04:	e8 e7 fb ff ff       	call   8006f0 <getuint>
  800b09:	83 c4 10             	add    $0x10,%esp
  800b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b12:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b19:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b20:	83 ec 04             	sub    $0x4,%esp
  800b23:	52                   	push   %edx
  800b24:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b27:	50                   	push   %eax
  800b28:	ff 75 f4             	pushl  -0xc(%ebp)
  800b2b:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	ff 75 08             	pushl  0x8(%ebp)
  800b34:	e8 00 fb ff ff       	call   800639 <printnum>
  800b39:	83 c4 20             	add    $0x20,%esp
			break;
  800b3c:	eb 34                	jmp    800b72 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3e:	83 ec 08             	sub    $0x8,%esp
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	53                   	push   %ebx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	ff d0                	call   *%eax
  800b4a:	83 c4 10             	add    $0x10,%esp
			break;
  800b4d:	eb 23                	jmp    800b72 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 25                	push   $0x25
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5f:	ff 4d 10             	decl   0x10(%ebp)
  800b62:	eb 03                	jmp    800b67 <vprintfmt+0x3b1>
  800b64:	ff 4d 10             	decl   0x10(%ebp)
  800b67:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6a:	48                   	dec    %eax
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	3c 25                	cmp    $0x25,%al
  800b6f:	75 f3                	jne    800b64 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b71:	90                   	nop
		}
	}
  800b72:	e9 47 fc ff ff       	jmp    8007be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b77:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b85:	8d 45 10             	lea    0x10(%ebp),%eax
  800b88:	83 c0 04             	add    $0x4,%eax
  800b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b91:	ff 75 f4             	pushl  -0xc(%ebp)
  800b94:	50                   	push   %eax
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	ff 75 08             	pushl  0x8(%ebp)
  800b9b:	e8 16 fc ff ff       	call   8007b6 <vprintfmt>
  800ba0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba3:	90                   	nop
  800ba4:	c9                   	leave  
  800ba5:	c3                   	ret    

00800ba6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8b 40 08             	mov    0x8(%eax),%eax
  800baf:	8d 50 01             	lea    0x1(%eax),%edx
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	8b 10                	mov    (%eax),%edx
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	8b 40 04             	mov    0x4(%eax),%eax
  800bc3:	39 c2                	cmp    %eax,%edx
  800bc5:	73 12                	jae    800bd9 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd2:	89 0a                	mov    %ecx,(%edx)
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	88 10                	mov    %dl,(%eax)
}
  800bd9:	90                   	nop
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	01 d0                	add    %edx,%eax
  800bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c01:	74 06                	je     800c09 <vsnprintf+0x2d>
  800c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c07:	7f 07                	jg     800c10 <vsnprintf+0x34>
		return -E_INVAL;
  800c09:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0e:	eb 20                	jmp    800c30 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c10:	ff 75 14             	pushl  0x14(%ebp)
  800c13:	ff 75 10             	pushl  0x10(%ebp)
  800c16:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c19:	50                   	push   %eax
  800c1a:	68 a6 0b 80 00       	push   $0x800ba6
  800c1f:	e8 92 fb ff ff       	call   8007b6 <vprintfmt>
  800c24:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c2a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c38:	8d 45 10             	lea    0x10(%ebp),%eax
  800c3b:	83 c0 04             	add    $0x4,%eax
  800c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	ff 75 f4             	pushl  -0xc(%ebp)
  800c47:	50                   	push   %eax
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	ff 75 08             	pushl  0x8(%ebp)
  800c4e:	e8 89 ff ff ff       	call   800bdc <vsnprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
  800c56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6b:	eb 06                	jmp    800c73 <strlen+0x15>
		n++;
  800c6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c70:	ff 45 08             	incl   0x8(%ebp)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 f1                	jne    800c6d <strlen+0xf>
		n++;
	return n;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8e:	eb 09                	jmp    800c99 <strnlen+0x18>
		n++;
  800c90:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c93:	ff 45 08             	incl   0x8(%ebp)
  800c96:	ff 4d 0c             	decl   0xc(%ebp)
  800c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9d:	74 09                	je     800ca8 <strnlen+0x27>
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	75 e8                	jne    800c90 <strnlen+0xf>
		n++;
	return n;
  800ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb9:	90                   	nop
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	84 c0                	test   %al,%al
  800cd4:	75 e4                	jne    800cba <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cee:	eb 1f                	jmp    800d0f <strncpy+0x34>
		*dst++ = *src;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8d 50 01             	lea    0x1(%eax),%edx
  800cf6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	8a 12                	mov    (%edx),%dl
  800cfe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	84 c0                	test   %al,%al
  800d07:	74 03                	je     800d0c <strncpy+0x31>
			src++;
  800d09:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d12:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d15:	72 d9                	jb     800cf0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2c:	74 30                	je     800d5e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2e:	eb 16                	jmp    800d46 <strlcpy+0x2a>
			*dst++ = *src++;
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8d 50 01             	lea    0x1(%eax),%edx
  800d36:	89 55 08             	mov    %edx,0x8(%ebp)
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d46:	ff 4d 10             	decl   0x10(%ebp)
  800d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4d:	74 09                	je     800d58 <strlcpy+0x3c>
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	84 c0                	test   %al,%al
  800d56:	75 d8                	jne    800d30 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d64:	29 c2                	sub    %eax,%edx
  800d66:	89 d0                	mov    %edx,%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6d:	eb 06                	jmp    800d75 <strcmp+0xb>
		p++, q++;
  800d6f:	ff 45 08             	incl   0x8(%ebp)
  800d72:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 0e                	je     800d8c <strcmp+0x22>
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 10                	mov    (%eax),%dl
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	38 c2                	cmp    %al,%dl
  800d8a:	74 e3                	je     800d6f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d0             	movzbl %al,%edx
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	0f b6 c0             	movzbl %al,%eax
  800d9c:	29 c2                	sub    %eax,%edx
  800d9e:	89 d0                	mov    %edx,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da5:	eb 09                	jmp    800db0 <strncmp+0xe>
		n--, p++, q++;
  800da7:	ff 4d 10             	decl   0x10(%ebp)
  800daa:	ff 45 08             	incl   0x8(%ebp)
  800dad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db4:	74 17                	je     800dcd <strncmp+0x2b>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	74 0e                	je     800dcd <strncmp+0x2b>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 10                	mov    (%eax),%dl
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	38 c2                	cmp    %al,%dl
  800dcb:	74 da                	je     800da7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	75 07                	jne    800dda <strncmp+0x38>
		return 0;
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd8:	eb 14                	jmp    800dee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 d0             	movzbl %al,%edx
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 c0             	movzbl %al,%eax
  800dea:	29 c2                	sub    %eax,%edx
  800dec:	89 d0                	mov    %edx,%eax
}
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 04             	sub    $0x4,%esp
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfc:	eb 12                	jmp    800e10 <strchr+0x20>
		if (*s == c)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e06:	75 05                	jne    800e0d <strchr+0x1d>
			return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	eb 11                	jmp    800e1e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0d:	ff 45 08             	incl   0x8(%ebp)
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e5                	jne    800dfe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 04             	sub    $0x4,%esp
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2c:	eb 0d                	jmp    800e3b <strfind+0x1b>
		if (*s == c)
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e36:	74 0e                	je     800e46 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e38:	ff 45 08             	incl   0x8(%ebp)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 ea                	jne    800e2e <strfind+0xe>
  800e44:	eb 01                	jmp    800e47 <strfind+0x27>
		if (*s == c)
			break;
  800e46:	90                   	nop
	return (char *) s;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5e:	eb 0e                	jmp    800e6e <memset+0x22>
		*p++ = c;
  800e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e63:	8d 50 01             	lea    0x1(%eax),%edx
  800e66:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6e:	ff 4d f8             	decl   -0x8(%ebp)
  800e71:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e75:	79 e9                	jns    800e60 <memset+0x14>
		*p++ = c;

	return v;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8e:	eb 16                	jmp    800ea6 <memcpy+0x2a>
		*d++ = *s++;
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e93:	8d 50 01             	lea    0x1(%eax),%edx
  800e96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea2:	8a 12                	mov    (%edx),%dl
  800ea4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 dd                	jne    800e90 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed0:	73 50                	jae    800f22 <memmove+0x6a>
  800ed2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed8:	01 d0                	add    %edx,%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	76 43                	jbe    800f22 <memmove+0x6a>
		s += n;
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eeb:	eb 10                	jmp    800efd <memmove+0x45>
			*--d = *--s;
  800eed:	ff 4d f8             	decl   -0x8(%ebp)
  800ef0:	ff 4d fc             	decl   -0x4(%ebp)
  800ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef6:	8a 10                	mov    (%eax),%dl
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efd:	8b 45 10             	mov    0x10(%ebp),%eax
  800f00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f03:	89 55 10             	mov    %edx,0x10(%ebp)
  800f06:	85 c0                	test   %eax,%eax
  800f08:	75 e3                	jne    800eed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f0a:	eb 23                	jmp    800f2f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	8d 50 01             	lea    0x1(%eax),%edx
  800f12:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f28:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	75 dd                	jne    800f0c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f46:	eb 2a                	jmp    800f72 <memcmp+0x3e>
		if (*s1 != *s2)
  800f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 16                	je     800f6c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
  800f6a:	eb 18                	jmp    800f84 <memcmp+0x50>
		s1++, s2++;
  800f6c:	ff 45 fc             	incl   -0x4(%ebp)
  800f6f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 c9                	jne    800f48 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	01 d0                	add    %edx,%eax
  800f94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f97:	eb 15                	jmp    800fae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f b6 d0             	movzbl %al,%edx
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	0f b6 c0             	movzbl %al,%eax
  800fa7:	39 c2                	cmp    %eax,%edx
  800fa9:	74 0d                	je     800fb8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fab:	ff 45 08             	incl   0x8(%ebp)
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb4:	72 e3                	jb     800f99 <memfind+0x13>
  800fb6:	eb 01                	jmp    800fb9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb8:	90                   	nop
	return (void *) s;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fcb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd2:	eb 03                	jmp    800fd7 <strtol+0x19>
		s++;
  800fd4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 20                	cmp    $0x20,%al
  800fde:	74 f4                	je     800fd4 <strtol+0x16>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 09                	cmp    $0x9,%al
  800fe7:	74 eb                	je     800fd4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 2b                	cmp    $0x2b,%al
  800ff0:	75 05                	jne    800ff7 <strtol+0x39>
		s++;
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	eb 13                	jmp    80100a <strtol+0x4c>
	else if (*s == '-')
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	3c 2d                	cmp    $0x2d,%al
  800ffe:	75 0a                	jne    80100a <strtol+0x4c>
		s++, neg = 1;
  801000:	ff 45 08             	incl   0x8(%ebp)
  801003:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80100a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100e:	74 06                	je     801016 <strtol+0x58>
  801010:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801014:	75 20                	jne    801036 <strtol+0x78>
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	3c 30                	cmp    $0x30,%al
  80101d:	75 17                	jne    801036 <strtol+0x78>
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	40                   	inc    %eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3c 78                	cmp    $0x78,%al
  801027:	75 0d                	jne    801036 <strtol+0x78>
		s += 2, base = 16;
  801029:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801034:	eb 28                	jmp    80105e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801036:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103a:	75 15                	jne    801051 <strtol+0x93>
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	3c 30                	cmp    $0x30,%al
  801043:	75 0c                	jne    801051 <strtol+0x93>
		s++, base = 8;
  801045:	ff 45 08             	incl   0x8(%ebp)
  801048:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104f:	eb 0d                	jmp    80105e <strtol+0xa0>
	else if (base == 0)
  801051:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801055:	75 07                	jne    80105e <strtol+0xa0>
		base = 10;
  801057:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 2f                	cmp    $0x2f,%al
  801065:	7e 19                	jle    801080 <strtol+0xc2>
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	8a 00                	mov    (%eax),%al
  80106c:	3c 39                	cmp    $0x39,%al
  80106e:	7f 10                	jg     801080 <strtol+0xc2>
			dig = *s - '0';
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	0f be c0             	movsbl %al,%eax
  801078:	83 e8 30             	sub    $0x30,%eax
  80107b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107e:	eb 42                	jmp    8010c2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	8a 00                	mov    (%eax),%al
  801085:	3c 60                	cmp    $0x60,%al
  801087:	7e 19                	jle    8010a2 <strtol+0xe4>
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	3c 7a                	cmp    $0x7a,%al
  801090:	7f 10                	jg     8010a2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	0f be c0             	movsbl %al,%eax
  80109a:	83 e8 57             	sub    $0x57,%eax
  80109d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a0:	eb 20                	jmp    8010c2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	3c 40                	cmp    $0x40,%al
  8010a9:	7e 39                	jle    8010e4 <strtol+0x126>
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 5a                	cmp    $0x5a,%al
  8010b2:	7f 30                	jg     8010e4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	0f be c0             	movsbl %al,%eax
  8010bc:	83 e8 37             	sub    $0x37,%eax
  8010bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c8:	7d 19                	jge    8010e3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010ca:	ff 45 08             	incl   0x8(%ebp)
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d4:	89 c2                	mov    %eax,%edx
  8010d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010de:	e9 7b ff ff ff       	jmp    80105e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e8:	74 08                	je     8010f2 <strtol+0x134>
		*endptr = (char *) s;
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 07                	je     8010ff <strtol+0x141>
  8010f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fb:	f7 d8                	neg    %eax
  8010fd:	eb 03                	jmp    801102 <strtol+0x144>
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <ltostr>:

void
ltostr(long value, char *str)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80110a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801111:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801118:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111c:	79 13                	jns    801131 <ltostr+0x2d>
	{
		neg = 1;
  80111e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80112b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801139:	99                   	cltd   
  80113a:	f7 f9                	idiv   %ecx
  80113c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	83 c2 30             	add    $0x30,%edx
  801155:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801157:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80115a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115f:	f7 e9                	imul   %ecx
  801161:	c1 fa 02             	sar    $0x2,%edx
  801164:	89 c8                	mov    %ecx,%eax
  801166:	c1 f8 1f             	sar    $0x1f,%eax
  801169:	29 c2                	sub    %eax,%edx
  80116b:	89 d0                	mov    %edx,%eax
  80116d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801170:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801173:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801178:	f7 e9                	imul   %ecx
  80117a:	c1 fa 02             	sar    $0x2,%edx
  80117d:	89 c8                	mov    %ecx,%eax
  80117f:	c1 f8 1f             	sar    $0x1f,%eax
  801182:	29 c2                	sub    %eax,%edx
  801184:	89 d0                	mov    %edx,%eax
  801186:	c1 e0 02             	shl    $0x2,%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	01 c0                	add    %eax,%eax
  80118d:	29 c1                	sub    %eax,%ecx
  80118f:	89 ca                	mov    %ecx,%edx
  801191:	85 d2                	test   %edx,%edx
  801193:	75 9c                	jne    801131 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801195:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119f:	48                   	dec    %eax
  8011a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a7:	74 3d                	je     8011e6 <ltostr+0xe2>
		start = 1 ;
  8011a9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011b0:	eb 34                	jmp    8011e6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b8:	01 d0                	add    %edx,%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d9:	01 c2                	add    %eax,%edx
  8011db:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011de:	88 02                	mov    %al,(%edx)
		start++ ;
  8011e0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ec:	7c c4                	jl     8011b2 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f9:	90                   	nop
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801202:	ff 75 08             	pushl  0x8(%ebp)
  801205:	e8 54 fa ff ff       	call   800c5e <strlen>
  80120a:	83 c4 04             	add    $0x4,%esp
  80120d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801210:	ff 75 0c             	pushl  0xc(%ebp)
  801213:	e8 46 fa ff ff       	call   800c5e <strlen>
  801218:	83 c4 04             	add    $0x4,%esp
  80121b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80121e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122c:	eb 17                	jmp    801245 <strcconcat+0x49>
		final[s] = str1[s] ;
  80122e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	01 c2                	add    %eax,%edx
  801236:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	01 c8                	add    %ecx,%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801242:	ff 45 fc             	incl   -0x4(%ebp)
  801245:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801248:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80124b:	7c e1                	jl     80122e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80124d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801254:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80125b:	eb 1f                	jmp    80127c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80125d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801266:	89 c2                	mov    %eax,%edx
  801268:	8b 45 10             	mov    0x10(%ebp),%eax
  80126b:	01 c2                	add    %eax,%edx
  80126d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801270:	8b 45 0c             	mov    0xc(%ebp),%eax
  801273:	01 c8                	add    %ecx,%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801279:	ff 45 f8             	incl   -0x8(%ebp)
  80127c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801282:	7c d9                	jl     80125d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c6 00 00             	movb   $0x0,(%eax)
}
  80128f:	90                   	nop
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801295:	8b 45 14             	mov    0x14(%ebp),%eax
  801298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80129e:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a1:	8b 00                	mov    (%eax),%eax
  8012a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 d0                	add    %edx,%eax
  8012af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b5:	eb 0c                	jmp    8012c3 <strsplit+0x31>
			*string++ = 0;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	8d 50 01             	lea    0x1(%eax),%edx
  8012bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	84 c0                	test   %al,%al
  8012ca:	74 18                	je     8012e4 <strsplit+0x52>
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	8a 00                	mov    (%eax),%al
  8012d1:	0f be c0             	movsbl %al,%eax
  8012d4:	50                   	push   %eax
  8012d5:	ff 75 0c             	pushl  0xc(%ebp)
  8012d8:	e8 13 fb ff ff       	call   800df0 <strchr>
  8012dd:	83 c4 08             	add    $0x8,%esp
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 d3                	jne    8012b7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	74 5a                	je     801347 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f0:	8b 00                	mov    (%eax),%eax
  8012f2:	83 f8 0f             	cmp    $0xf,%eax
  8012f5:	75 07                	jne    8012fe <strsplit+0x6c>
		{
			return 0;
  8012f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fc:	eb 66                	jmp    801364 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801301:	8b 00                	mov    (%eax),%eax
  801303:	8d 48 01             	lea    0x1(%eax),%ecx
  801306:	8b 55 14             	mov    0x14(%ebp),%edx
  801309:	89 0a                	mov    %ecx,(%edx)
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 c2                	add    %eax,%edx
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131c:	eb 03                	jmp    801321 <strsplit+0x8f>
			string++;
  80131e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
  801324:	8a 00                	mov    (%eax),%al
  801326:	84 c0                	test   %al,%al
  801328:	74 8b                	je     8012b5 <strsplit+0x23>
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	0f be c0             	movsbl %al,%eax
  801332:	50                   	push   %eax
  801333:	ff 75 0c             	pushl  0xc(%ebp)
  801336:	e8 b5 fa ff ff       	call   800df0 <strchr>
  80133b:	83 c4 08             	add    $0x8,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	74 dc                	je     80131e <strsplit+0x8c>
			string++;
	}
  801342:	e9 6e ff ff ff       	jmp    8012b5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801347:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801348:	8b 45 14             	mov    0x14(%ebp),%eax
  80134b:	8b 00                	mov    (%eax),%eax
  80134d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 d0                	add    %edx,%eax
  801359:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  80136c:	83 ec 04             	sub    $0x4,%esp
  80136f:	68 f0 24 80 00       	push   $0x8024f0
  801374:	6a 0e                	push   $0xe
  801376:	68 2a 25 80 00       	push   $0x80252a
  80137b:	e8 a8 ef ff ff       	call   800328 <_panic>

00801380 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  801386:	a1 04 30 80 00       	mov    0x803004,%eax
  80138b:	85 c0                	test   %eax,%eax
  80138d:	74 0f                	je     80139e <malloc+0x1e>
	{
		initialize_dyn_block_system();
  80138f:	e8 d2 ff ff ff       	call   801366 <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801394:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  80139b:	00 00 00 
	}
	if (size == 0) return NULL ;
  80139e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a2:	75 07                	jne    8013ab <malloc+0x2b>
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a9:	eb 14                	jmp    8013bf <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	68 38 25 80 00       	push   $0x802538
  8013b3:	6a 2e                	push   $0x2e
  8013b5:	68 2a 25 80 00       	push   $0x80252a
  8013ba:	e8 69 ef ff ff       	call   800328 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	68 60 25 80 00       	push   $0x802560
  8013cf:	6a 49                	push   $0x49
  8013d1:	68 2a 25 80 00       	push   $0x80252a
  8013d6:	e8 4d ef ff ff       	call   800328 <_panic>

008013db <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 18             	sub    $0x18,%esp
  8013e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e4:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8013e7:	83 ec 04             	sub    $0x4,%esp
  8013ea:	68 84 25 80 00       	push   $0x802584
  8013ef:	6a 57                	push   $0x57
  8013f1:	68 2a 25 80 00       	push   $0x80252a
  8013f6:	e8 2d ef ff ff       	call   800328 <_panic>

008013fb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801401:	83 ec 04             	sub    $0x4,%esp
  801404:	68 ac 25 80 00       	push   $0x8025ac
  801409:	6a 60                	push   $0x60
  80140b:	68 2a 25 80 00       	push   $0x80252a
  801410:	e8 13 ef ff ff       	call   800328 <_panic>

00801415 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
  801418:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80141b:	83 ec 04             	sub    $0x4,%esp
  80141e:	68 d0 25 80 00       	push   $0x8025d0
  801423:	6a 7c                	push   $0x7c
  801425:	68 2a 25 80 00       	push   $0x80252a
  80142a:	e8 f9 ee ff ff       	call   800328 <_panic>

0080142f <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801435:	83 ec 04             	sub    $0x4,%esp
  801438:	68 f8 25 80 00       	push   $0x8025f8
  80143d:	68 86 00 00 00       	push   $0x86
  801442:	68 2a 25 80 00       	push   $0x80252a
  801447:	e8 dc ee ff ff       	call   800328 <_panic>

0080144c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801452:	83 ec 04             	sub    $0x4,%esp
  801455:	68 1c 26 80 00       	push   $0x80261c
  80145a:	68 91 00 00 00       	push   $0x91
  80145f:	68 2a 25 80 00       	push   $0x80252a
  801464:	e8 bf ee ff ff       	call   800328 <_panic>

00801469 <shrink>:

}
void shrink(uint32 newSize)
{
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
  80146c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80146f:	83 ec 04             	sub    $0x4,%esp
  801472:	68 1c 26 80 00       	push   $0x80261c
  801477:	68 96 00 00 00       	push   $0x96
  80147c:	68 2a 25 80 00       	push   $0x80252a
  801481:	e8 a2 ee ff ff       	call   800328 <_panic>

00801486 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80148c:	83 ec 04             	sub    $0x4,%esp
  80148f:	68 1c 26 80 00       	push   $0x80261c
  801494:	68 9b 00 00 00       	push   $0x9b
  801499:	68 2a 25 80 00       	push   $0x80252a
  80149e:	e8 85 ee ff ff       	call   800328 <_panic>

008014a3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	57                   	push   %edi
  8014a7:	56                   	push   %esi
  8014a8:	53                   	push   %ebx
  8014a9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014b5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014b8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8014bb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8014be:	cd 30                	int    $0x30
  8014c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8014c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	5b                   	pop    %ebx
  8014ca:	5e                   	pop    %esi
  8014cb:	5f                   	pop    %edi
  8014cc:	5d                   	pop    %ebp
  8014cd:	c3                   	ret    

008014ce <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8014da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	52                   	push   %edx
  8014e6:	ff 75 0c             	pushl  0xc(%ebp)
  8014e9:	50                   	push   %eax
  8014ea:	6a 00                	push   $0x0
  8014ec:	e8 b2 ff ff ff       	call   8014a3 <syscall>
  8014f1:	83 c4 18             	add    $0x18,%esp
}
  8014f4:	90                   	nop
  8014f5:	c9                   	leave  
  8014f6:	c3                   	ret    

008014f7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 01                	push   $0x1
  801506:	e8 98 ff ff ff       	call   8014a3 <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801513:	8b 55 0c             	mov    0xc(%ebp),%edx
  801516:	8b 45 08             	mov    0x8(%ebp),%eax
  801519:	6a 00                	push   $0x0
  80151b:	6a 00                	push   $0x0
  80151d:	6a 00                	push   $0x0
  80151f:	52                   	push   %edx
  801520:	50                   	push   %eax
  801521:	6a 05                	push   $0x5
  801523:	e8 7b ff ff ff       	call   8014a3 <syscall>
  801528:	83 c4 18             	add    $0x18,%esp
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	56                   	push   %esi
  801531:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801532:	8b 75 18             	mov    0x18(%ebp),%esi
  801535:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801538:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80153b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	56                   	push   %esi
  801542:	53                   	push   %ebx
  801543:	51                   	push   %ecx
  801544:	52                   	push   %edx
  801545:	50                   	push   %eax
  801546:	6a 06                	push   $0x6
  801548:	e8 56 ff ff ff       	call   8014a3 <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
}
  801550:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801553:	5b                   	pop    %ebx
  801554:	5e                   	pop    %esi
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80155a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	6a 00                	push   $0x0
  801566:	52                   	push   %edx
  801567:	50                   	push   %eax
  801568:	6a 07                	push   $0x7
  80156a:	e8 34 ff ff ff       	call   8014a3 <syscall>
  80156f:	83 c4 18             	add    $0x18,%esp
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	ff 75 08             	pushl  0x8(%ebp)
  801583:	6a 08                	push   $0x8
  801585:	e8 19 ff ff ff       	call   8014a3 <syscall>
  80158a:	83 c4 18             	add    $0x18,%esp
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801592:	6a 00                	push   $0x0
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 09                	push   $0x9
  80159e:	e8 00 ff ff ff       	call   8014a3 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015ab:	6a 00                	push   $0x0
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 0a                	push   $0xa
  8015b7:	e8 e7 fe ff ff       	call   8014a3 <syscall>
  8015bc:	83 c4 18             	add    $0x18,%esp
}
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8015c4:	6a 00                	push   $0x0
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 0b                	push   $0xb
  8015d0:	e8 ce fe ff ff       	call   8014a3 <syscall>
  8015d5:	83 c4 18             	add    $0x18,%esp
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	ff 75 0c             	pushl  0xc(%ebp)
  8015e6:	ff 75 08             	pushl  0x8(%ebp)
  8015e9:	6a 0f                	push   $0xf
  8015eb:	e8 b3 fe ff ff       	call   8014a3 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
	return;
  8015f3:	90                   	nop
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	ff 75 0c             	pushl  0xc(%ebp)
  801602:	ff 75 08             	pushl  0x8(%ebp)
  801605:	6a 10                	push   $0x10
  801607:	e8 97 fe ff ff       	call   8014a3 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
	return ;
  80160f:	90                   	nop
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	ff 75 10             	pushl  0x10(%ebp)
  80161c:	ff 75 0c             	pushl  0xc(%ebp)
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	6a 11                	push   $0x11
  801624:	e8 7a fe ff ff       	call   8014a3 <syscall>
  801629:	83 c4 18             	add    $0x18,%esp
	return ;
  80162c:	90                   	nop
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 0c                	push   $0xc
  80163e:	e8 60 fe ff ff       	call   8014a3 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	ff 75 08             	pushl  0x8(%ebp)
  801656:	6a 0d                	push   $0xd
  801658:	e8 46 fe ff ff       	call   8014a3 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
}
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 0e                	push   $0xe
  801671:	e8 2d fe ff ff       	call   8014a3 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
}
  801679:	90                   	nop
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 13                	push   $0x13
  80168b:	e8 13 fe ff ff       	call   8014a3 <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	90                   	nop
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 14                	push   $0x14
  8016a5:	e8 f9 fd ff ff       	call   8014a3 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
}
  8016ad:	90                   	nop
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 04             	sub    $0x4,%esp
  8016b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8016bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	50                   	push   %eax
  8016c9:	6a 15                	push   $0x15
  8016cb:	e8 d3 fd ff ff       	call   8014a3 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	90                   	nop
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 16                	push   $0x16
  8016e5:	e8 b9 fd ff ff       	call   8014a3 <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
}
  8016ed:	90                   	nop
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	50                   	push   %eax
  801700:	6a 17                	push   $0x17
  801702:	e8 9c fd ff ff       	call   8014a3 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80170f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	52                   	push   %edx
  80171c:	50                   	push   %eax
  80171d:	6a 1a                	push   $0x1a
  80171f:	e8 7f fd ff ff       	call   8014a3 <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80172c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80172f:	8b 45 08             	mov    0x8(%ebp),%eax
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	52                   	push   %edx
  801739:	50                   	push   %eax
  80173a:	6a 18                	push   $0x18
  80173c:	e8 62 fd ff ff       	call   8014a3 <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	90                   	nop
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80174a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	52                   	push   %edx
  801757:	50                   	push   %eax
  801758:	6a 19                	push   $0x19
  80175a:	e8 44 fd ff ff       	call   8014a3 <syscall>
  80175f:	83 c4 18             	add    $0x18,%esp
}
  801762:	90                   	nop
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	8b 45 10             	mov    0x10(%ebp),%eax
  80176e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801771:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801774:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	6a 00                	push   $0x0
  80177d:	51                   	push   %ecx
  80177e:	52                   	push   %edx
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	50                   	push   %eax
  801783:	6a 1b                	push   $0x1b
  801785:	e8 19 fd ff ff       	call   8014a3 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	52                   	push   %edx
  80179f:	50                   	push   %eax
  8017a0:	6a 1c                	push   $0x1c
  8017a2:	e8 fc fc ff ff       	call   8014a3 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	51                   	push   %ecx
  8017bd:	52                   	push   %edx
  8017be:	50                   	push   %eax
  8017bf:	6a 1d                	push   $0x1d
  8017c1:	e8 dd fc ff ff       	call   8014a3 <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8017ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	52                   	push   %edx
  8017db:	50                   	push   %eax
  8017dc:	6a 1e                	push   $0x1e
  8017de:	e8 c0 fc ff ff       	call   8014a3 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 1f                	push   $0x1f
  8017f7:	e8 a7 fc ff ff       	call   8014a3 <syscall>
  8017fc:	83 c4 18             	add    $0x18,%esp
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	6a 00                	push   $0x0
  801809:	ff 75 14             	pushl  0x14(%ebp)
  80180c:	ff 75 10             	pushl  0x10(%ebp)
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	50                   	push   %eax
  801813:	6a 20                	push   $0x20
  801815:	e8 89 fc ff ff       	call   8014a3 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801822:	8b 45 08             	mov    0x8(%ebp),%eax
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	50                   	push   %eax
  80182e:	6a 21                	push   $0x21
  801830:	e8 6e fc ff ff       	call   8014a3 <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
}
  801838:	90                   	nop
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	50                   	push   %eax
  80184a:	6a 22                	push   $0x22
  80184c:	e8 52 fc ff ff       	call   8014a3 <syscall>
  801851:	83 c4 18             	add    $0x18,%esp
}
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 02                	push   $0x2
  801865:	e8 39 fc ff ff       	call   8014a3 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 03                	push   $0x3
  80187e:	e8 20 fc ff ff       	call   8014a3 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 04                	push   $0x4
  801897:	e8 07 fc ff ff       	call   8014a3 <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_exit_env>:


void sys_exit_env(void)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 23                	push   $0x23
  8018b0:	e8 ee fb ff ff       	call   8014a3 <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	90                   	nop
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8018c1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c4:	8d 50 04             	lea    0x4(%eax),%edx
  8018c7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	52                   	push   %edx
  8018d1:	50                   	push   %eax
  8018d2:	6a 24                	push   $0x24
  8018d4:	e8 ca fb ff ff       	call   8014a3 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
	return result;
  8018dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	89 01                	mov    %eax,(%ecx)
  8018e7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	c9                   	leave  
  8018ee:	c2 04 00             	ret    $0x4

008018f1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	ff 75 10             	pushl  0x10(%ebp)
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	6a 12                	push   $0x12
  801903:	e8 9b fb ff ff       	call   8014a3 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
	return ;
  80190b:	90                   	nop
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_rcr2>:
uint32 sys_rcr2()
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 25                	push   $0x25
  80191d:	e8 81 fb ff ff       	call   8014a3 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 04             	sub    $0x4,%esp
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801933:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	50                   	push   %eax
  801940:	6a 26                	push   $0x26
  801942:	e8 5c fb ff ff       	call   8014a3 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
	return ;
  80194a:	90                   	nop
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <rsttst>:
void rsttst()
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 28                	push   $0x28
  80195c:	e8 42 fb ff ff       	call   8014a3 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
	return ;
  801964:	90                   	nop
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801973:	8b 55 18             	mov    0x18(%ebp),%edx
  801976:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80197a:	52                   	push   %edx
  80197b:	50                   	push   %eax
  80197c:	ff 75 10             	pushl  0x10(%ebp)
  80197f:	ff 75 0c             	pushl  0xc(%ebp)
  801982:	ff 75 08             	pushl  0x8(%ebp)
  801985:	6a 27                	push   $0x27
  801987:	e8 17 fb ff ff       	call   8014a3 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
	return ;
  80198f:	90                   	nop
}
  801990:	c9                   	leave  
  801991:	c3                   	ret    

00801992 <chktst>:
void chktst(uint32 n)
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 29                	push   $0x29
  8019a2:	e8 fc fa ff ff       	call   8014a3 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019aa:	90                   	nop
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <inctst>:

void inctst()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 2a                	push   $0x2a
  8019bc:	e8 e2 fa ff ff       	call   8014a3 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c4:	90                   	nop
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <gettst>:
uint32 gettst()
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 2b                	push   $0x2b
  8019d6:	e8 c8 fa ff ff       	call   8014a3 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 2c                	push   $0x2c
  8019f2:	e8 ac fa ff ff       	call   8014a3 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
  8019fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019fd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a01:	75 07                	jne    801a0a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a03:	b8 01 00 00 00       	mov    $0x1,%eax
  801a08:	eb 05                	jmp    801a0f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
  801a14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 2c                	push   $0x2c
  801a23:	e8 7b fa ff ff       	call   8014a3 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
  801a2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a2e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a32:	75 07                	jne    801a3b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a34:	b8 01 00 00 00       	mov    $0x1,%eax
  801a39:	eb 05                	jmp    801a40 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 2c                	push   $0x2c
  801a54:	e8 4a fa ff ff       	call   8014a3 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
  801a5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a5f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a63:	75 07                	jne    801a6c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a65:	b8 01 00 00 00       	mov    $0x1,%eax
  801a6a:	eb 05                	jmp    801a71 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 2c                	push   $0x2c
  801a85:	e8 19 fa ff ff       	call   8014a3 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
  801a8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a90:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a94:	75 07                	jne    801a9d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a96:	b8 01 00 00 00       	mov    $0x1,%eax
  801a9b:	eb 05                	jmp    801aa2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	6a 2d                	push   $0x2d
  801ab4:	e8 ea f9 ff ff       	call   8014a3 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
	return ;
  801abc:	90                   	nop
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ac3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	53                   	push   %ebx
  801ad2:	51                   	push   %ecx
  801ad3:	52                   	push   %edx
  801ad4:	50                   	push   %eax
  801ad5:	6a 2e                	push   $0x2e
  801ad7:	e8 c7 f9 ff ff       	call   8014a3 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	52                   	push   %edx
  801af4:	50                   	push   %eax
  801af5:	6a 2f                	push   $0x2f
  801af7:	e8 a7 f9 ff ff       	call   8014a3 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    
  801b01:	66 90                	xchg   %ax,%ax
  801b03:	90                   	nop

00801b04 <__udivdi3>:
  801b04:	55                   	push   %ebp
  801b05:	57                   	push   %edi
  801b06:	56                   	push   %esi
  801b07:	53                   	push   %ebx
  801b08:	83 ec 1c             	sub    $0x1c,%esp
  801b0b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b0f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1b:	89 ca                	mov    %ecx,%edx
  801b1d:	89 f8                	mov    %edi,%eax
  801b1f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b23:	85 f6                	test   %esi,%esi
  801b25:	75 2d                	jne    801b54 <__udivdi3+0x50>
  801b27:	39 cf                	cmp    %ecx,%edi
  801b29:	77 65                	ja     801b90 <__udivdi3+0x8c>
  801b2b:	89 fd                	mov    %edi,%ebp
  801b2d:	85 ff                	test   %edi,%edi
  801b2f:	75 0b                	jne    801b3c <__udivdi3+0x38>
  801b31:	b8 01 00 00 00       	mov    $0x1,%eax
  801b36:	31 d2                	xor    %edx,%edx
  801b38:	f7 f7                	div    %edi
  801b3a:	89 c5                	mov    %eax,%ebp
  801b3c:	31 d2                	xor    %edx,%edx
  801b3e:	89 c8                	mov    %ecx,%eax
  801b40:	f7 f5                	div    %ebp
  801b42:	89 c1                	mov    %eax,%ecx
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	f7 f5                	div    %ebp
  801b48:	89 cf                	mov    %ecx,%edi
  801b4a:	89 fa                	mov    %edi,%edx
  801b4c:	83 c4 1c             	add    $0x1c,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5f                   	pop    %edi
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    
  801b54:	39 ce                	cmp    %ecx,%esi
  801b56:	77 28                	ja     801b80 <__udivdi3+0x7c>
  801b58:	0f bd fe             	bsr    %esi,%edi
  801b5b:	83 f7 1f             	xor    $0x1f,%edi
  801b5e:	75 40                	jne    801ba0 <__udivdi3+0x9c>
  801b60:	39 ce                	cmp    %ecx,%esi
  801b62:	72 0a                	jb     801b6e <__udivdi3+0x6a>
  801b64:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801b68:	0f 87 9e 00 00 00    	ja     801c0c <__udivdi3+0x108>
  801b6e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b73:	89 fa                	mov    %edi,%edx
  801b75:	83 c4 1c             	add    $0x1c,%esp
  801b78:	5b                   	pop    %ebx
  801b79:	5e                   	pop    %esi
  801b7a:	5f                   	pop    %edi
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    
  801b7d:	8d 76 00             	lea    0x0(%esi),%esi
  801b80:	31 ff                	xor    %edi,%edi
  801b82:	31 c0                	xor    %eax,%eax
  801b84:	89 fa                	mov    %edi,%edx
  801b86:	83 c4 1c             	add    $0x1c,%esp
  801b89:	5b                   	pop    %ebx
  801b8a:	5e                   	pop    %esi
  801b8b:	5f                   	pop    %edi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    
  801b8e:	66 90                	xchg   %ax,%ax
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	f7 f7                	div    %edi
  801b94:	31 ff                	xor    %edi,%edi
  801b96:	89 fa                	mov    %edi,%edx
  801b98:	83 c4 1c             	add    $0x1c,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5f                   	pop    %edi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    
  801ba0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ba5:	89 eb                	mov    %ebp,%ebx
  801ba7:	29 fb                	sub    %edi,%ebx
  801ba9:	89 f9                	mov    %edi,%ecx
  801bab:	d3 e6                	shl    %cl,%esi
  801bad:	89 c5                	mov    %eax,%ebp
  801baf:	88 d9                	mov    %bl,%cl
  801bb1:	d3 ed                	shr    %cl,%ebp
  801bb3:	89 e9                	mov    %ebp,%ecx
  801bb5:	09 f1                	or     %esi,%ecx
  801bb7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bbb:	89 f9                	mov    %edi,%ecx
  801bbd:	d3 e0                	shl    %cl,%eax
  801bbf:	89 c5                	mov    %eax,%ebp
  801bc1:	89 d6                	mov    %edx,%esi
  801bc3:	88 d9                	mov    %bl,%cl
  801bc5:	d3 ee                	shr    %cl,%esi
  801bc7:	89 f9                	mov    %edi,%ecx
  801bc9:	d3 e2                	shl    %cl,%edx
  801bcb:	8b 44 24 08          	mov    0x8(%esp),%eax
  801bcf:	88 d9                	mov    %bl,%cl
  801bd1:	d3 e8                	shr    %cl,%eax
  801bd3:	09 c2                	or     %eax,%edx
  801bd5:	89 d0                	mov    %edx,%eax
  801bd7:	89 f2                	mov    %esi,%edx
  801bd9:	f7 74 24 0c          	divl   0xc(%esp)
  801bdd:	89 d6                	mov    %edx,%esi
  801bdf:	89 c3                	mov    %eax,%ebx
  801be1:	f7 e5                	mul    %ebp
  801be3:	39 d6                	cmp    %edx,%esi
  801be5:	72 19                	jb     801c00 <__udivdi3+0xfc>
  801be7:	74 0b                	je     801bf4 <__udivdi3+0xf0>
  801be9:	89 d8                	mov    %ebx,%eax
  801beb:	31 ff                	xor    %edi,%edi
  801bed:	e9 58 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801bf2:	66 90                	xchg   %ax,%ax
  801bf4:	8b 54 24 08          	mov    0x8(%esp),%edx
  801bf8:	89 f9                	mov    %edi,%ecx
  801bfa:	d3 e2                	shl    %cl,%edx
  801bfc:	39 c2                	cmp    %eax,%edx
  801bfe:	73 e9                	jae    801be9 <__udivdi3+0xe5>
  801c00:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c03:	31 ff                	xor    %edi,%edi
  801c05:	e9 40 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801c0a:	66 90                	xchg   %ax,%ax
  801c0c:	31 c0                	xor    %eax,%eax
  801c0e:	e9 37 ff ff ff       	jmp    801b4a <__udivdi3+0x46>
  801c13:	90                   	nop

00801c14 <__umoddi3>:
  801c14:	55                   	push   %ebp
  801c15:	57                   	push   %edi
  801c16:	56                   	push   %esi
  801c17:	53                   	push   %ebx
  801c18:	83 ec 1c             	sub    $0x1c,%esp
  801c1b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c1f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c23:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c27:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c33:	89 f3                	mov    %esi,%ebx
  801c35:	89 fa                	mov    %edi,%edx
  801c37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c3b:	89 34 24             	mov    %esi,(%esp)
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	75 1a                	jne    801c5c <__umoddi3+0x48>
  801c42:	39 f7                	cmp    %esi,%edi
  801c44:	0f 86 a2 00 00 00    	jbe    801cec <__umoddi3+0xd8>
  801c4a:	89 c8                	mov    %ecx,%eax
  801c4c:	89 f2                	mov    %esi,%edx
  801c4e:	f7 f7                	div    %edi
  801c50:	89 d0                	mov    %edx,%eax
  801c52:	31 d2                	xor    %edx,%edx
  801c54:	83 c4 1c             	add    $0x1c,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
  801c5c:	39 f0                	cmp    %esi,%eax
  801c5e:	0f 87 ac 00 00 00    	ja     801d10 <__umoddi3+0xfc>
  801c64:	0f bd e8             	bsr    %eax,%ebp
  801c67:	83 f5 1f             	xor    $0x1f,%ebp
  801c6a:	0f 84 ac 00 00 00    	je     801d1c <__umoddi3+0x108>
  801c70:	bf 20 00 00 00       	mov    $0x20,%edi
  801c75:	29 ef                	sub    %ebp,%edi
  801c77:	89 fe                	mov    %edi,%esi
  801c79:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801c7d:	89 e9                	mov    %ebp,%ecx
  801c7f:	d3 e0                	shl    %cl,%eax
  801c81:	89 d7                	mov    %edx,%edi
  801c83:	89 f1                	mov    %esi,%ecx
  801c85:	d3 ef                	shr    %cl,%edi
  801c87:	09 c7                	or     %eax,%edi
  801c89:	89 e9                	mov    %ebp,%ecx
  801c8b:	d3 e2                	shl    %cl,%edx
  801c8d:	89 14 24             	mov    %edx,(%esp)
  801c90:	89 d8                	mov    %ebx,%eax
  801c92:	d3 e0                	shl    %cl,%eax
  801c94:	89 c2                	mov    %eax,%edx
  801c96:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c9a:	d3 e0                	shl    %cl,%eax
  801c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca0:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ca4:	89 f1                	mov    %esi,%ecx
  801ca6:	d3 e8                	shr    %cl,%eax
  801ca8:	09 d0                	or     %edx,%eax
  801caa:	d3 eb                	shr    %cl,%ebx
  801cac:	89 da                	mov    %ebx,%edx
  801cae:	f7 f7                	div    %edi
  801cb0:	89 d3                	mov    %edx,%ebx
  801cb2:	f7 24 24             	mull   (%esp)
  801cb5:	89 c6                	mov    %eax,%esi
  801cb7:	89 d1                	mov    %edx,%ecx
  801cb9:	39 d3                	cmp    %edx,%ebx
  801cbb:	0f 82 87 00 00 00    	jb     801d48 <__umoddi3+0x134>
  801cc1:	0f 84 91 00 00 00    	je     801d58 <__umoddi3+0x144>
  801cc7:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ccb:	29 f2                	sub    %esi,%edx
  801ccd:	19 cb                	sbb    %ecx,%ebx
  801ccf:	89 d8                	mov    %ebx,%eax
  801cd1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801cd5:	d3 e0                	shl    %cl,%eax
  801cd7:	89 e9                	mov    %ebp,%ecx
  801cd9:	d3 ea                	shr    %cl,%edx
  801cdb:	09 d0                	or     %edx,%eax
  801cdd:	89 e9                	mov    %ebp,%ecx
  801cdf:	d3 eb                	shr    %cl,%ebx
  801ce1:	89 da                	mov    %ebx,%edx
  801ce3:	83 c4 1c             	add    $0x1c,%esp
  801ce6:	5b                   	pop    %ebx
  801ce7:	5e                   	pop    %esi
  801ce8:	5f                   	pop    %edi
  801ce9:	5d                   	pop    %ebp
  801cea:	c3                   	ret    
  801ceb:	90                   	nop
  801cec:	89 fd                	mov    %edi,%ebp
  801cee:	85 ff                	test   %edi,%edi
  801cf0:	75 0b                	jne    801cfd <__umoddi3+0xe9>
  801cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf7:	31 d2                	xor    %edx,%edx
  801cf9:	f7 f7                	div    %edi
  801cfb:	89 c5                	mov    %eax,%ebp
  801cfd:	89 f0                	mov    %esi,%eax
  801cff:	31 d2                	xor    %edx,%edx
  801d01:	f7 f5                	div    %ebp
  801d03:	89 c8                	mov    %ecx,%eax
  801d05:	f7 f5                	div    %ebp
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	e9 44 ff ff ff       	jmp    801c52 <__umoddi3+0x3e>
  801d0e:	66 90                	xchg   %ax,%ax
  801d10:	89 c8                	mov    %ecx,%eax
  801d12:	89 f2                	mov    %esi,%edx
  801d14:	83 c4 1c             	add    $0x1c,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    
  801d1c:	3b 04 24             	cmp    (%esp),%eax
  801d1f:	72 06                	jb     801d27 <__umoddi3+0x113>
  801d21:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d25:	77 0f                	ja     801d36 <__umoddi3+0x122>
  801d27:	89 f2                	mov    %esi,%edx
  801d29:	29 f9                	sub    %edi,%ecx
  801d2b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d2f:	89 14 24             	mov    %edx,(%esp)
  801d32:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d36:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d3a:	8b 14 24             	mov    (%esp),%edx
  801d3d:	83 c4 1c             	add    $0x1c,%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5f                   	pop    %edi
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    
  801d45:	8d 76 00             	lea    0x0(%esi),%esi
  801d48:	2b 04 24             	sub    (%esp),%eax
  801d4b:	19 fa                	sbb    %edi,%edx
  801d4d:	89 d1                	mov    %edx,%ecx
  801d4f:	89 c6                	mov    %eax,%esi
  801d51:	e9 71 ff ff ff       	jmp    801cc7 <__umoddi3+0xb3>
  801d56:	66 90                	xchg   %ax,%ax
  801d58:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d5c:	72 ea                	jb     801d48 <__umoddi3+0x134>
  801d5e:	89 d9                	mov    %ebx,%ecx
  801d60:	e9 62 ff ff ff       	jmp    801cc7 <__umoddi3+0xb3>
