
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
  80008c:	68 40 36 80 00       	push   $0x803640
  800091:	6a 12                	push   $0x12
  800093:	68 5c 36 80 00       	push   $0x80365c
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
  8000aa:	e8 5e 1a 00 00       	call   801b0d <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 77 36 80 00       	push   $0x803677
  8000b7:	50                   	push   %eax
  8000b8:	e8 33 15 00 00       	call   8015f0 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 4c 17 00 00       	call   801814 <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 7c 36 80 00       	push   $0x80367c
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 ce 15 00 00       	call   8016b4 <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 a0 36 80 00       	push   $0x8036a0
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 16 17 00 00       	call   801814 <sys_calculate_free_frames>
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
  80011c:	68 b8 36 80 00       	push   $0x8036b8
  800121:	6a 24                	push   $0x24
  800123:	68 5c 36 80 00       	push   $0x80365c
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 00 1b 00 00       	call   801c32 <inctst>

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
  80013b:	e8 b4 19 00 00       	call   801af4 <sys_getenvindex>
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
  8001a6:	e8 56 17 00 00       	call   801901 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 5c 37 80 00       	push   $0x80375c
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
  8001d6:	68 84 37 80 00       	push   $0x803784
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
  800207:	68 ac 37 80 00       	push   $0x8037ac
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 04 38 80 00       	push   $0x803804
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 5c 37 80 00       	push   $0x80375c
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 d6 16 00 00       	call   80191b <sys_enable_interrupt>

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
  800258:	e8 63 18 00 00       	call   801ac0 <sys_destroy_env>
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
  800269:	e8 b8 18 00 00       	call   801b26 <sys_exit_env>
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
  800292:	68 18 38 80 00       	push   $0x803818
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 1d 38 80 00       	push   $0x80381d
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
  8002cf:	68 39 38 80 00       	push   $0x803839
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
  8002fb:	68 3c 38 80 00       	push   $0x80383c
  800300:	6a 26                	push   $0x26
  800302:	68 88 38 80 00       	push   $0x803888
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
  8003cd:	68 94 38 80 00       	push   $0x803894
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 88 38 80 00       	push   $0x803888
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
  80043d:	68 e8 38 80 00       	push   $0x8038e8
  800442:	6a 44                	push   $0x44
  800444:	68 88 38 80 00       	push   $0x803888
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
  800497:	e8 b7 12 00 00       	call   801753 <sys_cputs>
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
  80050e:	e8 40 12 00 00       	call   801753 <sys_cputs>
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
  800558:	e8 a4 13 00 00       	call   801901 <sys_disable_interrupt>
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
  800578:	e8 9e 13 00 00       	call   80191b <sys_enable_interrupt>
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
  8005c2:	e8 11 2e 00 00       	call   8033d8 <__udivdi3>
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
  800612:	e8 d1 2e 00 00       	call   8034e8 <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 54 3b 80 00       	add    $0x803b54,%eax
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
  80076d:	8b 04 85 78 3b 80 00 	mov    0x803b78(,%eax,4),%eax
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
  80084e:	8b 34 9d c0 39 80 00 	mov    0x8039c0(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 65 3b 80 00       	push   $0x803b65
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
  800873:	68 6e 3b 80 00       	push   $0x803b6e
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
  8008a0:	be 71 3b 80 00       	mov    $0x803b71,%esi
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
  8012c6:	68 d0 3c 80 00       	push   $0x803cd0
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
  801396:	e8 fc 04 00 00       	call   801897 <sys_allocate_chunk>
  80139b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139e:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	50                   	push   %eax
  8013a7:	e8 71 0b 00 00       	call   801f1d <initialize_MemBlocksList>
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
  8013d4:	68 f5 3c 80 00       	push   $0x803cf5
  8013d9:	6a 33                	push   $0x33
  8013db:	68 13 3d 80 00       	push   $0x803d13
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
  801453:	68 20 3d 80 00       	push   $0x803d20
  801458:	6a 34                	push   $0x34
  80145a:	68 13 3d 80 00       	push   $0x803d13
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
  8014b0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b3:	e8 f7 fd ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  8014b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014bc:	75 07                	jne    8014c5 <malloc+0x18>
  8014be:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c3:	eb 61                	jmp    801526 <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8014c5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d2:	01 d0                	add    %edx,%eax
  8014d4:	48                   	dec    %eax
  8014d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014db:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e0:	f7 75 f0             	divl   -0x10(%ebp)
  8014e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014e6:	29 d0                	sub    %edx,%eax
  8014e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014eb:	e8 75 07 00 00       	call   801c65 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 11                	je     801505 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8014fa:	e8 e0 0d 00 00       	call   8022df <alloc_block_FF>
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  801505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801509:	74 16                	je     801521 <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  80150b:	83 ec 0c             	sub    $0xc,%esp
  80150e:	ff 75 f4             	pushl  -0xc(%ebp)
  801511:	e8 3c 0b 00 00       	call   802052 <insert_sorted_allocList>
  801516:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151c:	8b 40 08             	mov    0x8(%eax),%eax
  80151f:	eb 05                	jmp    801526 <malloc+0x79>
	}

    return NULL;
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801526:	c9                   	leave  
  801527:	c3                   	ret    

00801528 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801528:	55                   	push   %ebp
  801529:	89 e5                	mov    %esp,%ebp
  80152b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80152e:	83 ec 04             	sub    $0x4,%esp
  801531:	68 44 3d 80 00       	push   $0x803d44
  801536:	6a 6f                	push   $0x6f
  801538:	68 13 3d 80 00       	push   $0x803d13
  80153d:	e8 2f ed ff ff       	call   800271 <_panic>

00801542 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	83 ec 38             	sub    $0x38,%esp
  801548:	8b 45 10             	mov    0x10(%ebp),%eax
  80154b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80154e:	e8 5c fd ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  801553:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801557:	75 0a                	jne    801563 <smalloc+0x21>
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	e9 8b 00 00 00       	jmp    8015ee <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801563:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80156a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801570:	01 d0                	add    %edx,%eax
  801572:	48                   	dec    %eax
  801573:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801576:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801579:	ba 00 00 00 00       	mov    $0x0,%edx
  80157e:	f7 75 f0             	divl   -0x10(%ebp)
  801581:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801584:	29 d0                	sub    %edx,%eax
  801586:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801589:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801590:	e8 d0 06 00 00       	call   801c65 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801595:	85 c0                	test   %eax,%eax
  801597:	74 11                	je     8015aa <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801599:	83 ec 0c             	sub    $0xc,%esp
  80159c:	ff 75 e8             	pushl  -0x18(%ebp)
  80159f:	e8 3b 0d 00 00       	call   8022df <alloc_block_FF>
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8015aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ae:	74 39                	je     8015e9 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	8b 40 08             	mov    0x8(%eax),%eax
  8015b6:	89 c2                	mov    %eax,%edx
  8015b8:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015bc:	52                   	push   %edx
  8015bd:	50                   	push   %eax
  8015be:	ff 75 0c             	pushl  0xc(%ebp)
  8015c1:	ff 75 08             	pushl  0x8(%ebp)
  8015c4:	e8 21 04 00 00       	call   8019ea <sys_createSharedObject>
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8015cf:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8015d3:	74 14                	je     8015e9 <smalloc+0xa7>
  8015d5:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8015d9:	74 0e                	je     8015e9 <smalloc+0xa7>
  8015db:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015df:	74 08                	je     8015e9 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8015e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e4:	8b 40 08             	mov    0x8(%eax),%eax
  8015e7:	eb 05                	jmp    8015ee <smalloc+0xac>
	}
	return NULL;
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f6:	e8 b4 fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8015fb:	83 ec 08             	sub    $0x8,%esp
  8015fe:	ff 75 0c             	pushl  0xc(%ebp)
  801601:	ff 75 08             	pushl  0x8(%ebp)
  801604:	e8 0b 04 00 00       	call   801a14 <sys_getSizeOfSharedObject>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  80160f:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  801613:	74 76                	je     80168b <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801615:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80161c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80161f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801622:	01 d0                	add    %edx,%eax
  801624:	48                   	dec    %eax
  801625:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801628:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80162b:	ba 00 00 00 00       	mov    $0x0,%edx
  801630:	f7 75 ec             	divl   -0x14(%ebp)
  801633:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801636:	29 d0                	sub    %edx,%eax
  801638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  80163b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801642:	e8 1e 06 00 00       	call   801c65 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801647:	85 c0                	test   %eax,%eax
  801649:	74 11                	je     80165c <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  80164b:	83 ec 0c             	sub    $0xc,%esp
  80164e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801651:	e8 89 0c 00 00       	call   8022df <alloc_block_FF>
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80165c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801660:	74 29                	je     80168b <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801665:	8b 40 08             	mov    0x8(%eax),%eax
  801668:	83 ec 04             	sub    $0x4,%esp
  80166b:	50                   	push   %eax
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	e8 ba 03 00 00       	call   801a31 <sys_getSharedObject>
  801677:	83 c4 10             	add    $0x10,%esp
  80167a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80167d:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801681:	74 08                	je     80168b <sget+0x9b>
				return (void *)mem_block->sva;
  801683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801686:	8b 40 08             	mov    0x8(%eax),%eax
  801689:	eb 05                	jmp    801690 <sget+0xa0>
		}
	}
	return (void *)NULL;
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801698:	e8 12 fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80169d:	83 ec 04             	sub    $0x4,%esp
  8016a0:	68 68 3d 80 00       	push   $0x803d68
  8016a5:	68 f1 00 00 00       	push   $0xf1
  8016aa:	68 13 3d 80 00       	push   $0x803d13
  8016af:	e8 bd eb ff ff       	call   800271 <_panic>

008016b4 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	68 90 3d 80 00       	push   $0x803d90
  8016c2:	68 05 01 00 00       	push   $0x105
  8016c7:	68 13 3d 80 00       	push   $0x803d13
  8016cc:	e8 a0 eb ff ff       	call   800271 <_panic>

008016d1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	68 b4 3d 80 00       	push   $0x803db4
  8016df:	68 10 01 00 00       	push   $0x110
  8016e4:	68 13 3d 80 00       	push   $0x803d13
  8016e9:	e8 83 eb ff ff       	call   800271 <_panic>

008016ee <shrink>:

}
void shrink(uint32 newSize)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f4:	83 ec 04             	sub    $0x4,%esp
  8016f7:	68 b4 3d 80 00       	push   $0x803db4
  8016fc:	68 15 01 00 00       	push   $0x115
  801701:	68 13 3d 80 00       	push   $0x803d13
  801706:	e8 66 eb ff ff       	call   800271 <_panic>

0080170b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	68 b4 3d 80 00       	push   $0x803db4
  801719:	68 1a 01 00 00       	push   $0x11a
  80171e:	68 13 3d 80 00       	push   $0x803d13
  801723:	e8 49 eb ff ff       	call   800271 <_panic>

00801728 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	57                   	push   %edi
  80172c:	56                   	push   %esi
  80172d:	53                   	push   %ebx
  80172e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	8b 55 0c             	mov    0xc(%ebp),%edx
  801737:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80173d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801740:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801743:	cd 30                	int    $0x30
  801745:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801748:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	5b                   	pop    %ebx
  80174f:	5e                   	pop    %esi
  801750:	5f                   	pop    %edi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	83 ec 04             	sub    $0x4,%esp
  801759:	8b 45 10             	mov    0x10(%ebp),%eax
  80175c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80175f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	52                   	push   %edx
  80176b:	ff 75 0c             	pushl  0xc(%ebp)
  80176e:	50                   	push   %eax
  80176f:	6a 00                	push   $0x0
  801771:	e8 b2 ff ff ff       	call   801728 <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	90                   	nop
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <sys_cgetc>:

int
sys_cgetc(void)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 01                	push   $0x1
  80178b:	e8 98 ff ff ff       	call   801728 <syscall>
  801790:	83 c4 18             	add    $0x18,%esp
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	52                   	push   %edx
  8017a5:	50                   	push   %eax
  8017a6:	6a 05                	push   $0x5
  8017a8:	e8 7b ff ff ff       	call   801728 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
}
  8017b0:	c9                   	leave  
  8017b1:	c3                   	ret    

