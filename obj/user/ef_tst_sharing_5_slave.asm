
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
  80008c:	68 e0 34 80 00       	push   $0x8034e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 34 80 00       	push   $0x8034fc
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 0e 19 00 00       	call   8019b0 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 1a 35 80 00       	push   $0x80351a
  8000aa:	50                   	push   %eax
  8000ab:	e8 63 14 00 00       	call   801513 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 fc 15 00 00       	call   8016b7 <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 1c 35 80 00       	push   $0x80351c
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 7e 14 00 00       	call   801557 <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 40 35 80 00       	push   $0x803540
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 c6 15 00 00       	call   8016b7 <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 58 35 80 00       	push   $0x803558
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 fc 34 80 00       	push   $0x8034fc
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 b9 19 00 00       	call   801ad5 <inctst>

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
  800125:	e8 6d 18 00 00       	call   801997 <sys_getenvindex>
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
  800190:	e8 0f 16 00 00       	call   8017a4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 fc 35 80 00       	push   $0x8035fc
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
  8001c0:	68 24 36 80 00       	push   $0x803624
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
  8001f1:	68 4c 36 80 00       	push   $0x80364c
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 a4 36 80 00       	push   $0x8036a4
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 fc 35 80 00       	push   $0x8035fc
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 8f 15 00 00       	call   8017be <sys_enable_interrupt>

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
  800242:	e8 1c 17 00 00       	call   801963 <sys_destroy_env>
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
  800253:	e8 71 17 00 00       	call   8019c9 <sys_exit_env>
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
  80027c:	68 b8 36 80 00       	push   $0x8036b8
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 bd 36 80 00       	push   $0x8036bd
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
  8002b9:	68 d9 36 80 00       	push   $0x8036d9
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
  8002e5:	68 dc 36 80 00       	push   $0x8036dc
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 28 37 80 00       	push   $0x803728
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
  8003b7:	68 34 37 80 00       	push   $0x803734
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 28 37 80 00       	push   $0x803728
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
  800427:	68 88 37 80 00       	push   $0x803788
  80042c:	6a 44                	push   $0x44
  80042e:	68 28 37 80 00       	push   $0x803728
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
  800481:	e8 70 11 00 00       	call   8015f6 <sys_cputs>
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
  8004f8:	e8 f9 10 00 00       	call   8015f6 <sys_cputs>
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
  800542:	e8 5d 12 00 00       	call   8017a4 <sys_disable_interrupt>
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
  800562:	e8 57 12 00 00       	call   8017be <sys_enable_interrupt>
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
  8005ac:	e8 cb 2c 00 00       	call   80327c <__udivdi3>
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
  8005fc:	e8 8b 2d 00 00       	call   80338c <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 f4 39 80 00       	add    $0x8039f4,%eax
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
  800757:	8b 04 85 18 3a 80 00 	mov    0x803a18(,%eax,4),%eax
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
  800838:	8b 34 9d 60 38 80 00 	mov    0x803860(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 05 3a 80 00       	push   $0x803a05
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
  80085d:	68 0e 3a 80 00       	push   $0x803a0e
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
  80088a:	be 11 3a 80 00       	mov    $0x803a11,%esi
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
  8012b0:	68 70 3b 80 00       	push   $0x803b70
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801363:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80136a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801372:	2d 00 10 00 00       	sub    $0x1000,%eax
  801377:	83 ec 04             	sub    $0x4,%esp
  80137a:	6a 03                	push   $0x3
  80137c:	ff 75 f4             	pushl  -0xc(%ebp)
  80137f:	50                   	push   %eax
  801380:	e8 b5 03 00 00       	call   80173a <sys_allocate_chunk>
  801385:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801388:	a1 20 41 80 00       	mov    0x804120,%eax
  80138d:	83 ec 0c             	sub    $0xc,%esp
  801390:	50                   	push   %eax
  801391:	e8 2a 0a 00 00       	call   801dc0 <initialize_MemBlocksList>
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
  8013be:	68 95 3b 80 00       	push   $0x803b95
  8013c3:	6a 33                	push   $0x33
  8013c5:	68 b3 3b 80 00       	push   $0x803bb3
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
  80143d:	68 c0 3b 80 00       	push   $0x803bc0
  801442:	6a 34                	push   $0x34
  801444:	68 b3 3b 80 00       	push   $0x803bb3
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
  8014b2:	68 e4 3b 80 00       	push   $0x803be4
  8014b7:	6a 46                	push   $0x46
  8014b9:	68 b3 3b 80 00       	push   $0x803bb3
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
  8014ce:	68 0c 3c 80 00       	push   $0x803c0c
  8014d3:	6a 61                	push   $0x61
  8014d5:	68 b3 3b 80 00       	push   $0x803bb3
  8014da:	e8 7c ed ff ff       	call   80025b <_panic>

008014df <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 18             	sub    $0x18,%esp
  8014e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e8:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014eb:	e8 a9 fd ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f4:	75 07                	jne    8014fd <smalloc+0x1e>
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 14                	jmp    801511 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  8014fd:	83 ec 04             	sub    $0x4,%esp
  801500:	68 30 3c 80 00       	push   $0x803c30
  801505:	6a 76                	push   $0x76
  801507:	68 b3 3b 80 00       	push   $0x803bb3
  80150c:	e8 4a ed ff ff       	call   80025b <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801519:	e8 7b fd ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80151e:	83 ec 04             	sub    $0x4,%esp
  801521:	68 58 3c 80 00       	push   $0x803c58
  801526:	68 93 00 00 00       	push   $0x93
  80152b:	68 b3 3b 80 00       	push   $0x803bb3
  801530:	e8 26 ed ff ff       	call   80025b <_panic>

00801535 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80153b:	e8 59 fd ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801540:	83 ec 04             	sub    $0x4,%esp
  801543:	68 7c 3c 80 00       	push   $0x803c7c
  801548:	68 c5 00 00 00       	push   $0xc5
  80154d:	68 b3 3b 80 00       	push   $0x803bb3
  801552:	e8 04 ed ff ff       	call   80025b <_panic>

00801557 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80155d:	83 ec 04             	sub    $0x4,%esp
  801560:	68 a4 3c 80 00       	push   $0x803ca4
  801565:	68 d9 00 00 00       	push   $0xd9
  80156a:	68 b3 3b 80 00       	push   $0x803bb3
  80156f:	e8 e7 ec ff ff       	call   80025b <_panic>

00801574 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80157a:	83 ec 04             	sub    $0x4,%esp
  80157d:	68 c8 3c 80 00       	push   $0x803cc8
  801582:	68 e4 00 00 00       	push   $0xe4
  801587:	68 b3 3b 80 00       	push   $0x803bb3
  80158c:	e8 ca ec ff ff       	call   80025b <_panic>

00801591 <shrink>:

}
void shrink(uint32 newSize)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801597:	83 ec 04             	sub    $0x4,%esp
  80159a:	68 c8 3c 80 00       	push   $0x803cc8
  80159f:	68 e9 00 00 00       	push   $0xe9
  8015a4:	68 b3 3b 80 00       	push   $0x803bb3
  8015a9:	e8 ad ec ff ff       	call   80025b <_panic>

008015ae <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015b4:	83 ec 04             	sub    $0x4,%esp
  8015b7:	68 c8 3c 80 00       	push   $0x803cc8
  8015bc:	68 ee 00 00 00       	push   $0xee
  8015c1:	68 b3 3b 80 00       	push   $0x803bb3
  8015c6:	e8 90 ec ff ff       	call   80025b <_panic>

008015cb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	57                   	push   %edi
  8015cf:	56                   	push   %esi
  8015d0:	53                   	push   %ebx
  8015d1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015e0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015e3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015e6:	cd 30                	int    $0x30
  8015e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8015eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015ee:	83 c4 10             	add    $0x10,%esp
  8015f1:	5b                   	pop    %ebx
  8015f2:	5e                   	pop    %esi
  8015f3:	5f                   	pop    %edi
  8015f4:	5d                   	pop    %ebp
  8015f5:	c3                   	ret    

008015f6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 04             	sub    $0x4,%esp
  8015fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801602:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801606:	8b 45 08             	mov    0x8(%ebp),%eax
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	52                   	push   %edx
  80160e:	ff 75 0c             	pushl  0xc(%ebp)
  801611:	50                   	push   %eax
  801612:	6a 00                	push   $0x0
  801614:	e8 b2 ff ff ff       	call   8015cb <syscall>
  801619:	83 c4 18             	add    $0x18,%esp
}
  80161c:	90                   	nop
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <sys_cgetc>:

int
sys_cgetc(void)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801622:	6a 00                	push   $0x0
  801624:	6a 00                	push   $0x0
  801626:	6a 00                	push   $0x0
  801628:	6a 00                	push   $0x0
  80162a:	6a 00                	push   $0x0
  80162c:	6a 01                	push   $0x1
  80162e:	e8 98 ff ff ff       	call   8015cb <syscall>
  801633:	83 c4 18             	add    $0x18,%esp
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80163b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	6a 00                	push   $0x0
  801643:	6a 00                	push   $0x0
  801645:	6a 00                	push   $0x0
  801647:	52                   	push   %edx
  801648:	50                   	push   %eax
  801649:	6a 05                	push   $0x5
  80164b:	e8 7b ff ff ff       	call   8015cb <syscall>
  801650:	83 c4 18             	add    $0x18,%esp
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	56                   	push   %esi
  801659:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80165a:	8b 75 18             	mov    0x18(%ebp),%esi
  80165d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801660:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801663:	8b 55 0c             	mov    0xc(%ebp),%edx
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	56                   	push   %esi
  80166a:	53                   	push   %ebx
  80166b:	51                   	push   %ecx
  80166c:	52                   	push   %edx
  80166d:	50                   	push   %eax
  80166e:	6a 06                	push   $0x6
  801670:	e8 56 ff ff ff       	call   8015cb <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80167b:	5b                   	pop    %ebx
  80167c:	5e                   	pop    %esi
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    

0080167f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801682:	8b 55 0c             	mov    0xc(%ebp),%edx
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	52                   	push   %edx
  80168f:	50                   	push   %eax
  801690:	6a 07                	push   $0x7
  801692:	e8 34 ff ff ff       	call   8015cb <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	6a 00                	push   $0x0
  8016a5:	ff 75 0c             	pushl  0xc(%ebp)
  8016a8:	ff 75 08             	pushl  0x8(%ebp)
  8016ab:	6a 08                	push   $0x8
  8016ad:	e8 19 ff ff ff       	call   8015cb <syscall>
  8016b2:	83 c4 18             	add    $0x18,%esp
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 09                	push   $0x9
  8016c6:	e8 00 ff ff ff       	call   8015cb <syscall>
  8016cb:	83 c4 18             	add    $0x18,%esp
}
  8016ce:	c9                   	leave  
  8016cf:	c3                   	ret    

008016d0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 0a                	push   $0xa
  8016df:	e8 e7 fe ff ff       	call   8015cb <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 0b                	push   $0xb
  8016f8:	e8 ce fe ff ff       	call   8015cb <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	6a 0f                	push   $0xf
  801713:	e8 b3 fe ff ff       	call   8015cb <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
	return;
  80171b:	90                   	nop
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	ff 75 0c             	pushl  0xc(%ebp)
  80172a:	ff 75 08             	pushl  0x8(%ebp)
  80172d:	6a 10                	push   $0x10
  80172f:	e8 97 fe ff ff       	call   8015cb <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
	return ;
  801737:	90                   	nop
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	ff 75 10             	pushl  0x10(%ebp)
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	ff 75 08             	pushl  0x8(%ebp)
  80174a:	6a 11                	push   $0x11
  80174c:	e8 7a fe ff ff       	call   8015cb <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
	return ;
  801754:	90                   	nop
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 0c                	push   $0xc
  801766:	e8 60 fe ff ff       	call   8015cb <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	6a 0d                	push   $0xd
  801780:	e8 46 fe ff ff       	call   8015cb <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 0e                	push   $0xe
  801799:	e8 2d fe ff ff       	call   8015cb <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	90                   	nop
  8017a2:	c9                   	leave  
  8017a3:	c3                   	ret    

