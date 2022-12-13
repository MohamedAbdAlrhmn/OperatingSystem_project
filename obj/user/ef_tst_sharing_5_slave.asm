
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
  80008c:	68 40 36 80 00       	push   $0x803640
  800091:	6a 12                	push   $0x12
  800093:	68 5c 36 80 00       	push   $0x80365c
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 55 1a 00 00       	call   801af7 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 7a 36 80 00       	push   $0x80367a
  8000aa:	50                   	push   %eax
  8000ab:	e8 2a 15 00 00       	call   8015da <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 43 17 00 00       	call   8017fe <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 7c 36 80 00       	push   $0x80367c
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 c5 15 00 00       	call   80169e <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 a0 36 80 00       	push   $0x8036a0
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 0d 17 00 00       	call   8017fe <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 b8 36 80 00       	push   $0x8036b8
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 5c 36 80 00       	push   $0x80365c
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 00 1b 00 00       	call   801c1c <inctst>

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
  800125:	e8 b4 19 00 00       	call   801ade <sys_getenvindex>
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
  800190:	e8 56 17 00 00       	call   8018eb <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 5c 37 80 00       	push   $0x80375c
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
  8001c0:	68 84 37 80 00       	push   $0x803784
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
  8001f1:	68 ac 37 80 00       	push   $0x8037ac
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 04 38 80 00       	push   $0x803804
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 5c 37 80 00       	push   $0x80375c
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 d6 16 00 00       	call   801905 <sys_enable_interrupt>

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
  800242:	e8 63 18 00 00       	call   801aaa <sys_destroy_env>
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
  800253:	e8 b8 18 00 00       	call   801b10 <sys_exit_env>
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
  80027c:	68 18 38 80 00       	push   $0x803818
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 1d 38 80 00       	push   $0x80381d
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
  8002b9:	68 39 38 80 00       	push   $0x803839
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
  8002e5:	68 3c 38 80 00       	push   $0x80383c
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 88 38 80 00       	push   $0x803888
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
  8003b7:	68 94 38 80 00       	push   $0x803894
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 88 38 80 00       	push   $0x803888
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
  800427:	68 e8 38 80 00       	push   $0x8038e8
  80042c:	6a 44                	push   $0x44
  80042e:	68 88 38 80 00       	push   $0x803888
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
  800481:	e8 b7 12 00 00       	call   80173d <sys_cputs>
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
  8004f8:	e8 40 12 00 00       	call   80173d <sys_cputs>
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
  800542:	e8 a4 13 00 00       	call   8018eb <sys_disable_interrupt>
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
  800562:	e8 9e 13 00 00       	call   801905 <sys_enable_interrupt>
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
  8005ac:	e8 0f 2e 00 00       	call   8033c0 <__udivdi3>
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
  8005fc:	e8 cf 2e 00 00       	call   8034d0 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 54 3b 80 00       	add    $0x803b54,%eax
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
  800757:	8b 04 85 78 3b 80 00 	mov    0x803b78(,%eax,4),%eax
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
  800838:	8b 34 9d c0 39 80 00 	mov    0x8039c0(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 65 3b 80 00       	push   $0x803b65
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
  80085d:	68 6e 3b 80 00       	push   $0x803b6e
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
  80088a:	be 71 3b 80 00       	mov    $0x803b71,%esi
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
  8012b0:	68 d0 3c 80 00       	push   $0x803cd0
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
  801380:	e8 fc 04 00 00       	call   801881 <sys_allocate_chunk>
  801385:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801388:	a1 20 41 80 00       	mov    0x804120,%eax
  80138d:	83 ec 0c             	sub    $0xc,%esp
  801390:	50                   	push   %eax
  801391:	e8 71 0b 00 00       	call   801f07 <initialize_MemBlocksList>
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
  8013be:	68 f5 3c 80 00       	push   $0x803cf5
  8013c3:	6a 33                	push   $0x33
  8013c5:	68 13 3d 80 00       	push   $0x803d13
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
  80143d:	68 20 3d 80 00       	push   $0x803d20
  801442:	6a 34                	push   $0x34
  801444:	68 13 3d 80 00       	push   $0x803d13
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
  80149a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80149d:	e8 f7 fd ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a6:	75 07                	jne    8014af <malloc+0x18>
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ad:	eb 61                	jmp    801510 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8014af:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	48                   	dec    %eax
  8014bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ca:	f7 75 f0             	divl   -0x10(%ebp)
  8014cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d0:	29 d0                	sub    %edx,%eax
  8014d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014d5:	e8 75 07 00 00       	call   801c4f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	74 11                	je     8014ef <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014de:	83 ec 0c             	sub    $0xc,%esp
  8014e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8014e4:	e8 e0 0d 00 00       	call   8022c9 <alloc_block_FF>
  8014e9:	83 c4 10             	add    $0x10,%esp
  8014ec:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8014ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014f3:	74 16                	je     80150b <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  8014f5:	83 ec 0c             	sub    $0xc,%esp
  8014f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8014fb:	e8 3c 0b 00 00       	call   80203c <insert_sorted_allocList>
  801500:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801506:	8b 40 08             	mov    0x8(%eax),%eax
  801509:	eb 05                	jmp    801510 <malloc+0x79>
	}

    return NULL;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	68 44 3d 80 00       	push   $0x803d44
  801520:	6a 6f                	push   $0x6f
  801522:	68 13 3d 80 00       	push   $0x803d13
  801527:	e8 2f ed ff ff       	call   80025b <_panic>

0080152c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 38             	sub    $0x38,%esp
  801532:	8b 45 10             	mov    0x10(%ebp),%eax
  801535:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801538:	e8 5c fd ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  80153d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801541:	75 0a                	jne    80154d <smalloc+0x21>
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	e9 8b 00 00 00       	jmp    8015d8 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80154d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801554:	8b 55 0c             	mov    0xc(%ebp),%edx
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	01 d0                	add    %edx,%eax
  80155c:	48                   	dec    %eax
  80155d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801560:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801563:	ba 00 00 00 00       	mov    $0x0,%edx
  801568:	f7 75 f0             	divl   -0x10(%ebp)
  80156b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156e:	29 d0                	sub    %edx,%eax
  801570:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801573:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80157a:	e8 d0 06 00 00       	call   801c4f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80157f:	85 c0                	test   %eax,%eax
  801581:	74 11                	je     801594 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801583:	83 ec 0c             	sub    $0xc,%esp
  801586:	ff 75 e8             	pushl  -0x18(%ebp)
  801589:	e8 3b 0d 00 00       	call   8022c9 <alloc_block_FF>
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801598:	74 39                	je     8015d3 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159d:	8b 40 08             	mov    0x8(%eax),%eax
  8015a0:	89 c2                	mov    %eax,%edx
  8015a2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015a6:	52                   	push   %edx
  8015a7:	50                   	push   %eax
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 21 04 00 00       	call   8019d4 <sys_createSharedObject>
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015b9:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015bd:	74 14                	je     8015d3 <smalloc+0xa7>
  8015bf:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015c3:	74 0e                	je     8015d3 <smalloc+0xa7>
  8015c5:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015c9:	74 08                	je     8015d3 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8015cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ce:	8b 40 08             	mov    0x8(%eax),%eax
  8015d1:	eb 05                	jmp    8015d8 <smalloc+0xac>
	}
	return NULL;
  8015d3:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e0:	e8 b4 fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8015e5:	83 ec 08             	sub    $0x8,%esp
  8015e8:	ff 75 0c             	pushl  0xc(%ebp)
  8015eb:	ff 75 08             	pushl  0x8(%ebp)
  8015ee:	e8 0b 04 00 00       	call   8019fe <sys_getSizeOfSharedObject>
  8015f3:	83 c4 10             	add    $0x10,%esp
  8015f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8015f9:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8015fd:	74 76                	je     801675 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8015ff:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801606:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801609:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160c:	01 d0                	add    %edx,%eax
  80160e:	48                   	dec    %eax
  80160f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801615:	ba 00 00 00 00       	mov    $0x0,%edx
  80161a:	f7 75 ec             	divl   -0x14(%ebp)
  80161d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801620:	29 d0                	sub    %edx,%eax
  801622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801625:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80162c:	e8 1e 06 00 00       	call   801c4f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801631:	85 c0                	test   %eax,%eax
  801633:	74 11                	je     801646 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801635:	83 ec 0c             	sub    $0xc,%esp
  801638:	ff 75 e4             	pushl  -0x1c(%ebp)
  80163b:	e8 89 0c 00 00       	call   8022c9 <alloc_block_FF>
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801646:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80164a:	74 29                	je     801675 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164f:	8b 40 08             	mov    0x8(%eax),%eax
  801652:	83 ec 04             	sub    $0x4,%esp
  801655:	50                   	push   %eax
  801656:	ff 75 0c             	pushl  0xc(%ebp)
  801659:	ff 75 08             	pushl  0x8(%ebp)
  80165c:	e8 ba 03 00 00       	call   801a1b <sys_getSharedObject>
  801661:	83 c4 10             	add    $0x10,%esp
  801664:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801667:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80166b:	74 08                	je     801675 <sget+0x9b>
				return (void *)mem_block->sva;
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	8b 40 08             	mov    0x8(%eax),%eax
  801673:	eb 05                	jmp    80167a <sget+0xa0>
		}
	}
	return (void *)NULL;
  801675:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801682:	e8 12 fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801687:	83 ec 04             	sub    $0x4,%esp
  80168a:	68 68 3d 80 00       	push   $0x803d68
  80168f:	68 f1 00 00 00       	push   $0xf1
  801694:	68 13 3d 80 00       	push   $0x803d13
  801699:	e8 bd eb ff ff       	call   80025b <_panic>

0080169e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016a4:	83 ec 04             	sub    $0x4,%esp
  8016a7:	68 90 3d 80 00       	push   $0x803d90
  8016ac:	68 05 01 00 00       	push   $0x105
  8016b1:	68 13 3d 80 00       	push   $0x803d13
  8016b6:	e8 a0 eb ff ff       	call   80025b <_panic>

008016bb <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016c1:	83 ec 04             	sub    $0x4,%esp
  8016c4:	68 b4 3d 80 00       	push   $0x803db4
  8016c9:	68 10 01 00 00       	push   $0x110
  8016ce:	68 13 3d 80 00       	push   $0x803d13
  8016d3:	e8 83 eb ff ff       	call   80025b <_panic>

008016d8 <shrink>:

}
void shrink(uint32 newSize)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	68 b4 3d 80 00       	push   $0x803db4
  8016e6:	68 15 01 00 00       	push   $0x115
  8016eb:	68 13 3d 80 00       	push   $0x803d13
  8016f0:	e8 66 eb ff ff       	call   80025b <_panic>

008016f5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	68 b4 3d 80 00       	push   $0x803db4
  801703:	68 1a 01 00 00       	push   $0x11a
  801708:	68 13 3d 80 00       	push   $0x803d13
  80170d:	e8 49 eb ff ff       	call   80025b <_panic>

00801712 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	57                   	push   %edi
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801721:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801724:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801727:	8b 7d 18             	mov    0x18(%ebp),%edi
  80172a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80172d:	cd 30                	int    $0x30
  80172f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801732:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801735:	83 c4 10             	add    $0x10,%esp
  801738:	5b                   	pop    %ebx
  801739:	5e                   	pop    %esi
  80173a:	5f                   	pop    %edi
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    

0080173d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801749:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80174d:	8b 45 08             	mov    0x8(%ebp),%eax
  801750:	6a 00                	push   $0x0
  801752:	6a 00                	push   $0x0
  801754:	52                   	push   %edx
  801755:	ff 75 0c             	pushl  0xc(%ebp)
  801758:	50                   	push   %eax
  801759:	6a 00                	push   $0x0
  80175b:	e8 b2 ff ff ff       	call   801712 <syscall>
  801760:	83 c4 18             	add    $0x18,%esp
}
  801763:	90                   	nop
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <sys_cgetc>:

