
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
  80008c:	68 a0 35 80 00       	push   $0x8035a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 35 80 00       	push   $0x8035bc
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 c3 19 00 00       	call   801a65 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 da 35 80 00       	push   $0x8035da
  8000aa:	50                   	push   %eax
  8000ab:	e8 18 15 00 00       	call   8015c8 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 b1 16 00 00       	call   80176c <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 dc 35 80 00       	push   $0x8035dc
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 33 15 00 00       	call   80160c <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 00 36 80 00       	push   $0x803600
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 7b 16 00 00       	call   80176c <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 18 36 80 00       	push   $0x803618
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 bc 35 80 00       	push   $0x8035bc
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 6e 1a 00 00       	call   801b8a <inctst>

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
  800125:	e8 22 19 00 00       	call   801a4c <sys_getenvindex>
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
  800190:	e8 c4 16 00 00       	call   801859 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 bc 36 80 00       	push   $0x8036bc
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
  8001c0:	68 e4 36 80 00       	push   $0x8036e4
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
  8001f1:	68 0c 37 80 00       	push   $0x80370c
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 64 37 80 00       	push   $0x803764
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 bc 36 80 00       	push   $0x8036bc
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 44 16 00 00       	call   801873 <sys_enable_interrupt>

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
  800242:	e8 d1 17 00 00       	call   801a18 <sys_destroy_env>
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
  800253:	e8 26 18 00 00       	call   801a7e <sys_exit_env>
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
  80027c:	68 78 37 80 00       	push   $0x803778
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 7d 37 80 00       	push   $0x80377d
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
  8002b9:	68 99 37 80 00       	push   $0x803799
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
  8002e5:	68 9c 37 80 00       	push   $0x80379c
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 e8 37 80 00       	push   $0x8037e8
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
  8003b7:	68 f4 37 80 00       	push   $0x8037f4
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 e8 37 80 00       	push   $0x8037e8
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
  800427:	68 48 38 80 00       	push   $0x803848
  80042c:	6a 44                	push   $0x44
  80042e:	68 e8 37 80 00       	push   $0x8037e8
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
  800481:	e8 25 12 00 00       	call   8016ab <sys_cputs>
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
  8004f8:	e8 ae 11 00 00       	call   8016ab <sys_cputs>
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
  800542:	e8 12 13 00 00       	call   801859 <sys_disable_interrupt>
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
  800562:	e8 0c 13 00 00       	call   801873 <sys_enable_interrupt>
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
  8005ac:	e8 7f 2d 00 00       	call   803330 <__udivdi3>
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
  8005fc:	e8 3f 2e 00 00       	call   803440 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 b4 3a 80 00       	add    $0x803ab4,%eax
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
  800757:	8b 04 85 d8 3a 80 00 	mov    0x803ad8(,%eax,4),%eax
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
  800838:	8b 34 9d 20 39 80 00 	mov    0x803920(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 c5 3a 80 00       	push   $0x803ac5
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
  80085d:	68 ce 3a 80 00       	push   $0x803ace
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
  80088a:	be d1 3a 80 00       	mov    $0x803ad1,%esi
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
  8012b0:	68 30 3c 80 00       	push   $0x803c30
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
  801380:	e8 6a 04 00 00       	call   8017ef <sys_allocate_chunk>
  801385:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801388:	a1 20 41 80 00       	mov    0x804120,%eax
  80138d:	83 ec 0c             	sub    $0xc,%esp
  801390:	50                   	push   %eax
  801391:	e8 df 0a 00 00       	call   801e75 <initialize_MemBlocksList>
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
  8013be:	68 55 3c 80 00       	push   $0x803c55
  8013c3:	6a 33                	push   $0x33
  8013c5:	68 73 3c 80 00       	push   $0x803c73
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
  80143d:	68 80 3c 80 00       	push   $0x803c80
  801442:	6a 34                	push   $0x34
  801444:	68 73 3c 80 00       	push   $0x803c73
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
  8014d5:	e8 e3 06 00 00       	call   801bbd <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	74 11                	je     8014ef <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014de:	83 ec 0c             	sub    $0xc,%esp
  8014e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8014e4:	e8 4e 0d 00 00       	call   802237 <alloc_block_FF>
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
  8014fb:	e8 aa 0a 00 00       	call   801faa <insert_sorted_allocList>
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
  80151b:	68 a4 3c 80 00       	push   $0x803ca4
  801520:	6a 6f                	push   $0x6f
  801522:	68 73 3c 80 00       	push   $0x803c73
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
  801541:	75 07                	jne    80154a <smalloc+0x1e>
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	eb 7c                	jmp    8015c6 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80154a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801551:	8b 55 0c             	mov    0xc(%ebp),%edx
  801554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801557:	01 d0                	add    %edx,%eax
  801559:	48                   	dec    %eax
  80155a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80155d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801560:	ba 00 00 00 00       	mov    $0x0,%edx
  801565:	f7 75 f0             	divl   -0x10(%ebp)
  801568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156b:	29 d0                	sub    %edx,%eax
  80156d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801570:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801577:	e8 41 06 00 00       	call   801bbd <sys_isUHeapPlacementStrategyFIRSTFIT>
  80157c:	85 c0                	test   %eax,%eax
  80157e:	74 11                	je     801591 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801580:	83 ec 0c             	sub    $0xc,%esp
  801583:	ff 75 e8             	pushl  -0x18(%ebp)
  801586:	e8 ac 0c 00 00       	call   802237 <alloc_block_FF>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801595:	74 2a                	je     8015c1 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159a:	8b 40 08             	mov    0x8(%eax),%eax
  80159d:	89 c2                	mov    %eax,%edx
  80159f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015a3:	52                   	push   %edx
  8015a4:	50                   	push   %eax
  8015a5:	ff 75 0c             	pushl  0xc(%ebp)
  8015a8:	ff 75 08             	pushl  0x8(%ebp)
  8015ab:	e8 92 03 00 00       	call   801942 <sys_createSharedObject>
  8015b0:	83 c4 10             	add    $0x10,%esp
  8015b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015b6:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015ba:	74 05                	je     8015c1 <smalloc+0x95>
			return (void*)virtual_address;
  8015bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015bf:	eb 05                	jmp    8015c6 <smalloc+0x9a>
	}
	return NULL;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ce:	e8 c6 fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	68 c8 3c 80 00       	push   $0x803cc8
  8015db:	68 b0 00 00 00       	push   $0xb0
  8015e0:	68 73 3c 80 00       	push   $0x803c73
  8015e5:	e8 71 ec ff ff       	call   80025b <_panic>

008015ea <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f0:	e8 a4 fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015f5:	83 ec 04             	sub    $0x4,%esp
  8015f8:	68 ec 3c 80 00       	push   $0x803cec
  8015fd:	68 f4 00 00 00       	push   $0xf4
  801602:	68 73 3c 80 00       	push   $0x803c73
  801607:	e8 4f ec ff ff       	call   80025b <_panic>

0080160c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801612:	83 ec 04             	sub    $0x4,%esp
  801615:	68 14 3d 80 00       	push   $0x803d14
  80161a:	68 08 01 00 00       	push   $0x108
  80161f:	68 73 3c 80 00       	push   $0x803c73
  801624:	e8 32 ec ff ff       	call   80025b <_panic>

00801629 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80162f:	83 ec 04             	sub    $0x4,%esp
  801632:	68 38 3d 80 00       	push   $0x803d38
  801637:	68 13 01 00 00       	push   $0x113
  80163c:	68 73 3c 80 00       	push   $0x803c73
  801641:	e8 15 ec ff ff       	call   80025b <_panic>

00801646 <shrink>:

}
void shrink(uint32 newSize)
{
  801646:	55                   	push   %ebp
  801647:	89 e5                	mov    %esp,%ebp
  801649:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	68 38 3d 80 00       	push   $0x803d38
  801654:	68 18 01 00 00       	push   $0x118
  801659:	68 73 3c 80 00       	push   $0x803c73
  80165e:	e8 f8 eb ff ff       	call   80025b <_panic>

00801663 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801669:	83 ec 04             	sub    $0x4,%esp
  80166c:	68 38 3d 80 00       	push   $0x803d38
  801671:	68 1d 01 00 00       	push   $0x11d
  801676:	68 73 3c 80 00       	push   $0x803c73
  80167b:	e8 db eb ff ff       	call   80025b <_panic>

00801680 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	57                   	push   %edi
  801684:	56                   	push   %esi
  801685:	53                   	push   %ebx
  801686:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801692:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801695:	8b 7d 18             	mov    0x18(%ebp),%edi
  801698:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80169b:	cd 30                	int    $0x30
  80169d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	5b                   	pop    %ebx
  8016a7:	5e                   	pop    %esi
  8016a8:	5f                   	pop    %edi
  8016a9:	5d                   	pop    %ebp
  8016aa:	c3                   	ret    

008016ab <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016b7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	52                   	push   %edx
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	50                   	push   %eax
  8016c7:	6a 00                	push   $0x0
  8016c9:	e8 b2 ff ff ff       	call   801680 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	90                   	nop
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016d7:	6a 00                	push   $0x0
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 01                	push   $0x1
  8016e3:	e8 98 ff ff ff       	call   801680 <syscall>
  8016e8:	83 c4 18             	add    $0x18,%esp
}
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	52                   	push   %edx
  8016fd:	50                   	push   %eax
  8016fe:	6a 05                	push   $0x5
  801700:	e8 7b ff ff ff       	call   801680 <syscall>
  801705:	83 c4 18             	add    $0x18,%esp
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	56                   	push   %esi
  80170e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80170f:	8b 75 18             	mov    0x18(%ebp),%esi
  801712:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801715:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	56                   	push   %esi
  80171f:	53                   	push   %ebx
  801720:	51                   	push   %ecx
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	6a 06                	push   $0x6
  801725:	e8 56 ff ff ff       	call   801680 <syscall>
  80172a:	83 c4 18             	add    $0x18,%esp
}
  80172d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5d                   	pop    %ebp
  801733:	c3                   	ret    

00801734 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801737:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	52                   	push   %edx
  801744:	50                   	push   %eax
  801745:	6a 07                	push   $0x7
  801747:	e8 34 ff ff ff       	call   801680 <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	ff 75 08             	pushl  0x8(%ebp)
  801760:	6a 08                	push   $0x8
  801762:	e8 19 ff ff ff       	call   801680 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 09                	push   $0x9
  80177b:	e8 00 ff ff ff       	call   801680 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 0a                	push   $0xa
  801794:	e8 e7 fe ff ff       	call   801680 <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 0b                	push   $0xb
  8017ad:	e8 ce fe ff ff       	call   801680 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	ff 75 0c             	pushl  0xc(%ebp)
  8017c3:	ff 75 08             	pushl  0x8(%ebp)
  8017c6:	6a 0f                	push   $0xf
  8017c8:	e8 b3 fe ff ff       	call   801680 <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
	return;
  8017d0:	90                   	nop
}
  8017d1:	c9                   	leave  
  8017d2:	c3                   	ret    

008017d3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	ff 75 08             	pushl  0x8(%ebp)
  8017e2:	6a 10                	push   $0x10
  8017e4:	e8 97 fe ff ff       	call   801680 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8017ec:	90                   	nop
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	ff 75 10             	pushl  0x10(%ebp)
  8017f9:	ff 75 0c             	pushl  0xc(%ebp)
  8017fc:	ff 75 08             	pushl  0x8(%ebp)
  8017ff:	6a 11                	push   $0x11
  801801:	e8 7a fe ff ff       	call   801680 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
	return ;
  801809:	90                   	nop
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 0c                	push   $0xc
  80181b:	e8 60 fe ff ff       	call   801680 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 08             	pushl  0x8(%ebp)
  801833:	6a 0d                	push   $0xd
  801835:	e8 46 fe ff ff       	call   801680 <syscall>
  80183a:	83 c4 18             	add    $0x18,%esp
}
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	6a 00                	push   $0x0
  80184c:	6a 0e                	push   $0xe
  80184e:	e8 2d fe ff ff       	call   801680 <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
}
  801856:	90                   	nop
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 13                	push   $0x13
  801868:	e8 13 fe ff ff       	call   801680 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	90                   	nop
  801871:	c9                   	leave  
  801872:	c3                   	ret    