008017a4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 13                	push   $0x13
  8017b3:	e8 13 fe ff ff       	call   8015cb <syscall>
  8017b8:	83 c4 18             	add    $0x18,%esp
}
  8017bb:	90                   	nop
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 14                	push   $0x14
  8017cd:	e8 f9 fd ff ff       	call   8015cb <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	90                   	nop
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 04             	sub    $0x4,%esp
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	50                   	push   %eax
  8017f1:	6a 15                	push   $0x15
  8017f3:	e8 d3 fd ff ff       	call   8015cb <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
}
  8017fb:	90                   	nop
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 16                	push   $0x16
  80180d:	e8 b9 fd ff ff       	call   8015cb <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	90                   	nop
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	ff 75 0c             	pushl  0xc(%ebp)
  801827:	50                   	push   %eax
  801828:	6a 17                	push   $0x17
  80182a:	e8 9c fd ff ff       	call   8015cb <syscall>
  80182f:	83 c4 18             	add    $0x18,%esp
}
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	52                   	push   %edx
  801844:	50                   	push   %eax
  801845:	6a 1a                	push   $0x1a
  801847:	e8 7f fd ff ff       	call   8015cb <syscall>
  80184c:	83 c4 18             	add    $0x18,%esp
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801854:	8b 55 0c             	mov    0xc(%ebp),%edx
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 18                	push   $0x18
  801864:	e8 62 fd ff ff       	call   8015cb <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	90                   	nop
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801872:	8b 55 0c             	mov    0xc(%ebp),%edx
  801875:	8b 45 08             	mov    0x8(%ebp),%eax
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	52                   	push   %edx
  80187f:	50                   	push   %eax
  801880:	6a 19                	push   $0x19
  801882:	e8 44 fd ff ff       	call   8015cb <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	8b 45 10             	mov    0x10(%ebp),%eax
  801896:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801899:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80189c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	6a 00                	push   $0x0
  8018a5:	51                   	push   %ecx
  8018a6:	52                   	push   %edx
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	50                   	push   %eax
  8018ab:	6a 1b                	push   $0x1b
  8018ad:	e8 19 fd ff ff       	call   8015cb <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	6a 1c                	push   $0x1c
  8018ca:	e8 fc fc ff ff       	call   8015cb <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
}
  8018d2:	c9                   	leave  
  8018d3:	c3                   	ret    

008018d4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	51                   	push   %ecx
  8018e5:	52                   	push   %edx
  8018e6:	50                   	push   %eax
  8018e7:	6a 1d                	push   $0x1d
  8018e9:	e8 dd fc ff ff       	call   8015cb <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8018f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	6a 1e                	push   $0x1e
  801906:	e8 c0 fc ff ff       	call   8015cb <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 1f                	push   $0x1f
  80191f:	e8 a7 fc ff ff       	call   8015cb <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 14             	pushl  0x14(%ebp)
  801934:	ff 75 10             	pushl  0x10(%ebp)
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	50                   	push   %eax
  80193b:	6a 20                	push   $0x20
  80193d:	e8 89 fc ff ff       	call   8015cb <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	50                   	push   %eax
  801956:	6a 21                	push   $0x21
  801958:	e8 6e fc ff ff       	call   8015cb <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	90                   	nop
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	50                   	push   %eax
  801972:	6a 22                	push   $0x22
  801974:	e8 52 fc ff ff       	call   8015cb <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 02                	push   $0x2
  80198d:	e8 39 fc ff ff       	call   8015cb <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 03                	push   $0x3
  8019a6:	e8 20 fc ff ff       	call   8015cb <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 04                	push   $0x4
  8019bf:	e8 07 fc ff ff       	call   8015cb <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_exit_env>:


void sys_exit_env(void)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 23                	push   $0x23
  8019d8:	e8 ee fb ff ff       	call   8015cb <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019ec:	8d 50 04             	lea    0x4(%eax),%edx
  8019ef:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	52                   	push   %edx
  8019f9:	50                   	push   %eax
  8019fa:	6a 24                	push   $0x24
  8019fc:	e8 ca fb ff ff       	call   8015cb <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
	return result;
  801a04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a0d:	89 01                	mov    %eax,(%ecx)
  801a0f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	c9                   	leave  
  801a16:	c2 04 00             	ret    $0x4

00801a19 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	ff 75 10             	pushl  0x10(%ebp)
  801a23:	ff 75 0c             	pushl  0xc(%ebp)
  801a26:	ff 75 08             	pushl  0x8(%ebp)
  801a29:	6a 12                	push   $0x12
  801a2b:	e8 9b fb ff ff       	call   8015cb <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
	return ;
  801a33:	90                   	nop
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <sys_rcr2>:
uint32 sys_rcr2()
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 25                	push   $0x25
  801a45:	e8 81 fb ff ff       	call   8015cb <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 04             	sub    $0x4,%esp
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a5b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	50                   	push   %eax
  801a68:	6a 26                	push   $0x26
  801a6a:	e8 5c fb ff ff       	call   8015cb <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a72:	90                   	nop
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <rsttst>:
void rsttst()
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 28                	push   $0x28
  801a84:	e8 42 fb ff ff       	call   8015cb <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8c:	90                   	nop
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	83 ec 04             	sub    $0x4,%esp
  801a95:	8b 45 14             	mov    0x14(%ebp),%eax
  801a98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a9b:	8b 55 18             	mov    0x18(%ebp),%edx
  801a9e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	ff 75 10             	pushl  0x10(%ebp)
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	ff 75 08             	pushl  0x8(%ebp)
  801aad:	6a 27                	push   $0x27
  801aaf:	e8 17 fb ff ff       	call   8015cb <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab7:	90                   	nop
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <chktst>:
void chktst(uint32 n)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	6a 29                	push   $0x29
  801aca:	e8 fc fa ff ff       	call   8015cb <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad2:	90                   	nop
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <inctst>:

void inctst()
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 2a                	push   $0x2a
  801ae4:	e8 e2 fa ff ff       	call   8015cb <syscall>
  801ae9:	83 c4 18             	add    $0x18,%esp
	return ;
  801aec:	90                   	nop
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <gettst>:
uint32 gettst()
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 2b                	push   $0x2b
  801afe:	e8 c8 fa ff ff       	call   8015cb <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 2c                	push   $0x2c
  801b1a:	e8 ac fa ff ff       	call   8015cb <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
  801b22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b25:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b29:	75 07                	jne    801b32 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b2b:	b8 01 00 00 00       	mov    $0x1,%eax
  801b30:	eb 05                	jmp    801b37 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 2c                	push   $0x2c
  801b4b:	e8 7b fa ff ff       	call   8015cb <syscall>
  801b50:	83 c4 18             	add    $0x18,%esp
  801b53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b56:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b5a:	75 07                	jne    801b63 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b5c:	b8 01 00 00 00       	mov    $0x1,%eax
  801b61:	eb 05                	jmp    801b68 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 2c                	push   $0x2c
  801b7c:	e8 4a fa ff ff       	call   8015cb <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
  801b84:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b87:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b8b:	75 07                	jne    801b94 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b92:	eb 05                	jmp    801b99 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 2c                	push   $0x2c
  801bad:	e8 19 fa ff ff       	call   8015cb <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
  801bb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bb8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bbc:	75 07                	jne    801bc5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bbe:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc3:	eb 05                	jmp    801bca <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	ff 75 08             	pushl  0x8(%ebp)
  801bda:	6a 2d                	push   $0x2d
  801bdc:	e8 ea f9 ff ff       	call   8015cb <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return ;
  801be4:	90                   	nop
}
  801be5:	c9                   	leave  
  801be6:	c3                   	ret    

00801be7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
  801bea:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801beb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	6a 00                	push   $0x0
  801bf9:	53                   	push   %ebx
  801bfa:	51                   	push   %ecx
  801bfb:	52                   	push   %edx
  801bfc:	50                   	push   %eax
  801bfd:	6a 2e                	push   $0x2e
  801bff:	e8 c7 f9 ff ff       	call   8015cb <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	52                   	push   %edx
  801c1c:	50                   	push   %eax
  801c1d:	6a 2f                	push   $0x2f
  801c1f:	e8 a7 f9 ff ff       	call   8015cb <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c2f:	83 ec 0c             	sub    $0xc,%esp
  801c32:	68 d8 3c 80 00       	push   $0x803cd8
  801c37:	e8 d3 e8 ff ff       	call   80050f <cprintf>
  801c3c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c3f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c46:	83 ec 0c             	sub    $0xc,%esp
  801c49:	68 04 3d 80 00       	push   $0x803d04
  801c4e:	e8 bc e8 ff ff       	call   80050f <cprintf>
  801c53:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c56:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c5a:	a1 38 41 80 00       	mov    0x804138,%eax
  801c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c62:	eb 56                	jmp    801cba <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c68:	74 1c                	je     801c86 <print_mem_block_lists+0x5d>
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	8b 50 08             	mov    0x8(%eax),%edx
  801c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c73:	8b 48 08             	mov    0x8(%eax),%ecx
  801c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c79:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7c:	01 c8                	add    %ecx,%eax
  801c7e:	39 c2                	cmp    %eax,%edx
  801c80:	73 04                	jae    801c86 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c82:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c89:	8b 50 08             	mov    0x8(%eax),%edx
  801c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c92:	01 c2                	add    %eax,%edx
  801c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c97:	8b 40 08             	mov    0x8(%eax),%eax
  801c9a:	83 ec 04             	sub    $0x4,%esp
  801c9d:	52                   	push   %edx
  801c9e:	50                   	push   %eax
  801c9f:	68 19 3d 80 00       	push   $0x803d19
  801ca4:	e8 66 e8 ff ff       	call   80050f <cprintf>
  801ca9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cb2:	a1 40 41 80 00       	mov    0x804140,%eax
  801cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cbe:	74 07                	je     801cc7 <print_mem_block_lists+0x9e>
  801cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc3:	8b 00                	mov    (%eax),%eax
  801cc5:	eb 05                	jmp    801ccc <print_mem_block_lists+0xa3>
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccc:	a3 40 41 80 00       	mov    %eax,0x804140
  801cd1:	a1 40 41 80 00       	mov    0x804140,%eax
  801cd6:	85 c0                	test   %eax,%eax
  801cd8:	75 8a                	jne    801c64 <print_mem_block_lists+0x3b>
  801cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cde:	75 84                	jne    801c64 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ce0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ce4:	75 10                	jne    801cf6 <print_mem_block_lists+0xcd>
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	68 28 3d 80 00       	push   $0x803d28
  801cee:	e8 1c e8 ff ff       	call   80050f <cprintf>
  801cf3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801cf6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	68 4c 3d 80 00       	push   $0x803d4c
  801d05:	e8 05 e8 ff ff       	call   80050f <cprintf>
  801d0a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d0d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d11:	a1 40 40 80 00       	mov    0x804040,%eax
  801d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d19:	eb 56                	jmp    801d71 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d1f:	74 1c                	je     801d3d <print_mem_block_lists+0x114>
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	8b 50 08             	mov    0x8(%eax),%edx
  801d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2a:	8b 48 08             	mov    0x8(%eax),%ecx
  801d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d30:	8b 40 0c             	mov    0xc(%eax),%eax
  801d33:	01 c8                	add    %ecx,%eax
  801d35:	39 c2                	cmp    %eax,%edx
  801d37:	73 04                	jae    801d3d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d39:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d40:	8b 50 08             	mov    0x8(%eax),%edx
  801d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d46:	8b 40 0c             	mov    0xc(%eax),%eax
  801d49:	01 c2                	add    %eax,%edx
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	8b 40 08             	mov    0x8(%eax),%eax
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	52                   	push   %edx
  801d55:	50                   	push   %eax
  801d56:	68 19 3d 80 00       	push   $0x803d19
  801d5b:	e8 af e7 ff ff       	call   80050f <cprintf>
  801d60:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d69:	a1 48 40 80 00       	mov    0x804048,%eax
  801d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d75:	74 07                	je     801d7e <print_mem_block_lists+0x155>
  801d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7a:	8b 00                	mov    (%eax),%eax
  801d7c:	eb 05                	jmp    801d83 <print_mem_block_lists+0x15a>
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d83:	a3 48 40 80 00       	mov    %eax,0x804048
  801d88:	a1 48 40 80 00       	mov    0x804048,%eax
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	75 8a                	jne    801d1b <print_mem_block_lists+0xf2>
  801d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d95:	75 84                	jne    801d1b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801d97:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d9b:	75 10                	jne    801dad <print_mem_block_lists+0x184>
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	68 64 3d 80 00       	push   $0x803d64
  801da5:	e8 65 e7 ff ff       	call   80050f <cprintf>
  801daa:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801dad:	83 ec 0c             	sub    $0xc,%esp
  801db0:	68 d8 3c 80 00       	push   $0x803cd8
  801db5:	e8 55 e7 ff ff       	call   80050f <cprintf>
  801dba:	83 c4 10             	add    $0x10,%esp

}
  801dbd:	90                   	nop
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801dc6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801dcd:	00 00 00 
  801dd0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801dd7:	00 00 00 
  801dda:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801de1:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801de4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801deb:	e9 9e 00 00 00       	jmp    801e8e <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801df0:	a1 50 40 80 00       	mov    0x804050,%eax
  801df5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df8:	c1 e2 04             	shl    $0x4,%edx
  801dfb:	01 d0                	add    %edx,%eax
  801dfd:	85 c0                	test   %eax,%eax
  801dff:	75 14                	jne    801e15 <initialize_MemBlocksList+0x55>
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	68 8c 3d 80 00       	push   $0x803d8c
  801e09:	6a 46                	push   $0x46
  801e0b:	68 af 3d 80 00       	push   $0x803daf
  801e10:	e8 46 e4 ff ff       	call   80025b <_panic>
  801e15:	a1 50 40 80 00       	mov    0x804050,%eax
  801e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1d:	c1 e2 04             	shl    $0x4,%edx
  801e20:	01 d0                	add    %edx,%eax
  801e22:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e28:	89 10                	mov    %edx,(%eax)
  801e2a:	8b 00                	mov    (%eax),%eax
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	74 18                	je     801e48 <initialize_MemBlocksList+0x88>
  801e30:	a1 48 41 80 00       	mov    0x804148,%eax
  801e35:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e3b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e3e:	c1 e1 04             	shl    $0x4,%ecx
  801e41:	01 ca                	add    %ecx,%edx
  801e43:	89 50 04             	mov    %edx,0x4(%eax)
  801e46:	eb 12                	jmp    801e5a <initialize_MemBlocksList+0x9a>
  801e48:	a1 50 40 80 00       	mov    0x804050,%eax
  801e4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e50:	c1 e2 04             	shl    $0x4,%edx
  801e53:	01 d0                	add    %edx,%eax
  801e55:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e5a:	a1 50 40 80 00       	mov    0x804050,%eax
  801e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e62:	c1 e2 04             	shl    $0x4,%edx
  801e65:	01 d0                	add    %edx,%eax
  801e67:	a3 48 41 80 00       	mov    %eax,0x804148
  801e6c:	a1 50 40 80 00       	mov    0x804050,%eax
  801e71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e74:	c1 e2 04             	shl    $0x4,%edx
  801e77:	01 d0                	add    %edx,%eax
  801e79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e80:	a1 54 41 80 00       	mov    0x804154,%eax
  801e85:	40                   	inc    %eax
  801e86:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801e8b:	ff 45 f4             	incl   -0xc(%ebp)
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e94:	0f 82 56 ff ff ff    	jb     801df0 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801e9a:	90                   	nop
  801e9b:	c9                   	leave  
  801e9c:	c3                   	ret    