008017b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	56                   	push   %esi
  8017b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8017ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
  8017c8:	51                   	push   %ecx
  8017c9:	52                   	push   %edx
  8017ca:	50                   	push   %eax
  8017cb:	6a 06                	push   $0x6
  8017cd:	e8 56 ff ff ff       	call   801728 <syscall>
  8017d2:	83 c4 18             	add    $0x18,%esp
}
  8017d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	52                   	push   %edx
  8017ec:	50                   	push   %eax
  8017ed:	6a 07                	push   $0x7
  8017ef:	e8 34 ff ff ff       	call   801728 <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
}
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	ff 75 08             	pushl  0x8(%ebp)
  801808:	6a 08                	push   $0x8
  80180a:	e8 19 ff ff ff       	call   801728 <syscall>
  80180f:	83 c4 18             	add    $0x18,%esp
}
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 09                	push   $0x9
  801823:	e8 00 ff ff ff       	call   801728 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 0a                	push   $0xa
  80183c:	e8 e7 fe ff ff       	call   801728 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 0b                	push   $0xb
  801855:	e8 ce fe ff ff       	call   801728 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	6a 0f                	push   $0xf
  801870:	e8 b3 fe ff ff       	call   801728 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
	return;
  801878:	90                   	nop
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	ff 75 0c             	pushl  0xc(%ebp)
  801887:	ff 75 08             	pushl  0x8(%ebp)
  80188a:	6a 10                	push   $0x10
  80188c:	e8 97 fe ff ff       	call   801728 <syscall>
  801891:	83 c4 18             	add    $0x18,%esp
	return ;
  801894:	90                   	nop
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	ff 75 10             	pushl  0x10(%ebp)
  8018a1:	ff 75 0c             	pushl  0xc(%ebp)
  8018a4:	ff 75 08             	pushl  0x8(%ebp)
  8018a7:	6a 11                	push   $0x11
  8018a9:	e8 7a fe ff ff       	call   801728 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8018b1:	90                   	nop
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 0c                	push   $0xc
  8018c3:	e8 60 fe ff ff       	call   801728 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	ff 75 08             	pushl  0x8(%ebp)
  8018db:	6a 0d                	push   $0xd
  8018dd:	e8 46 fe ff ff       	call   801728 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 0e                	push   $0xe
  8018f6:	e8 2d fe ff ff       	call   801728 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 13                	push   $0x13
  801910:	e8 13 fe ff ff       	call   801728 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	90                   	nop
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 14                	push   $0x14
  80192a:	e8 f9 fd ff ff       	call   801728 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	90                   	nop
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_cputc>:


void
sys_cputc(const char c)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 04             	sub    $0x4,%esp
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801941:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	50                   	push   %eax
  80194e:	6a 15                	push   $0x15
  801950:	e8 d3 fd ff ff       	call   801728 <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	90                   	nop
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 16                	push   $0x16
  80196a:	e8 b9 fd ff ff       	call   801728 <syscall>
  80196f:	83 c4 18             	add    $0x18,%esp
}
  801972:	90                   	nop
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	ff 75 0c             	pushl  0xc(%ebp)
  801984:	50                   	push   %eax
  801985:	6a 17                	push   $0x17
  801987:	e8 9c fd ff ff       	call   801728 <syscall>
  80198c:	83 c4 18             	add    $0x18,%esp
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801994:	8b 55 0c             	mov    0xc(%ebp),%edx
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	52                   	push   %edx
  8019a1:	50                   	push   %eax
  8019a2:	6a 1a                	push   $0x1a
  8019a4:	e8 7f fd ff ff       	call   801728 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	52                   	push   %edx
  8019be:	50                   	push   %eax
  8019bf:	6a 18                	push   $0x18
  8019c1:	e8 62 fd ff ff       	call   801728 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	52                   	push   %edx
  8019dc:	50                   	push   %eax
  8019dd:	6a 19                	push   $0x19
  8019df:	e8 44 fd ff ff       	call   801728 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	90                   	nop
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019f6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	6a 00                	push   $0x0
  801a02:	51                   	push   %ecx
  801a03:	52                   	push   %edx
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	50                   	push   %eax
  801a08:	6a 1b                	push   $0x1b
  801a0a:	e8 19 fd ff ff       	call   801728 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	6a 1c                	push   $0x1c
  801a27:	e8 fc fc ff ff       	call   801728 <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a34:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	51                   	push   %ecx
  801a42:	52                   	push   %edx
  801a43:	50                   	push   %eax
  801a44:	6a 1d                	push   $0x1d
  801a46:	e8 dd fc ff ff       	call   801728 <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a56:	8b 45 08             	mov    0x8(%ebp),%eax
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	52                   	push   %edx
  801a60:	50                   	push   %eax
  801a61:	6a 1e                	push   $0x1e
  801a63:	e8 c0 fc ff ff       	call   801728 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 1f                	push   $0x1f
  801a7c:	e8 a7 fc ff ff       	call   801728 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	ff 75 14             	pushl  0x14(%ebp)
  801a91:	ff 75 10             	pushl  0x10(%ebp)
  801a94:	ff 75 0c             	pushl  0xc(%ebp)
  801a97:	50                   	push   %eax
  801a98:	6a 20                	push   $0x20
  801a9a:	e8 89 fc ff ff       	call   801728 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	c9                   	leave  
  801aa3:	c3                   	ret    

00801aa4 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	50                   	push   %eax
  801ab3:	6a 21                	push   $0x21
  801ab5:	e8 6e fc ff ff       	call   801728 <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	90                   	nop
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	50                   	push   %eax
  801acf:	6a 22                	push   $0x22
  801ad1:	e8 52 fc ff ff       	call   801728 <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <sys_getenvid>:

int32 sys_getenvid(void)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 02                	push   $0x2
  801aea:	e8 39 fc ff ff       	call   801728 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 03                	push   $0x3
  801b03:	e8 20 fc ff ff       	call   801728 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 04                	push   $0x4
  801b1c:	e8 07 fc ff ff       	call   801728 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_exit_env>:


void sys_exit_env(void)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 23                	push   $0x23
  801b35:	e8 ee fb ff ff       	call   801728 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	90                   	nop
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b46:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b49:	8d 50 04             	lea    0x4(%eax),%edx
  801b4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	6a 24                	push   $0x24
  801b59:	e8 ca fb ff ff       	call   801728 <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
	return result;
  801b61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b6a:	89 01                	mov    %eax,(%ecx)
  801b6c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	c9                   	leave  
  801b73:	c2 04 00             	ret    $0x4

00801b76 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	ff 75 10             	pushl  0x10(%ebp)
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	6a 12                	push   $0x12
  801b88:	e8 9b fb ff ff       	call   801728 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b90:	90                   	nop
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 25                	push   $0x25
  801ba2:	e8 81 fb ff ff       	call   801728 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 04             	sub    $0x4,%esp
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bb8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	50                   	push   %eax
  801bc5:	6a 26                	push   $0x26
  801bc7:	e8 5c fb ff ff       	call   801728 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <rsttst>:
void rsttst()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 28                	push   $0x28
  801be1:	e8 42 fb ff ff       	call   801728 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
	return ;
  801be9:	90                   	nop
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 04             	sub    $0x4,%esp
  801bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bf8:	8b 55 18             	mov    0x18(%ebp),%edx
  801bfb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bff:	52                   	push   %edx
  801c00:	50                   	push   %eax
  801c01:	ff 75 10             	pushl  0x10(%ebp)
  801c04:	ff 75 0c             	pushl  0xc(%ebp)
  801c07:	ff 75 08             	pushl  0x8(%ebp)
  801c0a:	6a 27                	push   $0x27
  801c0c:	e8 17 fb ff ff       	call   801728 <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
	return ;
  801c14:	90                   	nop
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <chktst>:
void chktst(uint32 n)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	ff 75 08             	pushl  0x8(%ebp)
  801c25:	6a 29                	push   $0x29
  801c27:	e8 fc fa ff ff       	call   801728 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2f:	90                   	nop
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <inctst>:

void inctst()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 2a                	push   $0x2a
  801c41:	e8 e2 fa ff ff       	call   801728 <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
	return ;
  801c49:	90                   	nop
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <gettst>:
uint32 gettst()
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 2b                	push   $0x2b
  801c5b:	e8 c8 fa ff ff       	call   801728 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 2c                	push   $0x2c
  801c77:	e8 ac fa ff ff       	call   801728 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
  801c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c82:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c86:	75 07                	jne    801c8f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c88:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8d:	eb 05                	jmp    801c94 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 2c                	push   $0x2c
  801ca8:	e8 7b fa ff ff       	call   801728 <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
  801cb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cb3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cb7:	75 07                	jne    801cc0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cbe:	eb 05                	jmp    801cc5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 2c                	push   $0x2c
  801cd9:	e8 4a fa ff ff       	call   801728 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
  801ce1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ce4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ce8:	75 07                	jne    801cf1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cea:	b8 01 00 00 00       	mov    $0x1,%eax
  801cef:	eb 05                	jmp    801cf6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cf6:	c9                   	leave  
  801cf7:	c3                   	ret    

