
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
  80008c:	68 e0 36 80 00       	push   $0x8036e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 36 80 00       	push   $0x8036fc
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 0b 1b 00 00       	call   801bad <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 1a 37 80 00       	push   $0x80371a
  8000aa:	50                   	push   %eax
  8000ab:	e8 e0 15 00 00       	call   801690 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 f9 17 00 00       	call   8018b4 <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 1c 37 80 00       	push   $0x80371c
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 7b 16 00 00       	call   801754 <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 40 37 80 00       	push   $0x803740
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 c3 17 00 00       	call   8018b4 <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 58 37 80 00       	push   $0x803758
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 fc 36 80 00       	push   $0x8036fc
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 b6 1b 00 00       	call   801cd2 <inctst>

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
  800125:	e8 6a 1a 00 00       	call   801b94 <sys_getenvindex>
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
  800190:	e8 0c 18 00 00       	call   8019a1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 fc 37 80 00       	push   $0x8037fc
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
  8001c0:	68 24 38 80 00       	push   $0x803824
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
  8001f1:	68 4c 38 80 00       	push   $0x80384c
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 a4 38 80 00       	push   $0x8038a4
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 fc 37 80 00       	push   $0x8037fc
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 8c 17 00 00       	call   8019bb <sys_enable_interrupt>

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
  800242:	e8 19 19 00 00       	call   801b60 <sys_destroy_env>
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
  800253:	e8 6e 19 00 00       	call   801bc6 <sys_exit_env>
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
  80027c:	68 b8 38 80 00       	push   $0x8038b8
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 bd 38 80 00       	push   $0x8038bd
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
  8002b9:	68 d9 38 80 00       	push   $0x8038d9
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
  8002e5:	68 dc 38 80 00       	push   $0x8038dc
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 28 39 80 00       	push   $0x803928
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
  8003b7:	68 34 39 80 00       	push   $0x803934
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 28 39 80 00       	push   $0x803928
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
  800427:	68 88 39 80 00       	push   $0x803988
  80042c:	6a 44                	push   $0x44
  80042e:	68 28 39 80 00       	push   $0x803928
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
  800481:	e8 6d 13 00 00       	call   8017f3 <sys_cputs>
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
  8004f8:	e8 f6 12 00 00       	call   8017f3 <sys_cputs>
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
  800542:	e8 5a 14 00 00       	call   8019a1 <sys_disable_interrupt>
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
  800562:	e8 54 14 00 00       	call   8019bb <sys_enable_interrupt>
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
  8005ac:	e8 c7 2e 00 00       	call   803478 <__udivdi3>
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
  8005fc:	e8 87 2f 00 00       	call   803588 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 f4 3b 80 00       	add    $0x803bf4,%eax
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
  800757:	8b 04 85 18 3c 80 00 	mov    0x803c18(,%eax,4),%eax
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
  800838:	8b 34 9d 60 3a 80 00 	mov    0x803a60(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 05 3c 80 00       	push   $0x803c05
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
  80085d:	68 0e 3c 80 00       	push   $0x803c0e
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
  80088a:	be 11 3c 80 00       	mov    $0x803c11,%esi
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
  8012b0:	68 70 3d 80 00       	push   $0x803d70
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
  801380:	e8 b2 05 00 00       	call   801937 <sys_allocate_chunk>
  801385:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801388:	a1 20 41 80 00       	mov    0x804120,%eax
  80138d:	83 ec 0c             	sub    $0xc,%esp
  801390:	50                   	push   %eax
  801391:	e8 27 0c 00 00       	call   801fbd <initialize_MemBlocksList>
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
  8013be:	68 95 3d 80 00       	push   $0x803d95
  8013c3:	6a 33                	push   $0x33
  8013c5:	68 b3 3d 80 00       	push   $0x803db3
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
  80143d:	68 c0 3d 80 00       	push   $0x803dc0
  801442:	6a 34                	push   $0x34
  801444:	68 b3 3d 80 00       	push   $0x803db3
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
  8014d5:	e8 2b 08 00 00       	call   801d05 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	74 11                	je     8014ef <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014de:	83 ec 0c             	sub    $0xc,%esp
  8014e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8014e4:	e8 96 0e 00 00       	call   80237f <alloc_block_FF>
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
  8014fb:	e8 f2 0b 00 00       	call   8020f2 <insert_sorted_allocList>
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
  801515:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	50                   	push   %eax
  80151f:	68 40 40 80 00       	push   $0x804040
  801524:	e8 71 0b 00 00       	call   80209a <find_block>
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80152f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801533:	0f 84 a6 00 00 00    	je     8015df <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153c:	8b 50 0c             	mov    0xc(%eax),%edx
  80153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801542:	8b 40 08             	mov    0x8(%eax),%eax
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	52                   	push   %edx
  801549:	50                   	push   %eax
  80154a:	e8 b0 03 00 00       	call   8018ff <sys_free_user_mem>
  80154f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801556:	75 14                	jne    80156c <free+0x5a>
  801558:	83 ec 04             	sub    $0x4,%esp
  80155b:	68 95 3d 80 00       	push   $0x803d95
  801560:	6a 74                	push   $0x74
  801562:	68 b3 3d 80 00       	push   $0x803db3
  801567:	e8 ef ec ff ff       	call   80025b <_panic>
  80156c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156f:	8b 00                	mov    (%eax),%eax
  801571:	85 c0                	test   %eax,%eax
  801573:	74 10                	je     801585 <free+0x73>
  801575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801578:	8b 00                	mov    (%eax),%eax
  80157a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157d:	8b 52 04             	mov    0x4(%edx),%edx
  801580:	89 50 04             	mov    %edx,0x4(%eax)
  801583:	eb 0b                	jmp    801590 <free+0x7e>
  801585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801588:	8b 40 04             	mov    0x4(%eax),%eax
  80158b:	a3 44 40 80 00       	mov    %eax,0x804044
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	8b 40 04             	mov    0x4(%eax),%eax
  801596:	85 c0                	test   %eax,%eax
  801598:	74 0f                	je     8015a9 <free+0x97>
  80159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159d:	8b 40 04             	mov    0x4(%eax),%eax
  8015a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a3:	8b 12                	mov    (%edx),%edx
  8015a5:	89 10                	mov    %edx,(%eax)
  8015a7:	eb 0a                	jmp    8015b3 <free+0xa1>
  8015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ac:	8b 00                	mov    (%eax),%eax
  8015ae:	a3 40 40 80 00       	mov    %eax,0x804040
  8015b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015cb:	48                   	dec    %eax
  8015cc:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(free_block);
  8015d1:	83 ec 0c             	sub    $0xc,%esp
  8015d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015d7:	e8 4e 17 00 00       	call   802d2a <insert_sorted_with_merge_freeList>
  8015dc:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015df:	90                   	nop
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	83 ec 38             	sub    $0x38,%esp
  8015e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015eb:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ee:	e8 a6 fc ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015f7:	75 0a                	jne    801603 <smalloc+0x21>
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fe:	e9 8b 00 00 00       	jmp    80168e <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801603:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80160a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	01 d0                	add    %edx,%eax
  801612:	48                   	dec    %eax
  801613:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801619:	ba 00 00 00 00       	mov    $0x0,%edx
  80161e:	f7 75 f0             	divl   -0x10(%ebp)
  801621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801624:	29 d0                	sub    %edx,%eax
  801626:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801629:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801630:	e8 d0 06 00 00       	call   801d05 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801635:	85 c0                	test   %eax,%eax
  801637:	74 11                	je     80164a <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801639:	83 ec 0c             	sub    $0xc,%esp
  80163c:	ff 75 e8             	pushl  -0x18(%ebp)
  80163f:	e8 3b 0d 00 00       	call   80237f <alloc_block_FF>
  801644:	83 c4 10             	add    $0x10,%esp
  801647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  80164a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80164e:	74 39                	je     801689 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801653:	8b 40 08             	mov    0x8(%eax),%eax
  801656:	89 c2                	mov    %eax,%edx
  801658:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80165c:	52                   	push   %edx
  80165d:	50                   	push   %eax
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	ff 75 08             	pushl  0x8(%ebp)
  801664:	e8 21 04 00 00       	call   801a8a <sys_createSharedObject>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80166f:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801673:	74 14                	je     801689 <smalloc+0xa7>
  801675:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801679:	74 0e                	je     801689 <smalloc+0xa7>
  80167b:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80167f:	74 08                	je     801689 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801684:	8b 40 08             	mov    0x8(%eax),%eax
  801687:	eb 05                	jmp    80168e <smalloc+0xac>
	}
	return NULL;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801696:	e8 fe fb ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80169b:	83 ec 08             	sub    $0x8,%esp
  80169e:	ff 75 0c             	pushl  0xc(%ebp)
  8016a1:	ff 75 08             	pushl  0x8(%ebp)
  8016a4:	e8 0b 04 00 00       	call   801ab4 <sys_getSizeOfSharedObject>
  8016a9:	83 c4 10             	add    $0x10,%esp
  8016ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8016af:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8016b3:	74 76                	je     80172b <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016b5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c2:	01 d0                	add    %edx,%eax
  8016c4:	48                   	dec    %eax
  8016c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d0:	f7 75 ec             	divl   -0x14(%ebp)
  8016d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d6:	29 d0                	sub    %edx,%eax
  8016d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8016db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016e2:	e8 1e 06 00 00       	call   801d05 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e7:	85 c0                	test   %eax,%eax
  8016e9:	74 11                	je     8016fc <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8016eb:	83 ec 0c             	sub    $0xc,%esp
  8016ee:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016f1:	e8 89 0c 00 00       	call   80237f <alloc_block_FF>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  8016fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801700:	74 29                	je     80172b <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	8b 40 08             	mov    0x8(%eax),%eax
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	50                   	push   %eax
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	e8 ba 03 00 00       	call   801ad1 <sys_getSharedObject>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80171d:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801721:	74 08                	je     80172b <sget+0x9b>
				return (void *)mem_block->sva;
  801723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801726:	8b 40 08             	mov    0x8(%eax),%eax
  801729:	eb 05                	jmp    801730 <sget+0xa0>
		}
	}
	return NULL;
  80172b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801730:	c9                   	leave  
  801731:	c3                   	ret    

00801732 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801732:	55                   	push   %ebp
  801733:	89 e5                	mov    %esp,%ebp
  801735:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801738:	e8 5c fb ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	68 e4 3d 80 00       	push   $0x803de4
  801745:	68 f7 00 00 00       	push   $0xf7
  80174a:	68 b3 3d 80 00       	push   $0x803db3
  80174f:	e8 07 eb ff ff       	call   80025b <_panic>

00801754 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80175a:	83 ec 04             	sub    $0x4,%esp
  80175d:	68 0c 3e 80 00       	push   $0x803e0c
  801762:	68 0b 01 00 00       	push   $0x10b
  801767:	68 b3 3d 80 00       	push   $0x803db3
  80176c:	e8 ea ea ff ff       	call   80025b <_panic>

00801771 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	68 30 3e 80 00       	push   $0x803e30
  80177f:	68 16 01 00 00       	push   $0x116
  801784:	68 b3 3d 80 00       	push   $0x803db3
  801789:	e8 cd ea ff ff       	call   80025b <_panic>

0080178e <shrink>:

}
void shrink(uint32 newSize)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 30 3e 80 00       	push   $0x803e30
  80179c:	68 1b 01 00 00       	push   $0x11b
  8017a1:	68 b3 3d 80 00       	push   $0x803db3
  8017a6:	e8 b0 ea ff ff       	call   80025b <_panic>

008017ab <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b1:	83 ec 04             	sub    $0x4,%esp
  8017b4:	68 30 3e 80 00       	push   $0x803e30
  8017b9:	68 20 01 00 00       	push   $0x120
  8017be:	68 b3 3d 80 00       	push   $0x803db3
  8017c3:	e8 93 ea ff ff       	call   80025b <_panic>

008017c8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	57                   	push   %edi
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
  8017ce:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017da:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017dd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017e0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017e3:	cd 30                	int    $0x30
  8017e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	5b                   	pop    %ebx
  8017ef:	5e                   	pop    %esi
  8017f0:	5f                   	pop    %edi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 04             	sub    $0x4,%esp
  8017f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	52                   	push   %edx
  80180b:	ff 75 0c             	pushl  0xc(%ebp)
  80180e:	50                   	push   %eax
  80180f:	6a 00                	push   $0x0
  801811:	e8 b2 ff ff ff       	call   8017c8 <syscall>
  801816:	83 c4 18             	add    $0x18,%esp
}
  801819:	90                   	nop
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_cgetc>:

int
sys_cgetc(void)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80181f:	6a 00                	push   $0x0
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 01                	push   $0x1
  80182b:	e8 98 ff ff ff       	call   8017c8 <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801838:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	52                   	push   %edx
  801845:	50                   	push   %eax
  801846:	6a 05                	push   $0x5
  801848:	e8 7b ff ff ff       	call   8017c8 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	56                   	push   %esi
  801856:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801857:	8b 75 18             	mov    0x18(%ebp),%esi
  80185a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80185d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801860:	8b 55 0c             	mov    0xc(%ebp),%edx
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	56                   	push   %esi
  801867:	53                   	push   %ebx
  801868:	51                   	push   %ecx
  801869:	52                   	push   %edx
  80186a:	50                   	push   %eax
  80186b:	6a 06                	push   $0x6
  80186d:	e8 56 ff ff ff       	call   8017c8 <syscall>
  801872:	83 c4 18             	add    $0x18,%esp
}
  801875:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    

0080187c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80187f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	52                   	push   %edx
  80188c:	50                   	push   %eax
  80188d:	6a 07                	push   $0x7
  80188f:	e8 34 ff ff ff       	call   8017c8 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	6a 08                	push   $0x8
  8018aa:	e8 19 ff ff ff       	call   8017c8 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 09                	push   $0x9
  8018c3:	e8 00 ff ff ff       	call   8017c8 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 0a                	push   $0xa
  8018dc:	e8 e7 fe ff ff       	call   8017c8 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 0b                	push   $0xb
  8018f5:	e8 ce fe ff ff       	call   8017c8 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	ff 75 08             	pushl  0x8(%ebp)
  80190e:	6a 0f                	push   $0xf
  801910:	e8 b3 fe ff ff       	call   8017c8 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
	return;
  801918:	90                   	nop
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	ff 75 08             	pushl  0x8(%ebp)
  80192a:	6a 10                	push   $0x10
  80192c:	e8 97 fe ff ff       	call   8017c8 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
	return ;
  801934:	90                   	nop
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	ff 75 10             	pushl  0x10(%ebp)
  801941:	ff 75 0c             	pushl  0xc(%ebp)
  801944:	ff 75 08             	pushl  0x8(%ebp)
  801947:	6a 11                	push   $0x11
  801949:	e8 7a fe ff ff       	call   8017c8 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
	return ;
  801951:	90                   	nop
}
  801952:	c9                   	leave  
  801953:	c3                   	ret    

00801954 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 0c                	push   $0xc
  801963:	e8 60 fe ff ff       	call   8017c8 <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	6a 0d                	push   $0xd
  80197d:	e8 46 fe ff ff       	call   8017c8 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 0e                	push   $0xe
  801996:	e8 2d fe ff ff       	call   8017c8 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	90                   	nop
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 13                	push   $0x13
  8019b0:	e8 13 fe ff ff       	call   8017c8 <syscall>
  8019b5:	83 c4 18             	add    $0x18,%esp
}
  8019b8:	90                   	nop
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 14                	push   $0x14
  8019ca:	e8 f9 fd ff ff       	call   8017c8 <syscall>
  8019cf:	83 c4 18             	add    $0x18,%esp
}
  8019d2:	90                   	nop
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 04             	sub    $0x4,%esp
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019e1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	50                   	push   %eax
  8019ee:	6a 15                	push   $0x15
  8019f0:	e8 d3 fd ff ff       	call   8017c8 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
}
  8019f8:	90                   	nop
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 16                	push   $0x16
  801a0a:	e8 b9 fd ff ff       	call   8017c8 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	90                   	nop
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	ff 75 0c             	pushl  0xc(%ebp)
  801a24:	50                   	push   %eax
  801a25:	6a 17                	push   $0x17
  801a27:	e8 9c fd ff ff       	call   8017c8 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 1a                	push   $0x1a
  801a44:	e8 7f fd ff ff       	call   8017c8 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	52                   	push   %edx
  801a5e:	50                   	push   %eax
  801a5f:	6a 18                	push   $0x18
  801a61:	e8 62 fd ff ff       	call   8017c8 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	52                   	push   %edx
  801a7c:	50                   	push   %eax
  801a7d:	6a 19                	push   $0x19
  801a7f:	e8 44 fd ff ff       	call   8017c8 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	90                   	nop
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	8b 45 10             	mov    0x10(%ebp),%eax
  801a93:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a96:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a99:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	51                   	push   %ecx
  801aa3:	52                   	push   %edx
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	50                   	push   %eax
  801aa8:	6a 1b                	push   $0x1b
  801aaa:	e8 19 fd ff ff       	call   8017c8 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 1c                	push   $0x1c
  801ac7:	e8 fc fc ff ff       	call   8017c8 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ad4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ad7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	51                   	push   %ecx
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 1d                	push   $0x1d
  801ae6:	e8 dd fc ff ff       	call   8017c8 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 1e                	push   $0x1e
  801b03:	e8 c0 fc ff ff       	call   8017c8 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 1f                	push   $0x1f
  801b1c:	e8 a7 fc ff ff       	call   8017c8 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	6a 00                	push   $0x0
  801b2e:	ff 75 14             	pushl  0x14(%ebp)
  801b31:	ff 75 10             	pushl  0x10(%ebp)
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	50                   	push   %eax
  801b38:	6a 20                	push   $0x20
  801b3a:	e8 89 fc ff ff       	call   8017c8 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	50                   	push   %eax
  801b53:	6a 21                	push   $0x21
  801b55:	e8 6e fc ff ff       	call   8017c8 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	90                   	nop
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	50                   	push   %eax
  801b6f:	6a 22                	push   $0x22
  801b71:	e8 52 fc ff ff       	call   8017c8 <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 02                	push   $0x2
  801b8a:	e8 39 fc ff ff       	call   8017c8 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 03                	push   $0x3
  801ba3:	e8 20 fc ff ff       	call   8017c8 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 04                	push   $0x4
  801bbc:	e8 07 fc ff ff       	call   8017c8 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_exit_env>:


void sys_exit_env(void)
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 23                	push   $0x23
  801bd5:	e8 ee fb ff ff       	call   8017c8 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	90                   	nop
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801be6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be9:	8d 50 04             	lea    0x4(%eax),%edx
  801bec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	52                   	push   %edx
  801bf6:	50                   	push   %eax
  801bf7:	6a 24                	push   $0x24
  801bf9:	e8 ca fb ff ff       	call   8017c8 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
	return result;
  801c01:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c0a:	89 01                	mov    %eax,(%ecx)
  801c0c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	c9                   	leave  
  801c13:	c2 04 00             	ret    $0x4

00801c16 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 10             	pushl  0x10(%ebp)
  801c20:	ff 75 0c             	pushl  0xc(%ebp)
  801c23:	ff 75 08             	pushl  0x8(%ebp)
  801c26:	6a 12                	push   $0x12
  801c28:	e8 9b fb ff ff       	call   8017c8 <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c30:	90                   	nop
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 25                	push   $0x25
  801c42:	e8 81 fb ff ff       	call   8017c8 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
  801c4f:	83 ec 04             	sub    $0x4,%esp
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c58:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	50                   	push   %eax
  801c65:	6a 26                	push   $0x26
  801c67:	e8 5c fb ff ff       	call   8017c8 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6f:	90                   	nop
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <rsttst>:
void rsttst()
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 28                	push   $0x28
  801c81:	e8 42 fb ff ff       	call   8017c8 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
	return ;
  801c89:	90                   	nop
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	83 ec 04             	sub    $0x4,%esp
  801c92:	8b 45 14             	mov    0x14(%ebp),%eax
  801c95:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c98:	8b 55 18             	mov    0x18(%ebp),%edx
  801c9b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c9f:	52                   	push   %edx
  801ca0:	50                   	push   %eax
  801ca1:	ff 75 10             	pushl  0x10(%ebp)
  801ca4:	ff 75 0c             	pushl  0xc(%ebp)
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	6a 27                	push   $0x27
  801cac:	e8 17 fb ff ff       	call   8017c8 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb4:	90                   	nop
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <chktst>:
void chktst(uint32 n)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	ff 75 08             	pushl  0x8(%ebp)
  801cc5:	6a 29                	push   $0x29
  801cc7:	e8 fc fa ff ff       	call   8017c8 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccf:	90                   	nop
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <inctst>:

void inctst()
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 2a                	push   $0x2a
  801ce1:	e8 e2 fa ff ff       	call   8017c8 <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce9:	90                   	nop
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <gettst>:
uint32 gettst()
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 2b                	push   $0x2b
  801cfb:	e8 c8 fa ff ff       	call   8017c8 <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 2c                	push   $0x2c
  801d17:	e8 ac fa ff ff       	call   8017c8 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
  801d1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d22:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d26:	75 07                	jne    801d2f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d28:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2d:	eb 05                	jmp    801d34 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 2c                	push   $0x2c
  801d48:	e8 7b fa ff ff       	call   8017c8 <syscall>
  801d4d:	83 c4 18             	add    $0x18,%esp
  801d50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d53:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d57:	75 07                	jne    801d60 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d59:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5e:	eb 05                	jmp    801d65 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d65:	c9                   	leave  
  801d66:	c3                   	ret    

