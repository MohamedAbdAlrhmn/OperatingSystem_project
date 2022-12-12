
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 ff 00 00 00       	call   800135 <libmain>
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
  800098:	e8 d4 01 00 00       	call   800271 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 06 14 00 00       	call   8014ad <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int expected;
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 7f 19 00 00       	call   801a2e <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 97 35 80 00       	push   $0x803597
  8000b7:	50                   	push   %eax
  8000b8:	e8 d4 14 00 00       	call   801591 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 6d 16 00 00       	call   801735 <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 9c 35 80 00       	push   $0x80359c
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 ef 14 00 00       	call   8015d5 <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 c0 35 80 00       	push   $0x8035c0
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 37 16 00 00       	call   801735 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	expected = 1;
  80010a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 d8 35 80 00       	push   $0x8035d8
  800121:	6a 24                	push   $0x24
  800123:	68 7c 35 80 00       	push   $0x80357c
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 21 1a 00 00       	call   801b53 <inctst>

	return;
  800132:	90                   	nop
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013b:	e8 d5 18 00 00       	call   801a15 <sys_getenvindex>
  800140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800146:	89 d0                	mov    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	01 c0                	add    %eax,%eax
  80014f:	01 d0                	add    %edx,%eax
  800151:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800158:	01 d0                	add    %edx,%eax
  80015a:	c1 e0 04             	shl    $0x4,%eax
  80015d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800162:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800167:	a1 20 40 80 00       	mov    0x804020,%eax
  80016c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0f                	je     800185 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	05 5c 05 00 00       	add    $0x55c,%eax
  800180:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800189:	7e 0a                	jle    800195 <libmain+0x60>
		binaryname = argv[0];
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 fe ff ff       	call   800038 <_main>
  8001a3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a6:	e8 77 16 00 00       	call   801822 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 7c 36 80 00       	push   $0x80367c
  8001b3:	e8 6d 03 00 00       	call   800525 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	52                   	push   %edx
  8001d5:	50                   	push   %eax
  8001d6:	68 a4 36 80 00       	push   $0x8036a4
  8001db:	e8 45 03 00 00       	call   800525 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fe:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800204:	51                   	push   %ecx
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	68 cc 36 80 00       	push   $0x8036cc
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 24 37 80 00       	push   $0x803724
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 7c 36 80 00       	push   $0x80367c
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 f7 15 00 00       	call   80183c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800245:	e8 19 00 00 00       	call   800263 <exit>
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 00                	push   $0x0
  800258:	e8 84 17 00 00       	call   8019e1 <sys_destroy_env>
  80025d:	83 c4 10             	add    $0x10,%esp
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <exit>:

void
exit(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800269:	e8 d9 17 00 00       	call   801a47 <sys_exit_env>
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800277:	8d 45 10             	lea    0x10(%ebp),%eax
  80027a:	83 c0 04             	add    $0x4,%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800280:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800285:	85 c0                	test   %eax,%eax
  800287:	74 16                	je     80029f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800289:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	50                   	push   %eax
  800292:	68 38 37 80 00       	push   $0x803738
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 3d 37 80 00       	push   $0x80373d
  8002b0:	e8 70 02 00 00       	call   800525 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	e8 f3 01 00 00       	call   8004ba <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	68 59 37 80 00       	push   $0x803759
  8002d4:	e8 e1 01 00 00       	call   8004ba <vcprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002dc:	e8 82 ff ff ff       	call   800263 <exit>

	// should not return here
	while (1) ;
  8002e1:	eb fe                	jmp    8002e1 <_panic+0x70>

008002e3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ee:	8b 50 74             	mov    0x74(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 5c 37 80 00       	push   $0x80375c
  800300:	6a 26                	push   $0x26
  800302:	68 a8 37 80 00       	push   $0x8037a8
  800307:	e8 65 ff ff ff       	call   800271 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031a:	e9 c2 00 00 00       	jmp    8003e1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	85 c0                	test   %eax,%eax
  800332:	75 08                	jne    80033c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800334:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800337:	e9 a2 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80033c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034a:	eb 69                	jmp    8003b5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034c:	a1 20 40 80 00       	mov    0x804020,%eax
  800351:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035a:	89 d0                	mov    %edx,%eax
  80035c:	01 c0                	add    %eax,%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	c1 e0 03             	shl    $0x3,%eax
  800363:	01 c8                	add    %ecx,%eax
  800365:	8a 40 04             	mov    0x4(%eax),%al
  800368:	84 c0                	test   %al,%al
  80036a:	75 46                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	a1 20 40 80 00       	mov    0x804020,%eax
  800371:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037a:	89 d0                	mov    %edx,%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 03             	shl    $0x3,%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 c8                	add    %ecx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	75 09                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b0:	eb 12                	jmp    8003c4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 50 74             	mov    0x74(%eax),%edx
  8003bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c0:	39 c2                	cmp    %eax,%edx
  8003c2:	77 88                	ja     80034c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c8:	75 14                	jne    8003de <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 b4 37 80 00       	push   $0x8037b4
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 a8 37 80 00       	push   $0x8037a8
  8003d9:	e8 93 fe ff ff       	call   800271 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003de:	ff 45 f0             	incl   -0x10(%ebp)
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e7:	0f 8c 32 ff ff ff    	jl     80031f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fb:	eb 26                	jmp    800423 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800402:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800408:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040b:	89 d0                	mov    %edx,%eax
  80040d:	01 c0                	add    %eax,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	c1 e0 03             	shl    $0x3,%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8a 40 04             	mov    0x4(%eax),%al
  800419:	3c 01                	cmp    $0x1,%al
  80041b:	75 03                	jne    800420 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80041d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	ff 45 e0             	incl   -0x20(%ebp)
  800423:	a1 20 40 80 00       	mov    0x804020,%eax
  800428:	8b 50 74             	mov    0x74(%eax),%edx
  80042b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	77 cb                	ja     8003fd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800435:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800438:	74 14                	je     80044e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	68 08 38 80 00       	push   $0x803808
  800442:	6a 44                	push   $0x44
  800444:	68 a8 37 80 00       	push   $0x8037a8
  800449:	e8 23 fe ff ff       	call   800271 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044e:	90                   	nop
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 48 01             	lea    0x1(%eax),%ecx
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	89 0a                	mov    %ecx,(%edx)
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	88 d1                	mov    %dl,%cl
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047a:	75 2c                	jne    8004a8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047c:	a0 24 40 80 00       	mov    0x804024,%al
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	8b 55 0c             	mov    0xc(%ebp),%edx
  800487:	8b 12                	mov    (%edx),%edx
  800489:	89 d1                	mov    %edx,%ecx
  80048b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048e:	83 c2 08             	add    $0x8,%edx
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	50                   	push   %eax
  800495:	51                   	push   %ecx
  800496:	52                   	push   %edx
  800497:	e8 d8 11 00 00       	call   801674 <sys_cputs>
  80049c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 40 04             	mov    0x4(%eax),%eax
  8004ae:	8d 50 01             	lea    0x1(%eax),%edx
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ca:	00 00 00 
	b.cnt = 0;
  8004cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	ff 75 08             	pushl  0x8(%ebp)
  8004dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	68 51 04 80 00       	push   $0x800451
  8004e9:	e8 11 02 00 00       	call   8006ff <vprintfmt>
  8004ee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f1:	a0 24 40 80 00       	mov    0x804024,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	50                   	push   %eax
  800503:	52                   	push   %edx
  800504:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050a:	83 c0 08             	add    $0x8,%eax
  80050d:	50                   	push   %eax
  80050e:	e8 61 11 00 00       	call   801674 <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800516:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80051d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <cprintf>:

int cprintf(const char *fmt, ...) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 73 ff ff ff       	call   8004ba <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800558:	e8 c5 12 00 00       	call   801822 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800560:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 f4             	pushl  -0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	e8 48 ff ff ff       	call   8004ba <vcprintf>
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800578:	e8 bf 12 00 00       	call   80183c <sys_enable_interrupt>
	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	53                   	push   %ebx
  800586:	83 ec 14             	sub    $0x14,%esp
  800589:	8b 45 10             	mov    0x10(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800595:	8b 45 18             	mov    0x18(%ebp),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a0:	77 55                	ja     8005f7 <printnum+0x75>
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	72 05                	jb     8005ac <printnum+0x2a>
  8005a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005aa:	77 4b                	ja     8005f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	52                   	push   %edx
  8005bb:	50                   	push   %eax
  8005bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c2:	e8 31 2d 00 00       	call   8032f8 <__udivdi3>
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	ff 75 20             	pushl  0x20(%ebp)
  8005d0:	53                   	push   %ebx
  8005d1:	ff 75 18             	pushl  0x18(%ebp)
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	e8 a1 ff ff ff       	call   800582 <printnum>
  8005e1:	83 c4 20             	add    $0x20,%esp
  8005e4:	eb 1a                	jmp    800600 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	ff d0                	call   *%eax
  8005f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8005fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fe:	7f e6                	jg     8005e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800600:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800603:	bb 00 00 00 00       	mov    $0x0,%ebx
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060e:	53                   	push   %ebx
  80060f:	51                   	push   %ecx
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	e8 f1 2d 00 00       	call   803408 <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 74 3a 80 00       	add    $0x803a74,%eax
  80061f:	8a 00                	mov    (%eax),%al
  800621:	0f be c0             	movsbl %al,%eax
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	50                   	push   %eax
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	ff d0                	call   *%eax
  800630:	83 c4 10             	add    $0x10,%esp
}
  800633:	90                   	nop
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800640:	7e 1c                	jle    80065e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	8d 50 08             	lea    0x8(%eax),%edx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 10                	mov    %edx,(%eax)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 e8 08             	sub    $0x8,%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	eb 40                	jmp    80069e <getuint+0x65>
	else if (lflag)
  80065e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800662:	74 1e                	je     800682 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	8d 50 04             	lea    0x4(%eax),%edx
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	89 10                	mov    %edx,(%eax)
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	eb 1c                	jmp    80069e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a7:	7e 1c                	jle    8006c5 <getint+0x25>
		return va_arg(*ap, long long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 08             	lea    0x8(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 08             	sub    $0x8,%eax
  8006be:	8b 50 04             	mov    0x4(%eax),%edx
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	eb 38                	jmp    8006fd <getint+0x5d>
	else if (lflag)
  8006c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c9:	74 1a                	je     8006e5 <getint+0x45>
		return va_arg(*ap, long);
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	89 10                	mov    %edx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	83 e8 04             	sub    $0x4,%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	99                   	cltd   
  8006e3:	eb 18                	jmp    8006fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	56                   	push   %esi
  800703:	53                   	push   %ebx
  800704:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x21>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 af 03 00 00    	je     800ac0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	53                   	push   %ebx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	8d 50 01             	lea    0x1(%eax),%edx
  800726:	89 55 10             	mov    %edx,0x10(%ebp)
  800729:	8a 00                	mov    (%eax),%al
  80072b:	0f b6 d8             	movzbl %al,%ebx
  80072e:	83 fb 25             	cmp    $0x25,%ebx
  800731:	75 d6                	jne    800709 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800733:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800737:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800745:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800753:	8b 45 10             	mov    0x10(%ebp),%eax
  800756:	8d 50 01             	lea    0x1(%eax),%edx
  800759:	89 55 10             	mov    %edx,0x10(%ebp)
  80075c:	8a 00                	mov    (%eax),%al
  80075e:	0f b6 d8             	movzbl %al,%ebx
  800761:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800764:	83 f8 55             	cmp    $0x55,%eax
  800767:	0f 87 2b 03 00 00    	ja     800a98 <vprintfmt+0x399>
  80076d:	8b 04 85 98 3a 80 00 	mov    0x803a98(,%eax,4),%eax
  800774:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800776:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077a:	eb d7                	jmp    800753 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800780:	eb d1                	jmp    800753 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800782:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078c:	89 d0                	mov    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	01 d0                	add    %edx,%eax
  800793:	01 c0                	add    %eax,%eax
  800795:	01 d8                	add    %ebx,%eax
  800797:	83 e8 30             	sub    $0x30,%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079d:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 3e                	jle    8007e8 <vprintfmt+0xe9>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 39                	jg     8007e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b2:	eb d5                	jmp    800789 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c8:	eb 1f                	jmp    8007e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ce:	79 83                	jns    800753 <vprintfmt+0x54>
				width = 0;
  8007d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d7:	e9 77 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e3:	e9 6b ff ff ff       	jmp    800753 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	0f 89 60 ff ff ff    	jns    800753 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800800:	e9 4e ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800805:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800808:	e9 46 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	50                   	push   %eax
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	e9 89 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800843:	85 db                	test   %ebx,%ebx
  800845:	79 02                	jns    800849 <vprintfmt+0x14a>
				err = -err;
  800847:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800849:	83 fb 64             	cmp    $0x64,%ebx
  80084c:	7f 0b                	jg     800859 <vprintfmt+0x15a>
  80084e:	8b 34 9d e0 38 80 00 	mov    0x8038e0(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 85 3a 80 00       	push   $0x803a85
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 5e 02 00 00       	call   800ac8 <printfmt>
  80086a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086d:	e9 49 02 00 00       	jmp    800abb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800872:	56                   	push   %esi
  800873:	68 8e 3a 80 00       	push   $0x803a8e
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 45 02 00 00       	call   800ac8 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	e9 30 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 30                	mov    (%eax),%esi
  80089c:	85 f6                	test   %esi,%esi
  80089e:	75 05                	jne    8008a5 <vprintfmt+0x1a6>
				p = "(null)";
  8008a0:	be 91 3a 80 00       	mov    $0x803a91,%esi
			if (width > 0 && padc != '-')
  8008a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a9:	7e 6d                	jle    800918 <vprintfmt+0x219>
  8008ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008af:	74 67                	je     800918 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	50                   	push   %eax
  8008b8:	56                   	push   %esi
  8008b9:	e8 0c 03 00 00       	call   800bca <strnlen>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c4:	eb 16                	jmp    8008dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e0:	7f e4                	jg     8008c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	eb 34                	jmp    800918 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e8:	74 1c                	je     800906 <vprintfmt+0x207>
  8008ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ed:	7e 05                	jle    8008f4 <vprintfmt+0x1f5>
  8008ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f2:	7e 12                	jle    800906 <vprintfmt+0x207>
					putch('?', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	6a 3f                	push   $0x3f
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	ff 4d e4             	decl   -0x1c(%ebp)
  800918:	89 f0                	mov    %esi,%eax
  80091a:	8d 70 01             	lea    0x1(%eax),%esi
  80091d:	8a 00                	mov    (%eax),%al
  80091f:	0f be d8             	movsbl %al,%ebx
  800922:	85 db                	test   %ebx,%ebx
  800924:	74 24                	je     80094a <vprintfmt+0x24b>
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	78 b8                	js     8008e4 <vprintfmt+0x1e5>
  80092c:	ff 4d e0             	decl   -0x20(%ebp)
  80092f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800933:	79 af                	jns    8008e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800935:	eb 13                	jmp    80094a <vprintfmt+0x24b>
				putch(' ', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 20                	push   $0x20
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	ff 4d e4             	decl   -0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e7                	jg     800937 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800950:	e9 66 01 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 e8             	pushl  -0x18(%ebp)
  80095b:	8d 45 14             	lea    0x14(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	e8 3c fd ff ff       	call   8006a0 <getint>
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800973:	85 d2                	test   %edx,%edx
  800975:	79 23                	jns    80099a <vprintfmt+0x29b>
				putch('-', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 2d                	push   $0x2d
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	f7 d8                	neg    %eax
  80098f:	83 d2 00             	adc    $0x0,%edx
  800992:	f7 da                	neg    %edx
  800994:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800997:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a1:	e9 bc 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	e8 84 fc ff ff       	call   800639 <getuint>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c5:	e9 98 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 58                	push   $0x58
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			break;
  8009fa:	e9 bc 00 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 30                	push   $0x30
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 78                	push   $0x78
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 c0 04             	add    $0x4,%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 e8 04             	sub    $0x4,%eax
  800a2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a41:	eb 1f                	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 e7 fb ff ff       	call   800639 <getuint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	83 ec 04             	sub    $0x4,%esp
  800a6c:	52                   	push   %edx
  800a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 00 fb ff ff       	call   800582 <printnum>
  800a82:	83 c4 20             	add    $0x20,%esp
			break;
  800a85:	eb 34                	jmp    800abb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			break;
  800a96:	eb 23                	jmp    800abb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 25                	push   $0x25
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	eb 03                	jmp    800ab0 <vprintfmt+0x3b1>
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	48                   	dec    %eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	3c 25                	cmp    $0x25,%al
  800ab8:	75 f3                	jne    800aad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aba:	90                   	nop
		}
	}
  800abb:	e9 47 fc ff ff       	jmp    800707 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ace:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 16 fc ff ff       	call   8006ff <vprintfmt>
  800ae9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aec:	90                   	nop
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 40 08             	mov    0x8(%eax),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	8b 10                	mov    (%eax),%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 40 04             	mov    0x4(%eax),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	73 12                	jae    800b22 <sprintputch+0x33>
		*b->buf++ = ch;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	8d 48 01             	lea    0x1(%eax),%ecx
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 0a                	mov    %ecx,(%edx)
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	88 10                	mov    %dl,(%eax)
}
  800b22:	90                   	nop
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4a:	74 06                	je     800b52 <vsnprintf+0x2d>
  800b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b50:	7f 07                	jg     800b59 <vsnprintf+0x34>
		return -E_INVAL;
  800b52:	b8 03 00 00 00       	mov    $0x3,%eax
  800b57:	eb 20                	jmp    800b79 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b59:	ff 75 14             	pushl  0x14(%ebp)
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	68 ef 0a 80 00       	push   $0x800aef
  800b68:	e8 92 fb ff ff       	call   8006ff <vprintfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b81:	8d 45 10             	lea    0x10(%ebp),%eax
  800b84:	83 c0 04             	add    $0x4,%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 89 ff ff ff       	call   800b25 <vsnprintf>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb4:	eb 06                	jmp    800bbc <strlen+0x15>
		n++;
  800bb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	ff 45 08             	incl   0x8(%ebp)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	75 f1                	jne    800bb6 <strlen+0xf>
		n++;
	return n;
  800bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd7:	eb 09                	jmp    800be2 <strnlen+0x18>
		n++;
  800bd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdc:	ff 45 08             	incl   0x8(%ebp)
  800bdf:	ff 4d 0c             	decl   0xc(%ebp)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 09                	je     800bf1 <strnlen+0x27>
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e8                	jne    800bd9 <strnlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c02:	90                   	nop
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	75 e4                	jne    800c03 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 1f                	jmp    800c58 <strncpy+0x34>
		*dst++ = *src;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 03                	je     800c55 <strncpy+0x31>
			src++;
  800c52:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5e:	72 d9                	jb     800c39 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 30                	je     800ca7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c77:	eb 16                	jmp    800c8f <strlcpy+0x2a>
			*dst++ = *src++;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8b:	8a 12                	mov    (%edx),%dl
  800c8d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8f:	ff 4d 10             	decl   0x10(%ebp)
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 09                	je     800ca1 <strlcpy+0x3c>
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	84 c0                	test   %al,%al
  800c9f:	75 d8                	jne    800c79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	29 c2                	sub    %eax,%edx
  800caf:	89 d0                	mov    %edx,%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb6:	eb 06                	jmp    800cbe <strcmp+0xb>
		p++, q++;
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 0e                	je     800cd5 <strcmp+0x22>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	38 c2                	cmp    %al,%dl
  800cd3:	74 e3                	je     800cb8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	0f b6 d0             	movzbl %al,%edx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cee:	eb 09                	jmp    800cf9 <strncmp+0xe>
		n--, p++, q++;
  800cf0:	ff 4d 10             	decl   0x10(%ebp)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	74 17                	je     800d16 <strncmp+0x2b>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strncmp+0x2b>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 da                	je     800cf0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	75 07                	jne    800d23 <strncmp+0x38>
		return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	eb 14                	jmp    800d37 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 04             	sub    $0x4,%esp
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d45:	eb 12                	jmp    800d59 <strchr+0x20>
		if (*s == c)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4f:	75 05                	jne    800d56 <strchr+0x1d>
			return (char *) s;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	eb 11                	jmp    800d67 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 e5                	jne    800d47 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 0d                	jmp    800d84 <strfind+0x1b>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	74 0e                	je     800d8f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	75 ea                	jne    800d77 <strfind+0xe>
  800d8d:	eb 01                	jmp    800d90 <strfind+0x27>
		if (*s == c)
			break;
  800d8f:	90                   	nop
	return (char *) s;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da7:	eb 0e                	jmp    800db7 <memset+0x22>
		*p++ = c;
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db7:	ff 4d f8             	decl   -0x8(%ebp)
  800dba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbe:	79 e9                	jns    800da9 <memset+0x14>
		*p++ = c;

	return v;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd7:	eb 16                	jmp    800def <memcpy+0x2a>
		*d++ = *s++;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800deb:	8a 12                	mov    (%edx),%dl
  800ded:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 dd                	jne    800dd9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e19:	73 50                	jae    800e6b <memmove+0x6a>
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e26:	76 43                	jbe    800e6b <memmove+0x6a>
		s += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e34:	eb 10                	jmp    800e46 <memmove+0x45>
			*--d = *--s;
  800e36:	ff 4d f8             	decl   -0x8(%ebp)
  800e39:	ff 4d fc             	decl   -0x4(%ebp)
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	8a 10                	mov    (%eax),%dl
  800e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e44:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e3                	jne    800e36 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e53:	eb 23                	jmp    800e78 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e67:	8a 12                	mov    (%edx),%dl
  800e69:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 dd                	jne    800e55 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8f:	eb 2a                	jmp    800ebb <memcmp+0x3e>
		if (*s1 != *s2)
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	8a 10                	mov    (%eax),%dl
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	38 c2                	cmp    %al,%dl
  800e9d:	74 16                	je     800eb5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f b6 d0             	movzbl %al,%edx
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 c0             	movzbl %al,%eax
  800eaf:	29 c2                	sub    %eax,%edx
  800eb1:	89 d0                	mov    %edx,%eax
  800eb3:	eb 18                	jmp    800ecd <memcmp+0x50>
		s1++, s2++;
  800eb5:	ff 45 fc             	incl   -0x4(%ebp)
  800eb8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 c9                	jne    800e91 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee0:	eb 15                	jmp    800ef7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	39 c2                	cmp    %eax,%edx
  800ef2:	74 0d                	je     800f01 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efd:	72 e3                	jb     800ee2 <memfind+0x13>
  800eff:	eb 01                	jmp    800f02 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f01:	90                   	nop
	return (void *) s;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	eb 03                	jmp    800f20 <strtol+0x19>
		s++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 20                	cmp    $0x20,%al
  800f27:	74 f4                	je     800f1d <strtol+0x16>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 09                	cmp    $0x9,%al
  800f30:	74 eb                	je     800f1d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 2b                	cmp    $0x2b,%al
  800f39:	75 05                	jne    800f40 <strtol+0x39>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	eb 13                	jmp    800f53 <strtol+0x4c>
	else if (*s == '-')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2d                	cmp    $0x2d,%al
  800f47:	75 0a                	jne    800f53 <strtol+0x4c>
		s++, neg = 1;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 06                	je     800f5f <strtol+0x58>
  800f59:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5d:	75 20                	jne    800f7f <strtol+0x78>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 30                	cmp    $0x30,%al
  800f66:	75 17                	jne    800f7f <strtol+0x78>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	40                   	inc    %eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	3c 78                	cmp    $0x78,%al
  800f70:	75 0d                	jne    800f7f <strtol+0x78>
		s += 2, base = 16;
  800f72:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f76:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7d:	eb 28                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 15                	jne    800f9a <strtol+0x93>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 30                	cmp    $0x30,%al
  800f8c:	75 0c                	jne    800f9a <strtol+0x93>
		s++, base = 8;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f98:	eb 0d                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0)
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	75 07                	jne    800fa7 <strtol+0xa0>
		base = 10;
  800fa0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 2f                	cmp    $0x2f,%al
  800fae:	7e 19                	jle    800fc9 <strtol+0xc2>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 39                	cmp    $0x39,%al
  800fb7:	7f 10                	jg     800fc9 <strtol+0xc2>
			dig = *s - '0';
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 30             	sub    $0x30,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc7:	eb 42                	jmp    80100b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 60                	cmp    $0x60,%al
  800fd0:	7e 19                	jle    800feb <strtol+0xe4>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 7a                	cmp    $0x7a,%al
  800fd9:	7f 10                	jg     800feb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	83 e8 57             	sub    $0x57,%eax
  800fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe9:	eb 20                	jmp    80100b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 40                	cmp    $0x40,%al
  800ff2:	7e 39                	jle    80102d <strtol+0x126>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 5a                	cmp    $0x5a,%al
  800ffb:	7f 30                	jg     80102d <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 37             	sub    $0x37,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801011:	7d 19                	jge    80102c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801027:	e9 7b ff ff ff       	jmp    800fa7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801031:	74 08                	je     80103b <strtol+0x134>
		*endptr = (char *) s;
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103f:	74 07                	je     801048 <strtol+0x141>
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	f7 d8                	neg    %eax
  801046:	eb 03                	jmp    80104b <strtol+0x144>
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <ltostr>:

void
ltostr(long value, char *str)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801065:	79 13                	jns    80107a <ltostr+0x2d>
	{
		neg = 1;
  801067:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801074:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801077:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801082:	99                   	cltd   
  801083:	f7 f9                	idiv   %ecx
  801085:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801091:	89 c2                	mov    %eax,%edx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109b:	83 c2 30             	add    $0x30,%edx
  80109e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a8:	f7 e9                	imul   %ecx
  8010aa:	c1 fa 02             	sar    $0x2,%edx
  8010ad:	89 c8                	mov    %ecx,%eax
  8010af:	c1 f8 1f             	sar    $0x1f,%eax
  8010b2:	29 c2                	sub    %eax,%edx
  8010b4:	89 d0                	mov    %edx,%eax
  8010b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	c1 e0 02             	shl    $0x2,%eax
  8010d2:	01 d0                	add    %edx,%eax
  8010d4:	01 c0                	add    %eax,%eax
  8010d6:	29 c1                	sub    %eax,%ecx
  8010d8:	89 ca                	mov    %ecx,%edx
  8010da:	85 d2                	test   %edx,%edx
  8010dc:	75 9c                	jne    80107a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	48                   	dec    %eax
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 3d                	je     80112f <ltostr+0xe2>
		start = 1 ;
  8010f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f9:	eb 34                	jmp    80112f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 c2                	add    %eax,%edx
  801124:	8a 45 eb             	mov    -0x15(%ebp),%al
  801127:	88 02                	mov    %al,(%edx)
		start++ ;
  801129:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c c4                	jl     8010fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801137:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 54 fa ff ff       	call   800ba7 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 46 fa ff ff       	call   800ba7 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801175:	eb 17                	jmp    80118e <strcconcat+0x49>
		final[s] = str1[s] ;
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c8                	add    %ecx,%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801191:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801194:	7c e1                	jl     801177 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a4:	eb 1f                	jmp    8011c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c2:	ff 45 f8             	incl   -0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c d9                	jl     8011a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	eb 0c                	jmp    80120c <strsplit+0x31>
			*string++ = 0;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 08             	mov    %edx,0x8(%ebp)
  801209:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 18                	je     80122d <strsplit+0x52>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 13 fb ff ff       	call   800d39 <strchr>
  801226:	83 c4 08             	add    $0x8,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 d3                	jne    801200 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 5a                	je     801290 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	83 f8 0f             	cmp    $0xf,%eax
  80123e:	75 07                	jne    801247 <strsplit+0x6c>
		{
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 66                	jmp    8012ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 14             	mov    0x14(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	eb 03                	jmp    80126a <strsplit+0x8f>
			string++;
  801267:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	74 8b                	je     8011fe <strsplit+0x23>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 b5 fa ff ff       	call   800d39 <strchr>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	74 dc                	je     801267 <strsplit+0x8c>
			string++;
	}
  80128b:	e9 6e ff ff ff       	jmp    8011fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801290:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 1f                	je     8012dd <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012be:	e8 1d 00 00 00       	call   8012e0 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	68 f0 3b 80 00       	push   $0x803bf0
  8012cb:	e8 55 f2 ff ff       	call   800525 <cprintf>
  8012d0:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d3:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012da:	00 00 00 
	}
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8012e6:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012ed:	00 00 00 
  8012f0:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012f7:	00 00 00 
  8012fa:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801301:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801304:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80130b:	00 00 00 
  80130e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801315:	00 00 00 
  801318:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80131f:	00 00 00 
	uint32 arr_size = 0;
  801322:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801329:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801333:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801338:	2d 00 10 00 00       	sub    $0x1000,%eax
  80133d:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801342:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801349:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80134c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801353:	a1 20 41 80 00       	mov    0x804120,%eax
  801358:	c1 e0 04             	shl    $0x4,%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	48                   	dec    %eax
  801363:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801369:	ba 00 00 00 00       	mov    $0x0,%edx
  80136e:	f7 75 ec             	divl   -0x14(%ebp)
  801371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801374:	29 d0                	sub    %edx,%eax
  801376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801379:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801383:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801388:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138d:	83 ec 04             	sub    $0x4,%esp
  801390:	6a 06                	push   $0x6
  801392:	ff 75 f4             	pushl  -0xc(%ebp)
  801395:	50                   	push   %eax
  801396:	e8 1d 04 00 00       	call   8017b8 <sys_allocate_chunk>
  80139b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139e:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	50                   	push   %eax
  8013a7:	e8 92 0a 00 00       	call   801e3e <initialize_MemBlocksList>
  8013ac:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013af:	a1 48 41 80 00       	mov    0x804148,%eax
  8013b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ba:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8013c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8013cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013cf:	75 14                	jne    8013e5 <initialize_dyn_block_system+0x105>
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	68 15 3c 80 00       	push   $0x803c15
  8013d9:	6a 33                	push   $0x33
  8013db:	68 33 3c 80 00       	push   $0x803c33
  8013e0:	e8 8c ee ff ff       	call   800271 <_panic>
  8013e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e8:	8b 00                	mov    (%eax),%eax
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	74 10                	je     8013fe <initialize_dyn_block_system+0x11e>
  8013ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013f6:	8b 52 04             	mov    0x4(%edx),%edx
  8013f9:	89 50 04             	mov    %edx,0x4(%eax)
  8013fc:	eb 0b                	jmp    801409 <initialize_dyn_block_system+0x129>
  8013fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801401:	8b 40 04             	mov    0x4(%eax),%eax
  801404:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140c:	8b 40 04             	mov    0x4(%eax),%eax
  80140f:	85 c0                	test   %eax,%eax
  801411:	74 0f                	je     801422 <initialize_dyn_block_system+0x142>
  801413:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801416:	8b 40 04             	mov    0x4(%eax),%eax
  801419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80141c:	8b 12                	mov    (%edx),%edx
  80141e:	89 10                	mov    %edx,(%eax)
  801420:	eb 0a                	jmp    80142c <initialize_dyn_block_system+0x14c>
  801422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801425:	8b 00                	mov    (%eax),%eax
  801427:	a3 48 41 80 00       	mov    %eax,0x804148
  80142c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801435:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80143f:	a1 54 41 80 00       	mov    0x804154,%eax
  801444:	48                   	dec    %eax
  801445:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80144a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80144e:	75 14                	jne    801464 <initialize_dyn_block_system+0x184>
  801450:	83 ec 04             	sub    $0x4,%esp
  801453:	68 40 3c 80 00       	push   $0x803c40
  801458:	6a 34                	push   $0x34
  80145a:	68 33 3c 80 00       	push   $0x803c33
  80145f:	e8 0d ee ff ff       	call   800271 <_panic>
  801464:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80146a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146d:	89 10                	mov    %edx,(%eax)
  80146f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	85 c0                	test   %eax,%eax
  801476:	74 0d                	je     801485 <initialize_dyn_block_system+0x1a5>
  801478:	a1 38 41 80 00       	mov    0x804138,%eax
  80147d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801480:	89 50 04             	mov    %edx,0x4(%eax)
  801483:	eb 08                	jmp    80148d <initialize_dyn_block_system+0x1ad>
  801485:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801488:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80148d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801490:	a3 38 41 80 00       	mov    %eax,0x804138
  801495:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80149f:	a1 44 41 80 00       	mov    0x804144,%eax
  8014a4:	40                   	inc    %eax
  8014a5:	a3 44 41 80 00       	mov    %eax,0x804144
}
  8014aa:	90                   	nop
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    

008014ad <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b3:	e8 f7 fd ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  8014b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014bc:	75 07                	jne    8014c5 <malloc+0x18>
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	eb 14                	jmp    8014d9 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014c5:	83 ec 04             	sub    $0x4,%esp
  8014c8:	68 64 3c 80 00       	push   $0x803c64
  8014cd:	6a 46                	push   $0x46
  8014cf:	68 33 3c 80 00       	push   $0x803c33
  8014d4:	e8 98 ed ff ff       	call   800271 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    

008014db <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
  8014de:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	68 8c 3c 80 00       	push   $0x803c8c
  8014e9:	6a 61                	push   $0x61
  8014eb:	68 33 3c 80 00       	push   $0x803c33
  8014f0:	e8 7c ed ff ff       	call   800271 <_panic>

008014f5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 38             	sub    $0x38,%esp
  8014fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fe:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801501:	e8 a9 fd ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  801506:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80150a:	75 07                	jne    801513 <smalloc+0x1e>
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	eb 7c                	jmp    80158f <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801513:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80151a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801520:	01 d0                	add    %edx,%eax
  801522:	48                   	dec    %eax
  801523:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801529:	ba 00 00 00 00       	mov    $0x0,%edx
  80152e:	f7 75 f0             	divl   -0x10(%ebp)
  801531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801534:	29 d0                	sub    %edx,%eax
  801536:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801539:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801540:	e8 41 06 00 00       	call   801b86 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801545:	85 c0                	test   %eax,%eax
  801547:	74 11                	je     80155a <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801549:	83 ec 0c             	sub    $0xc,%esp
  80154c:	ff 75 e8             	pushl  -0x18(%ebp)
  80154f:	e8 ac 0c 00 00       	call   802200 <alloc_block_FF>
  801554:	83 c4 10             	add    $0x10,%esp
  801557:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80155a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80155e:	74 2a                	je     80158a <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	8b 40 08             	mov    0x8(%eax),%eax
  801566:	89 c2                	mov    %eax,%edx
  801568:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80156c:	52                   	push   %edx
  80156d:	50                   	push   %eax
  80156e:	ff 75 0c             	pushl  0xc(%ebp)
  801571:	ff 75 08             	pushl  0x8(%ebp)
  801574:	e8 92 03 00 00       	call   80190b <sys_createSharedObject>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  80157f:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801583:	74 05                	je     80158a <smalloc+0x95>
			return (void*)virtual_address;
  801585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801588:	eb 05                	jmp    80158f <smalloc+0x9a>
	}
	return NULL;
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801597:	e8 13 fd ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  80159c:	83 ec 04             	sub    $0x4,%esp
  80159f:	68 b0 3c 80 00       	push   $0x803cb0
  8015a4:	68 a2 00 00 00       	push   $0xa2
  8015a9:	68 33 3c 80 00       	push   $0x803c33
  8015ae:	e8 be ec ff ff       	call   800271 <_panic>

008015b3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
  8015b6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b9:	e8 f1 fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	68 d4 3c 80 00       	push   $0x803cd4
  8015c6:	68 e6 00 00 00       	push   $0xe6
  8015cb:	68 33 3c 80 00       	push   $0x803c33
  8015d0:	e8 9c ec ff ff       	call   800271 <_panic>

008015d5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015db:	83 ec 04             	sub    $0x4,%esp
  8015de:	68 fc 3c 80 00       	push   $0x803cfc
  8015e3:	68 fa 00 00 00       	push   $0xfa
  8015e8:	68 33 3c 80 00       	push   $0x803c33
  8015ed:	e8 7f ec ff ff       	call   800271 <_panic>

008015f2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015f8:	83 ec 04             	sub    $0x4,%esp
  8015fb:	68 20 3d 80 00       	push   $0x803d20
  801600:	68 05 01 00 00       	push   $0x105
  801605:	68 33 3c 80 00       	push   $0x803c33
  80160a:	e8 62 ec ff ff       	call   800271 <_panic>

0080160f <shrink>:

}
void shrink(uint32 newSize)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801615:	83 ec 04             	sub    $0x4,%esp
  801618:	68 20 3d 80 00       	push   $0x803d20
  80161d:	68 0a 01 00 00       	push   $0x10a
  801622:	68 33 3c 80 00       	push   $0x803c33
  801627:	e8 45 ec ff ff       	call   800271 <_panic>

0080162c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801632:	83 ec 04             	sub    $0x4,%esp
  801635:	68 20 3d 80 00       	push   $0x803d20
  80163a:	68 0f 01 00 00       	push   $0x10f
  80163f:	68 33 3c 80 00       	push   $0x803c33
  801644:	e8 28 ec ff ff       	call   800271 <_panic>

00801649 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	57                   	push   %edi
  80164d:	56                   	push   %esi
  80164e:	53                   	push   %ebx
  80164f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80165e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801661:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801664:	cd 30                	int    $0x30
  801666:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801669:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	5b                   	pop    %ebx
  801670:	5e                   	pop    %esi
  801671:	5f                   	pop    %edi
  801672:	5d                   	pop    %ebp
  801673:	c3                   	ret    

00801674 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	8b 45 10             	mov    0x10(%ebp),%eax
  80167d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801680:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	52                   	push   %edx
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	50                   	push   %eax
  801690:	6a 00                	push   $0x0
  801692:	e8 b2 ff ff ff       	call   801649 <syscall>
  801697:	83 c4 18             	add    $0x18,%esp
}
  80169a:	90                   	nop
  80169b:	c9                   	leave  
  80169c:	c3                   	ret    

0080169d <sys_cgetc>:

int
sys_cgetc(void)
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 01                	push   $0x1
  8016ac:	e8 98 ff ff ff       	call   801649 <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	52                   	push   %edx
  8016c6:	50                   	push   %eax
  8016c7:	6a 05                	push   $0x5
  8016c9:	e8 7b ff ff ff       	call   801649 <syscall>
  8016ce:	83 c4 18             	add    $0x18,%esp
}
  8016d1:	c9                   	leave  
  8016d2:	c3                   	ret    

008016d3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	56                   	push   %esi
  8016d7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8016db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e7:	56                   	push   %esi
  8016e8:	53                   	push   %ebx
  8016e9:	51                   	push   %ecx
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	6a 06                	push   $0x6
  8016ee:	e8 56 ff ff ff       	call   801649 <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016f9:	5b                   	pop    %ebx
  8016fa:	5e                   	pop    %esi
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    

008016fd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801700:	8b 55 0c             	mov    0xc(%ebp),%edx
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	52                   	push   %edx
  80170d:	50                   	push   %eax
  80170e:	6a 07                	push   $0x7
  801710:	e8 34 ff ff ff       	call   801649 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	6a 00                	push   $0x0
  801723:	ff 75 0c             	pushl  0xc(%ebp)
  801726:	ff 75 08             	pushl  0x8(%ebp)
  801729:	6a 08                	push   $0x8
  80172b:	e8 19 ff ff ff       	call   801649 <syscall>
  801730:	83 c4 18             	add    $0x18,%esp
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 09                	push   $0x9
  801744:	e8 00 ff ff ff       	call   801649 <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801751:	6a 00                	push   $0x0
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 0a                	push   $0xa
  80175d:	e8 e7 fe ff ff       	call   801649 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 0b                	push   $0xb
  801776:	e8 ce fe ff ff       	call   801649 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	ff 75 08             	pushl  0x8(%ebp)
  80178f:	6a 0f                	push   $0xf
  801791:	e8 b3 fe ff ff       	call   801649 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
	return;
  801799:	90                   	nop
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	ff 75 0c             	pushl  0xc(%ebp)
  8017a8:	ff 75 08             	pushl  0x8(%ebp)
  8017ab:	6a 10                	push   $0x10
  8017ad:	e8 97 fe ff ff       	call   801649 <syscall>
  8017b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8017b5:	90                   	nop
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	ff 75 10             	pushl  0x10(%ebp)
  8017c2:	ff 75 0c             	pushl  0xc(%ebp)
  8017c5:	ff 75 08             	pushl  0x8(%ebp)
  8017c8:	6a 11                	push   $0x11
  8017ca:	e8 7a fe ff ff       	call   801649 <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8017d2:	90                   	nop
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 0c                	push   $0xc
  8017e4:	e8 60 fe ff ff       	call   801649 <syscall>
  8017e9:	83 c4 18             	add    $0x18,%esp
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	ff 75 08             	pushl  0x8(%ebp)
  8017fc:	6a 0d                	push   $0xd
  8017fe:	e8 46 fe ff ff       	call   801649 <syscall>
  801803:	83 c4 18             	add    $0x18,%esp
}
  801806:	c9                   	leave  
  801807:	c3                   	ret    