int
sys_cgetc(void)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801769:	6a 00                	push   $0x0
  80176b:	6a 00                	push   $0x0
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 01                	push   $0x1
  801775:	e8 98 ff ff ff       	call   801712 <syscall>
  80177a:	83 c4 18             	add    $0x18,%esp
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801782:	8b 55 0c             	mov    0xc(%ebp),%edx
  801785:	8b 45 08             	mov    0x8(%ebp),%eax
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	52                   	push   %edx
  80178f:	50                   	push   %eax
  801790:	6a 05                	push   $0x5
  801792:	e8 7b ff ff ff       	call   801712 <syscall>
  801797:	83 c4 18             	add    $0x18,%esp
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	56                   	push   %esi
  8017a0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8017a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
  8017b2:	51                   	push   %ecx
  8017b3:	52                   	push   %edx
  8017b4:	50                   	push   %eax
  8017b5:	6a 06                	push   $0x6
  8017b7:	e8 56 ff ff ff       	call   801712 <syscall>
  8017bc:	83 c4 18             	add    $0x18,%esp
}
  8017bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c2:	5b                   	pop    %ebx
  8017c3:	5e                   	pop    %esi
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	6a 00                	push   $0x0
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	52                   	push   %edx
  8017d6:	50                   	push   %eax
  8017d7:	6a 07                	push   $0x7
  8017d9:	e8 34 ff ff ff       	call   801712 <syscall>
  8017de:	83 c4 18             	add    $0x18,%esp
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	ff 75 0c             	pushl  0xc(%ebp)
  8017ef:	ff 75 08             	pushl  0x8(%ebp)
  8017f2:	6a 08                	push   $0x8
  8017f4:	e8 19 ff ff ff       	call   801712 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 09                	push   $0x9
  80180d:	e8 00 ff ff ff       	call   801712 <syscall>
  801812:	83 c4 18             	add    $0x18,%esp
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 0a                	push   $0xa
  801826:	e8 e7 fe ff ff       	call   801712 <syscall>
  80182b:	83 c4 18             	add    $0x18,%esp
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 0b                	push   $0xb
  80183f:	e8 ce fe ff ff       	call   801712 <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	ff 75 0c             	pushl  0xc(%ebp)
  801855:	ff 75 08             	pushl  0x8(%ebp)
  801858:	6a 0f                	push   $0xf
  80185a:	e8 b3 fe ff ff       	call   801712 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
	return;
  801862:	90                   	nop
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	6a 10                	push   $0x10
  801876:	e8 97 fe ff ff       	call   801712 <syscall>
  80187b:	83 c4 18             	add    $0x18,%esp
	return ;
  80187e:	90                   	nop
}
  80187f:	c9                   	leave  
  801880:	c3                   	ret    

00801881 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	ff 75 10             	pushl  0x10(%ebp)
  80188b:	ff 75 0c             	pushl  0xc(%ebp)
  80188e:	ff 75 08             	pushl  0x8(%ebp)
  801891:	6a 11                	push   $0x11
  801893:	e8 7a fe ff ff       	call   801712 <syscall>
  801898:	83 c4 18             	add    $0x18,%esp
	return ;
  80189b:	90                   	nop
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 0c                	push   $0xc
  8018ad:	e8 60 fe ff ff       	call   801712 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	ff 75 08             	pushl  0x8(%ebp)
  8018c5:	6a 0d                	push   $0xd
  8018c7:	e8 46 fe ff ff       	call   801712 <syscall>
  8018cc:	83 c4 18             	add    $0x18,%esp
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 0e                	push   $0xe
  8018e0:	e8 2d fe ff ff       	call   801712 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	90                   	nop
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 13                	push   $0x13
  8018fa:	e8 13 fe ff ff       	call   801712 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 14                	push   $0x14
  801914:	e8 f9 fd ff ff       	call   801712 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	90                   	nop
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_cputc>:


void
sys_cputc(const char c)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80192b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	50                   	push   %eax
  801938:	6a 15                	push   $0x15
  80193a:	e8 d3 fd ff ff       	call   801712 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	90                   	nop
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 16                	push   $0x16
  801954:	e8 b9 fd ff ff       	call   801712 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
}
  80195c:	90                   	nop
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801962:	8b 45 08             	mov    0x8(%ebp),%eax
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 0c             	pushl  0xc(%ebp)
  80196e:	50                   	push   %eax
  80196f:	6a 17                	push   $0x17
  801971:	e8 9c fd ff ff       	call   801712 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	52                   	push   %edx
  80198b:	50                   	push   %eax
  80198c:	6a 1a                	push   $0x1a
  80198e:	e8 7f fd ff ff       	call   801712 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 18                	push   $0x18
  8019ab:	e8 62 fd ff ff       	call   801712 <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	90                   	nop
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	52                   	push   %edx
  8019c6:	50                   	push   %eax
  8019c7:	6a 19                	push   $0x19
  8019c9:	e8 44 fd ff ff       	call   801712 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019e3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	6a 00                	push   $0x0
  8019ec:	51                   	push   %ecx
  8019ed:	52                   	push   %edx
  8019ee:	ff 75 0c             	pushl  0xc(%ebp)
  8019f1:	50                   	push   %eax
  8019f2:	6a 1b                	push   $0x1b
  8019f4:	e8 19 fd ff ff       	call   801712 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a04:	8b 45 08             	mov    0x8(%ebp),%eax
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	52                   	push   %edx
  801a0e:	50                   	push   %eax
  801a0f:	6a 1c                	push   $0x1c
  801a11:	e8 fc fc ff ff       	call   801712 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	51                   	push   %ecx
  801a2c:	52                   	push   %edx
  801a2d:	50                   	push   %eax
  801a2e:	6a 1d                	push   $0x1d
  801a30:	e8 dd fc ff ff       	call   801712 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	52                   	push   %edx
  801a4a:	50                   	push   %eax
  801a4b:	6a 1e                	push   $0x1e
  801a4d:	e8 c0 fc ff ff       	call   801712 <syscall>
  801a52:	83 c4 18             	add    $0x18,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 1f                	push   $0x1f
  801a66:	e8 a7 fc ff ff       	call   801712 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	6a 00                	push   $0x0
  801a78:	ff 75 14             	pushl  0x14(%ebp)
  801a7b:	ff 75 10             	pushl  0x10(%ebp)
  801a7e:	ff 75 0c             	pushl  0xc(%ebp)
  801a81:	50                   	push   %eax
  801a82:	6a 20                	push   $0x20
  801a84:	e8 89 fc ff ff       	call   801712 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	50                   	push   %eax
  801a9d:	6a 21                	push   $0x21
  801a9f:	e8 6e fc ff ff       	call   801712 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	90                   	nop
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	50                   	push   %eax
  801ab9:	6a 22                	push   $0x22
  801abb:	e8 52 fc ff ff       	call   801712 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 02                	push   $0x2
  801ad4:	e8 39 fc ff ff       	call   801712 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 03                	push   $0x3
  801aed:	e8 20 fc ff ff       	call   801712 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 04                	push   $0x4
  801b06:	e8 07 fc ff ff       	call   801712 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_exit_env>:


void sys_exit_env(void)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 23                	push   $0x23
  801b1f:	e8 ee fb ff ff       	call   801712 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	90                   	nop
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b30:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b33:	8d 50 04             	lea    0x4(%eax),%edx
  801b36:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	6a 24                	push   $0x24
  801b43:	e8 ca fb ff ff       	call   801712 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
	return result;
  801b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b51:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b54:	89 01                	mov    %eax,(%ecx)
  801b56:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	c9                   	leave  
  801b5d:	c2 04 00             	ret    $0x4

00801b60 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	ff 75 10             	pushl  0x10(%ebp)
  801b6a:	ff 75 0c             	pushl  0xc(%ebp)
  801b6d:	ff 75 08             	pushl  0x8(%ebp)
  801b70:	6a 12                	push   $0x12
  801b72:	e8 9b fb ff ff       	call   801712 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7a:	90                   	nop
}
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_rcr2>:
uint32 sys_rcr2()
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 25                	push   $0x25
  801b8c:	e8 81 fb ff ff       	call   801712 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	83 ec 04             	sub    $0x4,%esp
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	50                   	push   %eax
  801baf:	6a 26                	push   $0x26
  801bb1:	e8 5c fb ff ff       	call   801712 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb9:	90                   	nop
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <rsttst>:
void rsttst()
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 28                	push   $0x28
  801bcb:	e8 42 fb ff ff       	call   801712 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	8b 45 14             	mov    0x14(%ebp),%eax
  801bdf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be2:	8b 55 18             	mov    0x18(%ebp),%edx
  801be5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be9:	52                   	push   %edx
  801bea:	50                   	push   %eax
  801beb:	ff 75 10             	pushl  0x10(%ebp)
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	ff 75 08             	pushl  0x8(%ebp)
  801bf4:	6a 27                	push   $0x27
  801bf6:	e8 17 fb ff ff       	call   801712 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfe:	90                   	nop
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <chktst>:
void chktst(uint32 n)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	ff 75 08             	pushl  0x8(%ebp)
  801c0f:	6a 29                	push   $0x29
  801c11:	e8 fc fa ff ff       	call   801712 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
	return ;
  801c19:	90                   	nop
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <inctst>:

void inctst()
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 2a                	push   $0x2a
  801c2b:	e8 e2 fa ff ff       	call   801712 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
	return ;
  801c33:	90                   	nop
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <gettst>:
uint32 gettst()
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 2b                	push   $0x2b
  801c45:	e8 c8 fa ff ff       	call   801712 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 2c                	push   $0x2c
  801c61:	e8 ac fa ff ff       	call   801712 <syscall>
  801c66:	83 c4 18             	add    $0x18,%esp
  801c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c6c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c70:	75 07                	jne    801c79 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c72:	b8 01 00 00 00       	mov    $0x1,%eax
  801c77:	eb 05                	jmp    801c7e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 2c                	push   $0x2c
  801c92:	e8 7b fa ff ff       	call   801712 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
  801c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c9d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ca1:	75 07                	jne    801caa <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ca3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca8:	eb 05                	jmp    801caf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 2c                	push   $0x2c
  801cc3:	e8 4a fa ff ff       	call   801712 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
  801ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cce:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cd2:	75 07                	jne    801cdb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cd4:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd9:	eb 05                	jmp    801ce0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
  801ce5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 2c                	push   $0x2c
  801cf4:	e8 19 fa ff ff       	call   801712 <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
  801cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cff:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d03:	75 07                	jne    801d0c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d05:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0a:	eb 05                	jmp    801d11 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    