00801873 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 14                	push   $0x14
  801882:	e8 f9 fd ff ff       	call   801680 <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_cputc>:


void
sys_cputc(const char c)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 04             	sub    $0x4,%esp
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801899:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	50                   	push   %eax
  8018a6:	6a 15                	push   $0x15
  8018a8:	e8 d3 fd ff ff       	call   801680 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	90                   	nop
  8018b1:	c9                   	leave  
  8018b2:	c3                   	ret    

008018b3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 16                	push   $0x16
  8018c2:	e8 b9 fd ff ff       	call   801680 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	90                   	nop
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	50                   	push   %eax
  8018dd:	6a 17                	push   $0x17
  8018df:	e8 9c fd ff ff       	call   801680 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 1a                	push   $0x1a
  8018fc:	e8 7f fd ff ff       	call   801680 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	50                   	push   %eax
  801917:	6a 18                	push   $0x18
  801919:	e8 62 fd ff ff       	call   801680 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	90                   	nop
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	52                   	push   %edx
  801934:	50                   	push   %eax
  801935:	6a 19                	push   $0x19
  801937:	e8 44 fd ff ff       	call   801680 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80194e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801951:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	51                   	push   %ecx
  80195b:	52                   	push   %edx
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	50                   	push   %eax
  801960:	6a 1b                	push   $0x1b
  801962:	e8 19 fd ff ff       	call   801680 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	52                   	push   %edx
  80197c:	50                   	push   %eax
  80197d:	6a 1c                	push   $0x1c
  80197f:	e8 fc fc ff ff       	call   801680 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80198c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	51                   	push   %ecx
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 1d                	push   $0x1d
  80199e:	e8 dd fc ff ff       	call   801680 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	6a 1e                	push   $0x1e
  8019bb:	e8 c0 fc ff ff       	call   801680 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 1f                	push   $0x1f
  8019d4:	e8 a7 fc ff ff       	call   801680 <syscall>
  8019d9:	83 c4 18             	add    $0x18,%esp
}
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 14             	pushl  0x14(%ebp)
  8019e9:	ff 75 10             	pushl  0x10(%ebp)
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 20                	push   $0x20
  8019f2:	e8 89 fc ff ff       	call   801680 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	50                   	push   %eax
  801a0b:	6a 21                	push   $0x21
  801a0d:	e8 6e fc ff ff       	call   801680 <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	90                   	nop
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	50                   	push   %eax
  801a27:	6a 22                	push   $0x22
  801a29:	e8 52 fc ff ff       	call   801680 <syscall>
  801a2e:	83 c4 18             	add    $0x18,%esp
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 02                	push   $0x2
  801a42:	e8 39 fc ff ff       	call   801680 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 03                	push   $0x3
  801a5b:	e8 20 fc ff ff       	call   801680 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 04                	push   $0x4
  801a74:	e8 07 fc ff ff       	call   801680 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_exit_env>:


void sys_exit_env(void)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 23                	push   $0x23
  801a8d:	e8 ee fb ff ff       	call   801680 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
  801a9b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a9e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa1:	8d 50 04             	lea    0x4(%eax),%edx
  801aa4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 24                	push   $0x24
  801ab1:	e8 ca fb ff ff       	call   801680 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
	return result;
  801ab9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801abc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ac2:	89 01                	mov    %eax,(%ecx)
  801ac4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	c9                   	leave  
  801acb:	c2 04 00             	ret    $0x4

00801ace <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	ff 75 10             	pushl  0x10(%ebp)
  801ad8:	ff 75 0c             	pushl  0xc(%ebp)
  801adb:	ff 75 08             	pushl  0x8(%ebp)
  801ade:	6a 12                	push   $0x12
  801ae0:	e8 9b fb ff ff       	call   801680 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae8:	90                   	nop
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <sys_rcr2>:
uint32 sys_rcr2()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 25                	push   $0x25
  801afa:	e8 81 fb ff ff       	call   801680 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b10:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	50                   	push   %eax
  801b1d:	6a 26                	push   $0x26
  801b1f:	e8 5c fb ff ff       	call   801680 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
	return ;
  801b27:	90                   	nop
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <rsttst>:
void rsttst()
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 28                	push   $0x28
  801b39:	e8 42 fb ff ff       	call   801680 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b41:	90                   	nop
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 04             	sub    $0x4,%esp
  801b4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b50:	8b 55 18             	mov    0x18(%ebp),%edx
  801b53:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	ff 75 10             	pushl  0x10(%ebp)
  801b5c:	ff 75 0c             	pushl  0xc(%ebp)
  801b5f:	ff 75 08             	pushl  0x8(%ebp)
  801b62:	6a 27                	push   $0x27
  801b64:	e8 17 fb ff ff       	call   801680 <syscall>
  801b69:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6c:	90                   	nop
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <chktst>:
void chktst(uint32 n)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	ff 75 08             	pushl  0x8(%ebp)
  801b7d:	6a 29                	push   $0x29
  801b7f:	e8 fc fa ff ff       	call   801680 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
	return ;
  801b87:	90                   	nop
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <inctst>:

void inctst()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 2a                	push   $0x2a
  801b99:	e8 e2 fa ff ff       	call   801680 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba1:	90                   	nop
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <gettst>:
uint32 gettst()
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 2b                	push   $0x2b
  801bb3:	e8 c8 fa ff ff       	call   801680 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
  801bc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 2c                	push   $0x2c
  801bcf:	e8 ac fa ff ff       	call   801680 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
  801bd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bda:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bde:	75 07                	jne    801be7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801be0:	b8 01 00 00 00       	mov    $0x1,%eax
  801be5:	eb 05                	jmp    801bec <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 2c                	push   $0x2c
  801c00:	e8 7b fa ff ff       	call   801680 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
  801c08:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c0b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c0f:	75 07                	jne    801c18 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c11:	b8 01 00 00 00       	mov    $0x1,%eax
  801c16:	eb 05                	jmp    801c1d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 2c                	push   $0x2c
  801c31:	e8 4a fa ff ff       	call   801680 <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
  801c39:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c3c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c40:	75 07                	jne    801c49 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c42:	b8 01 00 00 00       	mov    $0x1,%eax
  801c47:	eb 05                	jmp    801c4e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 2c                	push   $0x2c
  801c62:	e8 19 fa ff ff       	call   801680 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
  801c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c6d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c71:	75 07                	jne    801c7a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c73:	b8 01 00 00 00       	mov    $0x1,%eax
  801c78:	eb 05                	jmp    801c7f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	ff 75 08             	pushl  0x8(%ebp)
  801c8f:	6a 2d                	push   $0x2d
  801c91:	e8 ea f9 ff ff       	call   801680 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
	return ;
  801c99:	90                   	nop
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ca0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ca3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	53                   	push   %ebx
  801caf:	51                   	push   %ecx
  801cb0:	52                   	push   %edx
  801cb1:	50                   	push   %eax
  801cb2:	6a 2e                	push   $0x2e
  801cb4:	e8 c7 f9 ff ff       	call   801680 <syscall>
  801cb9:	83 c4 18             	add    $0x18,%esp
}
  801cbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	52                   	push   %edx
  801cd1:	50                   	push   %eax
  801cd2:	6a 2f                	push   $0x2f
  801cd4:	e8 a7 f9 ff ff       	call   801680 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	68 48 3d 80 00       	push   $0x803d48
  801cec:	e8 1e e8 ff ff       	call   80050f <cprintf>
  801cf1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cf4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cfb:	83 ec 0c             	sub    $0xc,%esp
  801cfe:	68 74 3d 80 00       	push   $0x803d74
  801d03:	e8 07 e8 ff ff       	call   80050f <cprintf>
  801d08:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d0b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d0f:	a1 38 41 80 00       	mov    0x804138,%eax
  801d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d17:	eb 56                	jmp    801d6f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d1d:	74 1c                	je     801d3b <print_mem_block_lists+0x5d>
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	8b 50 08             	mov    0x8(%eax),%edx
  801d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d28:	8b 48 08             	mov    0x8(%eax),%ecx
  801d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d31:	01 c8                	add    %ecx,%eax
  801d33:	39 c2                	cmp    %eax,%edx
  801d35:	73 04                	jae    801d3b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d37:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	8b 50 08             	mov    0x8(%eax),%edx
  801d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d44:	8b 40 0c             	mov    0xc(%eax),%eax
  801d47:	01 c2                	add    %eax,%edx
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	8b 40 08             	mov    0x8(%eax),%eax
  801d4f:	83 ec 04             	sub    $0x4,%esp
  801d52:	52                   	push   %edx
  801d53:	50                   	push   %eax
  801d54:	68 89 3d 80 00       	push   $0x803d89
  801d59:	e8 b1 e7 ff ff       	call   80050f <cprintf>
  801d5e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d67:	a1 40 41 80 00       	mov    0x804140,%eax
  801d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d73:	74 07                	je     801d7c <print_mem_block_lists+0x9e>
  801d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d78:	8b 00                	mov    (%eax),%eax
  801d7a:	eb 05                	jmp    801d81 <print_mem_block_lists+0xa3>
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d81:	a3 40 41 80 00       	mov    %eax,0x804140
  801d86:	a1 40 41 80 00       	mov    0x804140,%eax
  801d8b:	85 c0                	test   %eax,%eax
  801d8d:	75 8a                	jne    801d19 <print_mem_block_lists+0x3b>
  801d8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d93:	75 84                	jne    801d19 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d95:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d99:	75 10                	jne    801dab <print_mem_block_lists+0xcd>
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	68 98 3d 80 00       	push   $0x803d98
  801da3:	e8 67 e7 ff ff       	call   80050f <cprintf>
  801da8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801db2:	83 ec 0c             	sub    $0xc,%esp
  801db5:	68 bc 3d 80 00       	push   $0x803dbc
  801dba:	e8 50 e7 ff ff       	call   80050f <cprintf>
  801dbf:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dc2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801dc6:	a1 40 40 80 00       	mov    0x804040,%eax
  801dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dce:	eb 56                	jmp    801e26 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd4:	74 1c                	je     801df2 <print_mem_block_lists+0x114>
  801dd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd9:	8b 50 08             	mov    0x8(%eax),%edx
  801ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddf:	8b 48 08             	mov    0x8(%eax),%ecx
  801de2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de5:	8b 40 0c             	mov    0xc(%eax),%eax
  801de8:	01 c8                	add    %ecx,%eax
  801dea:	39 c2                	cmp    %eax,%edx
  801dec:	73 04                	jae    801df2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dee:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	8b 50 08             	mov    0x8(%eax),%edx
  801df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfe:	01 c2                	add    %eax,%edx
  801e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e03:	8b 40 08             	mov    0x8(%eax),%eax
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	52                   	push   %edx
  801e0a:	50                   	push   %eax
  801e0b:	68 89 3d 80 00       	push   $0x803d89
  801e10:	e8 fa e6 ff ff       	call   80050f <cprintf>
  801e15:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e1e:	a1 48 40 80 00       	mov    0x804048,%eax
  801e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e26:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e2a:	74 07                	je     801e33 <print_mem_block_lists+0x155>
  801e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2f:	8b 00                	mov    (%eax),%eax
  801e31:	eb 05                	jmp    801e38 <print_mem_block_lists+0x15a>
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
  801e38:	a3 48 40 80 00       	mov    %eax,0x804048
  801e3d:	a1 48 40 80 00       	mov    0x804048,%eax
  801e42:	85 c0                	test   %eax,%eax
  801e44:	75 8a                	jne    801dd0 <print_mem_block_lists+0xf2>
  801e46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e4a:	75 84                	jne    801dd0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e4c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e50:	75 10                	jne    801e62 <print_mem_block_lists+0x184>
  801e52:	83 ec 0c             	sub    $0xc,%esp
  801e55:	68 d4 3d 80 00       	push   $0x803dd4
  801e5a:	e8 b0 e6 ff ff       	call   80050f <cprintf>
  801e5f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e62:	83 ec 0c             	sub    $0xc,%esp
  801e65:	68 48 3d 80 00       	push   $0x803d48
  801e6a:	e8 a0 e6 ff ff       	call   80050f <cprintf>
  801e6f:	83 c4 10             	add    $0x10,%esp

}
  801e72:	90                   	nop
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e7b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e82:	00 00 00 
  801e85:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e8c:	00 00 00 
  801e8f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e96:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ea0:	e9 9e 00 00 00       	jmp    801f43 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ea5:	a1 50 40 80 00       	mov    0x804050,%eax
  801eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ead:	c1 e2 04             	shl    $0x4,%edx
  801eb0:	01 d0                	add    %edx,%eax
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	75 14                	jne    801eca <initialize_MemBlocksList+0x55>
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	68 fc 3d 80 00       	push   $0x803dfc
  801ebe:	6a 46                	push   $0x46
  801ec0:	68 1f 3e 80 00       	push   $0x803e1f
  801ec5:	e8 91 e3 ff ff       	call   80025b <_panic>
  801eca:	a1 50 40 80 00       	mov    0x804050,%eax
  801ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed2:	c1 e2 04             	shl    $0x4,%edx
  801ed5:	01 d0                	add    %edx,%eax
  801ed7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801edd:	89 10                	mov    %edx,(%eax)
  801edf:	8b 00                	mov    (%eax),%eax
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	74 18                	je     801efd <initialize_MemBlocksList+0x88>
  801ee5:	a1 48 41 80 00       	mov    0x804148,%eax
  801eea:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ef0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ef3:	c1 e1 04             	shl    $0x4,%ecx
  801ef6:	01 ca                	add    %ecx,%edx
  801ef8:	89 50 04             	mov    %edx,0x4(%eax)
  801efb:	eb 12                	jmp    801f0f <initialize_MemBlocksList+0x9a>
  801efd:	a1 50 40 80 00       	mov    0x804050,%eax
  801f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f05:	c1 e2 04             	shl    $0x4,%edx
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f0f:	a1 50 40 80 00       	mov    0x804050,%eax
  801f14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f17:	c1 e2 04             	shl    $0x4,%edx
  801f1a:	01 d0                	add    %edx,%eax
  801f1c:	a3 48 41 80 00       	mov    %eax,0x804148
  801f21:	a1 50 40 80 00       	mov    0x804050,%eax
  801f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f29:	c1 e2 04             	shl    $0x4,%edx
  801f2c:	01 d0                	add    %edx,%eax
  801f2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f35:	a1 54 41 80 00       	mov    0x804154,%eax
  801f3a:	40                   	inc    %eax
  801f3b:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f40:	ff 45 f4             	incl   -0xc(%ebp)
  801f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f46:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f49:	0f 82 56 ff ff ff    	jb     801ea5 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f4f:	90                   	nop
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	8b 00                	mov    (%eax),%eax
  801f5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f60:	eb 19                	jmp    801f7b <find_block+0x29>
	{
		if(va==point->sva)
  801f62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f65:	8b 40 08             	mov    0x8(%eax),%eax
  801f68:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f6b:	75 05                	jne    801f72 <find_block+0x20>
		   return point;
  801f6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f70:	eb 36                	jmp    801fa8 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	8b 40 08             	mov    0x8(%eax),%eax
  801f78:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f7b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f7f:	74 07                	je     801f88 <find_block+0x36>
  801f81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	eb 05                	jmp    801f8d <find_block+0x3b>
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f90:	89 42 08             	mov    %eax,0x8(%edx)
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	8b 40 08             	mov    0x8(%eax),%eax
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	75 c5                	jne    801f62 <find_block+0x10>
  801f9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fa1:	75 bf                	jne    801f62 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fb0:	a1 40 40 80 00       	mov    0x804040,%eax
  801fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fb8:	a1 44 40 80 00       	mov    0x804044,%eax
  801fbd:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fc6:	74 24                	je     801fec <insert_sorted_allocList+0x42>
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	8b 50 08             	mov    0x8(%eax),%edx
  801fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd1:	8b 40 08             	mov    0x8(%eax),%eax
  801fd4:	39 c2                	cmp    %eax,%edx
  801fd6:	76 14                	jbe    801fec <insert_sorted_allocList+0x42>
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 50 08             	mov    0x8(%eax),%edx
  801fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe1:	8b 40 08             	mov    0x8(%eax),%eax
  801fe4:	39 c2                	cmp    %eax,%edx
  801fe6:	0f 82 60 01 00 00    	jb     80214c <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ff0:	75 65                	jne    802057 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801ff2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff6:	75 14                	jne    80200c <insert_sorted_allocList+0x62>
  801ff8:	83 ec 04             	sub    $0x4,%esp
  801ffb:	68 fc 3d 80 00       	push   $0x803dfc
  802000:	6a 6b                	push   $0x6b
  802002:	68 1f 3e 80 00       	push   $0x803e1f
  802007:	e8 4f e2 ff ff       	call   80025b <_panic>
  80200c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	89 10                	mov    %edx,(%eax)
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	8b 00                	mov    (%eax),%eax
  80201c:	85 c0                	test   %eax,%eax
  80201e:	74 0d                	je     80202d <insert_sorted_allocList+0x83>
  802020:	a1 40 40 80 00       	mov    0x804040,%eax
  802025:	8b 55 08             	mov    0x8(%ebp),%edx
  802028:	89 50 04             	mov    %edx,0x4(%eax)
  80202b:	eb 08                	jmp    802035 <insert_sorted_allocList+0x8b>
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	a3 44 40 80 00       	mov    %eax,0x804044
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	a3 40 40 80 00       	mov    %eax,0x804040
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802047:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80204c:	40                   	inc    %eax
  80204d:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802052:	e9 dc 01 00 00       	jmp    802233 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	8b 50 08             	mov    0x8(%eax),%edx
  80205d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802060:	8b 40 08             	mov    0x8(%eax),%eax
  802063:	39 c2                	cmp    %eax,%edx
  802065:	77 6c                	ja     8020d3 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802067:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80206b:	74 06                	je     802073 <insert_sorted_allocList+0xc9>
  80206d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802071:	75 14                	jne    802087 <insert_sorted_allocList+0xdd>
  802073:	83 ec 04             	sub    $0x4,%esp
  802076:	68 38 3e 80 00       	push   $0x803e38
  80207b:	6a 6f                	push   $0x6f
  80207d:	68 1f 3e 80 00       	push   $0x803e1f
  802082:	e8 d4 e1 ff ff       	call   80025b <_panic>
  802087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208a:	8b 50 04             	mov    0x4(%eax),%edx
  80208d:	8b 45 08             	mov    0x8(%ebp),%eax
  802090:	89 50 04             	mov    %edx,0x4(%eax)
  802093:	8b 45 08             	mov    0x8(%ebp),%eax
  802096:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802099:	89 10                	mov    %edx,(%eax)
  80209b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209e:	8b 40 04             	mov    0x4(%eax),%eax
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	74 0d                	je     8020b2 <insert_sorted_allocList+0x108>
  8020a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a8:	8b 40 04             	mov    0x4(%eax),%eax
  8020ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ae:	89 10                	mov    %edx,(%eax)
  8020b0:	eb 08                	jmp    8020ba <insert_sorted_allocList+0x110>
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	a3 40 40 80 00       	mov    %eax,0x804040
  8020ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c0:	89 50 04             	mov    %edx,0x4(%eax)
  8020c3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020c8:	40                   	inc    %eax
  8020c9:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020ce:	e9 60 01 00 00       	jmp    802233 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	8b 50 08             	mov    0x8(%eax),%edx
  8020d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020dc:	8b 40 08             	mov    0x8(%eax),%eax
  8020df:	39 c2                	cmp    %eax,%edx
  8020e1:	0f 82 4c 01 00 00    	jb     802233 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020eb:	75 14                	jne    802101 <insert_sorted_allocList+0x157>
  8020ed:	83 ec 04             	sub    $0x4,%esp
  8020f0:	68 70 3e 80 00       	push   $0x803e70
  8020f5:	6a 73                	push   $0x73
  8020f7:	68 1f 3e 80 00       	push   $0x803e1f
  8020fc:	e8 5a e1 ff ff       	call   80025b <_panic>
  802101:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	89 50 04             	mov    %edx,0x4(%eax)
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8b 40 04             	mov    0x4(%eax),%eax
  802113:	85 c0                	test   %eax,%eax
  802115:	74 0c                	je     802123 <insert_sorted_allocList+0x179>
  802117:	a1 44 40 80 00       	mov    0x804044,%eax
  80211c:	8b 55 08             	mov    0x8(%ebp),%edx
  80211f:	89 10                	mov    %edx,(%eax)
  802121:	eb 08                	jmp    80212b <insert_sorted_allocList+0x181>
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	a3 40 40 80 00       	mov    %eax,0x804040
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	a3 44 40 80 00       	mov    %eax,0x804044
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80213c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802141:	40                   	inc    %eax
  802142:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802147:	e9 e7 00 00 00       	jmp    802233 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80214c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802152:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802159:	a1 40 40 80 00       	mov    0x804040,%eax
  80215e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802161:	e9 9d 00 00 00       	jmp    802203 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802166:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802169:	8b 00                	mov    (%eax),%eax
  80216b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80216e:	8b 45 08             	mov    0x8(%ebp),%eax
  802171:	8b 50 08             	mov    0x8(%eax),%edx
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	8b 40 08             	mov    0x8(%eax),%eax
  80217a:	39 c2                	cmp    %eax,%edx
  80217c:	76 7d                	jbe    8021fb <insert_sorted_allocList+0x251>
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	8b 50 08             	mov    0x8(%eax),%edx
  802184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802187:	8b 40 08             	mov    0x8(%eax),%eax
  80218a:	39 c2                	cmp    %eax,%edx
  80218c:	73 6d                	jae    8021fb <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80218e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802192:	74 06                	je     80219a <insert_sorted_allocList+0x1f0>
  802194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802198:	75 14                	jne    8021ae <insert_sorted_allocList+0x204>
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	68 94 3e 80 00       	push   $0x803e94
  8021a2:	6a 7f                	push   $0x7f
  8021a4:	68 1f 3e 80 00       	push   $0x803e1f
  8021a9:	e8 ad e0 ff ff       	call   80025b <_panic>
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 10                	mov    (%eax),%edx
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	89 10                	mov    %edx,(%eax)
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	8b 00                	mov    (%eax),%eax
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	74 0b                	je     8021cc <insert_sorted_allocList+0x222>
  8021c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c4:	8b 00                	mov    (%eax),%eax
  8021c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c9:	89 50 04             	mov    %edx,0x4(%eax)
  8021cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d2:	89 10                	mov    %edx,(%eax)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021da:	89 50 04             	mov    %edx,0x4(%eax)
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	8b 00                	mov    (%eax),%eax
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 08                	jne    8021ee <insert_sorted_allocList+0x244>
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ee:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f3:	40                   	inc    %eax
  8021f4:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021f9:	eb 39                	jmp    802234 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021fb:	a1 48 40 80 00       	mov    0x804048,%eax
  802200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802207:	74 07                	je     802210 <insert_sorted_allocList+0x266>
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	8b 00                	mov    (%eax),%eax
  80220e:	eb 05                	jmp    802215 <insert_sorted_allocList+0x26b>
  802210:	b8 00 00 00 00       	mov    $0x0,%eax
  802215:	a3 48 40 80 00       	mov    %eax,0x804048
  80221a:	a1 48 40 80 00       	mov    0x804048,%eax
  80221f:	85 c0                	test   %eax,%eax
  802221:	0f 85 3f ff ff ff    	jne    802166 <insert_sorted_allocList+0x1bc>
  802227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222b:	0f 85 35 ff ff ff    	jne    802166 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802231:	eb 01                	jmp    802234 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802233:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802234:	90                   	nop
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80223d:	a1 38 41 80 00       	mov    0x804138,%eax
  802242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802245:	e9 85 01 00 00       	jmp    8023cf <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 40 0c             	mov    0xc(%eax),%eax
  802250:	3b 45 08             	cmp    0x8(%ebp),%eax
  802253:	0f 82 6e 01 00 00    	jb     8023c7 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	8b 40 0c             	mov    0xc(%eax),%eax
  80225f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802262:	0f 85 8a 00 00 00    	jne    8022f2 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226c:	75 17                	jne    802285 <alloc_block_FF+0x4e>
  80226e:	83 ec 04             	sub    $0x4,%esp
  802271:	68 c8 3e 80 00       	push   $0x803ec8
  802276:	68 93 00 00 00       	push   $0x93
  80227b:	68 1f 3e 80 00       	push   $0x803e1f
  802280:	e8 d6 df ff ff       	call   80025b <_panic>
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 00                	mov    (%eax),%eax
  80228a:	85 c0                	test   %eax,%eax
  80228c:	74 10                	je     80229e <alloc_block_FF+0x67>
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	8b 00                	mov    (%eax),%eax
  802293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802296:	8b 52 04             	mov    0x4(%edx),%edx
  802299:	89 50 04             	mov    %edx,0x4(%eax)
  80229c:	eb 0b                	jmp    8022a9 <alloc_block_FF+0x72>
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 40 04             	mov    0x4(%eax),%eax
  8022a4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 40 04             	mov    0x4(%eax),%eax
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	74 0f                	je     8022c2 <alloc_block_FF+0x8b>
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 40 04             	mov    0x4(%eax),%eax
  8022b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bc:	8b 12                	mov    (%edx),%edx
  8022be:	89 10                	mov    %edx,(%eax)
  8022c0:	eb 0a                	jmp    8022cc <alloc_block_FF+0x95>
  8022c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c5:	8b 00                	mov    (%eax),%eax
  8022c7:	a3 38 41 80 00       	mov    %eax,0x804138
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022df:	a1 44 41 80 00       	mov    0x804144,%eax
  8022e4:	48                   	dec    %eax
  8022e5:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	e9 10 01 00 00       	jmp    802402 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022fb:	0f 86 c6 00 00 00    	jbe    8023c7 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802301:	a1 48 41 80 00       	mov    0x804148,%eax
  802306:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	8b 50 08             	mov    0x8(%eax),%edx
  80230f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802312:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802318:	8b 55 08             	mov    0x8(%ebp),%edx
  80231b:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80231e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802322:	75 17                	jne    80233b <alloc_block_FF+0x104>
  802324:	83 ec 04             	sub    $0x4,%esp
  802327:	68 c8 3e 80 00       	push   $0x803ec8
  80232c:	68 9b 00 00 00       	push   $0x9b
  802331:	68 1f 3e 80 00       	push   $0x803e1f
  802336:	e8 20 df ff ff       	call   80025b <_panic>
  80233b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233e:	8b 00                	mov    (%eax),%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	74 10                	je     802354 <alloc_block_FF+0x11d>
  802344:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234c:	8b 52 04             	mov    0x4(%edx),%edx
  80234f:	89 50 04             	mov    %edx,0x4(%eax)
  802352:	eb 0b                	jmp    80235f <alloc_block_FF+0x128>
  802354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802357:	8b 40 04             	mov    0x4(%eax),%eax
  80235a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80235f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802362:	8b 40 04             	mov    0x4(%eax),%eax
  802365:	85 c0                	test   %eax,%eax
  802367:	74 0f                	je     802378 <alloc_block_FF+0x141>
  802369:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236c:	8b 40 04             	mov    0x4(%eax),%eax
  80236f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802372:	8b 12                	mov    (%edx),%edx
  802374:	89 10                	mov    %edx,(%eax)
  802376:	eb 0a                	jmp    802382 <alloc_block_FF+0x14b>
  802378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237b:	8b 00                	mov    (%eax),%eax
  80237d:	a3 48 41 80 00       	mov    %eax,0x804148
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802385:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802395:	a1 54 41 80 00       	mov    0x804154,%eax
  80239a:	48                   	dec    %eax
  80239b:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 50 08             	mov    0x8(%eax),%edx
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	01 c2                	add    %eax,%edx
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b7:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ba:	89 c2                	mov    %eax,%edx
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c5:	eb 3b                	jmp    802402 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023c7:	a1 40 41 80 00       	mov    0x804140,%eax
  8023cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d3:	74 07                	je     8023dc <alloc_block_FF+0x1a5>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	eb 05                	jmp    8023e1 <alloc_block_FF+0x1aa>
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	a3 40 41 80 00       	mov    %eax,0x804140
  8023e6:	a1 40 41 80 00       	mov    0x804140,%eax
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	0f 85 57 fe ff ff    	jne    80224a <alloc_block_FF+0x13>
  8023f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f7:	0f 85 4d fe ff ff    	jne    80224a <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802402:	c9                   	leave  
  802403:	c3                   	ret    

00802404 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802404:	55                   	push   %ebp
  802405:	89 e5                	mov    %esp,%ebp
  802407:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80240a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802411:	a1 38 41 80 00       	mov    0x804138,%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802419:	e9 df 00 00 00       	jmp    8024fd <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 40 0c             	mov    0xc(%eax),%eax
  802424:	3b 45 08             	cmp    0x8(%ebp),%eax
  802427:	0f 82 c8 00 00 00    	jb     8024f5 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 40 0c             	mov    0xc(%eax),%eax
  802433:	3b 45 08             	cmp    0x8(%ebp),%eax
  802436:	0f 85 8a 00 00 00    	jne    8024c6 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80243c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802440:	75 17                	jne    802459 <alloc_block_BF+0x55>
  802442:	83 ec 04             	sub    $0x4,%esp
  802445:	68 c8 3e 80 00       	push   $0x803ec8
  80244a:	68 b7 00 00 00       	push   $0xb7
  80244f:	68 1f 3e 80 00       	push   $0x803e1f
  802454:	e8 02 de ff ff       	call   80025b <_panic>
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 00                	mov    (%eax),%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	74 10                	je     802472 <alloc_block_BF+0x6e>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 00                	mov    (%eax),%eax
  802467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246a:	8b 52 04             	mov    0x4(%edx),%edx
  80246d:	89 50 04             	mov    %edx,0x4(%eax)
  802470:	eb 0b                	jmp    80247d <alloc_block_BF+0x79>
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 40 04             	mov    0x4(%eax),%eax
  802478:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 04             	mov    0x4(%eax),%eax
  802483:	85 c0                	test   %eax,%eax
  802485:	74 0f                	je     802496 <alloc_block_BF+0x92>
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 40 04             	mov    0x4(%eax),%eax
  80248d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802490:	8b 12                	mov    (%edx),%edx
  802492:	89 10                	mov    %edx,(%eax)
  802494:	eb 0a                	jmp    8024a0 <alloc_block_BF+0x9c>
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 00                	mov    (%eax),%eax
  80249b:	a3 38 41 80 00       	mov    %eax,0x804138
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8024b8:	48                   	dec    %eax
  8024b9:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	e9 4d 01 00 00       	jmp    802613 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024cf:	76 24                	jbe    8024f5 <alloc_block_BF+0xf1>
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024da:	73 19                	jae    8024f5 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024dc:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 40 08             	mov    0x8(%eax),%eax
  8024f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024f5:	a1 40 41 80 00       	mov    0x804140,%eax
  8024fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802501:	74 07                	je     80250a <alloc_block_BF+0x106>
  802503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802506:	8b 00                	mov    (%eax),%eax
  802508:	eb 05                	jmp    80250f <alloc_block_BF+0x10b>
  80250a:	b8 00 00 00 00       	mov    $0x0,%eax
  80250f:	a3 40 41 80 00       	mov    %eax,0x804140
  802514:	a1 40 41 80 00       	mov    0x804140,%eax
  802519:	85 c0                	test   %eax,%eax
  80251b:	0f 85 fd fe ff ff    	jne    80241e <alloc_block_BF+0x1a>
  802521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802525:	0f 85 f3 fe ff ff    	jne    80241e <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80252b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80252f:	0f 84 d9 00 00 00    	je     80260e <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802535:	a1 48 41 80 00       	mov    0x804148,%eax
  80253a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80253d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802540:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802543:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802549:	8b 55 08             	mov    0x8(%ebp),%edx
  80254c:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80254f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802553:	75 17                	jne    80256c <alloc_block_BF+0x168>
  802555:	83 ec 04             	sub    $0x4,%esp
  802558:	68 c8 3e 80 00       	push   $0x803ec8
  80255d:	68 c7 00 00 00       	push   $0xc7
  802562:	68 1f 3e 80 00       	push   $0x803e1f
  802567:	e8 ef dc ff ff       	call   80025b <_panic>
  80256c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256f:	8b 00                	mov    (%eax),%eax
  802571:	85 c0                	test   %eax,%eax
  802573:	74 10                	je     802585 <alloc_block_BF+0x181>
  802575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257d:	8b 52 04             	mov    0x4(%edx),%edx
  802580:	89 50 04             	mov    %edx,0x4(%eax)
  802583:	eb 0b                	jmp    802590 <alloc_block_BF+0x18c>
  802585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802588:	8b 40 04             	mov    0x4(%eax),%eax
  80258b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	85 c0                	test   %eax,%eax
  802598:	74 0f                	je     8025a9 <alloc_block_BF+0x1a5>
  80259a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259d:	8b 40 04             	mov    0x4(%eax),%eax
  8025a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025a3:	8b 12                	mov    (%edx),%edx
  8025a5:	89 10                	mov    %edx,(%eax)
  8025a7:	eb 0a                	jmp    8025b3 <alloc_block_BF+0x1af>
  8025a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	a3 48 41 80 00       	mov    %eax,0x804148
  8025b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c6:	a1 54 41 80 00       	mov    0x804154,%eax
  8025cb:	48                   	dec    %eax
  8025cc:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025d1:	83 ec 08             	sub    $0x8,%esp
  8025d4:	ff 75 ec             	pushl  -0x14(%ebp)
  8025d7:	68 38 41 80 00       	push   $0x804138
  8025dc:	e8 71 f9 ff ff       	call   801f52 <find_block>
  8025e1:	83 c4 10             	add    $0x10,%esp
  8025e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ea:	8b 50 08             	mov    0x8(%eax),%edx
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	01 c2                	add    %eax,%edx
  8025f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f5:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fe:	2b 45 08             	sub    0x8(%ebp),%eax
  802601:	89 c2                	mov    %eax,%edx
  802603:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802606:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260c:	eb 05                	jmp    802613 <alloc_block_BF+0x20f>
	}
	return NULL;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80261b:	a1 28 40 80 00       	mov    0x804028,%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	0f 85 de 01 00 00    	jne    802806 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802628:	a1 38 41 80 00       	mov    0x804138,%eax
  80262d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802630:	e9 9e 01 00 00       	jmp    8027d3 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 0c             	mov    0xc(%eax),%eax
  80263b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263e:	0f 82 87 01 00 00    	jb     8027cb <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802647:	8b 40 0c             	mov    0xc(%eax),%eax
  80264a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264d:	0f 85 95 00 00 00    	jne    8026e8 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802657:	75 17                	jne    802670 <alloc_block_NF+0x5b>
  802659:	83 ec 04             	sub    $0x4,%esp
  80265c:	68 c8 3e 80 00       	push   $0x803ec8
  802661:	68 e0 00 00 00       	push   $0xe0
  802666:	68 1f 3e 80 00       	push   $0x803e1f
  80266b:	e8 eb db ff ff       	call   80025b <_panic>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	74 10                	je     802689 <alloc_block_NF+0x74>
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802681:	8b 52 04             	mov    0x4(%edx),%edx
  802684:	89 50 04             	mov    %edx,0x4(%eax)
  802687:	eb 0b                	jmp    802694 <alloc_block_NF+0x7f>
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 04             	mov    0x4(%eax),%eax
  80268f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 40 04             	mov    0x4(%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	74 0f                	je     8026ad <alloc_block_NF+0x98>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a7:	8b 12                	mov    (%edx),%edx
  8026a9:	89 10                	mov    %edx,(%eax)
  8026ab:	eb 0a                	jmp    8026b7 <alloc_block_NF+0xa2>
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 00                	mov    (%eax),%eax
  8026b2:	a3 38 41 80 00       	mov    %eax,0x804138
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8026cf:	48                   	dec    %eax
  8026d0:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 08             	mov    0x8(%eax),%eax
  8026db:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	e9 f8 04 00 00       	jmp    802be0 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f1:	0f 86 d4 00 00 00    	jbe    8027cb <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026f7:	a1 48 41 80 00       	mov    0x804148,%eax
  8026fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 50 08             	mov    0x8(%eax),%edx
  802705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802708:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80270b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270e:	8b 55 08             	mov    0x8(%ebp),%edx
  802711:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802714:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802718:	75 17                	jne    802731 <alloc_block_NF+0x11c>
  80271a:	83 ec 04             	sub    $0x4,%esp
  80271d:	68 c8 3e 80 00       	push   $0x803ec8
  802722:	68 e9 00 00 00       	push   $0xe9
  802727:	68 1f 3e 80 00       	push   $0x803e1f
  80272c:	e8 2a db ff ff       	call   80025b <_panic>
  802731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802734:	8b 00                	mov    (%eax),%eax
  802736:	85 c0                	test   %eax,%eax
  802738:	74 10                	je     80274a <alloc_block_NF+0x135>
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802742:	8b 52 04             	mov    0x4(%edx),%edx
  802745:	89 50 04             	mov    %edx,0x4(%eax)
  802748:	eb 0b                	jmp    802755 <alloc_block_NF+0x140>
  80274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274d:	8b 40 04             	mov    0x4(%eax),%eax
  802750:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802758:	8b 40 04             	mov    0x4(%eax),%eax
  80275b:	85 c0                	test   %eax,%eax
  80275d:	74 0f                	je     80276e <alloc_block_NF+0x159>
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802768:	8b 12                	mov    (%edx),%edx
  80276a:	89 10                	mov    %edx,(%eax)
  80276c:	eb 0a                	jmp    802778 <alloc_block_NF+0x163>
  80276e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	a3 48 41 80 00       	mov    %eax,0x804148
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802784:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278b:	a1 54 41 80 00       	mov    0x804154,%eax
  802790:	48                   	dec    %eax
  802791:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	8b 40 08             	mov    0x8(%eax),%eax
  80279c:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 50 08             	mov    0x8(%eax),%edx
  8027a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027aa:	01 c2                	add    %eax,%edx
  8027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027af:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bb:	89 c2                	mov    %eax,%edx
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	e9 15 04 00 00       	jmp    802be0 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027cb:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d7:	74 07                	je     8027e0 <alloc_block_NF+0x1cb>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	eb 05                	jmp    8027e5 <alloc_block_NF+0x1d0>
  8027e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e5:	a3 40 41 80 00       	mov    %eax,0x804140
  8027ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	0f 85 3e fe ff ff    	jne    802635 <alloc_block_NF+0x20>
  8027f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fb:	0f 85 34 fe ff ff    	jne    802635 <alloc_block_NF+0x20>
  802801:	e9 d5 03 00 00       	jmp    802bdb <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802806:	a1 38 41 80 00       	mov    0x804138,%eax
  80280b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80280e:	e9 b1 01 00 00       	jmp    8029c4 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 50 08             	mov    0x8(%eax),%edx
  802819:	a1 28 40 80 00       	mov    0x804028,%eax
  80281e:	39 c2                	cmp    %eax,%edx
  802820:	0f 82 96 01 00 00    	jb     8029bc <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 40 0c             	mov    0xc(%eax),%eax
  80282c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282f:	0f 82 87 01 00 00    	jb     8029bc <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 0c             	mov    0xc(%eax),%eax
  80283b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80283e:	0f 85 95 00 00 00    	jne    8028d9 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802848:	75 17                	jne    802861 <alloc_block_NF+0x24c>
  80284a:	83 ec 04             	sub    $0x4,%esp
  80284d:	68 c8 3e 80 00       	push   $0x803ec8
  802852:	68 fc 00 00 00       	push   $0xfc
  802857:	68 1f 3e 80 00       	push   $0x803e1f
  80285c:	e8 fa d9 ff ff       	call   80025b <_panic>
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 10                	je     80287a <alloc_block_NF+0x265>
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802872:	8b 52 04             	mov    0x4(%edx),%edx
  802875:	89 50 04             	mov    %edx,0x4(%eax)
  802878:	eb 0b                	jmp    802885 <alloc_block_NF+0x270>
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	8b 40 04             	mov    0x4(%eax),%eax
  802880:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 0f                	je     80289e <alloc_block_NF+0x289>
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802898:	8b 12                	mov    (%edx),%edx
  80289a:	89 10                	mov    %edx,(%eax)
  80289c:	eb 0a                	jmp    8028a8 <alloc_block_NF+0x293>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	a3 38 41 80 00       	mov    %eax,0x804138
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bb:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c0:	48                   	dec    %eax
  8028c1:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c9:	8b 40 08             	mov    0x8(%eax),%eax
  8028cc:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	e9 07 03 00 00       	jmp    802be0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e2:	0f 86 d4 00 00 00    	jbe    8029bc <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028e8:	a1 48 41 80 00       	mov    0x804148,%eax
  8028ed:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 50 08             	mov    0x8(%eax),%edx
  8028f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f9:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802902:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802905:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802909:	75 17                	jne    802922 <alloc_block_NF+0x30d>
  80290b:	83 ec 04             	sub    $0x4,%esp
  80290e:	68 c8 3e 80 00       	push   $0x803ec8
  802913:	68 04 01 00 00       	push   $0x104
  802918:	68 1f 3e 80 00       	push   $0x803e1f
  80291d:	e8 39 d9 ff ff       	call   80025b <_panic>
  802922:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	85 c0                	test   %eax,%eax
  802929:	74 10                	je     80293b <alloc_block_NF+0x326>
  80292b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802933:	8b 52 04             	mov    0x4(%edx),%edx
  802936:	89 50 04             	mov    %edx,0x4(%eax)
  802939:	eb 0b                	jmp    802946 <alloc_block_NF+0x331>
  80293b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802946:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	74 0f                	je     80295f <alloc_block_NF+0x34a>
  802950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802959:	8b 12                	mov    (%edx),%edx
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	eb 0a                	jmp    802969 <alloc_block_NF+0x354>
  80295f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802962:	8b 00                	mov    (%eax),%eax
  802964:	a3 48 41 80 00       	mov    %eax,0x804148
  802969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802972:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802975:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297c:	a1 54 41 80 00       	mov    0x804154,%eax
  802981:	48                   	dec    %eax
  802982:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298a:	8b 40 08             	mov    0x8(%eax),%eax
  80298d:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 50 08             	mov    0x8(%eax),%edx
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	01 c2                	add    %eax,%edx
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8029ac:	89 c2                	mov    %eax,%edx
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b7:	e9 24 02 00 00       	jmp    802be0 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8029c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c8:	74 07                	je     8029d1 <alloc_block_NF+0x3bc>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	eb 05                	jmp    8029d6 <alloc_block_NF+0x3c1>
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d6:	a3 40 41 80 00       	mov    %eax,0x804140
  8029db:	a1 40 41 80 00       	mov    0x804140,%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	0f 85 2b fe ff ff    	jne    802813 <alloc_block_NF+0x1fe>
  8029e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ec:	0f 85 21 fe ff ff    	jne    802813 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029f2:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fa:	e9 ae 01 00 00       	jmp    802bad <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 50 08             	mov    0x8(%eax),%edx
  802a05:	a1 28 40 80 00       	mov    0x804028,%eax
  802a0a:	39 c2                	cmp    %eax,%edx
  802a0c:	0f 83 93 01 00 00    	jae    802ba5 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 0c             	mov    0xc(%eax),%eax
  802a18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a1b:	0f 82 84 01 00 00    	jb     802ba5 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2a:	0f 85 95 00 00 00    	jne    802ac5 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a34:	75 17                	jne    802a4d <alloc_block_NF+0x438>
  802a36:	83 ec 04             	sub    $0x4,%esp
  802a39:	68 c8 3e 80 00       	push   $0x803ec8
  802a3e:	68 14 01 00 00       	push   $0x114
  802a43:	68 1f 3e 80 00       	push   $0x803e1f
  802a48:	e8 0e d8 ff ff       	call   80025b <_panic>
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	8b 00                	mov    (%eax),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 10                	je     802a66 <alloc_block_NF+0x451>
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5e:	8b 52 04             	mov    0x4(%edx),%edx
  802a61:	89 50 04             	mov    %edx,0x4(%eax)
  802a64:	eb 0b                	jmp    802a71 <alloc_block_NF+0x45c>
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 40 04             	mov    0x4(%eax),%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	74 0f                	je     802a8a <alloc_block_NF+0x475>
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 04             	mov    0x4(%eax),%eax
  802a81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a84:	8b 12                	mov    (%edx),%edx
  802a86:	89 10                	mov    %edx,(%eax)
  802a88:	eb 0a                	jmp    802a94 <alloc_block_NF+0x47f>
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 00                	mov    (%eax),%eax
  802a8f:	a3 38 41 80 00       	mov    %eax,0x804138
  802a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa7:	a1 44 41 80 00       	mov    0x804144,%eax
  802aac:	48                   	dec    %eax
  802aad:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 40 08             	mov    0x8(%eax),%eax
  802ab8:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	e9 1b 01 00 00       	jmp    802be0 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  802acb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ace:	0f 86 d1 00 00 00    	jbe    802ba5 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ad4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ad9:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 50 08             	mov    0x8(%eax),%edx
  802ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae5:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aeb:	8b 55 08             	mov    0x8(%ebp),%edx
  802aee:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802af1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af5:	75 17                	jne    802b0e <alloc_block_NF+0x4f9>
  802af7:	83 ec 04             	sub    $0x4,%esp
  802afa:	68 c8 3e 80 00       	push   $0x803ec8
  802aff:	68 1c 01 00 00       	push   $0x11c
  802b04:	68 1f 3e 80 00       	push   $0x803e1f
  802b09:	e8 4d d7 ff ff       	call   80025b <_panic>
  802b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	85 c0                	test   %eax,%eax
  802b15:	74 10                	je     802b27 <alloc_block_NF+0x512>
  802b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1f:	8b 52 04             	mov    0x4(%edx),%edx
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	eb 0b                	jmp    802b32 <alloc_block_NF+0x51d>
  802b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2a:	8b 40 04             	mov    0x4(%eax),%eax
  802b2d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b35:	8b 40 04             	mov    0x4(%eax),%eax
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	74 0f                	je     802b4b <alloc_block_NF+0x536>
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	8b 40 04             	mov    0x4(%eax),%eax
  802b42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b45:	8b 12                	mov    (%edx),%edx
  802b47:	89 10                	mov    %edx,(%eax)
  802b49:	eb 0a                	jmp    802b55 <alloc_block_NF+0x540>
  802b4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	a3 48 41 80 00       	mov    %eax,0x804148
  802b55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b68:	a1 54 41 80 00       	mov    0x804154,%eax
  802b6d:	48                   	dec    %eax
  802b6e:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b76:	8b 40 08             	mov    0x8(%eax),%eax
  802b79:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 50 08             	mov    0x8(%eax),%edx
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	01 c2                	add    %eax,%edx
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 0c             	mov    0xc(%eax),%eax
  802b95:	2b 45 08             	sub    0x8(%ebp),%eax
  802b98:	89 c2                	mov    %eax,%edx
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ba0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba3:	eb 3b                	jmp    802be0 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ba5:	a1 40 41 80 00       	mov    0x804140,%eax
  802baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb1:	74 07                	je     802bba <alloc_block_NF+0x5a5>
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	eb 05                	jmp    802bbf <alloc_block_NF+0x5aa>
  802bba:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbf:	a3 40 41 80 00       	mov    %eax,0x804140
  802bc4:	a1 40 41 80 00       	mov    0x804140,%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	0f 85 2e fe ff ff    	jne    8029ff <alloc_block_NF+0x3ea>
  802bd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd5:	0f 85 24 fe ff ff    	jne    8029ff <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be0:	c9                   	leave  
  802be1:	c3                   	ret    

00802be2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802be2:	55                   	push   %ebp
  802be3:	89 e5                	mov    %esp,%ebp
  802be5:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802be8:	a1 38 41 80 00       	mov    0x804138,%eax
  802bed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bf0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bf5:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bf8:	a1 38 41 80 00       	mov    0x804138,%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	74 14                	je     802c15 <insert_sorted_with_merge_freeList+0x33>
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	8b 50 08             	mov    0x8(%eax),%edx
  802c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0a:	8b 40 08             	mov    0x8(%eax),%eax
  802c0d:	39 c2                	cmp    %eax,%edx
  802c0f:	0f 87 9b 01 00 00    	ja     802db0 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c19:	75 17                	jne    802c32 <insert_sorted_with_merge_freeList+0x50>
  802c1b:	83 ec 04             	sub    $0x4,%esp
  802c1e:	68 fc 3d 80 00       	push   $0x803dfc
  802c23:	68 38 01 00 00       	push   $0x138
  802c28:	68 1f 3e 80 00       	push   $0x803e1f
  802c2d:	e8 29 d6 ff ff       	call   80025b <_panic>
  802c32:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	89 10                	mov    %edx,(%eax)
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	74 0d                	je     802c53 <insert_sorted_with_merge_freeList+0x71>
  802c46:	a1 38 41 80 00       	mov    0x804138,%eax
  802c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4e:	89 50 04             	mov    %edx,0x4(%eax)
  802c51:	eb 08                	jmp    802c5b <insert_sorted_with_merge_freeList+0x79>
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	a3 38 41 80 00       	mov    %eax,0x804138
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6d:	a1 44 41 80 00       	mov    0x804144,%eax
  802c72:	40                   	inc    %eax
  802c73:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c7c:	0f 84 a8 06 00 00    	je     80332a <insert_sorted_with_merge_freeList+0x748>
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 50 08             	mov    0x8(%eax),%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8e:	01 c2                	add    %eax,%edx
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	8b 40 08             	mov    0x8(%eax),%eax
  802c96:	39 c2                	cmp    %eax,%edx
  802c98:	0f 85 8c 06 00 00    	jne    80332a <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca7:	8b 40 0c             	mov    0xc(%eax),%eax
  802caa:	01 c2                	add    %eax,%edx
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cb6:	75 17                	jne    802ccf <insert_sorted_with_merge_freeList+0xed>
  802cb8:	83 ec 04             	sub    $0x4,%esp
  802cbb:	68 c8 3e 80 00       	push   $0x803ec8
  802cc0:	68 3c 01 00 00       	push   $0x13c
  802cc5:	68 1f 3e 80 00       	push   $0x803e1f
  802cca:	e8 8c d5 ff ff       	call   80025b <_panic>
  802ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	74 10                	je     802ce8 <insert_sorted_with_merge_freeList+0x106>
  802cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce0:	8b 52 04             	mov    0x4(%edx),%edx
  802ce3:	89 50 04             	mov    %edx,0x4(%eax)
  802ce6:	eb 0b                	jmp    802cf3 <insert_sorted_with_merge_freeList+0x111>
  802ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ceb:	8b 40 04             	mov    0x4(%eax),%eax
  802cee:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	8b 40 04             	mov    0x4(%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	74 0f                	je     802d0c <insert_sorted_with_merge_freeList+0x12a>
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	8b 40 04             	mov    0x4(%eax),%eax
  802d03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d06:	8b 12                	mov    (%edx),%edx
  802d08:	89 10                	mov    %edx,(%eax)
  802d0a:	eb 0a                	jmp    802d16 <insert_sorted_with_merge_freeList+0x134>
  802d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0f:	8b 00                	mov    (%eax),%eax
  802d11:	a3 38 41 80 00       	mov    %eax,0x804138
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d29:	a1 44 41 80 00       	mov    0x804144,%eax
  802d2e:	48                   	dec    %eax
  802d2f:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d4c:	75 17                	jne    802d65 <insert_sorted_with_merge_freeList+0x183>
  802d4e:	83 ec 04             	sub    $0x4,%esp
  802d51:	68 fc 3d 80 00       	push   $0x803dfc
  802d56:	68 3f 01 00 00       	push   $0x13f
  802d5b:	68 1f 3e 80 00       	push   $0x803e1f
  802d60:	e8 f6 d4 ff ff       	call   80025b <_panic>
  802d65:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	89 10                	mov    %edx,(%eax)
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	85 c0                	test   %eax,%eax
  802d77:	74 0d                	je     802d86 <insert_sorted_with_merge_freeList+0x1a4>
  802d79:	a1 48 41 80 00       	mov    0x804148,%eax
  802d7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d81:	89 50 04             	mov    %edx,0x4(%eax)
  802d84:	eb 08                	jmp    802d8e <insert_sorted_with_merge_freeList+0x1ac>
  802d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d89:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d91:	a3 48 41 80 00       	mov    %eax,0x804148
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da0:	a1 54 41 80 00       	mov    0x804154,%eax
  802da5:	40                   	inc    %eax
  802da6:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dab:	e9 7a 05 00 00       	jmp    80332a <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	8b 50 08             	mov    0x8(%eax),%edx
  802db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db9:	8b 40 08             	mov    0x8(%eax),%eax
  802dbc:	39 c2                	cmp    %eax,%edx
  802dbe:	0f 82 14 01 00 00    	jb     802ed8 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc7:	8b 50 08             	mov    0x8(%eax),%edx
  802dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd0:	01 c2                	add    %eax,%edx
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	8b 40 08             	mov    0x8(%eax),%eax
  802dd8:	39 c2                	cmp    %eax,%edx
  802dda:	0f 85 90 00 00 00    	jne    802e70 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de3:	8b 50 0c             	mov    0xc(%eax),%edx
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dec:	01 c2                	add    %eax,%edx
  802dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df1:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0c:	75 17                	jne    802e25 <insert_sorted_with_merge_freeList+0x243>
  802e0e:	83 ec 04             	sub    $0x4,%esp
  802e11:	68 fc 3d 80 00       	push   $0x803dfc
  802e16:	68 49 01 00 00       	push   $0x149
  802e1b:	68 1f 3e 80 00       	push   $0x803e1f
  802e20:	e8 36 d4 ff ff       	call   80025b <_panic>
  802e25:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	74 0d                	je     802e46 <insert_sorted_with_merge_freeList+0x264>
  802e39:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e41:	89 50 04             	mov    %edx,0x4(%eax)
  802e44:	eb 08                	jmp    802e4e <insert_sorted_with_merge_freeList+0x26c>
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	a3 48 41 80 00       	mov    %eax,0x804148
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e60:	a1 54 41 80 00       	mov    0x804154,%eax
  802e65:	40                   	inc    %eax
  802e66:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e6b:	e9 bb 04 00 00       	jmp    80332b <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e74:	75 17                	jne    802e8d <insert_sorted_with_merge_freeList+0x2ab>
  802e76:	83 ec 04             	sub    $0x4,%esp
  802e79:	68 70 3e 80 00       	push   $0x803e70
  802e7e:	68 4c 01 00 00       	push   $0x14c
  802e83:	68 1f 3e 80 00       	push   $0x803e1f
  802e88:	e8 ce d3 ff ff       	call   80025b <_panic>
  802e8d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	89 50 04             	mov    %edx,0x4(%eax)
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	74 0c                	je     802eaf <insert_sorted_with_merge_freeList+0x2cd>
  802ea3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ea8:	8b 55 08             	mov    0x8(%ebp),%edx
  802eab:	89 10                	mov    %edx,(%eax)
  802ead:	eb 08                	jmp    802eb7 <insert_sorted_with_merge_freeList+0x2d5>
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	a3 38 41 80 00       	mov    %eax,0x804138
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec8:	a1 44 41 80 00       	mov    0x804144,%eax
  802ecd:	40                   	inc    %eax
  802ece:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ed3:	e9 53 04 00 00       	jmp    80332b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ed8:	a1 38 41 80 00       	mov    0x804138,%eax
  802edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee0:	e9 15 04 00 00       	jmp    8032fa <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee8:	8b 00                	mov    (%eax),%eax
  802eea:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	8b 50 08             	mov    0x8(%eax),%edx
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 40 08             	mov    0x8(%eax),%eax
  802ef9:	39 c2                	cmp    %eax,%edx
  802efb:	0f 86 f1 03 00 00    	jbe    8032f2 <insert_sorted_with_merge_freeList+0x710>
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	8b 50 08             	mov    0x8(%eax),%edx
  802f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0a:	8b 40 08             	mov    0x8(%eax),%eax
  802f0d:	39 c2                	cmp    %eax,%edx
  802f0f:	0f 83 dd 03 00 00    	jae    8032f2 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 50 08             	mov    0x8(%eax),%edx
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f21:	01 c2                	add    %eax,%edx
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 40 08             	mov    0x8(%eax),%eax
  802f29:	39 c2                	cmp    %eax,%edx
  802f2b:	0f 85 b9 01 00 00    	jne    8030ea <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f31:	8b 45 08             	mov    0x8(%ebp),%eax
  802f34:	8b 50 08             	mov    0x8(%eax),%edx
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3d:	01 c2                	add    %eax,%edx
  802f3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f42:	8b 40 08             	mov    0x8(%eax),%eax
  802f45:	39 c2                	cmp    %eax,%edx
  802f47:	0f 85 0d 01 00 00    	jne    80305a <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 50 0c             	mov    0xc(%eax),%edx
  802f53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f56:	8b 40 0c             	mov    0xc(%eax),%eax
  802f59:	01 c2                	add    %eax,%edx
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f61:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f65:	75 17                	jne    802f7e <insert_sorted_with_merge_freeList+0x39c>
  802f67:	83 ec 04             	sub    $0x4,%esp
  802f6a:	68 c8 3e 80 00       	push   $0x803ec8
  802f6f:	68 5c 01 00 00       	push   $0x15c
  802f74:	68 1f 3e 80 00       	push   $0x803e1f
  802f79:	e8 dd d2 ff ff       	call   80025b <_panic>
  802f7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f81:	8b 00                	mov    (%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 10                	je     802f97 <insert_sorted_with_merge_freeList+0x3b5>
  802f87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f8a:	8b 00                	mov    (%eax),%eax
  802f8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8f:	8b 52 04             	mov    0x4(%edx),%edx
  802f92:	89 50 04             	mov    %edx,0x4(%eax)
  802f95:	eb 0b                	jmp    802fa2 <insert_sorted_with_merge_freeList+0x3c0>
  802f97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9a:	8b 40 04             	mov    0x4(%eax),%eax
  802f9d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa5:	8b 40 04             	mov    0x4(%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 0f                	je     802fbb <insert_sorted_with_merge_freeList+0x3d9>
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	8b 40 04             	mov    0x4(%eax),%eax
  802fb2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fb5:	8b 12                	mov    (%edx),%edx
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	eb 0a                	jmp    802fc5 <insert_sorted_with_merge_freeList+0x3e3>
  802fbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	a3 38 41 80 00       	mov    %eax,0x804138
  802fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd8:	a1 44 41 80 00       	mov    0x804144,%eax
  802fdd:	48                   	dec    %eax
  802fde:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802ff7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ffb:	75 17                	jne    803014 <insert_sorted_with_merge_freeList+0x432>
  802ffd:	83 ec 04             	sub    $0x4,%esp
  803000:	68 fc 3d 80 00       	push   $0x803dfc
  803005:	68 5f 01 00 00       	push   $0x15f
  80300a:	68 1f 3e 80 00       	push   $0x803e1f
  80300f:	e8 47 d2 ff ff       	call   80025b <_panic>
  803014:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80301a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301d:	89 10                	mov    %edx,(%eax)
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	8b 00                	mov    (%eax),%eax
  803024:	85 c0                	test   %eax,%eax
  803026:	74 0d                	je     803035 <insert_sorted_with_merge_freeList+0x453>
  803028:	a1 48 41 80 00       	mov    0x804148,%eax
  80302d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803030:	89 50 04             	mov    %edx,0x4(%eax)
  803033:	eb 08                	jmp    80303d <insert_sorted_with_merge_freeList+0x45b>
  803035:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803038:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80303d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803040:	a3 48 41 80 00       	mov    %eax,0x804148
  803045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803048:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304f:	a1 54 41 80 00       	mov    0x804154,%eax
  803054:	40                   	inc    %eax
  803055:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  80305a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305d:	8b 50 0c             	mov    0xc(%eax),%edx
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	8b 40 0c             	mov    0xc(%eax),%eax
  803066:	01 c2                	add    %eax,%edx
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803082:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803086:	75 17                	jne    80309f <insert_sorted_with_merge_freeList+0x4bd>
  803088:	83 ec 04             	sub    $0x4,%esp
  80308b:	68 fc 3d 80 00       	push   $0x803dfc
  803090:	68 64 01 00 00       	push   $0x164
  803095:	68 1f 3e 80 00       	push   $0x803e1f
  80309a:	e8 bc d1 ff ff       	call   80025b <_panic>
  80309f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	89 10                	mov    %edx,(%eax)
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	74 0d                	je     8030c0 <insert_sorted_with_merge_freeList+0x4de>
  8030b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8030b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	eb 08                	jmp    8030c8 <insert_sorted_with_merge_freeList+0x4e6>
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030da:	a1 54 41 80 00       	mov    0x804154,%eax
  8030df:	40                   	inc    %eax
  8030e0:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030e5:	e9 41 02 00 00       	jmp    80332b <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	8b 50 08             	mov    0x8(%eax),%edx
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f6:	01 c2                	add    %eax,%edx
  8030f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030fb:	8b 40 08             	mov    0x8(%eax),%eax
  8030fe:	39 c2                	cmp    %eax,%edx
  803100:	0f 85 7c 01 00 00    	jne    803282 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803106:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310a:	74 06                	je     803112 <insert_sorted_with_merge_freeList+0x530>
  80310c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803110:	75 17                	jne    803129 <insert_sorted_with_merge_freeList+0x547>
  803112:	83 ec 04             	sub    $0x4,%esp
  803115:	68 38 3e 80 00       	push   $0x803e38
  80311a:	68 69 01 00 00       	push   $0x169
  80311f:	68 1f 3e 80 00       	push   $0x803e1f
  803124:	e8 32 d1 ff ff       	call   80025b <_panic>
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	8b 50 04             	mov    0x4(%eax),%edx
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	89 50 04             	mov    %edx,0x4(%eax)
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80313b:	89 10                	mov    %edx,(%eax)
  80313d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803140:	8b 40 04             	mov    0x4(%eax),%eax
  803143:	85 c0                	test   %eax,%eax
  803145:	74 0d                	je     803154 <insert_sorted_with_merge_freeList+0x572>
  803147:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	8b 55 08             	mov    0x8(%ebp),%edx
  803150:	89 10                	mov    %edx,(%eax)
  803152:	eb 08                	jmp    80315c <insert_sorted_with_merge_freeList+0x57a>
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	a3 38 41 80 00       	mov    %eax,0x804138
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	8b 55 08             	mov    0x8(%ebp),%edx
  803162:	89 50 04             	mov    %edx,0x4(%eax)
  803165:	a1 44 41 80 00       	mov    0x804144,%eax
  80316a:	40                   	inc    %eax
  80316b:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 50 0c             	mov    0xc(%eax),%edx
  803176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803179:	8b 40 0c             	mov    0xc(%eax),%eax
  80317c:	01 c2                	add    %eax,%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803184:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803188:	75 17                	jne    8031a1 <insert_sorted_with_merge_freeList+0x5bf>
  80318a:	83 ec 04             	sub    $0x4,%esp
  80318d:	68 c8 3e 80 00       	push   $0x803ec8
  803192:	68 6b 01 00 00       	push   $0x16b
  803197:	68 1f 3e 80 00       	push   $0x803e1f
  80319c:	e8 ba d0 ff ff       	call   80025b <_panic>
  8031a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a4:	8b 00                	mov    (%eax),%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 10                	je     8031ba <insert_sorted_with_merge_freeList+0x5d8>
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b2:	8b 52 04             	mov    0x4(%edx),%edx
  8031b5:	89 50 04             	mov    %edx,0x4(%eax)
  8031b8:	eb 0b                	jmp    8031c5 <insert_sorted_with_merge_freeList+0x5e3>
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	8b 40 04             	mov    0x4(%eax),%eax
  8031c0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c8:	8b 40 04             	mov    0x4(%eax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 0f                	je     8031de <insert_sorted_with_merge_freeList+0x5fc>
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d8:	8b 12                	mov    (%edx),%edx
  8031da:	89 10                	mov    %edx,(%eax)
  8031dc:	eb 0a                	jmp    8031e8 <insert_sorted_with_merge_freeList+0x606>
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	a3 38 41 80 00       	mov    %eax,0x804138
  8031e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fb:	a1 44 41 80 00       	mov    0x804144,%eax
  803200:	48                   	dec    %eax
  803201:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80321a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80321e:	75 17                	jne    803237 <insert_sorted_with_merge_freeList+0x655>
  803220:	83 ec 04             	sub    $0x4,%esp
  803223:	68 fc 3d 80 00       	push   $0x803dfc
  803228:	68 6e 01 00 00       	push   $0x16e
  80322d:	68 1f 3e 80 00       	push   $0x803e1f
  803232:	e8 24 d0 ff ff       	call   80025b <_panic>
  803237:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	89 10                	mov    %edx,(%eax)
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	8b 00                	mov    (%eax),%eax
  803247:	85 c0                	test   %eax,%eax
  803249:	74 0d                	je     803258 <insert_sorted_with_merge_freeList+0x676>
  80324b:	a1 48 41 80 00       	mov    0x804148,%eax
  803250:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803253:	89 50 04             	mov    %edx,0x4(%eax)
  803256:	eb 08                	jmp    803260 <insert_sorted_with_merge_freeList+0x67e>
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803260:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803263:	a3 48 41 80 00       	mov    %eax,0x804148
  803268:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803272:	a1 54 41 80 00       	mov    0x804154,%eax
  803277:	40                   	inc    %eax
  803278:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80327d:	e9 a9 00 00 00       	jmp    80332b <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803286:	74 06                	je     80328e <insert_sorted_with_merge_freeList+0x6ac>
  803288:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328c:	75 17                	jne    8032a5 <insert_sorted_with_merge_freeList+0x6c3>
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	68 94 3e 80 00       	push   $0x803e94
  803296:	68 73 01 00 00       	push   $0x173
  80329b:	68 1f 3e 80 00       	push   $0x803e1f
  8032a0:	e8 b6 cf ff ff       	call   80025b <_panic>
  8032a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a8:	8b 10                	mov    (%eax),%edx
  8032aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ad:	89 10                	mov    %edx,(%eax)
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	8b 00                	mov    (%eax),%eax
  8032b4:	85 c0                	test   %eax,%eax
  8032b6:	74 0b                	je     8032c3 <insert_sorted_with_merge_freeList+0x6e1>
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c0:	89 50 04             	mov    %edx,0x4(%eax)
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c9:	89 10                	mov    %edx,(%eax)
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d1:	89 50 04             	mov    %edx,0x4(%eax)
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	75 08                	jne    8032e5 <insert_sorted_with_merge_freeList+0x703>
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032e5:	a1 44 41 80 00       	mov    0x804144,%eax
  8032ea:	40                   	inc    %eax
  8032eb:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032f0:	eb 39                	jmp    80332b <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032f2:	a1 40 41 80 00       	mov    0x804140,%eax
  8032f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fe:	74 07                	je     803307 <insert_sorted_with_merge_freeList+0x725>
  803300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803303:	8b 00                	mov    (%eax),%eax
  803305:	eb 05                	jmp    80330c <insert_sorted_with_merge_freeList+0x72a>
  803307:	b8 00 00 00 00       	mov    $0x0,%eax
  80330c:	a3 40 41 80 00       	mov    %eax,0x804140
  803311:	a1 40 41 80 00       	mov    0x804140,%eax
  803316:	85 c0                	test   %eax,%eax
  803318:	0f 85 c7 fb ff ff    	jne    802ee5 <insert_sorted_with_merge_freeList+0x303>
  80331e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803322:	0f 85 bd fb ff ff    	jne    802ee5 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803328:	eb 01                	jmp    80332b <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80332a:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80332b:	90                   	nop
  80332c:	c9                   	leave  
  80332d:	c3                   	ret    
  80332e:	66 90                	xchg   %ax,%ax

00803330 <__udivdi3>:
  803330:	55                   	push   %ebp
  803331:	57                   	push   %edi
  803332:	56                   	push   %esi
  803333:	53                   	push   %ebx
  803334:	83 ec 1c             	sub    $0x1c,%esp
  803337:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80333b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80333f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803343:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803347:	89 ca                	mov    %ecx,%edx
  803349:	89 f8                	mov    %edi,%eax
  80334b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80334f:	85 f6                	test   %esi,%esi
  803351:	75 2d                	jne    803380 <__udivdi3+0x50>
  803353:	39 cf                	cmp    %ecx,%edi
  803355:	77 65                	ja     8033bc <__udivdi3+0x8c>
  803357:	89 fd                	mov    %edi,%ebp
  803359:	85 ff                	test   %edi,%edi
  80335b:	75 0b                	jne    803368 <__udivdi3+0x38>
  80335d:	b8 01 00 00 00       	mov    $0x1,%eax
  803362:	31 d2                	xor    %edx,%edx
  803364:	f7 f7                	div    %edi
  803366:	89 c5                	mov    %eax,%ebp
  803368:	31 d2                	xor    %edx,%edx
  80336a:	89 c8                	mov    %ecx,%eax
  80336c:	f7 f5                	div    %ebp
  80336e:	89 c1                	mov    %eax,%ecx
  803370:	89 d8                	mov    %ebx,%eax
  803372:	f7 f5                	div    %ebp
  803374:	89 cf                	mov    %ecx,%edi
  803376:	89 fa                	mov    %edi,%edx
  803378:	83 c4 1c             	add    $0x1c,%esp
  80337b:	5b                   	pop    %ebx
  80337c:	5e                   	pop    %esi
  80337d:	5f                   	pop    %edi
  80337e:	5d                   	pop    %ebp
  80337f:	c3                   	ret    
  803380:	39 ce                	cmp    %ecx,%esi
  803382:	77 28                	ja     8033ac <__udivdi3+0x7c>
  803384:	0f bd fe             	bsr    %esi,%edi
  803387:	83 f7 1f             	xor    $0x1f,%edi
  80338a:	75 40                	jne    8033cc <__udivdi3+0x9c>
  80338c:	39 ce                	cmp    %ecx,%esi
  80338e:	72 0a                	jb     80339a <__udivdi3+0x6a>
  803390:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803394:	0f 87 9e 00 00 00    	ja     803438 <__udivdi3+0x108>
  80339a:	b8 01 00 00 00       	mov    $0x1,%eax
  80339f:	89 fa                	mov    %edi,%edx
  8033a1:	83 c4 1c             	add    $0x1c,%esp
  8033a4:	5b                   	pop    %ebx
  8033a5:	5e                   	pop    %esi
  8033a6:	5f                   	pop    %edi
  8033a7:	5d                   	pop    %ebp
  8033a8:	c3                   	ret    
  8033a9:	8d 76 00             	lea    0x0(%esi),%esi
  8033ac:	31 ff                	xor    %edi,%edi
  8033ae:	31 c0                	xor    %eax,%eax
  8033b0:	89 fa                	mov    %edi,%edx
  8033b2:	83 c4 1c             	add    $0x1c,%esp
  8033b5:	5b                   	pop    %ebx
  8033b6:	5e                   	pop    %esi
  8033b7:	5f                   	pop    %edi
  8033b8:	5d                   	pop    %ebp
  8033b9:	c3                   	ret    
  8033ba:	66 90                	xchg   %ax,%ax
  8033bc:	89 d8                	mov    %ebx,%eax
  8033be:	f7 f7                	div    %edi
  8033c0:	31 ff                	xor    %edi,%edi
  8033c2:	89 fa                	mov    %edi,%edx
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    
  8033cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033d1:	89 eb                	mov    %ebp,%ebx
  8033d3:	29 fb                	sub    %edi,%ebx
  8033d5:	89 f9                	mov    %edi,%ecx
  8033d7:	d3 e6                	shl    %cl,%esi
  8033d9:	89 c5                	mov    %eax,%ebp
  8033db:	88 d9                	mov    %bl,%cl
  8033dd:	d3 ed                	shr    %cl,%ebp
  8033df:	89 e9                	mov    %ebp,%ecx
  8033e1:	09 f1                	or     %esi,%ecx
  8033e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033e7:	89 f9                	mov    %edi,%ecx
  8033e9:	d3 e0                	shl    %cl,%eax
  8033eb:	89 c5                	mov    %eax,%ebp
  8033ed:	89 d6                	mov    %edx,%esi
  8033ef:	88 d9                	mov    %bl,%cl
  8033f1:	d3 ee                	shr    %cl,%esi
  8033f3:	89 f9                	mov    %edi,%ecx
  8033f5:	d3 e2                	shl    %cl,%edx
  8033f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033fb:	88 d9                	mov    %bl,%cl
  8033fd:	d3 e8                	shr    %cl,%eax
  8033ff:	09 c2                	or     %eax,%edx
  803401:	89 d0                	mov    %edx,%eax
  803403:	89 f2                	mov    %esi,%edx
  803405:	f7 74 24 0c          	divl   0xc(%esp)
  803409:	89 d6                	mov    %edx,%esi
  80340b:	89 c3                	mov    %eax,%ebx
  80340d:	f7 e5                	mul    %ebp
  80340f:	39 d6                	cmp    %edx,%esi
  803411:	72 19                	jb     80342c <__udivdi3+0xfc>
  803413:	74 0b                	je     803420 <__udivdi3+0xf0>
  803415:	89 d8                	mov    %ebx,%eax
  803417:	31 ff                	xor    %edi,%edi
  803419:	e9 58 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  80341e:	66 90                	xchg   %ax,%ax
  803420:	8b 54 24 08          	mov    0x8(%esp),%edx
  803424:	89 f9                	mov    %edi,%ecx
  803426:	d3 e2                	shl    %cl,%edx
  803428:	39 c2                	cmp    %eax,%edx
  80342a:	73 e9                	jae    803415 <__udivdi3+0xe5>
  80342c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80342f:	31 ff                	xor    %edi,%edi
  803431:	e9 40 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  803436:	66 90                	xchg   %ax,%ax
  803438:	31 c0                	xor    %eax,%eax
  80343a:	e9 37 ff ff ff       	jmp    803376 <__udivdi3+0x46>
  80343f:	90                   	nop

00803440 <__umoddi3>:
  803440:	55                   	push   %ebp
  803441:	57                   	push   %edi
  803442:	56                   	push   %esi
  803443:	53                   	push   %ebx
  803444:	83 ec 1c             	sub    $0x1c,%esp
  803447:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80344b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80344f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803453:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803457:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80345b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80345f:	89 f3                	mov    %esi,%ebx
  803461:	89 fa                	mov    %edi,%edx
  803463:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803467:	89 34 24             	mov    %esi,(%esp)
  80346a:	85 c0                	test   %eax,%eax
  80346c:	75 1a                	jne    803488 <__umoddi3+0x48>
  80346e:	39 f7                	cmp    %esi,%edi
  803470:	0f 86 a2 00 00 00    	jbe    803518 <__umoddi3+0xd8>
  803476:	89 c8                	mov    %ecx,%eax
  803478:	89 f2                	mov    %esi,%edx
  80347a:	f7 f7                	div    %edi
  80347c:	89 d0                	mov    %edx,%eax
  80347e:	31 d2                	xor    %edx,%edx
  803480:	83 c4 1c             	add    $0x1c,%esp
  803483:	5b                   	pop    %ebx
  803484:	5e                   	pop    %esi
  803485:	5f                   	pop    %edi
  803486:	5d                   	pop    %ebp
  803487:	c3                   	ret    
  803488:	39 f0                	cmp    %esi,%eax
  80348a:	0f 87 ac 00 00 00    	ja     80353c <__umoddi3+0xfc>
  803490:	0f bd e8             	bsr    %eax,%ebp
  803493:	83 f5 1f             	xor    $0x1f,%ebp
  803496:	0f 84 ac 00 00 00    	je     803548 <__umoddi3+0x108>
  80349c:	bf 20 00 00 00       	mov    $0x20,%edi
  8034a1:	29 ef                	sub    %ebp,%edi
  8034a3:	89 fe                	mov    %edi,%esi
  8034a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034a9:	89 e9                	mov    %ebp,%ecx
  8034ab:	d3 e0                	shl    %cl,%eax
  8034ad:	89 d7                	mov    %edx,%edi
  8034af:	89 f1                	mov    %esi,%ecx
  8034b1:	d3 ef                	shr    %cl,%edi
  8034b3:	09 c7                	or     %eax,%edi
  8034b5:	89 e9                	mov    %ebp,%ecx
  8034b7:	d3 e2                	shl    %cl,%edx
  8034b9:	89 14 24             	mov    %edx,(%esp)
  8034bc:	89 d8                	mov    %ebx,%eax
  8034be:	d3 e0                	shl    %cl,%eax
  8034c0:	89 c2                	mov    %eax,%edx
  8034c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034c6:	d3 e0                	shl    %cl,%eax
  8034c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d0:	89 f1                	mov    %esi,%ecx
  8034d2:	d3 e8                	shr    %cl,%eax
  8034d4:	09 d0                	or     %edx,%eax
  8034d6:	d3 eb                	shr    %cl,%ebx
  8034d8:	89 da                	mov    %ebx,%edx
  8034da:	f7 f7                	div    %edi
  8034dc:	89 d3                	mov    %edx,%ebx
  8034de:	f7 24 24             	mull   (%esp)
  8034e1:	89 c6                	mov    %eax,%esi
  8034e3:	89 d1                	mov    %edx,%ecx
  8034e5:	39 d3                	cmp    %edx,%ebx
  8034e7:	0f 82 87 00 00 00    	jb     803574 <__umoddi3+0x134>
  8034ed:	0f 84 91 00 00 00    	je     803584 <__umoddi3+0x144>
  8034f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034f7:	29 f2                	sub    %esi,%edx
  8034f9:	19 cb                	sbb    %ecx,%ebx
  8034fb:	89 d8                	mov    %ebx,%eax
  8034fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803501:	d3 e0                	shl    %cl,%eax
  803503:	89 e9                	mov    %ebp,%ecx
  803505:	d3 ea                	shr    %cl,%edx
  803507:	09 d0                	or     %edx,%eax
  803509:	89 e9                	mov    %ebp,%ecx
  80350b:	d3 eb                	shr    %cl,%ebx
  80350d:	89 da                	mov    %ebx,%edx
  80350f:	83 c4 1c             	add    $0x1c,%esp
  803512:	5b                   	pop    %ebx
  803513:	5e                   	pop    %esi
  803514:	5f                   	pop    %edi
  803515:	5d                   	pop    %ebp
  803516:	c3                   	ret    
  803517:	90                   	nop
  803518:	89 fd                	mov    %edi,%ebp
  80351a:	85 ff                	test   %edi,%edi
  80351c:	75 0b                	jne    803529 <__umoddi3+0xe9>
  80351e:	b8 01 00 00 00       	mov    $0x1,%eax
  803523:	31 d2                	xor    %edx,%edx
  803525:	f7 f7                	div    %edi
  803527:	89 c5                	mov    %eax,%ebp
  803529:	89 f0                	mov    %esi,%eax
  80352b:	31 d2                	xor    %edx,%edx
  80352d:	f7 f5                	div    %ebp
  80352f:	89 c8                	mov    %ecx,%eax
  803531:	f7 f5                	div    %ebp
  803533:	89 d0                	mov    %edx,%eax
  803535:	e9 44 ff ff ff       	jmp    80347e <__umoddi3+0x3e>
  80353a:	66 90                	xchg   %ax,%ax
  80353c:	89 c8                	mov    %ecx,%eax
  80353e:	89 f2                	mov    %esi,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	3b 04 24             	cmp    (%esp),%eax
  80354b:	72 06                	jb     803553 <__umoddi3+0x113>
  80354d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803551:	77 0f                	ja     803562 <__umoddi3+0x122>
  803553:	89 f2                	mov    %esi,%edx
  803555:	29 f9                	sub    %edi,%ecx
  803557:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80355b:	89 14 24             	mov    %edx,(%esp)
  80355e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803562:	8b 44 24 04          	mov    0x4(%esp),%eax
  803566:	8b 14 24             	mov    (%esp),%edx
  803569:	83 c4 1c             	add    $0x1c,%esp
  80356c:	5b                   	pop    %ebx
  80356d:	5e                   	pop    %esi
  80356e:	5f                   	pop    %edi
  80356f:	5d                   	pop    %ebp
  803570:	c3                   	ret    
  803571:	8d 76 00             	lea    0x0(%esi),%esi
  803574:	2b 04 24             	sub    (%esp),%eax
  803577:	19 fa                	sbb    %edi,%edx
  803579:	89 d1                	mov    %edx,%ecx
  80357b:	89 c6                	mov    %eax,%esi
  80357d:	e9 71 ff ff ff       	jmp    8034f3 <__umoddi3+0xb3>
  803582:	66 90                	xchg   %ax,%ax
  803584:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803588:	72 ea                	jb     803574 <__umoddi3+0x134>
  80358a:	89 d9                	mov    %ebx,%ecx
  80358c:	e9 62 ff ff ff       	jmp    8034f3 <__umoddi3+0xb3>