00801808 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 0e                	push   $0xe
  801817:	e8 2d fe ff ff       	call   801649 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
}
  80181f:	90                   	nop
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 13                	push   $0x13
  801831:	e8 13 fe ff ff       	call   801649 <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	90                   	nop
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 00                	push   $0x0
  801849:	6a 14                	push   $0x14
  80184b:	e8 f9 fd ff ff       	call   801649 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	90                   	nop
  801854:	c9                   	leave  
  801855:	c3                   	ret    

00801856 <sys_cputc>:


void
sys_cputc(const char c)
{
  801856:	55                   	push   %ebp
  801857:	89 e5                	mov    %esp,%ebp
  801859:	83 ec 04             	sub    $0x4,%esp
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801862:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	50                   	push   %eax
  80186f:	6a 15                	push   $0x15
  801871:	e8 d3 fd ff ff       	call   801649 <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	90                   	nop
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 16                	push   $0x16
  80188b:	e8 b9 fd ff ff       	call   801649 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	50                   	push   %eax
  8018a6:	6a 17                	push   $0x17
  8018a8:	e8 9c fd ff ff       	call   801649 <syscall>
  8018ad:	83 c4 18             	add    $0x18,%esp
}
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	52                   	push   %edx
  8018c2:	50                   	push   %eax
  8018c3:	6a 1a                	push   $0x1a
  8018c5:	e8 7f fd ff ff       	call   801649 <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	52                   	push   %edx
  8018df:	50                   	push   %eax
  8018e0:	6a 18                	push   $0x18
  8018e2:	e8 62 fd ff ff       	call   801649 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	90                   	nop
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	52                   	push   %edx
  8018fd:	50                   	push   %eax
  8018fe:	6a 19                	push   $0x19
  801900:	e8 44 fd ff ff       	call   801649 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	83 ec 04             	sub    $0x4,%esp
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801917:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80191a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80191e:	8b 45 08             	mov    0x8(%ebp),%eax
  801921:	6a 00                	push   $0x0
  801923:	51                   	push   %ecx
  801924:	52                   	push   %edx
  801925:	ff 75 0c             	pushl  0xc(%ebp)
  801928:	50                   	push   %eax
  801929:	6a 1b                	push   $0x1b
  80192b:	e8 19 fd ff ff       	call   801649 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	52                   	push   %edx
  801945:	50                   	push   %eax
  801946:	6a 1c                	push   $0x1c
  801948:	e8 fc fc ff ff       	call   801649 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801955:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801958:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	51                   	push   %ecx
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 1d                	push   $0x1d
  801967:	e8 dd fc ff ff       	call   801649 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801974:	8b 55 0c             	mov    0xc(%ebp),%edx
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	52                   	push   %edx
  801981:	50                   	push   %eax
  801982:	6a 1e                	push   $0x1e
  801984:	e8 c0 fc ff ff       	call   801649 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 1f                	push   $0x1f
  80199d:	e8 a7 fc ff ff       	call   801649 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	ff 75 14             	pushl  0x14(%ebp)
  8019b2:	ff 75 10             	pushl  0x10(%ebp)
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	50                   	push   %eax
  8019b9:	6a 20                	push   $0x20
  8019bb:	e8 89 fc ff ff       	call   801649 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	50                   	push   %eax
  8019d4:	6a 21                	push   $0x21
  8019d6:	e8 6e fc ff ff       	call   801649 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	90                   	nop
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	50                   	push   %eax
  8019f0:	6a 22                	push   $0x22
  8019f2:	e8 52 fc ff ff       	call   801649 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 02                	push   $0x2
  801a0b:	e8 39 fc ff ff       	call   801649 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 03                	push   $0x3
  801a24:	e8 20 fc ff ff       	call   801649 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 04                	push   $0x4
  801a3d:	e8 07 fc ff ff       	call   801649 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_exit_env>:


void sys_exit_env(void)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 23                	push   $0x23
  801a56:	e8 ee fb ff ff       	call   801649 <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	90                   	nop
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a67:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a6a:	8d 50 04             	lea    0x4(%eax),%edx
  801a6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	52                   	push   %edx
  801a77:	50                   	push   %eax
  801a78:	6a 24                	push   $0x24
  801a7a:	e8 ca fb ff ff       	call   801649 <syscall>
  801a7f:	83 c4 18             	add    $0x18,%esp
	return result;
  801a82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a85:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a8b:	89 01                	mov    %eax,(%ecx)
  801a8d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	c9                   	leave  
  801a94:	c2 04 00             	ret    $0x4

00801a97 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	ff 75 10             	pushl  0x10(%ebp)
  801aa1:	ff 75 0c             	pushl  0xc(%ebp)
  801aa4:	ff 75 08             	pushl  0x8(%ebp)
  801aa7:	6a 12                	push   $0x12
  801aa9:	e8 9b fb ff ff       	call   801649 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab1:	90                   	nop
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 25                	push   $0x25
  801ac3:	e8 81 fb ff ff       	call   801649 <syscall>
  801ac8:	83 c4 18             	add    $0x18,%esp
}
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 04             	sub    $0x4,%esp
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ad9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	50                   	push   %eax
  801ae6:	6a 26                	push   $0x26
  801ae8:	e8 5c fb ff ff       	call   801649 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
	return ;
  801af0:	90                   	nop
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <rsttst>:
void rsttst()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 28                	push   $0x28
  801b02:	e8 42 fb ff ff       	call   801649 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0a:	90                   	nop
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	8b 45 14             	mov    0x14(%ebp),%eax
  801b16:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b19:	8b 55 18             	mov    0x18(%ebp),%edx
  801b1c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b20:	52                   	push   %edx
  801b21:	50                   	push   %eax
  801b22:	ff 75 10             	pushl  0x10(%ebp)
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	6a 27                	push   $0x27
  801b2d:	e8 17 fb ff ff       	call   801649 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <chktst>:
void chktst(uint32 n)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	ff 75 08             	pushl  0x8(%ebp)
  801b46:	6a 29                	push   $0x29
  801b48:	e8 fc fa ff ff       	call   801649 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b50:	90                   	nop
}
  801b51:	c9                   	leave  
  801b52:	c3                   	ret    

00801b53 <inctst>:

void inctst()
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 2a                	push   $0x2a
  801b62:	e8 e2 fa ff ff       	call   801649 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6a:	90                   	nop
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <gettst>:
uint32 gettst()
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 2b                	push   $0x2b
  801b7c:	e8 c8 fa ff ff       	call   801649 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 2c                	push   $0x2c
  801b98:	e8 ac fa ff ff       	call   801649 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
  801ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ba3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ba7:	75 07                	jne    801bb0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ba9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bae:	eb 05                	jmp    801bb5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
  801bba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 2c                	push   $0x2c
  801bc9:	e8 7b fa ff ff       	call   801649 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
  801bd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bd4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bd8:	75 07                	jne    801be1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bda:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdf:	eb 05                	jmp    801be6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
  801beb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 2c                	push   $0x2c
  801bfa:	e8 4a fa ff ff       	call   801649 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
  801c02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c05:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c09:	75 07                	jne    801c12 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801c10:	eb 05                	jmp    801c17 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 2c                	push   $0x2c
  801c2b:	e8 19 fa ff ff       	call   801649 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
  801c33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c36:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c3a:	75 07                	jne    801c43 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c41:	eb 05                	jmp    801c48 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	ff 75 08             	pushl  0x8(%ebp)
  801c58:	6a 2d                	push   $0x2d
  801c5a:	e8 ea f9 ff ff       	call   801649 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c62:	90                   	nop
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c69:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	53                   	push   %ebx
  801c78:	51                   	push   %ecx
  801c79:	52                   	push   %edx
  801c7a:	50                   	push   %eax
  801c7b:	6a 2e                	push   $0x2e
  801c7d:	e8 c7 f9 ff ff       	call   801649 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	52                   	push   %edx
  801c9a:	50                   	push   %eax
  801c9b:	6a 2f                	push   $0x2f
  801c9d:	e8 a7 f9 ff ff       	call   801649 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	68 30 3d 80 00       	push   $0x803d30
  801cb5:	e8 6b e8 ff ff       	call   800525 <cprintf>
  801cba:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cbd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cc4:	83 ec 0c             	sub    $0xc,%esp
  801cc7:	68 5c 3d 80 00       	push   $0x803d5c
  801ccc:	e8 54 e8 ff ff       	call   800525 <cprintf>
  801cd1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cd4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cd8:	a1 38 41 80 00       	mov    0x804138,%eax
  801cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ce0:	eb 56                	jmp    801d38 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ce2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ce6:	74 1c                	je     801d04 <print_mem_block_lists+0x5d>
  801ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ceb:	8b 50 08             	mov    0x8(%eax),%edx
  801cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf1:	8b 48 08             	mov    0x8(%eax),%ecx
  801cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf7:	8b 40 0c             	mov    0xc(%eax),%eax
  801cfa:	01 c8                	add    %ecx,%eax
  801cfc:	39 c2                	cmp    %eax,%edx
  801cfe:	73 04                	jae    801d04 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d00:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d07:	8b 50 08             	mov    0x8(%eax),%edx
  801d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d10:	01 c2                	add    %eax,%edx
  801d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d15:	8b 40 08             	mov    0x8(%eax),%eax
  801d18:	83 ec 04             	sub    $0x4,%esp
  801d1b:	52                   	push   %edx
  801d1c:	50                   	push   %eax
  801d1d:	68 71 3d 80 00       	push   $0x803d71
  801d22:	e8 fe e7 ff ff       	call   800525 <cprintf>
  801d27:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d30:	a1 40 41 80 00       	mov    0x804140,%eax
  801d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d3c:	74 07                	je     801d45 <print_mem_block_lists+0x9e>
  801d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d41:	8b 00                	mov    (%eax),%eax
  801d43:	eb 05                	jmp    801d4a <print_mem_block_lists+0xa3>
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4a:	a3 40 41 80 00       	mov    %eax,0x804140
  801d4f:	a1 40 41 80 00       	mov    0x804140,%eax
  801d54:	85 c0                	test   %eax,%eax
  801d56:	75 8a                	jne    801ce2 <print_mem_block_lists+0x3b>
  801d58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5c:	75 84                	jne    801ce2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d5e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d62:	75 10                	jne    801d74 <print_mem_block_lists+0xcd>
  801d64:	83 ec 0c             	sub    $0xc,%esp
  801d67:	68 80 3d 80 00       	push   $0x803d80
  801d6c:	e8 b4 e7 ff ff       	call   800525 <cprintf>
  801d71:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	68 a4 3d 80 00       	push   $0x803da4
  801d83:	e8 9d e7 ff ff       	call   800525 <cprintf>
  801d88:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d8b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d8f:	a1 40 40 80 00       	mov    0x804040,%eax
  801d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d97:	eb 56                	jmp    801def <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d9d:	74 1c                	je     801dbb <print_mem_block_lists+0x114>
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	8b 50 08             	mov    0x8(%eax),%edx
  801da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da8:	8b 48 08             	mov    0x8(%eax),%ecx
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dae:	8b 40 0c             	mov    0xc(%eax),%eax
  801db1:	01 c8                	add    %ecx,%eax
  801db3:	39 c2                	cmp    %eax,%edx
  801db5:	73 04                	jae    801dbb <print_mem_block_lists+0x114>
			sorted = 0 ;
  801db7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbe:	8b 50 08             	mov    0x8(%eax),%edx
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc7:	01 c2                	add    %eax,%edx
  801dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcc:	8b 40 08             	mov    0x8(%eax),%eax
  801dcf:	83 ec 04             	sub    $0x4,%esp
  801dd2:	52                   	push   %edx
  801dd3:	50                   	push   %eax
  801dd4:	68 71 3d 80 00       	push   $0x803d71
  801dd9:	e8 47 e7 ff ff       	call   800525 <cprintf>
  801dde:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801de7:	a1 48 40 80 00       	mov    0x804048,%eax
  801dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801def:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801df3:	74 07                	je     801dfc <print_mem_block_lists+0x155>
  801df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df8:	8b 00                	mov    (%eax),%eax
  801dfa:	eb 05                	jmp    801e01 <print_mem_block_lists+0x15a>
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	a3 48 40 80 00       	mov    %eax,0x804048
  801e06:	a1 48 40 80 00       	mov    0x804048,%eax
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	75 8a                	jne    801d99 <print_mem_block_lists+0xf2>
  801e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e13:	75 84                	jne    801d99 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e15:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e19:	75 10                	jne    801e2b <print_mem_block_lists+0x184>
  801e1b:	83 ec 0c             	sub    $0xc,%esp
  801e1e:	68 bc 3d 80 00       	push   $0x803dbc
  801e23:	e8 fd e6 ff ff       	call   800525 <cprintf>
  801e28:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e2b:	83 ec 0c             	sub    $0xc,%esp
  801e2e:	68 30 3d 80 00       	push   $0x803d30
  801e33:	e8 ed e6 ff ff       	call   800525 <cprintf>
  801e38:	83 c4 10             	add    $0x10,%esp

}
  801e3b:	90                   	nop
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e44:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e4b:	00 00 00 
  801e4e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e55:	00 00 00 
  801e58:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e5f:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e69:	e9 9e 00 00 00       	jmp    801f0c <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e6e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e76:	c1 e2 04             	shl    $0x4,%edx
  801e79:	01 d0                	add    %edx,%eax
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	75 14                	jne    801e93 <initialize_MemBlocksList+0x55>
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	68 e4 3d 80 00       	push   $0x803de4
  801e87:	6a 46                	push   $0x46
  801e89:	68 07 3e 80 00       	push   $0x803e07
  801e8e:	e8 de e3 ff ff       	call   800271 <_panic>
  801e93:	a1 50 40 80 00       	mov    0x804050,%eax
  801e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9b:	c1 e2 04             	shl    $0x4,%edx
  801e9e:	01 d0                	add    %edx,%eax
  801ea0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ea6:	89 10                	mov    %edx,(%eax)
  801ea8:	8b 00                	mov    (%eax),%eax
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	74 18                	je     801ec6 <initialize_MemBlocksList+0x88>
  801eae:	a1 48 41 80 00       	mov    0x804148,%eax
  801eb3:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801eb9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ebc:	c1 e1 04             	shl    $0x4,%ecx
  801ebf:	01 ca                	add    %ecx,%edx
  801ec1:	89 50 04             	mov    %edx,0x4(%eax)
  801ec4:	eb 12                	jmp    801ed8 <initialize_MemBlocksList+0x9a>
  801ec6:	a1 50 40 80 00       	mov    0x804050,%eax
  801ecb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ece:	c1 e2 04             	shl    $0x4,%edx
  801ed1:	01 d0                	add    %edx,%eax
  801ed3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ed8:	a1 50 40 80 00       	mov    0x804050,%eax
  801edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee0:	c1 e2 04             	shl    $0x4,%edx
  801ee3:	01 d0                	add    %edx,%eax
  801ee5:	a3 48 41 80 00       	mov    %eax,0x804148
  801eea:	a1 50 40 80 00       	mov    0x804050,%eax
  801eef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef2:	c1 e2 04             	shl    $0x4,%edx
  801ef5:	01 d0                	add    %edx,%eax
  801ef7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801efe:	a1 54 41 80 00       	mov    0x804154,%eax
  801f03:	40                   	inc    %eax
  801f04:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f09:	ff 45 f4             	incl   -0xc(%ebp)
  801f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f12:	0f 82 56 ff ff ff    	jb     801e6e <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f18:	90                   	nop
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	8b 00                	mov    (%eax),%eax
  801f26:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f29:	eb 19                	jmp    801f44 <find_block+0x29>
	{
		if(va==point->sva)
  801f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f2e:	8b 40 08             	mov    0x8(%eax),%eax
  801f31:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f34:	75 05                	jne    801f3b <find_block+0x20>
		   return point;
  801f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f39:	eb 36                	jmp    801f71 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	8b 40 08             	mov    0x8(%eax),%eax
  801f41:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f44:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f48:	74 07                	je     801f51 <find_block+0x36>
  801f4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4d:	8b 00                	mov    (%eax),%eax
  801f4f:	eb 05                	jmp    801f56 <find_block+0x3b>
  801f51:	b8 00 00 00 00       	mov    $0x0,%eax
  801f56:	8b 55 08             	mov    0x8(%ebp),%edx
  801f59:	89 42 08             	mov    %eax,0x8(%edx)
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	85 c0                	test   %eax,%eax
  801f64:	75 c5                	jne    801f2b <find_block+0x10>
  801f66:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f6a:	75 bf                	jne    801f2b <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f79:	a1 40 40 80 00       	mov    0x804040,%eax
  801f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f81:	a1 44 40 80 00       	mov    0x804044,%eax
  801f86:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f8f:	74 24                	je     801fb5 <insert_sorted_allocList+0x42>
  801f91:	8b 45 08             	mov    0x8(%ebp),%eax
  801f94:	8b 50 08             	mov    0x8(%eax),%edx
  801f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9a:	8b 40 08             	mov    0x8(%eax),%eax
  801f9d:	39 c2                	cmp    %eax,%edx
  801f9f:	76 14                	jbe    801fb5 <insert_sorted_allocList+0x42>
  801fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa4:	8b 50 08             	mov    0x8(%eax),%edx
  801fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801faa:	8b 40 08             	mov    0x8(%eax),%eax
  801fad:	39 c2                	cmp    %eax,%edx
  801faf:	0f 82 60 01 00 00    	jb     802115 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fb5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb9:	75 65                	jne    802020 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fbf:	75 14                	jne    801fd5 <insert_sorted_allocList+0x62>
  801fc1:	83 ec 04             	sub    $0x4,%esp
  801fc4:	68 e4 3d 80 00       	push   $0x803de4
  801fc9:	6a 6b                	push   $0x6b
  801fcb:	68 07 3e 80 00       	push   $0x803e07
  801fd0:	e8 9c e2 ff ff       	call   800271 <_panic>
  801fd5:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	89 10                	mov    %edx,(%eax)
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	8b 00                	mov    (%eax),%eax
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	74 0d                	je     801ff6 <insert_sorted_allocList+0x83>
  801fe9:	a1 40 40 80 00       	mov    0x804040,%eax
  801fee:	8b 55 08             	mov    0x8(%ebp),%edx
  801ff1:	89 50 04             	mov    %edx,0x4(%eax)
  801ff4:	eb 08                	jmp    801ffe <insert_sorted_allocList+0x8b>
  801ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff9:	a3 44 40 80 00       	mov    %eax,0x804044
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	a3 40 40 80 00       	mov    %eax,0x804040
  802006:	8b 45 08             	mov    0x8(%ebp),%eax
  802009:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802010:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802015:	40                   	inc    %eax
  802016:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80201b:	e9 dc 01 00 00       	jmp    8021fc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	8b 50 08             	mov    0x8(%eax),%edx
  802026:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802029:	8b 40 08             	mov    0x8(%eax),%eax
  80202c:	39 c2                	cmp    %eax,%edx
  80202e:	77 6c                	ja     80209c <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802030:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802034:	74 06                	je     80203c <insert_sorted_allocList+0xc9>
  802036:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80203a:	75 14                	jne    802050 <insert_sorted_allocList+0xdd>
  80203c:	83 ec 04             	sub    $0x4,%esp
  80203f:	68 20 3e 80 00       	push   $0x803e20
  802044:	6a 6f                	push   $0x6f
  802046:	68 07 3e 80 00       	push   $0x803e07
  80204b:	e8 21 e2 ff ff       	call   800271 <_panic>
  802050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802053:	8b 50 04             	mov    0x4(%eax),%edx
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	89 50 04             	mov    %edx,0x4(%eax)
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802062:	89 10                	mov    %edx,(%eax)
  802064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802067:	8b 40 04             	mov    0x4(%eax),%eax
  80206a:	85 c0                	test   %eax,%eax
  80206c:	74 0d                	je     80207b <insert_sorted_allocList+0x108>
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	8b 40 04             	mov    0x4(%eax),%eax
  802074:	8b 55 08             	mov    0x8(%ebp),%edx
  802077:	89 10                	mov    %edx,(%eax)
  802079:	eb 08                	jmp    802083 <insert_sorted_allocList+0x110>
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	a3 40 40 80 00       	mov    %eax,0x804040
  802083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802086:	8b 55 08             	mov    0x8(%ebp),%edx
  802089:	89 50 04             	mov    %edx,0x4(%eax)
  80208c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802091:	40                   	inc    %eax
  802092:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802097:	e9 60 01 00 00       	jmp    8021fc <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	8b 50 08             	mov    0x8(%eax),%edx
  8020a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a5:	8b 40 08             	mov    0x8(%eax),%eax
  8020a8:	39 c2                	cmp    %eax,%edx
  8020aa:	0f 82 4c 01 00 00    	jb     8021fc <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b4:	75 14                	jne    8020ca <insert_sorted_allocList+0x157>
  8020b6:	83 ec 04             	sub    $0x4,%esp
  8020b9:	68 58 3e 80 00       	push   $0x803e58
  8020be:	6a 73                	push   $0x73
  8020c0:	68 07 3e 80 00       	push   $0x803e07
  8020c5:	e8 a7 e1 ff ff       	call   800271 <_panic>
  8020ca:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	89 50 04             	mov    %edx,0x4(%eax)
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	8b 40 04             	mov    0x4(%eax),%eax
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	74 0c                	je     8020ec <insert_sorted_allocList+0x179>
  8020e0:	a1 44 40 80 00       	mov    0x804044,%eax
  8020e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e8:	89 10                	mov    %edx,(%eax)
  8020ea:	eb 08                	jmp    8020f4 <insert_sorted_allocList+0x181>
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	a3 40 40 80 00       	mov    %eax,0x804040
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	a3 44 40 80 00       	mov    %eax,0x804044
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802105:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80210a:	40                   	inc    %eax
  80210b:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802110:	e9 e7 00 00 00       	jmp    8021fc <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802118:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80211b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802122:	a1 40 40 80 00       	mov    0x804040,%eax
  802127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80212a:	e9 9d 00 00 00       	jmp    8021cc <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 00                	mov    (%eax),%eax
  802134:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802137:	8b 45 08             	mov    0x8(%ebp),%eax
  80213a:	8b 50 08             	mov    0x8(%eax),%edx
  80213d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802140:	8b 40 08             	mov    0x8(%eax),%eax
  802143:	39 c2                	cmp    %eax,%edx
  802145:	76 7d                	jbe    8021c4 <insert_sorted_allocList+0x251>
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	8b 50 08             	mov    0x8(%eax),%edx
  80214d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802150:	8b 40 08             	mov    0x8(%eax),%eax
  802153:	39 c2                	cmp    %eax,%edx
  802155:	73 6d                	jae    8021c4 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802157:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215b:	74 06                	je     802163 <insert_sorted_allocList+0x1f0>
  80215d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802161:	75 14                	jne    802177 <insert_sorted_allocList+0x204>
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	68 7c 3e 80 00       	push   $0x803e7c
  80216b:	6a 7f                	push   $0x7f
  80216d:	68 07 3e 80 00       	push   $0x803e07
  802172:	e8 fa e0 ff ff       	call   800271 <_panic>
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	8b 10                	mov    (%eax),%edx
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	89 10                	mov    %edx,(%eax)
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8b 00                	mov    (%eax),%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	74 0b                	je     802195 <insert_sorted_allocList+0x222>
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 00                	mov    (%eax),%eax
  80218f:	8b 55 08             	mov    0x8(%ebp),%edx
  802192:	89 50 04             	mov    %edx,0x4(%eax)
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 55 08             	mov    0x8(%ebp),%edx
  80219b:	89 10                	mov    %edx,(%eax)
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a3:	89 50 04             	mov    %edx,0x4(%eax)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 00                	mov    (%eax),%eax
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	75 08                	jne    8021b7 <insert_sorted_allocList+0x244>
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	a3 44 40 80 00       	mov    %eax,0x804044
  8021b7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021bc:	40                   	inc    %eax
  8021bd:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021c2:	eb 39                	jmp    8021fd <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021c4:	a1 48 40 80 00       	mov    0x804048,%eax
  8021c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d0:	74 07                	je     8021d9 <insert_sorted_allocList+0x266>
  8021d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d5:	8b 00                	mov    (%eax),%eax
  8021d7:	eb 05                	jmp    8021de <insert_sorted_allocList+0x26b>
  8021d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021de:	a3 48 40 80 00       	mov    %eax,0x804048
  8021e3:	a1 48 40 80 00       	mov    0x804048,%eax
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	0f 85 3f ff ff ff    	jne    80212f <insert_sorted_allocList+0x1bc>
  8021f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f4:	0f 85 35 ff ff ff    	jne    80212f <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021fa:	eb 01                	jmp    8021fd <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021fc:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8021fd:	90                   	nop
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802206:	a1 38 41 80 00       	mov    0x804138,%eax
  80220b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220e:	e9 85 01 00 00       	jmp    802398 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802213:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802216:	8b 40 0c             	mov    0xc(%eax),%eax
  802219:	3b 45 08             	cmp    0x8(%ebp),%eax
  80221c:	0f 82 6e 01 00 00    	jb     802390 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802225:	8b 40 0c             	mov    0xc(%eax),%eax
  802228:	3b 45 08             	cmp    0x8(%ebp),%eax
  80222b:	0f 85 8a 00 00 00    	jne    8022bb <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802231:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802235:	75 17                	jne    80224e <alloc_block_FF+0x4e>
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	68 b0 3e 80 00       	push   $0x803eb0
  80223f:	68 93 00 00 00       	push   $0x93
  802244:	68 07 3e 80 00       	push   $0x803e07
  802249:	e8 23 e0 ff ff       	call   800271 <_panic>
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	8b 00                	mov    (%eax),%eax
  802253:	85 c0                	test   %eax,%eax
  802255:	74 10                	je     802267 <alloc_block_FF+0x67>
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	8b 00                	mov    (%eax),%eax
  80225c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225f:	8b 52 04             	mov    0x4(%edx),%edx
  802262:	89 50 04             	mov    %edx,0x4(%eax)
  802265:	eb 0b                	jmp    802272 <alloc_block_FF+0x72>
  802267:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226a:	8b 40 04             	mov    0x4(%eax),%eax
  80226d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 40 04             	mov    0x4(%eax),%eax
  802278:	85 c0                	test   %eax,%eax
  80227a:	74 0f                	je     80228b <alloc_block_FF+0x8b>
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 40 04             	mov    0x4(%eax),%eax
  802282:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802285:	8b 12                	mov    (%edx),%edx
  802287:	89 10                	mov    %edx,(%eax)
  802289:	eb 0a                	jmp    802295 <alloc_block_FF+0x95>
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 00                	mov    (%eax),%eax
  802290:	a3 38 41 80 00       	mov    %eax,0x804138
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8022ad:	48                   	dec    %eax
  8022ae:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	e9 10 01 00 00       	jmp    8023cb <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 40 0c             	mov    0xc(%eax),%eax
  8022c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c4:	0f 86 c6 00 00 00    	jbe    802390 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022ca:	a1 48 41 80 00       	mov    0x804148,%eax
  8022cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 50 08             	mov    0x8(%eax),%edx
  8022d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022db:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e4:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022eb:	75 17                	jne    802304 <alloc_block_FF+0x104>
  8022ed:	83 ec 04             	sub    $0x4,%esp
  8022f0:	68 b0 3e 80 00       	push   $0x803eb0
  8022f5:	68 9b 00 00 00       	push   $0x9b
  8022fa:	68 07 3e 80 00       	push   $0x803e07
  8022ff:	e8 6d df ff ff       	call   800271 <_panic>
  802304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802307:	8b 00                	mov    (%eax),%eax
  802309:	85 c0                	test   %eax,%eax
  80230b:	74 10                	je     80231d <alloc_block_FF+0x11d>
  80230d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802310:	8b 00                	mov    (%eax),%eax
  802312:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802315:	8b 52 04             	mov    0x4(%edx),%edx
  802318:	89 50 04             	mov    %edx,0x4(%eax)
  80231b:	eb 0b                	jmp    802328 <alloc_block_FF+0x128>
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	8b 40 04             	mov    0x4(%eax),%eax
  802323:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802328:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232b:	8b 40 04             	mov    0x4(%eax),%eax
  80232e:	85 c0                	test   %eax,%eax
  802330:	74 0f                	je     802341 <alloc_block_FF+0x141>
  802332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802335:	8b 40 04             	mov    0x4(%eax),%eax
  802338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233b:	8b 12                	mov    (%edx),%edx
  80233d:	89 10                	mov    %edx,(%eax)
  80233f:	eb 0a                	jmp    80234b <alloc_block_FF+0x14b>
  802341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802344:	8b 00                	mov    (%eax),%eax
  802346:	a3 48 41 80 00       	mov    %eax,0x804148
  80234b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802357:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80235e:	a1 54 41 80 00       	mov    0x804154,%eax
  802363:	48                   	dec    %eax
  802364:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 50 08             	mov    0x8(%eax),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	01 c2                	add    %eax,%edx
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 40 0c             	mov    0xc(%eax),%eax
  802380:	2b 45 08             	sub    0x8(%ebp),%eax
  802383:	89 c2                	mov    %eax,%edx
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	eb 3b                	jmp    8023cb <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802390:	a1 40 41 80 00       	mov    0x804140,%eax
  802395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802398:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239c:	74 07                	je     8023a5 <alloc_block_FF+0x1a5>
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 00                	mov    (%eax),%eax
  8023a3:	eb 05                	jmp    8023aa <alloc_block_FF+0x1aa>
  8023a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023aa:	a3 40 41 80 00       	mov    %eax,0x804140
  8023af:	a1 40 41 80 00       	mov    0x804140,%eax
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	0f 85 57 fe ff ff    	jne    802213 <alloc_block_FF+0x13>
  8023bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c0:	0f 85 4d fe ff ff    	jne    802213 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023da:	a1 38 41 80 00       	mov    0x804138,%eax
  8023df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e2:	e9 df 00 00 00       	jmp    8024c6 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f0:	0f 82 c8 00 00 00    	jb     8024be <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ff:	0f 85 8a 00 00 00    	jne    80248f <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802409:	75 17                	jne    802422 <alloc_block_BF+0x55>
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	68 b0 3e 80 00       	push   $0x803eb0
  802413:	68 b7 00 00 00       	push   $0xb7
  802418:	68 07 3e 80 00       	push   $0x803e07
  80241d:	e8 4f de ff ff       	call   800271 <_panic>
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 10                	je     80243b <alloc_block_BF+0x6e>
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 00                	mov    (%eax),%eax
  802430:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802433:	8b 52 04             	mov    0x4(%edx),%edx
  802436:	89 50 04             	mov    %edx,0x4(%eax)
  802439:	eb 0b                	jmp    802446 <alloc_block_BF+0x79>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 40 04             	mov    0x4(%eax),%eax
  802441:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 40 04             	mov    0x4(%eax),%eax
  80244c:	85 c0                	test   %eax,%eax
  80244e:	74 0f                	je     80245f <alloc_block_BF+0x92>
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 40 04             	mov    0x4(%eax),%eax
  802456:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802459:	8b 12                	mov    (%edx),%edx
  80245b:	89 10                	mov    %edx,(%eax)
  80245d:	eb 0a                	jmp    802469 <alloc_block_BF+0x9c>
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 00                	mov    (%eax),%eax
  802464:	a3 38 41 80 00       	mov    %eax,0x804138
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247c:	a1 44 41 80 00       	mov    0x804144,%eax
  802481:	48                   	dec    %eax
  802482:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	e9 4d 01 00 00       	jmp    8025dc <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 0c             	mov    0xc(%eax),%eax
  802495:	3b 45 08             	cmp    0x8(%ebp),%eax
  802498:	76 24                	jbe    8024be <alloc_block_BF+0xf1>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024a3:	73 19                	jae    8024be <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024a5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 40 08             	mov    0x8(%eax),%eax
  8024bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024be:	a1 40 41 80 00       	mov    0x804140,%eax
  8024c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ca:	74 07                	je     8024d3 <alloc_block_BF+0x106>
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	eb 05                	jmp    8024d8 <alloc_block_BF+0x10b>
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d8:	a3 40 41 80 00       	mov    %eax,0x804140
  8024dd:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	0f 85 fd fe ff ff    	jne    8023e7 <alloc_block_BF+0x1a>
  8024ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ee:	0f 85 f3 fe ff ff    	jne    8023e7 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8024f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8024f8:	0f 84 d9 00 00 00    	je     8025d7 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024fe:	a1 48 41 80 00       	mov    0x804148,%eax
  802503:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802509:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80250c:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80250f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802512:	8b 55 08             	mov    0x8(%ebp),%edx
  802515:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802518:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80251c:	75 17                	jne    802535 <alloc_block_BF+0x168>
  80251e:	83 ec 04             	sub    $0x4,%esp
  802521:	68 b0 3e 80 00       	push   $0x803eb0
  802526:	68 c7 00 00 00       	push   $0xc7
  80252b:	68 07 3e 80 00       	push   $0x803e07
  802530:	e8 3c dd ff ff       	call   800271 <_panic>
  802535:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802538:	8b 00                	mov    (%eax),%eax
  80253a:	85 c0                	test   %eax,%eax
  80253c:	74 10                	je     80254e <alloc_block_BF+0x181>
  80253e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802546:	8b 52 04             	mov    0x4(%edx),%edx
  802549:	89 50 04             	mov    %edx,0x4(%eax)
  80254c:	eb 0b                	jmp    802559 <alloc_block_BF+0x18c>
  80254e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802559:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255c:	8b 40 04             	mov    0x4(%eax),%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	74 0f                	je     802572 <alloc_block_BF+0x1a5>
  802563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802566:	8b 40 04             	mov    0x4(%eax),%eax
  802569:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80256c:	8b 12                	mov    (%edx),%edx
  80256e:	89 10                	mov    %edx,(%eax)
  802570:	eb 0a                	jmp    80257c <alloc_block_BF+0x1af>
  802572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	a3 48 41 80 00       	mov    %eax,0x804148
  80257c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802588:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258f:	a1 54 41 80 00       	mov    0x804154,%eax
  802594:	48                   	dec    %eax
  802595:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80259a:	83 ec 08             	sub    $0x8,%esp
  80259d:	ff 75 ec             	pushl  -0x14(%ebp)
  8025a0:	68 38 41 80 00       	push   $0x804138
  8025a5:	e8 71 f9 ff ff       	call   801f1b <find_block>
  8025aa:	83 c4 10             	add    $0x10,%esp
  8025ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025b3:	8b 50 08             	mov    0x8(%eax),%edx
  8025b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b9:	01 c2                	add    %eax,%edx
  8025bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025be:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c7:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ca:	89 c2                	mov    %eax,%edx
  8025cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cf:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d5:	eb 05                	jmp    8025dc <alloc_block_BF+0x20f>
	}
	return NULL;
  8025d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025dc:	c9                   	leave  
  8025dd:	c3                   	ret    