00801d13 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d13:	55                   	push   %ebp
  801d14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	ff 75 08             	pushl  0x8(%ebp)
  801d21:	6a 2d                	push   $0x2d
  801d23:	e8 ea f9 ff ff       	call   801712 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2b:	90                   	nop
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	6a 00                	push   $0x0
  801d40:	53                   	push   %ebx
  801d41:	51                   	push   %ecx
  801d42:	52                   	push   %edx
  801d43:	50                   	push   %eax
  801d44:	6a 2e                	push   $0x2e
  801d46:	e8 c7 f9 ff ff       	call   801712 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	52                   	push   %edx
  801d63:	50                   	push   %eax
  801d64:	6a 2f                	push   $0x2f
  801d66:	e8 a7 f9 ff ff       	call   801712 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d76:	83 ec 0c             	sub    $0xc,%esp
  801d79:	68 c4 3d 80 00       	push   $0x803dc4
  801d7e:	e8 8c e7 ff ff       	call   80050f <cprintf>
  801d83:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d86:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d8d:	83 ec 0c             	sub    $0xc,%esp
  801d90:	68 f0 3d 80 00       	push   $0x803df0
  801d95:	e8 75 e7 ff ff       	call   80050f <cprintf>
  801d9a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d9d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801da1:	a1 38 41 80 00       	mov    0x804138,%eax
  801da6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da9:	eb 56                	jmp    801e01 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801daf:	74 1c                	je     801dcd <print_mem_block_lists+0x5d>
  801db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db4:	8b 50 08             	mov    0x8(%eax),%edx
  801db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dba:	8b 48 08             	mov    0x8(%eax),%ecx
  801dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc3:	01 c8                	add    %ecx,%eax
  801dc5:	39 c2                	cmp    %eax,%edx
  801dc7:	73 04                	jae    801dcd <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dc9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	8b 50 08             	mov    0x8(%eax),%edx
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd9:	01 c2                	add    %eax,%edx
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	8b 40 08             	mov    0x8(%eax),%eax
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	52                   	push   %edx
  801de5:	50                   	push   %eax
  801de6:	68 05 3e 80 00       	push   $0x803e05
  801deb:	e8 1f e7 ff ff       	call   80050f <cprintf>
  801df0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df9:	a1 40 41 80 00       	mov    0x804140,%eax
  801dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e05:	74 07                	je     801e0e <print_mem_block_lists+0x9e>
  801e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0a:	8b 00                	mov    (%eax),%eax
  801e0c:	eb 05                	jmp    801e13 <print_mem_block_lists+0xa3>
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e13:	a3 40 41 80 00       	mov    %eax,0x804140
  801e18:	a1 40 41 80 00       	mov    0x804140,%eax
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	75 8a                	jne    801dab <print_mem_block_lists+0x3b>
  801e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e25:	75 84                	jne    801dab <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e27:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e2b:	75 10                	jne    801e3d <print_mem_block_lists+0xcd>
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	68 14 3e 80 00       	push   $0x803e14
  801e35:	e8 d5 e6 ff ff       	call   80050f <cprintf>
  801e3a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e3d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e44:	83 ec 0c             	sub    $0xc,%esp
  801e47:	68 38 3e 80 00       	push   $0x803e38
  801e4c:	e8 be e6 ff ff       	call   80050f <cprintf>
  801e51:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e54:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e58:	a1 40 40 80 00       	mov    0x804040,%eax
  801e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e60:	eb 56                	jmp    801eb8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e66:	74 1c                	je     801e84 <print_mem_block_lists+0x114>
  801e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6b:	8b 50 08             	mov    0x8(%eax),%edx
  801e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e71:	8b 48 08             	mov    0x8(%eax),%ecx
  801e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e77:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7a:	01 c8                	add    %ecx,%eax
  801e7c:	39 c2                	cmp    %eax,%edx
  801e7e:	73 04                	jae    801e84 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e80:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e87:	8b 50 08             	mov    0x8(%eax),%edx
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e90:	01 c2                	add    %eax,%edx
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 40 08             	mov    0x8(%eax),%eax
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	52                   	push   %edx
  801e9c:	50                   	push   %eax
  801e9d:	68 05 3e 80 00       	push   $0x803e05
  801ea2:	e8 68 e6 ff ff       	call   80050f <cprintf>
  801ea7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eb0:	a1 48 40 80 00       	mov    0x804048,%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebc:	74 07                	je     801ec5 <print_mem_block_lists+0x155>
  801ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec1:	8b 00                	mov    (%eax),%eax
  801ec3:	eb 05                	jmp    801eca <print_mem_block_lists+0x15a>
  801ec5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eca:	a3 48 40 80 00       	mov    %eax,0x804048
  801ecf:	a1 48 40 80 00       	mov    0x804048,%eax
  801ed4:	85 c0                	test   %eax,%eax
  801ed6:	75 8a                	jne    801e62 <print_mem_block_lists+0xf2>
  801ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edc:	75 84                	jne    801e62 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ede:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ee2:	75 10                	jne    801ef4 <print_mem_block_lists+0x184>
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	68 50 3e 80 00       	push   $0x803e50
  801eec:	e8 1e e6 ff ff       	call   80050f <cprintf>
  801ef1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	68 c4 3d 80 00       	push   $0x803dc4
  801efc:	e8 0e e6 ff ff       	call   80050f <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp

}
  801f04:	90                   	nop
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f0d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f14:	00 00 00 
  801f17:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f1e:	00 00 00 
  801f21:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f28:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f32:	e9 9e 00 00 00       	jmp    801fd5 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f37:	a1 50 40 80 00       	mov    0x804050,%eax
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	c1 e2 04             	shl    $0x4,%edx
  801f42:	01 d0                	add    %edx,%eax
  801f44:	85 c0                	test   %eax,%eax
  801f46:	75 14                	jne    801f5c <initialize_MemBlocksList+0x55>
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	68 78 3e 80 00       	push   $0x803e78
  801f50:	6a 46                	push   $0x46
  801f52:	68 9b 3e 80 00       	push   $0x803e9b
  801f57:	e8 ff e2 ff ff       	call   80025b <_panic>
  801f5c:	a1 50 40 80 00       	mov    0x804050,%eax
  801f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f64:	c1 e2 04             	shl    $0x4,%edx
  801f67:	01 d0                	add    %edx,%eax
  801f69:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f6f:	89 10                	mov    %edx,(%eax)
  801f71:	8b 00                	mov    (%eax),%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	74 18                	je     801f8f <initialize_MemBlocksList+0x88>
  801f77:	a1 48 41 80 00       	mov    0x804148,%eax
  801f7c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f82:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f85:	c1 e1 04             	shl    $0x4,%ecx
  801f88:	01 ca                	add    %ecx,%edx
  801f8a:	89 50 04             	mov    %edx,0x4(%eax)
  801f8d:	eb 12                	jmp    801fa1 <initialize_MemBlocksList+0x9a>
  801f8f:	a1 50 40 80 00       	mov    0x804050,%eax
  801f94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f97:	c1 e2 04             	shl    $0x4,%edx
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801fa1:	a1 50 40 80 00       	mov    0x804050,%eax
  801fa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa9:	c1 e2 04             	shl    $0x4,%edx
  801fac:	01 d0                	add    %edx,%eax
  801fae:	a3 48 41 80 00       	mov    %eax,0x804148
  801fb3:	a1 50 40 80 00       	mov    0x804050,%eax
  801fb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbb:	c1 e2 04             	shl    $0x4,%edx
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fc7:	a1 54 41 80 00       	mov    0x804154,%eax
  801fcc:	40                   	inc    %eax
  801fcd:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fd2:	ff 45 f4             	incl   -0xc(%ebp)
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fdb:	0f 82 56 ff ff ff    	jb     801f37 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801fe1:	90                   	nop
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	8b 00                	mov    (%eax),%eax
  801fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ff2:	eb 19                	jmp    80200d <find_block+0x29>
	{
		if(va==point->sva)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8b 40 08             	mov    0x8(%eax),%eax
  801ffa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ffd:	75 05                	jne    802004 <find_block+0x20>
		   return point;
  801fff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802002:	eb 36                	jmp    80203a <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	8b 40 08             	mov    0x8(%eax),%eax
  80200a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80200d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802011:	74 07                	je     80201a <find_block+0x36>
  802013:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802016:	8b 00                	mov    (%eax),%eax
  802018:	eb 05                	jmp    80201f <find_block+0x3b>
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
  80201f:	8b 55 08             	mov    0x8(%ebp),%edx
  802022:	89 42 08             	mov    %eax,0x8(%edx)
  802025:	8b 45 08             	mov    0x8(%ebp),%eax
  802028:	8b 40 08             	mov    0x8(%eax),%eax
  80202b:	85 c0                	test   %eax,%eax
  80202d:	75 c5                	jne    801ff4 <find_block+0x10>
  80202f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802033:	75 bf                	jne    801ff4 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802042:	a1 40 40 80 00       	mov    0x804040,%eax
  802047:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80204a:	a1 44 40 80 00       	mov    0x804044,%eax
  80204f:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802052:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802055:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802058:	74 24                	je     80207e <insert_sorted_allocList+0x42>
  80205a:	8b 45 08             	mov    0x8(%ebp),%eax
  80205d:	8b 50 08             	mov    0x8(%eax),%edx
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	8b 40 08             	mov    0x8(%eax),%eax
  802066:	39 c2                	cmp    %eax,%edx
  802068:	76 14                	jbe    80207e <insert_sorted_allocList+0x42>
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	8b 50 08             	mov    0x8(%eax),%edx
  802070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802073:	8b 40 08             	mov    0x8(%eax),%eax
  802076:	39 c2                	cmp    %eax,%edx
  802078:	0f 82 60 01 00 00    	jb     8021de <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80207e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802082:	75 65                	jne    8020e9 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802084:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802088:	75 14                	jne    80209e <insert_sorted_allocList+0x62>
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	68 78 3e 80 00       	push   $0x803e78
  802092:	6a 6b                	push   $0x6b
  802094:	68 9b 3e 80 00       	push   $0x803e9b
  802099:	e8 bd e1 ff ff       	call   80025b <_panic>
  80209e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	89 10                	mov    %edx,(%eax)
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	8b 00                	mov    (%eax),%eax
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	74 0d                	je     8020bf <insert_sorted_allocList+0x83>
  8020b2:	a1 40 40 80 00       	mov    0x804040,%eax
  8020b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ba:	89 50 04             	mov    %edx,0x4(%eax)
  8020bd:	eb 08                	jmp    8020c7 <insert_sorted_allocList+0x8b>
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	a3 44 40 80 00       	mov    %eax,0x804044
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	a3 40 40 80 00       	mov    %eax,0x804040
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020de:	40                   	inc    %eax
  8020df:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020e4:	e9 dc 01 00 00       	jmp    8022c5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	8b 50 08             	mov    0x8(%eax),%edx
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	39 c2                	cmp    %eax,%edx
  8020f7:	77 6c                	ja     802165 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8020f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020fd:	74 06                	je     802105 <insert_sorted_allocList+0xc9>
  8020ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802103:	75 14                	jne    802119 <insert_sorted_allocList+0xdd>
  802105:	83 ec 04             	sub    $0x4,%esp
  802108:	68 b4 3e 80 00       	push   $0x803eb4
  80210d:	6a 6f                	push   $0x6f
  80210f:	68 9b 3e 80 00       	push   $0x803e9b
  802114:	e8 42 e1 ff ff       	call   80025b <_panic>
  802119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211c:	8b 50 04             	mov    0x4(%eax),%edx
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	89 50 04             	mov    %edx,0x4(%eax)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80212b:	89 10                	mov    %edx,(%eax)
  80212d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802130:	8b 40 04             	mov    0x4(%eax),%eax
  802133:	85 c0                	test   %eax,%eax
  802135:	74 0d                	je     802144 <insert_sorted_allocList+0x108>
  802137:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213a:	8b 40 04             	mov    0x4(%eax),%eax
  80213d:	8b 55 08             	mov    0x8(%ebp),%edx
  802140:	89 10                	mov    %edx,(%eax)
  802142:	eb 08                	jmp    80214c <insert_sorted_allocList+0x110>
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 40 40 80 00       	mov    %eax,0x804040
  80214c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214f:	8b 55 08             	mov    0x8(%ebp),%edx
  802152:	89 50 04             	mov    %edx,0x4(%eax)
  802155:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80215a:	40                   	inc    %eax
  80215b:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802160:	e9 60 01 00 00       	jmp    8022c5 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	8b 50 08             	mov    0x8(%eax),%edx
  80216b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80216e:	8b 40 08             	mov    0x8(%eax),%eax
  802171:	39 c2                	cmp    %eax,%edx
  802173:	0f 82 4c 01 00 00    	jb     8022c5 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802179:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217d:	75 14                	jne    802193 <insert_sorted_allocList+0x157>
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	68 ec 3e 80 00       	push   $0x803eec
  802187:	6a 73                	push   $0x73
  802189:	68 9b 3e 80 00       	push   $0x803e9b
  80218e:	e8 c8 e0 ff ff       	call   80025b <_panic>
  802193:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	89 50 04             	mov    %edx,0x4(%eax)
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	8b 40 04             	mov    0x4(%eax),%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 0c                	je     8021b5 <insert_sorted_allocList+0x179>
  8021a9:	a1 44 40 80 00       	mov    0x804044,%eax
  8021ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b1:	89 10                	mov    %edx,(%eax)
  8021b3:	eb 08                	jmp    8021bd <insert_sorted_allocList+0x181>
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	a3 40 40 80 00       	mov    %eax,0x804040
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	a3 44 40 80 00       	mov    %eax,0x804044
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021ce:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d3:	40                   	inc    %eax
  8021d4:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021d9:	e9 e7 00 00 00       	jmp    8022c5 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021eb:	a1 40 40 80 00       	mov    0x804040,%eax
  8021f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f3:	e9 9d 00 00 00       	jmp    802295 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	8b 00                	mov    (%eax),%eax
  8021fd:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8b 50 08             	mov    0x8(%eax),%edx
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 40 08             	mov    0x8(%eax),%eax
  80220c:	39 c2                	cmp    %eax,%edx
  80220e:	76 7d                	jbe    80228d <insert_sorted_allocList+0x251>
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	8b 50 08             	mov    0x8(%eax),%edx
  802216:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802219:	8b 40 08             	mov    0x8(%eax),%eax
  80221c:	39 c2                	cmp    %eax,%edx
  80221e:	73 6d                	jae    80228d <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802224:	74 06                	je     80222c <insert_sorted_allocList+0x1f0>
  802226:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222a:	75 14                	jne    802240 <insert_sorted_allocList+0x204>
  80222c:	83 ec 04             	sub    $0x4,%esp
  80222f:	68 10 3f 80 00       	push   $0x803f10
  802234:	6a 7f                	push   $0x7f
  802236:	68 9b 3e 80 00       	push   $0x803e9b
  80223b:	e8 1b e0 ff ff       	call   80025b <_panic>
  802240:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802243:	8b 10                	mov    (%eax),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	89 10                	mov    %edx,(%eax)
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	85 c0                	test   %eax,%eax
  802251:	74 0b                	je     80225e <insert_sorted_allocList+0x222>
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 00                	mov    (%eax),%eax
  802258:	8b 55 08             	mov    0x8(%ebp),%edx
  80225b:	89 50 04             	mov    %edx,0x4(%eax)
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 55 08             	mov    0x8(%ebp),%edx
  802264:	89 10                	mov    %edx,(%eax)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226c:	89 50 04             	mov    %edx,0x4(%eax)
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8b 00                	mov    (%eax),%eax
  802274:	85 c0                	test   %eax,%eax
  802276:	75 08                	jne    802280 <insert_sorted_allocList+0x244>
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	a3 44 40 80 00       	mov    %eax,0x804044
  802280:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802285:	40                   	inc    %eax
  802286:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80228b:	eb 39                	jmp    8022c6 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80228d:	a1 48 40 80 00       	mov    0x804048,%eax
  802292:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802295:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802299:	74 07                	je     8022a2 <insert_sorted_allocList+0x266>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	eb 05                	jmp    8022a7 <insert_sorted_allocList+0x26b>
  8022a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a7:	a3 48 40 80 00       	mov    %eax,0x804048
  8022ac:	a1 48 40 80 00       	mov    0x804048,%eax
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	0f 85 3f ff ff ff    	jne    8021f8 <insert_sorted_allocList+0x1bc>
  8022b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022bd:	0f 85 35 ff ff ff    	jne    8021f8 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022c3:	eb 01                	jmp    8022c6 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022c5:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022c6:	90                   	nop
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8022d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d7:	e9 85 01 00 00       	jmp    802461 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e5:	0f 82 6e 01 00 00    	jb     802459 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022f4:	0f 85 8a 00 00 00    	jne    802384 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8022fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fe:	75 17                	jne    802317 <alloc_block_FF+0x4e>
  802300:	83 ec 04             	sub    $0x4,%esp
  802303:	68 44 3f 80 00       	push   $0x803f44
  802308:	68 93 00 00 00       	push   $0x93
  80230d:	68 9b 3e 80 00       	push   $0x803e9b
  802312:	e8 44 df ff ff       	call   80025b <_panic>
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 00                	mov    (%eax),%eax
  80231c:	85 c0                	test   %eax,%eax
  80231e:	74 10                	je     802330 <alloc_block_FF+0x67>
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802328:	8b 52 04             	mov    0x4(%edx),%edx
  80232b:	89 50 04             	mov    %edx,0x4(%eax)
  80232e:	eb 0b                	jmp    80233b <alloc_block_FF+0x72>
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802333:	8b 40 04             	mov    0x4(%eax),%eax
  802336:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 40 04             	mov    0x4(%eax),%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	74 0f                	je     802354 <alloc_block_FF+0x8b>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 04             	mov    0x4(%eax),%eax
  80234b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234e:	8b 12                	mov    (%edx),%edx
  802350:	89 10                	mov    %edx,(%eax)
  802352:	eb 0a                	jmp    80235e <alloc_block_FF+0x95>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 00                	mov    (%eax),%eax
  802359:	a3 38 41 80 00       	mov    %eax,0x804138
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802371:	a1 44 41 80 00       	mov    0x804144,%eax
  802376:	48                   	dec    %eax
  802377:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80237c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237f:	e9 10 01 00 00       	jmp    802494 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802387:	8b 40 0c             	mov    0xc(%eax),%eax
  80238a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80238d:	0f 86 c6 00 00 00    	jbe    802459 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802393:	a1 48 41 80 00       	mov    0x804148,%eax
  802398:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 50 08             	mov    0x8(%eax),%edx
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ad:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b4:	75 17                	jne    8023cd <alloc_block_FF+0x104>
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	68 44 3f 80 00       	push   $0x803f44
  8023be:	68 9b 00 00 00       	push   $0x9b
  8023c3:	68 9b 3e 80 00       	push   $0x803e9b
  8023c8:	e8 8e de ff ff       	call   80025b <_panic>
  8023cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d0:	8b 00                	mov    (%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 10                	je     8023e6 <alloc_block_FF+0x11d>
  8023d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d9:	8b 00                	mov    (%eax),%eax
  8023db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023de:	8b 52 04             	mov    0x4(%edx),%edx
  8023e1:	89 50 04             	mov    %edx,0x4(%eax)
  8023e4:	eb 0b                	jmp    8023f1 <alloc_block_FF+0x128>
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f4:	8b 40 04             	mov    0x4(%eax),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	74 0f                	je     80240a <alloc_block_FF+0x141>
  8023fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fe:	8b 40 04             	mov    0x4(%eax),%eax
  802401:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802404:	8b 12                	mov    (%edx),%edx
  802406:	89 10                	mov    %edx,(%eax)
  802408:	eb 0a                	jmp    802414 <alloc_block_FF+0x14b>
  80240a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240d:	8b 00                	mov    (%eax),%eax
  80240f:	a3 48 41 80 00       	mov    %eax,0x804148
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802420:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802427:	a1 54 41 80 00       	mov    0x804154,%eax
  80242c:	48                   	dec    %eax
  80242d:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 50 08             	mov    0x8(%eax),%edx
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	01 c2                	add    %eax,%edx
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	2b 45 08             	sub    0x8(%ebp),%eax
  80244c:	89 c2                	mov    %eax,%edx
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802457:	eb 3b                	jmp    802494 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802459:	a1 40 41 80 00       	mov    0x804140,%eax
  80245e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802465:	74 07                	je     80246e <alloc_block_FF+0x1a5>
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 00                	mov    (%eax),%eax
  80246c:	eb 05                	jmp    802473 <alloc_block_FF+0x1aa>
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
  802473:	a3 40 41 80 00       	mov    %eax,0x804140
  802478:	a1 40 41 80 00       	mov    0x804140,%eax
  80247d:	85 c0                	test   %eax,%eax
  80247f:	0f 85 57 fe ff ff    	jne    8022dc <alloc_block_FF+0x13>
  802485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802489:	0f 85 4d fe ff ff    	jne    8022dc <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80248f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80249c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8024a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ab:	e9 df 00 00 00       	jmp    80258f <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b9:	0f 82 c8 00 00 00    	jb     802587 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c8:	0f 85 8a 00 00 00    	jne    802558 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d2:	75 17                	jne    8024eb <alloc_block_BF+0x55>
  8024d4:	83 ec 04             	sub    $0x4,%esp
  8024d7:	68 44 3f 80 00       	push   $0x803f44
  8024dc:	68 b7 00 00 00       	push   $0xb7
  8024e1:	68 9b 3e 80 00       	push   $0x803e9b
  8024e6:	e8 70 dd ff ff       	call   80025b <_panic>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	74 10                	je     802504 <alloc_block_BF+0x6e>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fc:	8b 52 04             	mov    0x4(%edx),%edx
  8024ff:	89 50 04             	mov    %edx,0x4(%eax)
  802502:	eb 0b                	jmp    80250f <alloc_block_BF+0x79>
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	8b 40 04             	mov    0x4(%eax),%eax
  80250a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 04             	mov    0x4(%eax),%eax
  802515:	85 c0                	test   %eax,%eax
  802517:	74 0f                	je     802528 <alloc_block_BF+0x92>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 40 04             	mov    0x4(%eax),%eax
  80251f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802522:	8b 12                	mov    (%edx),%edx
  802524:	89 10                	mov    %edx,(%eax)
  802526:	eb 0a                	jmp    802532 <alloc_block_BF+0x9c>
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	a3 38 41 80 00       	mov    %eax,0x804138
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802545:	a1 44 41 80 00       	mov    0x804144,%eax
  80254a:	48                   	dec    %eax
  80254b:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	e9 4d 01 00 00       	jmp    8026a5 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 40 0c             	mov    0xc(%eax),%eax
  80255e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802561:	76 24                	jbe    802587 <alloc_block_BF+0xf1>
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 0c             	mov    0xc(%eax),%eax
  802569:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80256c:	73 19                	jae    802587 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80256e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 0c             	mov    0xc(%eax),%eax
  80257b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80257e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802581:	8b 40 08             	mov    0x8(%eax),%eax
  802584:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802587:	a1 40 41 80 00       	mov    0x804140,%eax
  80258c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802593:	74 07                	je     80259c <alloc_block_BF+0x106>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	eb 05                	jmp    8025a1 <alloc_block_BF+0x10b>
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a1:	a3 40 41 80 00       	mov    %eax,0x804140
  8025a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	0f 85 fd fe ff ff    	jne    8024b0 <alloc_block_BF+0x1a>
  8025b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b7:	0f 85 f3 fe ff ff    	jne    8024b0 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025c1:	0f 84 d9 00 00 00    	je     8026a0 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025c7:	a1 48 41 80 00       	mov    0x804148,%eax
  8025cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d5:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025db:	8b 55 08             	mov    0x8(%ebp),%edx
  8025de:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025e5:	75 17                	jne    8025fe <alloc_block_BF+0x168>
  8025e7:	83 ec 04             	sub    $0x4,%esp
  8025ea:	68 44 3f 80 00       	push   $0x803f44
  8025ef:	68 c7 00 00 00       	push   $0xc7
  8025f4:	68 9b 3e 80 00       	push   $0x803e9b
  8025f9:	e8 5d dc ff ff       	call   80025b <_panic>
  8025fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	74 10                	je     802617 <alloc_block_BF+0x181>
  802607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260a:	8b 00                	mov    (%eax),%eax
  80260c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80260f:	8b 52 04             	mov    0x4(%edx),%edx
  802612:	89 50 04             	mov    %edx,0x4(%eax)
  802615:	eb 0b                	jmp    802622 <alloc_block_BF+0x18c>
  802617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261a:	8b 40 04             	mov    0x4(%eax),%eax
  80261d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802625:	8b 40 04             	mov    0x4(%eax),%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 0f                	je     80263b <alloc_block_BF+0x1a5>
  80262c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262f:	8b 40 04             	mov    0x4(%eax),%eax
  802632:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802635:	8b 12                	mov    (%edx),%edx
  802637:	89 10                	mov    %edx,(%eax)
  802639:	eb 0a                	jmp    802645 <alloc_block_BF+0x1af>
  80263b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263e:	8b 00                	mov    (%eax),%eax
  802640:	a3 48 41 80 00       	mov    %eax,0x804148
  802645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802648:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802651:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802658:	a1 54 41 80 00       	mov    0x804154,%eax
  80265d:	48                   	dec    %eax
  80265e:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802663:	83 ec 08             	sub    $0x8,%esp
  802666:	ff 75 ec             	pushl  -0x14(%ebp)
  802669:	68 38 41 80 00       	push   $0x804138
  80266e:	e8 71 f9 ff ff       	call   801fe4 <find_block>
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267c:	8b 50 08             	mov    0x8(%eax),%edx
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	01 c2                	add    %eax,%edx
  802684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802687:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80268a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268d:	8b 40 0c             	mov    0xc(%eax),%eax
  802690:	2b 45 08             	sub    0x8(%ebp),%eax
  802693:	89 c2                	mov    %eax,%edx
  802695:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802698:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80269b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269e:	eb 05                	jmp    8026a5 <alloc_block_BF+0x20f>
	}
	return NULL;
  8026a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026ad:	a1 28 40 80 00       	mov    0x804028,%eax
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	0f 85 de 01 00 00    	jne    802898 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026ba:	a1 38 41 80 00       	mov    0x804138,%eax
  8026bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c2:	e9 9e 01 00 00       	jmp    802865 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d0:	0f 82 87 01 00 00    	jb     80285d <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026df:	0f 85 95 00 00 00    	jne    80277a <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e9:	75 17                	jne    802702 <alloc_block_NF+0x5b>
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	68 44 3f 80 00       	push   $0x803f44
  8026f3:	68 e0 00 00 00       	push   $0xe0
  8026f8:	68 9b 3e 80 00       	push   $0x803e9b
  8026fd:	e8 59 db ff ff       	call   80025b <_panic>
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 00                	mov    (%eax),%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	74 10                	je     80271b <alloc_block_NF+0x74>
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802713:	8b 52 04             	mov    0x4(%edx),%edx
  802716:	89 50 04             	mov    %edx,0x4(%eax)
  802719:	eb 0b                	jmp    802726 <alloc_block_NF+0x7f>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	85 c0                	test   %eax,%eax
  80272e:	74 0f                	je     80273f <alloc_block_NF+0x98>
  802730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802733:	8b 40 04             	mov    0x4(%eax),%eax
  802736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802739:	8b 12                	mov    (%edx),%edx
  80273b:	89 10                	mov    %edx,(%eax)
  80273d:	eb 0a                	jmp    802749 <alloc_block_NF+0xa2>
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	8b 00                	mov    (%eax),%eax
  802744:	a3 38 41 80 00       	mov    %eax,0x804138
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275c:	a1 44 41 80 00       	mov    0x804144,%eax
  802761:	48                   	dec    %eax
  802762:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 08             	mov    0x8(%eax),%eax
  80276d:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	e9 f8 04 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 40 0c             	mov    0xc(%eax),%eax
  802780:	3b 45 08             	cmp    0x8(%ebp),%eax
  802783:	0f 86 d4 00 00 00    	jbe    80285d <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802789:	a1 48 41 80 00       	mov    0x804148,%eax
  80278e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 50 08             	mov    0x8(%eax),%edx
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a3:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027aa:	75 17                	jne    8027c3 <alloc_block_NF+0x11c>
  8027ac:	83 ec 04             	sub    $0x4,%esp
  8027af:	68 44 3f 80 00       	push   $0x803f44
  8027b4:	68 e9 00 00 00       	push   $0xe9
  8027b9:	68 9b 3e 80 00       	push   $0x803e9b
  8027be:	e8 98 da ff ff       	call   80025b <_panic>
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 10                	je     8027dc <alloc_block_NF+0x135>
  8027cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d4:	8b 52 04             	mov    0x4(%edx),%edx
  8027d7:	89 50 04             	mov    %edx,0x4(%eax)
  8027da:	eb 0b                	jmp    8027e7 <alloc_block_NF+0x140>
  8027dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 0f                	je     802800 <alloc_block_NF+0x159>
  8027f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fa:	8b 12                	mov    (%edx),%edx
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	eb 0a                	jmp    80280a <alloc_block_NF+0x163>
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	a3 48 41 80 00       	mov    %eax,0x804148
  80280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281d:	a1 54 41 80 00       	mov    0x804154,%eax
  802822:	48                   	dec    %eax
  802823:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282b:	8b 40 08             	mov    0x8(%eax),%eax
  80282e:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 50 08             	mov    0x8(%eax),%edx
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	01 c2                	add    %eax,%edx
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 0c             	mov    0xc(%eax),%eax
  80284a:	2b 45 08             	sub    0x8(%ebp),%eax
  80284d:	89 c2                	mov    %eax,%edx
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	e9 15 04 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80285d:	a1 40 41 80 00       	mov    0x804140,%eax
  802862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802865:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802869:	74 07                	je     802872 <alloc_block_NF+0x1cb>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	eb 05                	jmp    802877 <alloc_block_NF+0x1d0>
  802872:	b8 00 00 00 00       	mov    $0x0,%eax
  802877:	a3 40 41 80 00       	mov    %eax,0x804140
  80287c:	a1 40 41 80 00       	mov    0x804140,%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	0f 85 3e fe ff ff    	jne    8026c7 <alloc_block_NF+0x20>
  802889:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288d:	0f 85 34 fe ff ff    	jne    8026c7 <alloc_block_NF+0x20>
  802893:	e9 d5 03 00 00       	jmp    802c6d <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802898:	a1 38 41 80 00       	mov    0x804138,%eax
  80289d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028a0:	e9 b1 01 00 00       	jmp    802a56 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 50 08             	mov    0x8(%eax),%edx
  8028ab:	a1 28 40 80 00       	mov    0x804028,%eax
  8028b0:	39 c2                	cmp    %eax,%edx
  8028b2:	0f 82 96 01 00 00    	jb     802a4e <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c1:	0f 82 87 01 00 00    	jb     802a4e <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d0:	0f 85 95 00 00 00    	jne    80296b <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028da:	75 17                	jne    8028f3 <alloc_block_NF+0x24c>
  8028dc:	83 ec 04             	sub    $0x4,%esp
  8028df:	68 44 3f 80 00       	push   $0x803f44
  8028e4:	68 fc 00 00 00       	push   $0xfc
  8028e9:	68 9b 3e 80 00       	push   $0x803e9b
  8028ee:	e8 68 d9 ff ff       	call   80025b <_panic>
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	85 c0                	test   %eax,%eax
  8028fa:	74 10                	je     80290c <alloc_block_NF+0x265>
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802904:	8b 52 04             	mov    0x4(%edx),%edx
  802907:	89 50 04             	mov    %edx,0x4(%eax)
  80290a:	eb 0b                	jmp    802917 <alloc_block_NF+0x270>
  80290c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290f:	8b 40 04             	mov    0x4(%eax),%eax
  802912:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 40 04             	mov    0x4(%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	74 0f                	je     802930 <alloc_block_NF+0x289>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 40 04             	mov    0x4(%eax),%eax
  802927:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292a:	8b 12                	mov    (%edx),%edx
  80292c:	89 10                	mov    %edx,(%eax)
  80292e:	eb 0a                	jmp    80293a <alloc_block_NF+0x293>
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 00                	mov    (%eax),%eax
  802935:	a3 38 41 80 00       	mov    %eax,0x804138
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80294d:	a1 44 41 80 00       	mov    0x804144,%eax
  802952:	48                   	dec    %eax
  802953:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295b:	8b 40 08             	mov    0x8(%eax),%eax
  80295e:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	e9 07 03 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 40 0c             	mov    0xc(%eax),%eax
  802971:	3b 45 08             	cmp    0x8(%ebp),%eax
  802974:	0f 86 d4 00 00 00    	jbe    802a4e <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80297a:	a1 48 41 80 00       	mov    0x804148,%eax
  80297f:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 50 08             	mov    0x8(%eax),%edx
  802988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298b:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80298e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802991:	8b 55 08             	mov    0x8(%ebp),%edx
  802994:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802997:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80299b:	75 17                	jne    8029b4 <alloc_block_NF+0x30d>
  80299d:	83 ec 04             	sub    $0x4,%esp
  8029a0:	68 44 3f 80 00       	push   $0x803f44
  8029a5:	68 04 01 00 00       	push   $0x104
  8029aa:	68 9b 3e 80 00       	push   $0x803e9b
  8029af:	e8 a7 d8 ff ff       	call   80025b <_panic>
  8029b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	85 c0                	test   %eax,%eax
  8029bb:	74 10                	je     8029cd <alloc_block_NF+0x326>
  8029bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c0:	8b 00                	mov    (%eax),%eax
  8029c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029c5:	8b 52 04             	mov    0x4(%edx),%edx
  8029c8:	89 50 04             	mov    %edx,0x4(%eax)
  8029cb:	eb 0b                	jmp    8029d8 <alloc_block_NF+0x331>
  8029cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d0:	8b 40 04             	mov    0x4(%eax),%eax
  8029d3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029db:	8b 40 04             	mov    0x4(%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 0f                	je     8029f1 <alloc_block_NF+0x34a>
  8029e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029eb:	8b 12                	mov    (%edx),%edx
  8029ed:	89 10                	mov    %edx,(%eax)
  8029ef:	eb 0a                	jmp    8029fb <alloc_block_NF+0x354>
  8029f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	a3 48 41 80 00       	mov    %eax,0x804148
  8029fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0e:	a1 54 41 80 00       	mov    0x804154,%eax
  802a13:	48                   	dec    %eax
  802a14:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1c:	8b 40 08             	mov    0x8(%eax),%eax
  802a1f:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 50 08             	mov    0x8(%eax),%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	01 c2                	add    %eax,%edx
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a38:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a3e:	89 c2                	mov    %eax,%edx
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a49:	e9 24 02 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a4e:	a1 40 41 80 00       	mov    0x804140,%eax
  802a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5a:	74 07                	je     802a63 <alloc_block_NF+0x3bc>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	eb 05                	jmp    802a68 <alloc_block_NF+0x3c1>
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
  802a68:	a3 40 41 80 00       	mov    %eax,0x804140
  802a6d:	a1 40 41 80 00       	mov    0x804140,%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	0f 85 2b fe ff ff    	jne    8028a5 <alloc_block_NF+0x1fe>
  802a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a7e:	0f 85 21 fe ff ff    	jne    8028a5 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a84:	a1 38 41 80 00       	mov    0x804138,%eax
  802a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8c:	e9 ae 01 00 00       	jmp    802c3f <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 50 08             	mov    0x8(%eax),%edx
  802a97:	a1 28 40 80 00       	mov    0x804028,%eax
  802a9c:	39 c2                	cmp    %eax,%edx
  802a9e:	0f 83 93 01 00 00    	jae    802c37 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 40 0c             	mov    0xc(%eax),%eax
  802aaa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aad:	0f 82 84 01 00 00    	jb     802c37 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abc:	0f 85 95 00 00 00    	jne    802b57 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac6:	75 17                	jne    802adf <alloc_block_NF+0x438>
  802ac8:	83 ec 04             	sub    $0x4,%esp
  802acb:	68 44 3f 80 00       	push   $0x803f44
  802ad0:	68 14 01 00 00       	push   $0x114
  802ad5:	68 9b 3e 80 00       	push   $0x803e9b
  802ada:	e8 7c d7 ff ff       	call   80025b <_panic>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 10                	je     802af8 <alloc_block_NF+0x451>
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af0:	8b 52 04             	mov    0x4(%edx),%edx
  802af3:	89 50 04             	mov    %edx,0x4(%eax)
  802af6:	eb 0b                	jmp    802b03 <alloc_block_NF+0x45c>
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	8b 40 04             	mov    0x4(%eax),%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	74 0f                	je     802b1c <alloc_block_NF+0x475>
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b16:	8b 12                	mov    (%edx),%edx
  802b18:	89 10                	mov    %edx,(%eax)
  802b1a:	eb 0a                	jmp    802b26 <alloc_block_NF+0x47f>
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	a3 38 41 80 00       	mov    %eax,0x804138
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b39:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3e:	48                   	dec    %eax
  802b3f:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 08             	mov    0x8(%eax),%eax
  802b4a:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	e9 1b 01 00 00       	jmp    802c72 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b60:	0f 86 d1 00 00 00    	jbe    802c37 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b66:	a1 48 41 80 00       	mov    0x804148,%eax
  802b6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 50 08             	mov    0x8(%eax),%edx
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b80:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b87:	75 17                	jne    802ba0 <alloc_block_NF+0x4f9>
  802b89:	83 ec 04             	sub    $0x4,%esp
  802b8c:	68 44 3f 80 00       	push   $0x803f44
  802b91:	68 1c 01 00 00       	push   $0x11c
  802b96:	68 9b 3e 80 00       	push   $0x803e9b
  802b9b:	e8 bb d6 ff ff       	call   80025b <_panic>
  802ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba3:	8b 00                	mov    (%eax),%eax
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	74 10                	je     802bb9 <alloc_block_NF+0x512>
  802ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bac:	8b 00                	mov    (%eax),%eax
  802bae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb1:	8b 52 04             	mov    0x4(%edx),%edx
  802bb4:	89 50 04             	mov    %edx,0x4(%eax)
  802bb7:	eb 0b                	jmp    802bc4 <alloc_block_NF+0x51d>
  802bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbc:	8b 40 04             	mov    0x4(%eax),%eax
  802bbf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	74 0f                	je     802bdd <alloc_block_NF+0x536>
  802bce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd1:	8b 40 04             	mov    0x4(%eax),%eax
  802bd4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bd7:	8b 12                	mov    (%edx),%edx
  802bd9:	89 10                	mov    %edx,(%eax)
  802bdb:	eb 0a                	jmp    802be7 <alloc_block_NF+0x540>
  802bdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	a3 48 41 80 00       	mov    %eax,0x804148
  802be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfa:	a1 54 41 80 00       	mov    0x804154,%eax
  802bff:	48                   	dec    %eax
  802c00:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c08:	8b 40 08             	mov    0x8(%eax),%eax
  802c0b:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 50 08             	mov    0x8(%eax),%edx
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	01 c2                	add    %eax,%edx
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 40 0c             	mov    0xc(%eax),%eax
  802c27:	2b 45 08             	sub    0x8(%ebp),%eax
  802c2a:	89 c2                	mov    %eax,%edx
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c35:	eb 3b                	jmp    802c72 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c37:	a1 40 41 80 00       	mov    0x804140,%eax
  802c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c43:	74 07                	je     802c4c <alloc_block_NF+0x5a5>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 00                	mov    (%eax),%eax
  802c4a:	eb 05                	jmp    802c51 <alloc_block_NF+0x5aa>
  802c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c51:	a3 40 41 80 00       	mov    %eax,0x804140
  802c56:	a1 40 41 80 00       	mov    0x804140,%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	0f 85 2e fe ff ff    	jne    802a91 <alloc_block_NF+0x3ea>
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c67:	0f 85 24 fe ff ff    	jne    802a91 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c72:	c9                   	leave  
  802c73:	c3                   	ret    

00802c74 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c74:	55                   	push   %ebp
  802c75:	89 e5                	mov    %esp,%ebp
  802c77:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c7a:	a1 38 41 80 00       	mov    0x804138,%eax
  802c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c82:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c87:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c8a:	a1 38 41 80 00       	mov    0x804138,%eax
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	74 14                	je     802ca7 <insert_sorted_with_merge_freeList+0x33>
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	8b 50 08             	mov    0x8(%eax),%edx
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 40 08             	mov    0x8(%eax),%eax
  802c9f:	39 c2                	cmp    %eax,%edx
  802ca1:	0f 87 9b 01 00 00    	ja     802e42 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802ca7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cab:	75 17                	jne    802cc4 <insert_sorted_with_merge_freeList+0x50>
  802cad:	83 ec 04             	sub    $0x4,%esp
  802cb0:	68 78 3e 80 00       	push   $0x803e78
  802cb5:	68 38 01 00 00       	push   $0x138
  802cba:	68 9b 3e 80 00       	push   $0x803e9b
  802cbf:	e8 97 d5 ff ff       	call   80025b <_panic>
  802cc4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccd:	89 10                	mov    %edx,(%eax)
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 0d                	je     802ce5 <insert_sorted_with_merge_freeList+0x71>
  802cd8:	a1 38 41 80 00       	mov    0x804138,%eax
  802cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce0:	89 50 04             	mov    %edx,0x4(%eax)
  802ce3:	eb 08                	jmp    802ced <insert_sorted_with_merge_freeList+0x79>
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	a3 38 41 80 00       	mov    %eax,0x804138
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cff:	a1 44 41 80 00       	mov    0x804144,%eax
  802d04:	40                   	inc    %eax
  802d05:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d0e:	0f 84 a8 06 00 00    	je     8033bc <insert_sorted_with_merge_freeList+0x748>
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	8b 50 08             	mov    0x8(%eax),%edx
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d20:	01 c2                	add    %eax,%edx
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 40 08             	mov    0x8(%eax),%eax
  802d28:	39 c2                	cmp    %eax,%edx
  802d2a:	0f 85 8c 06 00 00    	jne    8033bc <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 50 0c             	mov    0xc(%eax),%edx
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3c:	01 c2                	add    %eax,%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d48:	75 17                	jne    802d61 <insert_sorted_with_merge_freeList+0xed>
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	68 44 3f 80 00       	push   $0x803f44
  802d52:	68 3c 01 00 00       	push   $0x13c
  802d57:	68 9b 3e 80 00       	push   $0x803e9b
  802d5c:	e8 fa d4 ff ff       	call   80025b <_panic>
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 00                	mov    (%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 10                	je     802d7a <insert_sorted_with_merge_freeList+0x106>
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d72:	8b 52 04             	mov    0x4(%edx),%edx
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	eb 0b                	jmp    802d85 <insert_sorted_with_merge_freeList+0x111>
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	8b 40 04             	mov    0x4(%eax),%eax
  802d80:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d88:	8b 40 04             	mov    0x4(%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0f                	je     802d9e <insert_sorted_with_merge_freeList+0x12a>
  802d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d92:	8b 40 04             	mov    0x4(%eax),%eax
  802d95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d98:	8b 12                	mov    (%edx),%edx
  802d9a:	89 10                	mov    %edx,(%eax)
  802d9c:	eb 0a                	jmp    802da8 <insert_sorted_with_merge_freeList+0x134>
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 00                	mov    (%eax),%eax
  802da3:	a3 38 41 80 00       	mov    %eax,0x804138
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbb:	a1 44 41 80 00       	mov    0x804144,%eax
  802dc0:	48                   	dec    %eax
  802dc1:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802dda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dde:	75 17                	jne    802df7 <insert_sorted_with_merge_freeList+0x183>
  802de0:	83 ec 04             	sub    $0x4,%esp
  802de3:	68 78 3e 80 00       	push   $0x803e78
  802de8:	68 3f 01 00 00       	push   $0x13f
  802ded:	68 9b 3e 80 00       	push   $0x803e9b
  802df2:	e8 64 d4 ff ff       	call   80025b <_panic>
  802df7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 00                	mov    (%eax),%eax
  802e07:	85 c0                	test   %eax,%eax
  802e09:	74 0d                	je     802e18 <insert_sorted_with_merge_freeList+0x1a4>
  802e0b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e13:	89 50 04             	mov    %edx,0x4(%eax)
  802e16:	eb 08                	jmp    802e20 <insert_sorted_with_merge_freeList+0x1ac>
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	a3 48 41 80 00       	mov    %eax,0x804148
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e32:	a1 54 41 80 00       	mov    0x804154,%eax
  802e37:	40                   	inc    %eax
  802e38:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e3d:	e9 7a 05 00 00       	jmp    8033bc <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 50 08             	mov    0x8(%eax),%edx
  802e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4b:	8b 40 08             	mov    0x8(%eax),%eax
  802e4e:	39 c2                	cmp    %eax,%edx
  802e50:	0f 82 14 01 00 00    	jb     802f6a <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e59:	8b 50 08             	mov    0x8(%eax),%edx
  802e5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e62:	01 c2                	add    %eax,%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 40 08             	mov    0x8(%eax),%eax
  802e6a:	39 c2                	cmp    %eax,%edx
  802e6c:	0f 85 90 00 00 00    	jne    802f02 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e75:	8b 50 0c             	mov    0xc(%eax),%edx
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	01 c2                	add    %eax,%edx
  802e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e83:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9e:	75 17                	jne    802eb7 <insert_sorted_with_merge_freeList+0x243>
  802ea0:	83 ec 04             	sub    $0x4,%esp
  802ea3:	68 78 3e 80 00       	push   $0x803e78
  802ea8:	68 49 01 00 00       	push   $0x149
  802ead:	68 9b 3e 80 00       	push   $0x803e9b
  802eb2:	e8 a4 d3 ff ff       	call   80025b <_panic>
  802eb7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	89 10                	mov    %edx,(%eax)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 0d                	je     802ed8 <insert_sorted_with_merge_freeList+0x264>
  802ecb:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed3:	89 50 04             	mov    %edx,0x4(%eax)
  802ed6:	eb 08                	jmp    802ee0 <insert_sorted_with_merge_freeList+0x26c>
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef7:	40                   	inc    %eax
  802ef8:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802efd:	e9 bb 04 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f06:	75 17                	jne    802f1f <insert_sorted_with_merge_freeList+0x2ab>
  802f08:	83 ec 04             	sub    $0x4,%esp
  802f0b:	68 ec 3e 80 00       	push   $0x803eec
  802f10:	68 4c 01 00 00       	push   $0x14c
  802f15:	68 9b 3e 80 00       	push   $0x803e9b
  802f1a:	e8 3c d3 ff ff       	call   80025b <_panic>
  802f1f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	89 50 04             	mov    %edx,0x4(%eax)
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	8b 40 04             	mov    0x4(%eax),%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	74 0c                	je     802f41 <insert_sorted_with_merge_freeList+0x2cd>
  802f35:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3d:	89 10                	mov    %edx,(%eax)
  802f3f:	eb 08                	jmp    802f49 <insert_sorted_with_merge_freeList+0x2d5>
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	a3 38 41 80 00       	mov    %eax,0x804138
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5a:	a1 44 41 80 00       	mov    0x804144,%eax
  802f5f:	40                   	inc    %eax
  802f60:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f65:	e9 53 04 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f6a:	a1 38 41 80 00       	mov    0x804138,%eax
  802f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f72:	e9 15 04 00 00       	jmp    80338c <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	8b 50 08             	mov    0x8(%eax),%edx
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 40 08             	mov    0x8(%eax),%eax
  802f8b:	39 c2                	cmp    %eax,%edx
  802f8d:	0f 86 f1 03 00 00    	jbe    803384 <insert_sorted_with_merge_freeList+0x710>
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9c:	8b 40 08             	mov    0x8(%eax),%eax
  802f9f:	39 c2                	cmp    %eax,%edx
  802fa1:	0f 83 dd 03 00 00    	jae    803384 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 50 08             	mov    0x8(%eax),%edx
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	01 c2                	add    %eax,%edx
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 40 08             	mov    0x8(%eax),%eax
  802fbb:	39 c2                	cmp    %eax,%edx
  802fbd:	0f 85 b9 01 00 00    	jne    80317c <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 50 08             	mov    0x8(%eax),%edx
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802fcf:	01 c2                	add    %eax,%edx
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 40 08             	mov    0x8(%eax),%eax
  802fd7:	39 c2                	cmp    %eax,%edx
  802fd9:	0f 85 0d 01 00 00    	jne    8030ec <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe8:	8b 40 0c             	mov    0xc(%eax),%eax
  802feb:	01 c2                	add    %eax,%edx
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ff3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ff7:	75 17                	jne    803010 <insert_sorted_with_merge_freeList+0x39c>
  802ff9:	83 ec 04             	sub    $0x4,%esp
  802ffc:	68 44 3f 80 00       	push   $0x803f44
  803001:	68 5c 01 00 00       	push   $0x15c
  803006:	68 9b 3e 80 00       	push   $0x803e9b
  80300b:	e8 4b d2 ff ff       	call   80025b <_panic>
  803010:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	85 c0                	test   %eax,%eax
  803017:	74 10                	je     803029 <insert_sorted_with_merge_freeList+0x3b5>
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	8b 00                	mov    (%eax),%eax
  80301e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803021:	8b 52 04             	mov    0x4(%edx),%edx
  803024:	89 50 04             	mov    %edx,0x4(%eax)
  803027:	eb 0b                	jmp    803034 <insert_sorted_with_merge_freeList+0x3c0>
  803029:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	74 0f                	je     80304d <insert_sorted_with_merge_freeList+0x3d9>
  80303e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803041:	8b 40 04             	mov    0x4(%eax),%eax
  803044:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803047:	8b 12                	mov    (%edx),%edx
  803049:	89 10                	mov    %edx,(%eax)
  80304b:	eb 0a                	jmp    803057 <insert_sorted_with_merge_freeList+0x3e3>
  80304d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803050:	8b 00                	mov    (%eax),%eax
  803052:	a3 38 41 80 00       	mov    %eax,0x804138
  803057:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803060:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803063:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306a:	a1 44 41 80 00       	mov    0x804144,%eax
  80306f:	48                   	dec    %eax
  803070:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  803075:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803078:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803089:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80308d:	75 17                	jne    8030a6 <insert_sorted_with_merge_freeList+0x432>
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	68 78 3e 80 00       	push   $0x803e78
  803097:	68 5f 01 00 00       	push   $0x15f
  80309c:	68 9b 3e 80 00       	push   $0x803e9b
  8030a1:	e8 b5 d1 ff ff       	call   80025b <_panic>
  8030a6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 0d                	je     8030c7 <insert_sorted_with_merge_freeList+0x453>
  8030ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8030bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 08                	jmp    8030cf <insert_sorted_with_merge_freeList+0x45b>
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e1:	a1 54 41 80 00       	mov    0x804154,%eax
  8030e6:	40                   	inc    %eax
  8030e7:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  8030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ef:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f8:	01 c2                	add    %eax,%edx
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803114:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803118:	75 17                	jne    803131 <insert_sorted_with_merge_freeList+0x4bd>
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	68 78 3e 80 00       	push   $0x803e78
  803122:	68 64 01 00 00       	push   $0x164
  803127:	68 9b 3e 80 00       	push   $0x803e9b
  80312c:	e8 2a d1 ff ff       	call   80025b <_panic>
  803131:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	89 10                	mov    %edx,(%eax)
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 0d                	je     803152 <insert_sorted_with_merge_freeList+0x4de>
  803145:	a1 48 41 80 00       	mov    0x804148,%eax
  80314a:	8b 55 08             	mov    0x8(%ebp),%edx
  80314d:	89 50 04             	mov    %edx,0x4(%eax)
  803150:	eb 08                	jmp    80315a <insert_sorted_with_merge_freeList+0x4e6>
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	a3 48 41 80 00       	mov    %eax,0x804148
  803162:	8b 45 08             	mov    0x8(%ebp),%eax
  803165:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316c:	a1 54 41 80 00       	mov    0x804154,%eax
  803171:	40                   	inc    %eax
  803172:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803177:	e9 41 02 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	8b 50 08             	mov    0x8(%eax),%edx
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	8b 40 0c             	mov    0xc(%eax),%eax
  803188:	01 c2                	add    %eax,%edx
  80318a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318d:	8b 40 08             	mov    0x8(%eax),%eax
  803190:	39 c2                	cmp    %eax,%edx
  803192:	0f 85 7c 01 00 00    	jne    803314 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803198:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319c:	74 06                	je     8031a4 <insert_sorted_with_merge_freeList+0x530>
  80319e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a2:	75 17                	jne    8031bb <insert_sorted_with_merge_freeList+0x547>
  8031a4:	83 ec 04             	sub    $0x4,%esp
  8031a7:	68 b4 3e 80 00       	push   $0x803eb4
  8031ac:	68 69 01 00 00       	push   $0x169
  8031b1:	68 9b 3e 80 00       	push   $0x803e9b
  8031b6:	e8 a0 d0 ff ff       	call   80025b <_panic>
  8031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031be:	8b 50 04             	mov    0x4(%eax),%edx
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	89 50 04             	mov    %edx,0x4(%eax)
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031cd:	89 10                	mov    %edx,(%eax)
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	74 0d                	je     8031e6 <insert_sorted_with_merge_freeList+0x572>
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	8b 40 04             	mov    0x4(%eax),%eax
  8031df:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e2:	89 10                	mov    %edx,(%eax)
  8031e4:	eb 08                	jmp    8031ee <insert_sorted_with_merge_freeList+0x57a>
  8031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e9:	a3 38 41 80 00       	mov    %eax,0x804138
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f4:	89 50 04             	mov    %edx,0x4(%eax)
  8031f7:	a1 44 41 80 00       	mov    0x804144,%eax
  8031fc:	40                   	inc    %eax
  8031fd:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	8b 50 0c             	mov    0xc(%eax),%edx
  803208:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320b:	8b 40 0c             	mov    0xc(%eax),%eax
  80320e:	01 c2                	add    %eax,%edx
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803216:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321a:	75 17                	jne    803233 <insert_sorted_with_merge_freeList+0x5bf>
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 44 3f 80 00       	push   $0x803f44
  803224:	68 6b 01 00 00       	push   $0x16b
  803229:	68 9b 3e 80 00       	push   $0x803e9b
  80322e:	e8 28 d0 ff ff       	call   80025b <_panic>
  803233:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803236:	8b 00                	mov    (%eax),%eax
  803238:	85 c0                	test   %eax,%eax
  80323a:	74 10                	je     80324c <insert_sorted_with_merge_freeList+0x5d8>
  80323c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323f:	8b 00                	mov    (%eax),%eax
  803241:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803244:	8b 52 04             	mov    0x4(%edx),%edx
  803247:	89 50 04             	mov    %edx,0x4(%eax)
  80324a:	eb 0b                	jmp    803257 <insert_sorted_with_merge_freeList+0x5e3>
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803257:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325a:	8b 40 04             	mov    0x4(%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 0f                	je     803270 <insert_sorted_with_merge_freeList+0x5fc>
  803261:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803264:	8b 40 04             	mov    0x4(%eax),%eax
  803267:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80326a:	8b 12                	mov    (%edx),%edx
  80326c:	89 10                	mov    %edx,(%eax)
  80326e:	eb 0a                	jmp    80327a <insert_sorted_with_merge_freeList+0x606>
  803270:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	a3 38 41 80 00       	mov    %eax,0x804138
  80327a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803283:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803286:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328d:	a1 44 41 80 00       	mov    0x804144,%eax
  803292:	48                   	dec    %eax
  803293:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803298:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032b0:	75 17                	jne    8032c9 <insert_sorted_with_merge_freeList+0x655>
  8032b2:	83 ec 04             	sub    $0x4,%esp
  8032b5:	68 78 3e 80 00       	push   $0x803e78
  8032ba:	68 6e 01 00 00       	push   $0x16e
  8032bf:	68 9b 3e 80 00       	push   $0x803e9b
  8032c4:	e8 92 cf ff ff       	call   80025b <_panic>
  8032c9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8032cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d2:	89 10                	mov    %edx,(%eax)
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 0d                	je     8032ea <insert_sorted_with_merge_freeList+0x676>
  8032dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8032e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e5:	89 50 04             	mov    %edx,0x4(%eax)
  8032e8:	eb 08                	jmp    8032f2 <insert_sorted_with_merge_freeList+0x67e>
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	a3 48 41 80 00       	mov    %eax,0x804148
  8032fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803304:	a1 54 41 80 00       	mov    0x804154,%eax
  803309:	40                   	inc    %eax
  80330a:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80330f:	e9 a9 00 00 00       	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803318:	74 06                	je     803320 <insert_sorted_with_merge_freeList+0x6ac>
  80331a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331e:	75 17                	jne    803337 <insert_sorted_with_merge_freeList+0x6c3>
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	68 10 3f 80 00       	push   $0x803f10
  803328:	68 73 01 00 00       	push   $0x173
  80332d:	68 9b 3e 80 00       	push   $0x803e9b
  803332:	e8 24 cf ff ff       	call   80025b <_panic>
  803337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333a:	8b 10                	mov    (%eax),%edx
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	89 10                	mov    %edx,(%eax)
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	85 c0                	test   %eax,%eax
  803348:	74 0b                	je     803355 <insert_sorted_with_merge_freeList+0x6e1>
  80334a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334d:	8b 00                	mov    (%eax),%eax
  80334f:	8b 55 08             	mov    0x8(%ebp),%edx
  803352:	89 50 04             	mov    %edx,0x4(%eax)
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	8b 55 08             	mov    0x8(%ebp),%edx
  80335b:	89 10                	mov    %edx,(%eax)
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	75 08                	jne    803377 <insert_sorted_with_merge_freeList+0x703>
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803377:	a1 44 41 80 00       	mov    0x804144,%eax
  80337c:	40                   	inc    %eax
  80337d:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803382:	eb 39                	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803384:	a1 40 41 80 00       	mov    0x804140,%eax
  803389:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80338c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803390:	74 07                	je     803399 <insert_sorted_with_merge_freeList+0x725>
  803392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803395:	8b 00                	mov    (%eax),%eax
  803397:	eb 05                	jmp    80339e <insert_sorted_with_merge_freeList+0x72a>
  803399:	b8 00 00 00 00       	mov    $0x0,%eax
  80339e:	a3 40 41 80 00       	mov    %eax,0x804140
  8033a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	0f 85 c7 fb ff ff    	jne    802f77 <insert_sorted_with_merge_freeList+0x303>
  8033b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033b4:	0f 85 bd fb ff ff    	jne    802f77 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033ba:	eb 01                	jmp    8033bd <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033bc:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033bd:	90                   	nop
  8033be:	c9                   	leave  
  8033bf:	c3                   	ret    

008033c0 <__udivdi3>:
  8033c0:	55                   	push   %ebp
  8033c1:	57                   	push   %edi
  8033c2:	56                   	push   %esi
  8033c3:	53                   	push   %ebx
  8033c4:	83 ec 1c             	sub    $0x1c,%esp
  8033c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033d7:	89 ca                	mov    %ecx,%edx
  8033d9:	89 f8                	mov    %edi,%eax
  8033db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033df:	85 f6                	test   %esi,%esi
  8033e1:	75 2d                	jne    803410 <__udivdi3+0x50>
  8033e3:	39 cf                	cmp    %ecx,%edi
  8033e5:	77 65                	ja     80344c <__udivdi3+0x8c>
  8033e7:	89 fd                	mov    %edi,%ebp
  8033e9:	85 ff                	test   %edi,%edi
  8033eb:	75 0b                	jne    8033f8 <__udivdi3+0x38>
  8033ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8033f2:	31 d2                	xor    %edx,%edx
  8033f4:	f7 f7                	div    %edi
  8033f6:	89 c5                	mov    %eax,%ebp
  8033f8:	31 d2                	xor    %edx,%edx
  8033fa:	89 c8                	mov    %ecx,%eax
  8033fc:	f7 f5                	div    %ebp
  8033fe:	89 c1                	mov    %eax,%ecx
  803400:	89 d8                	mov    %ebx,%eax
  803402:	f7 f5                	div    %ebp
  803404:	89 cf                	mov    %ecx,%edi
  803406:	89 fa                	mov    %edi,%edx
  803408:	83 c4 1c             	add    $0x1c,%esp
  80340b:	5b                   	pop    %ebx
  80340c:	5e                   	pop    %esi
  80340d:	5f                   	pop    %edi
  80340e:	5d                   	pop    %ebp
  80340f:	c3                   	ret    
  803410:	39 ce                	cmp    %ecx,%esi
  803412:	77 28                	ja     80343c <__udivdi3+0x7c>
  803414:	0f bd fe             	bsr    %esi,%edi
  803417:	83 f7 1f             	xor    $0x1f,%edi
  80341a:	75 40                	jne    80345c <__udivdi3+0x9c>
  80341c:	39 ce                	cmp    %ecx,%esi
  80341e:	72 0a                	jb     80342a <__udivdi3+0x6a>
  803420:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803424:	0f 87 9e 00 00 00    	ja     8034c8 <__udivdi3+0x108>
  80342a:	b8 01 00 00 00       	mov    $0x1,%eax
  80342f:	89 fa                	mov    %edi,%edx
  803431:	83 c4 1c             	add    $0x1c,%esp
  803434:	5b                   	pop    %ebx
  803435:	5e                   	pop    %esi
  803436:	5f                   	pop    %edi
  803437:	5d                   	pop    %ebp
  803438:	c3                   	ret    
  803439:	8d 76 00             	lea    0x0(%esi),%esi
  80343c:	31 ff                	xor    %edi,%edi
  80343e:	31 c0                	xor    %eax,%eax
  803440:	89 fa                	mov    %edi,%edx
  803442:	83 c4 1c             	add    $0x1c,%esp
  803445:	5b                   	pop    %ebx
  803446:	5e                   	pop    %esi
  803447:	5f                   	pop    %edi
  803448:	5d                   	pop    %ebp
  803449:	c3                   	ret    
  80344a:	66 90                	xchg   %ax,%ax
  80344c:	89 d8                	mov    %ebx,%eax
  80344e:	f7 f7                	div    %edi
  803450:	31 ff                	xor    %edi,%edi
  803452:	89 fa                	mov    %edi,%edx
  803454:	83 c4 1c             	add    $0x1c,%esp
  803457:	5b                   	pop    %ebx
  803458:	5e                   	pop    %esi
  803459:	5f                   	pop    %edi
  80345a:	5d                   	pop    %ebp
  80345b:	c3                   	ret    
  80345c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803461:	89 eb                	mov    %ebp,%ebx
  803463:	29 fb                	sub    %edi,%ebx
  803465:	89 f9                	mov    %edi,%ecx
  803467:	d3 e6                	shl    %cl,%esi
  803469:	89 c5                	mov    %eax,%ebp
  80346b:	88 d9                	mov    %bl,%cl
  80346d:	d3 ed                	shr    %cl,%ebp
  80346f:	89 e9                	mov    %ebp,%ecx
  803471:	09 f1                	or     %esi,%ecx
  803473:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803477:	89 f9                	mov    %edi,%ecx
  803479:	d3 e0                	shl    %cl,%eax
  80347b:	89 c5                	mov    %eax,%ebp
  80347d:	89 d6                	mov    %edx,%esi
  80347f:	88 d9                	mov    %bl,%cl
  803481:	d3 ee                	shr    %cl,%esi
  803483:	89 f9                	mov    %edi,%ecx
  803485:	d3 e2                	shl    %cl,%edx
  803487:	8b 44 24 08          	mov    0x8(%esp),%eax
  80348b:	88 d9                	mov    %bl,%cl
  80348d:	d3 e8                	shr    %cl,%eax
  80348f:	09 c2                	or     %eax,%edx
  803491:	89 d0                	mov    %edx,%eax
  803493:	89 f2                	mov    %esi,%edx
  803495:	f7 74 24 0c          	divl   0xc(%esp)
  803499:	89 d6                	mov    %edx,%esi
  80349b:	89 c3                	mov    %eax,%ebx
  80349d:	f7 e5                	mul    %ebp
  80349f:	39 d6                	cmp    %edx,%esi
  8034a1:	72 19                	jb     8034bc <__udivdi3+0xfc>
  8034a3:	74 0b                	je     8034b0 <__udivdi3+0xf0>
  8034a5:	89 d8                	mov    %ebx,%eax
  8034a7:	31 ff                	xor    %edi,%edi
  8034a9:	e9 58 ff ff ff       	jmp    803406 <__udivdi3+0x46>
  8034ae:	66 90                	xchg   %ax,%ax
  8034b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034b4:	89 f9                	mov    %edi,%ecx
  8034b6:	d3 e2                	shl    %cl,%edx
  8034b8:	39 c2                	cmp    %eax,%edx
  8034ba:	73 e9                	jae    8034a5 <__udivdi3+0xe5>
  8034bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034bf:	31 ff                	xor    %edi,%edi
  8034c1:	e9 40 ff ff ff       	jmp    803406 <__udivdi3+0x46>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	31 c0                	xor    %eax,%eax
  8034ca:	e9 37 ff ff ff       	jmp    803406 <__udivdi3+0x46>
  8034cf:	90                   	nop

008034d0 <__umoddi3>:
  8034d0:	55                   	push   %ebp
  8034d1:	57                   	push   %edi
  8034d2:	56                   	push   %esi
  8034d3:	53                   	push   %ebx
  8034d4:	83 ec 1c             	sub    $0x1c,%esp
  8034d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034ef:	89 f3                	mov    %esi,%ebx
  8034f1:	89 fa                	mov    %edi,%edx
  8034f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034f7:	89 34 24             	mov    %esi,(%esp)
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	75 1a                	jne    803518 <__umoddi3+0x48>
  8034fe:	39 f7                	cmp    %esi,%edi
  803500:	0f 86 a2 00 00 00    	jbe    8035a8 <__umoddi3+0xd8>
  803506:	89 c8                	mov    %ecx,%eax
  803508:	89 f2                	mov    %esi,%edx
  80350a:	f7 f7                	div    %edi
  80350c:	89 d0                	mov    %edx,%eax
  80350e:	31 d2                	xor    %edx,%edx
  803510:	83 c4 1c             	add    $0x1c,%esp
  803513:	5b                   	pop    %ebx
  803514:	5e                   	pop    %esi
  803515:	5f                   	pop    %edi
  803516:	5d                   	pop    %ebp
  803517:	c3                   	ret    
  803518:	39 f0                	cmp    %esi,%eax
  80351a:	0f 87 ac 00 00 00    	ja     8035cc <__umoddi3+0xfc>
  803520:	0f bd e8             	bsr    %eax,%ebp
  803523:	83 f5 1f             	xor    $0x1f,%ebp
  803526:	0f 84 ac 00 00 00    	je     8035d8 <__umoddi3+0x108>
  80352c:	bf 20 00 00 00       	mov    $0x20,%edi
  803531:	29 ef                	sub    %ebp,%edi
  803533:	89 fe                	mov    %edi,%esi
  803535:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803539:	89 e9                	mov    %ebp,%ecx
  80353b:	d3 e0                	shl    %cl,%eax
  80353d:	89 d7                	mov    %edx,%edi
  80353f:	89 f1                	mov    %esi,%ecx
  803541:	d3 ef                	shr    %cl,%edi
  803543:	09 c7                	or     %eax,%edi
  803545:	89 e9                	mov    %ebp,%ecx
  803547:	d3 e2                	shl    %cl,%edx
  803549:	89 14 24             	mov    %edx,(%esp)
  80354c:	89 d8                	mov    %ebx,%eax
  80354e:	d3 e0                	shl    %cl,%eax
  803550:	89 c2                	mov    %eax,%edx
  803552:	8b 44 24 08          	mov    0x8(%esp),%eax
  803556:	d3 e0                	shl    %cl,%eax
  803558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80355c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803560:	89 f1                	mov    %esi,%ecx
  803562:	d3 e8                	shr    %cl,%eax
  803564:	09 d0                	or     %edx,%eax
  803566:	d3 eb                	shr    %cl,%ebx
  803568:	89 da                	mov    %ebx,%edx
  80356a:	f7 f7                	div    %edi
  80356c:	89 d3                	mov    %edx,%ebx
  80356e:	f7 24 24             	mull   (%esp)
  803571:	89 c6                	mov    %eax,%esi
  803573:	89 d1                	mov    %edx,%ecx
  803575:	39 d3                	cmp    %edx,%ebx
  803577:	0f 82 87 00 00 00    	jb     803604 <__umoddi3+0x134>
  80357d:	0f 84 91 00 00 00    	je     803614 <__umoddi3+0x144>
  803583:	8b 54 24 04          	mov    0x4(%esp),%edx
  803587:	29 f2                	sub    %esi,%edx
  803589:	19 cb                	sbb    %ecx,%ebx
  80358b:	89 d8                	mov    %ebx,%eax
  80358d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803591:	d3 e0                	shl    %cl,%eax
  803593:	89 e9                	mov    %ebp,%ecx
  803595:	d3 ea                	shr    %cl,%edx
  803597:	09 d0                	or     %edx,%eax
  803599:	89 e9                	mov    %ebp,%ecx
  80359b:	d3 eb                	shr    %cl,%ebx
  80359d:	89 da                	mov    %ebx,%edx
  80359f:	83 c4 1c             	add    $0x1c,%esp
  8035a2:	5b                   	pop    %ebx
  8035a3:	5e                   	pop    %esi
  8035a4:	5f                   	pop    %edi
  8035a5:	5d                   	pop    %ebp
  8035a6:	c3                   	ret    
  8035a7:	90                   	nop
  8035a8:	89 fd                	mov    %edi,%ebp
  8035aa:	85 ff                	test   %edi,%edi
  8035ac:	75 0b                	jne    8035b9 <__umoddi3+0xe9>
  8035ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8035b3:	31 d2                	xor    %edx,%edx
  8035b5:	f7 f7                	div    %edi
  8035b7:	89 c5                	mov    %eax,%ebp
  8035b9:	89 f0                	mov    %esi,%eax
  8035bb:	31 d2                	xor    %edx,%edx
  8035bd:	f7 f5                	div    %ebp
  8035bf:	89 c8                	mov    %ecx,%eax
  8035c1:	f7 f5                	div    %ebp
  8035c3:	89 d0                	mov    %edx,%eax
  8035c5:	e9 44 ff ff ff       	jmp    80350e <__umoddi3+0x3e>
  8035ca:	66 90                	xchg   %ax,%ax
  8035cc:	89 c8                	mov    %ecx,%eax
  8035ce:	89 f2                	mov    %esi,%edx
  8035d0:	83 c4 1c             	add    $0x1c,%esp
  8035d3:	5b                   	pop    %ebx
  8035d4:	5e                   	pop    %esi
  8035d5:	5f                   	pop    %edi
  8035d6:	5d                   	pop    %ebp
  8035d7:	c3                   	ret    
  8035d8:	3b 04 24             	cmp    (%esp),%eax
  8035db:	72 06                	jb     8035e3 <__umoddi3+0x113>
  8035dd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035e1:	77 0f                	ja     8035f2 <__umoddi3+0x122>
  8035e3:	89 f2                	mov    %esi,%edx
  8035e5:	29 f9                	sub    %edi,%ecx
  8035e7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035eb:	89 14 24             	mov    %edx,(%esp)
  8035ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035f2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035f6:	8b 14 24             	mov    (%esp),%edx
  8035f9:	83 c4 1c             	add    $0x1c,%esp
  8035fc:	5b                   	pop    %ebx
  8035fd:	5e                   	pop    %esi
  8035fe:	5f                   	pop    %edi
  8035ff:	5d                   	pop    %ebp
  803600:	c3                   	ret    
  803601:	8d 76 00             	lea    0x0(%esi),%esi
  803604:	2b 04 24             	sub    (%esp),%eax
  803607:	19 fa                	sbb    %edi,%edx
  803609:	89 d1                	mov    %edx,%ecx
  80360b:	89 c6                	mov    %eax,%esi
  80360d:	e9 71 ff ff ff       	jmp    803583 <__umoddi3+0xb3>
  803612:	66 90                	xchg   %ax,%ax
  803614:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803618:	72 ea                	jb     803604 <__umoddi3+0x134>
  80361a:	89 d9                	mov    %ebx,%ecx
  80361c:	e9 62 ff ff ff       	jmp    803583 <__umoddi3+0xb3>
