
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
  80008c:	68 60 35 80 00       	push   $0x803560
  800091:	6a 12                	push   $0x12
  800093:	68 7c 35 80 00       	push   $0x80357c
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 76 19 00 00       	call   801a18 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 9a 35 80 00       	push   $0x80359a
  8000aa:	50                   	push   %eax
  8000ab:	e8 cb 14 00 00       	call   80157b <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 64 16 00 00       	call   80171f <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 9c 35 80 00       	push   $0x80359c
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 e6 14 00 00       	call   8015bf <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 c0 35 80 00       	push   $0x8035c0
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 2e 16 00 00       	call   80171f <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 d8 35 80 00       	push   $0x8035d8
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 7c 35 80 00       	push   $0x80357c
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 21 1a 00 00       	call   801b3d <inctst>

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
  800125:	e8 d5 18 00 00       	call   8019ff <sys_getenvindex>
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
  800190:	e8 77 16 00 00       	call   80180c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 7c 36 80 00       	push   $0x80367c
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
  8001c0:	68 a4 36 80 00       	push   $0x8036a4
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
  8001f1:	68 cc 36 80 00       	push   $0x8036cc
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 24 37 80 00       	push   $0x803724
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 7c 36 80 00       	push   $0x80367c
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 f7 15 00 00       	call   801826 <sys_enable_interrupt>

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
  800242:	e8 84 17 00 00       	call   8019cb <sys_destroy_env>
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
  800253:	e8 d9 17 00 00       	call   801a31 <sys_exit_env>
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
  80027c:	68 38 37 80 00       	push   $0x803738
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 3d 37 80 00       	push   $0x80373d
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
  8002b9:	68 59 37 80 00       	push   $0x803759
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
  8002e5:	68 5c 37 80 00       	push   $0x80375c
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 a8 37 80 00       	push   $0x8037a8
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
  8003b7:	68 b4 37 80 00       	push   $0x8037b4
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 a8 37 80 00       	push   $0x8037a8
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
  800427:	68 08 38 80 00       	push   $0x803808
  80042c:	6a 44                	push   $0x44
  80042e:	68 a8 37 80 00       	push   $0x8037a8
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
  800481:	e8 d8 11 00 00       	call   80165e <sys_cputs>
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
  8004f8:	e8 61 11 00 00       	call   80165e <sys_cputs>
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
  800542:	e8 c5 12 00 00       	call   80180c <sys_disable_interrupt>
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
  800562:	e8 bf 12 00 00       	call   801826 <sys_enable_interrupt>
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
  8005ac:	e8 33 2d 00 00       	call   8032e4 <__udivdi3>
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
  8005fc:	e8 f3 2d 00 00       	call   8033f4 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 74 3a 80 00       	add    $0x803a74,%eax
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
  800757:	8b 04 85 98 3a 80 00 	mov    0x803a98(,%eax,4),%eax
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
  800838:	8b 34 9d e0 38 80 00 	mov    0x8038e0(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 85 3a 80 00       	push   $0x803a85
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
  80085d:	68 8e 3a 80 00       	push   $0x803a8e
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
  80088a:	be 91 3a 80 00       	mov    $0x803a91,%esi
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
  8012b0:	68 f0 3b 80 00       	push   $0x803bf0
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
  801380:	e8 1d 04 00 00       	call   8017a2 <sys_allocate_chunk>
  801385:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801388:	a1 20 41 80 00       	mov    0x804120,%eax
  80138d:	83 ec 0c             	sub    $0xc,%esp
  801390:	50                   	push   %eax
  801391:	e8 92 0a 00 00       	call   801e28 <initialize_MemBlocksList>
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
  8013be:	68 15 3c 80 00       	push   $0x803c15
  8013c3:	6a 33                	push   $0x33
  8013c5:	68 33 3c 80 00       	push   $0x803c33
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
  80143d:	68 40 3c 80 00       	push   $0x803c40
  801442:	6a 34                	push   $0x34
  801444:	68 33 3c 80 00       	push   $0x803c33
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
  8014b2:	68 64 3c 80 00       	push   $0x803c64
  8014b7:	6a 46                	push   $0x46
  8014b9:	68 33 3c 80 00       	push   $0x803c33
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
  8014ce:	68 8c 3c 80 00       	push   $0x803c8c
  8014d3:	6a 61                	push   $0x61
  8014d5:	68 33 3c 80 00       	push   $0x803c33
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
  8014f4:	75 07                	jne    8014fd <smalloc+0x1e>
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 7c                	jmp    801579 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8014fd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801504:	8b 55 0c             	mov    0xc(%ebp),%edx
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	48                   	dec    %eax
  80150d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801513:	ba 00 00 00 00       	mov    $0x0,%edx
  801518:	f7 75 f0             	divl   -0x10(%ebp)
  80151b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151e:	29 d0                	sub    %edx,%eax
  801520:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801523:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80152a:	e8 41 06 00 00       	call   801b70 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80152f:	85 c0                	test   %eax,%eax
  801531:	74 11                	je     801544 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	ff 75 e8             	pushl  -0x18(%ebp)
  801539:	e8 ac 0c 00 00       	call   8021ea <alloc_block_FF>
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801544:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801548:	74 2a                	je     801574 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80154a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154d:	8b 40 08             	mov    0x8(%eax),%eax
  801550:	89 c2                	mov    %eax,%edx
  801552:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801556:	52                   	push   %edx
  801557:	50                   	push   %eax
  801558:	ff 75 0c             	pushl  0xc(%ebp)
  80155b:	ff 75 08             	pushl  0x8(%ebp)
  80155e:	e8 92 03 00 00       	call   8018f5 <sys_createSharedObject>
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801569:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  80156d:	74 05                	je     801574 <smalloc+0x95>
			return (void*)virtual_address;
  80156f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801572:	eb 05                	jmp    801579 <smalloc+0x9a>
	}
	return NULL;
  801574:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801581:	e8 13 fd ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	68 b0 3c 80 00       	push   $0x803cb0
  80158e:	68 a2 00 00 00       	push   $0xa2
  801593:	68 33 3c 80 00       	push   $0x803c33
  801598:	e8 be ec ff ff       	call   80025b <_panic>

0080159d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a3:	e8 f1 fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	68 d4 3c 80 00       	push   $0x803cd4
  8015b0:	68 e6 00 00 00       	push   $0xe6
  8015b5:	68 33 3c 80 00       	push   $0x803c33
  8015ba:	e8 9c ec ff ff       	call   80025b <_panic>

008015bf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	68 fc 3c 80 00       	push   $0x803cfc
  8015cd:	68 fa 00 00 00       	push   $0xfa
  8015d2:	68 33 3c 80 00       	push   $0x803c33
  8015d7:	e8 7f ec ff ff       	call   80025b <_panic>

008015dc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015e2:	83 ec 04             	sub    $0x4,%esp
  8015e5:	68 20 3d 80 00       	push   $0x803d20
  8015ea:	68 05 01 00 00       	push   $0x105
  8015ef:	68 33 3c 80 00       	push   $0x803c33
  8015f4:	e8 62 ec ff ff       	call   80025b <_panic>

008015f9 <shrink>:

}
void shrink(uint32 newSize)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	68 20 3d 80 00       	push   $0x803d20
  801607:	68 0a 01 00 00       	push   $0x10a
  80160c:	68 33 3c 80 00       	push   $0x803c33
  801611:	e8 45 ec ff ff       	call   80025b <_panic>

00801616 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80161c:	83 ec 04             	sub    $0x4,%esp
  80161f:	68 20 3d 80 00       	push   $0x803d20
  801624:	68 0f 01 00 00       	push   $0x10f
  801629:	68 33 3c 80 00       	push   $0x803c33
  80162e:	e8 28 ec ff ff       	call   80025b <_panic>

00801633 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	57                   	push   %edi
  801637:	56                   	push   %esi
  801638:	53                   	push   %ebx
  801639:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80163c:	8b 45 08             	mov    0x8(%ebp),%eax
  80163f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801642:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801645:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801648:	8b 7d 18             	mov    0x18(%ebp),%edi
  80164b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80164e:	cd 30                	int    $0x30
  801650:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801653:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	5b                   	pop    %ebx
  80165a:	5e                   	pop    %esi
  80165b:	5f                   	pop    %edi
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    

0080165e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80166a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	52                   	push   %edx
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	50                   	push   %eax
  80167a:	6a 00                	push   $0x0
  80167c:	e8 b2 ff ff ff       	call   801633 <syscall>
  801681:	83 c4 18             	add    $0x18,%esp
}
  801684:	90                   	nop
  801685:	c9                   	leave  
  801686:	c3                   	ret    

00801687 <sys_cgetc>:

int
sys_cgetc(void)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80168a:	6a 00                	push   $0x0
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	6a 00                	push   $0x0
  801694:	6a 01                	push   $0x1
  801696:	e8 98 ff ff ff       	call   801633 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	6a 00                	push   $0x0
  8016af:	52                   	push   %edx
  8016b0:	50                   	push   %eax
  8016b1:	6a 05                	push   $0x5
  8016b3:	e8 7b ff ff ff       	call   801633 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
  8016c0:	56                   	push   %esi
  8016c1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016c2:	8b 75 18             	mov    0x18(%ebp),%esi
  8016c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	56                   	push   %esi
  8016d2:	53                   	push   %ebx
  8016d3:	51                   	push   %ecx
  8016d4:	52                   	push   %edx
  8016d5:	50                   	push   %eax
  8016d6:	6a 06                	push   $0x6
  8016d8:	e8 56 ff ff ff       	call   801633 <syscall>
  8016dd:	83 c4 18             	add    $0x18,%esp
}
  8016e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016e3:	5b                   	pop    %ebx
  8016e4:	5e                   	pop    %esi
  8016e5:	5d                   	pop    %ebp
  8016e6:	c3                   	ret    

008016e7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016e7:	55                   	push   %ebp
  8016e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8016ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	52                   	push   %edx
  8016f7:	50                   	push   %eax
  8016f8:	6a 07                	push   $0x7
  8016fa:	e8 34 ff ff ff       	call   801633 <syscall>
  8016ff:	83 c4 18             	add    $0x18,%esp
}
  801702:	c9                   	leave  
  801703:	c3                   	ret    

00801704 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	6a 00                	push   $0x0
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	ff 75 08             	pushl  0x8(%ebp)
  801713:	6a 08                	push   $0x8
  801715:	e8 19 ff ff ff       	call   801633 <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 09                	push   $0x9
  80172e:	e8 00 ff ff ff       	call   801633 <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 0a                	push   $0xa
  801747:	e8 e7 fe ff ff       	call   801633 <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 0b                	push   $0xb
  801760:	e8 ce fe ff ff       	call   801633 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
}
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80176d:	6a 00                	push   $0x0
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	6a 0f                	push   $0xf
  80177b:	e8 b3 fe ff ff       	call   801633 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
	return;
  801783:	90                   	nop
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	6a 10                	push   $0x10
  801797:	e8 97 fe ff ff       	call   801633 <syscall>
  80179c:	83 c4 18             	add    $0x18,%esp
	return ;
  80179f:	90                   	nop
}
  8017a0:	c9                   	leave  
  8017a1:	c3                   	ret    

008017a2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	ff 75 10             	pushl  0x10(%ebp)
  8017ac:	ff 75 0c             	pushl  0xc(%ebp)
  8017af:	ff 75 08             	pushl  0x8(%ebp)
  8017b2:	6a 11                	push   $0x11
  8017b4:	e8 7a fe ff ff       	call   801633 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017bc:	90                   	nop
}
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 0c                	push   $0xc
  8017ce:	e8 60 fe ff ff       	call   801633 <syscall>
  8017d3:	83 c4 18             	add    $0x18,%esp
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	6a 0d                	push   $0xd
  8017e8:	e8 46 fe ff ff       	call   801633 <syscall>
  8017ed:	83 c4 18             	add    $0x18,%esp
}
  8017f0:	c9                   	leave  
  8017f1:	c3                   	ret    