008025de <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025e4:	a1 28 40 80 00       	mov    0x804028,%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	0f 85 de 01 00 00    	jne    8027cf <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8025f1:	a1 38 41 80 00       	mov    0x804138,%eax
  8025f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f9:	e9 9e 01 00 00       	jmp    80279c <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 40 0c             	mov    0xc(%eax),%eax
  802604:	3b 45 08             	cmp    0x8(%ebp),%eax
  802607:	0f 82 87 01 00 00    	jb     802794 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 40 0c             	mov    0xc(%eax),%eax
  802613:	3b 45 08             	cmp    0x8(%ebp),%eax
  802616:	0f 85 95 00 00 00    	jne    8026b1 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80261c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802620:	75 17                	jne    802639 <alloc_block_NF+0x5b>
  802622:	83 ec 04             	sub    $0x4,%esp
  802625:	68 b0 3e 80 00       	push   $0x803eb0
  80262a:	68 e0 00 00 00       	push   $0xe0
  80262f:	68 07 3e 80 00       	push   $0x803e07
  802634:	e8 38 dc ff ff       	call   800271 <_panic>
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	74 10                	je     802652 <alloc_block_NF+0x74>
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 00                	mov    (%eax),%eax
  802647:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80264a:	8b 52 04             	mov    0x4(%edx),%edx
  80264d:	89 50 04             	mov    %edx,0x4(%eax)
  802650:	eb 0b                	jmp    80265d <alloc_block_NF+0x7f>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 04             	mov    0x4(%eax),%eax
  802658:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	85 c0                	test   %eax,%eax
  802665:	74 0f                	je     802676 <alloc_block_NF+0x98>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 04             	mov    0x4(%eax),%eax
  80266d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802670:	8b 12                	mov    (%edx),%edx
  802672:	89 10                	mov    %edx,(%eax)
  802674:	eb 0a                	jmp    802680 <alloc_block_NF+0xa2>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 00                	mov    (%eax),%eax
  80267b:	a3 38 41 80 00       	mov    %eax,0x804138
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802693:	a1 44 41 80 00       	mov    0x804144,%eax
  802698:	48                   	dec    %eax
  802699:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 40 08             	mov    0x8(%eax),%eax
  8026a4:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	e9 f8 04 00 00       	jmp    802ba9 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ba:	0f 86 d4 00 00 00    	jbe    802794 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026c0:	a1 48 41 80 00       	mov    0x804148,%eax
  8026c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d1:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026da:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026e1:	75 17                	jne    8026fa <alloc_block_NF+0x11c>
  8026e3:	83 ec 04             	sub    $0x4,%esp
  8026e6:	68 b0 3e 80 00       	push   $0x803eb0
  8026eb:	68 e9 00 00 00       	push   $0xe9
  8026f0:	68 07 3e 80 00       	push   $0x803e07
  8026f5:	e8 77 db ff ff       	call   800271 <_panic>
  8026fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fd:	8b 00                	mov    (%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 10                	je     802713 <alloc_block_NF+0x135>
  802703:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80270b:	8b 52 04             	mov    0x4(%edx),%edx
  80270e:	89 50 04             	mov    %edx,0x4(%eax)
  802711:	eb 0b                	jmp    80271e <alloc_block_NF+0x140>
  802713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802716:	8b 40 04             	mov    0x4(%eax),%eax
  802719:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80271e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802721:	8b 40 04             	mov    0x4(%eax),%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	74 0f                	je     802737 <alloc_block_NF+0x159>
  802728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272b:	8b 40 04             	mov    0x4(%eax),%eax
  80272e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802731:	8b 12                	mov    (%edx),%edx
  802733:	89 10                	mov    %edx,(%eax)
  802735:	eb 0a                	jmp    802741 <alloc_block_NF+0x163>
  802737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	a3 48 41 80 00       	mov    %eax,0x804148
  802741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802744:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802754:	a1 54 41 80 00       	mov    0x804154,%eax
  802759:	48                   	dec    %eax
  80275a:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 40 08             	mov    0x8(%eax),%eax
  802765:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 50 08             	mov    0x8(%eax),%edx
  802770:	8b 45 08             	mov    0x8(%ebp),%eax
  802773:	01 c2                	add    %eax,%edx
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 40 0c             	mov    0xc(%eax),%eax
  802781:	2b 45 08             	sub    0x8(%ebp),%eax
  802784:	89 c2                	mov    %eax,%edx
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80278c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278f:	e9 15 04 00 00       	jmp    802ba9 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802794:	a1 40 41 80 00       	mov    0x804140,%eax
  802799:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a0:	74 07                	je     8027a9 <alloc_block_NF+0x1cb>
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 00                	mov    (%eax),%eax
  8027a7:	eb 05                	jmp    8027ae <alloc_block_NF+0x1d0>
  8027a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ae:	a3 40 41 80 00       	mov    %eax,0x804140
  8027b3:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b8:	85 c0                	test   %eax,%eax
  8027ba:	0f 85 3e fe ff ff    	jne    8025fe <alloc_block_NF+0x20>
  8027c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c4:	0f 85 34 fe ff ff    	jne    8025fe <alloc_block_NF+0x20>
  8027ca:	e9 d5 03 00 00       	jmp    802ba4 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8027d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d7:	e9 b1 01 00 00       	jmp    80298d <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 50 08             	mov    0x8(%eax),%edx
  8027e2:	a1 28 40 80 00       	mov    0x804028,%eax
  8027e7:	39 c2                	cmp    %eax,%edx
  8027e9:	0f 82 96 01 00 00    	jb     802985 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f8:	0f 82 87 01 00 00    	jb     802985 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 40 0c             	mov    0xc(%eax),%eax
  802804:	3b 45 08             	cmp    0x8(%ebp),%eax
  802807:	0f 85 95 00 00 00    	jne    8028a2 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	75 17                	jne    80282a <alloc_block_NF+0x24c>
  802813:	83 ec 04             	sub    $0x4,%esp
  802816:	68 b0 3e 80 00       	push   $0x803eb0
  80281b:	68 fc 00 00 00       	push   $0xfc
  802820:	68 07 3e 80 00       	push   $0x803e07
  802825:	e8 47 da ff ff       	call   800271 <_panic>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	74 10                	je     802843 <alloc_block_NF+0x265>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283b:	8b 52 04             	mov    0x4(%edx),%edx
  80283e:	89 50 04             	mov    %edx,0x4(%eax)
  802841:	eb 0b                	jmp    80284e <alloc_block_NF+0x270>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 40 04             	mov    0x4(%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 0f                	je     802867 <alloc_block_NF+0x289>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802861:	8b 12                	mov    (%edx),%edx
  802863:	89 10                	mov    %edx,(%eax)
  802865:	eb 0a                	jmp    802871 <alloc_block_NF+0x293>
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	a3 38 41 80 00       	mov    %eax,0x804138
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802884:	a1 44 41 80 00       	mov    0x804144,%eax
  802889:	48                   	dec    %eax
  80288a:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80288f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802892:	8b 40 08             	mov    0x8(%eax),%eax
  802895:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  80289a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289d:	e9 07 03 00 00       	jmp    802ba9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ab:	0f 86 d4 00 00 00    	jbe    802985 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028b1:	a1 48 41 80 00       	mov    0x804148,%eax
  8028b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 50 08             	mov    0x8(%eax),%edx
  8028bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c2:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cb:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028d2:	75 17                	jne    8028eb <alloc_block_NF+0x30d>
  8028d4:	83 ec 04             	sub    $0x4,%esp
  8028d7:	68 b0 3e 80 00       	push   $0x803eb0
  8028dc:	68 04 01 00 00       	push   $0x104
  8028e1:	68 07 3e 80 00       	push   $0x803e07
  8028e6:	e8 86 d9 ff ff       	call   800271 <_panic>
  8028eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ee:	8b 00                	mov    (%eax),%eax
  8028f0:	85 c0                	test   %eax,%eax
  8028f2:	74 10                	je     802904 <alloc_block_NF+0x326>
  8028f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f7:	8b 00                	mov    (%eax),%eax
  8028f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028fc:	8b 52 04             	mov    0x4(%edx),%edx
  8028ff:	89 50 04             	mov    %edx,0x4(%eax)
  802902:	eb 0b                	jmp    80290f <alloc_block_NF+0x331>
  802904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80290f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802912:	8b 40 04             	mov    0x4(%eax),%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	74 0f                	je     802928 <alloc_block_NF+0x34a>
  802919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291c:	8b 40 04             	mov    0x4(%eax),%eax
  80291f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802922:	8b 12                	mov    (%edx),%edx
  802924:	89 10                	mov    %edx,(%eax)
  802926:	eb 0a                	jmp    802932 <alloc_block_NF+0x354>
  802928:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	a3 48 41 80 00       	mov    %eax,0x804148
  802932:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802935:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802945:	a1 54 41 80 00       	mov    0x804154,%eax
  80294a:	48                   	dec    %eax
  80294b:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802950:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802953:	8b 40 08             	mov    0x8(%eax),%eax
  802956:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 50 08             	mov    0x8(%eax),%edx
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	01 c2                	add    %eax,%edx
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 0c             	mov    0xc(%eax),%eax
  802972:	2b 45 08             	sub    0x8(%ebp),%eax
  802975:	89 c2                	mov    %eax,%edx
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80297d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802980:	e9 24 02 00 00       	jmp    802ba9 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802985:	a1 40 41 80 00       	mov    0x804140,%eax
  80298a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802991:	74 07                	je     80299a <alloc_block_NF+0x3bc>
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 00                	mov    (%eax),%eax
  802998:	eb 05                	jmp    80299f <alloc_block_NF+0x3c1>
  80299a:	b8 00 00 00 00       	mov    $0x0,%eax
  80299f:	a3 40 41 80 00       	mov    %eax,0x804140
  8029a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	0f 85 2b fe ff ff    	jne    8027dc <alloc_block_NF+0x1fe>
  8029b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b5:	0f 85 21 fe ff ff    	jne    8027dc <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029bb:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c3:	e9 ae 01 00 00       	jmp    802b76 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ce:	a1 28 40 80 00       	mov    0x804028,%eax
  8029d3:	39 c2                	cmp    %eax,%edx
  8029d5:	0f 83 93 01 00 00    	jae    802b6e <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029e4:	0f 82 84 01 00 00    	jb     802b6e <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f3:	0f 85 95 00 00 00    	jne    802a8e <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029fd:	75 17                	jne    802a16 <alloc_block_NF+0x438>
  8029ff:	83 ec 04             	sub    $0x4,%esp
  802a02:	68 b0 3e 80 00       	push   $0x803eb0
  802a07:	68 14 01 00 00       	push   $0x114
  802a0c:	68 07 3e 80 00       	push   $0x803e07
  802a11:	e8 5b d8 ff ff       	call   800271 <_panic>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	85 c0                	test   %eax,%eax
  802a1d:	74 10                	je     802a2f <alloc_block_NF+0x451>
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a27:	8b 52 04             	mov    0x4(%edx),%edx
  802a2a:	89 50 04             	mov    %edx,0x4(%eax)
  802a2d:	eb 0b                	jmp    802a3a <alloc_block_NF+0x45c>
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 0f                	je     802a53 <alloc_block_NF+0x475>
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 40 04             	mov    0x4(%eax),%eax
  802a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4d:	8b 12                	mov    (%edx),%edx
  802a4f:	89 10                	mov    %edx,(%eax)
  802a51:	eb 0a                	jmp    802a5d <alloc_block_NF+0x47f>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	a3 38 41 80 00       	mov    %eax,0x804138
  802a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a70:	a1 44 41 80 00       	mov    0x804144,%eax
  802a75:	48                   	dec    %eax
  802a76:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	e9 1b 01 00 00       	jmp    802ba9 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 0c             	mov    0xc(%eax),%eax
  802a94:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a97:	0f 86 d1 00 00 00    	jbe    802b6e <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a9d:	a1 48 41 80 00       	mov    0x804148,%eax
  802aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 50 08             	mov    0x8(%eax),%edx
  802aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aae:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab7:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802abe:	75 17                	jne    802ad7 <alloc_block_NF+0x4f9>
  802ac0:	83 ec 04             	sub    $0x4,%esp
  802ac3:	68 b0 3e 80 00       	push   $0x803eb0
  802ac8:	68 1c 01 00 00       	push   $0x11c
  802acd:	68 07 3e 80 00       	push   $0x803e07
  802ad2:	e8 9a d7 ff ff       	call   800271 <_panic>
  802ad7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	74 10                	je     802af0 <alloc_block_NF+0x512>
  802ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae3:	8b 00                	mov    (%eax),%eax
  802ae5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae8:	8b 52 04             	mov    0x4(%edx),%edx
  802aeb:	89 50 04             	mov    %edx,0x4(%eax)
  802aee:	eb 0b                	jmp    802afb <alloc_block_NF+0x51d>
  802af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af3:	8b 40 04             	mov    0x4(%eax),%eax
  802af6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afe:	8b 40 04             	mov    0x4(%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 0f                	je     802b14 <alloc_block_NF+0x536>
  802b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b0e:	8b 12                	mov    (%edx),%edx
  802b10:	89 10                	mov    %edx,(%eax)
  802b12:	eb 0a                	jmp    802b1e <alloc_block_NF+0x540>
  802b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	a3 48 41 80 00       	mov    %eax,0x804148
  802b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b31:	a1 54 41 80 00       	mov    0x804154,%eax
  802b36:	48                   	dec    %eax
  802b37:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3f:	8b 40 08             	mov    0x8(%eax),%eax
  802b42:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 50 08             	mov    0x8(%eax),%edx
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	01 c2                	add    %eax,%edx
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b61:	89 c2                	mov    %eax,%edx
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6c:	eb 3b                	jmp    802ba9 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b6e:	a1 40 41 80 00       	mov    0x804140,%eax
  802b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7a:	74 07                	je     802b83 <alloc_block_NF+0x5a5>
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	eb 05                	jmp    802b88 <alloc_block_NF+0x5aa>
  802b83:	b8 00 00 00 00       	mov    $0x0,%eax
  802b88:	a3 40 41 80 00       	mov    %eax,0x804140
  802b8d:	a1 40 41 80 00       	mov    0x804140,%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	0f 85 2e fe ff ff    	jne    8029c8 <alloc_block_NF+0x3ea>
  802b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9e:	0f 85 24 fe ff ff    	jne    8029c8 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802ba4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba9:	c9                   	leave  
  802baa:	c3                   	ret    

00802bab <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bab:	55                   	push   %ebp
  802bac:	89 e5                	mov    %esp,%ebp
  802bae:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bb1:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bb9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bbe:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bc1:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	74 14                	je     802bde <insert_sorted_with_merge_freeList+0x33>
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	8b 50 08             	mov    0x8(%eax),%edx
  802bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd3:	8b 40 08             	mov    0x8(%eax),%eax
  802bd6:	39 c2                	cmp    %eax,%edx
  802bd8:	0f 87 9b 01 00 00    	ja     802d79 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be2:	75 17                	jne    802bfb <insert_sorted_with_merge_freeList+0x50>
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	68 e4 3d 80 00       	push   $0x803de4
  802bec:	68 38 01 00 00       	push   $0x138
  802bf1:	68 07 3e 80 00       	push   $0x803e07
  802bf6:	e8 76 d6 ff ff       	call   800271 <_panic>
  802bfb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	89 10                	mov    %edx,(%eax)
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 0d                	je     802c1c <insert_sorted_with_merge_freeList+0x71>
  802c0f:	a1 38 41 80 00       	mov    0x804138,%eax
  802c14:	8b 55 08             	mov    0x8(%ebp),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	eb 08                	jmp    802c24 <insert_sorted_with_merge_freeList+0x79>
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	a3 38 41 80 00       	mov    %eax,0x804138
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c36:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3b:	40                   	inc    %eax
  802c3c:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c45:	0f 84 a8 06 00 00    	je     8032f3 <insert_sorted_with_merge_freeList+0x748>
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 50 08             	mov    0x8(%eax),%edx
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 40 0c             	mov    0xc(%eax),%eax
  802c57:	01 c2                	add    %eax,%edx
  802c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5c:	8b 40 08             	mov    0x8(%eax),%eax
  802c5f:	39 c2                	cmp    %eax,%edx
  802c61:	0f 85 8c 06 00 00    	jne    8032f3 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c70:	8b 40 0c             	mov    0xc(%eax),%eax
  802c73:	01 c2                	add    %eax,%edx
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c7f:	75 17                	jne    802c98 <insert_sorted_with_merge_freeList+0xed>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 b0 3e 80 00       	push   $0x803eb0
  802c89:	68 3c 01 00 00       	push   $0x13c
  802c8e:	68 07 3e 80 00       	push   $0x803e07
  802c93:	e8 d9 d5 ff ff       	call   800271 <_panic>
  802c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9b:	8b 00                	mov    (%eax),%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 10                	je     802cb1 <insert_sorted_with_merge_freeList+0x106>
  802ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca4:	8b 00                	mov    (%eax),%eax
  802ca6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca9:	8b 52 04             	mov    0x4(%edx),%edx
  802cac:	89 50 04             	mov    %edx,0x4(%eax)
  802caf:	eb 0b                	jmp    802cbc <insert_sorted_with_merge_freeList+0x111>
  802cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb4:	8b 40 04             	mov    0x4(%eax),%eax
  802cb7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbf:	8b 40 04             	mov    0x4(%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 0f                	je     802cd5 <insert_sorted_with_merge_freeList+0x12a>
  802cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc9:	8b 40 04             	mov    0x4(%eax),%eax
  802ccc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ccf:	8b 12                	mov    (%edx),%edx
  802cd1:	89 10                	mov    %edx,(%eax)
  802cd3:	eb 0a                	jmp    802cdf <insert_sorted_with_merge_freeList+0x134>
  802cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd8:	8b 00                	mov    (%eax),%eax
  802cda:	a3 38 41 80 00       	mov    %eax,0x804138
  802cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ceb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf2:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf7:	48                   	dec    %eax
  802cf8:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d15:	75 17                	jne    802d2e <insert_sorted_with_merge_freeList+0x183>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 e4 3d 80 00       	push   $0x803de4
  802d1f:	68 3f 01 00 00       	push   $0x13f
  802d24:	68 07 3e 80 00       	push   $0x803e07
  802d29:	e8 43 d5 ff ff       	call   800271 <_panic>
  802d2e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0d                	je     802d4f <insert_sorted_with_merge_freeList+0x1a4>
  802d42:	a1 48 41 80 00       	mov    0x804148,%eax
  802d47:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	eb 08                	jmp    802d57 <insert_sorted_with_merge_freeList+0x1ac>
  802d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d52:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	a3 48 41 80 00       	mov    %eax,0x804148
  802d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d69:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6e:	40                   	inc    %eax
  802d6f:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d74:	e9 7a 05 00 00       	jmp    8032f3 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	8b 50 08             	mov    0x8(%eax),%edx
  802d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d82:	8b 40 08             	mov    0x8(%eax),%eax
  802d85:	39 c2                	cmp    %eax,%edx
  802d87:	0f 82 14 01 00 00    	jb     802ea1 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d90:	8b 50 08             	mov    0x8(%eax),%edx
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	8b 40 0c             	mov    0xc(%eax),%eax
  802d99:	01 c2                	add    %eax,%edx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	8b 40 08             	mov    0x8(%eax),%eax
  802da1:	39 c2                	cmp    %eax,%edx
  802da3:	0f 85 90 00 00 00    	jne    802e39 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dac:	8b 50 0c             	mov    0xc(%eax),%edx
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	8b 40 0c             	mov    0xc(%eax),%eax
  802db5:	01 c2                	add    %eax,%edx
  802db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dba:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802dd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd5:	75 17                	jne    802dee <insert_sorted_with_merge_freeList+0x243>
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	68 e4 3d 80 00       	push   $0x803de4
  802ddf:	68 49 01 00 00       	push   $0x149
  802de4:	68 07 3e 80 00       	push   $0x803e07
  802de9:	e8 83 d4 ff ff       	call   800271 <_panic>
  802dee:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	89 10                	mov    %edx,(%eax)
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	85 c0                	test   %eax,%eax
  802e00:	74 0d                	je     802e0f <insert_sorted_with_merge_freeList+0x264>
  802e02:	a1 48 41 80 00       	mov    0x804148,%eax
  802e07:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0a:	89 50 04             	mov    %edx,0x4(%eax)
  802e0d:	eb 08                	jmp    802e17 <insert_sorted_with_merge_freeList+0x26c>
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e29:	a1 54 41 80 00       	mov    0x804154,%eax
  802e2e:	40                   	inc    %eax
  802e2f:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e34:	e9 bb 04 00 00       	jmp    8032f4 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e3d:	75 17                	jne    802e56 <insert_sorted_with_merge_freeList+0x2ab>
  802e3f:	83 ec 04             	sub    $0x4,%esp
  802e42:	68 58 3e 80 00       	push   $0x803e58
  802e47:	68 4c 01 00 00       	push   $0x14c
  802e4c:	68 07 3e 80 00       	push   $0x803e07
  802e51:	e8 1b d4 ff ff       	call   800271 <_panic>
  802e56:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	89 50 04             	mov    %edx,0x4(%eax)
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	8b 40 04             	mov    0x4(%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	74 0c                	je     802e78 <insert_sorted_with_merge_freeList+0x2cd>
  802e6c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e71:	8b 55 08             	mov    0x8(%ebp),%edx
  802e74:	89 10                	mov    %edx,(%eax)
  802e76:	eb 08                	jmp    802e80 <insert_sorted_with_merge_freeList+0x2d5>
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	a3 38 41 80 00       	mov    %eax,0x804138
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e91:	a1 44 41 80 00       	mov    0x804144,%eax
  802e96:	40                   	inc    %eax
  802e97:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e9c:	e9 53 04 00 00       	jmp    8032f4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ea1:	a1 38 41 80 00       	mov    0x804138,%eax
  802ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea9:	e9 15 04 00 00       	jmp    8032c3 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 50 08             	mov    0x8(%eax),%edx
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 40 08             	mov    0x8(%eax),%eax
  802ec2:	39 c2                	cmp    %eax,%edx
  802ec4:	0f 86 f1 03 00 00    	jbe    8032bb <insert_sorted_with_merge_freeList+0x710>
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	8b 50 08             	mov    0x8(%eax),%edx
  802ed0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed3:	8b 40 08             	mov    0x8(%eax),%eax
  802ed6:	39 c2                	cmp    %eax,%edx
  802ed8:	0f 83 dd 03 00 00    	jae    8032bb <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	8b 50 08             	mov    0x8(%eax),%edx
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eea:	01 c2                	add    %eax,%edx
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 40 08             	mov    0x8(%eax),%eax
  802ef2:	39 c2                	cmp    %eax,%edx
  802ef4:	0f 85 b9 01 00 00    	jne    8030b3 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	8b 50 08             	mov    0x8(%eax),%edx
  802f00:	8b 45 08             	mov    0x8(%ebp),%eax
  802f03:	8b 40 0c             	mov    0xc(%eax),%eax
  802f06:	01 c2                	add    %eax,%edx
  802f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0b:	8b 40 08             	mov    0x8(%eax),%eax
  802f0e:	39 c2                	cmp    %eax,%edx
  802f10:	0f 85 0d 01 00 00    	jne    803023 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 50 0c             	mov    0xc(%eax),%edx
  802f1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f22:	01 c2                	add    %eax,%edx
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f2a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f2e:	75 17                	jne    802f47 <insert_sorted_with_merge_freeList+0x39c>
  802f30:	83 ec 04             	sub    $0x4,%esp
  802f33:	68 b0 3e 80 00       	push   $0x803eb0
  802f38:	68 5c 01 00 00       	push   $0x15c
  802f3d:	68 07 3e 80 00       	push   $0x803e07
  802f42:	e8 2a d3 ff ff       	call   800271 <_panic>
  802f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	85 c0                	test   %eax,%eax
  802f4e:	74 10                	je     802f60 <insert_sorted_with_merge_freeList+0x3b5>
  802f50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f58:	8b 52 04             	mov    0x4(%edx),%edx
  802f5b:	89 50 04             	mov    %edx,0x4(%eax)
  802f5e:	eb 0b                	jmp    802f6b <insert_sorted_with_merge_freeList+0x3c0>
  802f60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6e:	8b 40 04             	mov    0x4(%eax),%eax
  802f71:	85 c0                	test   %eax,%eax
  802f73:	74 0f                	je     802f84 <insert_sorted_with_merge_freeList+0x3d9>
  802f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f78:	8b 40 04             	mov    0x4(%eax),%eax
  802f7b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f7e:	8b 12                	mov    (%edx),%edx
  802f80:	89 10                	mov    %edx,(%eax)
  802f82:	eb 0a                	jmp    802f8e <insert_sorted_with_merge_freeList+0x3e3>
  802f84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	a3 38 41 80 00       	mov    %eax,0x804138
  802f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa1:	a1 44 41 80 00       	mov    0x804144,%eax
  802fa6:	48                   	dec    %eax
  802fa7:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fc0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fc4:	75 17                	jne    802fdd <insert_sorted_with_merge_freeList+0x432>
  802fc6:	83 ec 04             	sub    $0x4,%esp
  802fc9:	68 e4 3d 80 00       	push   $0x803de4
  802fce:	68 5f 01 00 00       	push   $0x15f
  802fd3:	68 07 3e 80 00       	push   $0x803e07
  802fd8:	e8 94 d2 ff ff       	call   800271 <_panic>
  802fdd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe6:	89 10                	mov    %edx,(%eax)
  802fe8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	74 0d                	je     802ffe <insert_sorted_with_merge_freeList+0x453>
  802ff1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ff6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ff9:	89 50 04             	mov    %edx,0x4(%eax)
  802ffc:	eb 08                	jmp    803006 <insert_sorted_with_merge_freeList+0x45b>
  802ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803001:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803006:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803009:	a3 48 41 80 00       	mov    %eax,0x804148
  80300e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803011:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803018:	a1 54 41 80 00       	mov    0x804154,%eax
  80301d:	40                   	inc    %eax
  80301e:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	8b 50 0c             	mov    0xc(%eax),%edx
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	8b 40 0c             	mov    0xc(%eax),%eax
  80302f:	01 c2                	add    %eax,%edx
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80304b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80304f:	75 17                	jne    803068 <insert_sorted_with_merge_freeList+0x4bd>
  803051:	83 ec 04             	sub    $0x4,%esp
  803054:	68 e4 3d 80 00       	push   $0x803de4
  803059:	68 64 01 00 00       	push   $0x164
  80305e:	68 07 3e 80 00       	push   $0x803e07
  803063:	e8 09 d2 ff ff       	call   800271 <_panic>
  803068:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	89 10                	mov    %edx,(%eax)
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	8b 00                	mov    (%eax),%eax
  803078:	85 c0                	test   %eax,%eax
  80307a:	74 0d                	je     803089 <insert_sorted_with_merge_freeList+0x4de>
  80307c:	a1 48 41 80 00       	mov    0x804148,%eax
  803081:	8b 55 08             	mov    0x8(%ebp),%edx
  803084:	89 50 04             	mov    %edx,0x4(%eax)
  803087:	eb 08                	jmp    803091 <insert_sorted_with_merge_freeList+0x4e6>
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	a3 48 41 80 00       	mov    %eax,0x804148
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a3:	a1 54 41 80 00       	mov    0x804154,%eax
  8030a8:	40                   	inc    %eax
  8030a9:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030ae:	e9 41 02 00 00       	jmp    8032f4 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	8b 50 08             	mov    0x8(%eax),%edx
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030bf:	01 c2                	add    %eax,%edx
  8030c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c4:	8b 40 08             	mov    0x8(%eax),%eax
  8030c7:	39 c2                	cmp    %eax,%edx
  8030c9:	0f 85 7c 01 00 00    	jne    80324b <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d3:	74 06                	je     8030db <insert_sorted_with_merge_freeList+0x530>
  8030d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d9:	75 17                	jne    8030f2 <insert_sorted_with_merge_freeList+0x547>
  8030db:	83 ec 04             	sub    $0x4,%esp
  8030de:	68 20 3e 80 00       	push   $0x803e20
  8030e3:	68 69 01 00 00       	push   $0x169
  8030e8:	68 07 3e 80 00       	push   $0x803e07
  8030ed:	e8 7f d1 ff ff       	call   800271 <_panic>
  8030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f5:	8b 50 04             	mov    0x4(%eax),%edx
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	89 50 04             	mov    %edx,0x4(%eax)
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803104:	89 10                	mov    %edx,(%eax)
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 40 04             	mov    0x4(%eax),%eax
  80310c:	85 c0                	test   %eax,%eax
  80310e:	74 0d                	je     80311d <insert_sorted_with_merge_freeList+0x572>
  803110:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803113:	8b 40 04             	mov    0x4(%eax),%eax
  803116:	8b 55 08             	mov    0x8(%ebp),%edx
  803119:	89 10                	mov    %edx,(%eax)
  80311b:	eb 08                	jmp    803125 <insert_sorted_with_merge_freeList+0x57a>
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	a3 38 41 80 00       	mov    %eax,0x804138
  803125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803128:	8b 55 08             	mov    0x8(%ebp),%edx
  80312b:	89 50 04             	mov    %edx,0x4(%eax)
  80312e:	a1 44 41 80 00       	mov    0x804144,%eax
  803133:	40                   	inc    %eax
  803134:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	8b 50 0c             	mov    0xc(%eax),%edx
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	8b 40 0c             	mov    0xc(%eax),%eax
  803145:	01 c2                	add    %eax,%edx
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80314d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803151:	75 17                	jne    80316a <insert_sorted_with_merge_freeList+0x5bf>
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	68 b0 3e 80 00       	push   $0x803eb0
  80315b:	68 6b 01 00 00       	push   $0x16b
  803160:	68 07 3e 80 00       	push   $0x803e07
  803165:	e8 07 d1 ff ff       	call   800271 <_panic>
  80316a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316d:	8b 00                	mov    (%eax),%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	74 10                	je     803183 <insert_sorted_with_merge_freeList+0x5d8>
  803173:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80317b:	8b 52 04             	mov    0x4(%edx),%edx
  80317e:	89 50 04             	mov    %edx,0x4(%eax)
  803181:	eb 0b                	jmp    80318e <insert_sorted_with_merge_freeList+0x5e3>
  803183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803186:	8b 40 04             	mov    0x4(%eax),%eax
  803189:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	8b 40 04             	mov    0x4(%eax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	74 0f                	je     8031a7 <insert_sorted_with_merge_freeList+0x5fc>
  803198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319b:	8b 40 04             	mov    0x4(%eax),%eax
  80319e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a1:	8b 12                	mov    (%edx),%edx
  8031a3:	89 10                	mov    %edx,(%eax)
  8031a5:	eb 0a                	jmp    8031b1 <insert_sorted_with_merge_freeList+0x606>
  8031a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031aa:	8b 00                	mov    (%eax),%eax
  8031ac:	a3 38 41 80 00       	mov    %eax,0x804138
  8031b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8031c9:	48                   	dec    %eax
  8031ca:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031e7:	75 17                	jne    803200 <insert_sorted_with_merge_freeList+0x655>
  8031e9:	83 ec 04             	sub    $0x4,%esp
  8031ec:	68 e4 3d 80 00       	push   $0x803de4
  8031f1:	68 6e 01 00 00       	push   $0x16e
  8031f6:	68 07 3e 80 00       	push   $0x803e07
  8031fb:	e8 71 d0 ff ff       	call   800271 <_panic>
  803200:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803209:	89 10                	mov    %edx,(%eax)
  80320b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	85 c0                	test   %eax,%eax
  803212:	74 0d                	je     803221 <insert_sorted_with_merge_freeList+0x676>
  803214:	a1 48 41 80 00       	mov    0x804148,%eax
  803219:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80321c:	89 50 04             	mov    %edx,0x4(%eax)
  80321f:	eb 08                	jmp    803229 <insert_sorted_with_merge_freeList+0x67e>
  803221:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803224:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803229:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322c:	a3 48 41 80 00       	mov    %eax,0x804148
  803231:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803234:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323b:	a1 54 41 80 00       	mov    0x804154,%eax
  803240:	40                   	inc    %eax
  803241:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803246:	e9 a9 00 00 00       	jmp    8032f4 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80324b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80324f:	74 06                	je     803257 <insert_sorted_with_merge_freeList+0x6ac>
  803251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803255:	75 17                	jne    80326e <insert_sorted_with_merge_freeList+0x6c3>
  803257:	83 ec 04             	sub    $0x4,%esp
  80325a:	68 7c 3e 80 00       	push   $0x803e7c
  80325f:	68 73 01 00 00       	push   $0x173
  803264:	68 07 3e 80 00       	push   $0x803e07
  803269:	e8 03 d0 ff ff       	call   800271 <_panic>
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 10                	mov    (%eax),%edx
  803273:	8b 45 08             	mov    0x8(%ebp),%eax
  803276:	89 10                	mov    %edx,(%eax)
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	85 c0                	test   %eax,%eax
  80327f:	74 0b                	je     80328c <insert_sorted_with_merge_freeList+0x6e1>
  803281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803284:	8b 00                	mov    (%eax),%eax
  803286:	8b 55 08             	mov    0x8(%ebp),%edx
  803289:	89 50 04             	mov    %edx,0x4(%eax)
  80328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328f:	8b 55 08             	mov    0x8(%ebp),%edx
  803292:	89 10                	mov    %edx,(%eax)
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80329a:	89 50 04             	mov    %edx,0x4(%eax)
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	75 08                	jne    8032ae <insert_sorted_with_merge_freeList+0x703>
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032ae:	a1 44 41 80 00       	mov    0x804144,%eax
  8032b3:	40                   	inc    %eax
  8032b4:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032b9:	eb 39                	jmp    8032f4 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032bb:	a1 40 41 80 00       	mov    0x804140,%eax
  8032c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032c7:	74 07                	je     8032d0 <insert_sorted_with_merge_freeList+0x725>
  8032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cc:	8b 00                	mov    (%eax),%eax
  8032ce:	eb 05                	jmp    8032d5 <insert_sorted_with_merge_freeList+0x72a>
  8032d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8032d5:	a3 40 41 80 00       	mov    %eax,0x804140
  8032da:	a1 40 41 80 00       	mov    0x804140,%eax
  8032df:	85 c0                	test   %eax,%eax
  8032e1:	0f 85 c7 fb ff ff    	jne    802eae <insert_sorted_with_merge_freeList+0x303>
  8032e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032eb:	0f 85 bd fb ff ff    	jne    802eae <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032f1:	eb 01                	jmp    8032f4 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8032f3:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8032f4:	90                   	nop
  8032f5:	c9                   	leave  
  8032f6:	c3                   	ret    
  8032f7:	90                   	nop

008032f8 <__udivdi3>:
  8032f8:	55                   	push   %ebp
  8032f9:	57                   	push   %edi
  8032fa:	56                   	push   %esi
  8032fb:	53                   	push   %ebx
  8032fc:	83 ec 1c             	sub    $0x1c,%esp
  8032ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803303:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803307:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80330b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80330f:	89 ca                	mov    %ecx,%edx
  803311:	89 f8                	mov    %edi,%eax
  803313:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803317:	85 f6                	test   %esi,%esi
  803319:	75 2d                	jne    803348 <__udivdi3+0x50>
  80331b:	39 cf                	cmp    %ecx,%edi
  80331d:	77 65                	ja     803384 <__udivdi3+0x8c>
  80331f:	89 fd                	mov    %edi,%ebp
  803321:	85 ff                	test   %edi,%edi
  803323:	75 0b                	jne    803330 <__udivdi3+0x38>
  803325:	b8 01 00 00 00       	mov    $0x1,%eax
  80332a:	31 d2                	xor    %edx,%edx
  80332c:	f7 f7                	div    %edi
  80332e:	89 c5                	mov    %eax,%ebp
  803330:	31 d2                	xor    %edx,%edx
  803332:	89 c8                	mov    %ecx,%eax
  803334:	f7 f5                	div    %ebp
  803336:	89 c1                	mov    %eax,%ecx
  803338:	89 d8                	mov    %ebx,%eax
  80333a:	f7 f5                	div    %ebp
  80333c:	89 cf                	mov    %ecx,%edi
  80333e:	89 fa                	mov    %edi,%edx
  803340:	83 c4 1c             	add    $0x1c,%esp
  803343:	5b                   	pop    %ebx
  803344:	5e                   	pop    %esi
  803345:	5f                   	pop    %edi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    
  803348:	39 ce                	cmp    %ecx,%esi
  80334a:	77 28                	ja     803374 <__udivdi3+0x7c>
  80334c:	0f bd fe             	bsr    %esi,%edi
  80334f:	83 f7 1f             	xor    $0x1f,%edi
  803352:	75 40                	jne    803394 <__udivdi3+0x9c>
  803354:	39 ce                	cmp    %ecx,%esi
  803356:	72 0a                	jb     803362 <__udivdi3+0x6a>
  803358:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80335c:	0f 87 9e 00 00 00    	ja     803400 <__udivdi3+0x108>
  803362:	b8 01 00 00 00       	mov    $0x1,%eax
  803367:	89 fa                	mov    %edi,%edx
  803369:	83 c4 1c             	add    $0x1c,%esp
  80336c:	5b                   	pop    %ebx
  80336d:	5e                   	pop    %esi
  80336e:	5f                   	pop    %edi
  80336f:	5d                   	pop    %ebp
  803370:	c3                   	ret    
  803371:	8d 76 00             	lea    0x0(%esi),%esi
  803374:	31 ff                	xor    %edi,%edi
  803376:	31 c0                	xor    %eax,%eax
  803378:	89 fa                	mov    %edi,%edx
  80337a:	83 c4 1c             	add    $0x1c,%esp
  80337d:	5b                   	pop    %ebx
  80337e:	5e                   	pop    %esi
  80337f:	5f                   	pop    %edi
  803380:	5d                   	pop    %ebp
  803381:	c3                   	ret    
  803382:	66 90                	xchg   %ax,%ax
  803384:	89 d8                	mov    %ebx,%eax
  803386:	f7 f7                	div    %edi
  803388:	31 ff                	xor    %edi,%edi
  80338a:	89 fa                	mov    %edi,%edx
  80338c:	83 c4 1c             	add    $0x1c,%esp
  80338f:	5b                   	pop    %ebx
  803390:	5e                   	pop    %esi
  803391:	5f                   	pop    %edi
  803392:	5d                   	pop    %ebp
  803393:	c3                   	ret    
  803394:	bd 20 00 00 00       	mov    $0x20,%ebp
  803399:	89 eb                	mov    %ebp,%ebx
  80339b:	29 fb                	sub    %edi,%ebx
  80339d:	89 f9                	mov    %edi,%ecx
  80339f:	d3 e6                	shl    %cl,%esi
  8033a1:	89 c5                	mov    %eax,%ebp
  8033a3:	88 d9                	mov    %bl,%cl
  8033a5:	d3 ed                	shr    %cl,%ebp
  8033a7:	89 e9                	mov    %ebp,%ecx
  8033a9:	09 f1                	or     %esi,%ecx
  8033ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033af:	89 f9                	mov    %edi,%ecx
  8033b1:	d3 e0                	shl    %cl,%eax
  8033b3:	89 c5                	mov    %eax,%ebp
  8033b5:	89 d6                	mov    %edx,%esi
  8033b7:	88 d9                	mov    %bl,%cl
  8033b9:	d3 ee                	shr    %cl,%esi
  8033bb:	89 f9                	mov    %edi,%ecx
  8033bd:	d3 e2                	shl    %cl,%edx
  8033bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033c3:	88 d9                	mov    %bl,%cl
  8033c5:	d3 e8                	shr    %cl,%eax
  8033c7:	09 c2                	or     %eax,%edx
  8033c9:	89 d0                	mov    %edx,%eax
  8033cb:	89 f2                	mov    %esi,%edx
  8033cd:	f7 74 24 0c          	divl   0xc(%esp)
  8033d1:	89 d6                	mov    %edx,%esi
  8033d3:	89 c3                	mov    %eax,%ebx
  8033d5:	f7 e5                	mul    %ebp
  8033d7:	39 d6                	cmp    %edx,%esi
  8033d9:	72 19                	jb     8033f4 <__udivdi3+0xfc>
  8033db:	74 0b                	je     8033e8 <__udivdi3+0xf0>
  8033dd:	89 d8                	mov    %ebx,%eax
  8033df:	31 ff                	xor    %edi,%edi
  8033e1:	e9 58 ff ff ff       	jmp    80333e <__udivdi3+0x46>
  8033e6:	66 90                	xchg   %ax,%ax
  8033e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033ec:	89 f9                	mov    %edi,%ecx
  8033ee:	d3 e2                	shl    %cl,%edx
  8033f0:	39 c2                	cmp    %eax,%edx
  8033f2:	73 e9                	jae    8033dd <__udivdi3+0xe5>
  8033f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033f7:	31 ff                	xor    %edi,%edi
  8033f9:	e9 40 ff ff ff       	jmp    80333e <__udivdi3+0x46>
  8033fe:	66 90                	xchg   %ax,%ax
  803400:	31 c0                	xor    %eax,%eax
  803402:	e9 37 ff ff ff       	jmp    80333e <__udivdi3+0x46>
  803407:	90                   	nop

00803408 <__umoddi3>:
  803408:	55                   	push   %ebp
  803409:	57                   	push   %edi
  80340a:	56                   	push   %esi
  80340b:	53                   	push   %ebx
  80340c:	83 ec 1c             	sub    $0x1c,%esp
  80340f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803413:	8b 74 24 34          	mov    0x34(%esp),%esi
  803417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80341f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803423:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803427:	89 f3                	mov    %esi,%ebx
  803429:	89 fa                	mov    %edi,%edx
  80342b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80342f:	89 34 24             	mov    %esi,(%esp)
  803432:	85 c0                	test   %eax,%eax
  803434:	75 1a                	jne    803450 <__umoddi3+0x48>
  803436:	39 f7                	cmp    %esi,%edi
  803438:	0f 86 a2 00 00 00    	jbe    8034e0 <__umoddi3+0xd8>
  80343e:	89 c8                	mov    %ecx,%eax
  803440:	89 f2                	mov    %esi,%edx
  803442:	f7 f7                	div    %edi
  803444:	89 d0                	mov    %edx,%eax
  803446:	31 d2                	xor    %edx,%edx
  803448:	83 c4 1c             	add    $0x1c,%esp
  80344b:	5b                   	pop    %ebx
  80344c:	5e                   	pop    %esi
  80344d:	5f                   	pop    %edi
  80344e:	5d                   	pop    %ebp
  80344f:	c3                   	ret    
  803450:	39 f0                	cmp    %esi,%eax
  803452:	0f 87 ac 00 00 00    	ja     803504 <__umoddi3+0xfc>
  803458:	0f bd e8             	bsr    %eax,%ebp
  80345b:	83 f5 1f             	xor    $0x1f,%ebp
  80345e:	0f 84 ac 00 00 00    	je     803510 <__umoddi3+0x108>
  803464:	bf 20 00 00 00       	mov    $0x20,%edi
  803469:	29 ef                	sub    %ebp,%edi
  80346b:	89 fe                	mov    %edi,%esi
  80346d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803471:	89 e9                	mov    %ebp,%ecx
  803473:	d3 e0                	shl    %cl,%eax
  803475:	89 d7                	mov    %edx,%edi
  803477:	89 f1                	mov    %esi,%ecx
  803479:	d3 ef                	shr    %cl,%edi
  80347b:	09 c7                	or     %eax,%edi
  80347d:	89 e9                	mov    %ebp,%ecx
  80347f:	d3 e2                	shl    %cl,%edx
  803481:	89 14 24             	mov    %edx,(%esp)
  803484:	89 d8                	mov    %ebx,%eax
  803486:	d3 e0                	shl    %cl,%eax
  803488:	89 c2                	mov    %eax,%edx
  80348a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80348e:	d3 e0                	shl    %cl,%eax
  803490:	89 44 24 04          	mov    %eax,0x4(%esp)
  803494:	8b 44 24 08          	mov    0x8(%esp),%eax
  803498:	89 f1                	mov    %esi,%ecx
  80349a:	d3 e8                	shr    %cl,%eax
  80349c:	09 d0                	or     %edx,%eax
  80349e:	d3 eb                	shr    %cl,%ebx
  8034a0:	89 da                	mov    %ebx,%edx
  8034a2:	f7 f7                	div    %edi
  8034a4:	89 d3                	mov    %edx,%ebx
  8034a6:	f7 24 24             	mull   (%esp)
  8034a9:	89 c6                	mov    %eax,%esi
  8034ab:	89 d1                	mov    %edx,%ecx
  8034ad:	39 d3                	cmp    %edx,%ebx
  8034af:	0f 82 87 00 00 00    	jb     80353c <__umoddi3+0x134>
  8034b5:	0f 84 91 00 00 00    	je     80354c <__umoddi3+0x144>
  8034bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034bf:	29 f2                	sub    %esi,%edx
  8034c1:	19 cb                	sbb    %ecx,%ebx
  8034c3:	89 d8                	mov    %ebx,%eax
  8034c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034c9:	d3 e0                	shl    %cl,%eax
  8034cb:	89 e9                	mov    %ebp,%ecx
  8034cd:	d3 ea                	shr    %cl,%edx
  8034cf:	09 d0                	or     %edx,%eax
  8034d1:	89 e9                	mov    %ebp,%ecx
  8034d3:	d3 eb                	shr    %cl,%ebx
  8034d5:	89 da                	mov    %ebx,%edx
  8034d7:	83 c4 1c             	add    $0x1c,%esp
  8034da:	5b                   	pop    %ebx
  8034db:	5e                   	pop    %esi
  8034dc:	5f                   	pop    %edi
  8034dd:	5d                   	pop    %ebp
  8034de:	c3                   	ret    
  8034df:	90                   	nop
  8034e0:	89 fd                	mov    %edi,%ebp
  8034e2:	85 ff                	test   %edi,%edi
  8034e4:	75 0b                	jne    8034f1 <__umoddi3+0xe9>
  8034e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034eb:	31 d2                	xor    %edx,%edx
  8034ed:	f7 f7                	div    %edi
  8034ef:	89 c5                	mov    %eax,%ebp
  8034f1:	89 f0                	mov    %esi,%eax
  8034f3:	31 d2                	xor    %edx,%edx
  8034f5:	f7 f5                	div    %ebp
  8034f7:	89 c8                	mov    %ecx,%eax
  8034f9:	f7 f5                	div    %ebp
  8034fb:	89 d0                	mov    %edx,%eax
  8034fd:	e9 44 ff ff ff       	jmp    803446 <__umoddi3+0x3e>
  803502:	66 90                	xchg   %ax,%ax
  803504:	89 c8                	mov    %ecx,%eax
  803506:	89 f2                	mov    %esi,%edx
  803508:	83 c4 1c             	add    $0x1c,%esp
  80350b:	5b                   	pop    %ebx
  80350c:	5e                   	pop    %esi
  80350d:	5f                   	pop    %edi
  80350e:	5d                   	pop    %ebp
  80350f:	c3                   	ret    
  803510:	3b 04 24             	cmp    (%esp),%eax
  803513:	72 06                	jb     80351b <__umoddi3+0x113>
  803515:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803519:	77 0f                	ja     80352a <__umoddi3+0x122>
  80351b:	89 f2                	mov    %esi,%edx
  80351d:	29 f9                	sub    %edi,%ecx
  80351f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803523:	89 14 24             	mov    %edx,(%esp)
  803526:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80352a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80352e:	8b 14 24             	mov    (%esp),%edx
  803531:	83 c4 1c             	add    $0x1c,%esp
  803534:	5b                   	pop    %ebx
  803535:	5e                   	pop    %esi
  803536:	5f                   	pop    %edi
  803537:	5d                   	pop    %ebp
  803538:	c3                   	ret    
  803539:	8d 76 00             	lea    0x0(%esi),%esi
  80353c:	2b 04 24             	sub    (%esp),%eax
  80353f:	19 fa                	sbb    %edi,%edx
  803541:	89 d1                	mov    %edx,%ecx
  803543:	89 c6                	mov    %eax,%esi
  803545:	e9 71 ff ff ff       	jmp    8034bb <__umoddi3+0xb3>
  80354a:	66 90                	xchg   %ax,%ax
  80354c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803550:	72 ea                	jb     80353c <__umoddi3+0x134>
  803552:	89 d9                	mov    %ebx,%ecx
  803554:	e9 62 ff ff ff       	jmp    8034bb <__umoddi3+0xb3>
