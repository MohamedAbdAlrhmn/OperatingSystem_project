
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e9 00 00 00       	call   80011f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 80 35 80 00       	push   $0x803580
  800091:	6a 12                	push   $0x12
  800093:	68 9c 35 80 00       	push   $0x80359c
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 9b 19 00 00       	call   801a3d <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 ba 35 80 00       	push   $0x8035ba
  8000aa:	50                   	push   %eax
  8000ab:	e8 f0 14 00 00       	call   8015a0 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 89 16 00 00       	call   801744 <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 bc 35 80 00       	push   $0x8035bc
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 0b 15 00 00       	call   8015e4 <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 e0 35 80 00       	push   $0x8035e0
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 53 16 00 00       	call   801744 <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 f8 35 80 00       	push   $0x8035f8
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 9c 35 80 00       	push   $0x80359c
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 46 1a 00 00       	call   801b62 <inctst>

	return;
  80011c:	90                   	nop
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800125:	e8 fa 18 00 00       	call   801a24 <sys_getenvindex>
  80012a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	89 d0                	mov    %edx,%eax
  800132:	c1 e0 03             	shl    $0x3,%eax
  800135:	01 d0                	add    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800142:	01 d0                	add    %edx,%eax
  800144:	c1 e0 04             	shl    $0x4,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800151:	a1 20 40 80 00       	mov    0x804020,%eax
  800156:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80015c:	84 c0                	test   %al,%al
  80015e:	74 0f                	je     80016f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800160:	a1 20 40 80 00       	mov    0x804020,%eax
  800165:	05 5c 05 00 00       	add    $0x55c,%eax
  80016a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800173:	7e 0a                	jle    80017f <libmain+0x60>
		binaryname = argv[0];
  800175:	8b 45 0c             	mov    0xc(%ebp),%eax
  800178:	8b 00                	mov    (%eax),%eax
  80017a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	e8 ab fe ff ff       	call   800038 <_main>
  80018d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800190:	e8 9c 16 00 00       	call   801831 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 9c 36 80 00       	push   $0x80369c
  80019d:	e8 6d 03 00 00       	call   80050f <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001aa:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	68 c4 36 80 00       	push   $0x8036c4
  8001c5:	e8 45 03 00 00       	call   80050f <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dd:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001ee:	51                   	push   %ecx
  8001ef:	52                   	push   %edx
  8001f0:	50                   	push   %eax
  8001f1:	68 ec 36 80 00       	push   $0x8036ec
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 44 37 80 00       	push   $0x803744
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 9c 36 80 00       	push   $0x80369c
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 1c 16 00 00       	call   80184b <sys_enable_interrupt>

	// exit gracefully
	exit();
  80022f:	e8 19 00 00 00       	call   80024d <exit>
}
  800234:	90                   	nop
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 00                	push   $0x0
  800242:	e8 a9 17 00 00       	call   8019f0 <sys_destroy_env>
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <exit>:

void
exit(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800253:	e8 fe 17 00 00       	call   801a56 <sys_exit_env>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800261:	8d 45 10             	lea    0x10(%ebp),%eax
  800264:	83 c0 04             	add    $0x4,%eax
  800267:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80026f:	85 c0                	test   %eax,%eax
  800271:	74 16                	je     800289 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800273:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	50                   	push   %eax
  80027c:	68 58 37 80 00       	push   $0x803758
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 5d 37 80 00       	push   $0x80375d
  80029a:	e8 70 02 00 00       	call   80050f <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 f3 01 00 00       	call   8004a4 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	68 79 37 80 00       	push   $0x803779
  8002be:	e8 e1 01 00 00       	call   8004a4 <vcprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c6:	e8 82 ff ff ff       	call   80024d <exit>

	// should not return here
	while (1) ;
  8002cb:	eb fe                	jmp    8002cb <_panic+0x70>

008002cd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 50 74             	mov    0x74(%eax),%edx
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	74 14                	je     8002f6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 7c 37 80 00       	push   $0x80377c
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 c8 37 80 00       	push   $0x8037c8
  8002f1:	e8 65 ff ff ff       	call   80025b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800304:	e9 c2 00 00 00       	jmp    8003cb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	01 d0                	add    %edx,%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	85 c0                	test   %eax,%eax
  80031c:	75 08                	jne    800326 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80031e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800321:	e9 a2 00 00 00       	jmp    8003c8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800326:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800334:	eb 69                	jmp    80039f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800336:	a1 20 40 80 00       	mov    0x804020,%eax
  80033b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800341:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800344:	89 d0                	mov    %edx,%eax
  800346:	01 c0                	add    %eax,%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	c1 e0 03             	shl    $0x3,%eax
  80034d:	01 c8                	add    %ecx,%eax
  80034f:	8a 40 04             	mov    0x4(%eax),%al
  800352:	84 c0                	test   %al,%al
  800354:	75 46                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800356:	a1 20 40 80 00       	mov    0x804020,%eax
  80035b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800361:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	01 c0                	add    %eax,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	c1 e0 03             	shl    $0x3,%eax
  80036d:	01 c8                	add    %ecx,%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	75 09                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800393:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039a:	eb 12                	jmp    8003ae <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	ff 45 e8             	incl   -0x18(%ebp)
  80039f:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a4:	8b 50 74             	mov    0x74(%eax),%edx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	77 88                	ja     800336 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b2:	75 14                	jne    8003c8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	68 d4 37 80 00       	push   $0x8037d4
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 c8 37 80 00       	push   $0x8037c8
  8003c3:	e8 93 fe ff ff       	call   80025b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c8:	ff 45 f0             	incl   -0x10(%ebp)
  8003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d1:	0f 8c 32 ff ff ff    	jl     800309 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e5:	eb 26                	jmp    80040d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	01 c0                	add    %eax,%eax
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	c1 e0 03             	shl    $0x3,%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8a 40 04             	mov    0x4(%eax),%al
  800403:	3c 01                	cmp    $0x1,%al
  800405:	75 03                	jne    80040a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800407:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040a:	ff 45 e0             	incl   -0x20(%ebp)
  80040d:	a1 20 40 80 00       	mov    0x804020,%eax
  800412:	8b 50 74             	mov    0x74(%eax),%edx
  800415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	77 cb                	ja     8003e7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 28 38 80 00       	push   $0x803828
  80042c:	6a 44                	push   $0x44
  80042e:	68 c8 37 80 00       	push   $0x8037c8
  800433:	e8 23 fe ff ff       	call   80025b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800438:	90                   	nop
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 48 01             	lea    0x1(%eax),%ecx
  800449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044c:	89 0a                	mov    %ecx,(%edx)
  80044e:	8b 55 08             	mov    0x8(%ebp),%edx
  800451:	88 d1                	mov    %dl,%cl
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800464:	75 2c                	jne    800492 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800466:	a0 24 40 80 00       	mov    0x804024,%al
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	8b 12                	mov    (%edx),%edx
  800473:	89 d1                	mov    %edx,%ecx
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	83 c2 08             	add    $0x8,%edx
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	50                   	push   %eax
  80047f:	51                   	push   %ecx
  800480:	52                   	push   %edx
  800481:	e8 fd 11 00 00       	call   801683 <sys_cputs>
  800486:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
  800495:	8b 40 04             	mov    0x4(%eax),%eax
  800498:	8d 50 01             	lea    0x1(%eax),%edx
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a1:	90                   	nop
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b4:	00 00 00 
	b.cnt = 0;
  8004b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004be:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	68 3b 04 80 00       	push   $0x80043b
  8004d3:	e8 11 02 00 00       	call   8006e9 <vprintfmt>
  8004d8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004db:	a0 24 40 80 00       	mov    0x804024,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	50                   	push   %eax
  8004ed:	52                   	push   %edx
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	83 c0 08             	add    $0x8,%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 86 11 00 00       	call   801683 <sys_cputs>
  8004fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800500:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int cprintf(const char *fmt, ...) {
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800515:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80051c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 f4             	pushl  -0xc(%ebp)
  80052b:	50                   	push   %eax
  80052c:	e8 73 ff ff ff       	call   8004a4 <vcprintf>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800542:	e8 ea 12 00 00       	call   801831 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 48 ff ff ff       	call   8004a4 <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800562:	e8 e4 12 00 00       	call   80184b <sys_enable_interrupt>
	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	53                   	push   %ebx
  800570:	83 ec 14             	sub    $0x14,%esp
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 18             	mov    0x18(%ebp),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058a:	77 55                	ja     8005e1 <printnum+0x75>
  80058c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058f:	72 05                	jb     800596 <printnum+0x2a>
  800591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800594:	77 4b                	ja     8005e1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800596:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800599:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80059c:	8b 45 18             	mov    0x18(%ebp),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	52                   	push   %edx
  8005a5:	50                   	push   %eax
  8005a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ac:	e8 57 2d 00 00       	call   803308 <__udivdi3>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	ff 75 20             	pushl  0x20(%ebp)
  8005ba:	53                   	push   %ebx
  8005bb:	ff 75 18             	pushl  0x18(%ebp)
  8005be:	52                   	push   %edx
  8005bf:	50                   	push   %eax
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 a1 ff ff ff       	call   80056c <printnum>
  8005cb:	83 c4 20             	add    $0x20,%esp
  8005ce:	eb 1a                	jmp    8005ea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 20             	pushl  0x20(%ebp)
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	ff d0                	call   *%eax
  8005de:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e1:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e8:	7f e6                	jg     8005d0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f8:	53                   	push   %ebx
  8005f9:	51                   	push   %ecx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 17 2e 00 00       	call   803418 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 94 3a 80 00       	add    $0x803a94,%eax
  800609:	8a 00                	mov    (%eax),%al
  80060b:	0f be c0             	movsbl %al,%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
}
  80061d:	90                   	nop
  80061e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800626:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062a:	7e 1c                	jle    800648 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 08             	lea    0x8(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 08             	sub    $0x8,%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	eb 40                	jmp    800688 <getuint+0x65>
	else if (lflag)
  800648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064c:	74 1e                	je     80066c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	eb 1c                	jmp    800688 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800691:	7e 1c                	jle    8006af <getint+0x25>
		return va_arg(*ap, long long);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 08             	sub    $0x8,%eax
  8006a8:	8b 50 04             	mov    0x4(%eax),%edx
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	eb 38                	jmp    8006e7 <getint+0x5d>
	else if (lflag)
  8006af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b3:	74 1a                	je     8006cf <getint+0x45>
		return va_arg(*ap, long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	eb 18                	jmp    8006e7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	eb 17                	jmp    80070a <vprintfmt+0x21>
			if (ch == '\0')
  8006f3:	85 db                	test   %ebx,%ebx
  8006f5:	0f 84 af 03 00 00    	je     800aaa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	53                   	push   %ebx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	8d 50 01             	lea    0x1(%eax),%edx
  800710:	89 55 10             	mov    %edx,0x10(%ebp)
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f b6 d8             	movzbl %al,%ebx
  800718:	83 fb 25             	cmp    $0x25,%ebx
  80071b:	75 d6                	jne    8006f3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800721:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800736:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 10             	mov    0x10(%ebp),%eax
  800740:	8d 50 01             	lea    0x1(%eax),%edx
  800743:	89 55 10             	mov    %edx,0x10(%ebp)
  800746:	8a 00                	mov    (%eax),%al
  800748:	0f b6 d8             	movzbl %al,%ebx
  80074b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80074e:	83 f8 55             	cmp    $0x55,%eax
  800751:	0f 87 2b 03 00 00    	ja     800a82 <vprintfmt+0x399>
  800757:	8b 04 85 b8 3a 80 00 	mov    0x803ab8(,%eax,4),%eax
  80075e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800760:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800764:	eb d7                	jmp    80073d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800766:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80076a:	eb d1                	jmp    80073d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800773:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800776:	89 d0                	mov    %edx,%eax
  800778:	c1 e0 02             	shl    $0x2,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	01 c0                	add    %eax,%eax
  80077f:	01 d8                	add    %ebx,%eax
  800781:	83 e8 30             	sub    $0x30,%eax
  800784:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800787:	8b 45 10             	mov    0x10(%ebp),%eax
  80078a:	8a 00                	mov    (%eax),%al
  80078c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078f:	83 fb 2f             	cmp    $0x2f,%ebx
  800792:	7e 3e                	jle    8007d2 <vprintfmt+0xe9>
  800794:	83 fb 39             	cmp    $0x39,%ebx
  800797:	7f 39                	jg     8007d2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800799:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80079c:	eb d5                	jmp    800773 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	83 c0 04             	add    $0x4,%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b2:	eb 1f                	jmp    8007d3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b8:	79 83                	jns    80073d <vprintfmt+0x54>
				width = 0;
  8007ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c1:	e9 77 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007cd:	e9 6b ff ff ff       	jmp    80073d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d7:	0f 89 60 ff ff ff    	jns    80073d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ea:	e9 4e ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f2:	e9 46 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
			break;
  800817:	e9 89 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80082d:	85 db                	test   %ebx,%ebx
  80082f:	79 02                	jns    800833 <vprintfmt+0x14a>
				err = -err;
  800831:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800833:	83 fb 64             	cmp    $0x64,%ebx
  800836:	7f 0b                	jg     800843 <vprintfmt+0x15a>
  800838:	8b 34 9d 00 39 80 00 	mov    0x803900(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 a5 3a 80 00       	push   $0x803aa5
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 5e 02 00 00       	call   800ab2 <printfmt>
  800854:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800857:	e9 49 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80085c:	56                   	push   %esi
  80085d:	68 ae 3a 80 00       	push   $0x803aae
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 45 02 00 00       	call   800ab2 <printfmt>
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 30 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 30                	mov    (%eax),%esi
  800886:	85 f6                	test   %esi,%esi
  800888:	75 05                	jne    80088f <vprintfmt+0x1a6>
				p = "(null)";
  80088a:	be b1 3a 80 00       	mov    $0x803ab1,%esi
			if (width > 0 && padc != '-')
  80088f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800893:	7e 6d                	jle    800902 <vprintfmt+0x219>
  800895:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800899:	74 67                	je     800902 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	50                   	push   %eax
  8008a2:	56                   	push   %esi
  8008a3:	e8 0c 03 00 00       	call   800bb4 <strnlen>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ae:	eb 16                	jmp    8008c6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ca:	7f e4                	jg     8008b0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cc:	eb 34                	jmp    800902 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d2:	74 1c                	je     8008f0 <vprintfmt+0x207>
  8008d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d7:	7e 05                	jle    8008de <vprintfmt+0x1f5>
  8008d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008dc:	7e 12                	jle    8008f0 <vprintfmt+0x207>
					putch('?', putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	6a 3f                	push   $0x3f
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	eb 0f                	jmp    8008ff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	53                   	push   %ebx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 70 01             	lea    0x1(%eax),%esi
  800907:	8a 00                	mov    (%eax),%al
  800909:	0f be d8             	movsbl %al,%ebx
  80090c:	85 db                	test   %ebx,%ebx
  80090e:	74 24                	je     800934 <vprintfmt+0x24b>
  800910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800914:	78 b8                	js     8008ce <vprintfmt+0x1e5>
  800916:	ff 4d e0             	decl   -0x20(%ebp)
  800919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091d:	79 af                	jns    8008ce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091f:	eb 13                	jmp    800934 <vprintfmt+0x24b>
				putch(' ', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	6a 20                	push   $0x20
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	ff 4d e4             	decl   -0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e7                	jg     800921 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80093a:	e9 66 01 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 e8             	pushl  -0x18(%ebp)
  800945:	8d 45 14             	lea    0x14(%ebp),%eax
  800948:	50                   	push   %eax
  800949:	e8 3c fd ff ff       	call   80068a <getint>
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	79 23                	jns    800984 <vprintfmt+0x29b>
				putch('-', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	6a 2d                	push   $0x2d
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800977:	f7 d8                	neg    %eax
  800979:	83 d2 00             	adc    $0x0,%edx
  80097c:	f7 da                	neg    %edx
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800984:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098b:	e9 bc 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 e8             	pushl  -0x18(%ebp)
  800996:	8d 45 14             	lea    0x14(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	e8 84 fc ff ff       	call   800623 <getuint>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 98 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	6a 58                	push   $0x58
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 58                	push   $0x58
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 58                	push   $0x58
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 30                	push   $0x30
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 78                	push   $0x78
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 e8             	pushl  -0x18(%ebp)
  800a33:	8d 45 14             	lea    0x14(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	e8 e7 fb ff ff       	call   800623 <getuint>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	52                   	push   %edx
  800a57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 00 fb ff ff       	call   80056c <printnum>
  800a6c:	83 c4 20             	add    $0x20,%esp
			break;
  800a6f:	eb 34                	jmp    800aa5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
			break;
  800a80:	eb 23                	jmp    800aa5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 25                	push   $0x25
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a92:	ff 4d 10             	decl   0x10(%ebp)
  800a95:	eb 03                	jmp    800a9a <vprintfmt+0x3b1>
  800a97:	ff 4d 10             	decl   0x10(%ebp)
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	48                   	dec    %eax
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	3c 25                	cmp    $0x25,%al
  800aa2:	75 f3                	jne    800a97 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aa4:	90                   	nop
		}
	}
  800aa5:	e9 47 fc ff ff       	jmp    8006f1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aaa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab8:	8d 45 10             	lea    0x10(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 16 fc ff ff       	call   8006e9 <vprintfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad6:	90                   	nop
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 08             	mov    0x8(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 10                	mov    (%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8b 40 04             	mov    0x4(%eax),%eax
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	73 12                	jae    800b0c <sprintputch+0x33>
		*b->buf++ = ch;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	8d 48 01             	lea    0x1(%eax),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 0a                	mov    %ecx,(%edx)
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	88 10                	mov    %dl,(%eax)
}
  800b0c:	90                   	nop
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b34:	74 06                	je     800b3c <vsnprintf+0x2d>
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	7f 07                	jg     800b43 <vsnprintf+0x34>
		return -E_INVAL;
  800b3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b41:	eb 20                	jmp    800b63 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b43:	ff 75 14             	pushl  0x14(%ebp)
  800b46:	ff 75 10             	pushl  0x10(%ebp)
  800b49:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	68 d9 0a 80 00       	push   $0x800ad9
  800b52:	e8 92 fb ff ff       	call   8006e9 <vprintfmt>
  800b57:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b6e:	83 c0 04             	add    $0x4,%eax
  800b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 89 ff ff ff       	call   800b0f <vsnprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9e:	eb 06                	jmp    800ba6 <strlen+0x15>
		n++;
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 f1                	jne    800ba0 <strlen+0xf>
		n++;
	return n;
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc1:	eb 09                	jmp    800bcc <strnlen+0x18>
		n++;
  800bc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc6:	ff 45 08             	incl   0x8(%ebp)
  800bc9:	ff 4d 0c             	decl   0xc(%ebp)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 09                	je     800bdb <strnlen+0x27>
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	75 e8                	jne    800bc3 <strnlen+0xf>
		n++;
	return n;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bec:	90                   	nop
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bff:	8a 12                	mov    (%edx),%dl
  800c01:	88 10                	mov    %dl,(%eax)
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 e4                	jne    800bed <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c21:	eb 1f                	jmp    800c42 <strncpy+0x34>
		*dst++ = *src;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8a 12                	mov    (%edx),%dl
  800c31:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	74 03                	je     800c3f <strncpy+0x31>
			src++;
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3f:	ff 45 fc             	incl   -0x4(%ebp)
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c48:	72 d9                	jb     800c23 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5f:	74 30                	je     800c91 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c61:	eb 16                	jmp    800c79 <strlcpy+0x2a>
			*dst++ = *src++;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c80:	74 09                	je     800c8b <strlcpy+0x3c>
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 d8                	jne    800c63 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c97:	29 c2                	sub    %eax,%edx
  800c99:	89 d0                	mov    %edx,%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca0:	eb 06                	jmp    800ca8 <strcmp+0xb>
		p++, q++;
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	74 0e                	je     800cbf <strcmp+0x22>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 10                	mov    (%eax),%dl
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	38 c2                	cmp    %al,%dl
  800cbd:	74 e3                	je     800ca2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f b6 d0             	movzbl %al,%edx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	29 c2                	sub    %eax,%edx
  800cd1:	89 d0                	mov    %edx,%eax
}
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd8:	eb 09                	jmp    800ce3 <strncmp+0xe>
		n--, p++, q++;
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	74 17                	je     800d00 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 0e                	je     800d00 <strncmp+0x2b>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 10                	mov    (%eax),%dl
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	38 c2                	cmp    %al,%dl
  800cfe:	74 da                	je     800cda <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strncmp+0x38>
		return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 14                	jmp    800d21 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 d0             	movzbl %al,%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 c0             	movzbl %al,%eax
  800d1d:	29 c2                	sub    %eax,%edx
  800d1f:	89 d0                	mov    %edx,%eax
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2f:	eb 12                	jmp    800d43 <strchr+0x20>
		if (*s == c)
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d39:	75 05                	jne    800d40 <strchr+0x1d>
			return (char *) s;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	eb 11                	jmp    800d51 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	75 e5                	jne    800d31 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5f:	eb 0d                	jmp    800d6e <strfind+0x1b>
		if (*s == c)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d69:	74 0e                	je     800d79 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	75 ea                	jne    800d61 <strfind+0xe>
  800d77:	eb 01                	jmp    800d7a <strfind+0x27>
		if (*s == c)
			break;
  800d79:	90                   	nop
	return (char *) s;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d91:	eb 0e                	jmp    800da1 <memset+0x22>
		*p++ = c;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da1:	ff 4d f8             	decl   -0x8(%ebp)
  800da4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da8:	79 e9                	jns    800d93 <memset+0x14>
		*p++ = c;

	return v;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc1:	eb 16                	jmp    800dd9 <memcpy+0x2a>
		*d++ = *s++;
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 dd                	jne    800dc3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e03:	73 50                	jae    800e55 <memmove+0x6a>
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	76 43                	jbe    800e55 <memmove+0x6a>
		s += n;
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1e:	eb 10                	jmp    800e30 <memmove+0x45>
			*--d = *--s;
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	ff 4d fc             	decl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 e3                	jne    800e20 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3d:	eb 23                	jmp    800e62 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 dd                	jne    800e3f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e79:	eb 2a                	jmp    800ea5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 16                	je     800e9f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	eb 18                	jmp    800eb7 <memcmp+0x50>
		s1++, s2++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 c9                	jne    800e7b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eca:	eb 15                	jmp    800ee1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	39 c2                	cmp    %eax,%edx
  800edc:	74 0d                	je     800eeb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee7:	72 e3                	jb     800ecc <memfind+0x13>
  800ee9:	eb 01                	jmp    800eec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eeb:	90                   	nop
	return (void *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	eb 03                	jmp    800f0a <strtol+0x19>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 20                	cmp    $0x20,%al
  800f11:	74 f4                	je     800f07 <strtol+0x16>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 09                	cmp    $0x9,%al
  800f1a:	74 eb                	je     800f07 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 2b                	cmp    $0x2b,%al
  800f23:	75 05                	jne    800f2a <strtol+0x39>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	eb 13                	jmp    800f3d <strtol+0x4c>
	else if (*s == '-')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	75 0a                	jne    800f3d <strtol+0x4c>
		s++, neg = 1;
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	74 06                	je     800f49 <strtol+0x58>
  800f43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f47:	75 20                	jne    800f69 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 17                	jne    800f69 <strtol+0x78>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	40                   	inc    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 78                	cmp    $0x78,%al
  800f5a:	75 0d                	jne    800f69 <strtol+0x78>
		s += 2, base = 16;
  800f5c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f60:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f67:	eb 28                	jmp    800f91 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 15                	jne    800f84 <strtol+0x93>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 0c                	jne    800f84 <strtol+0x93>
		s++, base = 8;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f82:	eb 0d                	jmp    800f91 <strtol+0xa0>
	else if (base == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strtol+0xa0>
		base = 10;
  800f8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2f                	cmp    $0x2f,%al
  800f98:	7e 19                	jle    800fb3 <strtol+0xc2>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 39                	cmp    $0x39,%al
  800fa1:	7f 10                	jg     800fb3 <strtol+0xc2>
			dig = *s - '0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f be c0             	movsbl %al,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb1:	eb 42                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 60                	cmp    $0x60,%al
  800fba:	7e 19                	jle    800fd5 <strtol+0xe4>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 7a                	cmp    $0x7a,%al
  800fc3:	7f 10                	jg     800fd5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	83 e8 57             	sub    $0x57,%eax
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	eb 20                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 40                	cmp    $0x40,%al
  800fdc:	7e 39                	jle    801017 <strtol+0x126>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 5a                	cmp    $0x5a,%al
  800fe5:	7f 30                	jg     801017 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f be c0             	movsbl %al,%eax
  800fef:	83 e8 37             	sub    $0x37,%eax
  800ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffb:	7d 19                	jge    801016 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	89 c2                	mov    %eax,%edx
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801011:	e9 7b ff ff ff       	jmp    800f91 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801016:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 08                	je     801025 <strtol+0x134>
		*endptr = (char *) s;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 07                	je     801032 <strtol+0x141>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	f7 d8                	neg    %eax
  801030:	eb 03                	jmp    801035 <strtol+0x144>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <ltostr>:

void
ltostr(long value, char *str)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104f:	79 13                	jns    801064 <ltostr+0x2d>
	{
		neg = 1;
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801061:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106c:	99                   	cltd   
  80106d:	f7 f9                	idiv   %ecx
  80106f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8d 50 01             	lea    0x1(%eax),%edx
  801078:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801085:	83 c2 30             	add    $0x30,%edx
  801088:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801092:	f7 e9                	imul   %ecx
  801094:	c1 fa 02             	sar    $0x2,%edx
  801097:	89 c8                	mov    %ecx,%eax
  801099:	c1 f8 1f             	sar    $0x1f,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ab:	f7 e9                	imul   %ecx
  8010ad:	c1 fa 02             	sar    $0x2,%edx
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 f8 1f             	sar    $0x1f,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
  8010b9:	c1 e0 02             	shl    $0x2,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	01 c0                	add    %eax,%eax
  8010c0:	29 c1                	sub    %eax,%ecx
  8010c2:	89 ca                	mov    %ecx,%edx
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	75 9c                	jne    801064 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	48                   	dec    %eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010da:	74 3d                	je     801119 <ltostr+0xe2>
		start = 1 ;
  8010dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e3:	eb 34                	jmp    801119 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801111:	88 02                	mov    %al,(%edx)
		start++ ;
  801113:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801116:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c c4                	jl     8010e5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801121:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 54 fa ff ff       	call   800b91 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 46 fa ff ff       	call   800b91 <strlen>
  80114b:	83 c4 04             	add    $0x4,%esp
  80114e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 17                	jmp    801178 <strcconcat+0x49>
		final[s] = str1[s] ;
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c8                	add    %ecx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117e:	7c e1                	jl     801161 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118e:	eb 1f                	jmp    8011af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 c2                	add    %eax,%edx
  8011a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ac:	ff 45 f8             	incl   -0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b5:	7c d9                	jl     801190 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c2:	90                   	nop
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	eb 0c                	jmp    8011f6 <strsplit+0x31>
			*string++ = 0;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 18                	je     801217 <strsplit+0x52>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f be c0             	movsbl %al,%eax
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 13 fb ff ff       	call   800d23 <strchr>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 d3                	jne    8011ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	74 5a                	je     80127a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	83 f8 0f             	cmp    $0xf,%eax
  801228:	75 07                	jne    801231 <strsplit+0x6c>
		{
			return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	eb 66                	jmp    801297 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 14             	mov    0x14(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	eb 03                	jmp    801254 <strsplit+0x8f>
			string++;
  801251:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	74 8b                	je     8011e8 <strsplit+0x23>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	50                   	push   %eax
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 b5 fa ff ff       	call   800d23 <strchr>
  80126e:	83 c4 08             	add    $0x8,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	74 dc                	je     801251 <strsplit+0x8c>
			string++;
	}
  801275:	e9 6e ff ff ff       	jmp    8011e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80129f:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 1f                	je     8012c7 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012a8:	e8 1d 00 00 00       	call   8012ca <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	68 10 3c 80 00       	push   $0x803c10
  8012b5:	e8 55 f2 ff ff       	call   80050f <cprintf>
  8012ba:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012bd:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012c4:	00 00 00 
	}
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8012d0:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012d7:	00 00 00 
  8012da:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012e1:	00 00 00 
  8012e4:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8012eb:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8012ee:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012f5:	00 00 00 
  8012f8:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012ff:	00 00 00 
  801302:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801309:	00 00 00 
	uint32 arr_size = 0;
  80130c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801313:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80131a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80131d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801322:	2d 00 10 00 00       	sub    $0x1000,%eax
  801327:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80132c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801333:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801336:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80133d:	a1 20 41 80 00       	mov    0x804120,%eax
  801342:	c1 e0 04             	shl    $0x4,%eax
  801345:	89 c2                	mov    %eax,%edx
  801347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80134a:	01 d0                	add    %edx,%eax
  80134c:	48                   	dec    %eax
  80134d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801350:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801353:	ba 00 00 00 00       	mov    $0x0,%edx
  801358:	f7 75 ec             	divl   -0x14(%ebp)
  80135b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80135e:	29 d0                	sub    %edx,%eax
  801360:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801363:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80136a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801372:	2d 00 10 00 00       	sub    $0x1000,%eax
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	6a 06                	push   $0x6
  80137c:	ff 75 f4             	pushl  -0xc(%ebp)
  80137f:	50                   	push   %eax
  801380:	e8 42 04 00 00       	call   8017c7 <sys_allocate_chunk>
  801385:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801388:	a1 20 41 80 00       	mov    0x804120,%eax
  80138d:	83 ec 0c             	sub    $0xc,%esp
  801390:	50                   	push   %eax
  801391:	e8 b7 0a 00 00       	call   801e4d <initialize_MemBlocksList>
  801396:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  801399:	a1 48 41 80 00       	mov    0x804148,%eax
  80139e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8013ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ae:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8013b5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013b9:	75 14                	jne    8013cf <initialize_dyn_block_system+0x105>
  8013bb:	83 ec 04             	sub    $0x4,%esp
  8013be:	68 35 3c 80 00       	push   $0x803c35
  8013c3:	6a 33                	push   $0x33
  8013c5:	68 53 3c 80 00       	push   $0x803c53
  8013ca:	e8 8c ee ff ff       	call   80025b <_panic>
  8013cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d2:	8b 00                	mov    (%eax),%eax
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	74 10                	je     8013e8 <initialize_dyn_block_system+0x11e>
  8013d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013e0:	8b 52 04             	mov    0x4(%edx),%edx
  8013e3:	89 50 04             	mov    %edx,0x4(%eax)
  8013e6:	eb 0b                	jmp    8013f3 <initialize_dyn_block_system+0x129>
  8013e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013eb:	8b 40 04             	mov    0x4(%eax),%eax
  8013ee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f6:	8b 40 04             	mov    0x4(%eax),%eax
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	74 0f                	je     80140c <initialize_dyn_block_system+0x142>
  8013fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801400:	8b 40 04             	mov    0x4(%eax),%eax
  801403:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801406:	8b 12                	mov    (%edx),%edx
  801408:	89 10                	mov    %edx,(%eax)
  80140a:	eb 0a                	jmp    801416 <initialize_dyn_block_system+0x14c>
  80140c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	a3 48 41 80 00       	mov    %eax,0x804148
  801416:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801419:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80141f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801422:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801429:	a1 54 41 80 00       	mov    0x804154,%eax
  80142e:	48                   	dec    %eax
  80142f:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801434:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801438:	75 14                	jne    80144e <initialize_dyn_block_system+0x184>
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	68 60 3c 80 00       	push   $0x803c60
  801442:	6a 34                	push   $0x34
  801444:	68 53 3c 80 00       	push   $0x803c53
  801449:	e8 0d ee ff ff       	call   80025b <_panic>
  80144e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801454:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801457:	89 10                	mov    %edx,(%eax)
  801459:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145c:	8b 00                	mov    (%eax),%eax
  80145e:	85 c0                	test   %eax,%eax
  801460:	74 0d                	je     80146f <initialize_dyn_block_system+0x1a5>
  801462:	a1 38 41 80 00       	mov    0x804138,%eax
  801467:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80146a:	89 50 04             	mov    %edx,0x4(%eax)
  80146d:	eb 08                	jmp    801477 <initialize_dyn_block_system+0x1ad>
  80146f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801472:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147a:	a3 38 41 80 00       	mov    %eax,0x804138
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801489:	a1 44 41 80 00       	mov    0x804144,%eax
  80148e:	40                   	inc    %eax
  80148f:	a3 44 41 80 00       	mov    %eax,0x804144
}
  801494:	90                   	nop
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80149d:	e8 f7 fd ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a6:	75 07                	jne    8014af <malloc+0x18>
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ad:	eb 14                	jmp    8014c3 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	68 84 3c 80 00       	push   $0x803c84
  8014b7:	6a 46                	push   $0x46
  8014b9:	68 53 3c 80 00       	push   $0x803c53
  8014be:	e8 98 ed ff ff       	call   80025b <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014c3:	c9                   	leave  
  8014c4:	c3                   	ret    

008014c5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014c5:	55                   	push   %ebp
  8014c6:	89 e5                	mov    %esp,%ebp
  8014c8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014cb:	83 ec 04             	sub    $0x4,%esp
  8014ce:	68 ac 3c 80 00       	push   $0x803cac
  8014d3:	6a 61                	push   $0x61
  8014d5:	68 53 3c 80 00       	push   $0x803c53
  8014da:	e8 7c ed ff ff       	call   80025b <_panic>

008014df <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 38             	sub    $0x38,%esp
  8014e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e8:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014eb:	e8 a9 fd ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f4:	75 0a                	jne    801500 <smalloc+0x21>
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	e9 9e 00 00 00       	jmp    80159e <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801500:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801507:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	48                   	dec    %eax
  801510:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801513:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801516:	ba 00 00 00 00       	mov    $0x0,%edx
  80151b:	f7 75 f0             	divl   -0x10(%ebp)
  80151e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801521:	29 d0                	sub    %edx,%eax
  801523:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801526:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80152d:	e8 63 06 00 00       	call   801b95 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801532:	85 c0                	test   %eax,%eax
  801534:	74 11                	je     801547 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	ff 75 e8             	pushl  -0x18(%ebp)
  80153c:	e8 ce 0c 00 00       	call   80220f <alloc_block_FF>
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80154b:	74 4c                	je     801599 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80154d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801550:	8b 40 08             	mov    0x8(%eax),%eax
  801553:	89 c2                	mov    %eax,%edx
  801555:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801559:	52                   	push   %edx
  80155a:	50                   	push   %eax
  80155b:	ff 75 0c             	pushl  0xc(%ebp)
  80155e:	ff 75 08             	pushl  0x8(%ebp)
  801561:	e8 b4 03 00 00       	call   80191a <sys_createSharedObject>
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  80156c:	83 ec 08             	sub    $0x8,%esp
  80156f:	ff 75 e0             	pushl  -0x20(%ebp)
  801572:	68 cf 3c 80 00       	push   $0x803ccf
  801577:	e8 93 ef ff ff       	call   80050f <cprintf>
  80157c:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80157f:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801583:	74 14                	je     801599 <smalloc+0xba>
  801585:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801589:	74 0e                	je     801599 <smalloc+0xba>
  80158b:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80158f:	74 08                	je     801599 <smalloc+0xba>
			return (void*) mem_block->sva;
  801591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801594:	8b 40 08             	mov    0x8(%eax),%eax
  801597:	eb 05                	jmp    80159e <smalloc+0xbf>
	}
	return NULL;
  801599:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a6:	e8 ee fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015ab:	83 ec 04             	sub    $0x4,%esp
  8015ae:	68 e4 3c 80 00       	push   $0x803ce4
  8015b3:	68 ab 00 00 00       	push   $0xab
  8015b8:	68 53 3c 80 00       	push   $0x803c53
  8015bd:	e8 99 ec ff ff       	call   80025b <_panic>

008015c2 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c8:	e8 cc fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015cd:	83 ec 04             	sub    $0x4,%esp
  8015d0:	68 08 3d 80 00       	push   $0x803d08
  8015d5:	68 ef 00 00 00       	push   $0xef
  8015da:	68 53 3c 80 00       	push   $0x803c53
  8015df:	e8 77 ec ff ff       	call   80025b <_panic>

008015e4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	68 30 3d 80 00       	push   $0x803d30
  8015f2:	68 03 01 00 00       	push   $0x103
  8015f7:	68 53 3c 80 00       	push   $0x803c53
  8015fc:	e8 5a ec ff ff       	call   80025b <_panic>

00801601 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	68 54 3d 80 00       	push   $0x803d54
  80160f:	68 0e 01 00 00       	push   $0x10e
  801614:	68 53 3c 80 00       	push   $0x803c53
  801619:	e8 3d ec ff ff       	call   80025b <_panic>

0080161e <shrink>:

}
void shrink(uint32 newSize)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801624:	83 ec 04             	sub    $0x4,%esp
  801627:	68 54 3d 80 00       	push   $0x803d54
  80162c:	68 13 01 00 00       	push   $0x113
  801631:	68 53 3c 80 00       	push   $0x803c53
  801636:	e8 20 ec ff ff       	call   80025b <_panic>

0080163b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	68 54 3d 80 00       	push   $0x803d54
  801649:	68 18 01 00 00       	push   $0x118
  80164e:	68 53 3c 80 00       	push   $0x803c53
  801653:	e8 03 ec ff ff       	call   80025b <_panic>

00801658 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	57                   	push   %edi
  80165c:	56                   	push   %esi
  80165d:	53                   	push   %ebx
  80165e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801661:	8b 45 08             	mov    0x8(%ebp),%eax
  801664:	8b 55 0c             	mov    0xc(%ebp),%edx
  801667:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801670:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801673:	cd 30                	int    $0x30
  801675:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80167b:	83 c4 10             	add    $0x10,%esp
  80167e:	5b                   	pop    %ebx
  80167f:	5e                   	pop    %esi
  801680:	5f                   	pop    %edi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	8b 45 10             	mov    0x10(%ebp),%eax
  80168c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80168f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	52                   	push   %edx
  80169b:	ff 75 0c             	pushl  0xc(%ebp)
  80169e:	50                   	push   %eax
  80169f:	6a 00                	push   $0x0
  8016a1:	e8 b2 ff ff ff       	call   801658 <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
}
  8016a9:	90                   	nop
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016af:	6a 00                	push   $0x0
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 01                	push   $0x1
  8016bb:	e8 98 ff ff ff       	call   801658 <syscall>
  8016c0:	83 c4 18             	add    $0x18,%esp
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	52                   	push   %edx
  8016d5:	50                   	push   %eax
  8016d6:	6a 05                	push   $0x5
  8016d8:	e8 7b ff ff ff       	call   801658 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	c9                   	leave  
  8016e1:	c3                   	ret    

008016e2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	56                   	push   %esi
  8016e6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016e7:	8b 75 18             	mov    0x18(%ebp),%esi
  8016ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	56                   	push   %esi
  8016f7:	53                   	push   %ebx
  8016f8:	51                   	push   %ecx
  8016f9:	52                   	push   %edx
  8016fa:	50                   	push   %eax
  8016fb:	6a 06                	push   $0x6
  8016fd:	e8 56 ff ff ff       	call   801658 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801708:	5b                   	pop    %ebx
  801709:	5e                   	pop    %esi
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80170f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	52                   	push   %edx
  80171c:	50                   	push   %eax
  80171d:	6a 07                	push   $0x7
  80171f:	e8 34 ff ff ff       	call   801658 <syscall>
  801724:	83 c4 18             	add    $0x18,%esp
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	6a 08                	push   $0x8
  80173a:	e8 19 ff ff ff       	call   801658 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
}
  801742:	c9                   	leave  
  801743:	c3                   	ret    

00801744 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 09                	push   $0x9
  801753:	e8 00 ff ff ff       	call   801658 <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 0a                	push   $0xa
  80176c:	e8 e7 fe ff ff       	call   801658 <syscall>
  801771:	83 c4 18             	add    $0x18,%esp
}
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 0b                	push   $0xb
  801785:	e8 ce fe ff ff       	call   801658 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	ff 75 0c             	pushl  0xc(%ebp)
  80179b:	ff 75 08             	pushl  0x8(%ebp)
  80179e:	6a 0f                	push   $0xf
  8017a0:	e8 b3 fe ff ff       	call   801658 <syscall>
  8017a5:	83 c4 18             	add    $0x18,%esp
	return;
  8017a8:	90                   	nop
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	6a 10                	push   $0x10
  8017bc:	e8 97 fe ff ff       	call   801658 <syscall>
  8017c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c4:	90                   	nop
}
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	ff 75 10             	pushl  0x10(%ebp)
  8017d1:	ff 75 0c             	pushl  0xc(%ebp)
  8017d4:	ff 75 08             	pushl  0x8(%ebp)
  8017d7:	6a 11                	push   $0x11
  8017d9:	e8 7a fe ff ff       	call   801658 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e1:	90                   	nop
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 0c                	push   $0xc
  8017f3:	e8 60 fe ff ff       	call   801658 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	ff 75 08             	pushl  0x8(%ebp)
  80180b:	6a 0d                	push   $0xd
  80180d:	e8 46 fe ff ff       	call   801658 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 0e                	push   $0xe
  801826:	e8 2d fe ff ff       	call   801658 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	90                   	nop
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 13                	push   $0x13
  801840:	e8 13 fe ff ff       	call   801658 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	90                   	nop
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 14                	push   $0x14
  80185a:	e8 f9 fd ff ff       	call   801658 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	90                   	nop
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_cputc>:


void
sys_cputc(const char c)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	8b 45 08             	mov    0x8(%ebp),%eax
  80186e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801871:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	50                   	push   %eax
  80187e:	6a 15                	push   $0x15
  801880:	e8 d3 fd ff ff       	call   801658 <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	90                   	nop
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 16                	push   $0x16
  80189a:	e8 b9 fd ff ff       	call   801658 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	90                   	nop
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	50                   	push   %eax
  8018b5:	6a 17                	push   $0x17
  8018b7:	e8 9c fd ff ff       	call   801658 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	52                   	push   %edx
  8018d1:	50                   	push   %eax
  8018d2:	6a 1a                	push   $0x1a
  8018d4:	e8 7f fd ff ff       	call   801658 <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	52                   	push   %edx
  8018ee:	50                   	push   %eax
  8018ef:	6a 18                	push   $0x18
  8018f1:	e8 62 fd ff ff       	call   801658 <syscall>
  8018f6:	83 c4 18             	add    $0x18,%esp
}
  8018f9:	90                   	nop
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801902:	8b 45 08             	mov    0x8(%ebp),%eax
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	52                   	push   %edx
  80190c:	50                   	push   %eax
  80190d:	6a 19                	push   $0x19
  80190f:	e8 44 fd ff ff       	call   801658 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 04             	sub    $0x4,%esp
  801920:	8b 45 10             	mov    0x10(%ebp),%eax
  801923:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801926:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801929:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	51                   	push   %ecx
  801933:	52                   	push   %edx
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	50                   	push   %eax
  801938:	6a 1b                	push   $0x1b
  80193a:	e8 19 fd ff ff       	call   801658 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	6a 1c                	push   $0x1c
  801957:	e8 fc fc ff ff       	call   801658 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801964:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196a:	8b 45 08             	mov    0x8(%ebp),%eax
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	51                   	push   %ecx
  801972:	52                   	push   %edx
  801973:	50                   	push   %eax
  801974:	6a 1d                	push   $0x1d
  801976:	e8 dd fc ff ff       	call   801658 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 1e                	push   $0x1e
  801993:	e8 c0 fc ff ff       	call   801658 <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 1f                	push   $0x1f
  8019ac:	e8 a7 fc ff ff       	call   801658 <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	6a 00                	push   $0x0
  8019be:	ff 75 14             	pushl  0x14(%ebp)
  8019c1:	ff 75 10             	pushl  0x10(%ebp)
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	50                   	push   %eax
  8019c8:	6a 20                	push   $0x20
  8019ca:	e8 89 fc ff ff       	call   801658 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	50                   	push   %eax
  8019e3:	6a 21                	push   $0x21
  8019e5:	e8 6e fc ff ff       	call   801658 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	50                   	push   %eax
  8019ff:	6a 22                	push   $0x22
  801a01:	e8 52 fc ff ff       	call   801658 <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 02                	push   $0x2
  801a1a:	e8 39 fc ff ff       	call   801658 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 03                	push   $0x3
  801a33:	e8 20 fc ff ff       	call   801658 <syscall>
  801a38:	83 c4 18             	add    $0x18,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 04                	push   $0x4
  801a4c:	e8 07 fc ff ff       	call   801658 <syscall>
  801a51:	83 c4 18             	add    $0x18,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_exit_env>:


void sys_exit_env(void)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 23                	push   $0x23
  801a65:	e8 ee fb ff ff       	call   801658 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	90                   	nop
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a76:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a79:	8d 50 04             	lea    0x4(%eax),%edx
  801a7c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	52                   	push   %edx
  801a86:	50                   	push   %eax
  801a87:	6a 24                	push   $0x24
  801a89:	e8 ca fb ff ff       	call   801658 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
	return result;
  801a91:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9a:	89 01                	mov    %eax,(%ecx)
  801a9c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	c9                   	leave  
  801aa3:	c2 04 00             	ret    $0x4

00801aa6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	ff 75 10             	pushl  0x10(%ebp)
  801ab0:	ff 75 0c             	pushl  0xc(%ebp)
  801ab3:	ff 75 08             	pushl  0x8(%ebp)
  801ab6:	6a 12                	push   $0x12
  801ab8:	e8 9b fb ff ff       	call   801658 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac0:	90                   	nop
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 25                	push   $0x25
  801ad2:	e8 81 fb ff ff       	call   801658 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ae8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	50                   	push   %eax
  801af5:	6a 26                	push   $0x26
  801af7:	e8 5c fb ff ff       	call   801658 <syscall>
  801afc:	83 c4 18             	add    $0x18,%esp
	return ;
  801aff:	90                   	nop
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <rsttst>:
void rsttst()
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 28                	push   $0x28
  801b11:	e8 42 fb ff ff       	call   801658 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
	return ;
  801b19:	90                   	nop
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	8b 45 14             	mov    0x14(%ebp),%eax
  801b25:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b28:	8b 55 18             	mov    0x18(%ebp),%edx
  801b2b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	ff 75 10             	pushl  0x10(%ebp)
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	ff 75 08             	pushl  0x8(%ebp)
  801b3a:	6a 27                	push   $0x27
  801b3c:	e8 17 fb ff ff       	call   801658 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
	return ;
  801b44:	90                   	nop
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <chktst>:
void chktst(uint32 n)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	6a 29                	push   $0x29
  801b57:	e8 fc fa ff ff       	call   801658 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5f:	90                   	nop
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <inctst>:

void inctst()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 2a                	push   $0x2a
  801b71:	e8 e2 fa ff ff       	call   801658 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
	return ;
  801b79:	90                   	nop
}
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <gettst>:
uint32 gettst()
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 2b                	push   $0x2b
  801b8b:	e8 c8 fa ff ff       	call   801658 <syscall>
  801b90:	83 c4 18             	add    $0x18,%esp
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 2c                	push   $0x2c
  801ba7:	e8 ac fa ff ff       	call   801658 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
  801baf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bb2:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bb6:	75 07                	jne    801bbf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bb8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbd:	eb 05                	jmp    801bc4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 2c                	push   $0x2c
  801bd8:	e8 7b fa ff ff       	call   801658 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
  801be0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801be3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801be7:	75 07                	jne    801bf0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801be9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bee:	eb 05                	jmp    801bf5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 2c                	push   $0x2c
  801c09:	e8 4a fa ff ff       	call   801658 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
  801c11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c14:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c18:	75 07                	jne    801c21 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1f:	eb 05                	jmp    801c26 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 2c                	push   $0x2c
  801c3a:	e8 19 fa ff ff       	call   801658 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
  801c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c45:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c49:	75 07                	jne    801c52 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c50:	eb 05                	jmp    801c57 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	ff 75 08             	pushl  0x8(%ebp)
  801c67:	6a 2d                	push   $0x2d
  801c69:	e8 ea f9 ff ff       	call   801658 <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c71:	90                   	nop
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	53                   	push   %ebx
  801c87:	51                   	push   %ecx
  801c88:	52                   	push   %edx
  801c89:	50                   	push   %eax
  801c8a:	6a 2e                	push   $0x2e
  801c8c:	e8 c7 f9 ff ff       	call   801658 <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	52                   	push   %edx
  801ca9:	50                   	push   %eax
  801caa:	6a 2f                	push   $0x2f
  801cac:	e8 a7 f9 ff ff       	call   801658 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cbc:	83 ec 0c             	sub    $0xc,%esp
  801cbf:	68 64 3d 80 00       	push   $0x803d64
  801cc4:	e8 46 e8 ff ff       	call   80050f <cprintf>
  801cc9:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ccc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	68 90 3d 80 00       	push   $0x803d90
  801cdb:	e8 2f e8 ff ff       	call   80050f <cprintf>
  801ce0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ce3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ce7:	a1 38 41 80 00       	mov    0x804138,%eax
  801cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cef:	eb 56                	jmp    801d47 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cf1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf5:	74 1c                	je     801d13 <print_mem_block_lists+0x5d>
  801cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfa:	8b 50 08             	mov    0x8(%eax),%edx
  801cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d00:	8b 48 08             	mov    0x8(%eax),%ecx
  801d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d06:	8b 40 0c             	mov    0xc(%eax),%eax
  801d09:	01 c8                	add    %ecx,%eax
  801d0b:	39 c2                	cmp    %eax,%edx
  801d0d:	73 04                	jae    801d13 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d0f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d16:	8b 50 08             	mov    0x8(%eax),%edx
  801d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1f:	01 c2                	add    %eax,%edx
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	8b 40 08             	mov    0x8(%eax),%eax
  801d27:	83 ec 04             	sub    $0x4,%esp
  801d2a:	52                   	push   %edx
  801d2b:	50                   	push   %eax
  801d2c:	68 a5 3d 80 00       	push   $0x803da5
  801d31:	e8 d9 e7 ff ff       	call   80050f <cprintf>
  801d36:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d3f:	a1 40 41 80 00       	mov    0x804140,%eax
  801d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4b:	74 07                	je     801d54 <print_mem_block_lists+0x9e>
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	8b 00                	mov    (%eax),%eax
  801d52:	eb 05                	jmp    801d59 <print_mem_block_lists+0xa3>
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
  801d59:	a3 40 41 80 00       	mov    %eax,0x804140
  801d5e:	a1 40 41 80 00       	mov    0x804140,%eax
  801d63:	85 c0                	test   %eax,%eax
  801d65:	75 8a                	jne    801cf1 <print_mem_block_lists+0x3b>
  801d67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6b:	75 84                	jne    801cf1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d6d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d71:	75 10                	jne    801d83 <print_mem_block_lists+0xcd>
  801d73:	83 ec 0c             	sub    $0xc,%esp
  801d76:	68 b4 3d 80 00       	push   $0x803db4
  801d7b:	e8 8f e7 ff ff       	call   80050f <cprintf>
  801d80:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d83:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d8a:	83 ec 0c             	sub    $0xc,%esp
  801d8d:	68 d8 3d 80 00       	push   $0x803dd8
  801d92:	e8 78 e7 ff ff       	call   80050f <cprintf>
  801d97:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d9a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d9e:	a1 40 40 80 00       	mov    0x804040,%eax
  801da3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da6:	eb 56                	jmp    801dfe <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801da8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dac:	74 1c                	je     801dca <print_mem_block_lists+0x114>
  801dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db1:	8b 50 08             	mov    0x8(%eax),%edx
  801db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db7:	8b 48 08             	mov    0x8(%eax),%ecx
  801dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbd:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc0:	01 c8                	add    %ecx,%eax
  801dc2:	39 c2                	cmp    %eax,%edx
  801dc4:	73 04                	jae    801dca <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dc6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcd:	8b 50 08             	mov    0x8(%eax),%edx
  801dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd6:	01 c2                	add    %eax,%edx
  801dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddb:	8b 40 08             	mov    0x8(%eax),%eax
  801dde:	83 ec 04             	sub    $0x4,%esp
  801de1:	52                   	push   %edx
  801de2:	50                   	push   %eax
  801de3:	68 a5 3d 80 00       	push   $0x803da5
  801de8:	e8 22 e7 ff ff       	call   80050f <cprintf>
  801ded:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801df6:	a1 48 40 80 00       	mov    0x804048,%eax
  801dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e02:	74 07                	je     801e0b <print_mem_block_lists+0x155>
  801e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e07:	8b 00                	mov    (%eax),%eax
  801e09:	eb 05                	jmp    801e10 <print_mem_block_lists+0x15a>
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e10:	a3 48 40 80 00       	mov    %eax,0x804048
  801e15:	a1 48 40 80 00       	mov    0x804048,%eax
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	75 8a                	jne    801da8 <print_mem_block_lists+0xf2>
  801e1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e22:	75 84                	jne    801da8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e24:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e28:	75 10                	jne    801e3a <print_mem_block_lists+0x184>
  801e2a:	83 ec 0c             	sub    $0xc,%esp
  801e2d:	68 f0 3d 80 00       	push   $0x803df0
  801e32:	e8 d8 e6 ff ff       	call   80050f <cprintf>
  801e37:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	68 64 3d 80 00       	push   $0x803d64
  801e42:	e8 c8 e6 ff ff       	call   80050f <cprintf>
  801e47:	83 c4 10             	add    $0x10,%esp

}
  801e4a:	90                   	nop
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e53:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e5a:	00 00 00 
  801e5d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e64:	00 00 00 
  801e67:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e6e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e78:	e9 9e 00 00 00       	jmp    801f1b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e7d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e85:	c1 e2 04             	shl    $0x4,%edx
  801e88:	01 d0                	add    %edx,%eax
  801e8a:	85 c0                	test   %eax,%eax
  801e8c:	75 14                	jne    801ea2 <initialize_MemBlocksList+0x55>
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	68 18 3e 80 00       	push   $0x803e18
  801e96:	6a 46                	push   $0x46
  801e98:	68 3b 3e 80 00       	push   $0x803e3b
  801e9d:	e8 b9 e3 ff ff       	call   80025b <_panic>
  801ea2:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eaa:	c1 e2 04             	shl    $0x4,%edx
  801ead:	01 d0                	add    %edx,%eax
  801eaf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801eb5:	89 10                	mov    %edx,(%eax)
  801eb7:	8b 00                	mov    (%eax),%eax
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	74 18                	je     801ed5 <initialize_MemBlocksList+0x88>
  801ebd:	a1 48 41 80 00       	mov    0x804148,%eax
  801ec2:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ec8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ecb:	c1 e1 04             	shl    $0x4,%ecx
  801ece:	01 ca                	add    %ecx,%edx
  801ed0:	89 50 04             	mov    %edx,0x4(%eax)
  801ed3:	eb 12                	jmp    801ee7 <initialize_MemBlocksList+0x9a>
  801ed5:	a1 50 40 80 00       	mov    0x804050,%eax
  801eda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edd:	c1 e2 04             	shl    $0x4,%edx
  801ee0:	01 d0                	add    %edx,%eax
  801ee2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ee7:	a1 50 40 80 00       	mov    0x804050,%eax
  801eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eef:	c1 e2 04             	shl    $0x4,%edx
  801ef2:	01 d0                	add    %edx,%eax
  801ef4:	a3 48 41 80 00       	mov    %eax,0x804148
  801ef9:	a1 50 40 80 00       	mov    0x804050,%eax
  801efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f01:	c1 e2 04             	shl    $0x4,%edx
  801f04:	01 d0                	add    %edx,%eax
  801f06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f0d:	a1 54 41 80 00       	mov    0x804154,%eax
  801f12:	40                   	inc    %eax
  801f13:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f18:	ff 45 f4             	incl   -0xc(%ebp)
  801f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f21:	0f 82 56 ff ff ff    	jb     801e7d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f27:	90                   	nop
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	8b 00                	mov    (%eax),%eax
  801f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f38:	eb 19                	jmp    801f53 <find_block+0x29>
	{
		if(va==point->sva)
  801f3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3d:	8b 40 08             	mov    0x8(%eax),%eax
  801f40:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f43:	75 05                	jne    801f4a <find_block+0x20>
		   return point;
  801f45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f48:	eb 36                	jmp    801f80 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	8b 40 08             	mov    0x8(%eax),%eax
  801f50:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f53:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f57:	74 07                	je     801f60 <find_block+0x36>
  801f59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5c:	8b 00                	mov    (%eax),%eax
  801f5e:	eb 05                	jmp    801f65 <find_block+0x3b>
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	8b 55 08             	mov    0x8(%ebp),%edx
  801f68:	89 42 08             	mov    %eax,0x8(%edx)
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	8b 40 08             	mov    0x8(%eax),%eax
  801f71:	85 c0                	test   %eax,%eax
  801f73:	75 c5                	jne    801f3a <find_block+0x10>
  801f75:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f79:	75 bf                	jne    801f3a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f88:	a1 40 40 80 00       	mov    0x804040,%eax
  801f8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f90:	a1 44 40 80 00       	mov    0x804044,%eax
  801f95:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f9e:	74 24                	je     801fc4 <insert_sorted_allocList+0x42>
  801fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa3:	8b 50 08             	mov    0x8(%eax),%edx
  801fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa9:	8b 40 08             	mov    0x8(%eax),%eax
  801fac:	39 c2                	cmp    %eax,%edx
  801fae:	76 14                	jbe    801fc4 <insert_sorted_allocList+0x42>
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	8b 50 08             	mov    0x8(%eax),%edx
  801fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fb9:	8b 40 08             	mov    0x8(%eax),%eax
  801fbc:	39 c2                	cmp    %eax,%edx
  801fbe:	0f 82 60 01 00 00    	jb     802124 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fc8:	75 65                	jne    80202f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fce:	75 14                	jne    801fe4 <insert_sorted_allocList+0x62>
  801fd0:	83 ec 04             	sub    $0x4,%esp
  801fd3:	68 18 3e 80 00       	push   $0x803e18
  801fd8:	6a 6b                	push   $0x6b
  801fda:	68 3b 3e 80 00       	push   $0x803e3b
  801fdf:	e8 77 e2 ff ff       	call   80025b <_panic>
  801fe4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	89 10                	mov    %edx,(%eax)
  801fef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	74 0d                	je     802005 <insert_sorted_allocList+0x83>
  801ff8:	a1 40 40 80 00       	mov    0x804040,%eax
  801ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  802000:	89 50 04             	mov    %edx,0x4(%eax)
  802003:	eb 08                	jmp    80200d <insert_sorted_allocList+0x8b>
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	a3 44 40 80 00       	mov    %eax,0x804044
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	a3 40 40 80 00       	mov    %eax,0x804040
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80201f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802024:	40                   	inc    %eax
  802025:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80202a:	e9 dc 01 00 00       	jmp    80220b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	8b 50 08             	mov    0x8(%eax),%edx
  802035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802038:	8b 40 08             	mov    0x8(%eax),%eax
  80203b:	39 c2                	cmp    %eax,%edx
  80203d:	77 6c                	ja     8020ab <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80203f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802043:	74 06                	je     80204b <insert_sorted_allocList+0xc9>
  802045:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802049:	75 14                	jne    80205f <insert_sorted_allocList+0xdd>
  80204b:	83 ec 04             	sub    $0x4,%esp
  80204e:	68 54 3e 80 00       	push   $0x803e54
  802053:	6a 6f                	push   $0x6f
  802055:	68 3b 3e 80 00       	push   $0x803e3b
  80205a:	e8 fc e1 ff ff       	call   80025b <_panic>
  80205f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802062:	8b 50 04             	mov    0x4(%eax),%edx
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	89 50 04             	mov    %edx,0x4(%eax)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802071:	89 10                	mov    %edx,(%eax)
  802073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802076:	8b 40 04             	mov    0x4(%eax),%eax
  802079:	85 c0                	test   %eax,%eax
  80207b:	74 0d                	je     80208a <insert_sorted_allocList+0x108>
  80207d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802080:	8b 40 04             	mov    0x4(%eax),%eax
  802083:	8b 55 08             	mov    0x8(%ebp),%edx
  802086:	89 10                	mov    %edx,(%eax)
  802088:	eb 08                	jmp    802092 <insert_sorted_allocList+0x110>
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	a3 40 40 80 00       	mov    %eax,0x804040
  802092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802095:	8b 55 08             	mov    0x8(%ebp),%edx
  802098:	89 50 04             	mov    %edx,0x4(%eax)
  80209b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020a0:	40                   	inc    %eax
  8020a1:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020a6:	e9 60 01 00 00       	jmp    80220b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	8b 50 08             	mov    0x8(%eax),%edx
  8020b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b4:	8b 40 08             	mov    0x8(%eax),%eax
  8020b7:	39 c2                	cmp    %eax,%edx
  8020b9:	0f 82 4c 01 00 00    	jb     80220b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020c3:	75 14                	jne    8020d9 <insert_sorted_allocList+0x157>
  8020c5:	83 ec 04             	sub    $0x4,%esp
  8020c8:	68 8c 3e 80 00       	push   $0x803e8c
  8020cd:	6a 73                	push   $0x73
  8020cf:	68 3b 3e 80 00       	push   $0x803e3b
  8020d4:	e8 82 e1 ff ff       	call   80025b <_panic>
  8020d9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	89 50 04             	mov    %edx,0x4(%eax)
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	8b 40 04             	mov    0x4(%eax),%eax
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	74 0c                	je     8020fb <insert_sorted_allocList+0x179>
  8020ef:	a1 44 40 80 00       	mov    0x804044,%eax
  8020f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f7:	89 10                	mov    %edx,(%eax)
  8020f9:	eb 08                	jmp    802103 <insert_sorted_allocList+0x181>
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	a3 40 40 80 00       	mov    %eax,0x804040
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	a3 44 40 80 00       	mov    %eax,0x804044
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802114:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802119:	40                   	inc    %eax
  80211a:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80211f:	e9 e7 00 00 00       	jmp    80220b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802124:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80212a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802131:	a1 40 40 80 00       	mov    0x804040,%eax
  802136:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802139:	e9 9d 00 00 00       	jmp    8021db <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	8b 00                	mov    (%eax),%eax
  802143:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	8b 50 08             	mov    0x8(%eax),%edx
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 40 08             	mov    0x8(%eax),%eax
  802152:	39 c2                	cmp    %eax,%edx
  802154:	76 7d                	jbe    8021d3 <insert_sorted_allocList+0x251>
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	8b 50 08             	mov    0x8(%eax),%edx
  80215c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215f:	8b 40 08             	mov    0x8(%eax),%eax
  802162:	39 c2                	cmp    %eax,%edx
  802164:	73 6d                	jae    8021d3 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216a:	74 06                	je     802172 <insert_sorted_allocList+0x1f0>
  80216c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802170:	75 14                	jne    802186 <insert_sorted_allocList+0x204>
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 b0 3e 80 00       	push   $0x803eb0
  80217a:	6a 7f                	push   $0x7f
  80217c:	68 3b 3e 80 00       	push   $0x803e3b
  802181:	e8 d5 e0 ff ff       	call   80025b <_panic>
  802186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802189:	8b 10                	mov    (%eax),%edx
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	89 10                	mov    %edx,(%eax)
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	8b 00                	mov    (%eax),%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	74 0b                	je     8021a4 <insert_sorted_allocList+0x222>
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a1:	89 50 04             	mov    %edx,0x4(%eax)
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021aa:	89 10                	mov    %edx,(%eax)
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b2:	89 50 04             	mov    %edx,0x4(%eax)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8b 00                	mov    (%eax),%eax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	75 08                	jne    8021c6 <insert_sorted_allocList+0x244>
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8021c6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021cb:	40                   	inc    %eax
  8021cc:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021d1:	eb 39                	jmp    80220c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021d3:	a1 48 40 80 00       	mov    0x804048,%eax
  8021d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021df:	74 07                	je     8021e8 <insert_sorted_allocList+0x266>
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	8b 00                	mov    (%eax),%eax
  8021e6:	eb 05                	jmp    8021ed <insert_sorted_allocList+0x26b>
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ed:	a3 48 40 80 00       	mov    %eax,0x804048
  8021f2:	a1 48 40 80 00       	mov    0x804048,%eax
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	0f 85 3f ff ff ff    	jne    80213e <insert_sorted_allocList+0x1bc>
  8021ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802203:	0f 85 35 ff ff ff    	jne    80213e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802209:	eb 01                	jmp    80220c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80220b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80220c:	90                   	nop
  80220d:	c9                   	leave  
  80220e:	c3                   	ret    

0080220f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802215:	a1 38 41 80 00       	mov    0x804138,%eax
  80221a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221d:	e9 85 01 00 00       	jmp    8023a7 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	8b 40 0c             	mov    0xc(%eax),%eax
  802228:	3b 45 08             	cmp    0x8(%ebp),%eax
  80222b:	0f 82 6e 01 00 00    	jb     80239f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	8b 40 0c             	mov    0xc(%eax),%eax
  802237:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223a:	0f 85 8a 00 00 00    	jne    8022ca <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802240:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802244:	75 17                	jne    80225d <alloc_block_FF+0x4e>
  802246:	83 ec 04             	sub    $0x4,%esp
  802249:	68 e4 3e 80 00       	push   $0x803ee4
  80224e:	68 93 00 00 00       	push   $0x93
  802253:	68 3b 3e 80 00       	push   $0x803e3b
  802258:	e8 fe df ff ff       	call   80025b <_panic>
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	8b 00                	mov    (%eax),%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	74 10                	je     802276 <alloc_block_FF+0x67>
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 00                	mov    (%eax),%eax
  80226b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226e:	8b 52 04             	mov    0x4(%edx),%edx
  802271:	89 50 04             	mov    %edx,0x4(%eax)
  802274:	eb 0b                	jmp    802281 <alloc_block_FF+0x72>
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 40 04             	mov    0x4(%eax),%eax
  80227c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 40 04             	mov    0x4(%eax),%eax
  802287:	85 c0                	test   %eax,%eax
  802289:	74 0f                	je     80229a <alloc_block_FF+0x8b>
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 04             	mov    0x4(%eax),%eax
  802291:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802294:	8b 12                	mov    (%edx),%edx
  802296:	89 10                	mov    %edx,(%eax)
  802298:	eb 0a                	jmp    8022a4 <alloc_block_FF+0x95>
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	8b 00                	mov    (%eax),%eax
  80229f:	a3 38 41 80 00       	mov    %eax,0x804138
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8022bc:	48                   	dec    %eax
  8022bd:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	e9 10 01 00 00       	jmp    8023da <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d3:	0f 86 c6 00 00 00    	jbe    80239f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022d9:	a1 48 41 80 00       	mov    0x804148,%eax
  8022de:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 50 08             	mov    0x8(%eax),%edx
  8022e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ea:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f3:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022fa:	75 17                	jne    802313 <alloc_block_FF+0x104>
  8022fc:	83 ec 04             	sub    $0x4,%esp
  8022ff:	68 e4 3e 80 00       	push   $0x803ee4
  802304:	68 9b 00 00 00       	push   $0x9b
  802309:	68 3b 3e 80 00       	push   $0x803e3b
  80230e:	e8 48 df ff ff       	call   80025b <_panic>
  802313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	74 10                	je     80232c <alloc_block_FF+0x11d>
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	8b 00                	mov    (%eax),%eax
  802321:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802324:	8b 52 04             	mov    0x4(%edx),%edx
  802327:	89 50 04             	mov    %edx,0x4(%eax)
  80232a:	eb 0b                	jmp    802337 <alloc_block_FF+0x128>
  80232c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232f:	8b 40 04             	mov    0x4(%eax),%eax
  802332:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802337:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233a:	8b 40 04             	mov    0x4(%eax),%eax
  80233d:	85 c0                	test   %eax,%eax
  80233f:	74 0f                	je     802350 <alloc_block_FF+0x141>
  802341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802344:	8b 40 04             	mov    0x4(%eax),%eax
  802347:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234a:	8b 12                	mov    (%edx),%edx
  80234c:	89 10                	mov    %edx,(%eax)
  80234e:	eb 0a                	jmp    80235a <alloc_block_FF+0x14b>
  802350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802353:	8b 00                	mov    (%eax),%eax
  802355:	a3 48 41 80 00       	mov    %eax,0x804148
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802366:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236d:	a1 54 41 80 00       	mov    0x804154,%eax
  802372:	48                   	dec    %eax
  802373:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 50 08             	mov    0x8(%eax),%edx
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	01 c2                	add    %eax,%edx
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 40 0c             	mov    0xc(%eax),%eax
  80238f:	2b 45 08             	sub    0x8(%ebp),%eax
  802392:	89 c2                	mov    %eax,%edx
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80239a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239d:	eb 3b                	jmp    8023da <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80239f:	a1 40 41 80 00       	mov    0x804140,%eax
  8023a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ab:	74 07                	je     8023b4 <alloc_block_FF+0x1a5>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	eb 05                	jmp    8023b9 <alloc_block_FF+0x1aa>
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b9:	a3 40 41 80 00       	mov    %eax,0x804140
  8023be:	a1 40 41 80 00       	mov    0x804140,%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	0f 85 57 fe ff ff    	jne    802222 <alloc_block_FF+0x13>
  8023cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cf:	0f 85 4d fe ff ff    	jne    802222 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023e9:	a1 38 41 80 00       	mov    0x804138,%eax
  8023ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f1:	e9 df 00 00 00       	jmp    8024d5 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ff:	0f 82 c8 00 00 00    	jb     8024cd <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 0c             	mov    0xc(%eax),%eax
  80240b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240e:	0f 85 8a 00 00 00    	jne    80249e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802414:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802418:	75 17                	jne    802431 <alloc_block_BF+0x55>
  80241a:	83 ec 04             	sub    $0x4,%esp
  80241d:	68 e4 3e 80 00       	push   $0x803ee4
  802422:	68 b7 00 00 00       	push   $0xb7
  802427:	68 3b 3e 80 00       	push   $0x803e3b
  80242c:	e8 2a de ff ff       	call   80025b <_panic>
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 10                	je     80244a <alloc_block_BF+0x6e>
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 00                	mov    (%eax),%eax
  80243f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802442:	8b 52 04             	mov    0x4(%edx),%edx
  802445:	89 50 04             	mov    %edx,0x4(%eax)
  802448:	eb 0b                	jmp    802455 <alloc_block_BF+0x79>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 04             	mov    0x4(%eax),%eax
  80245b:	85 c0                	test   %eax,%eax
  80245d:	74 0f                	je     80246e <alloc_block_BF+0x92>
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 40 04             	mov    0x4(%eax),%eax
  802465:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802468:	8b 12                	mov    (%edx),%edx
  80246a:	89 10                	mov    %edx,(%eax)
  80246c:	eb 0a                	jmp    802478 <alloc_block_BF+0x9c>
  80246e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802471:	8b 00                	mov    (%eax),%eax
  802473:	a3 38 41 80 00       	mov    %eax,0x804138
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248b:	a1 44 41 80 00       	mov    0x804144,%eax
  802490:	48                   	dec    %eax
  802491:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	e9 4d 01 00 00       	jmp    8025eb <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a7:	76 24                	jbe    8024cd <alloc_block_BF+0xf1>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8024af:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024b2:	73 19                	jae    8024cd <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024b4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	8b 40 08             	mov    0x8(%eax),%eax
  8024ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024cd:	a1 40 41 80 00       	mov    0x804140,%eax
  8024d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d9:	74 07                	je     8024e2 <alloc_block_BF+0x106>
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	eb 05                	jmp    8024e7 <alloc_block_BF+0x10b>
  8024e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e7:	a3 40 41 80 00       	mov    %eax,0x804140
  8024ec:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	0f 85 fd fe ff ff    	jne    8023f6 <alloc_block_BF+0x1a>
  8024f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fd:	0f 85 f3 fe ff ff    	jne    8023f6 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802503:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802507:	0f 84 d9 00 00 00    	je     8025e6 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80250d:	a1 48 41 80 00       	mov    0x804148,%eax
  802512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802518:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80251e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802521:	8b 55 08             	mov    0x8(%ebp),%edx
  802524:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802527:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80252b:	75 17                	jne    802544 <alloc_block_BF+0x168>
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	68 e4 3e 80 00       	push   $0x803ee4
  802535:	68 c7 00 00 00       	push   $0xc7
  80253a:	68 3b 3e 80 00       	push   $0x803e3b
  80253f:	e8 17 dd ff ff       	call   80025b <_panic>
  802544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 10                	je     80255d <alloc_block_BF+0x181>
  80254d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802555:	8b 52 04             	mov    0x4(%edx),%edx
  802558:	89 50 04             	mov    %edx,0x4(%eax)
  80255b:	eb 0b                	jmp    802568 <alloc_block_BF+0x18c>
  80255d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802560:	8b 40 04             	mov    0x4(%eax),%eax
  802563:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256b:	8b 40 04             	mov    0x4(%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 0f                	je     802581 <alloc_block_BF+0x1a5>
  802572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257b:	8b 12                	mov    (%edx),%edx
  80257d:	89 10                	mov    %edx,(%eax)
  80257f:	eb 0a                	jmp    80258b <alloc_block_BF+0x1af>
  802581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	a3 48 41 80 00       	mov    %eax,0x804148
  80258b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802597:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259e:	a1 54 41 80 00       	mov    0x804154,%eax
  8025a3:	48                   	dec    %eax
  8025a4:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025a9:	83 ec 08             	sub    $0x8,%esp
  8025ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8025af:	68 38 41 80 00       	push   $0x804138
  8025b4:	e8 71 f9 ff ff       	call   801f2a <find_block>
  8025b9:	83 c4 10             	add    $0x10,%esp
  8025bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c2:	8b 50 08             	mov    0x8(%eax),%edx
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	01 c2                	add    %eax,%edx
  8025ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cd:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d6:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d9:	89 c2                	mov    %eax,%edx
  8025db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025de:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e4:	eb 05                	jmp    8025eb <alloc_block_BF+0x20f>
	}
	return NULL;
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
  8025f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025f3:	a1 28 40 80 00       	mov    0x804028,%eax
  8025f8:	85 c0                	test   %eax,%eax
  8025fa:	0f 85 de 01 00 00    	jne    8027de <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802600:	a1 38 41 80 00       	mov    0x804138,%eax
  802605:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802608:	e9 9e 01 00 00       	jmp    8027ab <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 40 0c             	mov    0xc(%eax),%eax
  802613:	3b 45 08             	cmp    0x8(%ebp),%eax
  802616:	0f 82 87 01 00 00    	jb     8027a3 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 0c             	mov    0xc(%eax),%eax
  802622:	3b 45 08             	cmp    0x8(%ebp),%eax
  802625:	0f 85 95 00 00 00    	jne    8026c0 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80262b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262f:	75 17                	jne    802648 <alloc_block_NF+0x5b>
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 e4 3e 80 00       	push   $0x803ee4
  802639:	68 e0 00 00 00       	push   $0xe0
  80263e:	68 3b 3e 80 00       	push   $0x803e3b
  802643:	e8 13 dc ff ff       	call   80025b <_panic>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 10                	je     802661 <alloc_block_NF+0x74>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802659:	8b 52 04             	mov    0x4(%edx),%edx
  80265c:	89 50 04             	mov    %edx,0x4(%eax)
  80265f:	eb 0b                	jmp    80266c <alloc_block_NF+0x7f>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	74 0f                	je     802685 <alloc_block_NF+0x98>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267f:	8b 12                	mov    (%edx),%edx
  802681:	89 10                	mov    %edx,(%eax)
  802683:	eb 0a                	jmp    80268f <alloc_block_NF+0xa2>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	a3 38 41 80 00       	mov    %eax,0x804138
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a2:	a1 44 41 80 00       	mov    0x804144,%eax
  8026a7:	48                   	dec    %eax
  8026a8:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 40 08             	mov    0x8(%eax),%eax
  8026b3:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	e9 f8 04 00 00       	jmp    802bb8 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026c9:	0f 86 d4 00 00 00    	jbe    8027a3 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026cf:	a1 48 41 80 00       	mov    0x804148,%eax
  8026d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 50 08             	mov    0x8(%eax),%edx
  8026dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e0:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e9:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f0:	75 17                	jne    802709 <alloc_block_NF+0x11c>
  8026f2:	83 ec 04             	sub    $0x4,%esp
  8026f5:	68 e4 3e 80 00       	push   $0x803ee4
  8026fa:	68 e9 00 00 00       	push   $0xe9
  8026ff:	68 3b 3e 80 00       	push   $0x803e3b
  802704:	e8 52 db ff ff       	call   80025b <_panic>
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	74 10                	je     802722 <alloc_block_NF+0x135>
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802715:	8b 00                	mov    (%eax),%eax
  802717:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271a:	8b 52 04             	mov    0x4(%edx),%edx
  80271d:	89 50 04             	mov    %edx,0x4(%eax)
  802720:	eb 0b                	jmp    80272d <alloc_block_NF+0x140>
  802722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802725:	8b 40 04             	mov    0x4(%eax),%eax
  802728:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	8b 40 04             	mov    0x4(%eax),%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	74 0f                	je     802746 <alloc_block_NF+0x159>
  802737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273a:	8b 40 04             	mov    0x4(%eax),%eax
  80273d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802740:	8b 12                	mov    (%edx),%edx
  802742:	89 10                	mov    %edx,(%eax)
  802744:	eb 0a                	jmp    802750 <alloc_block_NF+0x163>
  802746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	a3 48 41 80 00       	mov    %eax,0x804148
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802763:	a1 54 41 80 00       	mov    0x804154,%eax
  802768:	48                   	dec    %eax
  802769:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80276e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802771:	8b 40 08             	mov    0x8(%eax),%eax
  802774:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 50 08             	mov    0x8(%eax),%edx
  80277f:	8b 45 08             	mov    0x8(%ebp),%eax
  802782:	01 c2                	add    %eax,%edx
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	8b 40 0c             	mov    0xc(%eax),%eax
  802790:	2b 45 08             	sub    0x8(%ebp),%eax
  802793:	89 c2                	mov    %eax,%edx
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	e9 15 04 00 00       	jmp    802bb8 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027af:	74 07                	je     8027b8 <alloc_block_NF+0x1cb>
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	eb 05                	jmp    8027bd <alloc_block_NF+0x1d0>
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bd:	a3 40 41 80 00       	mov    %eax,0x804140
  8027c2:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	0f 85 3e fe ff ff    	jne    80260d <alloc_block_NF+0x20>
  8027cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d3:	0f 85 34 fe ff ff    	jne    80260d <alloc_block_NF+0x20>
  8027d9:	e9 d5 03 00 00       	jmp    802bb3 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027de:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e6:	e9 b1 01 00 00       	jmp    80299c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 50 08             	mov    0x8(%eax),%edx
  8027f1:	a1 28 40 80 00       	mov    0x804028,%eax
  8027f6:	39 c2                	cmp    %eax,%edx
  8027f8:	0f 82 96 01 00 00    	jb     802994 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 0c             	mov    0xc(%eax),%eax
  802804:	3b 45 08             	cmp    0x8(%ebp),%eax
  802807:	0f 82 87 01 00 00    	jb     802994 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 0c             	mov    0xc(%eax),%eax
  802813:	3b 45 08             	cmp    0x8(%ebp),%eax
  802816:	0f 85 95 00 00 00    	jne    8028b1 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80281c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802820:	75 17                	jne    802839 <alloc_block_NF+0x24c>
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	68 e4 3e 80 00       	push   $0x803ee4
  80282a:	68 fc 00 00 00       	push   $0xfc
  80282f:	68 3b 3e 80 00       	push   $0x803e3b
  802834:	e8 22 da ff ff       	call   80025b <_panic>
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 10                	je     802852 <alloc_block_NF+0x265>
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284a:	8b 52 04             	mov    0x4(%edx),%edx
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	eb 0b                	jmp    80285d <alloc_block_NF+0x270>
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 0f                	je     802876 <alloc_block_NF+0x289>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802870:	8b 12                	mov    (%edx),%edx
  802872:	89 10                	mov    %edx,(%eax)
  802874:	eb 0a                	jmp    802880 <alloc_block_NF+0x293>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	a3 38 41 80 00       	mov    %eax,0x804138
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802893:	a1 44 41 80 00       	mov    0x804144,%eax
  802898:	48                   	dec    %eax
  802899:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 40 08             	mov    0x8(%eax),%eax
  8028a4:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	e9 07 03 00 00       	jmp    802bb8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ba:	0f 86 d4 00 00 00    	jbe    802994 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028c0:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 50 08             	mov    0x8(%eax),%edx
  8028ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028da:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e1:	75 17                	jne    8028fa <alloc_block_NF+0x30d>
  8028e3:	83 ec 04             	sub    $0x4,%esp
  8028e6:	68 e4 3e 80 00       	push   $0x803ee4
  8028eb:	68 04 01 00 00       	push   $0x104
  8028f0:	68 3b 3e 80 00       	push   $0x803e3b
  8028f5:	e8 61 d9 ff ff       	call   80025b <_panic>
  8028fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 10                	je     802913 <alloc_block_NF+0x326>
  802903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290b:	8b 52 04             	mov    0x4(%edx),%edx
  80290e:	89 50 04             	mov    %edx,0x4(%eax)
  802911:	eb 0b                	jmp    80291e <alloc_block_NF+0x331>
  802913:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80291e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 0f                	je     802937 <alloc_block_NF+0x34a>
  802928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802931:	8b 12                	mov    (%edx),%edx
  802933:	89 10                	mov    %edx,(%eax)
  802935:	eb 0a                	jmp    802941 <alloc_block_NF+0x354>
  802937:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	a3 48 41 80 00       	mov    %eax,0x804148
  802941:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802954:	a1 54 41 80 00       	mov    0x804154,%eax
  802959:	48                   	dec    %eax
  80295a:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80295f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802962:	8b 40 08             	mov    0x8(%eax),%eax
  802965:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 50 08             	mov    0x8(%eax),%edx
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	01 c2                	add    %eax,%edx
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 40 0c             	mov    0xc(%eax),%eax
  802981:	2b 45 08             	sub    0x8(%ebp),%eax
  802984:	89 c2                	mov    %eax,%edx
  802986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802989:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80298c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298f:	e9 24 02 00 00       	jmp    802bb8 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802994:	a1 40 41 80 00       	mov    0x804140,%eax
  802999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a0:	74 07                	je     8029a9 <alloc_block_NF+0x3bc>
  8029a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	eb 05                	jmp    8029ae <alloc_block_NF+0x3c1>
  8029a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ae:	a3 40 41 80 00       	mov    %eax,0x804140
  8029b3:	a1 40 41 80 00       	mov    0x804140,%eax
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	0f 85 2b fe ff ff    	jne    8027eb <alloc_block_NF+0x1fe>
  8029c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c4:	0f 85 21 fe ff ff    	jne    8027eb <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8029cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d2:	e9 ae 01 00 00       	jmp    802b85 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 50 08             	mov    0x8(%eax),%edx
  8029dd:	a1 28 40 80 00       	mov    0x804028,%eax
  8029e2:	39 c2                	cmp    %eax,%edx
  8029e4:	0f 83 93 01 00 00    	jae    802b7d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f3:	0f 82 84 01 00 00    	jb     802b7d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a02:	0f 85 95 00 00 00    	jne    802a9d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0c:	75 17                	jne    802a25 <alloc_block_NF+0x438>
  802a0e:	83 ec 04             	sub    $0x4,%esp
  802a11:	68 e4 3e 80 00       	push   $0x803ee4
  802a16:	68 14 01 00 00       	push   $0x114
  802a1b:	68 3b 3e 80 00       	push   $0x803e3b
  802a20:	e8 36 d8 ff ff       	call   80025b <_panic>
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	74 10                	je     802a3e <alloc_block_NF+0x451>
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 00                	mov    (%eax),%eax
  802a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a36:	8b 52 04             	mov    0x4(%edx),%edx
  802a39:	89 50 04             	mov    %edx,0x4(%eax)
  802a3c:	eb 0b                	jmp    802a49 <alloc_block_NF+0x45c>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 40 04             	mov    0x4(%eax),%eax
  802a44:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	8b 40 04             	mov    0x4(%eax),%eax
  802a4f:	85 c0                	test   %eax,%eax
  802a51:	74 0f                	je     802a62 <alloc_block_NF+0x475>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 40 04             	mov    0x4(%eax),%eax
  802a59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5c:	8b 12                	mov    (%edx),%edx
  802a5e:	89 10                	mov    %edx,(%eax)
  802a60:	eb 0a                	jmp    802a6c <alloc_block_NF+0x47f>
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	a3 38 41 80 00       	mov    %eax,0x804138
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7f:	a1 44 41 80 00       	mov    0x804144,%eax
  802a84:	48                   	dec    %eax
  802a85:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 40 08             	mov    0x8(%eax),%eax
  802a90:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	e9 1b 01 00 00       	jmp    802bb8 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa6:	0f 86 d1 00 00 00    	jbe    802b7d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aac:	a1 48 41 80 00       	mov    0x804148,%eax
  802ab1:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	8b 50 08             	mov    0x8(%eax),%edx
  802aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abd:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ac0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac6:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802ac9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802acd:	75 17                	jne    802ae6 <alloc_block_NF+0x4f9>
  802acf:	83 ec 04             	sub    $0x4,%esp
  802ad2:	68 e4 3e 80 00       	push   $0x803ee4
  802ad7:	68 1c 01 00 00       	push   $0x11c
  802adc:	68 3b 3e 80 00       	push   $0x803e3b
  802ae1:	e8 75 d7 ff ff       	call   80025b <_panic>
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 10                	je     802aff <alloc_block_NF+0x512>
  802aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af7:	8b 52 04             	mov    0x4(%edx),%edx
  802afa:	89 50 04             	mov    %edx,0x4(%eax)
  802afd:	eb 0b                	jmp    802b0a <alloc_block_NF+0x51d>
  802aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b02:	8b 40 04             	mov    0x4(%eax),%eax
  802b05:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0d:	8b 40 04             	mov    0x4(%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 0f                	je     802b23 <alloc_block_NF+0x536>
  802b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b17:	8b 40 04             	mov    0x4(%eax),%eax
  802b1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1d:	8b 12                	mov    (%edx),%edx
  802b1f:	89 10                	mov    %edx,(%eax)
  802b21:	eb 0a                	jmp    802b2d <alloc_block_NF+0x540>
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	8b 00                	mov    (%eax),%eax
  802b28:	a3 48 41 80 00       	mov    %eax,0x804148
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b40:	a1 54 41 80 00       	mov    0x804154,%eax
  802b45:	48                   	dec    %eax
  802b46:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4e:	8b 40 08             	mov    0x8(%eax),%eax
  802b51:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 50 08             	mov    0x8(%eax),%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	01 c2                	add    %eax,%edx
  802b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b64:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b70:	89 c2                	mov    %eax,%edx
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7b:	eb 3b                	jmp    802bb8 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b7d:	a1 40 41 80 00       	mov    0x804140,%eax
  802b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b89:	74 07                	je     802b92 <alloc_block_NF+0x5a5>
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	eb 05                	jmp    802b97 <alloc_block_NF+0x5aa>
  802b92:	b8 00 00 00 00       	mov    $0x0,%eax
  802b97:	a3 40 41 80 00       	mov    %eax,0x804140
  802b9c:	a1 40 41 80 00       	mov    0x804140,%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	0f 85 2e fe ff ff    	jne    8029d7 <alloc_block_NF+0x3ea>
  802ba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bad:	0f 85 24 fe ff ff    	jne    8029d7 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb8:	c9                   	leave  
  802bb9:	c3                   	ret    

00802bba <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
  802bbd:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bc0:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bc8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bd0:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	74 14                	je     802bed <insert_sorted_with_merge_freeList+0x33>
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	8b 50 08             	mov    0x8(%eax),%edx
  802bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be2:	8b 40 08             	mov    0x8(%eax),%eax
  802be5:	39 c2                	cmp    %eax,%edx
  802be7:	0f 87 9b 01 00 00    	ja     802d88 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf1:	75 17                	jne    802c0a <insert_sorted_with_merge_freeList+0x50>
  802bf3:	83 ec 04             	sub    $0x4,%esp
  802bf6:	68 18 3e 80 00       	push   $0x803e18
  802bfb:	68 38 01 00 00       	push   $0x138
  802c00:	68 3b 3e 80 00       	push   $0x803e3b
  802c05:	e8 51 d6 ff ff       	call   80025b <_panic>
  802c0a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	89 10                	mov    %edx,(%eax)
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	8b 00                	mov    (%eax),%eax
  802c1a:	85 c0                	test   %eax,%eax
  802c1c:	74 0d                	je     802c2b <insert_sorted_with_merge_freeList+0x71>
  802c1e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c23:	8b 55 08             	mov    0x8(%ebp),%edx
  802c26:	89 50 04             	mov    %edx,0x4(%eax)
  802c29:	eb 08                	jmp    802c33 <insert_sorted_with_merge_freeList+0x79>
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c45:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4a:	40                   	inc    %eax
  802c4b:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c54:	0f 84 a8 06 00 00    	je     803302 <insert_sorted_with_merge_freeList+0x748>
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	8b 50 08             	mov    0x8(%eax),%edx
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	8b 40 0c             	mov    0xc(%eax),%eax
  802c66:	01 c2                	add    %eax,%edx
  802c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6b:	8b 40 08             	mov    0x8(%eax),%eax
  802c6e:	39 c2                	cmp    %eax,%edx
  802c70:	0f 85 8c 06 00 00    	jne    803302 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c82:	01 c2                	add    %eax,%edx
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c8e:	75 17                	jne    802ca7 <insert_sorted_with_merge_freeList+0xed>
  802c90:	83 ec 04             	sub    $0x4,%esp
  802c93:	68 e4 3e 80 00       	push   $0x803ee4
  802c98:	68 3c 01 00 00       	push   $0x13c
  802c9d:	68 3b 3e 80 00       	push   $0x803e3b
  802ca2:	e8 b4 d5 ff ff       	call   80025b <_panic>
  802ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 10                	je     802cc0 <insert_sorted_with_merge_freeList+0x106>
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	8b 00                	mov    (%eax),%eax
  802cb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb8:	8b 52 04             	mov    0x4(%edx),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	eb 0b                	jmp    802ccb <insert_sorted_with_merge_freeList+0x111>
  802cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc3:	8b 40 04             	mov    0x4(%eax),%eax
  802cc6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cce:	8b 40 04             	mov    0x4(%eax),%eax
  802cd1:	85 c0                	test   %eax,%eax
  802cd3:	74 0f                	je     802ce4 <insert_sorted_with_merge_freeList+0x12a>
  802cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cde:	8b 12                	mov    (%edx),%edx
  802ce0:	89 10                	mov    %edx,(%eax)
  802ce2:	eb 0a                	jmp    802cee <insert_sorted_with_merge_freeList+0x134>
  802ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	a3 38 41 80 00       	mov    %eax,0x804138
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d01:	a1 44 41 80 00       	mov    0x804144,%eax
  802d06:	48                   	dec    %eax
  802d07:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d24:	75 17                	jne    802d3d <insert_sorted_with_merge_freeList+0x183>
  802d26:	83 ec 04             	sub    $0x4,%esp
  802d29:	68 18 3e 80 00       	push   $0x803e18
  802d2e:	68 3f 01 00 00       	push   $0x13f
  802d33:	68 3b 3e 80 00       	push   $0x803e3b
  802d38:	e8 1e d5 ff ff       	call   80025b <_panic>
  802d3d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	89 10                	mov    %edx,(%eax)
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	74 0d                	je     802d5e <insert_sorted_with_merge_freeList+0x1a4>
  802d51:	a1 48 41 80 00       	mov    0x804148,%eax
  802d56:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d59:	89 50 04             	mov    %edx,0x4(%eax)
  802d5c:	eb 08                	jmp    802d66 <insert_sorted_with_merge_freeList+0x1ac>
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	a3 48 41 80 00       	mov    %eax,0x804148
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d78:	a1 54 41 80 00       	mov    0x804154,%eax
  802d7d:	40                   	inc    %eax
  802d7e:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d83:	e9 7a 05 00 00       	jmp    803302 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 50 08             	mov    0x8(%eax),%edx
  802d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d91:	8b 40 08             	mov    0x8(%eax),%eax
  802d94:	39 c2                	cmp    %eax,%edx
  802d96:	0f 82 14 01 00 00    	jb     802eb0 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9f:	8b 50 08             	mov    0x8(%eax),%edx
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	8b 40 0c             	mov    0xc(%eax),%eax
  802da8:	01 c2                	add    %eax,%edx
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	8b 40 08             	mov    0x8(%eax),%eax
  802db0:	39 c2                	cmp    %eax,%edx
  802db2:	0f 85 90 00 00 00    	jne    802e48 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc4:	01 c2                	add    %eax,%edx
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802de0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de4:	75 17                	jne    802dfd <insert_sorted_with_merge_freeList+0x243>
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	68 18 3e 80 00       	push   $0x803e18
  802dee:	68 49 01 00 00       	push   $0x149
  802df3:	68 3b 3e 80 00       	push   $0x803e3b
  802df8:	e8 5e d4 ff ff       	call   80025b <_panic>
  802dfd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	89 10                	mov    %edx,(%eax)
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	85 c0                	test   %eax,%eax
  802e0f:	74 0d                	je     802e1e <insert_sorted_with_merge_freeList+0x264>
  802e11:	a1 48 41 80 00       	mov    0x804148,%eax
  802e16:	8b 55 08             	mov    0x8(%ebp),%edx
  802e19:	89 50 04             	mov    %edx,0x4(%eax)
  802e1c:	eb 08                	jmp    802e26 <insert_sorted_with_merge_freeList+0x26c>
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	a3 48 41 80 00       	mov    %eax,0x804148
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e38:	a1 54 41 80 00       	mov    0x804154,%eax
  802e3d:	40                   	inc    %eax
  802e3e:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e43:	e9 bb 04 00 00       	jmp    803303 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4c:	75 17                	jne    802e65 <insert_sorted_with_merge_freeList+0x2ab>
  802e4e:	83 ec 04             	sub    $0x4,%esp
  802e51:	68 8c 3e 80 00       	push   $0x803e8c
  802e56:	68 4c 01 00 00       	push   $0x14c
  802e5b:	68 3b 3e 80 00       	push   $0x803e3b
  802e60:	e8 f6 d3 ff ff       	call   80025b <_panic>
  802e65:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	89 50 04             	mov    %edx,0x4(%eax)
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	74 0c                	je     802e87 <insert_sorted_with_merge_freeList+0x2cd>
  802e7b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e80:	8b 55 08             	mov    0x8(%ebp),%edx
  802e83:	89 10                	mov    %edx,(%eax)
  802e85:	eb 08                	jmp    802e8f <insert_sorted_with_merge_freeList+0x2d5>
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	a3 38 41 80 00       	mov    %eax,0x804138
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ea5:	40                   	inc    %eax
  802ea6:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802eab:	e9 53 04 00 00       	jmp    803303 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802eb0:	a1 38 41 80 00       	mov    0x804138,%eax
  802eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb8:	e9 15 04 00 00       	jmp    8032d2 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	8b 50 08             	mov    0x8(%eax),%edx
  802ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ece:	8b 40 08             	mov    0x8(%eax),%eax
  802ed1:	39 c2                	cmp    %eax,%edx
  802ed3:	0f 86 f1 03 00 00    	jbe    8032ca <insert_sorted_with_merge_freeList+0x710>
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	8b 50 08             	mov    0x8(%eax),%edx
  802edf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee2:	8b 40 08             	mov    0x8(%eax),%eax
  802ee5:	39 c2                	cmp    %eax,%edx
  802ee7:	0f 83 dd 03 00 00    	jae    8032ca <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 50 08             	mov    0x8(%eax),%edx
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef9:	01 c2                	add    %eax,%edx
  802efb:	8b 45 08             	mov    0x8(%ebp),%eax
  802efe:	8b 40 08             	mov    0x8(%eax),%eax
  802f01:	39 c2                	cmp    %eax,%edx
  802f03:	0f 85 b9 01 00 00    	jne    8030c2 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8b 50 08             	mov    0x8(%eax),%edx
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 40 0c             	mov    0xc(%eax),%eax
  802f15:	01 c2                	add    %eax,%edx
  802f17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1a:	8b 40 08             	mov    0x8(%eax),%eax
  802f1d:	39 c2                	cmp    %eax,%edx
  802f1f:	0f 85 0d 01 00 00    	jne    803032 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f28:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f31:	01 c2                	add    %eax,%edx
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f39:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f3d:	75 17                	jne    802f56 <insert_sorted_with_merge_freeList+0x39c>
  802f3f:	83 ec 04             	sub    $0x4,%esp
  802f42:	68 e4 3e 80 00       	push   $0x803ee4
  802f47:	68 5c 01 00 00       	push   $0x15c
  802f4c:	68 3b 3e 80 00       	push   $0x803e3b
  802f51:	e8 05 d3 ff ff       	call   80025b <_panic>
  802f56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	74 10                	je     802f6f <insert_sorted_with_merge_freeList+0x3b5>
  802f5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f62:	8b 00                	mov    (%eax),%eax
  802f64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f67:	8b 52 04             	mov    0x4(%edx),%edx
  802f6a:	89 50 04             	mov    %edx,0x4(%eax)
  802f6d:	eb 0b                	jmp    802f7a <insert_sorted_with_merge_freeList+0x3c0>
  802f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f72:	8b 40 04             	mov    0x4(%eax),%eax
  802f75:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7d:	8b 40 04             	mov    0x4(%eax),%eax
  802f80:	85 c0                	test   %eax,%eax
  802f82:	74 0f                	je     802f93 <insert_sorted_with_merge_freeList+0x3d9>
  802f84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f87:	8b 40 04             	mov    0x4(%eax),%eax
  802f8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8d:	8b 12                	mov    (%edx),%edx
  802f8f:	89 10                	mov    %edx,(%eax)
  802f91:	eb 0a                	jmp    802f9d <insert_sorted_with_merge_freeList+0x3e3>
  802f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	a3 38 41 80 00       	mov    %eax,0x804138
  802f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb0:	a1 44 41 80 00       	mov    0x804144,%eax
  802fb5:	48                   	dec    %eax
  802fb6:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fcf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd3:	75 17                	jne    802fec <insert_sorted_with_merge_freeList+0x432>
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	68 18 3e 80 00       	push   $0x803e18
  802fdd:	68 5f 01 00 00       	push   $0x15f
  802fe2:	68 3b 3e 80 00       	push   $0x803e3b
  802fe7:	e8 6f d2 ff ff       	call   80025b <_panic>
  802fec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff5:	89 10                	mov    %edx,(%eax)
  802ff7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	74 0d                	je     80300d <insert_sorted_with_merge_freeList+0x453>
  803000:	a1 48 41 80 00       	mov    0x804148,%eax
  803005:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803008:	89 50 04             	mov    %edx,0x4(%eax)
  80300b:	eb 08                	jmp    803015 <insert_sorted_with_merge_freeList+0x45b>
  80300d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803010:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803018:	a3 48 41 80 00       	mov    %eax,0x804148
  80301d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803027:	a1 54 41 80 00       	mov    0x804154,%eax
  80302c:	40                   	inc    %eax
  80302d:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	8b 50 0c             	mov    0xc(%eax),%edx
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	01 c2                	add    %eax,%edx
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80305a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305e:	75 17                	jne    803077 <insert_sorted_with_merge_freeList+0x4bd>
  803060:	83 ec 04             	sub    $0x4,%esp
  803063:	68 18 3e 80 00       	push   $0x803e18
  803068:	68 64 01 00 00       	push   $0x164
  80306d:	68 3b 3e 80 00       	push   $0x803e3b
  803072:	e8 e4 d1 ff ff       	call   80025b <_panic>
  803077:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	89 10                	mov    %edx,(%eax)
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	85 c0                	test   %eax,%eax
  803089:	74 0d                	je     803098 <insert_sorted_with_merge_freeList+0x4de>
  80308b:	a1 48 41 80 00       	mov    0x804148,%eax
  803090:	8b 55 08             	mov    0x8(%ebp),%edx
  803093:	89 50 04             	mov    %edx,0x4(%eax)
  803096:	eb 08                	jmp    8030a0 <insert_sorted_with_merge_freeList+0x4e6>
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	a3 48 41 80 00       	mov    %eax,0x804148
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b2:	a1 54 41 80 00       	mov    0x804154,%eax
  8030b7:	40                   	inc    %eax
  8030b8:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030bd:	e9 41 02 00 00       	jmp    803303 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	8b 50 08             	mov    0x8(%eax),%edx
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ce:	01 c2                	add    %eax,%edx
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	8b 40 08             	mov    0x8(%eax),%eax
  8030d6:	39 c2                	cmp    %eax,%edx
  8030d8:	0f 85 7c 01 00 00    	jne    80325a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e2:	74 06                	je     8030ea <insert_sorted_with_merge_freeList+0x530>
  8030e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e8:	75 17                	jne    803101 <insert_sorted_with_merge_freeList+0x547>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 54 3e 80 00       	push   $0x803e54
  8030f2:	68 69 01 00 00       	push   $0x169
  8030f7:	68 3b 3e 80 00       	push   $0x803e3b
  8030fc:	e8 5a d1 ff ff       	call   80025b <_panic>
  803101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803104:	8b 50 04             	mov    0x4(%eax),%edx
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803113:	89 10                	mov    %edx,(%eax)
  803115:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803118:	8b 40 04             	mov    0x4(%eax),%eax
  80311b:	85 c0                	test   %eax,%eax
  80311d:	74 0d                	je     80312c <insert_sorted_with_merge_freeList+0x572>
  80311f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803122:	8b 40 04             	mov    0x4(%eax),%eax
  803125:	8b 55 08             	mov    0x8(%ebp),%edx
  803128:	89 10                	mov    %edx,(%eax)
  80312a:	eb 08                	jmp    803134 <insert_sorted_with_merge_freeList+0x57a>
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	a3 38 41 80 00       	mov    %eax,0x804138
  803134:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803137:	8b 55 08             	mov    0x8(%ebp),%edx
  80313a:	89 50 04             	mov    %edx,0x4(%eax)
  80313d:	a1 44 41 80 00       	mov    0x804144,%eax
  803142:	40                   	inc    %eax
  803143:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	8b 50 0c             	mov    0xc(%eax),%edx
  80314e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803151:	8b 40 0c             	mov    0xc(%eax),%eax
  803154:	01 c2                	add    %eax,%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80315c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803160:	75 17                	jne    803179 <insert_sorted_with_merge_freeList+0x5bf>
  803162:	83 ec 04             	sub    $0x4,%esp
  803165:	68 e4 3e 80 00       	push   $0x803ee4
  80316a:	68 6b 01 00 00       	push   $0x16b
  80316f:	68 3b 3e 80 00       	push   $0x803e3b
  803174:	e8 e2 d0 ff ff       	call   80025b <_panic>
  803179:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 10                	je     803192 <insert_sorted_with_merge_freeList+0x5d8>
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318a:	8b 52 04             	mov    0x4(%edx),%edx
  80318d:	89 50 04             	mov    %edx,0x4(%eax)
  803190:	eb 0b                	jmp    80319d <insert_sorted_with_merge_freeList+0x5e3>
  803192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803195:	8b 40 04             	mov    0x4(%eax),%eax
  803198:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 0f                	je     8031b6 <insert_sorted_with_merge_freeList+0x5fc>
  8031a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031aa:	8b 40 04             	mov    0x4(%eax),%eax
  8031ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b0:	8b 12                	mov    (%edx),%edx
  8031b2:	89 10                	mov    %edx,(%eax)
  8031b4:	eb 0a                	jmp    8031c0 <insert_sorted_with_merge_freeList+0x606>
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8031c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d3:	a1 44 41 80 00       	mov    0x804144,%eax
  8031d8:	48                   	dec    %eax
  8031d9:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f6:	75 17                	jne    80320f <insert_sorted_with_merge_freeList+0x655>
  8031f8:	83 ec 04             	sub    $0x4,%esp
  8031fb:	68 18 3e 80 00       	push   $0x803e18
  803200:	68 6e 01 00 00       	push   $0x16e
  803205:	68 3b 3e 80 00       	push   $0x803e3b
  80320a:	e8 4c d0 ff ff       	call   80025b <_panic>
  80320f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803215:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803218:	89 10                	mov    %edx,(%eax)
  80321a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321d:	8b 00                	mov    (%eax),%eax
  80321f:	85 c0                	test   %eax,%eax
  803221:	74 0d                	je     803230 <insert_sorted_with_merge_freeList+0x676>
  803223:	a1 48 41 80 00       	mov    0x804148,%eax
  803228:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322b:	89 50 04             	mov    %edx,0x4(%eax)
  80322e:	eb 08                	jmp    803238 <insert_sorted_with_merge_freeList+0x67e>
  803230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803233:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	a3 48 41 80 00       	mov    %eax,0x804148
  803240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803243:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324a:	a1 54 41 80 00       	mov    0x804154,%eax
  80324f:	40                   	inc    %eax
  803250:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803255:	e9 a9 00 00 00       	jmp    803303 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80325a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325e:	74 06                	je     803266 <insert_sorted_with_merge_freeList+0x6ac>
  803260:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803264:	75 17                	jne    80327d <insert_sorted_with_merge_freeList+0x6c3>
  803266:	83 ec 04             	sub    $0x4,%esp
  803269:	68 b0 3e 80 00       	push   $0x803eb0
  80326e:	68 73 01 00 00       	push   $0x173
  803273:	68 3b 3e 80 00       	push   $0x803e3b
  803278:	e8 de cf ff ff       	call   80025b <_panic>
  80327d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803280:	8b 10                	mov    (%eax),%edx
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	89 10                	mov    %edx,(%eax)
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 0b                	je     80329b <insert_sorted_with_merge_freeList+0x6e1>
  803290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803293:	8b 00                	mov    (%eax),%eax
  803295:	8b 55 08             	mov    0x8(%ebp),%edx
  803298:	89 50 04             	mov    %edx,0x4(%eax)
  80329b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329e:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a1:	89 10                	mov    %edx,(%eax)
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032a9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	85 c0                	test   %eax,%eax
  8032b3:	75 08                	jne    8032bd <insert_sorted_with_merge_freeList+0x703>
  8032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032bd:	a1 44 41 80 00       	mov    0x804144,%eax
  8032c2:	40                   	inc    %eax
  8032c3:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032c8:	eb 39                	jmp    803303 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032ca:	a1 40 41 80 00       	mov    0x804140,%eax
  8032cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d6:	74 07                	je     8032df <insert_sorted_with_merge_freeList+0x725>
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	eb 05                	jmp    8032e4 <insert_sorted_with_merge_freeList+0x72a>
  8032df:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e4:	a3 40 41 80 00       	mov    %eax,0x804140
  8032e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	0f 85 c7 fb ff ff    	jne    802ebd <insert_sorted_with_merge_freeList+0x303>
  8032f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fa:	0f 85 bd fb ff ff    	jne    802ebd <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803300:	eb 01                	jmp    803303 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803302:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803303:	90                   	nop
  803304:	c9                   	leave  
  803305:	c3                   	ret    
  803306:	66 90                	xchg   %ax,%ax

00803308 <__udivdi3>:
  803308:	55                   	push   %ebp
  803309:	57                   	push   %edi
  80330a:	56                   	push   %esi
  80330b:	53                   	push   %ebx
  80330c:	83 ec 1c             	sub    $0x1c,%esp
  80330f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803313:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803317:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80331b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80331f:	89 ca                	mov    %ecx,%edx
  803321:	89 f8                	mov    %edi,%eax
  803323:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803327:	85 f6                	test   %esi,%esi
  803329:	75 2d                	jne    803358 <__udivdi3+0x50>
  80332b:	39 cf                	cmp    %ecx,%edi
  80332d:	77 65                	ja     803394 <__udivdi3+0x8c>
  80332f:	89 fd                	mov    %edi,%ebp
  803331:	85 ff                	test   %edi,%edi
  803333:	75 0b                	jne    803340 <__udivdi3+0x38>
  803335:	b8 01 00 00 00       	mov    $0x1,%eax
  80333a:	31 d2                	xor    %edx,%edx
  80333c:	f7 f7                	div    %edi
  80333e:	89 c5                	mov    %eax,%ebp
  803340:	31 d2                	xor    %edx,%edx
  803342:	89 c8                	mov    %ecx,%eax
  803344:	f7 f5                	div    %ebp
  803346:	89 c1                	mov    %eax,%ecx
  803348:	89 d8                	mov    %ebx,%eax
  80334a:	f7 f5                	div    %ebp
  80334c:	89 cf                	mov    %ecx,%edi
  80334e:	89 fa                	mov    %edi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	39 ce                	cmp    %ecx,%esi
  80335a:	77 28                	ja     803384 <__udivdi3+0x7c>
  80335c:	0f bd fe             	bsr    %esi,%edi
  80335f:	83 f7 1f             	xor    $0x1f,%edi
  803362:	75 40                	jne    8033a4 <__udivdi3+0x9c>
  803364:	39 ce                	cmp    %ecx,%esi
  803366:	72 0a                	jb     803372 <__udivdi3+0x6a>
  803368:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80336c:	0f 87 9e 00 00 00    	ja     803410 <__udivdi3+0x108>
  803372:	b8 01 00 00 00       	mov    $0x1,%eax
  803377:	89 fa                	mov    %edi,%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	31 ff                	xor    %edi,%edi
  803386:	31 c0                	xor    %eax,%eax
  803388:	89 fa                	mov    %edi,%edx
  80338a:	83 c4 1c             	add    $0x1c,%esp
  80338d:	5b                   	pop    %ebx
  80338e:	5e                   	pop    %esi
  80338f:	5f                   	pop    %edi
  803390:	5d                   	pop    %ebp
  803391:	c3                   	ret    
  803392:	66 90                	xchg   %ax,%ax
  803394:	89 d8                	mov    %ebx,%eax
  803396:	f7 f7                	div    %edi
  803398:	31 ff                	xor    %edi,%edi
  80339a:	89 fa                	mov    %edi,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033a9:	89 eb                	mov    %ebp,%ebx
  8033ab:	29 fb                	sub    %edi,%ebx
  8033ad:	89 f9                	mov    %edi,%ecx
  8033af:	d3 e6                	shl    %cl,%esi
  8033b1:	89 c5                	mov    %eax,%ebp
  8033b3:	88 d9                	mov    %bl,%cl
  8033b5:	d3 ed                	shr    %cl,%ebp
  8033b7:	89 e9                	mov    %ebp,%ecx
  8033b9:	09 f1                	or     %esi,%ecx
  8033bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033bf:	89 f9                	mov    %edi,%ecx
  8033c1:	d3 e0                	shl    %cl,%eax
  8033c3:	89 c5                	mov    %eax,%ebp
  8033c5:	89 d6                	mov    %edx,%esi
  8033c7:	88 d9                	mov    %bl,%cl
  8033c9:	d3 ee                	shr    %cl,%esi
  8033cb:	89 f9                	mov    %edi,%ecx
  8033cd:	d3 e2                	shl    %cl,%edx
  8033cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d3:	88 d9                	mov    %bl,%cl
  8033d5:	d3 e8                	shr    %cl,%eax
  8033d7:	09 c2                	or     %eax,%edx
  8033d9:	89 d0                	mov    %edx,%eax
  8033db:	89 f2                	mov    %esi,%edx
  8033dd:	f7 74 24 0c          	divl   0xc(%esp)
  8033e1:	89 d6                	mov    %edx,%esi
  8033e3:	89 c3                	mov    %eax,%ebx
  8033e5:	f7 e5                	mul    %ebp
  8033e7:	39 d6                	cmp    %edx,%esi
  8033e9:	72 19                	jb     803404 <__udivdi3+0xfc>
  8033eb:	74 0b                	je     8033f8 <__udivdi3+0xf0>
  8033ed:	89 d8                	mov    %ebx,%eax
  8033ef:	31 ff                	xor    %edi,%edi
  8033f1:	e9 58 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  8033f6:	66 90                	xchg   %ax,%ax
  8033f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033fc:	89 f9                	mov    %edi,%ecx
  8033fe:	d3 e2                	shl    %cl,%edx
  803400:	39 c2                	cmp    %eax,%edx
  803402:	73 e9                	jae    8033ed <__udivdi3+0xe5>
  803404:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803407:	31 ff                	xor    %edi,%edi
  803409:	e9 40 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  80340e:	66 90                	xchg   %ax,%ax
  803410:	31 c0                	xor    %eax,%eax
  803412:	e9 37 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  803417:	90                   	nop

00803418 <__umoddi3>:
  803418:	55                   	push   %ebp
  803419:	57                   	push   %edi
  80341a:	56                   	push   %esi
  80341b:	53                   	push   %ebx
  80341c:	83 ec 1c             	sub    $0x1c,%esp
  80341f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803423:	8b 74 24 34          	mov    0x34(%esp),%esi
  803427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80342f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803433:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803437:	89 f3                	mov    %esi,%ebx
  803439:	89 fa                	mov    %edi,%edx
  80343b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80343f:	89 34 24             	mov    %esi,(%esp)
  803442:	85 c0                	test   %eax,%eax
  803444:	75 1a                	jne    803460 <__umoddi3+0x48>
  803446:	39 f7                	cmp    %esi,%edi
  803448:	0f 86 a2 00 00 00    	jbe    8034f0 <__umoddi3+0xd8>
  80344e:	89 c8                	mov    %ecx,%eax
  803450:	89 f2                	mov    %esi,%edx
  803452:	f7 f7                	div    %edi
  803454:	89 d0                	mov    %edx,%eax
  803456:	31 d2                	xor    %edx,%edx
  803458:	83 c4 1c             	add    $0x1c,%esp
  80345b:	5b                   	pop    %ebx
  80345c:	5e                   	pop    %esi
  80345d:	5f                   	pop    %edi
  80345e:	5d                   	pop    %ebp
  80345f:	c3                   	ret    
  803460:	39 f0                	cmp    %esi,%eax
  803462:	0f 87 ac 00 00 00    	ja     803514 <__umoddi3+0xfc>
  803468:	0f bd e8             	bsr    %eax,%ebp
  80346b:	83 f5 1f             	xor    $0x1f,%ebp
  80346e:	0f 84 ac 00 00 00    	je     803520 <__umoddi3+0x108>
  803474:	bf 20 00 00 00       	mov    $0x20,%edi
  803479:	29 ef                	sub    %ebp,%edi
  80347b:	89 fe                	mov    %edi,%esi
  80347d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803481:	89 e9                	mov    %ebp,%ecx
  803483:	d3 e0                	shl    %cl,%eax
  803485:	89 d7                	mov    %edx,%edi
  803487:	89 f1                	mov    %esi,%ecx
  803489:	d3 ef                	shr    %cl,%edi
  80348b:	09 c7                	or     %eax,%edi
  80348d:	89 e9                	mov    %ebp,%ecx
  80348f:	d3 e2                	shl    %cl,%edx
  803491:	89 14 24             	mov    %edx,(%esp)
  803494:	89 d8                	mov    %ebx,%eax
  803496:	d3 e0                	shl    %cl,%eax
  803498:	89 c2                	mov    %eax,%edx
  80349a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80349e:	d3 e0                	shl    %cl,%eax
  8034a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a8:	89 f1                	mov    %esi,%ecx
  8034aa:	d3 e8                	shr    %cl,%eax
  8034ac:	09 d0                	or     %edx,%eax
  8034ae:	d3 eb                	shr    %cl,%ebx
  8034b0:	89 da                	mov    %ebx,%edx
  8034b2:	f7 f7                	div    %edi
  8034b4:	89 d3                	mov    %edx,%ebx
  8034b6:	f7 24 24             	mull   (%esp)
  8034b9:	89 c6                	mov    %eax,%esi
  8034bb:	89 d1                	mov    %edx,%ecx
  8034bd:	39 d3                	cmp    %edx,%ebx
  8034bf:	0f 82 87 00 00 00    	jb     80354c <__umoddi3+0x134>
  8034c5:	0f 84 91 00 00 00    	je     80355c <__umoddi3+0x144>
  8034cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034cf:	29 f2                	sub    %esi,%edx
  8034d1:	19 cb                	sbb    %ecx,%ebx
  8034d3:	89 d8                	mov    %ebx,%eax
  8034d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034d9:	d3 e0                	shl    %cl,%eax
  8034db:	89 e9                	mov    %ebp,%ecx
  8034dd:	d3 ea                	shr    %cl,%edx
  8034df:	09 d0                	or     %edx,%eax
  8034e1:	89 e9                	mov    %ebp,%ecx
  8034e3:	d3 eb                	shr    %cl,%ebx
  8034e5:	89 da                	mov    %ebx,%edx
  8034e7:	83 c4 1c             	add    $0x1c,%esp
  8034ea:	5b                   	pop    %ebx
  8034eb:	5e                   	pop    %esi
  8034ec:	5f                   	pop    %edi
  8034ed:	5d                   	pop    %ebp
  8034ee:	c3                   	ret    
  8034ef:	90                   	nop
  8034f0:	89 fd                	mov    %edi,%ebp
  8034f2:	85 ff                	test   %edi,%edi
  8034f4:	75 0b                	jne    803501 <__umoddi3+0xe9>
  8034f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fb:	31 d2                	xor    %edx,%edx
  8034fd:	f7 f7                	div    %edi
  8034ff:	89 c5                	mov    %eax,%ebp
  803501:	89 f0                	mov    %esi,%eax
  803503:	31 d2                	xor    %edx,%edx
  803505:	f7 f5                	div    %ebp
  803507:	89 c8                	mov    %ecx,%eax
  803509:	f7 f5                	div    %ebp
  80350b:	89 d0                	mov    %edx,%eax
  80350d:	e9 44 ff ff ff       	jmp    803456 <__umoddi3+0x3e>
  803512:	66 90                	xchg   %ax,%ax
  803514:	89 c8                	mov    %ecx,%eax
  803516:	89 f2                	mov    %esi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	3b 04 24             	cmp    (%esp),%eax
  803523:	72 06                	jb     80352b <__umoddi3+0x113>
  803525:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803529:	77 0f                	ja     80353a <__umoddi3+0x122>
  80352b:	89 f2                	mov    %esi,%edx
  80352d:	29 f9                	sub    %edi,%ecx
  80352f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803533:	89 14 24             	mov    %edx,(%esp)
  803536:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80353e:	8b 14 24             	mov    (%esp),%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	2b 04 24             	sub    (%esp),%eax
  80354f:	19 fa                	sbb    %edi,%edx
  803551:	89 d1                	mov    %edx,%ecx
  803553:	89 c6                	mov    %eax,%esi
  803555:	e9 71 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803560:	72 ea                	jb     80354c <__umoddi3+0x134>
  803562:	89 d9                	mov    %ebx,%ecx
  803564:	e9 62 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