008017f2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 0e                	push   $0xe
  801801:	e8 2d fe ff ff       	call   801633 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
}
  801809:	90                   	nop
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 13                	push   $0x13
  80181b:	e8 13 fe ff ff       	call   801633 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	90                   	nop
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 14                	push   $0x14
  801835:	e8 f9 fd ff ff       	call   801633 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	90                   	nop
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sys_cputc>:


void
sys_cputc(const char c)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 04             	sub    $0x4,%esp
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80184c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	50                   	push   %eax
  801859:	6a 15                	push   $0x15
  80185b:	e8 d3 fd ff ff       	call   801633 <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	90                   	nop
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 16                	push   $0x16
  801875:	e8 b9 fd ff ff       	call   801633 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	90                   	nop
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	50                   	push   %eax
  801890:	6a 17                	push   $0x17
  801892:	e8 9c fd ff ff       	call   801633 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80189f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 1a                	push   $0x1a
  8018af:	e8 7f fd ff ff       	call   801633 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	52                   	push   %edx
  8018c9:	50                   	push   %eax
  8018ca:	6a 18                	push   $0x18
  8018cc:	e8 62 fd ff ff       	call   801633 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	90                   	nop
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	52                   	push   %edx
  8018e7:	50                   	push   %eax
  8018e8:	6a 19                	push   $0x19
  8018ea:	e8 44 fd ff ff       	call   801633 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	90                   	nop
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801901:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801904:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	51                   	push   %ecx
  80190e:	52                   	push   %edx
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	50                   	push   %eax
  801913:	6a 1b                	push   $0x1b
  801915:	e8 19 fd ff ff       	call   801633 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	6a 1c                	push   $0x1c
  801932:	e8 fc fc ff ff       	call   801633 <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80193f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801942:	8b 55 0c             	mov    0xc(%ebp),%edx
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	51                   	push   %ecx
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	6a 1d                	push   $0x1d
  801951:	e8 dd fc ff ff       	call   801633 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	6a 1e                	push   $0x1e
  80196e:	e8 c0 fc ff ff       	call   801633 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 1f                	push   $0x1f
  801987:	e8 a7 fc ff ff       	call   801633 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	6a 00                	push   $0x0
  801999:	ff 75 14             	pushl  0x14(%ebp)
  80199c:	ff 75 10             	pushl  0x10(%ebp)
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	50                   	push   %eax
  8019a3:	6a 20                	push   $0x20
  8019a5:	e8 89 fc ff ff       	call   801633 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	50                   	push   %eax
  8019be:	6a 21                	push   $0x21
  8019c0:	e8 6e fc ff ff       	call   801633 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	90                   	nop
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	50                   	push   %eax
  8019da:	6a 22                	push   $0x22
  8019dc:	e8 52 fc ff ff       	call   801633 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 02                	push   $0x2
  8019f5:	e8 39 fc ff ff       	call   801633 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 03                	push   $0x3
  801a0e:	e8 20 fc ff ff       	call   801633 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 04                	push   $0x4
  801a27:	e8 07 fc ff ff       	call   801633 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_exit_env>:


void sys_exit_env(void)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 23                	push   $0x23
  801a40:	e8 ee fb ff ff       	call   801633 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a51:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a54:	8d 50 04             	lea    0x4(%eax),%edx
  801a57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	52                   	push   %edx
  801a61:	50                   	push   %eax
  801a62:	6a 24                	push   $0x24
  801a64:	e8 ca fb ff ff       	call   801633 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
	return result;
  801a6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a75:	89 01                	mov    %eax,(%ecx)
  801a77:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	c9                   	leave  
  801a7e:	c2 04 00             	ret    $0x4

00801a81 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	ff 75 10             	pushl  0x10(%ebp)
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	ff 75 08             	pushl  0x8(%ebp)
  801a91:	6a 12                	push   $0x12
  801a93:	e8 9b fb ff ff       	call   801633 <syscall>
  801a98:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9b:	90                   	nop
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_rcr2>:
uint32 sys_rcr2()
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 25                	push   $0x25
  801aad:	e8 81 fb ff ff       	call   801633 <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	83 ec 04             	sub    $0x4,%esp
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ac3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	50                   	push   %eax
  801ad0:	6a 26                	push   $0x26
  801ad2:	e8 5c fb ff ff       	call   801633 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
	return ;
  801ada:	90                   	nop
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <rsttst>:
void rsttst()
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 28                	push   $0x28
  801aec:	e8 42 fb ff ff       	call   801633 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
	return ;
  801af4:	90                   	nop
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b03:	8b 55 18             	mov    0x18(%ebp),%edx
  801b06:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	ff 75 10             	pushl  0x10(%ebp)
  801b0f:	ff 75 0c             	pushl  0xc(%ebp)
  801b12:	ff 75 08             	pushl  0x8(%ebp)
  801b15:	6a 27                	push   $0x27
  801b17:	e8 17 fb ff ff       	call   801633 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1f:	90                   	nop
}
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <chktst>:
void chktst(uint32 n)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	ff 75 08             	pushl  0x8(%ebp)
  801b30:	6a 29                	push   $0x29
  801b32:	e8 fc fa ff ff       	call   801633 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3a:	90                   	nop
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <inctst>:

void inctst()
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 2a                	push   $0x2a
  801b4c:	e8 e2 fa ff ff       	call   801633 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
	return ;
  801b54:	90                   	nop
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <gettst>:
uint32 gettst()
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 2b                	push   $0x2b
  801b66:	e8 c8 fa ff ff       	call   801633 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 2c                	push   $0x2c
  801b82:	e8 ac fa ff ff       	call   801633 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
  801b8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b8d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b91:	75 07                	jne    801b9a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b93:	b8 01 00 00 00       	mov    $0x1,%eax
  801b98:	eb 05                	jmp    801b9f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 2c                	push   $0x2c
  801bb3:	e8 7b fa ff ff       	call   801633 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
  801bbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bbe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bc2:	75 07                	jne    801bcb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bc4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc9:	eb 05                	jmp    801bd0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
  801bd5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 2c                	push   $0x2c
  801be4:	e8 4a fa ff ff       	call   801633 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
  801bec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801bef:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801bf3:	75 07                	jne    801bfc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801bf5:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfa:	eb 05                	jmp    801c01 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801bfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 2c                	push   $0x2c
  801c15:	e8 19 fa ff ff       	call   801633 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
  801c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c20:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c24:	75 07                	jne    801c2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	eb 05                	jmp    801c32 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	ff 75 08             	pushl  0x8(%ebp)
  801c42:	6a 2d                	push   $0x2d
  801c44:	e8 ea f9 ff ff       	call   801633 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4c:	90                   	nop
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c53:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	6a 00                	push   $0x0
  801c61:	53                   	push   %ebx
  801c62:	51                   	push   %ecx
  801c63:	52                   	push   %edx
  801c64:	50                   	push   %eax
  801c65:	6a 2e                	push   $0x2e
  801c67:	e8 c7 f9 ff ff       	call   801633 <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
}
  801c6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	52                   	push   %edx
  801c84:	50                   	push   %eax
  801c85:	6a 2f                	push   $0x2f
  801c87:	e8 a7 f9 ff ff       	call   801633 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	68 30 3d 80 00       	push   $0x803d30
  801c9f:	e8 6b e8 ff ff       	call   80050f <cprintf>
  801ca4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ca7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cae:	83 ec 0c             	sub    $0xc,%esp
  801cb1:	68 5c 3d 80 00       	push   $0x803d5c
  801cb6:	e8 54 e8 ff ff       	call   80050f <cprintf>
  801cbb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cbe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cc2:	a1 38 41 80 00       	mov    0x804138,%eax
  801cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cca:	eb 56                	jmp    801d22 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ccc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cd0:	74 1c                	je     801cee <print_mem_block_lists+0x5d>
  801cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd5:	8b 50 08             	mov    0x8(%eax),%edx
  801cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cdb:	8b 48 08             	mov    0x8(%eax),%ecx
  801cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce4:	01 c8                	add    %ecx,%eax
  801ce6:	39 c2                	cmp    %eax,%edx
  801ce8:	73 04                	jae    801cee <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801cea:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf1:	8b 50 08             	mov    0x8(%eax),%edx
  801cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfa:	01 c2                	add    %eax,%edx
  801cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cff:	8b 40 08             	mov    0x8(%eax),%eax
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	52                   	push   %edx
  801d06:	50                   	push   %eax
  801d07:	68 71 3d 80 00       	push   $0x803d71
  801d0c:	e8 fe e7 ff ff       	call   80050f <cprintf>
  801d11:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d1a:	a1 40 41 80 00       	mov    0x804140,%eax
  801d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d26:	74 07                	je     801d2f <print_mem_block_lists+0x9e>
  801d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2b:	8b 00                	mov    (%eax),%eax
  801d2d:	eb 05                	jmp    801d34 <print_mem_block_lists+0xa3>
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d34:	a3 40 41 80 00       	mov    %eax,0x804140
  801d39:	a1 40 41 80 00       	mov    0x804140,%eax
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	75 8a                	jne    801ccc <print_mem_block_lists+0x3b>
  801d42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d46:	75 84                	jne    801ccc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d48:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d4c:	75 10                	jne    801d5e <print_mem_block_lists+0xcd>
  801d4e:	83 ec 0c             	sub    $0xc,%esp
  801d51:	68 80 3d 80 00       	push   $0x803d80
  801d56:	e8 b4 e7 ff ff       	call   80050f <cprintf>
  801d5b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	68 a4 3d 80 00       	push   $0x803da4
  801d6d:	e8 9d e7 ff ff       	call   80050f <cprintf>
  801d72:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d75:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d79:	a1 40 40 80 00       	mov    0x804040,%eax
  801d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d81:	eb 56                	jmp    801dd9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d87:	74 1c                	je     801da5 <print_mem_block_lists+0x114>
  801d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8c:	8b 50 08             	mov    0x8(%eax),%edx
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d92:	8b 48 08             	mov    0x8(%eax),%ecx
  801d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d98:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9b:	01 c8                	add    %ecx,%eax
  801d9d:	39 c2                	cmp    %eax,%edx
  801d9f:	73 04                	jae    801da5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801da1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da8:	8b 50 08             	mov    0x8(%eax),%edx
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	8b 40 0c             	mov    0xc(%eax),%eax
  801db1:	01 c2                	add    %eax,%edx
  801db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db6:	8b 40 08             	mov    0x8(%eax),%eax
  801db9:	83 ec 04             	sub    $0x4,%esp
  801dbc:	52                   	push   %edx
  801dbd:	50                   	push   %eax
  801dbe:	68 71 3d 80 00       	push   $0x803d71
  801dc3:	e8 47 e7 ff ff       	call   80050f <cprintf>
  801dc8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dd1:	a1 48 40 80 00       	mov    0x804048,%eax
  801dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ddd:	74 07                	je     801de6 <print_mem_block_lists+0x155>
  801ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de2:	8b 00                	mov    (%eax),%eax
  801de4:	eb 05                	jmp    801deb <print_mem_block_lists+0x15a>
  801de6:	b8 00 00 00 00       	mov    $0x0,%eax
  801deb:	a3 48 40 80 00       	mov    %eax,0x804048
  801df0:	a1 48 40 80 00       	mov    0x804048,%eax
  801df5:	85 c0                	test   %eax,%eax
  801df7:	75 8a                	jne    801d83 <print_mem_block_lists+0xf2>
  801df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dfd:	75 84                	jne    801d83 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dff:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e03:	75 10                	jne    801e15 <print_mem_block_lists+0x184>
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	68 bc 3d 80 00       	push   $0x803dbc
  801e0d:	e8 fd e6 ff ff       	call   80050f <cprintf>
  801e12:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e15:	83 ec 0c             	sub    $0xc,%esp
  801e18:	68 30 3d 80 00       	push   $0x803d30
  801e1d:	e8 ed e6 ff ff       	call   80050f <cprintf>
  801e22:	83 c4 10             	add    $0x10,%esp

}
  801e25:	90                   	nop
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e2e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e35:	00 00 00 
  801e38:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e3f:	00 00 00 
  801e42:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e49:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e53:	e9 9e 00 00 00       	jmp    801ef6 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e58:	a1 50 40 80 00       	mov    0x804050,%eax
  801e5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e60:	c1 e2 04             	shl    $0x4,%edx
  801e63:	01 d0                	add    %edx,%eax
  801e65:	85 c0                	test   %eax,%eax
  801e67:	75 14                	jne    801e7d <initialize_MemBlocksList+0x55>
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	68 e4 3d 80 00       	push   $0x803de4
  801e71:	6a 46                	push   $0x46
  801e73:	68 07 3e 80 00       	push   $0x803e07
  801e78:	e8 de e3 ff ff       	call   80025b <_panic>
  801e7d:	a1 50 40 80 00       	mov    0x804050,%eax
  801e82:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e85:	c1 e2 04             	shl    $0x4,%edx
  801e88:	01 d0                	add    %edx,%eax
  801e8a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e90:	89 10                	mov    %edx,(%eax)
  801e92:	8b 00                	mov    (%eax),%eax
  801e94:	85 c0                	test   %eax,%eax
  801e96:	74 18                	je     801eb0 <initialize_MemBlocksList+0x88>
  801e98:	a1 48 41 80 00       	mov    0x804148,%eax
  801e9d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ea3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ea6:	c1 e1 04             	shl    $0x4,%ecx
  801ea9:	01 ca                	add    %ecx,%edx
  801eab:	89 50 04             	mov    %edx,0x4(%eax)
  801eae:	eb 12                	jmp    801ec2 <initialize_MemBlocksList+0x9a>
  801eb0:	a1 50 40 80 00       	mov    0x804050,%eax
  801eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb8:	c1 e2 04             	shl    $0x4,%edx
  801ebb:	01 d0                	add    %edx,%eax
  801ebd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ec2:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eca:	c1 e2 04             	shl    $0x4,%edx
  801ecd:	01 d0                	add    %edx,%eax
  801ecf:	a3 48 41 80 00       	mov    %eax,0x804148
  801ed4:	a1 50 40 80 00       	mov    0x804050,%eax
  801ed9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edc:	c1 e2 04             	shl    $0x4,%edx
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ee8:	a1 54 41 80 00       	mov    0x804154,%eax
  801eed:	40                   	inc    %eax
  801eee:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ef3:	ff 45 f4             	incl   -0xc(%ebp)
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	3b 45 08             	cmp    0x8(%ebp),%eax
  801efc:	0f 82 56 ff ff ff    	jb     801e58 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f02:	90                   	nop
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	8b 00                	mov    (%eax),%eax
  801f10:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f13:	eb 19                	jmp    801f2e <find_block+0x29>
	{
		if(va==point->sva)
  801f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f18:	8b 40 08             	mov    0x8(%eax),%eax
  801f1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f1e:	75 05                	jne    801f25 <find_block+0x20>
		   return point;
  801f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f23:	eb 36                	jmp    801f5b <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	8b 40 08             	mov    0x8(%eax),%eax
  801f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f2e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f32:	74 07                	je     801f3b <find_block+0x36>
  801f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f37:	8b 00                	mov    (%eax),%eax
  801f39:	eb 05                	jmp    801f40 <find_block+0x3b>
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f40:	8b 55 08             	mov    0x8(%ebp),%edx
  801f43:	89 42 08             	mov    %eax,0x8(%edx)
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8b 40 08             	mov    0x8(%eax),%eax
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	75 c5                	jne    801f15 <find_block+0x10>
  801f50:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f54:	75 bf                	jne    801f15 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f63:	a1 40 40 80 00       	mov    0x804040,%eax
  801f68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f6b:	a1 44 40 80 00       	mov    0x804044,%eax
  801f70:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f76:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f79:	74 24                	je     801f9f <insert_sorted_allocList+0x42>
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	8b 50 08             	mov    0x8(%eax),%edx
  801f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f84:	8b 40 08             	mov    0x8(%eax),%eax
  801f87:	39 c2                	cmp    %eax,%edx
  801f89:	76 14                	jbe    801f9f <insert_sorted_allocList+0x42>
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	8b 50 08             	mov    0x8(%eax),%edx
  801f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f94:	8b 40 08             	mov    0x8(%eax),%eax
  801f97:	39 c2                	cmp    %eax,%edx
  801f99:	0f 82 60 01 00 00    	jb     8020ff <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa3:	75 65                	jne    80200a <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fa9:	75 14                	jne    801fbf <insert_sorted_allocList+0x62>
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	68 e4 3d 80 00       	push   $0x803de4
  801fb3:	6a 6b                	push   $0x6b
  801fb5:	68 07 3e 80 00       	push   $0x803e07
  801fba:	e8 9c e2 ff ff       	call   80025b <_panic>
  801fbf:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 10                	mov    %edx,(%eax)
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	8b 00                	mov    (%eax),%eax
  801fcf:	85 c0                	test   %eax,%eax
  801fd1:	74 0d                	je     801fe0 <insert_sorted_allocList+0x83>
  801fd3:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd8:	8b 55 08             	mov    0x8(%ebp),%edx
  801fdb:	89 50 04             	mov    %edx,0x4(%eax)
  801fde:	eb 08                	jmp    801fe8 <insert_sorted_allocList+0x8b>
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	a3 44 40 80 00       	mov    %eax,0x804044
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	a3 40 40 80 00       	mov    %eax,0x804040
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ffa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fff:	40                   	inc    %eax
  802000:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802005:	e9 dc 01 00 00       	jmp    8021e6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80200a:	8b 45 08             	mov    0x8(%ebp),%eax
  80200d:	8b 50 08             	mov    0x8(%eax),%edx
  802010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802013:	8b 40 08             	mov    0x8(%eax),%eax
  802016:	39 c2                	cmp    %eax,%edx
  802018:	77 6c                	ja     802086 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80201a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80201e:	74 06                	je     802026 <insert_sorted_allocList+0xc9>
  802020:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802024:	75 14                	jne    80203a <insert_sorted_allocList+0xdd>
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 20 3e 80 00       	push   $0x803e20
  80202e:	6a 6f                	push   $0x6f
  802030:	68 07 3e 80 00       	push   $0x803e07
  802035:	e8 21 e2 ff ff       	call   80025b <_panic>
  80203a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203d:	8b 50 04             	mov    0x4(%eax),%edx
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	89 50 04             	mov    %edx,0x4(%eax)
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80204c:	89 10                	mov    %edx,(%eax)
  80204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802051:	8b 40 04             	mov    0x4(%eax),%eax
  802054:	85 c0                	test   %eax,%eax
  802056:	74 0d                	je     802065 <insert_sorted_allocList+0x108>
  802058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205b:	8b 40 04             	mov    0x4(%eax),%eax
  80205e:	8b 55 08             	mov    0x8(%ebp),%edx
  802061:	89 10                	mov    %edx,(%eax)
  802063:	eb 08                	jmp    80206d <insert_sorted_allocList+0x110>
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	a3 40 40 80 00       	mov    %eax,0x804040
  80206d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802070:	8b 55 08             	mov    0x8(%ebp),%edx
  802073:	89 50 04             	mov    %edx,0x4(%eax)
  802076:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80207b:	40                   	inc    %eax
  80207c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802081:	e9 60 01 00 00       	jmp    8021e6 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802086:	8b 45 08             	mov    0x8(%ebp),%eax
  802089:	8b 50 08             	mov    0x8(%eax),%edx
  80208c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80208f:	8b 40 08             	mov    0x8(%eax),%eax
  802092:	39 c2                	cmp    %eax,%edx
  802094:	0f 82 4c 01 00 00    	jb     8021e6 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	75 14                	jne    8020b4 <insert_sorted_allocList+0x157>
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	68 58 3e 80 00       	push   $0x803e58
  8020a8:	6a 73                	push   $0x73
  8020aa:	68 07 3e 80 00       	push   $0x803e07
  8020af:	e8 a7 e1 ff ff       	call   80025b <_panic>
  8020b4:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	89 50 04             	mov    %edx,0x4(%eax)
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	8b 40 04             	mov    0x4(%eax),%eax
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	74 0c                	je     8020d6 <insert_sorted_allocList+0x179>
  8020ca:	a1 44 40 80 00       	mov    0x804044,%eax
  8020cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d2:	89 10                	mov    %edx,(%eax)
  8020d4:	eb 08                	jmp    8020de <insert_sorted_allocList+0x181>
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	a3 40 40 80 00       	mov    %eax,0x804040
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	a3 44 40 80 00       	mov    %eax,0x804044
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ef:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f4:	40                   	inc    %eax
  8020f5:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020fa:	e9 e7 00 00 00       	jmp    8021e6 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802102:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802105:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80210c:	a1 40 40 80 00       	mov    0x804040,%eax
  802111:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802114:	e9 9d 00 00 00       	jmp    8021b6 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	8b 50 08             	mov    0x8(%eax),%edx
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 40 08             	mov    0x8(%eax),%eax
  80212d:	39 c2                	cmp    %eax,%edx
  80212f:	76 7d                	jbe    8021ae <insert_sorted_allocList+0x251>
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8b 50 08             	mov    0x8(%eax),%edx
  802137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80213a:	8b 40 08             	mov    0x8(%eax),%eax
  80213d:	39 c2                	cmp    %eax,%edx
  80213f:	73 6d                	jae    8021ae <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802141:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802145:	74 06                	je     80214d <insert_sorted_allocList+0x1f0>
  802147:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214b:	75 14                	jne    802161 <insert_sorted_allocList+0x204>
  80214d:	83 ec 04             	sub    $0x4,%esp
  802150:	68 7c 3e 80 00       	push   $0x803e7c
  802155:	6a 7f                	push   $0x7f
  802157:	68 07 3e 80 00       	push   $0x803e07
  80215c:	e8 fa e0 ff ff       	call   80025b <_panic>
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	8b 10                	mov    (%eax),%edx
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	89 10                	mov    %edx,(%eax)
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8b 00                	mov    (%eax),%eax
  802170:	85 c0                	test   %eax,%eax
  802172:	74 0b                	je     80217f <insert_sorted_allocList+0x222>
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 00                	mov    (%eax),%eax
  802179:	8b 55 08             	mov    0x8(%ebp),%edx
  80217c:	89 50 04             	mov    %edx,0x4(%eax)
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	8b 55 08             	mov    0x8(%ebp),%edx
  802185:	89 10                	mov    %edx,(%eax)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218d:	89 50 04             	mov    %edx,0x4(%eax)
  802190:	8b 45 08             	mov    0x8(%ebp),%eax
  802193:	8b 00                	mov    (%eax),%eax
  802195:	85 c0                	test   %eax,%eax
  802197:	75 08                	jne    8021a1 <insert_sorted_allocList+0x244>
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a6:	40                   	inc    %eax
  8021a7:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021ac:	eb 39                	jmp    8021e7 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021ae:	a1 48 40 80 00       	mov    0x804048,%eax
  8021b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ba:	74 07                	je     8021c3 <insert_sorted_allocList+0x266>
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	8b 00                	mov    (%eax),%eax
  8021c1:	eb 05                	jmp    8021c8 <insert_sorted_allocList+0x26b>
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	a3 48 40 80 00       	mov    %eax,0x804048
  8021cd:	a1 48 40 80 00       	mov    0x804048,%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	0f 85 3f ff ff ff    	jne    802119 <insert_sorted_allocList+0x1bc>
  8021da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021de:	0f 85 35 ff ff ff    	jne    802119 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021e4:	eb 01                	jmp    8021e7 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021e6:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021e7:	90                   	nop
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    

008021ea <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8021f0:	a1 38 41 80 00       	mov    0x804138,%eax
  8021f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f8:	e9 85 01 00 00       	jmp    802382 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	8b 40 0c             	mov    0xc(%eax),%eax
  802203:	3b 45 08             	cmp    0x8(%ebp),%eax
  802206:	0f 82 6e 01 00 00    	jb     80237a <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	8b 40 0c             	mov    0xc(%eax),%eax
  802212:	3b 45 08             	cmp    0x8(%ebp),%eax
  802215:	0f 85 8a 00 00 00    	jne    8022a5 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80221b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221f:	75 17                	jne    802238 <alloc_block_FF+0x4e>
  802221:	83 ec 04             	sub    $0x4,%esp
  802224:	68 b0 3e 80 00       	push   $0x803eb0
  802229:	68 93 00 00 00       	push   $0x93
  80222e:	68 07 3e 80 00       	push   $0x803e07
  802233:	e8 23 e0 ff ff       	call   80025b <_panic>
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 00                	mov    (%eax),%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	74 10                	je     802251 <alloc_block_FF+0x67>
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802249:	8b 52 04             	mov    0x4(%edx),%edx
  80224c:	89 50 04             	mov    %edx,0x4(%eax)
  80224f:	eb 0b                	jmp    80225c <alloc_block_FF+0x72>
  802251:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802254:	8b 40 04             	mov    0x4(%eax),%eax
  802257:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	8b 40 04             	mov    0x4(%eax),%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	74 0f                	je     802275 <alloc_block_FF+0x8b>
  802266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802269:	8b 40 04             	mov    0x4(%eax),%eax
  80226c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226f:	8b 12                	mov    (%edx),%edx
  802271:	89 10                	mov    %edx,(%eax)
  802273:	eb 0a                	jmp    80227f <alloc_block_FF+0x95>
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 00                	mov    (%eax),%eax
  80227a:	a3 38 41 80 00       	mov    %eax,0x804138
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802292:	a1 44 41 80 00       	mov    0x804144,%eax
  802297:	48                   	dec    %eax
  802298:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80229d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a0:	e9 10 01 00 00       	jmp    8023b5 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ae:	0f 86 c6 00 00 00    	jbe    80237a <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022b4:	a1 48 41 80 00       	mov    0x804148,%eax
  8022b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	8b 50 08             	mov    0x8(%eax),%edx
  8022c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c5:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ce:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022d5:	75 17                	jne    8022ee <alloc_block_FF+0x104>
  8022d7:	83 ec 04             	sub    $0x4,%esp
  8022da:	68 b0 3e 80 00       	push   $0x803eb0
  8022df:	68 9b 00 00 00       	push   $0x9b
  8022e4:	68 07 3e 80 00       	push   $0x803e07
  8022e9:	e8 6d df ff ff       	call   80025b <_panic>
  8022ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f1:	8b 00                	mov    (%eax),%eax
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	74 10                	je     802307 <alloc_block_FF+0x11d>
  8022f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022fa:	8b 00                	mov    (%eax),%eax
  8022fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ff:	8b 52 04             	mov    0x4(%edx),%edx
  802302:	89 50 04             	mov    %edx,0x4(%eax)
  802305:	eb 0b                	jmp    802312 <alloc_block_FF+0x128>
  802307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230a:	8b 40 04             	mov    0x4(%eax),%eax
  80230d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802315:	8b 40 04             	mov    0x4(%eax),%eax
  802318:	85 c0                	test   %eax,%eax
  80231a:	74 0f                	je     80232b <alloc_block_FF+0x141>
  80231c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80231f:	8b 40 04             	mov    0x4(%eax),%eax
  802322:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802325:	8b 12                	mov    (%edx),%edx
  802327:	89 10                	mov    %edx,(%eax)
  802329:	eb 0a                	jmp    802335 <alloc_block_FF+0x14b>
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	8b 00                	mov    (%eax),%eax
  802330:	a3 48 41 80 00       	mov    %eax,0x804148
  802335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802338:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80233e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802341:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802348:	a1 54 41 80 00       	mov    0x804154,%eax
  80234d:	48                   	dec    %eax
  80234e:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 50 08             	mov    0x8(%eax),%edx
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	01 c2                	add    %eax,%edx
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 40 0c             	mov    0xc(%eax),%eax
  80236a:	2b 45 08             	sub    0x8(%ebp),%eax
  80236d:	89 c2                	mov    %eax,%edx
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802378:	eb 3b                	jmp    8023b5 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80237a:	a1 40 41 80 00       	mov    0x804140,%eax
  80237f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802386:	74 07                	je     80238f <alloc_block_FF+0x1a5>
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	eb 05                	jmp    802394 <alloc_block_FF+0x1aa>
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
  802394:	a3 40 41 80 00       	mov    %eax,0x804140
  802399:	a1 40 41 80 00       	mov    0x804140,%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	0f 85 57 fe ff ff    	jne    8021fd <alloc_block_FF+0x13>
  8023a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023aa:	0f 85 4d fe ff ff    	jne    8021fd <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023c4:	a1 38 41 80 00       	mov    0x804138,%eax
  8023c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cc:	e9 df 00 00 00       	jmp    8024b0 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023da:	0f 82 c8 00 00 00    	jb     8024a8 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e9:	0f 85 8a 00 00 00    	jne    802479 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8023ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f3:	75 17                	jne    80240c <alloc_block_BF+0x55>
  8023f5:	83 ec 04             	sub    $0x4,%esp
  8023f8:	68 b0 3e 80 00       	push   $0x803eb0
  8023fd:	68 b7 00 00 00       	push   $0xb7
  802402:	68 07 3e 80 00       	push   $0x803e07
  802407:	e8 4f de ff ff       	call   80025b <_panic>
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 00                	mov    (%eax),%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	74 10                	je     802425 <alloc_block_BF+0x6e>
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241d:	8b 52 04             	mov    0x4(%edx),%edx
  802420:	89 50 04             	mov    %edx,0x4(%eax)
  802423:	eb 0b                	jmp    802430 <alloc_block_BF+0x79>
  802425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 0f                	je     802449 <alloc_block_BF+0x92>
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 40 04             	mov    0x4(%eax),%eax
  802440:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802443:	8b 12                	mov    (%edx),%edx
  802445:	89 10                	mov    %edx,(%eax)
  802447:	eb 0a                	jmp    802453 <alloc_block_BF+0x9c>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	a3 38 41 80 00       	mov    %eax,0x804138
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802466:	a1 44 41 80 00       	mov    0x804144,%eax
  80246b:	48                   	dec    %eax
  80246c:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	e9 4d 01 00 00       	jmp    8025c6 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	8b 40 0c             	mov    0xc(%eax),%eax
  80247f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802482:	76 24                	jbe    8024a8 <alloc_block_BF+0xf1>
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80248d:	73 19                	jae    8024a8 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80248f:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 40 0c             	mov    0xc(%eax),%eax
  80249c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 40 08             	mov    0x8(%eax),%eax
  8024a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024a8:	a1 40 41 80 00       	mov    0x804140,%eax
  8024ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b4:	74 07                	je     8024bd <alloc_block_BF+0x106>
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 00                	mov    (%eax),%eax
  8024bb:	eb 05                	jmp    8024c2 <alloc_block_BF+0x10b>
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c2:	a3 40 41 80 00       	mov    %eax,0x804140
  8024c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	0f 85 fd fe ff ff    	jne    8023d1 <alloc_block_BF+0x1a>
  8024d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d8:	0f 85 f3 fe ff ff    	jne    8023d1 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024e2:	0f 84 d9 00 00 00    	je     8025c1 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024e8:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8024f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024f6:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ff:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802502:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802506:	75 17                	jne    80251f <alloc_block_BF+0x168>
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	68 b0 3e 80 00       	push   $0x803eb0
  802510:	68 c7 00 00 00       	push   $0xc7
  802515:	68 07 3e 80 00       	push   $0x803e07
  80251a:	e8 3c dd ff ff       	call   80025b <_panic>
  80251f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802522:	8b 00                	mov    (%eax),%eax
  802524:	85 c0                	test   %eax,%eax
  802526:	74 10                	je     802538 <alloc_block_BF+0x181>
  802528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252b:	8b 00                	mov    (%eax),%eax
  80252d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802530:	8b 52 04             	mov    0x4(%edx),%edx
  802533:	89 50 04             	mov    %edx,0x4(%eax)
  802536:	eb 0b                	jmp    802543 <alloc_block_BF+0x18c>
  802538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253b:	8b 40 04             	mov    0x4(%eax),%eax
  80253e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802546:	8b 40 04             	mov    0x4(%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 0f                	je     80255c <alloc_block_BF+0x1a5>
  80254d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802550:	8b 40 04             	mov    0x4(%eax),%eax
  802553:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802556:	8b 12                	mov    (%edx),%edx
  802558:	89 10                	mov    %edx,(%eax)
  80255a:	eb 0a                	jmp    802566 <alloc_block_BF+0x1af>
  80255c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255f:	8b 00                	mov    (%eax),%eax
  802561:	a3 48 41 80 00       	mov    %eax,0x804148
  802566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802572:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802579:	a1 54 41 80 00       	mov    0x804154,%eax
  80257e:	48                   	dec    %eax
  80257f:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802584:	83 ec 08             	sub    $0x8,%esp
  802587:	ff 75 ec             	pushl  -0x14(%ebp)
  80258a:	68 38 41 80 00       	push   $0x804138
  80258f:	e8 71 f9 ff ff       	call   801f05 <find_block>
  802594:	83 c4 10             	add    $0x10,%esp
  802597:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80259a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259d:	8b 50 08             	mov    0x8(%eax),%edx
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	01 c2                	add    %eax,%edx
  8025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a8:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b4:	89 c2                	mov    %eax,%edx
  8025b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b9:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bf:	eb 05                	jmp    8025c6 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025ce:	a1 28 40 80 00       	mov    0x804028,%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	0f 85 de 01 00 00    	jne    8027b9 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025db:	a1 38 41 80 00       	mov    0x804138,%eax
  8025e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e3:	e9 9e 01 00 00       	jmp    802786 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f1:	0f 82 87 01 00 00    	jb     80277e <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802600:	0f 85 95 00 00 00    	jne    80269b <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260a:	75 17                	jne    802623 <alloc_block_NF+0x5b>
  80260c:	83 ec 04             	sub    $0x4,%esp
  80260f:	68 b0 3e 80 00       	push   $0x803eb0
  802614:	68 e0 00 00 00       	push   $0xe0
  802619:	68 07 3e 80 00       	push   $0x803e07
  80261e:	e8 38 dc ff ff       	call   80025b <_panic>
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 00                	mov    (%eax),%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 10                	je     80263c <alloc_block_NF+0x74>
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802634:	8b 52 04             	mov    0x4(%edx),%edx
  802637:	89 50 04             	mov    %edx,0x4(%eax)
  80263a:	eb 0b                	jmp    802647 <alloc_block_NF+0x7f>
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 40 04             	mov    0x4(%eax),%eax
  802642:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	8b 40 04             	mov    0x4(%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 0f                	je     802660 <alloc_block_NF+0x98>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 40 04             	mov    0x4(%eax),%eax
  802657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265a:	8b 12                	mov    (%edx),%edx
  80265c:	89 10                	mov    %edx,(%eax)
  80265e:	eb 0a                	jmp    80266a <alloc_block_NF+0xa2>
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	a3 38 41 80 00       	mov    %eax,0x804138
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267d:	a1 44 41 80 00       	mov    0x804144,%eax
  802682:	48                   	dec    %eax
  802683:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268b:	8b 40 08             	mov    0x8(%eax),%eax
  80268e:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	e9 f8 04 00 00       	jmp    802b93 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a4:	0f 86 d4 00 00 00    	jbe    80277e <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026aa:	a1 48 41 80 00       	mov    0x804148,%eax
  8026af:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 50 08             	mov    0x8(%eax),%edx
  8026b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bb:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c4:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026cb:	75 17                	jne    8026e4 <alloc_block_NF+0x11c>
  8026cd:	83 ec 04             	sub    $0x4,%esp
  8026d0:	68 b0 3e 80 00       	push   $0x803eb0
  8026d5:	68 e9 00 00 00       	push   $0xe9
  8026da:	68 07 3e 80 00       	push   $0x803e07
  8026df:	e8 77 db ff ff       	call   80025b <_panic>
  8026e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	74 10                	je     8026fd <alloc_block_NF+0x135>
  8026ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f0:	8b 00                	mov    (%eax),%eax
  8026f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f5:	8b 52 04             	mov    0x4(%edx),%edx
  8026f8:	89 50 04             	mov    %edx,0x4(%eax)
  8026fb:	eb 0b                	jmp    802708 <alloc_block_NF+0x140>
  8026fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802700:	8b 40 04             	mov    0x4(%eax),%eax
  802703:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270b:	8b 40 04             	mov    0x4(%eax),%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	74 0f                	je     802721 <alloc_block_NF+0x159>
  802712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802715:	8b 40 04             	mov    0x4(%eax),%eax
  802718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271b:	8b 12                	mov    (%edx),%edx
  80271d:	89 10                	mov    %edx,(%eax)
  80271f:	eb 0a                	jmp    80272b <alloc_block_NF+0x163>
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	a3 48 41 80 00       	mov    %eax,0x804148
  80272b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802737:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273e:	a1 54 41 80 00       	mov    0x804154,%eax
  802743:	48                   	dec    %eax
  802744:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274c:	8b 40 08             	mov    0x8(%eax),%eax
  80274f:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802757:	8b 50 08             	mov    0x8(%eax),%edx
  80275a:	8b 45 08             	mov    0x8(%ebp),%eax
  80275d:	01 c2                	add    %eax,%edx
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 40 0c             	mov    0xc(%eax),%eax
  80276b:	2b 45 08             	sub    0x8(%ebp),%eax
  80276e:	89 c2                	mov    %eax,%edx
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	e9 15 04 00 00       	jmp    802b93 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80277e:	a1 40 41 80 00       	mov    0x804140,%eax
  802783:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278a:	74 07                	je     802793 <alloc_block_NF+0x1cb>
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 00                	mov    (%eax),%eax
  802791:	eb 05                	jmp    802798 <alloc_block_NF+0x1d0>
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
  802798:	a3 40 41 80 00       	mov    %eax,0x804140
  80279d:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	0f 85 3e fe ff ff    	jne    8025e8 <alloc_block_NF+0x20>
  8027aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ae:	0f 85 34 fe ff ff    	jne    8025e8 <alloc_block_NF+0x20>
  8027b4:	e9 d5 03 00 00       	jmp    802b8e <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027b9:	a1 38 41 80 00       	mov    0x804138,%eax
  8027be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c1:	e9 b1 01 00 00       	jmp    802977 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	8b 50 08             	mov    0x8(%eax),%edx
  8027cc:	a1 28 40 80 00       	mov    0x804028,%eax
  8027d1:	39 c2                	cmp    %eax,%edx
  8027d3:	0f 82 96 01 00 00    	jb     80296f <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027e2:	0f 82 87 01 00 00    	jb     80296f <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f1:	0f 85 95 00 00 00    	jne    80288c <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fb:	75 17                	jne    802814 <alloc_block_NF+0x24c>
  8027fd:	83 ec 04             	sub    $0x4,%esp
  802800:	68 b0 3e 80 00       	push   $0x803eb0
  802805:	68 fc 00 00 00       	push   $0xfc
  80280a:	68 07 3e 80 00       	push   $0x803e07
  80280f:	e8 47 da ff ff       	call   80025b <_panic>
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 00                	mov    (%eax),%eax
  802819:	85 c0                	test   %eax,%eax
  80281b:	74 10                	je     80282d <alloc_block_NF+0x265>
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 00                	mov    (%eax),%eax
  802822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802825:	8b 52 04             	mov    0x4(%edx),%edx
  802828:	89 50 04             	mov    %edx,0x4(%eax)
  80282b:	eb 0b                	jmp    802838 <alloc_block_NF+0x270>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 40 04             	mov    0x4(%eax),%eax
  802833:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 40 04             	mov    0x4(%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 0f                	je     802851 <alloc_block_NF+0x289>
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 40 04             	mov    0x4(%eax),%eax
  802848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284b:	8b 12                	mov    (%edx),%edx
  80284d:	89 10                	mov    %edx,(%eax)
  80284f:	eb 0a                	jmp    80285b <alloc_block_NF+0x293>
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 00                	mov    (%eax),%eax
  802856:	a3 38 41 80 00       	mov    %eax,0x804138
  80285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286e:	a1 44 41 80 00       	mov    0x804144,%eax
  802873:	48                   	dec    %eax
  802874:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 08             	mov    0x8(%eax),%eax
  80287f:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	e9 07 03 00 00       	jmp    802b93 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	3b 45 08             	cmp    0x8(%ebp),%eax
  802895:	0f 86 d4 00 00 00    	jbe    80296f <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80289b:	a1 48 41 80 00       	mov    0x804148,%eax
  8028a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a6:	8b 50 08             	mov    0x8(%eax),%edx
  8028a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ac:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028bc:	75 17                	jne    8028d5 <alloc_block_NF+0x30d>
  8028be:	83 ec 04             	sub    $0x4,%esp
  8028c1:	68 b0 3e 80 00       	push   $0x803eb0
  8028c6:	68 04 01 00 00       	push   $0x104
  8028cb:	68 07 3e 80 00       	push   $0x803e07
  8028d0:	e8 86 d9 ff ff       	call   80025b <_panic>
  8028d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d8:	8b 00                	mov    (%eax),%eax
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	74 10                	je     8028ee <alloc_block_NF+0x326>
  8028de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028e6:	8b 52 04             	mov    0x4(%edx),%edx
  8028e9:	89 50 04             	mov    %edx,0x4(%eax)
  8028ec:	eb 0b                	jmp    8028f9 <alloc_block_NF+0x331>
  8028ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f1:	8b 40 04             	mov    0x4(%eax),%eax
  8028f4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 0f                	je     802912 <alloc_block_NF+0x34a>
  802903:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802906:	8b 40 04             	mov    0x4(%eax),%eax
  802909:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290c:	8b 12                	mov    (%edx),%edx
  80290e:	89 10                	mov    %edx,(%eax)
  802910:	eb 0a                	jmp    80291c <alloc_block_NF+0x354>
  802912:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	a3 48 41 80 00       	mov    %eax,0x804148
  80291c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802925:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802928:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292f:	a1 54 41 80 00       	mov    0x804154,%eax
  802934:	48                   	dec    %eax
  802935:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80293a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293d:	8b 40 08             	mov    0x8(%eax),%eax
  802940:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 50 08             	mov    0x8(%eax),%edx
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	01 c2                	add    %eax,%edx
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 40 0c             	mov    0xc(%eax),%eax
  80295c:	2b 45 08             	sub    0x8(%ebp),%eax
  80295f:	89 c2                	mov    %eax,%edx
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296a:	e9 24 02 00 00       	jmp    802b93 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80296f:	a1 40 41 80 00       	mov    0x804140,%eax
  802974:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802977:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297b:	74 07                	je     802984 <alloc_block_NF+0x3bc>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 00                	mov    (%eax),%eax
  802982:	eb 05                	jmp    802989 <alloc_block_NF+0x3c1>
  802984:	b8 00 00 00 00       	mov    $0x0,%eax
  802989:	a3 40 41 80 00       	mov    %eax,0x804140
  80298e:	a1 40 41 80 00       	mov    0x804140,%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	0f 85 2b fe ff ff    	jne    8027c6 <alloc_block_NF+0x1fe>
  80299b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299f:	0f 85 21 fe ff ff    	jne    8027c6 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029a5:	a1 38 41 80 00       	mov    0x804138,%eax
  8029aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ad:	e9 ae 01 00 00       	jmp    802b60 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b5:	8b 50 08             	mov    0x8(%eax),%edx
  8029b8:	a1 28 40 80 00       	mov    0x804028,%eax
  8029bd:	39 c2                	cmp    %eax,%edx
  8029bf:	0f 83 93 01 00 00    	jae    802b58 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ce:	0f 82 84 01 00 00    	jb     802b58 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029da:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029dd:	0f 85 95 00 00 00    	jne    802a78 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e7:	75 17                	jne    802a00 <alloc_block_NF+0x438>
  8029e9:	83 ec 04             	sub    $0x4,%esp
  8029ec:	68 b0 3e 80 00       	push   $0x803eb0
  8029f1:	68 14 01 00 00       	push   $0x114
  8029f6:	68 07 3e 80 00       	push   $0x803e07
  8029fb:	e8 5b d8 ff ff       	call   80025b <_panic>
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 10                	je     802a19 <alloc_block_NF+0x451>
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a11:	8b 52 04             	mov    0x4(%edx),%edx
  802a14:	89 50 04             	mov    %edx,0x4(%eax)
  802a17:	eb 0b                	jmp    802a24 <alloc_block_NF+0x45c>
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	8b 40 04             	mov    0x4(%eax),%eax
  802a1f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	74 0f                	je     802a3d <alloc_block_NF+0x475>
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 04             	mov    0x4(%eax),%eax
  802a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a37:	8b 12                	mov    (%edx),%edx
  802a39:	89 10                	mov    %edx,(%eax)
  802a3b:	eb 0a                	jmp    802a47 <alloc_block_NF+0x47f>
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 00                	mov    (%eax),%eax
  802a42:	a3 38 41 80 00       	mov    %eax,0x804138
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a5f:	48                   	dec    %eax
  802a60:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	8b 40 08             	mov    0x8(%eax),%eax
  802a6b:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	e9 1b 01 00 00       	jmp    802b93 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a81:	0f 86 d1 00 00 00    	jbe    802b58 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a87:	a1 48 41 80 00       	mov    0x804148,%eax
  802a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 50 08             	mov    0x8(%eax),%edx
  802a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a98:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa1:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aa4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa8:	75 17                	jne    802ac1 <alloc_block_NF+0x4f9>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 b0 3e 80 00       	push   $0x803eb0
  802ab2:	68 1c 01 00 00       	push   $0x11c
  802ab7:	68 07 3e 80 00       	push   $0x803e07
  802abc:	e8 9a d7 ff ff       	call   80025b <_panic>
  802ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 10                	je     802ada <alloc_block_NF+0x512>
  802aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ad2:	8b 52 04             	mov    0x4(%edx),%edx
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	eb 0b                	jmp    802ae5 <alloc_block_NF+0x51d>
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ae5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 0f                	je     802afe <alloc_block_NF+0x536>
  802aef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af8:	8b 12                	mov    (%edx),%edx
  802afa:	89 10                	mov    %edx,(%eax)
  802afc:	eb 0a                	jmp    802b08 <alloc_block_NF+0x540>
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	a3 48 41 80 00       	mov    %eax,0x804148
  802b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1b:	a1 54 41 80 00       	mov    0x804154,%eax
  802b20:	48                   	dec    %eax
  802b21:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b29:	8b 40 08             	mov    0x8(%eax),%eax
  802b2c:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 50 08             	mov    0x8(%eax),%edx
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	01 c2                	add    %eax,%edx
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 40 0c             	mov    0xc(%eax),%eax
  802b48:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4b:	89 c2                	mov    %eax,%edx
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b56:	eb 3b                	jmp    802b93 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b58:	a1 40 41 80 00       	mov    0x804140,%eax
  802b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b64:	74 07                	je     802b6d <alloc_block_NF+0x5a5>
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 00                	mov    (%eax),%eax
  802b6b:	eb 05                	jmp    802b72 <alloc_block_NF+0x5aa>
  802b6d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b72:	a3 40 41 80 00       	mov    %eax,0x804140
  802b77:	a1 40 41 80 00       	mov    0x804140,%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	0f 85 2e fe ff ff    	jne    8029b2 <alloc_block_NF+0x3ea>
  802b84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b88:	0f 85 24 fe ff ff    	jne    8029b2 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b93:	c9                   	leave  
  802b94:	c3                   	ret    

00802b95 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b95:	55                   	push   %ebp
  802b96:	89 e5                	mov    %esp,%ebp
  802b98:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b9b:	a1 38 41 80 00       	mov    0x804138,%eax
  802ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802ba3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba8:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bab:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb0:	85 c0                	test   %eax,%eax
  802bb2:	74 14                	je     802bc8 <insert_sorted_with_merge_freeList+0x33>
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	8b 50 08             	mov    0x8(%eax),%edx
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	8b 40 08             	mov    0x8(%eax),%eax
  802bc0:	39 c2                	cmp    %eax,%edx
  802bc2:	0f 87 9b 01 00 00    	ja     802d63 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcc:	75 17                	jne    802be5 <insert_sorted_with_merge_freeList+0x50>
  802bce:	83 ec 04             	sub    $0x4,%esp
  802bd1:	68 e4 3d 80 00       	push   $0x803de4
  802bd6:	68 38 01 00 00       	push   $0x138
  802bdb:	68 07 3e 80 00       	push   $0x803e07
  802be0:	e8 76 d6 ff ff       	call   80025b <_panic>
  802be5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	89 10                	mov    %edx,(%eax)
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	8b 00                	mov    (%eax),%eax
  802bf5:	85 c0                	test   %eax,%eax
  802bf7:	74 0d                	je     802c06 <insert_sorted_with_merge_freeList+0x71>
  802bf9:	a1 38 41 80 00       	mov    0x804138,%eax
  802bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  802c01:	89 50 04             	mov    %edx,0x4(%eax)
  802c04:	eb 08                	jmp    802c0e <insert_sorted_with_merge_freeList+0x79>
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c11:	a3 38 41 80 00       	mov    %eax,0x804138
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c20:	a1 44 41 80 00       	mov    0x804144,%eax
  802c25:	40                   	inc    %eax
  802c26:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c2f:	0f 84 a8 06 00 00    	je     8032dd <insert_sorted_with_merge_freeList+0x748>
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	8b 50 08             	mov    0x8(%eax),%edx
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c41:	01 c2                	add    %eax,%edx
  802c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c46:	8b 40 08             	mov    0x8(%eax),%eax
  802c49:	39 c2                	cmp    %eax,%edx
  802c4b:	0f 85 8c 06 00 00    	jne    8032dd <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 50 0c             	mov    0xc(%eax),%edx
  802c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5d:	01 c2                	add    %eax,%edx
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c69:	75 17                	jne    802c82 <insert_sorted_with_merge_freeList+0xed>
  802c6b:	83 ec 04             	sub    $0x4,%esp
  802c6e:	68 b0 3e 80 00       	push   $0x803eb0
  802c73:	68 3c 01 00 00       	push   $0x13c
  802c78:	68 07 3e 80 00       	push   $0x803e07
  802c7d:	e8 d9 d5 ff ff       	call   80025b <_panic>
  802c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c85:	8b 00                	mov    (%eax),%eax
  802c87:	85 c0                	test   %eax,%eax
  802c89:	74 10                	je     802c9b <insert_sorted_with_merge_freeList+0x106>
  802c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c93:	8b 52 04             	mov    0x4(%edx),%edx
  802c96:	89 50 04             	mov    %edx,0x4(%eax)
  802c99:	eb 0b                	jmp    802ca6 <insert_sorted_with_merge_freeList+0x111>
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 0f                	je     802cbf <insert_sorted_with_merge_freeList+0x12a>
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cb9:	8b 12                	mov    (%edx),%edx
  802cbb:	89 10                	mov    %edx,(%eax)
  802cbd:	eb 0a                	jmp    802cc9 <insert_sorted_with_merge_freeList+0x134>
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	a3 38 41 80 00       	mov    %eax,0x804138
  802cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cdc:	a1 44 41 80 00       	mov    0x804144,%eax
  802ce1:	48                   	dec    %eax
  802ce2:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802cfb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cff:	75 17                	jne    802d18 <insert_sorted_with_merge_freeList+0x183>
  802d01:	83 ec 04             	sub    $0x4,%esp
  802d04:	68 e4 3d 80 00       	push   $0x803de4
  802d09:	68 3f 01 00 00       	push   $0x13f
  802d0e:	68 07 3e 80 00       	push   $0x803e07
  802d13:	e8 43 d5 ff ff       	call   80025b <_panic>
  802d18:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d21:	89 10                	mov    %edx,(%eax)
  802d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 0d                	je     802d39 <insert_sorted_with_merge_freeList+0x1a4>
  802d2c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d31:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d34:	89 50 04             	mov    %edx,0x4(%eax)
  802d37:	eb 08                	jmp    802d41 <insert_sorted_with_merge_freeList+0x1ac>
  802d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d44:	a3 48 41 80 00       	mov    %eax,0x804148
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d53:	a1 54 41 80 00       	mov    0x804154,%eax
  802d58:	40                   	inc    %eax
  802d59:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d5e:	e9 7a 05 00 00       	jmp    8032dd <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	8b 50 08             	mov    0x8(%eax),%edx
  802d69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6c:	8b 40 08             	mov    0x8(%eax),%eax
  802d6f:	39 c2                	cmp    %eax,%edx
  802d71:	0f 82 14 01 00 00    	jb     802e8b <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	8b 50 08             	mov    0x8(%eax),%edx
  802d7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d80:	8b 40 0c             	mov    0xc(%eax),%eax
  802d83:	01 c2                	add    %eax,%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	8b 40 08             	mov    0x8(%eax),%eax
  802d8b:	39 c2                	cmp    %eax,%edx
  802d8d:	0f 85 90 00 00 00    	jne    802e23 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	8b 50 0c             	mov    0xc(%eax),%edx
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9f:	01 c2                	add    %eax,%edx
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbf:	75 17                	jne    802dd8 <insert_sorted_with_merge_freeList+0x243>
  802dc1:	83 ec 04             	sub    $0x4,%esp
  802dc4:	68 e4 3d 80 00       	push   $0x803de4
  802dc9:	68 49 01 00 00       	push   $0x149
  802dce:	68 07 3e 80 00       	push   $0x803e07
  802dd3:	e8 83 d4 ff ff       	call   80025b <_panic>
  802dd8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	89 10                	mov    %edx,(%eax)
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	8b 00                	mov    (%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	74 0d                	je     802df9 <insert_sorted_with_merge_freeList+0x264>
  802dec:	a1 48 41 80 00       	mov    0x804148,%eax
  802df1:	8b 55 08             	mov    0x8(%ebp),%edx
  802df4:	89 50 04             	mov    %edx,0x4(%eax)
  802df7:	eb 08                	jmp    802e01 <insert_sorted_with_merge_freeList+0x26c>
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	a3 48 41 80 00       	mov    %eax,0x804148
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e13:	a1 54 41 80 00       	mov    0x804154,%eax
  802e18:	40                   	inc    %eax
  802e19:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e1e:	e9 bb 04 00 00       	jmp    8032de <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e27:	75 17                	jne    802e40 <insert_sorted_with_merge_freeList+0x2ab>
  802e29:	83 ec 04             	sub    $0x4,%esp
  802e2c:	68 58 3e 80 00       	push   $0x803e58
  802e31:	68 4c 01 00 00       	push   $0x14c
  802e36:	68 07 3e 80 00       	push   $0x803e07
  802e3b:	e8 1b d4 ff ff       	call   80025b <_panic>
  802e40:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	89 50 04             	mov    %edx,0x4(%eax)
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	8b 40 04             	mov    0x4(%eax),%eax
  802e52:	85 c0                	test   %eax,%eax
  802e54:	74 0c                	je     802e62 <insert_sorted_with_merge_freeList+0x2cd>
  802e56:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5e:	89 10                	mov    %edx,(%eax)
  802e60:	eb 08                	jmp    802e6a <insert_sorted_with_merge_freeList+0x2d5>
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	a3 38 41 80 00       	mov    %eax,0x804138
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7b:	a1 44 41 80 00       	mov    0x804144,%eax
  802e80:	40                   	inc    %eax
  802e81:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e86:	e9 53 04 00 00       	jmp    8032de <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e8b:	a1 38 41 80 00       	mov    0x804138,%eax
  802e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e93:	e9 15 04 00 00       	jmp    8032ad <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	8b 50 08             	mov    0x8(%eax),%edx
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 40 08             	mov    0x8(%eax),%eax
  802eac:	39 c2                	cmp    %eax,%edx
  802eae:	0f 86 f1 03 00 00    	jbe    8032a5 <insert_sorted_with_merge_freeList+0x710>
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	8b 50 08             	mov    0x8(%eax),%edx
  802eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebd:	8b 40 08             	mov    0x8(%eax),%eax
  802ec0:	39 c2                	cmp    %eax,%edx
  802ec2:	0f 83 dd 03 00 00    	jae    8032a5 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 50 08             	mov    0x8(%eax),%edx
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed4:	01 c2                	add    %eax,%edx
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 40 08             	mov    0x8(%eax),%eax
  802edc:	39 c2                	cmp    %eax,%edx
  802ede:	0f 85 b9 01 00 00    	jne    80309d <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 50 08             	mov    0x8(%eax),%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef0:	01 c2                	add    %eax,%edx
  802ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
  802ef8:	39 c2                	cmp    %eax,%edx
  802efa:	0f 85 0d 01 00 00    	jne    80300d <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 50 0c             	mov    0xc(%eax),%edx
  802f06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	01 c2                	add    %eax,%edx
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f18:	75 17                	jne    802f31 <insert_sorted_with_merge_freeList+0x39c>
  802f1a:	83 ec 04             	sub    $0x4,%esp
  802f1d:	68 b0 3e 80 00       	push   $0x803eb0
  802f22:	68 5c 01 00 00       	push   $0x15c
  802f27:	68 07 3e 80 00       	push   $0x803e07
  802f2c:	e8 2a d3 ff ff       	call   80025b <_panic>
  802f31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	85 c0                	test   %eax,%eax
  802f38:	74 10                	je     802f4a <insert_sorted_with_merge_freeList+0x3b5>
  802f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3d:	8b 00                	mov    (%eax),%eax
  802f3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f42:	8b 52 04             	mov    0x4(%edx),%edx
  802f45:	89 50 04             	mov    %edx,0x4(%eax)
  802f48:	eb 0b                	jmp    802f55 <insert_sorted_with_merge_freeList+0x3c0>
  802f4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	8b 40 04             	mov    0x4(%eax),%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	74 0f                	je     802f6e <insert_sorted_with_merge_freeList+0x3d9>
  802f5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f62:	8b 40 04             	mov    0x4(%eax),%eax
  802f65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f68:	8b 12                	mov    (%edx),%edx
  802f6a:	89 10                	mov    %edx,(%eax)
  802f6c:	eb 0a                	jmp    802f78 <insert_sorted_with_merge_freeList+0x3e3>
  802f6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	a3 38 41 80 00       	mov    %eax,0x804138
  802f78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8b:	a1 44 41 80 00       	mov    0x804144,%eax
  802f90:	48                   	dec    %eax
  802f91:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802faa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fae:	75 17                	jne    802fc7 <insert_sorted_with_merge_freeList+0x432>
  802fb0:	83 ec 04             	sub    $0x4,%esp
  802fb3:	68 e4 3d 80 00       	push   $0x803de4
  802fb8:	68 5f 01 00 00       	push   $0x15f
  802fbd:	68 07 3e 80 00       	push   $0x803e07
  802fc2:	e8 94 d2 ff ff       	call   80025b <_panic>
  802fc7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd0:	89 10                	mov    %edx,(%eax)
  802fd2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	85 c0                	test   %eax,%eax
  802fd9:	74 0d                	je     802fe8 <insert_sorted_with_merge_freeList+0x453>
  802fdb:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fe3:	89 50 04             	mov    %edx,0x4(%eax)
  802fe6:	eb 08                	jmp    802ff0 <insert_sorted_with_merge_freeList+0x45b>
  802fe8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802feb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803002:	a1 54 41 80 00       	mov    0x804154,%eax
  803007:	40                   	inc    %eax
  803008:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	8b 50 0c             	mov    0xc(%eax),%edx
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	8b 40 0c             	mov    0xc(%eax),%eax
  803019:	01 c2                	add    %eax,%edx
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80302b:	8b 45 08             	mov    0x8(%ebp),%eax
  80302e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803035:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803039:	75 17                	jne    803052 <insert_sorted_with_merge_freeList+0x4bd>
  80303b:	83 ec 04             	sub    $0x4,%esp
  80303e:	68 e4 3d 80 00       	push   $0x803de4
  803043:	68 64 01 00 00       	push   $0x164
  803048:	68 07 3e 80 00       	push   $0x803e07
  80304d:	e8 09 d2 ff ff       	call   80025b <_panic>
  803052:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	89 10                	mov    %edx,(%eax)
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	85 c0                	test   %eax,%eax
  803064:	74 0d                	je     803073 <insert_sorted_with_merge_freeList+0x4de>
  803066:	a1 48 41 80 00       	mov    0x804148,%eax
  80306b:	8b 55 08             	mov    0x8(%ebp),%edx
  80306e:	89 50 04             	mov    %edx,0x4(%eax)
  803071:	eb 08                	jmp    80307b <insert_sorted_with_merge_freeList+0x4e6>
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	a3 48 41 80 00       	mov    %eax,0x804148
  803083:	8b 45 08             	mov    0x8(%ebp),%eax
  803086:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308d:	a1 54 41 80 00       	mov    0x804154,%eax
  803092:	40                   	inc    %eax
  803093:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803098:	e9 41 02 00 00       	jmp    8032de <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 50 08             	mov    0x8(%eax),%edx
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a9:	01 c2                	add    %eax,%edx
  8030ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ae:	8b 40 08             	mov    0x8(%eax),%eax
  8030b1:	39 c2                	cmp    %eax,%edx
  8030b3:	0f 85 7c 01 00 00    	jne    803235 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030bd:	74 06                	je     8030c5 <insert_sorted_with_merge_freeList+0x530>
  8030bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030c3:	75 17                	jne    8030dc <insert_sorted_with_merge_freeList+0x547>
  8030c5:	83 ec 04             	sub    $0x4,%esp
  8030c8:	68 20 3e 80 00       	push   $0x803e20
  8030cd:	68 69 01 00 00       	push   $0x169
  8030d2:	68 07 3e 80 00       	push   $0x803e07
  8030d7:	e8 7f d1 ff ff       	call   80025b <_panic>
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	8b 50 04             	mov    0x4(%eax),%edx
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ee:	89 10                	mov    %edx,(%eax)
  8030f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f3:	8b 40 04             	mov    0x4(%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 0d                	je     803107 <insert_sorted_with_merge_freeList+0x572>
  8030fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fd:	8b 40 04             	mov    0x4(%eax),%eax
  803100:	8b 55 08             	mov    0x8(%ebp),%edx
  803103:	89 10                	mov    %edx,(%eax)
  803105:	eb 08                	jmp    80310f <insert_sorted_with_merge_freeList+0x57a>
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	a3 38 41 80 00       	mov    %eax,0x804138
  80310f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803112:	8b 55 08             	mov    0x8(%ebp),%edx
  803115:	89 50 04             	mov    %edx,0x4(%eax)
  803118:	a1 44 41 80 00       	mov    0x804144,%eax
  80311d:	40                   	inc    %eax
  80311e:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 50 0c             	mov    0xc(%eax),%edx
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	8b 40 0c             	mov    0xc(%eax),%eax
  80312f:	01 c2                	add    %eax,%edx
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803137:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313b:	75 17                	jne    803154 <insert_sorted_with_merge_freeList+0x5bf>
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	68 b0 3e 80 00       	push   $0x803eb0
  803145:	68 6b 01 00 00       	push   $0x16b
  80314a:	68 07 3e 80 00       	push   $0x803e07
  80314f:	e8 07 d1 ff ff       	call   80025b <_panic>
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	74 10                	je     80316d <insert_sorted_with_merge_freeList+0x5d8>
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	8b 00                	mov    (%eax),%eax
  803162:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803165:	8b 52 04             	mov    0x4(%edx),%edx
  803168:	89 50 04             	mov    %edx,0x4(%eax)
  80316b:	eb 0b                	jmp    803178 <insert_sorted_with_merge_freeList+0x5e3>
  80316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803170:	8b 40 04             	mov    0x4(%eax),%eax
  803173:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	8b 40 04             	mov    0x4(%eax),%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	74 0f                	je     803191 <insert_sorted_with_merge_freeList+0x5fc>
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	8b 40 04             	mov    0x4(%eax),%eax
  803188:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318b:	8b 12                	mov    (%edx),%edx
  80318d:	89 10                	mov    %edx,(%eax)
  80318f:	eb 0a                	jmp    80319b <insert_sorted_with_merge_freeList+0x606>
  803191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	a3 38 41 80 00       	mov    %eax,0x804138
  80319b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ae:	a1 44 41 80 00       	mov    0x804144,%eax
  8031b3:	48                   	dec    %eax
  8031b4:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031d1:	75 17                	jne    8031ea <insert_sorted_with_merge_freeList+0x655>
  8031d3:	83 ec 04             	sub    $0x4,%esp
  8031d6:	68 e4 3d 80 00       	push   $0x803de4
  8031db:	68 6e 01 00 00       	push   $0x16e
  8031e0:	68 07 3e 80 00       	push   $0x803e07
  8031e5:	e8 71 d0 ff ff       	call   80025b <_panic>
  8031ea:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f3:	89 10                	mov    %edx,(%eax)
  8031f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	85 c0                	test   %eax,%eax
  8031fc:	74 0d                	je     80320b <insert_sorted_with_merge_freeList+0x676>
  8031fe:	a1 48 41 80 00       	mov    0x804148,%eax
  803203:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803206:	89 50 04             	mov    %edx,0x4(%eax)
  803209:	eb 08                	jmp    803213 <insert_sorted_with_merge_freeList+0x67e>
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803213:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803216:	a3 48 41 80 00       	mov    %eax,0x804148
  80321b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803225:	a1 54 41 80 00       	mov    0x804154,%eax
  80322a:	40                   	inc    %eax
  80322b:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803230:	e9 a9 00 00 00       	jmp    8032de <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803235:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803239:	74 06                	je     803241 <insert_sorted_with_merge_freeList+0x6ac>
  80323b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323f:	75 17                	jne    803258 <insert_sorted_with_merge_freeList+0x6c3>
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 7c 3e 80 00       	push   $0x803e7c
  803249:	68 73 01 00 00       	push   $0x173
  80324e:	68 07 3e 80 00       	push   $0x803e07
  803253:	e8 03 d0 ff ff       	call   80025b <_panic>
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	8b 10                	mov    (%eax),%edx
  80325d:	8b 45 08             	mov    0x8(%ebp),%eax
  803260:	89 10                	mov    %edx,(%eax)
  803262:	8b 45 08             	mov    0x8(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	85 c0                	test   %eax,%eax
  803269:	74 0b                	je     803276 <insert_sorted_with_merge_freeList+0x6e1>
  80326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	8b 55 08             	mov    0x8(%ebp),%edx
  803273:	89 50 04             	mov    %edx,0x4(%eax)
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	8b 55 08             	mov    0x8(%ebp),%edx
  80327c:	89 10                	mov    %edx,(%eax)
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803284:	89 50 04             	mov    %edx,0x4(%eax)
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	75 08                	jne    803298 <insert_sorted_with_merge_freeList+0x703>
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803298:	a1 44 41 80 00       	mov    0x804144,%eax
  80329d:	40                   	inc    %eax
  80329e:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032a3:	eb 39                	jmp    8032de <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032a5:	a1 40 41 80 00       	mov    0x804140,%eax
  8032aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b1:	74 07                	je     8032ba <insert_sorted_with_merge_freeList+0x725>
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	eb 05                	jmp    8032bf <insert_sorted_with_merge_freeList+0x72a>
  8032ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8032bf:	a3 40 41 80 00       	mov    %eax,0x804140
  8032c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	0f 85 c7 fb ff ff    	jne    802e98 <insert_sorted_with_merge_freeList+0x303>
  8032d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d5:	0f 85 bd fb ff ff    	jne    802e98 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032db:	eb 01                	jmp    8032de <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032dd:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032de:	90                   	nop
  8032df:	c9                   	leave  
  8032e0:	c3                   	ret    
  8032e1:	66 90                	xchg   %ax,%ax
  8032e3:	90                   	nop

008032e4 <__udivdi3>:
  8032e4:	55                   	push   %ebp
  8032e5:	57                   	push   %edi
  8032e6:	56                   	push   %esi
  8032e7:	53                   	push   %ebx
  8032e8:	83 ec 1c             	sub    $0x1c,%esp
  8032eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032fb:	89 ca                	mov    %ecx,%edx
  8032fd:	89 f8                	mov    %edi,%eax
  8032ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803303:	85 f6                	test   %esi,%esi
  803305:	75 2d                	jne    803334 <__udivdi3+0x50>
  803307:	39 cf                	cmp    %ecx,%edi
  803309:	77 65                	ja     803370 <__udivdi3+0x8c>
  80330b:	89 fd                	mov    %edi,%ebp
  80330d:	85 ff                	test   %edi,%edi
  80330f:	75 0b                	jne    80331c <__udivdi3+0x38>
  803311:	b8 01 00 00 00       	mov    $0x1,%eax
  803316:	31 d2                	xor    %edx,%edx
  803318:	f7 f7                	div    %edi
  80331a:	89 c5                	mov    %eax,%ebp
  80331c:	31 d2                	xor    %edx,%edx
  80331e:	89 c8                	mov    %ecx,%eax
  803320:	f7 f5                	div    %ebp
  803322:	89 c1                	mov    %eax,%ecx
  803324:	89 d8                	mov    %ebx,%eax
  803326:	f7 f5                	div    %ebp
  803328:	89 cf                	mov    %ecx,%edi
  80332a:	89 fa                	mov    %edi,%edx
  80332c:	83 c4 1c             	add    $0x1c,%esp
  80332f:	5b                   	pop    %ebx
  803330:	5e                   	pop    %esi
  803331:	5f                   	pop    %edi
  803332:	5d                   	pop    %ebp
  803333:	c3                   	ret    
  803334:	39 ce                	cmp    %ecx,%esi
  803336:	77 28                	ja     803360 <__udivdi3+0x7c>
  803338:	0f bd fe             	bsr    %esi,%edi
  80333b:	83 f7 1f             	xor    $0x1f,%edi
  80333e:	75 40                	jne    803380 <__udivdi3+0x9c>
  803340:	39 ce                	cmp    %ecx,%esi
  803342:	72 0a                	jb     80334e <__udivdi3+0x6a>
  803344:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803348:	0f 87 9e 00 00 00    	ja     8033ec <__udivdi3+0x108>
  80334e:	b8 01 00 00 00       	mov    $0x1,%eax
  803353:	89 fa                	mov    %edi,%edx
  803355:	83 c4 1c             	add    $0x1c,%esp
  803358:	5b                   	pop    %ebx
  803359:	5e                   	pop    %esi
  80335a:	5f                   	pop    %edi
  80335b:	5d                   	pop    %ebp
  80335c:	c3                   	ret    
  80335d:	8d 76 00             	lea    0x0(%esi),%esi
  803360:	31 ff                	xor    %edi,%edi
  803362:	31 c0                	xor    %eax,%eax
  803364:	89 fa                	mov    %edi,%edx
  803366:	83 c4 1c             	add    $0x1c,%esp
  803369:	5b                   	pop    %ebx
  80336a:	5e                   	pop    %esi
  80336b:	5f                   	pop    %edi
  80336c:	5d                   	pop    %ebp
  80336d:	c3                   	ret    
  80336e:	66 90                	xchg   %ax,%ax
  803370:	89 d8                	mov    %ebx,%eax
  803372:	f7 f7                	div    %edi
  803374:	31 ff                	xor    %edi,%edi
  803376:	89 fa                	mov    %edi,%edx
  803378:	83 c4 1c             	add    $0x1c,%esp
  80337b:	5b                   	pop    %ebx
  80337c:	5e                   	pop    %esi
  80337d:	5f                   	pop    %edi
  80337e:	5d                   	pop    %ebp
  80337f:	c3                   	ret    
  803380:	bd 20 00 00 00       	mov    $0x20,%ebp
  803385:	89 eb                	mov    %ebp,%ebx
  803387:	29 fb                	sub    %edi,%ebx
  803389:	89 f9                	mov    %edi,%ecx
  80338b:	d3 e6                	shl    %cl,%esi
  80338d:	89 c5                	mov    %eax,%ebp
  80338f:	88 d9                	mov    %bl,%cl
  803391:	d3 ed                	shr    %cl,%ebp
  803393:	89 e9                	mov    %ebp,%ecx
  803395:	09 f1                	or     %esi,%ecx
  803397:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80339b:	89 f9                	mov    %edi,%ecx
  80339d:	d3 e0                	shl    %cl,%eax
  80339f:	89 c5                	mov    %eax,%ebp
  8033a1:	89 d6                	mov    %edx,%esi
  8033a3:	88 d9                	mov    %bl,%cl
  8033a5:	d3 ee                	shr    %cl,%esi
  8033a7:	89 f9                	mov    %edi,%ecx
  8033a9:	d3 e2                	shl    %cl,%edx
  8033ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033af:	88 d9                	mov    %bl,%cl
  8033b1:	d3 e8                	shr    %cl,%eax
  8033b3:	09 c2                	or     %eax,%edx
  8033b5:	89 d0                	mov    %edx,%eax
  8033b7:	89 f2                	mov    %esi,%edx
  8033b9:	f7 74 24 0c          	divl   0xc(%esp)
  8033bd:	89 d6                	mov    %edx,%esi
  8033bf:	89 c3                	mov    %eax,%ebx
  8033c1:	f7 e5                	mul    %ebp
  8033c3:	39 d6                	cmp    %edx,%esi
  8033c5:	72 19                	jb     8033e0 <__udivdi3+0xfc>
  8033c7:	74 0b                	je     8033d4 <__udivdi3+0xf0>
  8033c9:	89 d8                	mov    %ebx,%eax
  8033cb:	31 ff                	xor    %edi,%edi
  8033cd:	e9 58 ff ff ff       	jmp    80332a <__udivdi3+0x46>
  8033d2:	66 90                	xchg   %ax,%ax
  8033d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033d8:	89 f9                	mov    %edi,%ecx
  8033da:	d3 e2                	shl    %cl,%edx
  8033dc:	39 c2                	cmp    %eax,%edx
  8033de:	73 e9                	jae    8033c9 <__udivdi3+0xe5>
  8033e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033e3:	31 ff                	xor    %edi,%edi
  8033e5:	e9 40 ff ff ff       	jmp    80332a <__udivdi3+0x46>
  8033ea:	66 90                	xchg   %ax,%ax
  8033ec:	31 c0                	xor    %eax,%eax
  8033ee:	e9 37 ff ff ff       	jmp    80332a <__udivdi3+0x46>
  8033f3:	90                   	nop

008033f4 <__umoddi3>:
  8033f4:	55                   	push   %ebp
  8033f5:	57                   	push   %edi
  8033f6:	56                   	push   %esi
  8033f7:	53                   	push   %ebx
  8033f8:	83 ec 1c             	sub    $0x1c,%esp
  8033fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803403:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803407:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80340b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80340f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803413:	89 f3                	mov    %esi,%ebx
  803415:	89 fa                	mov    %edi,%edx
  803417:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80341b:	89 34 24             	mov    %esi,(%esp)
  80341e:	85 c0                	test   %eax,%eax
  803420:	75 1a                	jne    80343c <__umoddi3+0x48>
  803422:	39 f7                	cmp    %esi,%edi
  803424:	0f 86 a2 00 00 00    	jbe    8034cc <__umoddi3+0xd8>
  80342a:	89 c8                	mov    %ecx,%eax
  80342c:	89 f2                	mov    %esi,%edx
  80342e:	f7 f7                	div    %edi
  803430:	89 d0                	mov    %edx,%eax
  803432:	31 d2                	xor    %edx,%edx
  803434:	83 c4 1c             	add    $0x1c,%esp
  803437:	5b                   	pop    %ebx
  803438:	5e                   	pop    %esi
  803439:	5f                   	pop    %edi
  80343a:	5d                   	pop    %ebp
  80343b:	c3                   	ret    
  80343c:	39 f0                	cmp    %esi,%eax
  80343e:	0f 87 ac 00 00 00    	ja     8034f0 <__umoddi3+0xfc>
  803444:	0f bd e8             	bsr    %eax,%ebp
  803447:	83 f5 1f             	xor    $0x1f,%ebp
  80344a:	0f 84 ac 00 00 00    	je     8034fc <__umoddi3+0x108>
  803450:	bf 20 00 00 00       	mov    $0x20,%edi
  803455:	29 ef                	sub    %ebp,%edi
  803457:	89 fe                	mov    %edi,%esi
  803459:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80345d:	89 e9                	mov    %ebp,%ecx
  80345f:	d3 e0                	shl    %cl,%eax
  803461:	89 d7                	mov    %edx,%edi
  803463:	89 f1                	mov    %esi,%ecx
  803465:	d3 ef                	shr    %cl,%edi
  803467:	09 c7                	or     %eax,%edi
  803469:	89 e9                	mov    %ebp,%ecx
  80346b:	d3 e2                	shl    %cl,%edx
  80346d:	89 14 24             	mov    %edx,(%esp)
  803470:	89 d8                	mov    %ebx,%eax
  803472:	d3 e0                	shl    %cl,%eax
  803474:	89 c2                	mov    %eax,%edx
  803476:	8b 44 24 08          	mov    0x8(%esp),%eax
  80347a:	d3 e0                	shl    %cl,%eax
  80347c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803480:	8b 44 24 08          	mov    0x8(%esp),%eax
  803484:	89 f1                	mov    %esi,%ecx
  803486:	d3 e8                	shr    %cl,%eax
  803488:	09 d0                	or     %edx,%eax
  80348a:	d3 eb                	shr    %cl,%ebx
  80348c:	89 da                	mov    %ebx,%edx
  80348e:	f7 f7                	div    %edi
  803490:	89 d3                	mov    %edx,%ebx
  803492:	f7 24 24             	mull   (%esp)
  803495:	89 c6                	mov    %eax,%esi
  803497:	89 d1                	mov    %edx,%ecx
  803499:	39 d3                	cmp    %edx,%ebx
  80349b:	0f 82 87 00 00 00    	jb     803528 <__umoddi3+0x134>
  8034a1:	0f 84 91 00 00 00    	je     803538 <__umoddi3+0x144>
  8034a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034ab:	29 f2                	sub    %esi,%edx
  8034ad:	19 cb                	sbb    %ecx,%ebx
  8034af:	89 d8                	mov    %ebx,%eax
  8034b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034b5:	d3 e0                	shl    %cl,%eax
  8034b7:	89 e9                	mov    %ebp,%ecx
  8034b9:	d3 ea                	shr    %cl,%edx
  8034bb:	09 d0                	or     %edx,%eax
  8034bd:	89 e9                	mov    %ebp,%ecx
  8034bf:	d3 eb                	shr    %cl,%ebx
  8034c1:	89 da                	mov    %ebx,%edx
  8034c3:	83 c4 1c             	add    $0x1c,%esp
  8034c6:	5b                   	pop    %ebx
  8034c7:	5e                   	pop    %esi
  8034c8:	5f                   	pop    %edi
  8034c9:	5d                   	pop    %ebp
  8034ca:	c3                   	ret    
  8034cb:	90                   	nop
  8034cc:	89 fd                	mov    %edi,%ebp
  8034ce:	85 ff                	test   %edi,%edi
  8034d0:	75 0b                	jne    8034dd <__umoddi3+0xe9>
  8034d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d7:	31 d2                	xor    %edx,%edx
  8034d9:	f7 f7                	div    %edi
  8034db:	89 c5                	mov    %eax,%ebp
  8034dd:	89 f0                	mov    %esi,%eax
  8034df:	31 d2                	xor    %edx,%edx
  8034e1:	f7 f5                	div    %ebp
  8034e3:	89 c8                	mov    %ecx,%eax
  8034e5:	f7 f5                	div    %ebp
  8034e7:	89 d0                	mov    %edx,%eax
  8034e9:	e9 44 ff ff ff       	jmp    803432 <__umoddi3+0x3e>
  8034ee:	66 90                	xchg   %ax,%ax
  8034f0:	89 c8                	mov    %ecx,%eax
  8034f2:	89 f2                	mov    %esi,%edx
  8034f4:	83 c4 1c             	add    $0x1c,%esp
  8034f7:	5b                   	pop    %ebx
  8034f8:	5e                   	pop    %esi
  8034f9:	5f                   	pop    %edi
  8034fa:	5d                   	pop    %ebp
  8034fb:	c3                   	ret    
  8034fc:	3b 04 24             	cmp    (%esp),%eax
  8034ff:	72 06                	jb     803507 <__umoddi3+0x113>
  803501:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803505:	77 0f                	ja     803516 <__umoddi3+0x122>
  803507:	89 f2                	mov    %esi,%edx
  803509:	29 f9                	sub    %edi,%ecx
  80350b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80350f:	89 14 24             	mov    %edx,(%esp)
  803512:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803516:	8b 44 24 04          	mov    0x4(%esp),%eax
  80351a:	8b 14 24             	mov    (%esp),%edx
  80351d:	83 c4 1c             	add    $0x1c,%esp
  803520:	5b                   	pop    %ebx
  803521:	5e                   	pop    %esi
  803522:	5f                   	pop    %edi
  803523:	5d                   	pop    %ebp
  803524:	c3                   	ret    
  803525:	8d 76 00             	lea    0x0(%esi),%esi
  803528:	2b 04 24             	sub    (%esp),%eax
  80352b:	19 fa                	sbb    %edi,%edx
  80352d:	89 d1                	mov    %edx,%ecx
  80352f:	89 c6                	mov    %eax,%esi
  803531:	e9 71 ff ff ff       	jmp    8034a7 <__umoddi3+0xb3>
  803536:	66 90                	xchg   %ax,%ax
  803538:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80353c:	72 ea                	jb     803528 <__umoddi3+0x134>
  80353e:	89 d9                	mov    %ebx,%ecx
  803540:	e9 62 ff ff ff       	jmp    8034a7 <__umoddi3+0xb3>