00801cf8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cf8:	55                   	push   %ebp
  801cf9:	89 e5                	mov    %esp,%ebp
  801cfb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 2c                	push   $0x2c
  801d0a:	e8 19 fa ff ff       	call   801728 <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
  801d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d15:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d19:	75 07                	jne    801d22 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d20:	eb 05                	jmp    801d27 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	ff 75 08             	pushl  0x8(%ebp)
  801d37:	6a 2d                	push   $0x2d
  801d39:	e8 ea f9 ff ff       	call   801728 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d41:	90                   	nop
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
  801d47:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d48:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	53                   	push   %ebx
  801d57:	51                   	push   %ecx
  801d58:	52                   	push   %edx
  801d59:	50                   	push   %eax
  801d5a:	6a 2e                	push   $0x2e
  801d5c:	e8 c7 f9 ff ff       	call   801728 <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
}
  801d64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	52                   	push   %edx
  801d79:	50                   	push   %eax
  801d7a:	6a 2f                	push   $0x2f
  801d7c:	e8 a7 f9 ff ff       	call   801728 <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d8c:	83 ec 0c             	sub    $0xc,%esp
  801d8f:	68 c4 3d 80 00       	push   $0x803dc4
  801d94:	e8 8c e7 ff ff       	call   800525 <cprintf>
  801d99:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d9c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801da3:	83 ec 0c             	sub    $0xc,%esp
  801da6:	68 f0 3d 80 00       	push   $0x803df0
  801dab:	e8 75 e7 ff ff       	call   800525 <cprintf>
  801db0:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801db3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801db7:	a1 38 41 80 00       	mov    0x804138,%eax
  801dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dbf:	eb 56                	jmp    801e17 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc5:	74 1c                	je     801de3 <print_mem_block_lists+0x5d>
  801dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dca:	8b 50 08             	mov    0x8(%eax),%edx
  801dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd0:	8b 48 08             	mov    0x8(%eax),%ecx
  801dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd6:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd9:	01 c8                	add    %ecx,%eax
  801ddb:	39 c2                	cmp    %eax,%edx
  801ddd:	73 04                	jae    801de3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ddf:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de6:	8b 50 08             	mov    0x8(%eax),%edx
  801de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dec:	8b 40 0c             	mov    0xc(%eax),%eax
  801def:	01 c2                	add    %eax,%edx
  801df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df4:	8b 40 08             	mov    0x8(%eax),%eax
  801df7:	83 ec 04             	sub    $0x4,%esp
  801dfa:	52                   	push   %edx
  801dfb:	50                   	push   %eax
  801dfc:	68 05 3e 80 00       	push   $0x803e05
  801e01:	e8 1f e7 ff ff       	call   800525 <cprintf>
  801e06:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e0f:	a1 40 41 80 00       	mov    0x804140,%eax
  801e14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e1b:	74 07                	je     801e24 <print_mem_block_lists+0x9e>
  801e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e20:	8b 00                	mov    (%eax),%eax
  801e22:	eb 05                	jmp    801e29 <print_mem_block_lists+0xa3>
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
  801e29:	a3 40 41 80 00       	mov    %eax,0x804140
  801e2e:	a1 40 41 80 00       	mov    0x804140,%eax
  801e33:	85 c0                	test   %eax,%eax
  801e35:	75 8a                	jne    801dc1 <print_mem_block_lists+0x3b>
  801e37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e3b:	75 84                	jne    801dc1 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e3d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e41:	75 10                	jne    801e53 <print_mem_block_lists+0xcd>
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	68 14 3e 80 00       	push   $0x803e14
  801e4b:	e8 d5 e6 ff ff       	call   800525 <cprintf>
  801e50:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e53:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	68 38 3e 80 00       	push   $0x803e38
  801e62:	e8 be e6 ff ff       	call   800525 <cprintf>
  801e67:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e6a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e6e:	a1 40 40 80 00       	mov    0x804040,%eax
  801e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e76:	eb 56                	jmp    801ece <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e7c:	74 1c                	je     801e9a <print_mem_block_lists+0x114>
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	8b 50 08             	mov    0x8(%eax),%edx
  801e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e87:	8b 48 08             	mov    0x8(%eax),%ecx
  801e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e90:	01 c8                	add    %ecx,%eax
  801e92:	39 c2                	cmp    %eax,%edx
  801e94:	73 04                	jae    801e9a <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e96:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	8b 50 08             	mov    0x8(%eax),%edx
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea6:	01 c2                	add    %eax,%edx
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	8b 40 08             	mov    0x8(%eax),%eax
  801eae:	83 ec 04             	sub    $0x4,%esp
  801eb1:	52                   	push   %edx
  801eb2:	50                   	push   %eax
  801eb3:	68 05 3e 80 00       	push   $0x803e05
  801eb8:	e8 68 e6 ff ff       	call   800525 <cprintf>
  801ebd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ec6:	a1 48 40 80 00       	mov    0x804048,%eax
  801ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed2:	74 07                	je     801edb <print_mem_block_lists+0x155>
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	8b 00                	mov    (%eax),%eax
  801ed9:	eb 05                	jmp    801ee0 <print_mem_block_lists+0x15a>
  801edb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee0:	a3 48 40 80 00       	mov    %eax,0x804048
  801ee5:	a1 48 40 80 00       	mov    0x804048,%eax
  801eea:	85 c0                	test   %eax,%eax
  801eec:	75 8a                	jne    801e78 <print_mem_block_lists+0xf2>
  801eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef2:	75 84                	jne    801e78 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ef4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef8:	75 10                	jne    801f0a <print_mem_block_lists+0x184>
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	68 50 3e 80 00       	push   $0x803e50
  801f02:	e8 1e e6 ff ff       	call   800525 <cprintf>
  801f07:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	68 c4 3d 80 00       	push   $0x803dc4
  801f12:	e8 0e e6 ff ff       	call   800525 <cprintf>
  801f17:	83 c4 10             	add    $0x10,%esp

}
  801f1a:	90                   	nop
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f23:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f2a:	00 00 00 
  801f2d:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f34:	00 00 00 
  801f37:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f3e:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f48:	e9 9e 00 00 00       	jmp    801feb <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f4d:	a1 50 40 80 00       	mov    0x804050,%eax
  801f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f55:	c1 e2 04             	shl    $0x4,%edx
  801f58:	01 d0                	add    %edx,%eax
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	75 14                	jne    801f72 <initialize_MemBlocksList+0x55>
  801f5e:	83 ec 04             	sub    $0x4,%esp
  801f61:	68 78 3e 80 00       	push   $0x803e78
  801f66:	6a 46                	push   $0x46
  801f68:	68 9b 3e 80 00       	push   $0x803e9b
  801f6d:	e8 ff e2 ff ff       	call   800271 <_panic>
  801f72:	a1 50 40 80 00       	mov    0x804050,%eax
  801f77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7a:	c1 e2 04             	shl    $0x4,%edx
  801f7d:	01 d0                	add    %edx,%eax
  801f7f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f85:	89 10                	mov    %edx,(%eax)
  801f87:	8b 00                	mov    (%eax),%eax
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	74 18                	je     801fa5 <initialize_MemBlocksList+0x88>
  801f8d:	a1 48 41 80 00       	mov    0x804148,%eax
  801f92:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f98:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f9b:	c1 e1 04             	shl    $0x4,%ecx
  801f9e:	01 ca                	add    %ecx,%edx
  801fa0:	89 50 04             	mov    %edx,0x4(%eax)
  801fa3:	eb 12                	jmp    801fb7 <initialize_MemBlocksList+0x9a>
  801fa5:	a1 50 40 80 00       	mov    0x804050,%eax
  801faa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fad:	c1 e2 04             	shl    $0x4,%edx
  801fb0:	01 d0                	add    %edx,%eax
  801fb2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801fb7:	a1 50 40 80 00       	mov    0x804050,%eax
  801fbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbf:	c1 e2 04             	shl    $0x4,%edx
  801fc2:	01 d0                	add    %edx,%eax
  801fc4:	a3 48 41 80 00       	mov    %eax,0x804148
  801fc9:	a1 50 40 80 00       	mov    0x804050,%eax
  801fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd1:	c1 e2 04             	shl    $0x4,%edx
  801fd4:	01 d0                	add    %edx,%eax
  801fd6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fdd:	a1 54 41 80 00       	mov    0x804154,%eax
  801fe2:	40                   	inc    %eax
  801fe3:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801fe8:	ff 45 f4             	incl   -0xc(%ebp)
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ff1:	0f 82 56 ff ff ff    	jb     801f4d <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801ff7:	90                   	nop
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	8b 00                	mov    (%eax),%eax
  802005:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802008:	eb 19                	jmp    802023 <find_block+0x29>
	{
		if(va==point->sva)
  80200a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80200d:	8b 40 08             	mov    0x8(%eax),%eax
  802010:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802013:	75 05                	jne    80201a <find_block+0x20>
		   return point;
  802015:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802018:	eb 36                	jmp    802050 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	8b 40 08             	mov    0x8(%eax),%eax
  802020:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802023:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802027:	74 07                	je     802030 <find_block+0x36>
  802029:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80202c:	8b 00                	mov    (%eax),%eax
  80202e:	eb 05                	jmp    802035 <find_block+0x3b>
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
  802035:	8b 55 08             	mov    0x8(%ebp),%edx
  802038:	89 42 08             	mov    %eax,0x8(%edx)
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	8b 40 08             	mov    0x8(%eax),%eax
  802041:	85 c0                	test   %eax,%eax
  802043:	75 c5                	jne    80200a <find_block+0x10>
  802045:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802049:	75 bf                	jne    80200a <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80204b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802050:	c9                   	leave  
  802051:	c3                   	ret    

00802052 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802052:	55                   	push   %ebp
  802053:	89 e5                	mov    %esp,%ebp
  802055:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802058:	a1 40 40 80 00       	mov    0x804040,%eax
  80205d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802060:	a1 44 40 80 00       	mov    0x804044,%eax
  802065:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80206e:	74 24                	je     802094 <insert_sorted_allocList+0x42>
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	8b 50 08             	mov    0x8(%eax),%edx
  802076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802079:	8b 40 08             	mov    0x8(%eax),%eax
  80207c:	39 c2                	cmp    %eax,%edx
  80207e:	76 14                	jbe    802094 <insert_sorted_allocList+0x42>
  802080:	8b 45 08             	mov    0x8(%ebp),%eax
  802083:	8b 50 08             	mov    0x8(%eax),%edx
  802086:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802089:	8b 40 08             	mov    0x8(%eax),%eax
  80208c:	39 c2                	cmp    %eax,%edx
  80208e:	0f 82 60 01 00 00    	jb     8021f4 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802094:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802098:	75 65                	jne    8020ff <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  80209a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80209e:	75 14                	jne    8020b4 <insert_sorted_allocList+0x62>
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	68 78 3e 80 00       	push   $0x803e78
  8020a8:	6a 6b                	push   $0x6b
  8020aa:	68 9b 3e 80 00       	push   $0x803e9b
  8020af:	e8 bd e1 ff ff       	call   800271 <_panic>
  8020b4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	89 10                	mov    %edx,(%eax)
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	8b 00                	mov    (%eax),%eax
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	74 0d                	je     8020d5 <insert_sorted_allocList+0x83>
  8020c8:	a1 40 40 80 00       	mov    0x804040,%eax
  8020cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d0:	89 50 04             	mov    %edx,0x4(%eax)
  8020d3:	eb 08                	jmp    8020dd <insert_sorted_allocList+0x8b>
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	a3 44 40 80 00       	mov    %eax,0x804044
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	a3 40 40 80 00       	mov    %eax,0x804040
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ef:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f4:	40                   	inc    %eax
  8020f5:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020fa:	e9 dc 01 00 00       	jmp    8022db <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	8b 50 08             	mov    0x8(%eax),%edx
  802105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802108:	8b 40 08             	mov    0x8(%eax),%eax
  80210b:	39 c2                	cmp    %eax,%edx
  80210d:	77 6c                	ja     80217b <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80210f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802113:	74 06                	je     80211b <insert_sorted_allocList+0xc9>
  802115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802119:	75 14                	jne    80212f <insert_sorted_allocList+0xdd>
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	68 b4 3e 80 00       	push   $0x803eb4
  802123:	6a 6f                	push   $0x6f
  802125:	68 9b 3e 80 00       	push   $0x803e9b
  80212a:	e8 42 e1 ff ff       	call   800271 <_panic>
  80212f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802132:	8b 50 04             	mov    0x4(%eax),%edx
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	89 50 04             	mov    %edx,0x4(%eax)
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802141:	89 10                	mov    %edx,(%eax)
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	8b 40 04             	mov    0x4(%eax),%eax
  802149:	85 c0                	test   %eax,%eax
  80214b:	74 0d                	je     80215a <insert_sorted_allocList+0x108>
  80214d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802150:	8b 40 04             	mov    0x4(%eax),%eax
  802153:	8b 55 08             	mov    0x8(%ebp),%edx
  802156:	89 10                	mov    %edx,(%eax)
  802158:	eb 08                	jmp    802162 <insert_sorted_allocList+0x110>
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	a3 40 40 80 00       	mov    %eax,0x804040
  802162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802165:	8b 55 08             	mov    0x8(%ebp),%edx
  802168:	89 50 04             	mov    %edx,0x4(%eax)
  80216b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802170:	40                   	inc    %eax
  802171:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802176:	e9 60 01 00 00       	jmp    8022db <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8b 50 08             	mov    0x8(%eax),%edx
  802181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	39 c2                	cmp    %eax,%edx
  802189:	0f 82 4c 01 00 00    	jb     8022db <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80218f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802193:	75 14                	jne    8021a9 <insert_sorted_allocList+0x157>
  802195:	83 ec 04             	sub    $0x4,%esp
  802198:	68 ec 3e 80 00       	push   $0x803eec
  80219d:	6a 73                	push   $0x73
  80219f:	68 9b 3e 80 00       	push   $0x803e9b
  8021a4:	e8 c8 e0 ff ff       	call   800271 <_panic>
  8021a9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	89 50 04             	mov    %edx,0x4(%eax)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8b 40 04             	mov    0x4(%eax),%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	74 0c                	je     8021cb <insert_sorted_allocList+0x179>
  8021bf:	a1 44 40 80 00       	mov    0x804044,%eax
  8021c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c7:	89 10                	mov    %edx,(%eax)
  8021c9:	eb 08                	jmp    8021d3 <insert_sorted_allocList+0x181>
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	a3 40 40 80 00       	mov    %eax,0x804040
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021e4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e9:	40                   	inc    %eax
  8021ea:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021ef:	e9 e7 00 00 00       	jmp    8022db <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8021f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8021fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802201:	a1 40 40 80 00       	mov    0x804040,%eax
  802206:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802209:	e9 9d 00 00 00       	jmp    8022ab <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	8b 00                	mov    (%eax),%eax
  802213:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8b 50 08             	mov    0x8(%eax),%edx
  80221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221f:	8b 40 08             	mov    0x8(%eax),%eax
  802222:	39 c2                	cmp    %eax,%edx
  802224:	76 7d                	jbe    8022a3 <insert_sorted_allocList+0x251>
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	8b 50 08             	mov    0x8(%eax),%edx
  80222c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80222f:	8b 40 08             	mov    0x8(%eax),%eax
  802232:	39 c2                	cmp    %eax,%edx
  802234:	73 6d                	jae    8022a3 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802236:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223a:	74 06                	je     802242 <insert_sorted_allocList+0x1f0>
  80223c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802240:	75 14                	jne    802256 <insert_sorted_allocList+0x204>
  802242:	83 ec 04             	sub    $0x4,%esp
  802245:	68 10 3f 80 00       	push   $0x803f10
  80224a:	6a 7f                	push   $0x7f
  80224c:	68 9b 3e 80 00       	push   $0x803e9b
  802251:	e8 1b e0 ff ff       	call   800271 <_panic>
  802256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802259:	8b 10                	mov    (%eax),%edx
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	89 10                	mov    %edx,(%eax)
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	8b 00                	mov    (%eax),%eax
  802265:	85 c0                	test   %eax,%eax
  802267:	74 0b                	je     802274 <insert_sorted_allocList+0x222>
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 00                	mov    (%eax),%eax
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
  802271:	89 50 04             	mov    %edx,0x4(%eax)
  802274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802277:	8b 55 08             	mov    0x8(%ebp),%edx
  80227a:	89 10                	mov    %edx,(%eax)
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802282:	89 50 04             	mov    %edx,0x4(%eax)
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8b 00                	mov    (%eax),%eax
  80228a:	85 c0                	test   %eax,%eax
  80228c:	75 08                	jne    802296 <insert_sorted_allocList+0x244>
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	a3 44 40 80 00       	mov    %eax,0x804044
  802296:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80229b:	40                   	inc    %eax
  80229c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8022a1:	eb 39                	jmp    8022dc <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022a3:	a1 48 40 80 00       	mov    0x804048,%eax
  8022a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022af:	74 07                	je     8022b8 <insert_sorted_allocList+0x266>
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 00                	mov    (%eax),%eax
  8022b6:	eb 05                	jmp    8022bd <insert_sorted_allocList+0x26b>
  8022b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bd:	a3 48 40 80 00       	mov    %eax,0x804048
  8022c2:	a1 48 40 80 00       	mov    0x804048,%eax
  8022c7:	85 c0                	test   %eax,%eax
  8022c9:	0f 85 3f ff ff ff    	jne    80220e <insert_sorted_allocList+0x1bc>
  8022cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d3:	0f 85 35 ff ff ff    	jne    80220e <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022d9:	eb 01                	jmp    8022dc <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022db:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8022dc:	90                   	nop
  8022dd:	c9                   	leave  
  8022de:	c3                   	ret    

008022df <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8022e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8022ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ed:	e9 85 01 00 00       	jmp    802477 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022fb:	0f 82 6e 01 00 00    	jb     80246f <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 40 0c             	mov    0xc(%eax),%eax
  802307:	3b 45 08             	cmp    0x8(%ebp),%eax
  80230a:	0f 85 8a 00 00 00    	jne    80239a <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802314:	75 17                	jne    80232d <alloc_block_FF+0x4e>
  802316:	83 ec 04             	sub    $0x4,%esp
  802319:	68 44 3f 80 00       	push   $0x803f44
  80231e:	68 93 00 00 00       	push   $0x93
  802323:	68 9b 3e 80 00       	push   $0x803e9b
  802328:	e8 44 df ff ff       	call   800271 <_panic>
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 00                	mov    (%eax),%eax
  802332:	85 c0                	test   %eax,%eax
  802334:	74 10                	je     802346 <alloc_block_FF+0x67>
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80233e:	8b 52 04             	mov    0x4(%edx),%edx
  802341:	89 50 04             	mov    %edx,0x4(%eax)
  802344:	eb 0b                	jmp    802351 <alloc_block_FF+0x72>
  802346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802349:	8b 40 04             	mov    0x4(%eax),%eax
  80234c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 40 04             	mov    0x4(%eax),%eax
  802357:	85 c0                	test   %eax,%eax
  802359:	74 0f                	je     80236a <alloc_block_FF+0x8b>
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 40 04             	mov    0x4(%eax),%eax
  802361:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802364:	8b 12                	mov    (%edx),%edx
  802366:	89 10                	mov    %edx,(%eax)
  802368:	eb 0a                	jmp    802374 <alloc_block_FF+0x95>
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	8b 00                	mov    (%eax),%eax
  80236f:	a3 38 41 80 00       	mov    %eax,0x804138
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802387:	a1 44 41 80 00       	mov    0x804144,%eax
  80238c:	48                   	dec    %eax
  80238d:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	e9 10 01 00 00       	jmp    8024aa <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a3:	0f 86 c6 00 00 00    	jbe    80246f <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023a9:	a1 48 41 80 00       	mov    0x804148,%eax
  8023ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 50 08             	mov    0x8(%eax),%edx
  8023b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ba:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c3:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8023c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023ca:	75 17                	jne    8023e3 <alloc_block_FF+0x104>
  8023cc:	83 ec 04             	sub    $0x4,%esp
  8023cf:	68 44 3f 80 00       	push   $0x803f44
  8023d4:	68 9b 00 00 00       	push   $0x9b
  8023d9:	68 9b 3e 80 00       	push   $0x803e9b
  8023de:	e8 8e de ff ff       	call   800271 <_panic>
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	74 10                	je     8023fc <alloc_block_FF+0x11d>
  8023ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ef:	8b 00                	mov    (%eax),%eax
  8023f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f4:	8b 52 04             	mov    0x4(%edx),%edx
  8023f7:	89 50 04             	mov    %edx,0x4(%eax)
  8023fa:	eb 0b                	jmp    802407 <alloc_block_FF+0x128>
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240a:	8b 40 04             	mov    0x4(%eax),%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	74 0f                	je     802420 <alloc_block_FF+0x141>
  802411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80241a:	8b 12                	mov    (%edx),%edx
  80241c:	89 10                	mov    %edx,(%eax)
  80241e:	eb 0a                	jmp    80242a <alloc_block_FF+0x14b>
  802420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	a3 48 41 80 00       	mov    %eax,0x804148
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802436:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243d:	a1 54 41 80 00       	mov    0x804154,%eax
  802442:	48                   	dec    %eax
  802443:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 50 08             	mov    0x8(%eax),%edx
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	01 c2                	add    %eax,%edx
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 40 0c             	mov    0xc(%eax),%eax
  80245f:	2b 45 08             	sub    0x8(%ebp),%eax
  802462:	89 c2                	mov    %eax,%edx
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	eb 3b                	jmp    8024aa <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80246f:	a1 40 41 80 00       	mov    0x804140,%eax
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247b:	74 07                	je     802484 <alloc_block_FF+0x1a5>
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 00                	mov    (%eax),%eax
  802482:	eb 05                	jmp    802489 <alloc_block_FF+0x1aa>
  802484:	b8 00 00 00 00       	mov    $0x0,%eax
  802489:	a3 40 41 80 00       	mov    %eax,0x804140
  80248e:	a1 40 41 80 00       	mov    0x804140,%eax
  802493:	85 c0                	test   %eax,%eax
  802495:	0f 85 57 fe ff ff    	jne    8022f2 <alloc_block_FF+0x13>
  80249b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249f:	0f 85 4d fe ff ff    	jne    8022f2 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024b2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024b9:	a1 38 41 80 00       	mov    0x804138,%eax
  8024be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c1:	e9 df 00 00 00       	jmp    8025a5 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024cf:	0f 82 c8 00 00 00    	jb     80259d <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024de:	0f 85 8a 00 00 00    	jne    80256e <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8024e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e8:	75 17                	jne    802501 <alloc_block_BF+0x55>
  8024ea:	83 ec 04             	sub    $0x4,%esp
  8024ed:	68 44 3f 80 00       	push   $0x803f44
  8024f2:	68 b7 00 00 00       	push   $0xb7
  8024f7:	68 9b 3e 80 00       	push   $0x803e9b
  8024fc:	e8 70 dd ff ff       	call   800271 <_panic>
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 00                	mov    (%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 10                	je     80251a <alloc_block_BF+0x6e>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802512:	8b 52 04             	mov    0x4(%edx),%edx
  802515:	89 50 04             	mov    %edx,0x4(%eax)
  802518:	eb 0b                	jmp    802525 <alloc_block_BF+0x79>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 04             	mov    0x4(%eax),%eax
  802520:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	85 c0                	test   %eax,%eax
  80252d:	74 0f                	je     80253e <alloc_block_BF+0x92>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 40 04             	mov    0x4(%eax),%eax
  802535:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802538:	8b 12                	mov    (%edx),%edx
  80253a:	89 10                	mov    %edx,(%eax)
  80253c:	eb 0a                	jmp    802548 <alloc_block_BF+0x9c>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	a3 38 41 80 00       	mov    %eax,0x804138
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80255b:	a1 44 41 80 00       	mov    0x804144,%eax
  802560:	48                   	dec    %eax
  802561:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	e9 4d 01 00 00       	jmp    8026bb <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 40 0c             	mov    0xc(%eax),%eax
  802574:	3b 45 08             	cmp    0x8(%ebp),%eax
  802577:	76 24                	jbe    80259d <alloc_block_BF+0xf1>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 0c             	mov    0xc(%eax),%eax
  80257f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802582:	73 19                	jae    80259d <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802584:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 40 0c             	mov    0xc(%eax),%eax
  802591:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 08             	mov    0x8(%eax),%eax
  80259a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80259d:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a9:	74 07                	je     8025b2 <alloc_block_BF+0x106>
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 00                	mov    (%eax),%eax
  8025b0:	eb 05                	jmp    8025b7 <alloc_block_BF+0x10b>
  8025b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b7:	a3 40 41 80 00       	mov    %eax,0x804140
  8025bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c1:	85 c0                	test   %eax,%eax
  8025c3:	0f 85 fd fe ff ff    	jne    8024c6 <alloc_block_BF+0x1a>
  8025c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cd:	0f 85 f3 fe ff ff    	jne    8024c6 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8025d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8025d7:	0f 84 d9 00 00 00    	je     8026b6 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8025dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8025e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8025e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025eb:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8025ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f4:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8025f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8025fb:	75 17                	jne    802614 <alloc_block_BF+0x168>
  8025fd:	83 ec 04             	sub    $0x4,%esp
  802600:	68 44 3f 80 00       	push   $0x803f44
  802605:	68 c7 00 00 00       	push   $0xc7
  80260a:	68 9b 3e 80 00       	push   $0x803e9b
  80260f:	e8 5d dc ff ff       	call   800271 <_panic>
  802614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802617:	8b 00                	mov    (%eax),%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	74 10                	je     80262d <alloc_block_BF+0x181>
  80261d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802620:	8b 00                	mov    (%eax),%eax
  802622:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802625:	8b 52 04             	mov    0x4(%edx),%edx
  802628:	89 50 04             	mov    %edx,0x4(%eax)
  80262b:	eb 0b                	jmp    802638 <alloc_block_BF+0x18c>
  80262d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802630:	8b 40 04             	mov    0x4(%eax),%eax
  802633:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	85 c0                	test   %eax,%eax
  802640:	74 0f                	je     802651 <alloc_block_BF+0x1a5>
  802642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802645:	8b 40 04             	mov    0x4(%eax),%eax
  802648:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80264b:	8b 12                	mov    (%edx),%edx
  80264d:	89 10                	mov    %edx,(%eax)
  80264f:	eb 0a                	jmp    80265b <alloc_block_BF+0x1af>
  802651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	a3 48 41 80 00       	mov    %eax,0x804148
  80265b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802664:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802667:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266e:	a1 54 41 80 00       	mov    0x804154,%eax
  802673:	48                   	dec    %eax
  802674:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802679:	83 ec 08             	sub    $0x8,%esp
  80267c:	ff 75 ec             	pushl  -0x14(%ebp)
  80267f:	68 38 41 80 00       	push   $0x804138
  802684:	e8 71 f9 ff ff       	call   801ffa <find_block>
  802689:	83 c4 10             	add    $0x10,%esp
  80268c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80268f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802692:	8b 50 08             	mov    0x8(%eax),%edx
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	01 c2                	add    %eax,%edx
  80269a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269d:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a9:	89 c2                	mov    %eax,%edx
  8026ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ae:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b4:	eb 05                	jmp    8026bb <alloc_block_BF+0x20f>
	}
	return NULL;
  8026b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bb:	c9                   	leave  
  8026bc:	c3                   	ret    

008026bd <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026bd:	55                   	push   %ebp
  8026be:	89 e5                	mov    %esp,%ebp
  8026c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8026c3:	a1 28 40 80 00       	mov    0x804028,%eax
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	0f 85 de 01 00 00    	jne    8028ae <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8026d0:	a1 38 41 80 00       	mov    0x804138,%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d8:	e9 9e 01 00 00       	jmp    80287b <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e6:	0f 82 87 01 00 00    	jb     802873 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f5:	0f 85 95 00 00 00    	jne    802790 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8026fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ff:	75 17                	jne    802718 <alloc_block_NF+0x5b>
  802701:	83 ec 04             	sub    $0x4,%esp
  802704:	68 44 3f 80 00       	push   $0x803f44
  802709:	68 e0 00 00 00       	push   $0xe0
  80270e:	68 9b 3e 80 00       	push   $0x803e9b
  802713:	e8 59 db ff ff       	call   800271 <_panic>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	85 c0                	test   %eax,%eax
  80271f:	74 10                	je     802731 <alloc_block_NF+0x74>
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802729:	8b 52 04             	mov    0x4(%edx),%edx
  80272c:	89 50 04             	mov    %edx,0x4(%eax)
  80272f:	eb 0b                	jmp    80273c <alloc_block_NF+0x7f>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 40 04             	mov    0x4(%eax),%eax
  802742:	85 c0                	test   %eax,%eax
  802744:	74 0f                	je     802755 <alloc_block_NF+0x98>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 40 04             	mov    0x4(%eax),%eax
  80274c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274f:	8b 12                	mov    (%edx),%edx
  802751:	89 10                	mov    %edx,(%eax)
  802753:	eb 0a                	jmp    80275f <alloc_block_NF+0xa2>
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 00                	mov    (%eax),%eax
  80275a:	a3 38 41 80 00       	mov    %eax,0x804138
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802772:	a1 44 41 80 00       	mov    0x804144,%eax
  802777:	48                   	dec    %eax
  802778:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 08             	mov    0x8(%eax),%eax
  802783:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	e9 f8 04 00 00       	jmp    802c88 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802793:	8b 40 0c             	mov    0xc(%eax),%eax
  802796:	3b 45 08             	cmp    0x8(%ebp),%eax
  802799:	0f 86 d4 00 00 00    	jbe    802873 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80279f:	a1 48 41 80 00       	mov    0x804148,%eax
  8027a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 50 08             	mov    0x8(%eax),%edx
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b9:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027c0:	75 17                	jne    8027d9 <alloc_block_NF+0x11c>
  8027c2:	83 ec 04             	sub    $0x4,%esp
  8027c5:	68 44 3f 80 00       	push   $0x803f44
  8027ca:	68 e9 00 00 00       	push   $0xe9
  8027cf:	68 9b 3e 80 00       	push   $0x803e9b
  8027d4:	e8 98 da ff ff       	call   800271 <_panic>
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	74 10                	je     8027f2 <alloc_block_NF+0x135>
  8027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ea:	8b 52 04             	mov    0x4(%edx),%edx
  8027ed:	89 50 04             	mov    %edx,0x4(%eax)
  8027f0:	eb 0b                	jmp    8027fd <alloc_block_NF+0x140>
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	8b 40 04             	mov    0x4(%eax),%eax
  8027f8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802800:	8b 40 04             	mov    0x4(%eax),%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	74 0f                	je     802816 <alloc_block_NF+0x159>
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	8b 40 04             	mov    0x4(%eax),%eax
  80280d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802810:	8b 12                	mov    (%edx),%edx
  802812:	89 10                	mov    %edx,(%eax)
  802814:	eb 0a                	jmp    802820 <alloc_block_NF+0x163>
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	a3 48 41 80 00       	mov    %eax,0x804148
  802820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802823:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802833:	a1 54 41 80 00       	mov    0x804154,%eax
  802838:	48                   	dec    %eax
  802839:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  80283e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802841:	8b 40 08             	mov    0x8(%eax),%eax
  802844:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 50 08             	mov    0x8(%eax),%edx
  80284f:	8b 45 08             	mov    0x8(%ebp),%eax
  802852:	01 c2                	add    %eax,%edx
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 0c             	mov    0xc(%eax),%eax
  802860:	2b 45 08             	sub    0x8(%ebp),%eax
  802863:	89 c2                	mov    %eax,%edx
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286e:	e9 15 04 00 00       	jmp    802c88 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802873:	a1 40 41 80 00       	mov    0x804140,%eax
  802878:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80287b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287f:	74 07                	je     802888 <alloc_block_NF+0x1cb>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	eb 05                	jmp    80288d <alloc_block_NF+0x1d0>
  802888:	b8 00 00 00 00       	mov    $0x0,%eax
  80288d:	a3 40 41 80 00       	mov    %eax,0x804140
  802892:	a1 40 41 80 00       	mov    0x804140,%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	0f 85 3e fe ff ff    	jne    8026dd <alloc_block_NF+0x20>
  80289f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a3:	0f 85 34 fe ff ff    	jne    8026dd <alloc_block_NF+0x20>
  8028a9:	e9 d5 03 00 00       	jmp    802c83 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b6:	e9 b1 01 00 00       	jmp    802a6c <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 50 08             	mov    0x8(%eax),%edx
  8028c1:	a1 28 40 80 00       	mov    0x804028,%eax
  8028c6:	39 c2                	cmp    %eax,%edx
  8028c8:	0f 82 96 01 00 00    	jb     802a64 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d7:	0f 82 87 01 00 00    	jb     802a64 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e6:	0f 85 95 00 00 00    	jne    802981 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8028ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f0:	75 17                	jne    802909 <alloc_block_NF+0x24c>
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 44 3f 80 00       	push   $0x803f44
  8028fa:	68 fc 00 00 00       	push   $0xfc
  8028ff:	68 9b 3e 80 00       	push   $0x803e9b
  802904:	e8 68 d9 ff ff       	call   800271 <_panic>
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 10                	je     802922 <alloc_block_NF+0x265>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 00                	mov    (%eax),%eax
  802917:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291a:	8b 52 04             	mov    0x4(%edx),%edx
  80291d:	89 50 04             	mov    %edx,0x4(%eax)
  802920:	eb 0b                	jmp    80292d <alloc_block_NF+0x270>
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 40 04             	mov    0x4(%eax),%eax
  802928:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0f                	je     802946 <alloc_block_NF+0x289>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 40 04             	mov    0x4(%eax),%eax
  80293d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802940:	8b 12                	mov    (%edx),%edx
  802942:	89 10                	mov    %edx,(%eax)
  802944:	eb 0a                	jmp    802950 <alloc_block_NF+0x293>
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 00                	mov    (%eax),%eax
  80294b:	a3 38 41 80 00       	mov    %eax,0x804138
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802963:	a1 44 41 80 00       	mov    0x804144,%eax
  802968:	48                   	dec    %eax
  802969:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 40 08             	mov    0x8(%eax),%eax
  802974:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	e9 07 03 00 00       	jmp    802c88 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 40 0c             	mov    0xc(%eax),%eax
  802987:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298a:	0f 86 d4 00 00 00    	jbe    802a64 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802990:	a1 48 41 80 00       	mov    0x804148,%eax
  802995:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 50 08             	mov    0x8(%eax),%edx
  80299e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a1:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029aa:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029b1:	75 17                	jne    8029ca <alloc_block_NF+0x30d>
  8029b3:	83 ec 04             	sub    $0x4,%esp
  8029b6:	68 44 3f 80 00       	push   $0x803f44
  8029bb:	68 04 01 00 00       	push   $0x104
  8029c0:	68 9b 3e 80 00       	push   $0x803e9b
  8029c5:	e8 a7 d8 ff ff       	call   800271 <_panic>
  8029ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	74 10                	je     8029e3 <alloc_block_NF+0x326>
  8029d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d6:	8b 00                	mov    (%eax),%eax
  8029d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029db:	8b 52 04             	mov    0x4(%edx),%edx
  8029de:	89 50 04             	mov    %edx,0x4(%eax)
  8029e1:	eb 0b                	jmp    8029ee <alloc_block_NF+0x331>
  8029e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	74 0f                	je     802a07 <alloc_block_NF+0x34a>
  8029f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029fb:	8b 40 04             	mov    0x4(%eax),%eax
  8029fe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a01:	8b 12                	mov    (%edx),%edx
  802a03:	89 10                	mov    %edx,(%eax)
  802a05:	eb 0a                	jmp    802a11 <alloc_block_NF+0x354>
  802a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	a3 48 41 80 00       	mov    %eax,0x804148
  802a11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a24:	a1 54 41 80 00       	mov    0x804154,%eax
  802a29:	48                   	dec    %eax
  802a2a:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a32:	8b 40 08             	mov    0x8(%eax),%eax
  802a35:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 50 08             	mov    0x8(%eax),%edx
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	01 c2                	add    %eax,%edx
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a51:	2b 45 08             	sub    0x8(%ebp),%eax
  802a54:	89 c2                	mov    %eax,%edx
  802a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a59:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5f:	e9 24 02 00 00       	jmp    802c88 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a64:	a1 40 41 80 00       	mov    0x804140,%eax
  802a69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a70:	74 07                	je     802a79 <alloc_block_NF+0x3bc>
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	eb 05                	jmp    802a7e <alloc_block_NF+0x3c1>
  802a79:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7e:	a3 40 41 80 00       	mov    %eax,0x804140
  802a83:	a1 40 41 80 00       	mov    0x804140,%eax
  802a88:	85 c0                	test   %eax,%eax
  802a8a:	0f 85 2b fe ff ff    	jne    8028bb <alloc_block_NF+0x1fe>
  802a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a94:	0f 85 21 fe ff ff    	jne    8028bb <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a9a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa2:	e9 ae 01 00 00       	jmp    802c55 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 50 08             	mov    0x8(%eax),%edx
  802aad:	a1 28 40 80 00       	mov    0x804028,%eax
  802ab2:	39 c2                	cmp    %eax,%edx
  802ab4:	0f 83 93 01 00 00    	jae    802c4d <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac3:	0f 82 84 01 00 00    	jb     802c4d <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	8b 40 0c             	mov    0xc(%eax),%eax
  802acf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ad2:	0f 85 95 00 00 00    	jne    802b6d <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802ad8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802adc:	75 17                	jne    802af5 <alloc_block_NF+0x438>
  802ade:	83 ec 04             	sub    $0x4,%esp
  802ae1:	68 44 3f 80 00       	push   $0x803f44
  802ae6:	68 14 01 00 00       	push   $0x114
  802aeb:	68 9b 3e 80 00       	push   $0x803e9b
  802af0:	e8 7c d7 ff ff       	call   800271 <_panic>
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	85 c0                	test   %eax,%eax
  802afc:	74 10                	je     802b0e <alloc_block_NF+0x451>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b06:	8b 52 04             	mov    0x4(%edx),%edx
  802b09:	89 50 04             	mov    %edx,0x4(%eax)
  802b0c:	eb 0b                	jmp    802b19 <alloc_block_NF+0x45c>
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 40 04             	mov    0x4(%eax),%eax
  802b14:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 04             	mov    0x4(%eax),%eax
  802b1f:	85 c0                	test   %eax,%eax
  802b21:	74 0f                	je     802b32 <alloc_block_NF+0x475>
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 40 04             	mov    0x4(%eax),%eax
  802b29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2c:	8b 12                	mov    (%edx),%edx
  802b2e:	89 10                	mov    %edx,(%eax)
  802b30:	eb 0a                	jmp    802b3c <alloc_block_NF+0x47f>
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	a3 38 41 80 00       	mov    %eax,0x804138
  802b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b54:	48                   	dec    %eax
  802b55:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 40 08             	mov    0x8(%eax),%eax
  802b60:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	e9 1b 01 00 00       	jmp    802c88 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 40 0c             	mov    0xc(%eax),%eax
  802b73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b76:	0f 86 d1 00 00 00    	jbe    802c4d <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b7c:	a1 48 41 80 00       	mov    0x804148,%eax
  802b81:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 50 08             	mov    0x8(%eax),%edx
  802b8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8d:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	8b 55 08             	mov    0x8(%ebp),%edx
  802b96:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b9d:	75 17                	jne    802bb6 <alloc_block_NF+0x4f9>
  802b9f:	83 ec 04             	sub    $0x4,%esp
  802ba2:	68 44 3f 80 00       	push   $0x803f44
  802ba7:	68 1c 01 00 00       	push   $0x11c
  802bac:	68 9b 3e 80 00       	push   $0x803e9b
  802bb1:	e8 bb d6 ff ff       	call   800271 <_panic>
  802bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb9:	8b 00                	mov    (%eax),%eax
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	74 10                	je     802bcf <alloc_block_NF+0x512>
  802bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bc7:	8b 52 04             	mov    0x4(%edx),%edx
  802bca:	89 50 04             	mov    %edx,0x4(%eax)
  802bcd:	eb 0b                	jmp    802bda <alloc_block_NF+0x51d>
  802bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd2:	8b 40 04             	mov    0x4(%eax),%eax
  802bd5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdd:	8b 40 04             	mov    0x4(%eax),%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	74 0f                	je     802bf3 <alloc_block_NF+0x536>
  802be4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be7:	8b 40 04             	mov    0x4(%eax),%eax
  802bea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bed:	8b 12                	mov    (%edx),%edx
  802bef:	89 10                	mov    %edx,(%eax)
  802bf1:	eb 0a                	jmp    802bfd <alloc_block_NF+0x540>
  802bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf6:	8b 00                	mov    (%eax),%eax
  802bf8:	a3 48 41 80 00       	mov    %eax,0x804148
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c10:	a1 54 41 80 00       	mov    0x804154,%eax
  802c15:	48                   	dec    %eax
  802c16:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1e:	8b 40 08             	mov    0x8(%eax),%eax
  802c21:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 50 08             	mov    0x8(%eax),%edx
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	01 c2                	add    %eax,%edx
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3d:	2b 45 08             	sub    0x8(%ebp),%eax
  802c40:	89 c2                	mov    %eax,%edx
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4b:	eb 3b                	jmp    802c88 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c4d:	a1 40 41 80 00       	mov    0x804140,%eax
  802c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c59:	74 07                	je     802c62 <alloc_block_NF+0x5a5>
  802c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5e:	8b 00                	mov    (%eax),%eax
  802c60:	eb 05                	jmp    802c67 <alloc_block_NF+0x5aa>
  802c62:	b8 00 00 00 00       	mov    $0x0,%eax
  802c67:	a3 40 41 80 00       	mov    %eax,0x804140
  802c6c:	a1 40 41 80 00       	mov    0x804140,%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	0f 85 2e fe ff ff    	jne    802aa7 <alloc_block_NF+0x3ea>
  802c79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7d:	0f 85 24 fe ff ff    	jne    802aa7 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c88:	c9                   	leave  
  802c89:	c3                   	ret    

00802c8a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c8a:	55                   	push   %ebp
  802c8b:	89 e5                	mov    %esp,%ebp
  802c8d:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802c90:	a1 38 41 80 00       	mov    0x804138,%eax
  802c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c98:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c9d:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802ca0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 14                	je     802cbd <insert_sorted_with_merge_freeList+0x33>
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	8b 50 08             	mov    0x8(%eax),%edx
  802caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb2:	8b 40 08             	mov    0x8(%eax),%eax
  802cb5:	39 c2                	cmp    %eax,%edx
  802cb7:	0f 87 9b 01 00 00    	ja     802e58 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cc1:	75 17                	jne    802cda <insert_sorted_with_merge_freeList+0x50>
  802cc3:	83 ec 04             	sub    $0x4,%esp
  802cc6:	68 78 3e 80 00       	push   $0x803e78
  802ccb:	68 38 01 00 00       	push   $0x138
  802cd0:	68 9b 3e 80 00       	push   $0x803e9b
  802cd5:	e8 97 d5 ff ff       	call   800271 <_panic>
  802cda:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	89 10                	mov    %edx,(%eax)
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	85 c0                	test   %eax,%eax
  802cec:	74 0d                	je     802cfb <insert_sorted_with_merge_freeList+0x71>
  802cee:	a1 38 41 80 00       	mov    0x804138,%eax
  802cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf6:	89 50 04             	mov    %edx,0x4(%eax)
  802cf9:	eb 08                	jmp    802d03 <insert_sorted_with_merge_freeList+0x79>
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	a3 38 41 80 00       	mov    %eax,0x804138
  802d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d15:	a1 44 41 80 00       	mov    0x804144,%eax
  802d1a:	40                   	inc    %eax
  802d1b:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d24:	0f 84 a8 06 00 00    	je     8033d2 <insert_sorted_with_merge_freeList+0x748>
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	8b 50 08             	mov    0x8(%eax),%edx
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 40 0c             	mov    0xc(%eax),%eax
  802d36:	01 c2                	add    %eax,%edx
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	8b 40 08             	mov    0x8(%eax),%eax
  802d3e:	39 c2                	cmp    %eax,%edx
  802d40:	0f 85 8c 06 00 00    	jne    8033d2 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	8b 50 0c             	mov    0xc(%eax),%edx
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d52:	01 c2                	add    %eax,%edx
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5e:	75 17                	jne    802d77 <insert_sorted_with_merge_freeList+0xed>
  802d60:	83 ec 04             	sub    $0x4,%esp
  802d63:	68 44 3f 80 00       	push   $0x803f44
  802d68:	68 3c 01 00 00       	push   $0x13c
  802d6d:	68 9b 3e 80 00       	push   $0x803e9b
  802d72:	e8 fa d4 ff ff       	call   800271 <_panic>
  802d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7a:	8b 00                	mov    (%eax),%eax
  802d7c:	85 c0                	test   %eax,%eax
  802d7e:	74 10                	je     802d90 <insert_sorted_with_merge_freeList+0x106>
  802d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d88:	8b 52 04             	mov    0x4(%edx),%edx
  802d8b:	89 50 04             	mov    %edx,0x4(%eax)
  802d8e:	eb 0b                	jmp    802d9b <insert_sorted_with_merge_freeList+0x111>
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9e:	8b 40 04             	mov    0x4(%eax),%eax
  802da1:	85 c0                	test   %eax,%eax
  802da3:	74 0f                	je     802db4 <insert_sorted_with_merge_freeList+0x12a>
  802da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dae:	8b 12                	mov    (%edx),%edx
  802db0:	89 10                	mov    %edx,(%eax)
  802db2:	eb 0a                	jmp    802dbe <insert_sorted_with_merge_freeList+0x134>
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	a3 38 41 80 00       	mov    %eax,0x804138
  802dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd1:	a1 44 41 80 00       	mov    0x804144,%eax
  802dd6:	48                   	dec    %eax
  802dd7:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802df0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df4:	75 17                	jne    802e0d <insert_sorted_with_merge_freeList+0x183>
  802df6:	83 ec 04             	sub    $0x4,%esp
  802df9:	68 78 3e 80 00       	push   $0x803e78
  802dfe:	68 3f 01 00 00       	push   $0x13f
  802e03:	68 9b 3e 80 00       	push   $0x803e9b
  802e08:	e8 64 d4 ff ff       	call   800271 <_panic>
  802e0d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e16:	89 10                	mov    %edx,(%eax)
  802e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 0d                	je     802e2e <insert_sorted_with_merge_freeList+0x1a4>
  802e21:	a1 48 41 80 00       	mov    0x804148,%eax
  802e26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e29:	89 50 04             	mov    %edx,0x4(%eax)
  802e2c:	eb 08                	jmp    802e36 <insert_sorted_with_merge_freeList+0x1ac>
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	a3 48 41 80 00       	mov    %eax,0x804148
  802e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e48:	a1 54 41 80 00       	mov    0x804154,%eax
  802e4d:	40                   	inc    %eax
  802e4e:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e53:	e9 7a 05 00 00       	jmp    8033d2 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	8b 50 08             	mov    0x8(%eax),%edx
  802e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e61:	8b 40 08             	mov    0x8(%eax),%eax
  802e64:	39 c2                	cmp    %eax,%edx
  802e66:	0f 82 14 01 00 00    	jb     802f80 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e6f:	8b 50 08             	mov    0x8(%eax),%edx
  802e72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e75:	8b 40 0c             	mov    0xc(%eax),%eax
  802e78:	01 c2                	add    %eax,%edx
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	8b 40 08             	mov    0x8(%eax),%eax
  802e80:	39 c2                	cmp    %eax,%edx
  802e82:	0f 85 90 00 00 00    	jne    802f18 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	8b 40 0c             	mov    0xc(%eax),%eax
  802e94:	01 c2                	add    %eax,%edx
  802e96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e99:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb4:	75 17                	jne    802ecd <insert_sorted_with_merge_freeList+0x243>
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	68 78 3e 80 00       	push   $0x803e78
  802ebe:	68 49 01 00 00       	push   $0x149
  802ec3:	68 9b 3e 80 00       	push   $0x803e9b
  802ec8:	e8 a4 d3 ff ff       	call   800271 <_panic>
  802ecd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	89 10                	mov    %edx,(%eax)
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 00                	mov    (%eax),%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 0d                	je     802eee <insert_sorted_with_merge_freeList+0x264>
  802ee1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	eb 08                	jmp    802ef6 <insert_sorted_with_merge_freeList+0x26c>
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	a3 48 41 80 00       	mov    %eax,0x804148
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f08:	a1 54 41 80 00       	mov    0x804154,%eax
  802f0d:	40                   	inc    %eax
  802f0e:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f13:	e9 bb 04 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1c:	75 17                	jne    802f35 <insert_sorted_with_merge_freeList+0x2ab>
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	68 ec 3e 80 00       	push   $0x803eec
  802f26:	68 4c 01 00 00       	push   $0x14c
  802f2b:	68 9b 3e 80 00       	push   $0x803e9b
  802f30:	e8 3c d3 ff ff       	call   800271 <_panic>
  802f35:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	8b 40 04             	mov    0x4(%eax),%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 0c                	je     802f57 <insert_sorted_with_merge_freeList+0x2cd>
  802f4b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802f50:	8b 55 08             	mov    0x8(%ebp),%edx
  802f53:	89 10                	mov    %edx,(%eax)
  802f55:	eb 08                	jmp    802f5f <insert_sorted_with_merge_freeList+0x2d5>
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	a3 38 41 80 00       	mov    %eax,0x804138
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f70:	a1 44 41 80 00       	mov    0x804144,%eax
  802f75:	40                   	inc    %eax
  802f76:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f7b:	e9 53 04 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802f80:	a1 38 41 80 00       	mov    0x804138,%eax
  802f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f88:	e9 15 04 00 00       	jmp    8033a2 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 50 08             	mov    0x8(%eax),%edx
  802f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9e:	8b 40 08             	mov    0x8(%eax),%eax
  802fa1:	39 c2                	cmp    %eax,%edx
  802fa3:	0f 86 f1 03 00 00    	jbe    80339a <insert_sorted_with_merge_freeList+0x710>
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 50 08             	mov    0x8(%eax),%edx
  802faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb2:	8b 40 08             	mov    0x8(%eax),%eax
  802fb5:	39 c2                	cmp    %eax,%edx
  802fb7:	0f 83 dd 03 00 00    	jae    80339a <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc0:	8b 50 08             	mov    0x8(%eax),%edx
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc9:	01 c2                	add    %eax,%edx
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	8b 40 08             	mov    0x8(%eax),%eax
  802fd1:	39 c2                	cmp    %eax,%edx
  802fd3:	0f 85 b9 01 00 00    	jne    803192 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	8b 50 08             	mov    0x8(%eax),%edx
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe5:	01 c2                	add    %eax,%edx
  802fe7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fea:	8b 40 08             	mov    0x8(%eax),%eax
  802fed:	39 c2                	cmp    %eax,%edx
  802fef:	0f 85 0d 01 00 00    	jne    803102 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	8b 50 0c             	mov    0xc(%eax),%edx
  802ffb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  803001:	01 c2                	add    %eax,%edx
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803009:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80300d:	75 17                	jne    803026 <insert_sorted_with_merge_freeList+0x39c>
  80300f:	83 ec 04             	sub    $0x4,%esp
  803012:	68 44 3f 80 00       	push   $0x803f44
  803017:	68 5c 01 00 00       	push   $0x15c
  80301c:	68 9b 3e 80 00       	push   $0x803e9b
  803021:	e8 4b d2 ff ff       	call   800271 <_panic>
  803026:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	85 c0                	test   %eax,%eax
  80302d:	74 10                	je     80303f <insert_sorted_with_merge_freeList+0x3b5>
  80302f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803037:	8b 52 04             	mov    0x4(%edx),%edx
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	eb 0b                	jmp    80304a <insert_sorted_with_merge_freeList+0x3c0>
  80303f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80304a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	85 c0                	test   %eax,%eax
  803052:	74 0f                	je     803063 <insert_sorted_with_merge_freeList+0x3d9>
  803054:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803057:	8b 40 04             	mov    0x4(%eax),%eax
  80305a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305d:	8b 12                	mov    (%edx),%edx
  80305f:	89 10                	mov    %edx,(%eax)
  803061:	eb 0a                	jmp    80306d <insert_sorted_with_merge_freeList+0x3e3>
  803063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803066:	8b 00                	mov    (%eax),%eax
  803068:	a3 38 41 80 00       	mov    %eax,0x804138
  80306d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803070:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803076:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803079:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803080:	a1 44 41 80 00       	mov    0x804144,%eax
  803085:	48                   	dec    %eax
  803086:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  80308b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803095:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803098:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80309f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030a3:	75 17                	jne    8030bc <insert_sorted_with_merge_freeList+0x432>
  8030a5:	83 ec 04             	sub    $0x4,%esp
  8030a8:	68 78 3e 80 00       	push   $0x803e78
  8030ad:	68 5f 01 00 00       	push   $0x15f
  8030b2:	68 9b 3e 80 00       	push   $0x803e9b
  8030b7:	e8 b5 d1 ff ff       	call   800271 <_panic>
  8030bc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c5:	89 10                	mov    %edx,(%eax)
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	8b 00                	mov    (%eax),%eax
  8030cc:	85 c0                	test   %eax,%eax
  8030ce:	74 0d                	je     8030dd <insert_sorted_with_merge_freeList+0x453>
  8030d0:	a1 48 41 80 00       	mov    0x804148,%eax
  8030d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030d8:	89 50 04             	mov    %edx,0x4(%eax)
  8030db:	eb 08                	jmp    8030e5 <insert_sorted_with_merge_freeList+0x45b>
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e8:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8030fc:	40                   	inc    %eax
  8030fd:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	8b 50 0c             	mov    0xc(%eax),%edx
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	8b 40 0c             	mov    0xc(%eax),%eax
  80310e:	01 c2                	add    %eax,%edx
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80312a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312e:	75 17                	jne    803147 <insert_sorted_with_merge_freeList+0x4bd>
  803130:	83 ec 04             	sub    $0x4,%esp
  803133:	68 78 3e 80 00       	push   $0x803e78
  803138:	68 64 01 00 00       	push   $0x164
  80313d:	68 9b 3e 80 00       	push   $0x803e9b
  803142:	e8 2a d1 ff ff       	call   800271 <_panic>
  803147:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	89 10                	mov    %edx,(%eax)
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	85 c0                	test   %eax,%eax
  803159:	74 0d                	je     803168 <insert_sorted_with_merge_freeList+0x4de>
  80315b:	a1 48 41 80 00       	mov    0x804148,%eax
  803160:	8b 55 08             	mov    0x8(%ebp),%edx
  803163:	89 50 04             	mov    %edx,0x4(%eax)
  803166:	eb 08                	jmp    803170 <insert_sorted_with_merge_freeList+0x4e6>
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	a3 48 41 80 00       	mov    %eax,0x804148
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803182:	a1 54 41 80 00       	mov    0x804154,%eax
  803187:	40                   	inc    %eax
  803188:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80318d:	e9 41 02 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 50 08             	mov    0x8(%eax),%edx
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	8b 40 0c             	mov    0xc(%eax),%eax
  80319e:	01 c2                	add    %eax,%edx
  8031a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a3:	8b 40 08             	mov    0x8(%eax),%eax
  8031a6:	39 c2                	cmp    %eax,%edx
  8031a8:	0f 85 7c 01 00 00    	jne    80332a <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031b2:	74 06                	je     8031ba <insert_sorted_with_merge_freeList+0x530>
  8031b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b8:	75 17                	jne    8031d1 <insert_sorted_with_merge_freeList+0x547>
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	68 b4 3e 80 00       	push   $0x803eb4
  8031c2:	68 69 01 00 00       	push   $0x169
  8031c7:	68 9b 3e 80 00       	push   $0x803e9b
  8031cc:	e8 a0 d0 ff ff       	call   800271 <_panic>
  8031d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d4:	8b 50 04             	mov    0x4(%eax),%edx
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	89 50 04             	mov    %edx,0x4(%eax)
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e3:	89 10                	mov    %edx,(%eax)
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	8b 40 04             	mov    0x4(%eax),%eax
  8031eb:	85 c0                	test   %eax,%eax
  8031ed:	74 0d                	je     8031fc <insert_sorted_with_merge_freeList+0x572>
  8031ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f2:	8b 40 04             	mov    0x4(%eax),%eax
  8031f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8031f8:	89 10                	mov    %edx,(%eax)
  8031fa:	eb 08                	jmp    803204 <insert_sorted_with_merge_freeList+0x57a>
  8031fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ff:	a3 38 41 80 00       	mov    %eax,0x804138
  803204:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803207:	8b 55 08             	mov    0x8(%ebp),%edx
  80320a:	89 50 04             	mov    %edx,0x4(%eax)
  80320d:	a1 44 41 80 00       	mov    0x804144,%eax
  803212:	40                   	inc    %eax
  803213:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	8b 50 0c             	mov    0xc(%eax),%edx
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	8b 40 0c             	mov    0xc(%eax),%eax
  803224:	01 c2                	add    %eax,%edx
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80322c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803230:	75 17                	jne    803249 <insert_sorted_with_merge_freeList+0x5bf>
  803232:	83 ec 04             	sub    $0x4,%esp
  803235:	68 44 3f 80 00       	push   $0x803f44
  80323a:	68 6b 01 00 00       	push   $0x16b
  80323f:	68 9b 3e 80 00       	push   $0x803e9b
  803244:	e8 28 d0 ff ff       	call   800271 <_panic>
  803249:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	85 c0                	test   %eax,%eax
  803250:	74 10                	je     803262 <insert_sorted_with_merge_freeList+0x5d8>
  803252:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80325a:	8b 52 04             	mov    0x4(%edx),%edx
  80325d:	89 50 04             	mov    %edx,0x4(%eax)
  803260:	eb 0b                	jmp    80326d <insert_sorted_with_merge_freeList+0x5e3>
  803262:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803265:	8b 40 04             	mov    0x4(%eax),%eax
  803268:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80326d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803270:	8b 40 04             	mov    0x4(%eax),%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	74 0f                	je     803286 <insert_sorted_with_merge_freeList+0x5fc>
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	8b 40 04             	mov    0x4(%eax),%eax
  80327d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803280:	8b 12                	mov    (%edx),%edx
  803282:	89 10                	mov    %edx,(%eax)
  803284:	eb 0a                	jmp    803290 <insert_sorted_with_merge_freeList+0x606>
  803286:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803289:	8b 00                	mov    (%eax),%eax
  80328b:	a3 38 41 80 00       	mov    %eax,0x804138
  803290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8032a8:	48                   	dec    %eax
  8032a9:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8032ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8032c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032c6:	75 17                	jne    8032df <insert_sorted_with_merge_freeList+0x655>
  8032c8:	83 ec 04             	sub    $0x4,%esp
  8032cb:	68 78 3e 80 00       	push   $0x803e78
  8032d0:	68 6e 01 00 00       	push   $0x16e
  8032d5:	68 9b 3e 80 00       	push   $0x803e9b
  8032da:	e8 92 cf ff ff       	call   800271 <_panic>
  8032df:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8032e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e8:	89 10                	mov    %edx,(%eax)
  8032ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ed:	8b 00                	mov    (%eax),%eax
  8032ef:	85 c0                	test   %eax,%eax
  8032f1:	74 0d                	je     803300 <insert_sorted_with_merge_freeList+0x676>
  8032f3:	a1 48 41 80 00       	mov    0x804148,%eax
  8032f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032fb:	89 50 04             	mov    %edx,0x4(%eax)
  8032fe:	eb 08                	jmp    803308 <insert_sorted_with_merge_freeList+0x67e>
  803300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803303:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330b:	a3 48 41 80 00       	mov    %eax,0x804148
  803310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803313:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331a:	a1 54 41 80 00       	mov    0x804154,%eax
  80331f:	40                   	inc    %eax
  803320:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803325:	e9 a9 00 00 00       	jmp    8033d3 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80332a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80332e:	74 06                	je     803336 <insert_sorted_with_merge_freeList+0x6ac>
  803330:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803334:	75 17                	jne    80334d <insert_sorted_with_merge_freeList+0x6c3>
  803336:	83 ec 04             	sub    $0x4,%esp
  803339:	68 10 3f 80 00       	push   $0x803f10
  80333e:	68 73 01 00 00       	push   $0x173
  803343:	68 9b 3e 80 00       	push   $0x803e9b
  803348:	e8 24 cf ff ff       	call   800271 <_panic>
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 10                	mov    (%eax),%edx
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	89 10                	mov    %edx,(%eax)
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	85 c0                	test   %eax,%eax
  80335e:	74 0b                	je     80336b <insert_sorted_with_merge_freeList+0x6e1>
  803360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803363:	8b 00                	mov    (%eax),%eax
  803365:	8b 55 08             	mov    0x8(%ebp),%edx
  803368:	89 50 04             	mov    %edx,0x4(%eax)
  80336b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336e:	8b 55 08             	mov    0x8(%ebp),%edx
  803371:	89 10                	mov    %edx,(%eax)
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803379:	89 50 04             	mov    %edx,0x4(%eax)
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	8b 00                	mov    (%eax),%eax
  803381:	85 c0                	test   %eax,%eax
  803383:	75 08                	jne    80338d <insert_sorted_with_merge_freeList+0x703>
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80338d:	a1 44 41 80 00       	mov    0x804144,%eax
  803392:	40                   	inc    %eax
  803393:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803398:	eb 39                	jmp    8033d3 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80339a:	a1 40 41 80 00       	mov    0x804140,%eax
  80339f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a6:	74 07                	je     8033af <insert_sorted_with_merge_freeList+0x725>
  8033a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	eb 05                	jmp    8033b4 <insert_sorted_with_merge_freeList+0x72a>
  8033af:	b8 00 00 00 00       	mov    $0x0,%eax
  8033b4:	a3 40 41 80 00       	mov    %eax,0x804140
  8033b9:	a1 40 41 80 00       	mov    0x804140,%eax
  8033be:	85 c0                	test   %eax,%eax
  8033c0:	0f 85 c7 fb ff ff    	jne    802f8d <insert_sorted_with_merge_freeList+0x303>
  8033c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033ca:	0f 85 bd fb ff ff    	jne    802f8d <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033d0:	eb 01                	jmp    8033d3 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8033d2:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8033d3:	90                   	nop
  8033d4:	c9                   	leave  
  8033d5:	c3                   	ret    
  8033d6:	66 90                	xchg   %ax,%ax

008033d8 <__udivdi3>:
  8033d8:	55                   	push   %ebp
  8033d9:	57                   	push   %edi
  8033da:	56                   	push   %esi
  8033db:	53                   	push   %ebx
  8033dc:	83 ec 1c             	sub    $0x1c,%esp
  8033df:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033e3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033ef:	89 ca                	mov    %ecx,%edx
  8033f1:	89 f8                	mov    %edi,%eax
  8033f3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033f7:	85 f6                	test   %esi,%esi
  8033f9:	75 2d                	jne    803428 <__udivdi3+0x50>
  8033fb:	39 cf                	cmp    %ecx,%edi
  8033fd:	77 65                	ja     803464 <__udivdi3+0x8c>
  8033ff:	89 fd                	mov    %edi,%ebp
  803401:	85 ff                	test   %edi,%edi
  803403:	75 0b                	jne    803410 <__udivdi3+0x38>
  803405:	b8 01 00 00 00       	mov    $0x1,%eax
  80340a:	31 d2                	xor    %edx,%edx
  80340c:	f7 f7                	div    %edi
  80340e:	89 c5                	mov    %eax,%ebp
  803410:	31 d2                	xor    %edx,%edx
  803412:	89 c8                	mov    %ecx,%eax
  803414:	f7 f5                	div    %ebp
  803416:	89 c1                	mov    %eax,%ecx
  803418:	89 d8                	mov    %ebx,%eax
  80341a:	f7 f5                	div    %ebp
  80341c:	89 cf                	mov    %ecx,%edi
  80341e:	89 fa                	mov    %edi,%edx
  803420:	83 c4 1c             	add    $0x1c,%esp
  803423:	5b                   	pop    %ebx
  803424:	5e                   	pop    %esi
  803425:	5f                   	pop    %edi
  803426:	5d                   	pop    %ebp
  803427:	c3                   	ret    
  803428:	39 ce                	cmp    %ecx,%esi
  80342a:	77 28                	ja     803454 <__udivdi3+0x7c>
  80342c:	0f bd fe             	bsr    %esi,%edi
  80342f:	83 f7 1f             	xor    $0x1f,%edi
  803432:	75 40                	jne    803474 <__udivdi3+0x9c>
  803434:	39 ce                	cmp    %ecx,%esi
  803436:	72 0a                	jb     803442 <__udivdi3+0x6a>
  803438:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80343c:	0f 87 9e 00 00 00    	ja     8034e0 <__udivdi3+0x108>
  803442:	b8 01 00 00 00       	mov    $0x1,%eax
  803447:	89 fa                	mov    %edi,%edx
  803449:	83 c4 1c             	add    $0x1c,%esp
  80344c:	5b                   	pop    %ebx
  80344d:	5e                   	pop    %esi
  80344e:	5f                   	pop    %edi
  80344f:	5d                   	pop    %ebp
  803450:	c3                   	ret    
  803451:	8d 76 00             	lea    0x0(%esi),%esi
  803454:	31 ff                	xor    %edi,%edi
  803456:	31 c0                	xor    %eax,%eax
  803458:	89 fa                	mov    %edi,%edx
  80345a:	83 c4 1c             	add    $0x1c,%esp
  80345d:	5b                   	pop    %ebx
  80345e:	5e                   	pop    %esi
  80345f:	5f                   	pop    %edi
  803460:	5d                   	pop    %ebp
  803461:	c3                   	ret    
  803462:	66 90                	xchg   %ax,%ax
  803464:	89 d8                	mov    %ebx,%eax
  803466:	f7 f7                	div    %edi
  803468:	31 ff                	xor    %edi,%edi
  80346a:	89 fa                	mov    %edi,%edx
  80346c:	83 c4 1c             	add    $0x1c,%esp
  80346f:	5b                   	pop    %ebx
  803470:	5e                   	pop    %esi
  803471:	5f                   	pop    %edi
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    
  803474:	bd 20 00 00 00       	mov    $0x20,%ebp
  803479:	89 eb                	mov    %ebp,%ebx
  80347b:	29 fb                	sub    %edi,%ebx
  80347d:	89 f9                	mov    %edi,%ecx
  80347f:	d3 e6                	shl    %cl,%esi
  803481:	89 c5                	mov    %eax,%ebp
  803483:	88 d9                	mov    %bl,%cl
  803485:	d3 ed                	shr    %cl,%ebp
  803487:	89 e9                	mov    %ebp,%ecx
  803489:	09 f1                	or     %esi,%ecx
  80348b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80348f:	89 f9                	mov    %edi,%ecx
  803491:	d3 e0                	shl    %cl,%eax
  803493:	89 c5                	mov    %eax,%ebp
  803495:	89 d6                	mov    %edx,%esi
  803497:	88 d9                	mov    %bl,%cl
  803499:	d3 ee                	shr    %cl,%esi
  80349b:	89 f9                	mov    %edi,%ecx
  80349d:	d3 e2                	shl    %cl,%edx
  80349f:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a3:	88 d9                	mov    %bl,%cl
  8034a5:	d3 e8                	shr    %cl,%eax
  8034a7:	09 c2                	or     %eax,%edx
  8034a9:	89 d0                	mov    %edx,%eax
  8034ab:	89 f2                	mov    %esi,%edx
  8034ad:	f7 74 24 0c          	divl   0xc(%esp)
  8034b1:	89 d6                	mov    %edx,%esi
  8034b3:	89 c3                	mov    %eax,%ebx
  8034b5:	f7 e5                	mul    %ebp
  8034b7:	39 d6                	cmp    %edx,%esi
  8034b9:	72 19                	jb     8034d4 <__udivdi3+0xfc>
  8034bb:	74 0b                	je     8034c8 <__udivdi3+0xf0>
  8034bd:	89 d8                	mov    %ebx,%eax
  8034bf:	31 ff                	xor    %edi,%edi
  8034c1:	e9 58 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034c6:	66 90                	xchg   %ax,%ax
  8034c8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034cc:	89 f9                	mov    %edi,%ecx
  8034ce:	d3 e2                	shl    %cl,%edx
  8034d0:	39 c2                	cmp    %eax,%edx
  8034d2:	73 e9                	jae    8034bd <__udivdi3+0xe5>
  8034d4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034d7:	31 ff                	xor    %edi,%edi
  8034d9:	e9 40 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034de:	66 90                	xchg   %ax,%ax
  8034e0:	31 c0                	xor    %eax,%eax
  8034e2:	e9 37 ff ff ff       	jmp    80341e <__udivdi3+0x46>
  8034e7:	90                   	nop

008034e8 <__umoddi3>:
  8034e8:	55                   	push   %ebp
  8034e9:	57                   	push   %edi
  8034ea:	56                   	push   %esi
  8034eb:	53                   	push   %ebx
  8034ec:	83 ec 1c             	sub    $0x1c,%esp
  8034ef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034f3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034fb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803503:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803507:	89 f3                	mov    %esi,%ebx
  803509:	89 fa                	mov    %edi,%edx
  80350b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80350f:	89 34 24             	mov    %esi,(%esp)
  803512:	85 c0                	test   %eax,%eax
  803514:	75 1a                	jne    803530 <__umoddi3+0x48>
  803516:	39 f7                	cmp    %esi,%edi
  803518:	0f 86 a2 00 00 00    	jbe    8035c0 <__umoddi3+0xd8>
  80351e:	89 c8                	mov    %ecx,%eax
  803520:	89 f2                	mov    %esi,%edx
  803522:	f7 f7                	div    %edi
  803524:	89 d0                	mov    %edx,%eax
  803526:	31 d2                	xor    %edx,%edx
  803528:	83 c4 1c             	add    $0x1c,%esp
  80352b:	5b                   	pop    %ebx
  80352c:	5e                   	pop    %esi
  80352d:	5f                   	pop    %edi
  80352e:	5d                   	pop    %ebp
  80352f:	c3                   	ret    
  803530:	39 f0                	cmp    %esi,%eax
  803532:	0f 87 ac 00 00 00    	ja     8035e4 <__umoddi3+0xfc>
  803538:	0f bd e8             	bsr    %eax,%ebp
  80353b:	83 f5 1f             	xor    $0x1f,%ebp
  80353e:	0f 84 ac 00 00 00    	je     8035f0 <__umoddi3+0x108>
  803544:	bf 20 00 00 00       	mov    $0x20,%edi
  803549:	29 ef                	sub    %ebp,%edi
  80354b:	89 fe                	mov    %edi,%esi
  80354d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803551:	89 e9                	mov    %ebp,%ecx
  803553:	d3 e0                	shl    %cl,%eax
  803555:	89 d7                	mov    %edx,%edi
  803557:	89 f1                	mov    %esi,%ecx
  803559:	d3 ef                	shr    %cl,%edi
  80355b:	09 c7                	or     %eax,%edi
  80355d:	89 e9                	mov    %ebp,%ecx
  80355f:	d3 e2                	shl    %cl,%edx
  803561:	89 14 24             	mov    %edx,(%esp)
  803564:	89 d8                	mov    %ebx,%eax
  803566:	d3 e0                	shl    %cl,%eax
  803568:	89 c2                	mov    %eax,%edx
  80356a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80356e:	d3 e0                	shl    %cl,%eax
  803570:	89 44 24 04          	mov    %eax,0x4(%esp)
  803574:	8b 44 24 08          	mov    0x8(%esp),%eax
  803578:	89 f1                	mov    %esi,%ecx
  80357a:	d3 e8                	shr    %cl,%eax
  80357c:	09 d0                	or     %edx,%eax
  80357e:	d3 eb                	shr    %cl,%ebx
  803580:	89 da                	mov    %ebx,%edx
  803582:	f7 f7                	div    %edi
  803584:	89 d3                	mov    %edx,%ebx
  803586:	f7 24 24             	mull   (%esp)
  803589:	89 c6                	mov    %eax,%esi
  80358b:	89 d1                	mov    %edx,%ecx
  80358d:	39 d3                	cmp    %edx,%ebx
  80358f:	0f 82 87 00 00 00    	jb     80361c <__umoddi3+0x134>
  803595:	0f 84 91 00 00 00    	je     80362c <__umoddi3+0x144>
  80359b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80359f:	29 f2                	sub    %esi,%edx
  8035a1:	19 cb                	sbb    %ecx,%ebx
  8035a3:	89 d8                	mov    %ebx,%eax
  8035a5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035a9:	d3 e0                	shl    %cl,%eax
  8035ab:	89 e9                	mov    %ebp,%ecx
  8035ad:	d3 ea                	shr    %cl,%edx
  8035af:	09 d0                	or     %edx,%eax
  8035b1:	89 e9                	mov    %ebp,%ecx
  8035b3:	d3 eb                	shr    %cl,%ebx
  8035b5:	89 da                	mov    %ebx,%edx
  8035b7:	83 c4 1c             	add    $0x1c,%esp
  8035ba:	5b                   	pop    %ebx
  8035bb:	5e                   	pop    %esi
  8035bc:	5f                   	pop    %edi
  8035bd:	5d                   	pop    %ebp
  8035be:	c3                   	ret    
  8035bf:	90                   	nop
  8035c0:	89 fd                	mov    %edi,%ebp
  8035c2:	85 ff                	test   %edi,%edi
  8035c4:	75 0b                	jne    8035d1 <__umoddi3+0xe9>
  8035c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035cb:	31 d2                	xor    %edx,%edx
  8035cd:	f7 f7                	div    %edi
  8035cf:	89 c5                	mov    %eax,%ebp
  8035d1:	89 f0                	mov    %esi,%eax
  8035d3:	31 d2                	xor    %edx,%edx
  8035d5:	f7 f5                	div    %ebp
  8035d7:	89 c8                	mov    %ecx,%eax
  8035d9:	f7 f5                	div    %ebp
  8035db:	89 d0                	mov    %edx,%eax
  8035dd:	e9 44 ff ff ff       	jmp    803526 <__umoddi3+0x3e>
  8035e2:	66 90                	xchg   %ax,%ax
  8035e4:	89 c8                	mov    %ecx,%eax
  8035e6:	89 f2                	mov    %esi,%edx
  8035e8:	83 c4 1c             	add    $0x1c,%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	5f                   	pop    %edi
  8035ee:	5d                   	pop    %ebp
  8035ef:	c3                   	ret    
  8035f0:	3b 04 24             	cmp    (%esp),%eax
  8035f3:	72 06                	jb     8035fb <__umoddi3+0x113>
  8035f5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035f9:	77 0f                	ja     80360a <__umoddi3+0x122>
  8035fb:	89 f2                	mov    %esi,%edx
  8035fd:	29 f9                	sub    %edi,%ecx
  8035ff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803603:	89 14 24             	mov    %edx,(%esp)
  803606:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80360a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80360e:	8b 14 24             	mov    (%esp),%edx
  803611:	83 c4 1c             	add    $0x1c,%esp
  803614:	5b                   	pop    %ebx
  803615:	5e                   	pop    %esi
  803616:	5f                   	pop    %edi
  803617:	5d                   	pop    %ebp
  803618:	c3                   	ret    
  803619:	8d 76 00             	lea    0x0(%esi),%esi
  80361c:	2b 04 24             	sub    (%esp),%eax
  80361f:	19 fa                	sbb    %edi,%edx
  803621:	89 d1                	mov    %edx,%ecx
  803623:	89 c6                	mov    %eax,%esi
  803625:	e9 71 ff ff ff       	jmp    80359b <__umoddi3+0xb3>
  80362a:	66 90                	xchg   %ax,%ax
  80362c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803630:	72 ea                	jb     80361c <__umoddi3+0x134>
  803632:	89 d9                	mov    %ebx,%ecx
  803634:	e9 62 ff ff ff       	jmp    80359b <__umoddi3+0xb3>