00801d67 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 2c                	push   $0x2c
  801d79:	e8 4a fa ff ff       	call   8017c8 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
  801d81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d84:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d88:	75 07                	jne    801d91 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	eb 05                	jmp    801d96 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 2c                	push   $0x2c
  801daa:	e8 19 fa ff ff       	call   8017c8 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
  801db2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801db5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801db9:	75 07                	jne    801dc2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc0:	eb 05                	jmp    801dc7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	ff 75 08             	pushl  0x8(%ebp)
  801dd7:	6a 2d                	push   $0x2d
  801dd9:	e8 ea f9 ff ff       	call   8017c8 <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
	return ;
  801de1:	90                   	nop
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801de8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801deb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	6a 00                	push   $0x0
  801df6:	53                   	push   %ebx
  801df7:	51                   	push   %ecx
  801df8:	52                   	push   %edx
  801df9:	50                   	push   %eax
  801dfa:	6a 2e                	push   $0x2e
  801dfc:	e8 c7 f9 ff ff       	call   8017c8 <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
}
  801e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	52                   	push   %edx
  801e19:	50                   	push   %eax
  801e1a:	6a 2f                	push   $0x2f
  801e1c:	e8 a7 f9 ff ff       	call   8017c8 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	68 40 3e 80 00       	push   $0x803e40
  801e34:	e8 d6 e6 ff ff       	call   80050f <cprintf>
  801e39:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e3c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	68 6c 3e 80 00       	push   $0x803e6c
  801e4b:	e8 bf e6 ff ff       	call   80050f <cprintf>
  801e50:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e53:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e57:	a1 38 41 80 00       	mov    0x804138,%eax
  801e5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e5f:	eb 56                	jmp    801eb7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e65:	74 1c                	je     801e83 <print_mem_block_lists+0x5d>
  801e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6a:	8b 50 08             	mov    0x8(%eax),%edx
  801e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e70:	8b 48 08             	mov    0x8(%eax),%ecx
  801e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e76:	8b 40 0c             	mov    0xc(%eax),%eax
  801e79:	01 c8                	add    %ecx,%eax
  801e7b:	39 c2                	cmp    %eax,%edx
  801e7d:	73 04                	jae    801e83 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e7f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e86:	8b 50 08             	mov    0x8(%eax),%edx
  801e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8f:	01 c2                	add    %eax,%edx
  801e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e94:	8b 40 08             	mov    0x8(%eax),%eax
  801e97:	83 ec 04             	sub    $0x4,%esp
  801e9a:	52                   	push   %edx
  801e9b:	50                   	push   %eax
  801e9c:	68 81 3e 80 00       	push   $0x803e81
  801ea1:	e8 69 e6 ff ff       	call   80050f <cprintf>
  801ea6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eaf:	a1 40 41 80 00       	mov    0x804140,%eax
  801eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebb:	74 07                	je     801ec4 <print_mem_block_lists+0x9e>
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	8b 00                	mov    (%eax),%eax
  801ec2:	eb 05                	jmp    801ec9 <print_mem_block_lists+0xa3>
  801ec4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec9:	a3 40 41 80 00       	mov    %eax,0x804140
  801ece:	a1 40 41 80 00       	mov    0x804140,%eax
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	75 8a                	jne    801e61 <print_mem_block_lists+0x3b>
  801ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801edb:	75 84                	jne    801e61 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801edd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ee1:	75 10                	jne    801ef3 <print_mem_block_lists+0xcd>
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	68 90 3e 80 00       	push   $0x803e90
  801eeb:	e8 1f e6 ff ff       	call   80050f <cprintf>
  801ef0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ef3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	68 b4 3e 80 00       	push   $0x803eb4
  801f02:	e8 08 e6 ff ff       	call   80050f <cprintf>
  801f07:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f0a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f0e:	a1 40 40 80 00       	mov    0x804040,%eax
  801f13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f16:	eb 56                	jmp    801f6e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f1c:	74 1c                	je     801f3a <print_mem_block_lists+0x114>
  801f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f21:	8b 50 08             	mov    0x8(%eax),%edx
  801f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f27:	8b 48 08             	mov    0x8(%eax),%ecx
  801f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f30:	01 c8                	add    %ecx,%eax
  801f32:	39 c2                	cmp    %eax,%edx
  801f34:	73 04                	jae    801f3a <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f36:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	8b 50 08             	mov    0x8(%eax),%edx
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	8b 40 0c             	mov    0xc(%eax),%eax
  801f46:	01 c2                	add    %eax,%edx
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	8b 40 08             	mov    0x8(%eax),%eax
  801f4e:	83 ec 04             	sub    $0x4,%esp
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	68 81 3e 80 00       	push   $0x803e81
  801f58:	e8 b2 e5 ff ff       	call   80050f <cprintf>
  801f5d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f66:	a1 48 40 80 00       	mov    0x804048,%eax
  801f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f72:	74 07                	je     801f7b <print_mem_block_lists+0x155>
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 00                	mov    (%eax),%eax
  801f79:	eb 05                	jmp    801f80 <print_mem_block_lists+0x15a>
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	a3 48 40 80 00       	mov    %eax,0x804048
  801f85:	a1 48 40 80 00       	mov    0x804048,%eax
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	75 8a                	jne    801f18 <print_mem_block_lists+0xf2>
  801f8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f92:	75 84                	jne    801f18 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f94:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f98:	75 10                	jne    801faa <print_mem_block_lists+0x184>
  801f9a:	83 ec 0c             	sub    $0xc,%esp
  801f9d:	68 cc 3e 80 00       	push   $0x803ecc
  801fa2:	e8 68 e5 ff ff       	call   80050f <cprintf>
  801fa7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	68 40 3e 80 00       	push   $0x803e40
  801fb2:	e8 58 e5 ff ff       	call   80050f <cprintf>
  801fb7:	83 c4 10             	add    $0x10,%esp

}
  801fba:	90                   	nop
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fc3:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fca:	00 00 00 
  801fcd:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fd4:	00 00 00 
  801fd7:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fde:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fe1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fe8:	e9 9e 00 00 00       	jmp    80208b <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fed:	a1 50 40 80 00       	mov    0x804050,%eax
  801ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff5:	c1 e2 04             	shl    $0x4,%edx
  801ff8:	01 d0                	add    %edx,%eax
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	75 14                	jne    802012 <initialize_MemBlocksList+0x55>
  801ffe:	83 ec 04             	sub    $0x4,%esp
  802001:	68 f4 3e 80 00       	push   $0x803ef4
  802006:	6a 46                	push   $0x46
  802008:	68 17 3f 80 00       	push   $0x803f17
  80200d:	e8 49 e2 ff ff       	call   80025b <_panic>
  802012:	a1 50 40 80 00       	mov    0x804050,%eax
  802017:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201a:	c1 e2 04             	shl    $0x4,%edx
  80201d:	01 d0                	add    %edx,%eax
  80201f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802025:	89 10                	mov    %edx,(%eax)
  802027:	8b 00                	mov    (%eax),%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	74 18                	je     802045 <initialize_MemBlocksList+0x88>
  80202d:	a1 48 41 80 00       	mov    0x804148,%eax
  802032:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802038:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80203b:	c1 e1 04             	shl    $0x4,%ecx
  80203e:	01 ca                	add    %ecx,%edx
  802040:	89 50 04             	mov    %edx,0x4(%eax)
  802043:	eb 12                	jmp    802057 <initialize_MemBlocksList+0x9a>
  802045:	a1 50 40 80 00       	mov    0x804050,%eax
  80204a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204d:	c1 e2 04             	shl    $0x4,%edx
  802050:	01 d0                	add    %edx,%eax
  802052:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802057:	a1 50 40 80 00       	mov    0x804050,%eax
  80205c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205f:	c1 e2 04             	shl    $0x4,%edx
  802062:	01 d0                	add    %edx,%eax
  802064:	a3 48 41 80 00       	mov    %eax,0x804148
  802069:	a1 50 40 80 00       	mov    0x804050,%eax
  80206e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802071:	c1 e2 04             	shl    $0x4,%edx
  802074:	01 d0                	add    %edx,%eax
  802076:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80207d:	a1 54 41 80 00       	mov    0x804154,%eax
  802082:	40                   	inc    %eax
  802083:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802088:	ff 45 f4             	incl   -0xc(%ebp)
  80208b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802091:	0f 82 56 ff ff ff    	jb     801fed <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802097:	90                   	nop
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	8b 00                	mov    (%eax),%eax
  8020a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020a8:	eb 19                	jmp    8020c3 <find_block+0x29>
	{
		if(va==point->sva)
  8020aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ad:	8b 40 08             	mov    0x8(%eax),%eax
  8020b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020b3:	75 05                	jne    8020ba <find_block+0x20>
		   return point;
  8020b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b8:	eb 36                	jmp    8020f0 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8b 40 08             	mov    0x8(%eax),%eax
  8020c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c7:	74 07                	je     8020d0 <find_block+0x36>
  8020c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cc:	8b 00                	mov    (%eax),%eax
  8020ce:	eb 05                	jmp    8020d5 <find_block+0x3b>
  8020d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d8:	89 42 08             	mov    %eax,0x8(%edx)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	8b 40 08             	mov    0x8(%eax),%eax
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	75 c5                	jne    8020aa <find_block+0x10>
  8020e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e9:	75 bf                	jne    8020aa <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020f8:	a1 40 40 80 00       	mov    0x804040,%eax
  8020fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802100:	a1 44 40 80 00       	mov    0x804044,%eax
  802105:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80210e:	74 24                	je     802134 <insert_sorted_allocList+0x42>
  802110:	8b 45 08             	mov    0x8(%ebp),%eax
  802113:	8b 50 08             	mov    0x8(%eax),%edx
  802116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802119:	8b 40 08             	mov    0x8(%eax),%eax
  80211c:	39 c2                	cmp    %eax,%edx
  80211e:	76 14                	jbe    802134 <insert_sorted_allocList+0x42>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	8b 50 08             	mov    0x8(%eax),%edx
  802126:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802129:	8b 40 08             	mov    0x8(%eax),%eax
  80212c:	39 c2                	cmp    %eax,%edx
  80212e:	0f 82 60 01 00 00    	jb     802294 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802134:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802138:	75 65                	jne    80219f <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80213a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80213e:	75 14                	jne    802154 <insert_sorted_allocList+0x62>
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 f4 3e 80 00       	push   $0x803ef4
  802148:	6a 6b                	push   $0x6b
  80214a:	68 17 3f 80 00       	push   $0x803f17
  80214f:	e8 07 e1 ff ff       	call   80025b <_panic>
  802154:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	89 10                	mov    %edx,(%eax)
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8b 00                	mov    (%eax),%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	74 0d                	je     802175 <insert_sorted_allocList+0x83>
  802168:	a1 40 40 80 00       	mov    0x804040,%eax
  80216d:	8b 55 08             	mov    0x8(%ebp),%edx
  802170:	89 50 04             	mov    %edx,0x4(%eax)
  802173:	eb 08                	jmp    80217d <insert_sorted_allocList+0x8b>
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	a3 44 40 80 00       	mov    %eax,0x804044
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	a3 40 40 80 00       	mov    %eax,0x804040
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802194:	40                   	inc    %eax
  802195:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80219a:	e9 dc 01 00 00       	jmp    80237b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	8b 50 08             	mov    0x8(%eax),%edx
  8021a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a8:	8b 40 08             	mov    0x8(%eax),%eax
  8021ab:	39 c2                	cmp    %eax,%edx
  8021ad:	77 6c                	ja     80221b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021b3:	74 06                	je     8021bb <insert_sorted_allocList+0xc9>
  8021b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b9:	75 14                	jne    8021cf <insert_sorted_allocList+0xdd>
  8021bb:	83 ec 04             	sub    $0x4,%esp
  8021be:	68 30 3f 80 00       	push   $0x803f30
  8021c3:	6a 6f                	push   $0x6f
  8021c5:	68 17 3f 80 00       	push   $0x803f17
  8021ca:	e8 8c e0 ff ff       	call   80025b <_panic>
  8021cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d2:	8b 50 04             	mov    0x4(%eax),%edx
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	89 50 04             	mov    %edx,0x4(%eax)
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021e1:	89 10                	mov    %edx,(%eax)
  8021e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e6:	8b 40 04             	mov    0x4(%eax),%eax
  8021e9:	85 c0                	test   %eax,%eax
  8021eb:	74 0d                	je     8021fa <insert_sorted_allocList+0x108>
  8021ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f0:	8b 40 04             	mov    0x4(%eax),%eax
  8021f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f6:	89 10                	mov    %edx,(%eax)
  8021f8:	eb 08                	jmp    802202 <insert_sorted_allocList+0x110>
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	a3 40 40 80 00       	mov    %eax,0x804040
  802202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802205:	8b 55 08             	mov    0x8(%ebp),%edx
  802208:	89 50 04             	mov    %edx,0x4(%eax)
  80220b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802210:	40                   	inc    %eax
  802211:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802216:	e9 60 01 00 00       	jmp    80237b <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	8b 50 08             	mov    0x8(%eax),%edx
  802221:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802224:	8b 40 08             	mov    0x8(%eax),%eax
  802227:	39 c2                	cmp    %eax,%edx
  802229:	0f 82 4c 01 00 00    	jb     80237b <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80222f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802233:	75 14                	jne    802249 <insert_sorted_allocList+0x157>
  802235:	83 ec 04             	sub    $0x4,%esp
  802238:	68 68 3f 80 00       	push   $0x803f68
  80223d:	6a 73                	push   $0x73
  80223f:	68 17 3f 80 00       	push   $0x803f17
  802244:	e8 12 e0 ff ff       	call   80025b <_panic>
  802249:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	89 50 04             	mov    %edx,0x4(%eax)
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	8b 40 04             	mov    0x4(%eax),%eax
  80225b:	85 c0                	test   %eax,%eax
  80225d:	74 0c                	je     80226b <insert_sorted_allocList+0x179>
  80225f:	a1 44 40 80 00       	mov    0x804044,%eax
  802264:	8b 55 08             	mov    0x8(%ebp),%edx
  802267:	89 10                	mov    %edx,(%eax)
  802269:	eb 08                	jmp    802273 <insert_sorted_allocList+0x181>
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	a3 40 40 80 00       	mov    %eax,0x804040
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	a3 44 40 80 00       	mov    %eax,0x804044
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802284:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802289:	40                   	inc    %eax
  80228a:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80228f:	e9 e7 00 00 00       	jmp    80237b <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802297:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80229a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022a1:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a9:	e9 9d 00 00 00       	jmp    80234b <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b1:	8b 00                	mov    (%eax),%eax
  8022b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	8b 50 08             	mov    0x8(%eax),%edx
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	8b 40 08             	mov    0x8(%eax),%eax
  8022c2:	39 c2                	cmp    %eax,%edx
  8022c4:	76 7d                	jbe    802343 <insert_sorted_allocList+0x251>
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 50 08             	mov    0x8(%eax),%edx
  8022cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022cf:	8b 40 08             	mov    0x8(%eax),%eax
  8022d2:	39 c2                	cmp    %eax,%edx
  8022d4:	73 6d                	jae    802343 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022da:	74 06                	je     8022e2 <insert_sorted_allocList+0x1f0>
  8022dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e0:	75 14                	jne    8022f6 <insert_sorted_allocList+0x204>
  8022e2:	83 ec 04             	sub    $0x4,%esp
  8022e5:	68 8c 3f 80 00       	push   $0x803f8c
  8022ea:	6a 7f                	push   $0x7f
  8022ec:	68 17 3f 80 00       	push   $0x803f17
  8022f1:	e8 65 df ff ff       	call   80025b <_panic>
  8022f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f9:	8b 10                	mov    (%eax),%edx
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	89 10                	mov    %edx,(%eax)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 00                	mov    (%eax),%eax
  802305:	85 c0                	test   %eax,%eax
  802307:	74 0b                	je     802314 <insert_sorted_allocList+0x222>
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	8b 55 08             	mov    0x8(%ebp),%edx
  802311:	89 50 04             	mov    %edx,0x4(%eax)
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 55 08             	mov    0x8(%ebp),%edx
  80231a:	89 10                	mov    %edx,(%eax)
  80231c:	8b 45 08             	mov    0x8(%ebp),%eax
  80231f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802322:	89 50 04             	mov    %edx,0x4(%eax)
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	85 c0                	test   %eax,%eax
  80232c:	75 08                	jne    802336 <insert_sorted_allocList+0x244>
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	a3 44 40 80 00       	mov    %eax,0x804044
  802336:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80233b:	40                   	inc    %eax
  80233c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802341:	eb 39                	jmp    80237c <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802343:	a1 48 40 80 00       	mov    0x804048,%eax
  802348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234f:	74 07                	je     802358 <insert_sorted_allocList+0x266>
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	eb 05                	jmp    80235d <insert_sorted_allocList+0x26b>
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
  80235d:	a3 48 40 80 00       	mov    %eax,0x804048
  802362:	a1 48 40 80 00       	mov    0x804048,%eax
  802367:	85 c0                	test   %eax,%eax
  802369:	0f 85 3f ff ff ff    	jne    8022ae <insert_sorted_allocList+0x1bc>
  80236f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802373:	0f 85 35 ff ff ff    	jne    8022ae <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802379:	eb 01                	jmp    80237c <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80237b:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80237c:	90                   	nop
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802385:	a1 38 41 80 00       	mov    0x804138,%eax
  80238a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238d:	e9 85 01 00 00       	jmp    802517 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 40 0c             	mov    0xc(%eax),%eax
  802398:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239b:	0f 82 6e 01 00 00    	jb     80250f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023aa:	0f 85 8a 00 00 00    	jne    80243a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b4:	75 17                	jne    8023cd <alloc_block_FF+0x4e>
  8023b6:	83 ec 04             	sub    $0x4,%esp
  8023b9:	68 c0 3f 80 00       	push   $0x803fc0
  8023be:	68 93 00 00 00       	push   $0x93
  8023c3:	68 17 3f 80 00       	push   $0x803f17
  8023c8:	e8 8e de ff ff       	call   80025b <_panic>
  8023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d0:	8b 00                	mov    (%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 10                	je     8023e6 <alloc_block_FF+0x67>
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 00                	mov    (%eax),%eax
  8023db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023de:	8b 52 04             	mov    0x4(%edx),%edx
  8023e1:	89 50 04             	mov    %edx,0x4(%eax)
  8023e4:	eb 0b                	jmp    8023f1 <alloc_block_FF+0x72>
  8023e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ec:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	8b 40 04             	mov    0x4(%eax),%eax
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	74 0f                	je     80240a <alloc_block_FF+0x8b>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 40 04             	mov    0x4(%eax),%eax
  802401:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802404:	8b 12                	mov    (%edx),%edx
  802406:	89 10                	mov    %edx,(%eax)
  802408:	eb 0a                	jmp    802414 <alloc_block_FF+0x95>
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 00                	mov    (%eax),%eax
  80240f:	a3 38 41 80 00       	mov    %eax,0x804138
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802427:	a1 44 41 80 00       	mov    0x804144,%eax
  80242c:	48                   	dec    %eax
  80242d:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	e9 10 01 00 00       	jmp    80254a <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 40 0c             	mov    0xc(%eax),%eax
  802440:	3b 45 08             	cmp    0x8(%ebp),%eax
  802443:	0f 86 c6 00 00 00    	jbe    80250f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802449:	a1 48 41 80 00       	mov    0x804148,%eax
  80244e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 50 08             	mov    0x8(%eax),%edx
  802457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245a:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80245d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802460:	8b 55 08             	mov    0x8(%ebp),%edx
  802463:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802466:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246a:	75 17                	jne    802483 <alloc_block_FF+0x104>
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	68 c0 3f 80 00       	push   $0x803fc0
  802474:	68 9b 00 00 00       	push   $0x9b
  802479:	68 17 3f 80 00       	push   $0x803f17
  80247e:	e8 d8 dd ff ff       	call   80025b <_panic>
  802483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802486:	8b 00                	mov    (%eax),%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	74 10                	je     80249c <alloc_block_FF+0x11d>
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802494:	8b 52 04             	mov    0x4(%edx),%edx
  802497:	89 50 04             	mov    %edx,0x4(%eax)
  80249a:	eb 0b                	jmp    8024a7 <alloc_block_FF+0x128>
  80249c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249f:	8b 40 04             	mov    0x4(%eax),%eax
  8024a2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024aa:	8b 40 04             	mov    0x4(%eax),%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 0f                	je     8024c0 <alloc_block_FF+0x141>
  8024b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ba:	8b 12                	mov    (%edx),%edx
  8024bc:	89 10                	mov    %edx,(%eax)
  8024be:	eb 0a                	jmp    8024ca <alloc_block_FF+0x14b>
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	a3 48 41 80 00       	mov    %eax,0x804148
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024dd:	a1 54 41 80 00       	mov    0x804154,%eax
  8024e2:	48                   	dec    %eax
  8024e3:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 50 08             	mov    0x8(%eax),%edx
  8024ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f1:	01 c2                	add    %eax,%edx
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	2b 45 08             	sub    0x8(%ebp),%eax
  802502:	89 c2                	mov    %eax,%edx
  802504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802507:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	eb 3b                	jmp    80254a <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80250f:	a1 40 41 80 00       	mov    0x804140,%eax
  802514:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802517:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251b:	74 07                	je     802524 <alloc_block_FF+0x1a5>
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	eb 05                	jmp    802529 <alloc_block_FF+0x1aa>
  802524:	b8 00 00 00 00       	mov    $0x0,%eax
  802529:	a3 40 41 80 00       	mov    %eax,0x804140
  80252e:	a1 40 41 80 00       	mov    0x804140,%eax
  802533:	85 c0                	test   %eax,%eax
  802535:	0f 85 57 fe ff ff    	jne    802392 <alloc_block_FF+0x13>
  80253b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253f:	0f 85 4d fe ff ff    	jne    802392 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802545:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80254a:	c9                   	leave  
  80254b:	c3                   	ret    

0080254c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802552:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802559:	a1 38 41 80 00       	mov    0x804138,%eax
  80255e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802561:	e9 df 00 00 00       	jmp    802645 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 40 0c             	mov    0xc(%eax),%eax
  80256c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256f:	0f 82 c8 00 00 00    	jb     80263d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 0c             	mov    0xc(%eax),%eax
  80257b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80257e:	0f 85 8a 00 00 00    	jne    80260e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802584:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802588:	75 17                	jne    8025a1 <alloc_block_BF+0x55>
  80258a:	83 ec 04             	sub    $0x4,%esp
  80258d:	68 c0 3f 80 00       	push   $0x803fc0
  802592:	68 b7 00 00 00       	push   $0xb7
  802597:	68 17 3f 80 00       	push   $0x803f17
  80259c:	e8 ba dc ff ff       	call   80025b <_panic>
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 00                	mov    (%eax),%eax
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	74 10                	je     8025ba <alloc_block_BF+0x6e>
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b2:	8b 52 04             	mov    0x4(%edx),%edx
  8025b5:	89 50 04             	mov    %edx,0x4(%eax)
  8025b8:	eb 0b                	jmp    8025c5 <alloc_block_BF+0x79>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	8b 40 04             	mov    0x4(%eax),%eax
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	74 0f                	je     8025de <alloc_block_BF+0x92>
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 04             	mov    0x4(%eax),%eax
  8025d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d8:	8b 12                	mov    (%edx),%edx
  8025da:	89 10                	mov    %edx,(%eax)
  8025dc:	eb 0a                	jmp    8025e8 <alloc_block_BF+0x9c>
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	a3 38 41 80 00       	mov    %eax,0x804138
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fb:	a1 44 41 80 00       	mov    0x804144,%eax
  802600:	48                   	dec    %eax
  802601:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	e9 4d 01 00 00       	jmp    80275b <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 40 0c             	mov    0xc(%eax),%eax
  802614:	3b 45 08             	cmp    0x8(%ebp),%eax
  802617:	76 24                	jbe    80263d <alloc_block_BF+0xf1>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 40 0c             	mov    0xc(%eax),%eax
  80261f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802622:	73 19                	jae    80263d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802624:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 40 0c             	mov    0xc(%eax),%eax
  802631:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802637:	8b 40 08             	mov    0x8(%eax),%eax
  80263a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80263d:	a1 40 41 80 00       	mov    0x804140,%eax
  802642:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802649:	74 07                	je     802652 <alloc_block_BF+0x106>
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 00                	mov    (%eax),%eax
  802650:	eb 05                	jmp    802657 <alloc_block_BF+0x10b>
  802652:	b8 00 00 00 00       	mov    $0x0,%eax
  802657:	a3 40 41 80 00       	mov    %eax,0x804140
  80265c:	a1 40 41 80 00       	mov    0x804140,%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	0f 85 fd fe ff ff    	jne    802566 <alloc_block_BF+0x1a>
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	0f 85 f3 fe ff ff    	jne    802566 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802673:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802677:	0f 84 d9 00 00 00    	je     802756 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80267d:	a1 48 41 80 00       	mov    0x804148,%eax
  802682:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802688:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80268b:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80268e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802691:	8b 55 08             	mov    0x8(%ebp),%edx
  802694:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802697:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80269b:	75 17                	jne    8026b4 <alloc_block_BF+0x168>
  80269d:	83 ec 04             	sub    $0x4,%esp
  8026a0:	68 c0 3f 80 00       	push   $0x803fc0
  8026a5:	68 c7 00 00 00       	push   $0xc7
  8026aa:	68 17 3f 80 00       	push   $0x803f17
  8026af:	e8 a7 db ff ff       	call   80025b <_panic>
  8026b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b7:	8b 00                	mov    (%eax),%eax
  8026b9:	85 c0                	test   %eax,%eax
  8026bb:	74 10                	je     8026cd <alloc_block_BF+0x181>
  8026bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c5:	8b 52 04             	mov    0x4(%edx),%edx
  8026c8:	89 50 04             	mov    %edx,0x4(%eax)
  8026cb:	eb 0b                	jmp    8026d8 <alloc_block_BF+0x18c>
  8026cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d0:	8b 40 04             	mov    0x4(%eax),%eax
  8026d3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	74 0f                	je     8026f1 <alloc_block_BF+0x1a5>
  8026e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e5:	8b 40 04             	mov    0x4(%eax),%eax
  8026e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026eb:	8b 12                	mov    (%edx),%edx
  8026ed:	89 10                	mov    %edx,(%eax)
  8026ef:	eb 0a                	jmp    8026fb <alloc_block_BF+0x1af>
  8026f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f4:	8b 00                	mov    (%eax),%eax
  8026f6:	a3 48 41 80 00       	mov    %eax,0x804148
  8026fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802707:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270e:	a1 54 41 80 00       	mov    0x804154,%eax
  802713:	48                   	dec    %eax
  802714:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802719:	83 ec 08             	sub    $0x8,%esp
  80271c:	ff 75 ec             	pushl  -0x14(%ebp)
  80271f:	68 38 41 80 00       	push   $0x804138
  802724:	e8 71 f9 ff ff       	call   80209a <find_block>
  802729:	83 c4 10             	add    $0x10,%esp
  80272c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80272f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802732:	8b 50 08             	mov    0x8(%eax),%edx
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	01 c2                	add    %eax,%edx
  80273a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802740:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802743:	8b 40 0c             	mov    0xc(%eax),%eax
  802746:	2b 45 08             	sub    0x8(%ebp),%eax
  802749:	89 c2                	mov    %eax,%edx
  80274b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274e:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802754:	eb 05                	jmp    80275b <alloc_block_BF+0x20f>
	}
	return NULL;
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80275d:	55                   	push   %ebp
  80275e:	89 e5                	mov    %esp,%ebp
  802760:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802763:	a1 28 40 80 00       	mov    0x804028,%eax
  802768:	85 c0                	test   %eax,%eax
  80276a:	0f 85 de 01 00 00    	jne    80294e <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802770:	a1 38 41 80 00       	mov    0x804138,%eax
  802775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802778:	e9 9e 01 00 00       	jmp    80291b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 0c             	mov    0xc(%eax),%eax
  802783:	3b 45 08             	cmp    0x8(%ebp),%eax
  802786:	0f 82 87 01 00 00    	jb     802913 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 40 0c             	mov    0xc(%eax),%eax
  802792:	3b 45 08             	cmp    0x8(%ebp),%eax
  802795:	0f 85 95 00 00 00    	jne    802830 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80279b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279f:	75 17                	jne    8027b8 <alloc_block_NF+0x5b>
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	68 c0 3f 80 00       	push   $0x803fc0
  8027a9:	68 e0 00 00 00       	push   $0xe0
  8027ae:	68 17 3f 80 00       	push   $0x803f17
  8027b3:	e8 a3 da ff ff       	call   80025b <_panic>
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 10                	je     8027d1 <alloc_block_NF+0x74>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c9:	8b 52 04             	mov    0x4(%edx),%edx
  8027cc:	89 50 04             	mov    %edx,0x4(%eax)
  8027cf:	eb 0b                	jmp    8027dc <alloc_block_NF+0x7f>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	74 0f                	je     8027f5 <alloc_block_NF+0x98>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ef:	8b 12                	mov    (%edx),%edx
  8027f1:	89 10                	mov    %edx,(%eax)
  8027f3:	eb 0a                	jmp    8027ff <alloc_block_NF+0xa2>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	a3 38 41 80 00       	mov    %eax,0x804138
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802812:	a1 44 41 80 00       	mov    0x804144,%eax
  802817:	48                   	dec    %eax
  802818:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 40 08             	mov    0x8(%eax),%eax
  802823:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	e9 f8 04 00 00       	jmp    802d28 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802833:	8b 40 0c             	mov    0xc(%eax),%eax
  802836:	3b 45 08             	cmp    0x8(%ebp),%eax
  802839:	0f 86 d4 00 00 00    	jbe    802913 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80283f:	a1 48 41 80 00       	mov    0x804148,%eax
  802844:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 50 08             	mov    0x8(%eax),%edx
  80284d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802850:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	8b 55 08             	mov    0x8(%ebp),%edx
  802859:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80285c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802860:	75 17                	jne    802879 <alloc_block_NF+0x11c>
  802862:	83 ec 04             	sub    $0x4,%esp
  802865:	68 c0 3f 80 00       	push   $0x803fc0
  80286a:	68 e9 00 00 00       	push   $0xe9
  80286f:	68 17 3f 80 00       	push   $0x803f17
  802874:	e8 e2 d9 ff ff       	call   80025b <_panic>
  802879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	85 c0                	test   %eax,%eax
  802880:	74 10                	je     802892 <alloc_block_NF+0x135>
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80288a:	8b 52 04             	mov    0x4(%edx),%edx
  80288d:	89 50 04             	mov    %edx,0x4(%eax)
  802890:	eb 0b                	jmp    80289d <alloc_block_NF+0x140>
  802892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802895:	8b 40 04             	mov    0x4(%eax),%eax
  802898:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80289d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a0:	8b 40 04             	mov    0x4(%eax),%eax
  8028a3:	85 c0                	test   %eax,%eax
  8028a5:	74 0f                	je     8028b6 <alloc_block_NF+0x159>
  8028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028b0:	8b 12                	mov    (%edx),%edx
  8028b2:	89 10                	mov    %edx,(%eax)
  8028b4:	eb 0a                	jmp    8028c0 <alloc_block_NF+0x163>
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	a3 48 41 80 00       	mov    %eax,0x804148
  8028c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d3:	a1 54 41 80 00       	mov    0x804154,%eax
  8028d8:	48                   	dec    %eax
  8028d9:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8028de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e1:	8b 40 08             	mov    0x8(%eax),%eax
  8028e4:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 50 08             	mov    0x8(%eax),%edx
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	01 c2                	add    %eax,%edx
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802900:	2b 45 08             	sub    0x8(%ebp),%eax
  802903:	89 c2                	mov    %eax,%edx
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80290b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290e:	e9 15 04 00 00       	jmp    802d28 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802913:	a1 40 41 80 00       	mov    0x804140,%eax
  802918:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80291f:	74 07                	je     802928 <alloc_block_NF+0x1cb>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	eb 05                	jmp    80292d <alloc_block_NF+0x1d0>
  802928:	b8 00 00 00 00       	mov    $0x0,%eax
  80292d:	a3 40 41 80 00       	mov    %eax,0x804140
  802932:	a1 40 41 80 00       	mov    0x804140,%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	0f 85 3e fe ff ff    	jne    80277d <alloc_block_NF+0x20>
  80293f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802943:	0f 85 34 fe ff ff    	jne    80277d <alloc_block_NF+0x20>
  802949:	e9 d5 03 00 00       	jmp    802d23 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80294e:	a1 38 41 80 00       	mov    0x804138,%eax
  802953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802956:	e9 b1 01 00 00       	jmp    802b0c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 50 08             	mov    0x8(%eax),%edx
  802961:	a1 28 40 80 00       	mov    0x804028,%eax
  802966:	39 c2                	cmp    %eax,%edx
  802968:	0f 82 96 01 00 00    	jb     802b04 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 40 0c             	mov    0xc(%eax),%eax
  802974:	3b 45 08             	cmp    0x8(%ebp),%eax
  802977:	0f 82 87 01 00 00    	jb     802b04 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 40 0c             	mov    0xc(%eax),%eax
  802983:	3b 45 08             	cmp    0x8(%ebp),%eax
  802986:	0f 85 95 00 00 00    	jne    802a21 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80298c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802990:	75 17                	jne    8029a9 <alloc_block_NF+0x24c>
  802992:	83 ec 04             	sub    $0x4,%esp
  802995:	68 c0 3f 80 00       	push   $0x803fc0
  80299a:	68 fc 00 00 00       	push   $0xfc
  80299f:	68 17 3f 80 00       	push   $0x803f17
  8029a4:	e8 b2 d8 ff ff       	call   80025b <_panic>
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 10                	je     8029c2 <alloc_block_NF+0x265>
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 00                	mov    (%eax),%eax
  8029b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ba:	8b 52 04             	mov    0x4(%edx),%edx
  8029bd:	89 50 04             	mov    %edx,0x4(%eax)
  8029c0:	eb 0b                	jmp    8029cd <alloc_block_NF+0x270>
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 40 04             	mov    0x4(%eax),%eax
  8029c8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 40 04             	mov    0x4(%eax),%eax
  8029d3:	85 c0                	test   %eax,%eax
  8029d5:	74 0f                	je     8029e6 <alloc_block_NF+0x289>
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 40 04             	mov    0x4(%eax),%eax
  8029dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e0:	8b 12                	mov    (%edx),%edx
  8029e2:	89 10                	mov    %edx,(%eax)
  8029e4:	eb 0a                	jmp    8029f0 <alloc_block_NF+0x293>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	a3 38 41 80 00       	mov    %eax,0x804138
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a03:	a1 44 41 80 00       	mov    0x804144,%eax
  802a08:	48                   	dec    %eax
  802a09:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 40 08             	mov    0x8(%eax),%eax
  802a14:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	e9 07 03 00 00       	jmp    802d28 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2a:	0f 86 d4 00 00 00    	jbe    802b04 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a30:	a1 48 41 80 00       	mov    0x804148,%eax
  802a35:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 50 08             	mov    0x8(%eax),%edx
  802a3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a41:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a47:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4a:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a51:	75 17                	jne    802a6a <alloc_block_NF+0x30d>
  802a53:	83 ec 04             	sub    $0x4,%esp
  802a56:	68 c0 3f 80 00       	push   $0x803fc0
  802a5b:	68 04 01 00 00       	push   $0x104
  802a60:	68 17 3f 80 00       	push   $0x803f17
  802a65:	e8 f1 d7 ff ff       	call   80025b <_panic>
  802a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 10                	je     802a83 <alloc_block_NF+0x326>
  802a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a76:	8b 00                	mov    (%eax),%eax
  802a78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a7b:	8b 52 04             	mov    0x4(%edx),%edx
  802a7e:	89 50 04             	mov    %edx,0x4(%eax)
  802a81:	eb 0b                	jmp    802a8e <alloc_block_NF+0x331>
  802a83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a86:	8b 40 04             	mov    0x4(%eax),%eax
  802a89:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	85 c0                	test   %eax,%eax
  802a96:	74 0f                	je     802aa7 <alloc_block_NF+0x34a>
  802a98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9b:	8b 40 04             	mov    0x4(%eax),%eax
  802a9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aa1:	8b 12                	mov    (%edx),%edx
  802aa3:	89 10                	mov    %edx,(%eax)
  802aa5:	eb 0a                	jmp    802ab1 <alloc_block_NF+0x354>
  802aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	a3 48 41 80 00       	mov    %eax,0x804148
  802ab1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac4:	a1 54 41 80 00       	mov    0x804154,%eax
  802ac9:	48                   	dec    %eax
  802aca:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802acf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 50 08             	mov    0x8(%eax),%edx
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	01 c2                	add    %eax,%edx
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 40 0c             	mov    0xc(%eax),%eax
  802af1:	2b 45 08             	sub    0x8(%ebp),%eax
  802af4:	89 c2                	mov    %eax,%edx
  802af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af9:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802afc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aff:	e9 24 02 00 00       	jmp    802d28 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b04:	a1 40 41 80 00       	mov    0x804140,%eax
  802b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b10:	74 07                	je     802b19 <alloc_block_NF+0x3bc>
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	8b 00                	mov    (%eax),%eax
  802b17:	eb 05                	jmp    802b1e <alloc_block_NF+0x3c1>
  802b19:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1e:	a3 40 41 80 00       	mov    %eax,0x804140
  802b23:	a1 40 41 80 00       	mov    0x804140,%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	0f 85 2b fe ff ff    	jne    80295b <alloc_block_NF+0x1fe>
  802b30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b34:	0f 85 21 fe ff ff    	jne    80295b <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b3a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b42:	e9 ae 01 00 00       	jmp    802cf5 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 50 08             	mov    0x8(%eax),%edx
  802b4d:	a1 28 40 80 00       	mov    0x804028,%eax
  802b52:	39 c2                	cmp    %eax,%edx
  802b54:	0f 83 93 01 00 00    	jae    802ced <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b63:	0f 82 84 01 00 00    	jb     802ced <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b72:	0f 85 95 00 00 00    	jne    802c0d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7c:	75 17                	jne    802b95 <alloc_block_NF+0x438>
  802b7e:	83 ec 04             	sub    $0x4,%esp
  802b81:	68 c0 3f 80 00       	push   $0x803fc0
  802b86:	68 14 01 00 00       	push   $0x114
  802b8b:	68 17 3f 80 00       	push   $0x803f17
  802b90:	e8 c6 d6 ff ff       	call   80025b <_panic>
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 10                	je     802bae <alloc_block_NF+0x451>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba6:	8b 52 04             	mov    0x4(%edx),%edx
  802ba9:	89 50 04             	mov    %edx,0x4(%eax)
  802bac:	eb 0b                	jmp    802bb9 <alloc_block_NF+0x45c>
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 40 04             	mov    0x4(%eax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0f                	je     802bd2 <alloc_block_NF+0x475>
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcc:	8b 12                	mov    (%edx),%edx
  802bce:	89 10                	mov    %edx,(%eax)
  802bd0:	eb 0a                	jmp    802bdc <alloc_block_NF+0x47f>
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	a3 38 41 80 00       	mov    %eax,0x804138
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bef:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf4:	48                   	dec    %eax
  802bf5:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 08             	mov    0x8(%eax),%eax
  802c00:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	e9 1b 01 00 00       	jmp    802d28 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 0c             	mov    0xc(%eax),%eax
  802c13:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c16:	0f 86 d1 00 00 00    	jbe    802ced <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c1c:	a1 48 41 80 00       	mov    0x804148,%eax
  802c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 50 08             	mov    0x8(%eax),%edx
  802c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c33:	8b 55 08             	mov    0x8(%ebp),%edx
  802c36:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c3d:	75 17                	jne    802c56 <alloc_block_NF+0x4f9>
  802c3f:	83 ec 04             	sub    $0x4,%esp
  802c42:	68 c0 3f 80 00       	push   $0x803fc0
  802c47:	68 1c 01 00 00       	push   $0x11c
  802c4c:	68 17 3f 80 00       	push   $0x803f17
  802c51:	e8 05 d6 ff ff       	call   80025b <_panic>
  802c56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c59:	8b 00                	mov    (%eax),%eax
  802c5b:	85 c0                	test   %eax,%eax
  802c5d:	74 10                	je     802c6f <alloc_block_NF+0x512>
  802c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c62:	8b 00                	mov    (%eax),%eax
  802c64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c67:	8b 52 04             	mov    0x4(%edx),%edx
  802c6a:	89 50 04             	mov    %edx,0x4(%eax)
  802c6d:	eb 0b                	jmp    802c7a <alloc_block_NF+0x51d>
  802c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7d:	8b 40 04             	mov    0x4(%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 0f                	je     802c93 <alloc_block_NF+0x536>
  802c84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c87:	8b 40 04             	mov    0x4(%eax),%eax
  802c8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c8d:	8b 12                	mov    (%edx),%edx
  802c8f:	89 10                	mov    %edx,(%eax)
  802c91:	eb 0a                	jmp    802c9d <alloc_block_NF+0x540>
  802c93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c96:	8b 00                	mov    (%eax),%eax
  802c98:	a3 48 41 80 00       	mov    %eax,0x804148
  802c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb0:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb5:	48                   	dec    %eax
  802cb6:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbe:	8b 40 08             	mov    0x8(%eax),%eax
  802cc1:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 50 08             	mov    0x8(%eax),%edx
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	01 c2                	add    %eax,%edx
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	2b 45 08             	sub    0x8(%ebp),%eax
  802ce0:	89 c2                	mov    %eax,%edx
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ceb:	eb 3b                	jmp    802d28 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ced:	a1 40 41 80 00       	mov    0x804140,%eax
  802cf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf9:	74 07                	je     802d02 <alloc_block_NF+0x5a5>
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	eb 05                	jmp    802d07 <alloc_block_NF+0x5aa>
  802d02:	b8 00 00 00 00       	mov    $0x0,%eax
  802d07:	a3 40 41 80 00       	mov    %eax,0x804140
  802d0c:	a1 40 41 80 00       	mov    0x804140,%eax
  802d11:	85 c0                	test   %eax,%eax
  802d13:	0f 85 2e fe ff ff    	jne    802b47 <alloc_block_NF+0x3ea>
  802d19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1d:	0f 85 24 fe ff ff    	jne    802b47 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d28:	c9                   	leave  
  802d29:	c3                   	ret    

00802d2a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d2a:	55                   	push   %ebp
  802d2b:	89 e5                	mov    %esp,%ebp
  802d2d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d30:	a1 38 41 80 00       	mov    0x804138,%eax
  802d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d38:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d3d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d40:	a1 38 41 80 00       	mov    0x804138,%eax
  802d45:	85 c0                	test   %eax,%eax
  802d47:	74 14                	je     802d5d <insert_sorted_with_merge_freeList+0x33>
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 50 08             	mov    0x8(%eax),%edx
  802d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d52:	8b 40 08             	mov    0x8(%eax),%eax
  802d55:	39 c2                	cmp    %eax,%edx
  802d57:	0f 87 9b 01 00 00    	ja     802ef8 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d61:	75 17                	jne    802d7a <insert_sorted_with_merge_freeList+0x50>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 f4 3e 80 00       	push   $0x803ef4
  802d6b:	68 38 01 00 00       	push   $0x138
  802d70:	68 17 3f 80 00       	push   $0x803f17
  802d75:	e8 e1 d4 ff ff       	call   80025b <_panic>
  802d7a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	89 10                	mov    %edx,(%eax)
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0d                	je     802d9b <insert_sorted_with_merge_freeList+0x71>
  802d8e:	a1 38 41 80 00       	mov    0x804138,%eax
  802d93:	8b 55 08             	mov    0x8(%ebp),%edx
  802d96:	89 50 04             	mov    %edx,0x4(%eax)
  802d99:	eb 08                	jmp    802da3 <insert_sorted_with_merge_freeList+0x79>
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	a3 38 41 80 00       	mov    %eax,0x804138
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db5:	a1 44 41 80 00       	mov    0x804144,%eax
  802dba:	40                   	inc    %eax
  802dbb:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc4:	0f 84 a8 06 00 00    	je     803472 <insert_sorted_with_merge_freeList+0x748>
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	8b 50 08             	mov    0x8(%eax),%edx
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd6:	01 c2                	add    %eax,%edx
  802dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddb:	8b 40 08             	mov    0x8(%eax),%eax
  802dde:	39 c2                	cmp    %eax,%edx
  802de0:	0f 85 8c 06 00 00    	jne    803472 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802def:	8b 40 0c             	mov    0xc(%eax),%eax
  802df2:	01 c2                	add    %eax,%edx
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dfe:	75 17                	jne    802e17 <insert_sorted_with_merge_freeList+0xed>
  802e00:	83 ec 04             	sub    $0x4,%esp
  802e03:	68 c0 3f 80 00       	push   $0x803fc0
  802e08:	68 3c 01 00 00       	push   $0x13c
  802e0d:	68 17 3f 80 00       	push   $0x803f17
  802e12:	e8 44 d4 ff ff       	call   80025b <_panic>
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1a:	8b 00                	mov    (%eax),%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	74 10                	je     802e30 <insert_sorted_with_merge_freeList+0x106>
  802e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e28:	8b 52 04             	mov    0x4(%edx),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	eb 0b                	jmp    802e3b <insert_sorted_with_merge_freeList+0x111>
  802e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e33:	8b 40 04             	mov    0x4(%eax),%eax
  802e36:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 0f                	je     802e54 <insert_sorted_with_merge_freeList+0x12a>
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e4e:	8b 12                	mov    (%edx),%edx
  802e50:	89 10                	mov    %edx,(%eax)
  802e52:	eb 0a                	jmp    802e5e <insert_sorted_with_merge_freeList+0x134>
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	a3 38 41 80 00       	mov    %eax,0x804138
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e71:	a1 44 41 80 00       	mov    0x804144,%eax
  802e76:	48                   	dec    %eax
  802e77:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e94:	75 17                	jne    802ead <insert_sorted_with_merge_freeList+0x183>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 f4 3e 80 00       	push   $0x803ef4
  802e9e:	68 3f 01 00 00       	push   $0x13f
  802ea3:	68 17 3f 80 00       	push   $0x803f17
  802ea8:	e8 ae d3 ff ff       	call   80025b <_panic>
  802ead:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb6:	89 10                	mov    %edx,(%eax)
  802eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebb:	8b 00                	mov    (%eax),%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	74 0d                	je     802ece <insert_sorted_with_merge_freeList+0x1a4>
  802ec1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec9:	89 50 04             	mov    %edx,0x4(%eax)
  802ecc:	eb 08                	jmp    802ed6 <insert_sorted_with_merge_freeList+0x1ac>
  802ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed9:	a3 48 41 80 00       	mov    %eax,0x804148
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee8:	a1 54 41 80 00       	mov    0x804154,%eax
  802eed:	40                   	inc    %eax
  802eee:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ef3:	e9 7a 05 00 00       	jmp    803472 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	8b 50 08             	mov    0x8(%eax),%edx
  802efe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f01:	8b 40 08             	mov    0x8(%eax),%eax
  802f04:	39 c2                	cmp    %eax,%edx
  802f06:	0f 82 14 01 00 00    	jb     803020 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0f:	8b 50 08             	mov    0x8(%eax),%edx
  802f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f15:	8b 40 0c             	mov    0xc(%eax),%eax
  802f18:	01 c2                	add    %eax,%edx
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	8b 40 08             	mov    0x8(%eax),%eax
  802f20:	39 c2                	cmp    %eax,%edx
  802f22:	0f 85 90 00 00 00    	jne    802fb8 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	8b 40 0c             	mov    0xc(%eax),%eax
  802f34:	01 c2                	add    %eax,%edx
  802f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f39:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f54:	75 17                	jne    802f6d <insert_sorted_with_merge_freeList+0x243>
  802f56:	83 ec 04             	sub    $0x4,%esp
  802f59:	68 f4 3e 80 00       	push   $0x803ef4
  802f5e:	68 49 01 00 00       	push   $0x149
  802f63:	68 17 3f 80 00       	push   $0x803f17
  802f68:	e8 ee d2 ff ff       	call   80025b <_panic>
  802f6d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	89 10                	mov    %edx,(%eax)
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	8b 00                	mov    (%eax),%eax
  802f7d:	85 c0                	test   %eax,%eax
  802f7f:	74 0d                	je     802f8e <insert_sorted_with_merge_freeList+0x264>
  802f81:	a1 48 41 80 00       	mov    0x804148,%eax
  802f86:	8b 55 08             	mov    0x8(%ebp),%edx
  802f89:	89 50 04             	mov    %edx,0x4(%eax)
  802f8c:	eb 08                	jmp    802f96 <insert_sorted_with_merge_freeList+0x26c>
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	a3 48 41 80 00       	mov    %eax,0x804148
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa8:	a1 54 41 80 00       	mov    0x804154,%eax
  802fad:	40                   	inc    %eax
  802fae:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fb3:	e9 bb 04 00 00       	jmp    803473 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fbc:	75 17                	jne    802fd5 <insert_sorted_with_merge_freeList+0x2ab>
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	68 68 3f 80 00       	push   $0x803f68
  802fc6:	68 4c 01 00 00       	push   $0x14c
  802fcb:	68 17 3f 80 00       	push   $0x803f17
  802fd0:	e8 86 d2 ff ff       	call   80025b <_panic>
  802fd5:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	89 50 04             	mov    %edx,0x4(%eax)
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	85 c0                	test   %eax,%eax
  802fe9:	74 0c                	je     802ff7 <insert_sorted_with_merge_freeList+0x2cd>
  802feb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff3:	89 10                	mov    %edx,(%eax)
  802ff5:	eb 08                	jmp    802fff <insert_sorted_with_merge_freeList+0x2d5>
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	a3 38 41 80 00       	mov    %eax,0x804138
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803010:	a1 44 41 80 00       	mov    0x804144,%eax
  803015:	40                   	inc    %eax
  803016:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80301b:	e9 53 04 00 00       	jmp    803473 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803020:	a1 38 41 80 00       	mov    0x804138,%eax
  803025:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803028:	e9 15 04 00 00       	jmp    803442 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	8b 50 08             	mov    0x8(%eax),%edx
  80303b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303e:	8b 40 08             	mov    0x8(%eax),%eax
  803041:	39 c2                	cmp    %eax,%edx
  803043:	0f 86 f1 03 00 00    	jbe    80343a <insert_sorted_with_merge_freeList+0x710>
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	8b 50 08             	mov    0x8(%eax),%edx
  80304f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803052:	8b 40 08             	mov    0x8(%eax),%eax
  803055:	39 c2                	cmp    %eax,%edx
  803057:	0f 83 dd 03 00 00    	jae    80343a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 50 08             	mov    0x8(%eax),%edx
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	8b 40 0c             	mov    0xc(%eax),%eax
  803069:	01 c2                	add    %eax,%edx
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	8b 40 08             	mov    0x8(%eax),%eax
  803071:	39 c2                	cmp    %eax,%edx
  803073:	0f 85 b9 01 00 00    	jne    803232 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	8b 50 08             	mov    0x8(%eax),%edx
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	8b 40 0c             	mov    0xc(%eax),%eax
  803085:	01 c2                	add    %eax,%edx
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	8b 40 08             	mov    0x8(%eax),%eax
  80308d:	39 c2                	cmp    %eax,%edx
  80308f:	0f 85 0d 01 00 00    	jne    8031a2 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 50 0c             	mov    0xc(%eax),%edx
  80309b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80309e:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a1:	01 c2                	add    %eax,%edx
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030ad:	75 17                	jne    8030c6 <insert_sorted_with_merge_freeList+0x39c>
  8030af:	83 ec 04             	sub    $0x4,%esp
  8030b2:	68 c0 3f 80 00       	push   $0x803fc0
  8030b7:	68 5c 01 00 00       	push   $0x15c
  8030bc:	68 17 3f 80 00       	push   $0x803f17
  8030c1:	e8 95 d1 ff ff       	call   80025b <_panic>
  8030c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c9:	8b 00                	mov    (%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	74 10                	je     8030df <insert_sorted_with_merge_freeList+0x3b5>
  8030cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d7:	8b 52 04             	mov    0x4(%edx),%edx
  8030da:	89 50 04             	mov    %edx,0x4(%eax)
  8030dd:	eb 0b                	jmp    8030ea <insert_sorted_with_merge_freeList+0x3c0>
  8030df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e2:	8b 40 04             	mov    0x4(%eax),%eax
  8030e5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ed:	8b 40 04             	mov    0x4(%eax),%eax
  8030f0:	85 c0                	test   %eax,%eax
  8030f2:	74 0f                	je     803103 <insert_sorted_with_merge_freeList+0x3d9>
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 40 04             	mov    0x4(%eax),%eax
  8030fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030fd:	8b 12                	mov    (%edx),%edx
  8030ff:	89 10                	mov    %edx,(%eax)
  803101:	eb 0a                	jmp    80310d <insert_sorted_with_merge_freeList+0x3e3>
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 00                	mov    (%eax),%eax
  803108:	a3 38 41 80 00       	mov    %eax,0x804138
  80310d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803110:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803116:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803119:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803120:	a1 44 41 80 00       	mov    0x804144,%eax
  803125:	48                   	dec    %eax
  803126:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80313f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803143:	75 17                	jne    80315c <insert_sorted_with_merge_freeList+0x432>
  803145:	83 ec 04             	sub    $0x4,%esp
  803148:	68 f4 3e 80 00       	push   $0x803ef4
  80314d:	68 5f 01 00 00       	push   $0x15f
  803152:	68 17 3f 80 00       	push   $0x803f17
  803157:	e8 ff d0 ff ff       	call   80025b <_panic>
  80315c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803162:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803165:	89 10                	mov    %edx,(%eax)
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	8b 00                	mov    (%eax),%eax
  80316c:	85 c0                	test   %eax,%eax
  80316e:	74 0d                	je     80317d <insert_sorted_with_merge_freeList+0x453>
  803170:	a1 48 41 80 00       	mov    0x804148,%eax
  803175:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803178:	89 50 04             	mov    %edx,0x4(%eax)
  80317b:	eb 08                	jmp    803185 <insert_sorted_with_merge_freeList+0x45b>
  80317d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803180:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803185:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803188:	a3 48 41 80 00       	mov    %eax,0x804148
  80318d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803190:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803197:	a1 54 41 80 00       	mov    0x804154,%eax
  80319c:	40                   	inc    %eax
  80319d:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  8031a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ae:	01 c2                	add    %eax,%edx
  8031b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b3:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ce:	75 17                	jne    8031e7 <insert_sorted_with_merge_freeList+0x4bd>
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	68 f4 3e 80 00       	push   $0x803ef4
  8031d8:	68 64 01 00 00       	push   $0x164
  8031dd:	68 17 3f 80 00       	push   $0x803f17
  8031e2:	e8 74 d0 ff ff       	call   80025b <_panic>
  8031e7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	89 10                	mov    %edx,(%eax)
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	74 0d                	je     803208 <insert_sorted_with_merge_freeList+0x4de>
  8031fb:	a1 48 41 80 00       	mov    0x804148,%eax
  803200:	8b 55 08             	mov    0x8(%ebp),%edx
  803203:	89 50 04             	mov    %edx,0x4(%eax)
  803206:	eb 08                	jmp    803210 <insert_sorted_with_merge_freeList+0x4e6>
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	a3 48 41 80 00       	mov    %eax,0x804148
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803222:	a1 54 41 80 00       	mov    0x804154,%eax
  803227:	40                   	inc    %eax
  803228:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80322d:	e9 41 02 00 00       	jmp    803473 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803232:	8b 45 08             	mov    0x8(%ebp),%eax
  803235:	8b 50 08             	mov    0x8(%eax),%edx
  803238:	8b 45 08             	mov    0x8(%ebp),%eax
  80323b:	8b 40 0c             	mov    0xc(%eax),%eax
  80323e:	01 c2                	add    %eax,%edx
  803240:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803243:	8b 40 08             	mov    0x8(%eax),%eax
  803246:	39 c2                	cmp    %eax,%edx
  803248:	0f 85 7c 01 00 00    	jne    8033ca <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80324e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803252:	74 06                	je     80325a <insert_sorted_with_merge_freeList+0x530>
  803254:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803258:	75 17                	jne    803271 <insert_sorted_with_merge_freeList+0x547>
  80325a:	83 ec 04             	sub    $0x4,%esp
  80325d:	68 30 3f 80 00       	push   $0x803f30
  803262:	68 69 01 00 00       	push   $0x169
  803267:	68 17 3f 80 00       	push   $0x803f17
  80326c:	e8 ea cf ff ff       	call   80025b <_panic>
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	8b 50 04             	mov    0x4(%eax),%edx
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	89 50 04             	mov    %edx,0x4(%eax)
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803283:	89 10                	mov    %edx,(%eax)
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	8b 40 04             	mov    0x4(%eax),%eax
  80328b:	85 c0                	test   %eax,%eax
  80328d:	74 0d                	je     80329c <insert_sorted_with_merge_freeList+0x572>
  80328f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803292:	8b 40 04             	mov    0x4(%eax),%eax
  803295:	8b 55 08             	mov    0x8(%ebp),%edx
  803298:	89 10                	mov    %edx,(%eax)
  80329a:	eb 08                	jmp    8032a4 <insert_sorted_with_merge_freeList+0x57a>
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	a3 38 41 80 00       	mov    %eax,0x804138
  8032a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8032aa:	89 50 04             	mov    %edx,0x4(%eax)
  8032ad:	a1 44 41 80 00       	mov    0x804144,%eax
  8032b2:	40                   	inc    %eax
  8032b3:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8032be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c4:	01 c2                	add    %eax,%edx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032d0:	75 17                	jne    8032e9 <insert_sorted_with_merge_freeList+0x5bf>
  8032d2:	83 ec 04             	sub    $0x4,%esp
  8032d5:	68 c0 3f 80 00       	push   $0x803fc0
  8032da:	68 6b 01 00 00       	push   $0x16b
  8032df:	68 17 3f 80 00       	push   $0x803f17
  8032e4:	e8 72 cf ff ff       	call   80025b <_panic>
  8032e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ec:	8b 00                	mov    (%eax),%eax
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	74 10                	je     803302 <insert_sorted_with_merge_freeList+0x5d8>
  8032f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032fa:	8b 52 04             	mov    0x4(%edx),%edx
  8032fd:	89 50 04             	mov    %edx,0x4(%eax)
  803300:	eb 0b                	jmp    80330d <insert_sorted_with_merge_freeList+0x5e3>
  803302:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803305:	8b 40 04             	mov    0x4(%eax),%eax
  803308:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0f                	je     803326 <insert_sorted_with_merge_freeList+0x5fc>
  803317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331a:	8b 40 04             	mov    0x4(%eax),%eax
  80331d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803320:	8b 12                	mov    (%edx),%edx
  803322:	89 10                	mov    %edx,(%eax)
  803324:	eb 0a                	jmp    803330 <insert_sorted_with_merge_freeList+0x606>
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	8b 00                	mov    (%eax),%eax
  80332b:	a3 38 41 80 00       	mov    %eax,0x804138
  803330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803339:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803343:	a1 44 41 80 00       	mov    0x804144,%eax
  803348:	48                   	dec    %eax
  803349:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  80334e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803351:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803362:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803366:	75 17                	jne    80337f <insert_sorted_with_merge_freeList+0x655>
  803368:	83 ec 04             	sub    $0x4,%esp
  80336b:	68 f4 3e 80 00       	push   $0x803ef4
  803370:	68 6e 01 00 00       	push   $0x16e
  803375:	68 17 3f 80 00       	push   $0x803f17
  80337a:	e8 dc ce ff ff       	call   80025b <_panic>
  80337f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803385:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803388:	89 10                	mov    %edx,(%eax)
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	8b 00                	mov    (%eax),%eax
  80338f:	85 c0                	test   %eax,%eax
  803391:	74 0d                	je     8033a0 <insert_sorted_with_merge_freeList+0x676>
  803393:	a1 48 41 80 00       	mov    0x804148,%eax
  803398:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80339b:	89 50 04             	mov    %edx,0x4(%eax)
  80339e:	eb 08                	jmp    8033a8 <insert_sorted_with_merge_freeList+0x67e>
  8033a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8033a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ab:	a3 48 41 80 00       	mov    %eax,0x804148
  8033b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ba:	a1 54 41 80 00       	mov    0x804154,%eax
  8033bf:	40                   	inc    %eax
  8033c0:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8033c5:	e9 a9 00 00 00       	jmp    803473 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ce:	74 06                	je     8033d6 <insert_sorted_with_merge_freeList+0x6ac>
  8033d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d4:	75 17                	jne    8033ed <insert_sorted_with_merge_freeList+0x6c3>
  8033d6:	83 ec 04             	sub    $0x4,%esp
  8033d9:	68 8c 3f 80 00       	push   $0x803f8c
  8033de:	68 73 01 00 00       	push   $0x173
  8033e3:	68 17 3f 80 00       	push   $0x803f17
  8033e8:	e8 6e ce ff ff       	call   80025b <_panic>
  8033ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f0:	8b 10                	mov    (%eax),%edx
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	89 10                	mov    %edx,(%eax)
  8033f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	85 c0                	test   %eax,%eax
  8033fe:	74 0b                	je     80340b <insert_sorted_with_merge_freeList+0x6e1>
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	8b 55 08             	mov    0x8(%ebp),%edx
  803408:	89 50 04             	mov    %edx,0x4(%eax)
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	8b 55 08             	mov    0x8(%ebp),%edx
  803411:	89 10                	mov    %edx,(%eax)
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803419:	89 50 04             	mov    %edx,0x4(%eax)
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	8b 00                	mov    (%eax),%eax
  803421:	85 c0                	test   %eax,%eax
  803423:	75 08                	jne    80342d <insert_sorted_with_merge_freeList+0x703>
  803425:	8b 45 08             	mov    0x8(%ebp),%eax
  803428:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80342d:	a1 44 41 80 00       	mov    0x804144,%eax
  803432:	40                   	inc    %eax
  803433:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803438:	eb 39                	jmp    803473 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80343a:	a1 40 41 80 00       	mov    0x804140,%eax
  80343f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803446:	74 07                	je     80344f <insert_sorted_with_merge_freeList+0x725>
  803448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	eb 05                	jmp    803454 <insert_sorted_with_merge_freeList+0x72a>
  80344f:	b8 00 00 00 00       	mov    $0x0,%eax
  803454:	a3 40 41 80 00       	mov    %eax,0x804140
  803459:	a1 40 41 80 00       	mov    0x804140,%eax
  80345e:	85 c0                	test   %eax,%eax
  803460:	0f 85 c7 fb ff ff    	jne    80302d <insert_sorted_with_merge_freeList+0x303>
  803466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346a:	0f 85 bd fb ff ff    	jne    80302d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803470:	eb 01                	jmp    803473 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803472:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803473:	90                   	nop
  803474:	c9                   	leave  
  803475:	c3                   	ret    
  803476:	66 90                	xchg   %ax,%ax

00803478 <__udivdi3>:
  803478:	55                   	push   %ebp
  803479:	57                   	push   %edi
  80347a:	56                   	push   %esi
  80347b:	53                   	push   %ebx
  80347c:	83 ec 1c             	sub    $0x1c,%esp
  80347f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803483:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803487:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80348b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80348f:	89 ca                	mov    %ecx,%edx
  803491:	89 f8                	mov    %edi,%eax
  803493:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803497:	85 f6                	test   %esi,%esi
  803499:	75 2d                	jne    8034c8 <__udivdi3+0x50>
  80349b:	39 cf                	cmp    %ecx,%edi
  80349d:	77 65                	ja     803504 <__udivdi3+0x8c>
  80349f:	89 fd                	mov    %edi,%ebp
  8034a1:	85 ff                	test   %edi,%edi
  8034a3:	75 0b                	jne    8034b0 <__udivdi3+0x38>
  8034a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034aa:	31 d2                	xor    %edx,%edx
  8034ac:	f7 f7                	div    %edi
  8034ae:	89 c5                	mov    %eax,%ebp
  8034b0:	31 d2                	xor    %edx,%edx
  8034b2:	89 c8                	mov    %ecx,%eax
  8034b4:	f7 f5                	div    %ebp
  8034b6:	89 c1                	mov    %eax,%ecx
  8034b8:	89 d8                	mov    %ebx,%eax
  8034ba:	f7 f5                	div    %ebp
  8034bc:	89 cf                	mov    %ecx,%edi
  8034be:	89 fa                	mov    %edi,%edx
  8034c0:	83 c4 1c             	add    $0x1c,%esp
  8034c3:	5b                   	pop    %ebx
  8034c4:	5e                   	pop    %esi
  8034c5:	5f                   	pop    %edi
  8034c6:	5d                   	pop    %ebp
  8034c7:	c3                   	ret    
  8034c8:	39 ce                	cmp    %ecx,%esi
  8034ca:	77 28                	ja     8034f4 <__udivdi3+0x7c>
  8034cc:	0f bd fe             	bsr    %esi,%edi
  8034cf:	83 f7 1f             	xor    $0x1f,%edi
  8034d2:	75 40                	jne    803514 <__udivdi3+0x9c>
  8034d4:	39 ce                	cmp    %ecx,%esi
  8034d6:	72 0a                	jb     8034e2 <__udivdi3+0x6a>
  8034d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034dc:	0f 87 9e 00 00 00    	ja     803580 <__udivdi3+0x108>
  8034e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034e7:	89 fa                	mov    %edi,%edx
  8034e9:	83 c4 1c             	add    $0x1c,%esp
  8034ec:	5b                   	pop    %ebx
  8034ed:	5e                   	pop    %esi
  8034ee:	5f                   	pop    %edi
  8034ef:	5d                   	pop    %ebp
  8034f0:	c3                   	ret    
  8034f1:	8d 76 00             	lea    0x0(%esi),%esi
  8034f4:	31 ff                	xor    %edi,%edi
  8034f6:	31 c0                	xor    %eax,%eax
  8034f8:	89 fa                	mov    %edi,%edx
  8034fa:	83 c4 1c             	add    $0x1c,%esp
  8034fd:	5b                   	pop    %ebx
  8034fe:	5e                   	pop    %esi
  8034ff:	5f                   	pop    %edi
  803500:	5d                   	pop    %ebp
  803501:	c3                   	ret    
  803502:	66 90                	xchg   %ax,%ax
  803504:	89 d8                	mov    %ebx,%eax
  803506:	f7 f7                	div    %edi
  803508:	31 ff                	xor    %edi,%edi
  80350a:	89 fa                	mov    %edi,%edx
  80350c:	83 c4 1c             	add    $0x1c,%esp
  80350f:	5b                   	pop    %ebx
  803510:	5e                   	pop    %esi
  803511:	5f                   	pop    %edi
  803512:	5d                   	pop    %ebp
  803513:	c3                   	ret    
  803514:	bd 20 00 00 00       	mov    $0x20,%ebp
  803519:	89 eb                	mov    %ebp,%ebx
  80351b:	29 fb                	sub    %edi,%ebx
  80351d:	89 f9                	mov    %edi,%ecx
  80351f:	d3 e6                	shl    %cl,%esi
  803521:	89 c5                	mov    %eax,%ebp
  803523:	88 d9                	mov    %bl,%cl
  803525:	d3 ed                	shr    %cl,%ebp
  803527:	89 e9                	mov    %ebp,%ecx
  803529:	09 f1                	or     %esi,%ecx
  80352b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80352f:	89 f9                	mov    %edi,%ecx
  803531:	d3 e0                	shl    %cl,%eax
  803533:	89 c5                	mov    %eax,%ebp
  803535:	89 d6                	mov    %edx,%esi
  803537:	88 d9                	mov    %bl,%cl
  803539:	d3 ee                	shr    %cl,%esi
  80353b:	89 f9                	mov    %edi,%ecx
  80353d:	d3 e2                	shl    %cl,%edx
  80353f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803543:	88 d9                	mov    %bl,%cl
  803545:	d3 e8                	shr    %cl,%eax
  803547:	09 c2                	or     %eax,%edx
  803549:	89 d0                	mov    %edx,%eax
  80354b:	89 f2                	mov    %esi,%edx
  80354d:	f7 74 24 0c          	divl   0xc(%esp)
  803551:	89 d6                	mov    %edx,%esi
  803553:	89 c3                	mov    %eax,%ebx
  803555:	f7 e5                	mul    %ebp
  803557:	39 d6                	cmp    %edx,%esi
  803559:	72 19                	jb     803574 <__udivdi3+0xfc>
  80355b:	74 0b                	je     803568 <__udivdi3+0xf0>
  80355d:	89 d8                	mov    %ebx,%eax
  80355f:	31 ff                	xor    %edi,%edi
  803561:	e9 58 ff ff ff       	jmp    8034be <__udivdi3+0x46>
  803566:	66 90                	xchg   %ax,%ax
  803568:	8b 54 24 08          	mov    0x8(%esp),%edx
  80356c:	89 f9                	mov    %edi,%ecx
  80356e:	d3 e2                	shl    %cl,%edx
  803570:	39 c2                	cmp    %eax,%edx
  803572:	73 e9                	jae    80355d <__udivdi3+0xe5>
  803574:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803577:	31 ff                	xor    %edi,%edi
  803579:	e9 40 ff ff ff       	jmp    8034be <__udivdi3+0x46>
  80357e:	66 90                	xchg   %ax,%ax
  803580:	31 c0                	xor    %eax,%eax
  803582:	e9 37 ff ff ff       	jmp    8034be <__udivdi3+0x46>
  803587:	90                   	nop

00803588 <__umoddi3>:
  803588:	55                   	push   %ebp
  803589:	57                   	push   %edi
  80358a:	56                   	push   %esi
  80358b:	53                   	push   %ebx
  80358c:	83 ec 1c             	sub    $0x1c,%esp
  80358f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803593:	8b 74 24 34          	mov    0x34(%esp),%esi
  803597:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80359b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80359f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035a7:	89 f3                	mov    %esi,%ebx
  8035a9:	89 fa                	mov    %edi,%edx
  8035ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035af:	89 34 24             	mov    %esi,(%esp)
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	75 1a                	jne    8035d0 <__umoddi3+0x48>
  8035b6:	39 f7                	cmp    %esi,%edi
  8035b8:	0f 86 a2 00 00 00    	jbe    803660 <__umoddi3+0xd8>
  8035be:	89 c8                	mov    %ecx,%eax
  8035c0:	89 f2                	mov    %esi,%edx
  8035c2:	f7 f7                	div    %edi
  8035c4:	89 d0                	mov    %edx,%eax
  8035c6:	31 d2                	xor    %edx,%edx
  8035c8:	83 c4 1c             	add    $0x1c,%esp
  8035cb:	5b                   	pop    %ebx
  8035cc:	5e                   	pop    %esi
  8035cd:	5f                   	pop    %edi
  8035ce:	5d                   	pop    %ebp
  8035cf:	c3                   	ret    
  8035d0:	39 f0                	cmp    %esi,%eax
  8035d2:	0f 87 ac 00 00 00    	ja     803684 <__umoddi3+0xfc>
  8035d8:	0f bd e8             	bsr    %eax,%ebp
  8035db:	83 f5 1f             	xor    $0x1f,%ebp
  8035de:	0f 84 ac 00 00 00    	je     803690 <__umoddi3+0x108>
  8035e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035e9:	29 ef                	sub    %ebp,%edi
  8035eb:	89 fe                	mov    %edi,%esi
  8035ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035f1:	89 e9                	mov    %ebp,%ecx
  8035f3:	d3 e0                	shl    %cl,%eax
  8035f5:	89 d7                	mov    %edx,%edi
  8035f7:	89 f1                	mov    %esi,%ecx
  8035f9:	d3 ef                	shr    %cl,%edi
  8035fb:	09 c7                	or     %eax,%edi
  8035fd:	89 e9                	mov    %ebp,%ecx
  8035ff:	d3 e2                	shl    %cl,%edx
  803601:	89 14 24             	mov    %edx,(%esp)
  803604:	89 d8                	mov    %ebx,%eax
  803606:	d3 e0                	shl    %cl,%eax
  803608:	89 c2                	mov    %eax,%edx
  80360a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80360e:	d3 e0                	shl    %cl,%eax
  803610:	89 44 24 04          	mov    %eax,0x4(%esp)
  803614:	8b 44 24 08          	mov    0x8(%esp),%eax
  803618:	89 f1                	mov    %esi,%ecx
  80361a:	d3 e8                	shr    %cl,%eax
  80361c:	09 d0                	or     %edx,%eax
  80361e:	d3 eb                	shr    %cl,%ebx
  803620:	89 da                	mov    %ebx,%edx
  803622:	f7 f7                	div    %edi
  803624:	89 d3                	mov    %edx,%ebx
  803626:	f7 24 24             	mull   (%esp)
  803629:	89 c6                	mov    %eax,%esi
  80362b:	89 d1                	mov    %edx,%ecx
  80362d:	39 d3                	cmp    %edx,%ebx
  80362f:	0f 82 87 00 00 00    	jb     8036bc <__umoddi3+0x134>
  803635:	0f 84 91 00 00 00    	je     8036cc <__umoddi3+0x144>
  80363b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80363f:	29 f2                	sub    %esi,%edx
  803641:	19 cb                	sbb    %ecx,%ebx
  803643:	89 d8                	mov    %ebx,%eax
  803645:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803649:	d3 e0                	shl    %cl,%eax
  80364b:	89 e9                	mov    %ebp,%ecx
  80364d:	d3 ea                	shr    %cl,%edx
  80364f:	09 d0                	or     %edx,%eax
  803651:	89 e9                	mov    %ebp,%ecx
  803653:	d3 eb                	shr    %cl,%ebx
  803655:	89 da                	mov    %ebx,%edx
  803657:	83 c4 1c             	add    $0x1c,%esp
  80365a:	5b                   	pop    %ebx
  80365b:	5e                   	pop    %esi
  80365c:	5f                   	pop    %edi
  80365d:	5d                   	pop    %ebp
  80365e:	c3                   	ret    
  80365f:	90                   	nop
  803660:	89 fd                	mov    %edi,%ebp
  803662:	85 ff                	test   %edi,%edi
  803664:	75 0b                	jne    803671 <__umoddi3+0xe9>
  803666:	b8 01 00 00 00       	mov    $0x1,%eax
  80366b:	31 d2                	xor    %edx,%edx
  80366d:	f7 f7                	div    %edi
  80366f:	89 c5                	mov    %eax,%ebp
  803671:	89 f0                	mov    %esi,%eax
  803673:	31 d2                	xor    %edx,%edx
  803675:	f7 f5                	div    %ebp
  803677:	89 c8                	mov    %ecx,%eax
  803679:	f7 f5                	div    %ebp
  80367b:	89 d0                	mov    %edx,%eax
  80367d:	e9 44 ff ff ff       	jmp    8035c6 <__umoddi3+0x3e>
  803682:	66 90                	xchg   %ax,%ax
  803684:	89 c8                	mov    %ecx,%eax
  803686:	89 f2                	mov    %esi,%edx
  803688:	83 c4 1c             	add    $0x1c,%esp
  80368b:	5b                   	pop    %ebx
  80368c:	5e                   	pop    %esi
  80368d:	5f                   	pop    %edi
  80368e:	5d                   	pop    %ebp
  80368f:	c3                   	ret    
  803690:	3b 04 24             	cmp    (%esp),%eax
  803693:	72 06                	jb     80369b <__umoddi3+0x113>
  803695:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803699:	77 0f                	ja     8036aa <__umoddi3+0x122>
  80369b:	89 f2                	mov    %esi,%edx
  80369d:	29 f9                	sub    %edi,%ecx
  80369f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036a3:	89 14 24             	mov    %edx,(%esp)
  8036a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036ae:	8b 14 24             	mov    (%esp),%edx
  8036b1:	83 c4 1c             	add    $0x1c,%esp
  8036b4:	5b                   	pop    %ebx
  8036b5:	5e                   	pop    %esi
  8036b6:	5f                   	pop    %edi
  8036b7:	5d                   	pop    %ebp
  8036b8:	c3                   	ret    
  8036b9:	8d 76 00             	lea    0x0(%esi),%esi
  8036bc:	2b 04 24             	sub    (%esp),%eax
  8036bf:	19 fa                	sbb    %edi,%edx
  8036c1:	89 d1                	mov    %edx,%ecx
  8036c3:	89 c6                	mov    %eax,%esi
  8036c5:	e9 71 ff ff ff       	jmp    80363b <__umoddi3+0xb3>
  8036ca:	66 90                	xchg   %ax,%ax
  8036cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036d0:	72 ea                	jb     8036bc <__umoddi3+0x134>
  8036d2:	89 d9                	mov    %ebx,%ecx
  8036d4:	e9 62 ff ff ff       	jmp    80363b <__umoddi3+0xb3>