00801e9d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea6:	8b 00                	mov    (%eax),%eax
  801ea8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801eab:	eb 19                	jmp    801ec6 <find_block+0x29>
	{
		if(va==point->sva)
  801ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eb0:	8b 40 08             	mov    0x8(%eax),%eax
  801eb3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801eb6:	75 05                	jne    801ebd <find_block+0x20>
		   return point;
  801eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ebb:	eb 36                	jmp    801ef3 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	8b 40 08             	mov    0x8(%eax),%eax
  801ec3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ec6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eca:	74 07                	je     801ed3 <find_block+0x36>
  801ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ecf:	8b 00                	mov    (%eax),%eax
  801ed1:	eb 05                	jmp    801ed8 <find_block+0x3b>
  801ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  801edb:	89 42 08             	mov    %eax,0x8(%edx)
  801ede:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee1:	8b 40 08             	mov    0x8(%eax),%eax
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	75 c5                	jne    801ead <find_block+0x10>
  801ee8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801eec:	75 bf                	jne    801ead <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801efb:	a1 40 40 80 00       	mov    0x804040,%eax
  801f00:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f03:	a1 44 40 80 00       	mov    0x804044,%eax
  801f08:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f11:	74 24                	je     801f37 <insert_sorted_allocList+0x42>
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	8b 50 08             	mov    0x8(%eax),%edx
  801f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1c:	8b 40 08             	mov    0x8(%eax),%eax
  801f1f:	39 c2                	cmp    %eax,%edx
  801f21:	76 14                	jbe    801f37 <insert_sorted_allocList+0x42>
  801f23:	8b 45 08             	mov    0x8(%ebp),%eax
  801f26:	8b 50 08             	mov    0x8(%eax),%edx
  801f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2c:	8b 40 08             	mov    0x8(%eax),%eax
  801f2f:	39 c2                	cmp    %eax,%edx
  801f31:	0f 82 60 01 00 00    	jb     802097 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f3b:	75 65                	jne    801fa2 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f41:	75 14                	jne    801f57 <insert_sorted_allocList+0x62>
  801f43:	83 ec 04             	sub    $0x4,%esp
  801f46:	68 8c 3d 80 00       	push   $0x803d8c
  801f4b:	6a 6b                	push   $0x6b
  801f4d:	68 af 3d 80 00       	push   $0x803daf
  801f52:	e8 04 e3 ff ff       	call   80025b <_panic>
  801f57:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	89 10                	mov    %edx,(%eax)
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	8b 00                	mov    (%eax),%eax
  801f67:	85 c0                	test   %eax,%eax
  801f69:	74 0d                	je     801f78 <insert_sorted_allocList+0x83>
  801f6b:	a1 40 40 80 00       	mov    0x804040,%eax
  801f70:	8b 55 08             	mov    0x8(%ebp),%edx
  801f73:	89 50 04             	mov    %edx,0x4(%eax)
  801f76:	eb 08                	jmp    801f80 <insert_sorted_allocList+0x8b>
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	a3 44 40 80 00       	mov    %eax,0x804044
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	a3 40 40 80 00       	mov    %eax,0x804040
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f92:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801f97:	40                   	inc    %eax
  801f98:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801f9d:	e9 dc 01 00 00       	jmp    80217e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	8b 50 08             	mov    0x8(%eax),%edx
  801fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fab:	8b 40 08             	mov    0x8(%eax),%eax
  801fae:	39 c2                	cmp    %eax,%edx
  801fb0:	77 6c                	ja     80201e <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801fb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb6:	74 06                	je     801fbe <insert_sorted_allocList+0xc9>
  801fb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fbc:	75 14                	jne    801fd2 <insert_sorted_allocList+0xdd>
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	68 c8 3d 80 00       	push   $0x803dc8
  801fc6:	6a 6f                	push   $0x6f
  801fc8:	68 af 3d 80 00       	push   $0x803daf
  801fcd:	e8 89 e2 ff ff       	call   80025b <_panic>
  801fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd5:	8b 50 04             	mov    0x4(%eax),%edx
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	89 50 04             	mov    %edx,0x4(%eax)
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fe4:	89 10                	mov    %edx,(%eax)
  801fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe9:	8b 40 04             	mov    0x4(%eax),%eax
  801fec:	85 c0                	test   %eax,%eax
  801fee:	74 0d                	je     801ffd <insert_sorted_allocList+0x108>
  801ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff3:	8b 40 04             	mov    0x4(%eax),%eax
  801ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff9:	89 10                	mov    %edx,(%eax)
  801ffb:	eb 08                	jmp    802005 <insert_sorted_allocList+0x110>
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	a3 40 40 80 00       	mov    %eax,0x804040
  802005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802008:	8b 55 08             	mov    0x8(%ebp),%edx
  80200b:	89 50 04             	mov    %edx,0x4(%eax)
  80200e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802013:	40                   	inc    %eax
  802014:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802019:	e9 60 01 00 00       	jmp    80217e <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	8b 50 08             	mov    0x8(%eax),%edx
  802024:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802027:	8b 40 08             	mov    0x8(%eax),%eax
  80202a:	39 c2                	cmp    %eax,%edx
  80202c:	0f 82 4c 01 00 00    	jb     80217e <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802032:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802036:	75 14                	jne    80204c <insert_sorted_allocList+0x157>
  802038:	83 ec 04             	sub    $0x4,%esp
  80203b:	68 00 3e 80 00       	push   $0x803e00
  802040:	6a 73                	push   $0x73
  802042:	68 af 3d 80 00       	push   $0x803daf
  802047:	e8 0f e2 ff ff       	call   80025b <_panic>
  80204c:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	89 50 04             	mov    %edx,0x4(%eax)
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	8b 40 04             	mov    0x4(%eax),%eax
  80205e:	85 c0                	test   %eax,%eax
  802060:	74 0c                	je     80206e <insert_sorted_allocList+0x179>
  802062:	a1 44 40 80 00       	mov    0x804044,%eax
  802067:	8b 55 08             	mov    0x8(%ebp),%edx
  80206a:	89 10                	mov    %edx,(%eax)
  80206c:	eb 08                	jmp    802076 <insert_sorted_allocList+0x181>
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	a3 40 40 80 00       	mov    %eax,0x804040
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	a3 44 40 80 00       	mov    %eax,0x804044
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802087:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80208c:	40                   	inc    %eax
  80208d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802092:	e9 e7 00 00 00       	jmp    80217e <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802097:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80209d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020a4:	a1 40 40 80 00       	mov    0x804040,%eax
  8020a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ac:	e9 9d 00 00 00       	jmp    80214e <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8020b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b4:	8b 00                	mov    (%eax),%eax
  8020b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	8b 50 08             	mov    0x8(%eax),%edx
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	8b 40 08             	mov    0x8(%eax),%eax
  8020c5:	39 c2                	cmp    %eax,%edx
  8020c7:	76 7d                	jbe    802146 <insert_sorted_allocList+0x251>
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	8b 50 08             	mov    0x8(%eax),%edx
  8020cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020d2:	8b 40 08             	mov    0x8(%eax),%eax
  8020d5:	39 c2                	cmp    %eax,%edx
  8020d7:	73 6d                	jae    802146 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8020d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020dd:	74 06                	je     8020e5 <insert_sorted_allocList+0x1f0>
  8020df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020e3:	75 14                	jne    8020f9 <insert_sorted_allocList+0x204>
  8020e5:	83 ec 04             	sub    $0x4,%esp
  8020e8:	68 24 3e 80 00       	push   $0x803e24
  8020ed:	6a 7f                	push   $0x7f
  8020ef:	68 af 3d 80 00       	push   $0x803daf
  8020f4:	e8 62 e1 ff ff       	call   80025b <_panic>
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	8b 10                	mov    (%eax),%edx
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	89 10                	mov    %edx,(%eax)
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	8b 00                	mov    (%eax),%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	74 0b                	je     802117 <insert_sorted_allocList+0x222>
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	8b 00                	mov    (%eax),%eax
  802111:	8b 55 08             	mov    0x8(%ebp),%edx
  802114:	89 50 04             	mov    %edx,0x4(%eax)
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	8b 55 08             	mov    0x8(%ebp),%edx
  80211d:	89 10                	mov    %edx,(%eax)
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	89 50 04             	mov    %edx,0x4(%eax)
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	8b 00                	mov    (%eax),%eax
  80212d:	85 c0                	test   %eax,%eax
  80212f:	75 08                	jne    802139 <insert_sorted_allocList+0x244>
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	a3 44 40 80 00       	mov    %eax,0x804044
  802139:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80213e:	40                   	inc    %eax
  80213f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802144:	eb 39                	jmp    80217f <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802146:	a1 48 40 80 00       	mov    0x804048,%eax
  80214b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802152:	74 07                	je     80215b <insert_sorted_allocList+0x266>
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 00                	mov    (%eax),%eax
  802159:	eb 05                	jmp    802160 <insert_sorted_allocList+0x26b>
  80215b:	b8 00 00 00 00       	mov    $0x0,%eax
  802160:	a3 48 40 80 00       	mov    %eax,0x804048
  802165:	a1 48 40 80 00       	mov    0x804048,%eax
  80216a:	85 c0                	test   %eax,%eax
  80216c:	0f 85 3f ff ff ff    	jne    8020b1 <insert_sorted_allocList+0x1bc>
  802172:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802176:	0f 85 35 ff ff ff    	jne    8020b1 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80217c:	eb 01                	jmp    80217f <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80217e:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80217f:	90                   	nop
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802188:	a1 38 41 80 00       	mov    0x804138,%eax
  80218d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802190:	e9 85 01 00 00       	jmp    80231a <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 40 0c             	mov    0xc(%eax),%eax
  80219b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80219e:	0f 82 6e 01 00 00    	jb     802312 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8021aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ad:	0f 85 8a 00 00 00    	jne    80223d <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8021b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b7:	75 17                	jne    8021d0 <alloc_block_FF+0x4e>
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	68 58 3e 80 00       	push   $0x803e58
  8021c1:	68 93 00 00 00       	push   $0x93
  8021c6:	68 af 3d 80 00       	push   $0x803daf
  8021cb:	e8 8b e0 ff ff       	call   80025b <_panic>
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	8b 00                	mov    (%eax),%eax
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 10                	je     8021e9 <alloc_block_FF+0x67>
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e1:	8b 52 04             	mov    0x4(%edx),%edx
  8021e4:	89 50 04             	mov    %edx,0x4(%eax)
  8021e7:	eb 0b                	jmp    8021f4 <alloc_block_FF+0x72>
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	8b 40 04             	mov    0x4(%eax),%eax
  8021ef:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 40 04             	mov    0x4(%eax),%eax
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	74 0f                	je     80220d <alloc_block_FF+0x8b>
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	8b 40 04             	mov    0x4(%eax),%eax
  802204:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802207:	8b 12                	mov    (%edx),%edx
  802209:	89 10                	mov    %edx,(%eax)
  80220b:	eb 0a                	jmp    802217 <alloc_block_FF+0x95>
  80220d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802210:	8b 00                	mov    (%eax),%eax
  802212:	a3 38 41 80 00       	mov    %eax,0x804138
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222a:	a1 44 41 80 00       	mov    0x804144,%eax
  80222f:	48                   	dec    %eax
  802230:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	e9 10 01 00 00       	jmp    80234d <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80223d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802240:	8b 40 0c             	mov    0xc(%eax),%eax
  802243:	3b 45 08             	cmp    0x8(%ebp),%eax
  802246:	0f 86 c6 00 00 00    	jbe    802312 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80224c:	a1 48 41 80 00       	mov    0x804148,%eax
  802251:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 50 08             	mov    0x8(%eax),%edx
  80225a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225d:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802263:	8b 55 08             	mov    0x8(%ebp),%edx
  802266:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80226d:	75 17                	jne    802286 <alloc_block_FF+0x104>
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	68 58 3e 80 00       	push   $0x803e58
  802277:	68 9b 00 00 00       	push   $0x9b
  80227c:	68 af 3d 80 00       	push   $0x803daf
  802281:	e8 d5 df ff ff       	call   80025b <_panic>
  802286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802289:	8b 00                	mov    (%eax),%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	74 10                	je     80229f <alloc_block_FF+0x11d>
  80228f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802297:	8b 52 04             	mov    0x4(%edx),%edx
  80229a:	89 50 04             	mov    %edx,0x4(%eax)
  80229d:	eb 0b                	jmp    8022aa <alloc_block_FF+0x128>
  80229f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a2:	8b 40 04             	mov    0x4(%eax),%eax
  8022a5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ad:	8b 40 04             	mov    0x4(%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 0f                	je     8022c3 <alloc_block_FF+0x141>
  8022b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022bd:	8b 12                	mov    (%edx),%edx
  8022bf:	89 10                	mov    %edx,(%eax)
  8022c1:	eb 0a                	jmp    8022cd <alloc_block_FF+0x14b>
  8022c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	a3 48 41 80 00       	mov    %eax,0x804148
  8022cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e0:	a1 54 41 80 00       	mov    0x804154,%eax
  8022e5:	48                   	dec    %eax
  8022e6:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 50 08             	mov    0x8(%eax),%edx
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	01 c2                	add    %eax,%edx
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802302:	2b 45 08             	sub    0x8(%ebp),%eax
  802305:	89 c2                	mov    %eax,%edx
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80230d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802310:	eb 3b                	jmp    80234d <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802312:	a1 40 41 80 00       	mov    0x804140,%eax
  802317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231e:	74 07                	je     802327 <alloc_block_FF+0x1a5>
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	eb 05                	jmp    80232c <alloc_block_FF+0x1aa>
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
  80232c:	a3 40 41 80 00       	mov    %eax,0x804140
  802331:	a1 40 41 80 00       	mov    0x804140,%eax
  802336:	85 c0                	test   %eax,%eax
  802338:	0f 85 57 fe ff ff    	jne    802195 <alloc_block_FF+0x13>
  80233e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802342:	0f 85 4d fe ff ff    	jne    802195 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802348:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802355:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80235c:	a1 38 41 80 00       	mov    0x804138,%eax
  802361:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802364:	e9 df 00 00 00       	jmp    802448 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 0c             	mov    0xc(%eax),%eax
  80236f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802372:	0f 82 c8 00 00 00    	jb     802440 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 40 0c             	mov    0xc(%eax),%eax
  80237e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802381:	0f 85 8a 00 00 00    	jne    802411 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238b:	75 17                	jne    8023a4 <alloc_block_BF+0x55>
  80238d:	83 ec 04             	sub    $0x4,%esp
  802390:	68 58 3e 80 00       	push   $0x803e58
  802395:	68 b7 00 00 00       	push   $0xb7
  80239a:	68 af 3d 80 00       	push   $0x803daf
  80239f:	e8 b7 de ff ff       	call   80025b <_panic>
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	74 10                	je     8023bd <alloc_block_BF+0x6e>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b5:	8b 52 04             	mov    0x4(%edx),%edx
  8023b8:	89 50 04             	mov    %edx,0x4(%eax)
  8023bb:	eb 0b                	jmp    8023c8 <alloc_block_BF+0x79>
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 40 04             	mov    0x4(%eax),%eax
  8023c3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 40 04             	mov    0x4(%eax),%eax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	74 0f                	je     8023e1 <alloc_block_BF+0x92>
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	8b 40 04             	mov    0x4(%eax),%eax
  8023d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023db:	8b 12                	mov    (%edx),%edx
  8023dd:	89 10                	mov    %edx,(%eax)
  8023df:	eb 0a                	jmp    8023eb <alloc_block_BF+0x9c>
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	a3 38 41 80 00       	mov    %eax,0x804138
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023fe:	a1 44 41 80 00       	mov    0x804144,%eax
  802403:	48                   	dec    %eax
  802404:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	e9 4d 01 00 00       	jmp    80255e <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	8b 40 0c             	mov    0xc(%eax),%eax
  802417:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241a:	76 24                	jbe    802440 <alloc_block_BF+0xf1>
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 40 0c             	mov    0xc(%eax),%eax
  802422:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802425:	73 19                	jae    802440 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802427:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 40 0c             	mov    0xc(%eax),%eax
  802434:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 40 08             	mov    0x8(%eax),%eax
  80243d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802440:	a1 40 41 80 00       	mov    0x804140,%eax
  802445:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802448:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244c:	74 07                	je     802455 <alloc_block_BF+0x106>
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 00                	mov    (%eax),%eax
  802453:	eb 05                	jmp    80245a <alloc_block_BF+0x10b>
  802455:	b8 00 00 00 00       	mov    $0x0,%eax
  80245a:	a3 40 41 80 00       	mov    %eax,0x804140
  80245f:	a1 40 41 80 00       	mov    0x804140,%eax
  802464:	85 c0                	test   %eax,%eax
  802466:	0f 85 fd fe ff ff    	jne    802369 <alloc_block_BF+0x1a>
  80246c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802470:	0f 85 f3 fe ff ff    	jne    802369 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802476:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80247a:	0f 84 d9 00 00 00    	je     802559 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802480:	a1 48 41 80 00       	mov    0x804148,%eax
  802485:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80248b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80248e:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802494:	8b 55 08             	mov    0x8(%ebp),%edx
  802497:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80249a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80249e:	75 17                	jne    8024b7 <alloc_block_BF+0x168>
  8024a0:	83 ec 04             	sub    $0x4,%esp
  8024a3:	68 58 3e 80 00       	push   $0x803e58
  8024a8:	68 c7 00 00 00       	push   $0xc7
  8024ad:	68 af 3d 80 00       	push   $0x803daf
  8024b2:	e8 a4 dd ff ff       	call   80025b <_panic>
  8024b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024ba:	8b 00                	mov    (%eax),%eax
  8024bc:	85 c0                	test   %eax,%eax
  8024be:	74 10                	je     8024d0 <alloc_block_BF+0x181>
  8024c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024c8:	8b 52 04             	mov    0x4(%edx),%edx
  8024cb:	89 50 04             	mov    %edx,0x4(%eax)
  8024ce:	eb 0b                	jmp    8024db <alloc_block_BF+0x18c>
  8024d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d3:	8b 40 04             	mov    0x4(%eax),%eax
  8024d6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024de:	8b 40 04             	mov    0x4(%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 0f                	je     8024f4 <alloc_block_BF+0x1a5>
  8024e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ee:	8b 12                	mov    (%edx),%edx
  8024f0:	89 10                	mov    %edx,(%eax)
  8024f2:	eb 0a                	jmp    8024fe <alloc_block_BF+0x1af>
  8024f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	a3 48 41 80 00       	mov    %eax,0x804148
  8024fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802507:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802511:	a1 54 41 80 00       	mov    0x804154,%eax
  802516:	48                   	dec    %eax
  802517:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80251c:	83 ec 08             	sub    $0x8,%esp
  80251f:	ff 75 ec             	pushl  -0x14(%ebp)
  802522:	68 38 41 80 00       	push   $0x804138
  802527:	e8 71 f9 ff ff       	call   801e9d <find_block>
  80252c:	83 c4 10             	add    $0x10,%esp
  80252f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802535:	8b 50 08             	mov    0x8(%eax),%edx
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	01 c2                	add    %eax,%edx
  80253d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802540:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802543:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802546:	8b 40 0c             	mov    0xc(%eax),%eax
  802549:	2b 45 08             	sub    0x8(%ebp),%eax
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802551:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802557:	eb 05                	jmp    80255e <alloc_block_BF+0x20f>
	}
	return NULL;
  802559:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802566:	a1 28 40 80 00       	mov    0x804028,%eax
  80256b:	85 c0                	test   %eax,%eax
  80256d:	0f 85 de 01 00 00    	jne    802751 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802573:	a1 38 41 80 00       	mov    0x804138,%eax
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257b:	e9 9e 01 00 00       	jmp    80271e <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 0c             	mov    0xc(%eax),%eax
  802586:	3b 45 08             	cmp    0x8(%ebp),%eax
  802589:	0f 82 87 01 00 00    	jb     802716 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 0c             	mov    0xc(%eax),%eax
  802595:	3b 45 08             	cmp    0x8(%ebp),%eax
  802598:	0f 85 95 00 00 00    	jne    802633 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80259e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a2:	75 17                	jne    8025bb <alloc_block_NF+0x5b>
  8025a4:	83 ec 04             	sub    $0x4,%esp
  8025a7:	68 58 3e 80 00       	push   $0x803e58
  8025ac:	68 e0 00 00 00       	push   $0xe0
  8025b1:	68 af 3d 80 00       	push   $0x803daf
  8025b6:	e8 a0 dc ff ff       	call   80025b <_panic>
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 00                	mov    (%eax),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	74 10                	je     8025d4 <alloc_block_NF+0x74>
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cc:	8b 52 04             	mov    0x4(%edx),%edx
  8025cf:	89 50 04             	mov    %edx,0x4(%eax)
  8025d2:	eb 0b                	jmp    8025df <alloc_block_NF+0x7f>
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 40 04             	mov    0x4(%eax),%eax
  8025da:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 0f                	je     8025f8 <alloc_block_NF+0x98>
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 04             	mov    0x4(%eax),%eax
  8025ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f2:	8b 12                	mov    (%edx),%edx
  8025f4:	89 10                	mov    %edx,(%eax)
  8025f6:	eb 0a                	jmp    802602 <alloc_block_NF+0xa2>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	a3 38 41 80 00       	mov    %eax,0x804138
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802615:	a1 44 41 80 00       	mov    0x804144,%eax
  80261a:	48                   	dec    %eax
  80261b:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 08             	mov    0x8(%eax),%eax
  802626:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	e9 f8 04 00 00       	jmp    802b2b <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 40 0c             	mov    0xc(%eax),%eax
  802639:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263c:	0f 86 d4 00 00 00    	jbe    802716 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802642:	a1 48 41 80 00       	mov    0x804148,%eax
  802647:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 50 08             	mov    0x8(%eax),%edx
  802650:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802653:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802659:	8b 55 08             	mov    0x8(%ebp),%edx
  80265c:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80265f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802663:	75 17                	jne    80267c <alloc_block_NF+0x11c>
  802665:	83 ec 04             	sub    $0x4,%esp
  802668:	68 58 3e 80 00       	push   $0x803e58
  80266d:	68 e9 00 00 00       	push   $0xe9
  802672:	68 af 3d 80 00       	push   $0x803daf
  802677:	e8 df db ff ff       	call   80025b <_panic>
  80267c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	85 c0                	test   %eax,%eax
  802683:	74 10                	je     802695 <alloc_block_NF+0x135>
  802685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80268d:	8b 52 04             	mov    0x4(%edx),%edx
  802690:	89 50 04             	mov    %edx,0x4(%eax)
  802693:	eb 0b                	jmp    8026a0 <alloc_block_NF+0x140>
  802695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802698:	8b 40 04             	mov    0x4(%eax),%eax
  80269b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	74 0f                	je     8026b9 <alloc_block_NF+0x159>
  8026aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026b3:	8b 12                	mov    (%edx),%edx
  8026b5:	89 10                	mov    %edx,(%eax)
  8026b7:	eb 0a                	jmp    8026c3 <alloc_block_NF+0x163>
  8026b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bc:	8b 00                	mov    (%eax),%eax
  8026be:	a3 48 41 80 00       	mov    %eax,0x804148
  8026c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d6:	a1 54 41 80 00       	mov    0x804154,%eax
  8026db:	48                   	dec    %eax
  8026dc:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8026e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e4:	8b 40 08             	mov    0x8(%eax),%eax
  8026e7:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 50 08             	mov    0x8(%eax),%edx
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	01 c2                	add    %eax,%edx
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	2b 45 08             	sub    0x8(%ebp),%eax
  802706:	89 c2                	mov    %eax,%edx
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80270e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802711:	e9 15 04 00 00       	jmp    802b2b <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802716:	a1 40 41 80 00       	mov    0x804140,%eax
  80271b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802722:	74 07                	je     80272b <alloc_block_NF+0x1cb>
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 00                	mov    (%eax),%eax
  802729:	eb 05                	jmp    802730 <alloc_block_NF+0x1d0>
  80272b:	b8 00 00 00 00       	mov    $0x0,%eax
  802730:	a3 40 41 80 00       	mov    %eax,0x804140
  802735:	a1 40 41 80 00       	mov    0x804140,%eax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	0f 85 3e fe ff ff    	jne    802580 <alloc_block_NF+0x20>
  802742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802746:	0f 85 34 fe ff ff    	jne    802580 <alloc_block_NF+0x20>
  80274c:	e9 d5 03 00 00       	jmp    802b26 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802751:	a1 38 41 80 00       	mov    0x804138,%eax
  802756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802759:	e9 b1 01 00 00       	jmp    80290f <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 50 08             	mov    0x8(%eax),%edx
  802764:	a1 28 40 80 00       	mov    0x804028,%eax
  802769:	39 c2                	cmp    %eax,%edx
  80276b:	0f 82 96 01 00 00    	jb     802907 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 0c             	mov    0xc(%eax),%eax
  802777:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277a:	0f 82 87 01 00 00    	jb     802907 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 40 0c             	mov    0xc(%eax),%eax
  802786:	3b 45 08             	cmp    0x8(%ebp),%eax
  802789:	0f 85 95 00 00 00    	jne    802824 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80278f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802793:	75 17                	jne    8027ac <alloc_block_NF+0x24c>
  802795:	83 ec 04             	sub    $0x4,%esp
  802798:	68 58 3e 80 00       	push   $0x803e58
  80279d:	68 fc 00 00 00       	push   $0xfc
  8027a2:	68 af 3d 80 00       	push   $0x803daf
  8027a7:	e8 af da ff ff       	call   80025b <_panic>
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	8b 00                	mov    (%eax),%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	74 10                	je     8027c5 <alloc_block_NF+0x265>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bd:	8b 52 04             	mov    0x4(%edx),%edx
  8027c0:	89 50 04             	mov    %edx,0x4(%eax)
  8027c3:	eb 0b                	jmp    8027d0 <alloc_block_NF+0x270>
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	8b 40 04             	mov    0x4(%eax),%eax
  8027cb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 04             	mov    0x4(%eax),%eax
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	74 0f                	je     8027e9 <alloc_block_NF+0x289>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e3:	8b 12                	mov    (%edx),%edx
  8027e5:	89 10                	mov    %edx,(%eax)
  8027e7:	eb 0a                	jmp    8027f3 <alloc_block_NF+0x293>
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	a3 38 41 80 00       	mov    %eax,0x804138
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802806:	a1 44 41 80 00       	mov    0x804144,%eax
  80280b:	48                   	dec    %eax
  80280c:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 40 08             	mov    0x8(%eax),%eax
  802817:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	e9 07 03 00 00       	jmp    802b2b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	8b 40 0c             	mov    0xc(%eax),%eax
  80282a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282d:	0f 86 d4 00 00 00    	jbe    802907 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802833:	a1 48 41 80 00       	mov    0x804148,%eax
  802838:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 50 08             	mov    0x8(%eax),%edx
  802841:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802844:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802847:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80284a:	8b 55 08             	mov    0x8(%ebp),%edx
  80284d:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802850:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802854:	75 17                	jne    80286d <alloc_block_NF+0x30d>
  802856:	83 ec 04             	sub    $0x4,%esp
  802859:	68 58 3e 80 00       	push   $0x803e58
  80285e:	68 04 01 00 00       	push   $0x104
  802863:	68 af 3d 80 00       	push   $0x803daf
  802868:	e8 ee d9 ff ff       	call   80025b <_panic>
  80286d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	74 10                	je     802886 <alloc_block_NF+0x326>
  802876:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80287e:	8b 52 04             	mov    0x4(%edx),%edx
  802881:	89 50 04             	mov    %edx,0x4(%eax)
  802884:	eb 0b                	jmp    802891 <alloc_block_NF+0x331>
  802886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802889:	8b 40 04             	mov    0x4(%eax),%eax
  80288c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802891:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802894:	8b 40 04             	mov    0x4(%eax),%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 0f                	je     8028aa <alloc_block_NF+0x34a>
  80289b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289e:	8b 40 04             	mov    0x4(%eax),%eax
  8028a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028a4:	8b 12                	mov    (%edx),%edx
  8028a6:	89 10                	mov    %edx,(%eax)
  8028a8:	eb 0a                	jmp    8028b4 <alloc_block_NF+0x354>
  8028aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ad:	8b 00                	mov    (%eax),%eax
  8028af:	a3 48 41 80 00       	mov    %eax,0x804148
  8028b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c7:	a1 54 41 80 00       	mov    0x804154,%eax
  8028cc:	48                   	dec    %eax
  8028cd:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8028d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d5:	8b 40 08             	mov    0x8(%eax),%eax
  8028d8:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 50 08             	mov    0x8(%eax),%edx
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	01 c2                	add    %eax,%edx
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f4:	2b 45 08             	sub    0x8(%ebp),%eax
  8028f7:	89 c2                	mov    %eax,%edx
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8028ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802902:	e9 24 02 00 00       	jmp    802b2b <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802907:	a1 40 41 80 00       	mov    0x804140,%eax
  80290c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80290f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802913:	74 07                	je     80291c <alloc_block_NF+0x3bc>
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	eb 05                	jmp    802921 <alloc_block_NF+0x3c1>
  80291c:	b8 00 00 00 00       	mov    $0x0,%eax
  802921:	a3 40 41 80 00       	mov    %eax,0x804140
  802926:	a1 40 41 80 00       	mov    0x804140,%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	0f 85 2b fe ff ff    	jne    80275e <alloc_block_NF+0x1fe>
  802933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802937:	0f 85 21 fe ff ff    	jne    80275e <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  80293d:	a1 38 41 80 00       	mov    0x804138,%eax
  802942:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802945:	e9 ae 01 00 00       	jmp    802af8 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 50 08             	mov    0x8(%eax),%edx
  802950:	a1 28 40 80 00       	mov    0x804028,%eax
  802955:	39 c2                	cmp    %eax,%edx
  802957:	0f 83 93 01 00 00    	jae    802af0 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 40 0c             	mov    0xc(%eax),%eax
  802963:	3b 45 08             	cmp    0x8(%ebp),%eax
  802966:	0f 82 84 01 00 00    	jb     802af0 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 0c             	mov    0xc(%eax),%eax
  802972:	3b 45 08             	cmp    0x8(%ebp),%eax
  802975:	0f 85 95 00 00 00    	jne    802a10 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80297b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297f:	75 17                	jne    802998 <alloc_block_NF+0x438>
  802981:	83 ec 04             	sub    $0x4,%esp
  802984:	68 58 3e 80 00       	push   $0x803e58
  802989:	68 14 01 00 00       	push   $0x114
  80298e:	68 af 3d 80 00       	push   $0x803daf
  802993:	e8 c3 d8 ff ff       	call   80025b <_panic>
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 00                	mov    (%eax),%eax
  80299d:	85 c0                	test   %eax,%eax
  80299f:	74 10                	je     8029b1 <alloc_block_NF+0x451>
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	8b 00                	mov    (%eax),%eax
  8029a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a9:	8b 52 04             	mov    0x4(%edx),%edx
  8029ac:	89 50 04             	mov    %edx,0x4(%eax)
  8029af:	eb 0b                	jmp    8029bc <alloc_block_NF+0x45c>
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 04             	mov    0x4(%eax),%eax
  8029b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bf:	8b 40 04             	mov    0x4(%eax),%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	74 0f                	je     8029d5 <alloc_block_NF+0x475>
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 40 04             	mov    0x4(%eax),%eax
  8029cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029cf:	8b 12                	mov    (%edx),%edx
  8029d1:	89 10                	mov    %edx,(%eax)
  8029d3:	eb 0a                	jmp    8029df <alloc_block_NF+0x47f>
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 00                	mov    (%eax),%eax
  8029da:	a3 38 41 80 00       	mov    %eax,0x804138
  8029df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f2:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f7:	48                   	dec    %eax
  8029f8:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 40 08             	mov    0x8(%eax),%eax
  802a03:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	e9 1b 01 00 00       	jmp    802b2b <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 40 0c             	mov    0xc(%eax),%eax
  802a16:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a19:	0f 86 d1 00 00 00    	jbe    802af0 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a1f:	a1 48 41 80 00       	mov    0x804148,%eax
  802a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 50 08             	mov    0x8(%eax),%edx
  802a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a30:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a36:	8b 55 08             	mov    0x8(%ebp),%edx
  802a39:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a40:	75 17                	jne    802a59 <alloc_block_NF+0x4f9>
  802a42:	83 ec 04             	sub    $0x4,%esp
  802a45:	68 58 3e 80 00       	push   $0x803e58
  802a4a:	68 1c 01 00 00       	push   $0x11c
  802a4f:	68 af 3d 80 00       	push   $0x803daf
  802a54:	e8 02 d8 ff ff       	call   80025b <_panic>
  802a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5c:	8b 00                	mov    (%eax),%eax
  802a5e:	85 c0                	test   %eax,%eax
  802a60:	74 10                	je     802a72 <alloc_block_NF+0x512>
  802a62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a6a:	8b 52 04             	mov    0x4(%edx),%edx
  802a6d:	89 50 04             	mov    %edx,0x4(%eax)
  802a70:	eb 0b                	jmp    802a7d <alloc_block_NF+0x51d>
  802a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a75:	8b 40 04             	mov    0x4(%eax),%eax
  802a78:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 0f                	je     802a96 <alloc_block_NF+0x536>
  802a87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8a:	8b 40 04             	mov    0x4(%eax),%eax
  802a8d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a90:	8b 12                	mov    (%edx),%edx
  802a92:	89 10                	mov    %edx,(%eax)
  802a94:	eb 0a                	jmp    802aa0 <alloc_block_NF+0x540>
  802a96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	a3 48 41 80 00       	mov    %eax,0x804148
  802aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ab8:	48                   	dec    %eax
  802ab9:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac1:	8b 40 08             	mov    0x8(%eax),%eax
  802ac4:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 50 08             	mov    0x8(%eax),%edx
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	01 c2                	add    %eax,%edx
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae0:	2b 45 08             	sub    0x8(%ebp),%eax
  802ae3:	89 c2                	mov    %eax,%edx
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aee:	eb 3b                	jmp    802b2b <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802af0:	a1 40 41 80 00       	mov    0x804140,%eax
  802af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802af8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afc:	74 07                	je     802b05 <alloc_block_NF+0x5a5>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	eb 05                	jmp    802b0a <alloc_block_NF+0x5aa>
  802b05:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0a:	a3 40 41 80 00       	mov    %eax,0x804140
  802b0f:	a1 40 41 80 00       	mov    0x804140,%eax
  802b14:	85 c0                	test   %eax,%eax
  802b16:	0f 85 2e fe ff ff    	jne    80294a <alloc_block_NF+0x3ea>
  802b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b20:	0f 85 24 fe ff ff    	jne    80294a <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2b:	c9                   	leave  
  802b2c:	c3                   	ret    

00802b2d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b2d:	55                   	push   %ebp
  802b2e:	89 e5                	mov    %esp,%ebp
  802b30:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b33:	a1 38 41 80 00       	mov    0x804138,%eax
  802b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b3b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b40:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b43:	a1 38 41 80 00       	mov    0x804138,%eax
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	74 14                	je     802b60 <insert_sorted_with_merge_freeList+0x33>
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	8b 50 08             	mov    0x8(%eax),%edx
  802b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b55:	8b 40 08             	mov    0x8(%eax),%eax
  802b58:	39 c2                	cmp    %eax,%edx
  802b5a:	0f 87 9b 01 00 00    	ja     802cfb <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b64:	75 17                	jne    802b7d <insert_sorted_with_merge_freeList+0x50>
  802b66:	83 ec 04             	sub    $0x4,%esp
  802b69:	68 8c 3d 80 00       	push   $0x803d8c
  802b6e:	68 38 01 00 00       	push   $0x138
  802b73:	68 af 3d 80 00       	push   $0x803daf
  802b78:	e8 de d6 ff ff       	call   80025b <_panic>
  802b7d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	8b 00                	mov    (%eax),%eax
  802b8d:	85 c0                	test   %eax,%eax
  802b8f:	74 0d                	je     802b9e <insert_sorted_with_merge_freeList+0x71>
  802b91:	a1 38 41 80 00       	mov    0x804138,%eax
  802b96:	8b 55 08             	mov    0x8(%ebp),%edx
  802b99:	89 50 04             	mov    %edx,0x4(%eax)
  802b9c:	eb 08                	jmp    802ba6 <insert_sorted_with_merge_freeList+0x79>
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	a3 38 41 80 00       	mov    %eax,0x804138
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb8:	a1 44 41 80 00       	mov    0x804144,%eax
  802bbd:	40                   	inc    %eax
  802bbe:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc7:	0f 84 a8 06 00 00    	je     803275 <insert_sorted_with_merge_freeList+0x748>
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	8b 50 08             	mov    0x8(%eax),%edx
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd9:	01 c2                	add    %eax,%edx
  802bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bde:	8b 40 08             	mov    0x8(%eax),%eax
  802be1:	39 c2                	cmp    %eax,%edx
  802be3:	0f 85 8c 06 00 00    	jne    803275 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	8b 50 0c             	mov    0xc(%eax),%edx
  802bef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf5:	01 c2                	add    %eax,%edx
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802bfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c01:	75 17                	jne    802c1a <insert_sorted_with_merge_freeList+0xed>
  802c03:	83 ec 04             	sub    $0x4,%esp
  802c06:	68 58 3e 80 00       	push   $0x803e58
  802c0b:	68 3c 01 00 00       	push   $0x13c
  802c10:	68 af 3d 80 00       	push   $0x803daf
  802c15:	e8 41 d6 ff ff       	call   80025b <_panic>
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 10                	je     802c33 <insert_sorted_with_merge_freeList+0x106>
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 00                	mov    (%eax),%eax
  802c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2b:	8b 52 04             	mov    0x4(%edx),%edx
  802c2e:	89 50 04             	mov    %edx,0x4(%eax)
  802c31:	eb 0b                	jmp    802c3e <insert_sorted_with_merge_freeList+0x111>
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	8b 40 04             	mov    0x4(%eax),%eax
  802c39:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c41:	8b 40 04             	mov    0x4(%eax),%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	74 0f                	je     802c57 <insert_sorted_with_merge_freeList+0x12a>
  802c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c51:	8b 12                	mov    (%edx),%edx
  802c53:	89 10                	mov    %edx,(%eax)
  802c55:	eb 0a                	jmp    802c61 <insert_sorted_with_merge_freeList+0x134>
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	8b 00                	mov    (%eax),%eax
  802c5c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c74:	a1 44 41 80 00       	mov    0x804144,%eax
  802c79:	48                   	dec    %eax
  802c7a:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c82:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802c93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c97:	75 17                	jne    802cb0 <insert_sorted_with_merge_freeList+0x183>
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	68 8c 3d 80 00       	push   $0x803d8c
  802ca1:	68 3f 01 00 00       	push   $0x13f
  802ca6:	68 af 3d 80 00       	push   $0x803daf
  802cab:	e8 ab d5 ff ff       	call   80025b <_panic>
  802cb0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 0d                	je     802cd1 <insert_sorted_with_merge_freeList+0x1a4>
  802cc4:	a1 48 41 80 00       	mov    0x804148,%eax
  802cc9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ccc:	89 50 04             	mov    %edx,0x4(%eax)
  802ccf:	eb 08                	jmp    802cd9 <insert_sorted_with_merge_freeList+0x1ac>
  802cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdc:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ceb:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf0:	40                   	inc    %eax
  802cf1:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802cf6:	e9 7a 05 00 00       	jmp    803275 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d04:	8b 40 08             	mov    0x8(%eax),%eax
  802d07:	39 c2                	cmp    %eax,%edx
  802d09:	0f 82 14 01 00 00    	jb     802e23 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d12:	8b 50 08             	mov    0x8(%eax),%edx
  802d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d18:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1b:	01 c2                	add    %eax,%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	8b 40 08             	mov    0x8(%eax),%eax
  802d23:	39 c2                	cmp    %eax,%edx
  802d25:	0f 85 90 00 00 00    	jne    802dbb <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c2                	add    %eax,%edx
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d57:	75 17                	jne    802d70 <insert_sorted_with_merge_freeList+0x243>
  802d59:	83 ec 04             	sub    $0x4,%esp
  802d5c:	68 8c 3d 80 00       	push   $0x803d8c
  802d61:	68 49 01 00 00       	push   $0x149
  802d66:	68 af 3d 80 00       	push   $0x803daf
  802d6b:	e8 eb d4 ff ff       	call   80025b <_panic>
  802d70:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	89 10                	mov    %edx,(%eax)
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 0d                	je     802d91 <insert_sorted_with_merge_freeList+0x264>
  802d84:	a1 48 41 80 00       	mov    0x804148,%eax
  802d89:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8c:	89 50 04             	mov    %edx,0x4(%eax)
  802d8f:	eb 08                	jmp    802d99 <insert_sorted_with_merge_freeList+0x26c>
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	a3 48 41 80 00       	mov    %eax,0x804148
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dab:	a1 54 41 80 00       	mov    0x804154,%eax
  802db0:	40                   	inc    %eax
  802db1:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802db6:	e9 bb 04 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802dbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbf:	75 17                	jne    802dd8 <insert_sorted_with_merge_freeList+0x2ab>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 00 3e 80 00       	push   $0x803e00
  802dc9:	68 4c 01 00 00       	push   $0x14c
  802dce:	68 af 3d 80 00       	push   $0x803daf
  802dd3:	e8 83 d4 ff ff       	call   80025b <_panic>
  802dd8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	89 50 04             	mov    %edx,0x4(%eax)
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	85 c0                	test   %eax,%eax
  802dec:	74 0c                	je     802dfa <insert_sorted_with_merge_freeList+0x2cd>
  802dee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802df3:	8b 55 08             	mov    0x8(%ebp),%edx
  802df6:	89 10                	mov    %edx,(%eax)
  802df8:	eb 08                	jmp    802e02 <insert_sorted_with_merge_freeList+0x2d5>
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	a3 38 41 80 00       	mov    %eax,0x804138
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e13:	a1 44 41 80 00       	mov    0x804144,%eax
  802e18:	40                   	inc    %eax
  802e19:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e1e:	e9 53 04 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e23:	a1 38 41 80 00       	mov    0x804138,%eax
  802e28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e2b:	e9 15 04 00 00       	jmp    803245 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 50 08             	mov    0x8(%eax),%edx
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 40 08             	mov    0x8(%eax),%eax
  802e44:	39 c2                	cmp    %eax,%edx
  802e46:	0f 86 f1 03 00 00    	jbe    80323d <insert_sorted_with_merge_freeList+0x710>
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	8b 50 08             	mov    0x8(%eax),%edx
  802e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e55:	8b 40 08             	mov    0x8(%eax),%eax
  802e58:	39 c2                	cmp    %eax,%edx
  802e5a:	0f 83 dd 03 00 00    	jae    80323d <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 50 08             	mov    0x8(%eax),%edx
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6c:	01 c2                	add    %eax,%edx
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	8b 40 08             	mov    0x8(%eax),%eax
  802e74:	39 c2                	cmp    %eax,%edx
  802e76:	0f 85 b9 01 00 00    	jne    803035 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	8b 50 08             	mov    0x8(%eax),%edx
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	8b 40 0c             	mov    0xc(%eax),%eax
  802e88:	01 c2                	add    %eax,%edx
  802e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8d:	8b 40 08             	mov    0x8(%eax),%eax
  802e90:	39 c2                	cmp    %eax,%edx
  802e92:	0f 85 0d 01 00 00    	jne    802fa5 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea4:	01 c2                	add    %eax,%edx
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802eac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eb0:	75 17                	jne    802ec9 <insert_sorted_with_merge_freeList+0x39c>
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	68 58 3e 80 00       	push   $0x803e58
  802eba:	68 5c 01 00 00       	push   $0x15c
  802ebf:	68 af 3d 80 00       	push   $0x803daf
  802ec4:	e8 92 d3 ff ff       	call   80025b <_panic>
  802ec9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	74 10                	je     802ee2 <insert_sorted_with_merge_freeList+0x3b5>
  802ed2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed5:	8b 00                	mov    (%eax),%eax
  802ed7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eda:	8b 52 04             	mov    0x4(%edx),%edx
  802edd:	89 50 04             	mov    %edx,0x4(%eax)
  802ee0:	eb 0b                	jmp    802eed <insert_sorted_with_merge_freeList+0x3c0>
  802ee2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee5:	8b 40 04             	mov    0x4(%eax),%eax
  802ee8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef0:	8b 40 04             	mov    0x4(%eax),%eax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	74 0f                	je     802f06 <insert_sorted_with_merge_freeList+0x3d9>
  802ef7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f00:	8b 12                	mov    (%edx),%edx
  802f02:	89 10                	mov    %edx,(%eax)
  802f04:	eb 0a                	jmp    802f10 <insert_sorted_with_merge_freeList+0x3e3>
  802f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	a3 38 41 80 00       	mov    %eax,0x804138
  802f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f23:	a1 44 41 80 00       	mov    0x804144,%eax
  802f28:	48                   	dec    %eax
  802f29:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f46:	75 17                	jne    802f5f <insert_sorted_with_merge_freeList+0x432>
  802f48:	83 ec 04             	sub    $0x4,%esp
  802f4b:	68 8c 3d 80 00       	push   $0x803d8c
  802f50:	68 5f 01 00 00       	push   $0x15f
  802f55:	68 af 3d 80 00       	push   $0x803daf
  802f5a:	e8 fc d2 ff ff       	call   80025b <_panic>
  802f5f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f68:	89 10                	mov    %edx,(%eax)
  802f6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6d:	8b 00                	mov    (%eax),%eax
  802f6f:	85 c0                	test   %eax,%eax
  802f71:	74 0d                	je     802f80 <insert_sorted_with_merge_freeList+0x453>
  802f73:	a1 48 41 80 00       	mov    0x804148,%eax
  802f78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f7b:	89 50 04             	mov    %edx,0x4(%eax)
  802f7e:	eb 08                	jmp    802f88 <insert_sorted_with_merge_freeList+0x45b>
  802f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f83:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9a:	a1 54 41 80 00       	mov    0x804154,%eax
  802f9f:	40                   	inc    %eax
  802fa0:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 50 0c             	mov    0xc(%eax),%edx
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	01 c2                	add    %eax,%edx
  802fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd1:	75 17                	jne    802fea <insert_sorted_with_merge_freeList+0x4bd>
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	68 8c 3d 80 00       	push   $0x803d8c
  802fdb:	68 64 01 00 00       	push   $0x164
  802fe0:	68 af 3d 80 00       	push   $0x803daf
  802fe5:	e8 71 d2 ff ff       	call   80025b <_panic>
  802fea:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff3:	89 10                	mov    %edx,(%eax)
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	8b 00                	mov    (%eax),%eax
  802ffa:	85 c0                	test   %eax,%eax
  802ffc:	74 0d                	je     80300b <insert_sorted_with_merge_freeList+0x4de>
  802ffe:	a1 48 41 80 00       	mov    0x804148,%eax
  803003:	8b 55 08             	mov    0x8(%ebp),%edx
  803006:	89 50 04             	mov    %edx,0x4(%eax)
  803009:	eb 08                	jmp    803013 <insert_sorted_with_merge_freeList+0x4e6>
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	a3 48 41 80 00       	mov    %eax,0x804148
  80301b:	8b 45 08             	mov    0x8(%ebp),%eax
  80301e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803025:	a1 54 41 80 00       	mov    0x804154,%eax
  80302a:	40                   	inc    %eax
  80302b:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803030:	e9 41 02 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	8b 50 08             	mov    0x8(%eax),%edx
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	8b 40 0c             	mov    0xc(%eax),%eax
  803041:	01 c2                	add    %eax,%edx
  803043:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803046:	8b 40 08             	mov    0x8(%eax),%eax
  803049:	39 c2                	cmp    %eax,%edx
  80304b:	0f 85 7c 01 00 00    	jne    8031cd <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803051:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803055:	74 06                	je     80305d <insert_sorted_with_merge_freeList+0x530>
  803057:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80305b:	75 17                	jne    803074 <insert_sorted_with_merge_freeList+0x547>
  80305d:	83 ec 04             	sub    $0x4,%esp
  803060:	68 c8 3d 80 00       	push   $0x803dc8
  803065:	68 69 01 00 00       	push   $0x169
  80306a:	68 af 3d 80 00       	push   $0x803daf
  80306f:	e8 e7 d1 ff ff       	call   80025b <_panic>
  803074:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803077:	8b 50 04             	mov    0x4(%eax),%edx
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	89 50 04             	mov    %edx,0x4(%eax)
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803086:	89 10                	mov    %edx,(%eax)
  803088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	85 c0                	test   %eax,%eax
  803090:	74 0d                	je     80309f <insert_sorted_with_merge_freeList+0x572>
  803092:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	8b 55 08             	mov    0x8(%ebp),%edx
  80309b:	89 10                	mov    %edx,(%eax)
  80309d:	eb 08                	jmp    8030a7 <insert_sorted_with_merge_freeList+0x57a>
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	a3 38 41 80 00       	mov    %eax,0x804138
  8030a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ad:	89 50 04             	mov    %edx,0x4(%eax)
  8030b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8030b5:	40                   	inc    %eax
  8030b6:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c7:	01 c2                	add    %eax,%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d3:	75 17                	jne    8030ec <insert_sorted_with_merge_freeList+0x5bf>
  8030d5:	83 ec 04             	sub    $0x4,%esp
  8030d8:	68 58 3e 80 00       	push   $0x803e58
  8030dd:	68 6b 01 00 00       	push   $0x16b
  8030e2:	68 af 3d 80 00       	push   $0x803daf
  8030e7:	e8 6f d1 ff ff       	call   80025b <_panic>
  8030ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	85 c0                	test   %eax,%eax
  8030f3:	74 10                	je     803105 <insert_sorted_with_merge_freeList+0x5d8>
  8030f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f8:	8b 00                	mov    (%eax),%eax
  8030fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fd:	8b 52 04             	mov    0x4(%edx),%edx
  803100:	89 50 04             	mov    %edx,0x4(%eax)
  803103:	eb 0b                	jmp    803110 <insert_sorted_with_merge_freeList+0x5e3>
  803105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803108:	8b 40 04             	mov    0x4(%eax),%eax
  80310b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 40 04             	mov    0x4(%eax),%eax
  803116:	85 c0                	test   %eax,%eax
  803118:	74 0f                	je     803129 <insert_sorted_with_merge_freeList+0x5fc>
  80311a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803123:	8b 12                	mov    (%edx),%edx
  803125:	89 10                	mov    %edx,(%eax)
  803127:	eb 0a                	jmp    803133 <insert_sorted_with_merge_freeList+0x606>
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	8b 00                	mov    (%eax),%eax
  80312e:	a3 38 41 80 00       	mov    %eax,0x804138
  803133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803136:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80313c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803146:	a1 44 41 80 00       	mov    0x804144,%eax
  80314b:	48                   	dec    %eax
  80314c:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803151:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803154:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80315b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803165:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803169:	75 17                	jne    803182 <insert_sorted_with_merge_freeList+0x655>
  80316b:	83 ec 04             	sub    $0x4,%esp
  80316e:	68 8c 3d 80 00       	push   $0x803d8c
  803173:	68 6e 01 00 00       	push   $0x16e
  803178:	68 af 3d 80 00       	push   $0x803daf
  80317d:	e8 d9 d0 ff ff       	call   80025b <_panic>
  803182:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803188:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318b:	89 10                	mov    %edx,(%eax)
  80318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803190:	8b 00                	mov    (%eax),%eax
  803192:	85 c0                	test   %eax,%eax
  803194:	74 0d                	je     8031a3 <insert_sorted_with_merge_freeList+0x676>
  803196:	a1 48 41 80 00       	mov    0x804148,%eax
  80319b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80319e:	89 50 04             	mov    %edx,0x4(%eax)
  8031a1:	eb 08                	jmp    8031ab <insert_sorted_with_merge_freeList+0x67e>
  8031a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ae:	a3 48 41 80 00       	mov    %eax,0x804148
  8031b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bd:	a1 54 41 80 00       	mov    0x804154,%eax
  8031c2:	40                   	inc    %eax
  8031c3:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031c8:	e9 a9 00 00 00       	jmp    803276 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8031cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d1:	74 06                	je     8031d9 <insert_sorted_with_merge_freeList+0x6ac>
  8031d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d7:	75 17                	jne    8031f0 <insert_sorted_with_merge_freeList+0x6c3>
  8031d9:	83 ec 04             	sub    $0x4,%esp
  8031dc:	68 24 3e 80 00       	push   $0x803e24
  8031e1:	68 73 01 00 00       	push   $0x173
  8031e6:	68 af 3d 80 00       	push   $0x803daf
  8031eb:	e8 6b d0 ff ff       	call   80025b <_panic>
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 10                	mov    (%eax),%edx
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	89 10                	mov    %edx,(%eax)
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	8b 00                	mov    (%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0b                	je     80320e <insert_sorted_with_merge_freeList+0x6e1>
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	8b 55 08             	mov    0x8(%ebp),%edx
  80320b:	89 50 04             	mov    %edx,0x4(%eax)
  80320e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803211:	8b 55 08             	mov    0x8(%ebp),%edx
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	75 08                	jne    803230 <insert_sorted_with_merge_freeList+0x703>
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803230:	a1 44 41 80 00       	mov    0x804144,%eax
  803235:	40                   	inc    %eax
  803236:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80323b:	eb 39                	jmp    803276 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80323d:	a1 40 41 80 00       	mov    0x804140,%eax
  803242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803245:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803249:	74 07                	je     803252 <insert_sorted_with_merge_freeList+0x725>
  80324b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	eb 05                	jmp    803257 <insert_sorted_with_merge_freeList+0x72a>
  803252:	b8 00 00 00 00       	mov    $0x0,%eax
  803257:	a3 40 41 80 00       	mov    %eax,0x804140
  80325c:	a1 40 41 80 00       	mov    0x804140,%eax
  803261:	85 c0                	test   %eax,%eax
  803263:	0f 85 c7 fb ff ff    	jne    802e30 <insert_sorted_with_merge_freeList+0x303>
  803269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326d:	0f 85 bd fb ff ff    	jne    802e30 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803273:	eb 01                	jmp    803276 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803275:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803276:	90                   	nop
  803277:	c9                   	leave  
  803278:	c3                   	ret    
  803279:	66 90                	xchg   %ax,%ax
  80327b:	90                   	nop

0080327c <__udivdi3>:
  80327c:	55                   	push   %ebp
  80327d:	57                   	push   %edi
  80327e:	56                   	push   %esi
  80327f:	53                   	push   %ebx
  803280:	83 ec 1c             	sub    $0x1c,%esp
  803283:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803287:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80328b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80328f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803293:	89 ca                	mov    %ecx,%edx
  803295:	89 f8                	mov    %edi,%eax
  803297:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80329b:	85 f6                	test   %esi,%esi
  80329d:	75 2d                	jne    8032cc <__udivdi3+0x50>
  80329f:	39 cf                	cmp    %ecx,%edi
  8032a1:	77 65                	ja     803308 <__udivdi3+0x8c>
  8032a3:	89 fd                	mov    %edi,%ebp
  8032a5:	85 ff                	test   %edi,%edi
  8032a7:	75 0b                	jne    8032b4 <__udivdi3+0x38>
  8032a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ae:	31 d2                	xor    %edx,%edx
  8032b0:	f7 f7                	div    %edi
  8032b2:	89 c5                	mov    %eax,%ebp
  8032b4:	31 d2                	xor    %edx,%edx
  8032b6:	89 c8                	mov    %ecx,%eax
  8032b8:	f7 f5                	div    %ebp
  8032ba:	89 c1                	mov    %eax,%ecx
  8032bc:	89 d8                	mov    %ebx,%eax
  8032be:	f7 f5                	div    %ebp
  8032c0:	89 cf                	mov    %ecx,%edi
  8032c2:	89 fa                	mov    %edi,%edx
  8032c4:	83 c4 1c             	add    $0x1c,%esp
  8032c7:	5b                   	pop    %ebx
  8032c8:	5e                   	pop    %esi
  8032c9:	5f                   	pop    %edi
  8032ca:	5d                   	pop    %ebp
  8032cb:	c3                   	ret    
  8032cc:	39 ce                	cmp    %ecx,%esi
  8032ce:	77 28                	ja     8032f8 <__udivdi3+0x7c>
  8032d0:	0f bd fe             	bsr    %esi,%edi
  8032d3:	83 f7 1f             	xor    $0x1f,%edi
  8032d6:	75 40                	jne    803318 <__udivdi3+0x9c>
  8032d8:	39 ce                	cmp    %ecx,%esi
  8032da:	72 0a                	jb     8032e6 <__udivdi3+0x6a>
  8032dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032e0:	0f 87 9e 00 00 00    	ja     803384 <__udivdi3+0x108>
  8032e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032eb:	89 fa                	mov    %edi,%edx
  8032ed:	83 c4 1c             	add    $0x1c,%esp
  8032f0:	5b                   	pop    %ebx
  8032f1:	5e                   	pop    %esi
  8032f2:	5f                   	pop    %edi
  8032f3:	5d                   	pop    %ebp
  8032f4:	c3                   	ret    
  8032f5:	8d 76 00             	lea    0x0(%esi),%esi
  8032f8:	31 ff                	xor    %edi,%edi
  8032fa:	31 c0                	xor    %eax,%eax
  8032fc:	89 fa                	mov    %edi,%edx
  8032fe:	83 c4 1c             	add    $0x1c,%esp
  803301:	5b                   	pop    %ebx
  803302:	5e                   	pop    %esi
  803303:	5f                   	pop    %edi
  803304:	5d                   	pop    %ebp
  803305:	c3                   	ret    
  803306:	66 90                	xchg   %ax,%ax
  803308:	89 d8                	mov    %ebx,%eax
  80330a:	f7 f7                	div    %edi
  80330c:	31 ff                	xor    %edi,%edi
  80330e:	89 fa                	mov    %edi,%edx
  803310:	83 c4 1c             	add    $0x1c,%esp
  803313:	5b                   	pop    %ebx
  803314:	5e                   	pop    %esi
  803315:	5f                   	pop    %edi
  803316:	5d                   	pop    %ebp
  803317:	c3                   	ret    
  803318:	bd 20 00 00 00       	mov    $0x20,%ebp
  80331d:	89 eb                	mov    %ebp,%ebx
  80331f:	29 fb                	sub    %edi,%ebx
  803321:	89 f9                	mov    %edi,%ecx
  803323:	d3 e6                	shl    %cl,%esi
  803325:	89 c5                	mov    %eax,%ebp
  803327:	88 d9                	mov    %bl,%cl
  803329:	d3 ed                	shr    %cl,%ebp
  80332b:	89 e9                	mov    %ebp,%ecx
  80332d:	09 f1                	or     %esi,%ecx
  80332f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803333:	89 f9                	mov    %edi,%ecx
  803335:	d3 e0                	shl    %cl,%eax
  803337:	89 c5                	mov    %eax,%ebp
  803339:	89 d6                	mov    %edx,%esi
  80333b:	88 d9                	mov    %bl,%cl
  80333d:	d3 ee                	shr    %cl,%esi
  80333f:	89 f9                	mov    %edi,%ecx
  803341:	d3 e2                	shl    %cl,%edx
  803343:	8b 44 24 08          	mov    0x8(%esp),%eax
  803347:	88 d9                	mov    %bl,%cl
  803349:	d3 e8                	shr    %cl,%eax
  80334b:	09 c2                	or     %eax,%edx
  80334d:	89 d0                	mov    %edx,%eax
  80334f:	89 f2                	mov    %esi,%edx
  803351:	f7 74 24 0c          	divl   0xc(%esp)
  803355:	89 d6                	mov    %edx,%esi
  803357:	89 c3                	mov    %eax,%ebx
  803359:	f7 e5                	mul    %ebp
  80335b:	39 d6                	cmp    %edx,%esi
  80335d:	72 19                	jb     803378 <__udivdi3+0xfc>
  80335f:	74 0b                	je     80336c <__udivdi3+0xf0>
  803361:	89 d8                	mov    %ebx,%eax
  803363:	31 ff                	xor    %edi,%edi
  803365:	e9 58 ff ff ff       	jmp    8032c2 <__udivdi3+0x46>
  80336a:	66 90                	xchg   %ax,%ax
  80336c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803370:	89 f9                	mov    %edi,%ecx
  803372:	d3 e2                	shl    %cl,%edx
  803374:	39 c2                	cmp    %eax,%edx
  803376:	73 e9                	jae    803361 <__udivdi3+0xe5>
  803378:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80337b:	31 ff                	xor    %edi,%edi
  80337d:	e9 40 ff ff ff       	jmp    8032c2 <__udivdi3+0x46>
  803382:	66 90                	xchg   %ax,%ax
  803384:	31 c0                	xor    %eax,%eax
  803386:	e9 37 ff ff ff       	jmp    8032c2 <__udivdi3+0x46>
  80338b:	90                   	nop

0080338c <__umoddi3>:
  80338c:	55                   	push   %ebp
  80338d:	57                   	push   %edi
  80338e:	56                   	push   %esi
  80338f:	53                   	push   %ebx
  803390:	83 ec 1c             	sub    $0x1c,%esp
  803393:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803397:	8b 74 24 34          	mov    0x34(%esp),%esi
  80339b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80339f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033ab:	89 f3                	mov    %esi,%ebx
  8033ad:	89 fa                	mov    %edi,%edx
  8033af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033b3:	89 34 24             	mov    %esi,(%esp)
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	75 1a                	jne    8033d4 <__umoddi3+0x48>
  8033ba:	39 f7                	cmp    %esi,%edi
  8033bc:	0f 86 a2 00 00 00    	jbe    803464 <__umoddi3+0xd8>
  8033c2:	89 c8                	mov    %ecx,%eax
  8033c4:	89 f2                	mov    %esi,%edx
  8033c6:	f7 f7                	div    %edi
  8033c8:	89 d0                	mov    %edx,%eax
  8033ca:	31 d2                	xor    %edx,%edx
  8033cc:	83 c4 1c             	add    $0x1c,%esp
  8033cf:	5b                   	pop    %ebx
  8033d0:	5e                   	pop    %esi
  8033d1:	5f                   	pop    %edi
  8033d2:	5d                   	pop    %ebp
  8033d3:	c3                   	ret    
  8033d4:	39 f0                	cmp    %esi,%eax
  8033d6:	0f 87 ac 00 00 00    	ja     803488 <__umoddi3+0xfc>
  8033dc:	0f bd e8             	bsr    %eax,%ebp
  8033df:	83 f5 1f             	xor    $0x1f,%ebp
  8033e2:	0f 84 ac 00 00 00    	je     803494 <__umoddi3+0x108>
  8033e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8033ed:	29 ef                	sub    %ebp,%edi
  8033ef:	89 fe                	mov    %edi,%esi
  8033f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033f5:	89 e9                	mov    %ebp,%ecx
  8033f7:	d3 e0                	shl    %cl,%eax
  8033f9:	89 d7                	mov    %edx,%edi
  8033fb:	89 f1                	mov    %esi,%ecx
  8033fd:	d3 ef                	shr    %cl,%edi
  8033ff:	09 c7                	or     %eax,%edi
  803401:	89 e9                	mov    %ebp,%ecx
  803403:	d3 e2                	shl    %cl,%edx
  803405:	89 14 24             	mov    %edx,(%esp)
  803408:	89 d8                	mov    %ebx,%eax
  80340a:	d3 e0                	shl    %cl,%eax
  80340c:	89 c2                	mov    %eax,%edx
  80340e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803412:	d3 e0                	shl    %cl,%eax
  803414:	89 44 24 04          	mov    %eax,0x4(%esp)
  803418:	8b 44 24 08          	mov    0x8(%esp),%eax
  80341c:	89 f1                	mov    %esi,%ecx
  80341e:	d3 e8                	shr    %cl,%eax
  803420:	09 d0                	or     %edx,%eax
  803422:	d3 eb                	shr    %cl,%ebx
  803424:	89 da                	mov    %ebx,%edx
  803426:	f7 f7                	div    %edi
  803428:	89 d3                	mov    %edx,%ebx
  80342a:	f7 24 24             	mull   (%esp)
  80342d:	89 c6                	mov    %eax,%esi
  80342f:	89 d1                	mov    %edx,%ecx
  803431:	39 d3                	cmp    %edx,%ebx
  803433:	0f 82 87 00 00 00    	jb     8034c0 <__umoddi3+0x134>
  803439:	0f 84 91 00 00 00    	je     8034d0 <__umoddi3+0x144>
  80343f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803443:	29 f2                	sub    %esi,%edx
  803445:	19 cb                	sbb    %ecx,%ebx
  803447:	89 d8                	mov    %ebx,%eax
  803449:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80344d:	d3 e0                	shl    %cl,%eax
  80344f:	89 e9                	mov    %ebp,%ecx
  803451:	d3 ea                	shr    %cl,%edx
  803453:	09 d0                	or     %edx,%eax
  803455:	89 e9                	mov    %ebp,%ecx
  803457:	d3 eb                	shr    %cl,%ebx
  803459:	89 da                	mov    %ebx,%edx
  80345b:	83 c4 1c             	add    $0x1c,%esp
  80345e:	5b                   	pop    %ebx
  80345f:	5e                   	pop    %esi
  803460:	5f                   	pop    %edi
  803461:	5d                   	pop    %ebp
  803462:	c3                   	ret    
  803463:	90                   	nop
  803464:	89 fd                	mov    %edi,%ebp
  803466:	85 ff                	test   %edi,%edi
  803468:	75 0b                	jne    803475 <__umoddi3+0xe9>
  80346a:	b8 01 00 00 00       	mov    $0x1,%eax
  80346f:	31 d2                	xor    %edx,%edx
  803471:	f7 f7                	div    %edi
  803473:	89 c5                	mov    %eax,%ebp
  803475:	89 f0                	mov    %esi,%eax
  803477:	31 d2                	xor    %edx,%edx
  803479:	f7 f5                	div    %ebp
  80347b:	89 c8                	mov    %ecx,%eax
  80347d:	f7 f5                	div    %ebp
  80347f:	89 d0                	mov    %edx,%eax
  803481:	e9 44 ff ff ff       	jmp    8033ca <__umoddi3+0x3e>
  803486:	66 90                	xchg   %ax,%ax
  803488:	89 c8                	mov    %ecx,%eax
  80348a:	89 f2                	mov    %esi,%edx
  80348c:	83 c4 1c             	add    $0x1c,%esp
  80348f:	5b                   	pop    %ebx
  803490:	5e                   	pop    %esi
  803491:	5f                   	pop    %edi
  803492:	5d                   	pop    %ebp
  803493:	c3                   	ret    
  803494:	3b 04 24             	cmp    (%esp),%eax
  803497:	72 06                	jb     80349f <__umoddi3+0x113>
  803499:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80349d:	77 0f                	ja     8034ae <__umoddi3+0x122>
  80349f:	89 f2                	mov    %esi,%edx
  8034a1:	29 f9                	sub    %edi,%ecx
  8034a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034a7:	89 14 24             	mov    %edx,(%esp)
  8034aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034b2:	8b 14 24             	mov    (%esp),%edx
  8034b5:	83 c4 1c             	add    $0x1c,%esp
  8034b8:	5b                   	pop    %ebx
  8034b9:	5e                   	pop    %esi
  8034ba:	5f                   	pop    %edi
  8034bb:	5d                   	pop    %ebp
  8034bc:	c3                   	ret    
  8034bd:	8d 76 00             	lea    0x0(%esi),%esi
  8034c0:	2b 04 24             	sub    (%esp),%eax
  8034c3:	19 fa                	sbb    %edi,%edx
  8034c5:	89 d1                	mov    %edx,%ecx
  8034c7:	89 c6                	mov    %eax,%esi
  8034c9:	e9 71 ff ff ff       	jmp    80343f <__umoddi3+0xb3>
  8034ce:	66 90                	xchg   %ax,%ax
  8034d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034d4:	72 ea                	jb     8034c0 <__umoddi3+0x134>
  8034d6:	89 d9                	mov    %ebx,%ecx
  8034d8:	e9 62 ff ff ff       	jmp    80343f <__umoddi3+0xb3>
