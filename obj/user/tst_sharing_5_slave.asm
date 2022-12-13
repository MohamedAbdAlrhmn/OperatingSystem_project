
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
  80008c:	68 c0 35 80 00       	push   $0x8035c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 35 80 00       	push   $0x8035dc
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
  8000aa:	e8 cc 19 00 00       	call   801a7b <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 f7 35 80 00       	push   $0x8035f7
  8000b7:	50                   	push   %eax
  8000b8:	e8 21 15 00 00       	call   8015de <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 ba 16 00 00       	call   801782 <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 fc 35 80 00       	push   $0x8035fc
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 3c 15 00 00       	call   801622 <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 20 36 80 00       	push   $0x803620
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 84 16 00 00       	call   801782 <sys_calculate_free_frames>
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
  80011c:	68 38 36 80 00       	push   $0x803638
  800121:	6a 24                	push   $0x24
  800123:	68 dc 35 80 00       	push   $0x8035dc
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 6e 1a 00 00       	call   801ba0 <inctst>

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
  80013b:	e8 22 19 00 00       	call   801a62 <sys_getenvindex>
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
  8001a6:	e8 c4 16 00 00       	call   80186f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 dc 36 80 00       	push   $0x8036dc
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
  8001d6:	68 04 37 80 00       	push   $0x803704
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
  800207:	68 2c 37 80 00       	push   $0x80372c
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 84 37 80 00       	push   $0x803784
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 dc 36 80 00       	push   $0x8036dc
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 44 16 00 00       	call   801889 <sys_enable_interrupt>

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
  800258:	e8 d1 17 00 00       	call   801a2e <sys_destroy_env>
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
  800269:	e8 26 18 00 00       	call   801a94 <sys_exit_env>
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
  800292:	68 98 37 80 00       	push   $0x803798
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 9d 37 80 00       	push   $0x80379d
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
  8002cf:	68 b9 37 80 00       	push   $0x8037b9
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
  8002fb:	68 bc 37 80 00       	push   $0x8037bc
  800300:	6a 26                	push   $0x26
  800302:	68 08 38 80 00       	push   $0x803808
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
  8003cd:	68 14 38 80 00       	push   $0x803814
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 08 38 80 00       	push   $0x803808
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
  80043d:	68 68 38 80 00       	push   $0x803868
  800442:	6a 44                	push   $0x44
  800444:	68 08 38 80 00       	push   $0x803808
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
  800497:	e8 25 12 00 00       	call   8016c1 <sys_cputs>
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
  80050e:	e8 ae 11 00 00       	call   8016c1 <sys_cputs>
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
  800558:	e8 12 13 00 00       	call   80186f <sys_disable_interrupt>
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
  800578:	e8 0c 13 00 00       	call   801889 <sys_enable_interrupt>
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
  8005c2:	e8 7d 2d 00 00       	call   803344 <__udivdi3>
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
  800612:	e8 3d 2e 00 00       	call   803454 <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 d4 3a 80 00       	add    $0x803ad4,%eax
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
  80076d:	8b 04 85 f8 3a 80 00 	mov    0x803af8(,%eax,4),%eax
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
  80084e:	8b 34 9d 40 39 80 00 	mov    0x803940(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 e5 3a 80 00       	push   $0x803ae5
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
  800873:	68 ee 3a 80 00       	push   $0x803aee
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
  8008a0:	be f1 3a 80 00       	mov    $0x803af1,%esi
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
  8012c6:	68 50 3c 80 00       	push   $0x803c50
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
  801396:	e8 6a 04 00 00       	call   801805 <sys_allocate_chunk>
  80139b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139e:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	50                   	push   %eax
  8013a7:	e8 df 0a 00 00       	call   801e8b <initialize_MemBlocksList>
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
  8013d4:	68 75 3c 80 00       	push   $0x803c75
  8013d9:	6a 33                	push   $0x33
  8013db:	68 93 3c 80 00       	push   $0x803c93
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
  801453:	68 a0 3c 80 00       	push   $0x803ca0
  801458:	6a 34                	push   $0x34
  80145a:	68 93 3c 80 00       	push   $0x803c93
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
  8014eb:	e8 e3 06 00 00       	call   801bd3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 11                	je     801505 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8014fa:	e8 4e 0d 00 00       	call   80224d <alloc_block_FF>
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
  801511:	e8 aa 0a 00 00       	call   801fc0 <insert_sorted_allocList>
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
  801531:	68 c4 3c 80 00       	push   $0x803cc4
  801536:	6a 6f                	push   $0x6f
  801538:	68 93 3c 80 00       	push   $0x803c93
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
  801557:	75 07                	jne    801560 <smalloc+0x1e>
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb 7c                	jmp    8015dc <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801560:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801567:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156d:	01 d0                	add    %edx,%eax
  80156f:	48                   	dec    %eax
  801570:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801576:	ba 00 00 00 00       	mov    $0x0,%edx
  80157b:	f7 75 f0             	divl   -0x10(%ebp)
  80157e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801581:	29 d0                	sub    %edx,%eax
  801583:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801586:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80158d:	e8 41 06 00 00       	call   801bd3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801592:	85 c0                	test   %eax,%eax
  801594:	74 11                	je     8015a7 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  801596:	83 ec 0c             	sub    $0xc,%esp
  801599:	ff 75 e8             	pushl  -0x18(%ebp)
  80159c:	e8 ac 0c 00 00       	call   80224d <alloc_block_FF>
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8015a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015ab:	74 2a                	je     8015d7 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8015ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b0:	8b 40 08             	mov    0x8(%eax),%eax
  8015b3:	89 c2                	mov    %eax,%edx
  8015b5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8015b9:	52                   	push   %edx
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 0c             	pushl  0xc(%ebp)
  8015be:	ff 75 08             	pushl  0x8(%ebp)
  8015c1:	e8 92 03 00 00       	call   801958 <sys_createSharedObject>
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8015cc:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8015d0:	74 05                	je     8015d7 <smalloc+0x95>
			return (void*)virtual_address;
  8015d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d5:	eb 05                	jmp    8015dc <smalloc+0x9a>
	}
	return NULL;
  8015d7:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015e4:	e8 c6 fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015e9:	83 ec 04             	sub    $0x4,%esp
  8015ec:	68 e8 3c 80 00       	push   $0x803ce8
  8015f1:	68 b0 00 00 00       	push   $0xb0
  8015f6:	68 93 3c 80 00       	push   $0x803c93
  8015fb:	e8 71 ec ff ff       	call   800271 <_panic>

00801600 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801606:	e8 a4 fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80160b:	83 ec 04             	sub    $0x4,%esp
  80160e:	68 0c 3d 80 00       	push   $0x803d0c
  801613:	68 f4 00 00 00       	push   $0xf4
  801618:	68 93 3c 80 00       	push   $0x803c93
  80161d:	e8 4f ec ff ff       	call   800271 <_panic>

00801622 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801628:	83 ec 04             	sub    $0x4,%esp
  80162b:	68 34 3d 80 00       	push   $0x803d34
  801630:	68 08 01 00 00       	push   $0x108
  801635:	68 93 3c 80 00       	push   $0x803c93
  80163a:	e8 32 ec ff ff       	call   800271 <_panic>

0080163f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	68 58 3d 80 00       	push   $0x803d58
  80164d:	68 13 01 00 00       	push   $0x113
  801652:	68 93 3c 80 00       	push   $0x803c93
  801657:	e8 15 ec ff ff       	call   800271 <_panic>

0080165c <shrink>:

}
void shrink(uint32 newSize)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801662:	83 ec 04             	sub    $0x4,%esp
  801665:	68 58 3d 80 00       	push   $0x803d58
  80166a:	68 18 01 00 00       	push   $0x118
  80166f:	68 93 3c 80 00       	push   $0x803c93
  801674:	e8 f8 eb ff ff       	call   800271 <_panic>

00801679 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	68 58 3d 80 00       	push   $0x803d58
  801687:	68 1d 01 00 00       	push   $0x11d
  80168c:	68 93 3c 80 00       	push   $0x803c93
  801691:	e8 db eb ff ff       	call   800271 <_panic>

00801696 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	57                   	push   %edi
  80169a:	56                   	push   %esi
  80169b:	53                   	push   %ebx
  80169c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016b1:	cd 30                	int    $0x30
  8016b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	5b                   	pop    %ebx
  8016bd:	5e                   	pop    %esi
  8016be:	5f                   	pop    %edi
  8016bf:	5d                   	pop    %ebp
  8016c0:	c3                   	ret    

008016c1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016c1:	55                   	push   %ebp
  8016c2:	89 e5                	mov    %esp,%ebp
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	52                   	push   %edx
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	50                   	push   %eax
  8016dd:	6a 00                	push   $0x0
  8016df:	e8 b2 ff ff ff       	call   801696 <syscall>
  8016e4:	83 c4 18             	add    $0x18,%esp
}
  8016e7:	90                   	nop
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 01                	push   $0x1
  8016f9:	e8 98 ff ff ff       	call   801696 <syscall>
  8016fe:	83 c4 18             	add    $0x18,%esp
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801706:	8b 55 0c             	mov    0xc(%ebp),%edx
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	52                   	push   %edx
  801713:	50                   	push   %eax
  801714:	6a 05                	push   $0x5
  801716:	e8 7b ff ff ff       	call   801696 <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801725:	8b 75 18             	mov    0x18(%ebp),%esi
  801728:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80172b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801731:	8b 45 08             	mov    0x8(%ebp),%eax
  801734:	56                   	push   %esi
  801735:	53                   	push   %ebx
  801736:	51                   	push   %ecx
  801737:	52                   	push   %edx
  801738:	50                   	push   %eax
  801739:	6a 06                	push   $0x6
  80173b:	e8 56 ff ff ff       	call   801696 <syscall>
  801740:	83 c4 18             	add    $0x18,%esp
}
  801743:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801746:	5b                   	pop    %ebx
  801747:	5e                   	pop    %esi
  801748:	5d                   	pop    %ebp
  801749:	c3                   	ret    

0080174a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80174d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	6a 00                	push   $0x0
  801759:	52                   	push   %edx
  80175a:	50                   	push   %eax
  80175b:	6a 07                	push   $0x7
  80175d:	e8 34 ff ff ff       	call   801696 <syscall>
  801762:	83 c4 18             	add    $0x18,%esp
}
  801765:	c9                   	leave  
  801766:	c3                   	ret    

00801767 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	6a 08                	push   $0x8
  801778:	e8 19 ff ff ff       	call   801696 <syscall>
  80177d:	83 c4 18             	add    $0x18,%esp
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 09                	push   $0x9
  801791:	e8 00 ff ff ff       	call   801696 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 0a                	push   $0xa
  8017aa:	e8 e7 fe ff ff       	call   801696 <syscall>
  8017af:	83 c4 18             	add    $0x18,%esp
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 0b                	push   $0xb
  8017c3:	e8 ce fe ff ff       	call   801696 <syscall>
  8017c8:	83 c4 18             	add    $0x18,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	ff 75 08             	pushl  0x8(%ebp)
  8017dc:	6a 0f                	push   $0xf
  8017de:	e8 b3 fe ff ff       	call   801696 <syscall>
  8017e3:	83 c4 18             	add    $0x18,%esp
	return;
  8017e6:	90                   	nop
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	ff 75 0c             	pushl  0xc(%ebp)
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	6a 10                	push   $0x10
  8017fa:	e8 97 fe ff ff       	call   801696 <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801802:	90                   	nop
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	ff 75 10             	pushl  0x10(%ebp)
  80180f:	ff 75 0c             	pushl  0xc(%ebp)
  801812:	ff 75 08             	pushl  0x8(%ebp)
  801815:	6a 11                	push   $0x11
  801817:	e8 7a fe ff ff       	call   801696 <syscall>
  80181c:	83 c4 18             	add    $0x18,%esp
	return ;
  80181f:	90                   	nop
}
  801820:	c9                   	leave  
  801821:	c3                   	ret    

00801822 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	6a 00                	push   $0x0
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 0c                	push   $0xc
  801831:	e8 60 fe ff ff       	call   801696 <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	ff 75 08             	pushl  0x8(%ebp)
  801849:	6a 0d                	push   $0xd
  80184b:	e8 46 fe ff ff       	call   801696 <syscall>
  801850:	83 c4 18             	add    $0x18,%esp
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 0e                	push   $0xe
  801864:	e8 2d fe ff ff       	call   801696 <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	90                   	nop
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 13                	push   $0x13
  80187e:	e8 13 fe ff ff       	call   801696 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 14                	push   $0x14
  801898:	e8 f9 fd ff ff       	call   801696 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	90                   	nop
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018af:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	50                   	push   %eax
  8018bc:	6a 15                	push   $0x15
  8018be:	e8 d3 fd ff ff       	call   801696 <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
}
  8018c6:	90                   	nop
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 16                	push   $0x16
  8018d8:	e8 b9 fd ff ff       	call   801696 <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	90                   	nop
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 0c             	pushl  0xc(%ebp)
  8018f2:	50                   	push   %eax
  8018f3:	6a 17                	push   $0x17
  8018f5:	e8 9c fd ff ff       	call   801696 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801902:	8b 55 0c             	mov    0xc(%ebp),%edx
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	52                   	push   %edx
  80190f:	50                   	push   %eax
  801910:	6a 1a                	push   $0x1a
  801912:	e8 7f fd ff ff       	call   801696 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 18                	push   $0x18
  80192f:	e8 62 fd ff ff       	call   801696 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	90                   	nop
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80193d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	52                   	push   %edx
  80194a:	50                   	push   %eax
  80194b:	6a 19                	push   $0x19
  80194d:	e8 44 fd ff ff       	call   801696 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	90                   	nop
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	83 ec 04             	sub    $0x4,%esp
  80195e:	8b 45 10             	mov    0x10(%ebp),%eax
  801961:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801964:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801967:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	6a 00                	push   $0x0
  801970:	51                   	push   %ecx
  801971:	52                   	push   %edx
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	50                   	push   %eax
  801976:	6a 1b                	push   $0x1b
  801978:	e8 19 fd ff ff       	call   801696 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	52                   	push   %edx
  801992:	50                   	push   %eax
  801993:	6a 1c                	push   $0x1c
  801995:	e8 fc fc ff ff       	call   801696 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	51                   	push   %ecx
  8019b0:	52                   	push   %edx
  8019b1:	50                   	push   %eax
  8019b2:	6a 1d                	push   $0x1d
  8019b4:	e8 dd fc ff ff       	call   801696 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	52                   	push   %edx
  8019ce:	50                   	push   %eax
  8019cf:	6a 1e                	push   $0x1e
  8019d1:	e8 c0 fc ff ff       	call   801696 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 1f                	push   $0x1f
  8019ea:	e8 a7 fc ff ff       	call   801696 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	6a 00                	push   $0x0
  8019fc:	ff 75 14             	pushl  0x14(%ebp)
  8019ff:	ff 75 10             	pushl  0x10(%ebp)
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	50                   	push   %eax
  801a06:	6a 20                	push   $0x20
  801a08:	e8 89 fc ff ff       	call   801696 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	50                   	push   %eax
  801a21:	6a 21                	push   $0x21
  801a23:	e8 6e fc ff ff       	call   801696 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	50                   	push   %eax
  801a3d:	6a 22                	push   $0x22
  801a3f:	e8 52 fc ff ff       	call   801696 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 02                	push   $0x2
  801a58:	e8 39 fc ff ff       	call   801696 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 03                	push   $0x3
  801a71:	e8 20 fc ff ff       	call   801696 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 04                	push   $0x4
  801a8a:	e8 07 fc ff ff       	call   801696 <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_exit_env>:


void sys_exit_env(void)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 23                	push   $0x23
  801aa3:	e8 ee fb ff ff       	call   801696 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	90                   	nop
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
  801ab1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ab4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ab7:	8d 50 04             	lea    0x4(%eax),%edx
  801aba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	52                   	push   %edx
  801ac4:	50                   	push   %eax
  801ac5:	6a 24                	push   $0x24
  801ac7:	e8 ca fb ff ff       	call   801696 <syscall>
  801acc:	83 c4 18             	add    $0x18,%esp
	return result;
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ad5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ad8:	89 01                	mov    %eax,(%ecx)
  801ada:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	c9                   	leave  
  801ae1:	c2 04 00             	ret    $0x4

00801ae4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	ff 75 10             	pushl  0x10(%ebp)
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	6a 12                	push   $0x12
  801af6:	e8 9b fb ff ff       	call   801696 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
	return ;
  801afe:	90                   	nop
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 25                	push   $0x25
  801b10:	e8 81 fb ff ff       	call   801696 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 04             	sub    $0x4,%esp
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b26:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	50                   	push   %eax
  801b33:	6a 26                	push   $0x26
  801b35:	e8 5c fb ff ff       	call   801696 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3d:	90                   	nop
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <rsttst>:
void rsttst()
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 28                	push   $0x28
  801b4f:	e8 42 fb ff ff       	call   801696 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
	return ;
  801b57:	90                   	nop
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	83 ec 04             	sub    $0x4,%esp
  801b60:	8b 45 14             	mov    0x14(%ebp),%eax
  801b63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b66:	8b 55 18             	mov    0x18(%ebp),%edx
  801b69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b6d:	52                   	push   %edx
  801b6e:	50                   	push   %eax
  801b6f:	ff 75 10             	pushl  0x10(%ebp)
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	ff 75 08             	pushl  0x8(%ebp)
  801b78:	6a 27                	push   $0x27
  801b7a:	e8 17 fb ff ff       	call   801696 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b82:	90                   	nop
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <chktst>:
void chktst(uint32 n)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	6a 29                	push   $0x29
  801b95:	e8 fc fa ff ff       	call   801696 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b9d:	90                   	nop
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <inctst>:

void inctst()
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 2a                	push   $0x2a
  801baf:	e8 e2 fa ff ff       	call   801696 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb7:	90                   	nop
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <gettst>:
uint32 gettst()
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 2b                	push   $0x2b
  801bc9:	e8 c8 fa ff ff       	call   801696 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 2c                	push   $0x2c
  801be5:	e8 ac fa ff ff       	call   801696 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
  801bed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bf0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bf4:	75 07                	jne    801bfd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bfb:	eb 05                	jmp    801c02 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 2c                	push   $0x2c
  801c16:	e8 7b fa ff ff       	call   801696 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
  801c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c21:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c25:	75 07                	jne    801c2e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c27:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2c:	eb 05                	jmp    801c33 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 2c                	push   $0x2c
  801c47:	e8 4a fa ff ff       	call   801696 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
  801c4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c52:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c56:	75 07                	jne    801c5f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c58:	b8 01 00 00 00       	mov    $0x1,%eax
  801c5d:	eb 05                	jmp    801c64 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 2c                	push   $0x2c
  801c78:	e8 19 fa ff ff       	call   801696 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
  801c80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c83:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c87:	75 07                	jne    801c90 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c89:	b8 01 00 00 00       	mov    $0x1,%eax
  801c8e:	eb 05                	jmp    801c95 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 08             	pushl  0x8(%ebp)
  801ca5:	6a 2d                	push   $0x2d
  801ca7:	e8 ea f9 ff ff       	call   801696 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
	return ;
  801caf:	90                   	nop
}
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
  801cb5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	6a 00                	push   $0x0
  801cc4:	53                   	push   %ebx
  801cc5:	51                   	push   %ecx
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 2e                	push   $0x2e
  801cca:	e8 c7 f9 ff ff       	call   801696 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	52                   	push   %edx
  801ce7:	50                   	push   %eax
  801ce8:	6a 2f                	push   $0x2f
  801cea:	e8 a7 f9 ff ff       	call   801696 <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
  801cf7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cfa:	83 ec 0c             	sub    $0xc,%esp
  801cfd:	68 68 3d 80 00       	push   $0x803d68
  801d02:	e8 1e e8 ff ff       	call   800525 <cprintf>
  801d07:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d11:	83 ec 0c             	sub    $0xc,%esp
  801d14:	68 94 3d 80 00       	push   $0x803d94
  801d19:	e8 07 e8 ff ff       	call   800525 <cprintf>
  801d1e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d21:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d25:	a1 38 41 80 00       	mov    0x804138,%eax
  801d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d2d:	eb 56                	jmp    801d85 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d33:	74 1c                	je     801d51 <print_mem_block_lists+0x5d>
  801d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d38:	8b 50 08             	mov    0x8(%eax),%edx
  801d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d3e:	8b 48 08             	mov    0x8(%eax),%ecx
  801d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d44:	8b 40 0c             	mov    0xc(%eax),%eax
  801d47:	01 c8                	add    %ecx,%eax
  801d49:	39 c2                	cmp    %eax,%edx
  801d4b:	73 04                	jae    801d51 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d4d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	8b 50 08             	mov    0x8(%eax),%edx
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5d:	01 c2                	add    %eax,%edx
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	8b 40 08             	mov    0x8(%eax),%eax
  801d65:	83 ec 04             	sub    $0x4,%esp
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	68 a9 3d 80 00       	push   $0x803da9
  801d6f:	e8 b1 e7 ff ff       	call   800525 <cprintf>
  801d74:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d7d:	a1 40 41 80 00       	mov    0x804140,%eax
  801d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d89:	74 07                	je     801d92 <print_mem_block_lists+0x9e>
  801d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8e:	8b 00                	mov    (%eax),%eax
  801d90:	eb 05                	jmp    801d97 <print_mem_block_lists+0xa3>
  801d92:	b8 00 00 00 00       	mov    $0x0,%eax
  801d97:	a3 40 41 80 00       	mov    %eax,0x804140
  801d9c:	a1 40 41 80 00       	mov    0x804140,%eax
  801da1:	85 c0                	test   %eax,%eax
  801da3:	75 8a                	jne    801d2f <print_mem_block_lists+0x3b>
  801da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801da9:	75 84                	jne    801d2f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801dab:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801daf:	75 10                	jne    801dc1 <print_mem_block_lists+0xcd>
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	68 b8 3d 80 00       	push   $0x803db8
  801db9:	e8 67 e7 ff ff       	call   800525 <cprintf>
  801dbe:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801dc1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dc8:	83 ec 0c             	sub    $0xc,%esp
  801dcb:	68 dc 3d 80 00       	push   $0x803ddc
  801dd0:	e8 50 e7 ff ff       	call   800525 <cprintf>
  801dd5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801dd8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ddc:	a1 40 40 80 00       	mov    0x804040,%eax
  801de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801de4:	eb 56                	jmp    801e3c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801de6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dea:	74 1c                	je     801e08 <print_mem_block_lists+0x114>
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	8b 50 08             	mov    0x8(%eax),%edx
  801df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df5:	8b 48 08             	mov    0x8(%eax),%ecx
  801df8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfe:	01 c8                	add    %ecx,%eax
  801e00:	39 c2                	cmp    %eax,%edx
  801e02:	73 04                	jae    801e08 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e04:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0b:	8b 50 08             	mov    0x8(%eax),%edx
  801e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e11:	8b 40 0c             	mov    0xc(%eax),%eax
  801e14:	01 c2                	add    %eax,%edx
  801e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e19:	8b 40 08             	mov    0x8(%eax),%eax
  801e1c:	83 ec 04             	sub    $0x4,%esp
  801e1f:	52                   	push   %edx
  801e20:	50                   	push   %eax
  801e21:	68 a9 3d 80 00       	push   $0x803da9
  801e26:	e8 fa e6 ff ff       	call   800525 <cprintf>
  801e2b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e34:	a1 48 40 80 00       	mov    0x804048,%eax
  801e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e40:	74 07                	je     801e49 <print_mem_block_lists+0x155>
  801e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e45:	8b 00                	mov    (%eax),%eax
  801e47:	eb 05                	jmp    801e4e <print_mem_block_lists+0x15a>
  801e49:	b8 00 00 00 00       	mov    $0x0,%eax
  801e4e:	a3 48 40 80 00       	mov    %eax,0x804048
  801e53:	a1 48 40 80 00       	mov    0x804048,%eax
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	75 8a                	jne    801de6 <print_mem_block_lists+0xf2>
  801e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e60:	75 84                	jne    801de6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e62:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e66:	75 10                	jne    801e78 <print_mem_block_lists+0x184>
  801e68:	83 ec 0c             	sub    $0xc,%esp
  801e6b:	68 f4 3d 80 00       	push   $0x803df4
  801e70:	e8 b0 e6 ff ff       	call   800525 <cprintf>
  801e75:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	68 68 3d 80 00       	push   $0x803d68
  801e80:	e8 a0 e6 ff ff       	call   800525 <cprintf>
  801e85:	83 c4 10             	add    $0x10,%esp

}
  801e88:	90                   	nop
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e91:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e98:	00 00 00 
  801e9b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ea2:	00 00 00 
  801ea5:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801eac:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801eaf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eb6:	e9 9e 00 00 00       	jmp    801f59 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801ebb:	a1 50 40 80 00       	mov    0x804050,%eax
  801ec0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec3:	c1 e2 04             	shl    $0x4,%edx
  801ec6:	01 d0                	add    %edx,%eax
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	75 14                	jne    801ee0 <initialize_MemBlocksList+0x55>
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	68 1c 3e 80 00       	push   $0x803e1c
  801ed4:	6a 46                	push   $0x46
  801ed6:	68 3f 3e 80 00       	push   $0x803e3f
  801edb:	e8 91 e3 ff ff       	call   800271 <_panic>
  801ee0:	a1 50 40 80 00       	mov    0x804050,%eax
  801ee5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee8:	c1 e2 04             	shl    $0x4,%edx
  801eeb:	01 d0                	add    %edx,%eax
  801eed:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ef3:	89 10                	mov    %edx,(%eax)
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	74 18                	je     801f13 <initialize_MemBlocksList+0x88>
  801efb:	a1 48 41 80 00       	mov    0x804148,%eax
  801f00:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f06:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f09:	c1 e1 04             	shl    $0x4,%ecx
  801f0c:	01 ca                	add    %ecx,%edx
  801f0e:	89 50 04             	mov    %edx,0x4(%eax)
  801f11:	eb 12                	jmp    801f25 <initialize_MemBlocksList+0x9a>
  801f13:	a1 50 40 80 00       	mov    0x804050,%eax
  801f18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1b:	c1 e2 04             	shl    $0x4,%edx
  801f1e:	01 d0                	add    %edx,%eax
  801f20:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f25:	a1 50 40 80 00       	mov    0x804050,%eax
  801f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2d:	c1 e2 04             	shl    $0x4,%edx
  801f30:	01 d0                	add    %edx,%eax
  801f32:	a3 48 41 80 00       	mov    %eax,0x804148
  801f37:	a1 50 40 80 00       	mov    0x804050,%eax
  801f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f3f:	c1 e2 04             	shl    $0x4,%edx
  801f42:	01 d0                	add    %edx,%eax
  801f44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f4b:	a1 54 41 80 00       	mov    0x804154,%eax
  801f50:	40                   	inc    %eax
  801f51:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f56:	ff 45 f4             	incl   -0xc(%ebp)
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f5f:	0f 82 56 ff ff ff    	jb     801ebb <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f65:	90                   	nop
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	8b 00                	mov    (%eax),%eax
  801f73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f76:	eb 19                	jmp    801f91 <find_block+0x29>
	{
		if(va==point->sva)
  801f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f7b:	8b 40 08             	mov    0x8(%eax),%eax
  801f7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f81:	75 05                	jne    801f88 <find_block+0x20>
		   return point;
  801f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f86:	eb 36                	jmp    801fbe <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	8b 40 08             	mov    0x8(%eax),%eax
  801f8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f95:	74 07                	je     801f9e <find_block+0x36>
  801f97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f9a:	8b 00                	mov    (%eax),%eax
  801f9c:	eb 05                	jmp    801fa3 <find_block+0x3b>
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  801fa6:	89 42 08             	mov    %eax,0x8(%edx)
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	8b 40 08             	mov    0x8(%eax),%eax
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	75 c5                	jne    801f78 <find_block+0x10>
  801fb3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fb7:	75 bf                	jne    801f78 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801fc6:	a1 40 40 80 00       	mov    0x804040,%eax
  801fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fce:	a1 44 40 80 00       	mov    0x804044,%eax
  801fd3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fdc:	74 24                	je     802002 <insert_sorted_allocList+0x42>
  801fde:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe1:	8b 50 08             	mov    0x8(%eax),%edx
  801fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe7:	8b 40 08             	mov    0x8(%eax),%eax
  801fea:	39 c2                	cmp    %eax,%edx
  801fec:	76 14                	jbe    802002 <insert_sorted_allocList+0x42>
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 50 08             	mov    0x8(%eax),%edx
  801ff4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ff7:	8b 40 08             	mov    0x8(%eax),%eax
  801ffa:	39 c2                	cmp    %eax,%edx
  801ffc:	0f 82 60 01 00 00    	jb     802162 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802002:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802006:	75 65                	jne    80206d <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802008:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80200c:	75 14                	jne    802022 <insert_sorted_allocList+0x62>
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 1c 3e 80 00       	push   $0x803e1c
  802016:	6a 6b                	push   $0x6b
  802018:	68 3f 3e 80 00       	push   $0x803e3f
  80201d:	e8 4f e2 ff ff       	call   800271 <_panic>
  802022:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	89 10                	mov    %edx,(%eax)
  80202d:	8b 45 08             	mov    0x8(%ebp),%eax
  802030:	8b 00                	mov    (%eax),%eax
  802032:	85 c0                	test   %eax,%eax
  802034:	74 0d                	je     802043 <insert_sorted_allocList+0x83>
  802036:	a1 40 40 80 00       	mov    0x804040,%eax
  80203b:	8b 55 08             	mov    0x8(%ebp),%edx
  80203e:	89 50 04             	mov    %edx,0x4(%eax)
  802041:	eb 08                	jmp    80204b <insert_sorted_allocList+0x8b>
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	a3 44 40 80 00       	mov    %eax,0x804044
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	a3 40 40 80 00       	mov    %eax,0x804040
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80205d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802062:	40                   	inc    %eax
  802063:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802068:	e9 dc 01 00 00       	jmp    802249 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 50 08             	mov    0x8(%eax),%edx
  802073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802076:	8b 40 08             	mov    0x8(%eax),%eax
  802079:	39 c2                	cmp    %eax,%edx
  80207b:	77 6c                	ja     8020e9 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80207d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802081:	74 06                	je     802089 <insert_sorted_allocList+0xc9>
  802083:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802087:	75 14                	jne    80209d <insert_sorted_allocList+0xdd>
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	68 58 3e 80 00       	push   $0x803e58
  802091:	6a 6f                	push   $0x6f
  802093:	68 3f 3e 80 00       	push   $0x803e3f
  802098:	e8 d4 e1 ff ff       	call   800271 <_panic>
  80209d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a0:	8b 50 04             	mov    0x4(%eax),%edx
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	89 50 04             	mov    %edx,0x4(%eax)
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020af:	89 10                	mov    %edx,(%eax)
  8020b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b4:	8b 40 04             	mov    0x4(%eax),%eax
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	74 0d                	je     8020c8 <insert_sorted_allocList+0x108>
  8020bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020be:	8b 40 04             	mov    0x4(%eax),%eax
  8020c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c4:	89 10                	mov    %edx,(%eax)
  8020c6:	eb 08                	jmp    8020d0 <insert_sorted_allocList+0x110>
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	a3 40 40 80 00       	mov    %eax,0x804040
  8020d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020d6:	89 50 04             	mov    %edx,0x4(%eax)
  8020d9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020de:	40                   	inc    %eax
  8020df:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020e4:	e9 60 01 00 00       	jmp    802249 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	8b 50 08             	mov    0x8(%eax),%edx
  8020ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	39 c2                	cmp    %eax,%edx
  8020f7:	0f 82 4c 01 00 00    	jb     802249 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802101:	75 14                	jne    802117 <insert_sorted_allocList+0x157>
  802103:	83 ec 04             	sub    $0x4,%esp
  802106:	68 90 3e 80 00       	push   $0x803e90
  80210b:	6a 73                	push   $0x73
  80210d:	68 3f 3e 80 00       	push   $0x803e3f
  802112:	e8 5a e1 ff ff       	call   800271 <_panic>
  802117:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	89 50 04             	mov    %edx,0x4(%eax)
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	8b 40 04             	mov    0x4(%eax),%eax
  802129:	85 c0                	test   %eax,%eax
  80212b:	74 0c                	je     802139 <insert_sorted_allocList+0x179>
  80212d:	a1 44 40 80 00       	mov    0x804044,%eax
  802132:	8b 55 08             	mov    0x8(%ebp),%edx
  802135:	89 10                	mov    %edx,(%eax)
  802137:	eb 08                	jmp    802141 <insert_sorted_allocList+0x181>
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	a3 40 40 80 00       	mov    %eax,0x804040
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	a3 44 40 80 00       	mov    %eax,0x804044
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802152:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802157:	40                   	inc    %eax
  802158:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80215d:	e9 e7 00 00 00       	jmp    802249 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802165:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802168:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80216f:	a1 40 40 80 00       	mov    0x804040,%eax
  802174:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802177:	e9 9d 00 00 00       	jmp    802219 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	8b 00                	mov    (%eax),%eax
  802181:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	8b 50 08             	mov    0x8(%eax),%edx
  80218a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218d:	8b 40 08             	mov    0x8(%eax),%eax
  802190:	39 c2                	cmp    %eax,%edx
  802192:	76 7d                	jbe    802211 <insert_sorted_allocList+0x251>
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	8b 50 08             	mov    0x8(%eax),%edx
  80219a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80219d:	8b 40 08             	mov    0x8(%eax),%eax
  8021a0:	39 c2                	cmp    %eax,%edx
  8021a2:	73 6d                	jae    802211 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8021a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a8:	74 06                	je     8021b0 <insert_sorted_allocList+0x1f0>
  8021aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ae:	75 14                	jne    8021c4 <insert_sorted_allocList+0x204>
  8021b0:	83 ec 04             	sub    $0x4,%esp
  8021b3:	68 b4 3e 80 00       	push   $0x803eb4
  8021b8:	6a 7f                	push   $0x7f
  8021ba:	68 3f 3e 80 00       	push   $0x803e3f
  8021bf:	e8 ad e0 ff ff       	call   800271 <_panic>
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	8b 10                	mov    (%eax),%edx
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	89 10                	mov    %edx,(%eax)
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 0b                	je     8021e2 <insert_sorted_allocList+0x222>
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	8b 00                	mov    (%eax),%eax
  8021dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021df:	89 50 04             	mov    %edx,0x4(%eax)
  8021e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e8:	89 10                	mov    %edx,(%eax)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f0:	89 50 04             	mov    %edx,0x4(%eax)
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8b 00                	mov    (%eax),%eax
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	75 08                	jne    802204 <insert_sorted_allocList+0x244>
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 44 40 80 00       	mov    %eax,0x804044
  802204:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802209:	40                   	inc    %eax
  80220a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80220f:	eb 39                	jmp    80224a <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802211:	a1 48 40 80 00       	mov    0x804048,%eax
  802216:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221d:	74 07                	je     802226 <insert_sorted_allocList+0x266>
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	8b 00                	mov    (%eax),%eax
  802224:	eb 05                	jmp    80222b <insert_sorted_allocList+0x26b>
  802226:	b8 00 00 00 00       	mov    $0x0,%eax
  80222b:	a3 48 40 80 00       	mov    %eax,0x804048
  802230:	a1 48 40 80 00       	mov    0x804048,%eax
  802235:	85 c0                	test   %eax,%eax
  802237:	0f 85 3f ff ff ff    	jne    80217c <insert_sorted_allocList+0x1bc>
  80223d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802241:	0f 85 35 ff ff ff    	jne    80217c <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802247:	eb 01                	jmp    80224a <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802249:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802253:	a1 38 41 80 00       	mov    0x804138,%eax
  802258:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80225b:	e9 85 01 00 00       	jmp    8023e5 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802263:	8b 40 0c             	mov    0xc(%eax),%eax
  802266:	3b 45 08             	cmp    0x8(%ebp),%eax
  802269:	0f 82 6e 01 00 00    	jb     8023dd <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 0c             	mov    0xc(%eax),%eax
  802275:	3b 45 08             	cmp    0x8(%ebp),%eax
  802278:	0f 85 8a 00 00 00    	jne    802308 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80227e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802282:	75 17                	jne    80229b <alloc_block_FF+0x4e>
  802284:	83 ec 04             	sub    $0x4,%esp
  802287:	68 e8 3e 80 00       	push   $0x803ee8
  80228c:	68 93 00 00 00       	push   $0x93
  802291:	68 3f 3e 80 00       	push   $0x803e3f
  802296:	e8 d6 df ff ff       	call   800271 <_panic>
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 10                	je     8022b4 <alloc_block_FF+0x67>
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 00                	mov    (%eax),%eax
  8022a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ac:	8b 52 04             	mov    0x4(%edx),%edx
  8022af:	89 50 04             	mov    %edx,0x4(%eax)
  8022b2:	eb 0b                	jmp    8022bf <alloc_block_FF+0x72>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c2:	8b 40 04             	mov    0x4(%eax),%eax
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	74 0f                	je     8022d8 <alloc_block_FF+0x8b>
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 40 04             	mov    0x4(%eax),%eax
  8022cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d2:	8b 12                	mov    (%edx),%edx
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	eb 0a                	jmp    8022e2 <alloc_block_FF+0x95>
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	8b 00                	mov    (%eax),%eax
  8022dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8022fa:	48                   	dec    %eax
  8022fb:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	e9 10 01 00 00       	jmp    802418 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 0c             	mov    0xc(%eax),%eax
  80230e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802311:	0f 86 c6 00 00 00    	jbe    8023dd <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802317:	a1 48 41 80 00       	mov    0x804148,%eax
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 50 08             	mov    0x8(%eax),%edx
  802325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802328:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	8b 55 08             	mov    0x8(%ebp),%edx
  802331:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802334:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802338:	75 17                	jne    802351 <alloc_block_FF+0x104>
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	68 e8 3e 80 00       	push   $0x803ee8
  802342:	68 9b 00 00 00       	push   $0x9b
  802347:	68 3f 3e 80 00       	push   $0x803e3f
  80234c:	e8 20 df ff ff       	call   800271 <_panic>
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	74 10                	je     80236a <alloc_block_FF+0x11d>
  80235a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802362:	8b 52 04             	mov    0x4(%edx),%edx
  802365:	89 50 04             	mov    %edx,0x4(%eax)
  802368:	eb 0b                	jmp    802375 <alloc_block_FF+0x128>
  80236a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236d:	8b 40 04             	mov    0x4(%eax),%eax
  802370:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802378:	8b 40 04             	mov    0x4(%eax),%eax
  80237b:	85 c0                	test   %eax,%eax
  80237d:	74 0f                	je     80238e <alloc_block_FF+0x141>
  80237f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802382:	8b 40 04             	mov    0x4(%eax),%eax
  802385:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802388:	8b 12                	mov    (%edx),%edx
  80238a:	89 10                	mov    %edx,(%eax)
  80238c:	eb 0a                	jmp    802398 <alloc_block_FF+0x14b>
  80238e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802391:	8b 00                	mov    (%eax),%eax
  802393:	a3 48 41 80 00       	mov    %eax,0x804148
  802398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ab:	a1 54 41 80 00       	mov    0x804154,%eax
  8023b0:	48                   	dec    %eax
  8023b1:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 50 08             	mov    0x8(%eax),%edx
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	01 c2                	add    %eax,%edx
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8023d0:	89 c2                	mov    %eax,%edx
  8023d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d5:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023db:	eb 3b                	jmp    802418 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023dd:	a1 40 41 80 00       	mov    0x804140,%eax
  8023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	74 07                	je     8023f2 <alloc_block_FF+0x1a5>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	eb 05                	jmp    8023f7 <alloc_block_FF+0x1aa>
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	a3 40 41 80 00       	mov    %eax,0x804140
  8023fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802401:	85 c0                	test   %eax,%eax
  802403:	0f 85 57 fe ff ff    	jne    802260 <alloc_block_FF+0x13>
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	0f 85 4d fe ff ff    	jne    802260 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802418:	c9                   	leave  
  802419:	c3                   	ret    

0080241a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802420:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802427:	a1 38 41 80 00       	mov    0x804138,%eax
  80242c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242f:	e9 df 00 00 00       	jmp    802513 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 40 0c             	mov    0xc(%eax),%eax
  80243a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243d:	0f 82 c8 00 00 00    	jb     80250b <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 40 0c             	mov    0xc(%eax),%eax
  802449:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244c:	0f 85 8a 00 00 00    	jne    8024dc <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802456:	75 17                	jne    80246f <alloc_block_BF+0x55>
  802458:	83 ec 04             	sub    $0x4,%esp
  80245b:	68 e8 3e 80 00       	push   $0x803ee8
  802460:	68 b7 00 00 00       	push   $0xb7
  802465:	68 3f 3e 80 00       	push   $0x803e3f
  80246a:	e8 02 de ff ff       	call   800271 <_panic>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 00                	mov    (%eax),%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 10                	je     802488 <alloc_block_BF+0x6e>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802480:	8b 52 04             	mov    0x4(%edx),%edx
  802483:	89 50 04             	mov    %edx,0x4(%eax)
  802486:	eb 0b                	jmp    802493 <alloc_block_BF+0x79>
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 40 04             	mov    0x4(%eax),%eax
  80248e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 04             	mov    0x4(%eax),%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	74 0f                	je     8024ac <alloc_block_BF+0x92>
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 04             	mov    0x4(%eax),%eax
  8024a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a6:	8b 12                	mov    (%edx),%edx
  8024a8:	89 10                	mov    %edx,(%eax)
  8024aa:	eb 0a                	jmp    8024b6 <alloc_block_BF+0x9c>
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c9:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ce:	48                   	dec    %eax
  8024cf:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	e9 4d 01 00 00       	jmp    802629 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e5:	76 24                	jbe    80250b <alloc_block_BF+0xf1>
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024f0:	73 19                	jae    80250b <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024f2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 40 08             	mov    0x8(%eax),%eax
  802508:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80250b:	a1 40 41 80 00       	mov    0x804140,%eax
  802510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802517:	74 07                	je     802520 <alloc_block_BF+0x106>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	eb 05                	jmp    802525 <alloc_block_BF+0x10b>
  802520:	b8 00 00 00 00       	mov    $0x0,%eax
  802525:	a3 40 41 80 00       	mov    %eax,0x804140
  80252a:	a1 40 41 80 00       	mov    0x804140,%eax
  80252f:	85 c0                	test   %eax,%eax
  802531:	0f 85 fd fe ff ff    	jne    802434 <alloc_block_BF+0x1a>
  802537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253b:	0f 85 f3 fe ff ff    	jne    802434 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802541:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802545:	0f 84 d9 00 00 00    	je     802624 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80254b:	a1 48 41 80 00       	mov    0x804148,%eax
  802550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802556:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802559:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80255c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255f:	8b 55 08             	mov    0x8(%ebp),%edx
  802562:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802565:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802569:	75 17                	jne    802582 <alloc_block_BF+0x168>
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 e8 3e 80 00       	push   $0x803ee8
  802573:	68 c7 00 00 00       	push   $0xc7
  802578:	68 3f 3e 80 00       	push   $0x803e3f
  80257d:	e8 ef dc ff ff       	call   800271 <_panic>
  802582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 10                	je     80259b <alloc_block_BF+0x181>
  80258b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802593:	8b 52 04             	mov    0x4(%edx),%edx
  802596:	89 50 04             	mov    %edx,0x4(%eax)
  802599:	eb 0b                	jmp    8025a6 <alloc_block_BF+0x18c>
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	74 0f                	je     8025bf <alloc_block_BF+0x1a5>
  8025b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b3:	8b 40 04             	mov    0x4(%eax),%eax
  8025b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025b9:	8b 12                	mov    (%edx),%edx
  8025bb:	89 10                	mov    %edx,(%eax)
  8025bd:	eb 0a                	jmp    8025c9 <alloc_block_BF+0x1af>
  8025bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	a3 48 41 80 00       	mov    %eax,0x804148
  8025c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025dc:	a1 54 41 80 00       	mov    0x804154,%eax
  8025e1:	48                   	dec    %eax
  8025e2:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025e7:	83 ec 08             	sub    $0x8,%esp
  8025ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8025ed:	68 38 41 80 00       	push   $0x804138
  8025f2:	e8 71 f9 ff ff       	call   801f68 <find_block>
  8025f7:	83 c4 10             	add    $0x10,%esp
  8025fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802600:	8b 50 08             	mov    0x8(%eax),%edx
  802603:	8b 45 08             	mov    0x8(%ebp),%eax
  802606:	01 c2                	add    %eax,%edx
  802608:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80260b:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80260e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802611:	8b 40 0c             	mov    0xc(%eax),%eax
  802614:	2b 45 08             	sub    0x8(%ebp),%eax
  802617:	89 c2                	mov    %eax,%edx
  802619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261c:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80261f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802622:	eb 05                	jmp    802629 <alloc_block_BF+0x20f>
	}
	return NULL;
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802629:	c9                   	leave  
  80262a:	c3                   	ret    

0080262b <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802631:	a1 28 40 80 00       	mov    0x804028,%eax
  802636:	85 c0                	test   %eax,%eax
  802638:	0f 85 de 01 00 00    	jne    80281c <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80263e:	a1 38 41 80 00       	mov    0x804138,%eax
  802643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802646:	e9 9e 01 00 00       	jmp    8027e9 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80264b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264e:	8b 40 0c             	mov    0xc(%eax),%eax
  802651:	3b 45 08             	cmp    0x8(%ebp),%eax
  802654:	0f 82 87 01 00 00    	jb     8027e1 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	3b 45 08             	cmp    0x8(%ebp),%eax
  802663:	0f 85 95 00 00 00    	jne    8026fe <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	75 17                	jne    802686 <alloc_block_NF+0x5b>
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	68 e8 3e 80 00       	push   $0x803ee8
  802677:	68 e0 00 00 00       	push   $0xe0
  80267c:	68 3f 3e 80 00       	push   $0x803e3f
  802681:	e8 eb db ff ff       	call   800271 <_panic>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 10                	je     80269f <alloc_block_NF+0x74>
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802697:	8b 52 04             	mov    0x4(%edx),%edx
  80269a:	89 50 04             	mov    %edx,0x4(%eax)
  80269d:	eb 0b                	jmp    8026aa <alloc_block_NF+0x7f>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0f                	je     8026c3 <alloc_block_NF+0x98>
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bd:	8b 12                	mov    (%edx),%edx
  8026bf:	89 10                	mov    %edx,(%eax)
  8026c1:	eb 0a                	jmp    8026cd <alloc_block_NF+0xa2>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	a3 38 41 80 00       	mov    %eax,0x804138
  8026cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e0:	a1 44 41 80 00       	mov    0x804144,%eax
  8026e5:	48                   	dec    %eax
  8026e6:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 08             	mov    0x8(%eax),%eax
  8026f1:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	e9 f8 04 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	3b 45 08             	cmp    0x8(%ebp),%eax
  802707:	0f 86 d4 00 00 00    	jbe    8027e1 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80270d:	a1 48 41 80 00       	mov    0x804148,%eax
  802712:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 50 08             	mov    0x8(%eax),%edx
  80271b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271e:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	8b 55 08             	mov    0x8(%ebp),%edx
  802727:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80272a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80272e:	75 17                	jne    802747 <alloc_block_NF+0x11c>
  802730:	83 ec 04             	sub    $0x4,%esp
  802733:	68 e8 3e 80 00       	push   $0x803ee8
  802738:	68 e9 00 00 00       	push   $0xe9
  80273d:	68 3f 3e 80 00       	push   $0x803e3f
  802742:	e8 2a db ff ff       	call   800271 <_panic>
  802747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274a:	8b 00                	mov    (%eax),%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	74 10                	je     802760 <alloc_block_NF+0x135>
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	8b 00                	mov    (%eax),%eax
  802755:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802758:	8b 52 04             	mov    0x4(%edx),%edx
  80275b:	89 50 04             	mov    %edx,0x4(%eax)
  80275e:	eb 0b                	jmp    80276b <alloc_block_NF+0x140>
  802760:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802763:	8b 40 04             	mov    0x4(%eax),%eax
  802766:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	85 c0                	test   %eax,%eax
  802773:	74 0f                	je     802784 <alloc_block_NF+0x159>
  802775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802778:	8b 40 04             	mov    0x4(%eax),%eax
  80277b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80277e:	8b 12                	mov    (%edx),%edx
  802780:	89 10                	mov    %edx,(%eax)
  802782:	eb 0a                	jmp    80278e <alloc_block_NF+0x163>
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 00                	mov    (%eax),%eax
  802789:	a3 48 41 80 00       	mov    %eax,0x804148
  80278e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802791:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a1:	a1 54 41 80 00       	mov    0x804154,%eax
  8027a6:	48                   	dec    %eax
  8027a7:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8027ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027af:	8b 40 08             	mov    0x8(%eax),%eax
  8027b2:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 50 08             	mov    0x8(%eax),%edx
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	01 c2                	add    %eax,%edx
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d1:	89 c2                	mov    %eax,%edx
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dc:	e9 15 04 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027e1:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ed:	74 07                	je     8027f6 <alloc_block_NF+0x1cb>
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 00                	mov    (%eax),%eax
  8027f4:	eb 05                	jmp    8027fb <alloc_block_NF+0x1d0>
  8027f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fb:	a3 40 41 80 00       	mov    %eax,0x804140
  802800:	a1 40 41 80 00       	mov    0x804140,%eax
  802805:	85 c0                	test   %eax,%eax
  802807:	0f 85 3e fe ff ff    	jne    80264b <alloc_block_NF+0x20>
  80280d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802811:	0f 85 34 fe ff ff    	jne    80264b <alloc_block_NF+0x20>
  802817:	e9 d5 03 00 00       	jmp    802bf1 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80281c:	a1 38 41 80 00       	mov    0x804138,%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802824:	e9 b1 01 00 00       	jmp    8029da <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 50 08             	mov    0x8(%eax),%edx
  80282f:	a1 28 40 80 00       	mov    0x804028,%eax
  802834:	39 c2                	cmp    %eax,%edx
  802836:	0f 82 96 01 00 00    	jb     8029d2 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	3b 45 08             	cmp    0x8(%ebp),%eax
  802845:	0f 82 87 01 00 00    	jb     8029d2 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	8b 40 0c             	mov    0xc(%eax),%eax
  802851:	3b 45 08             	cmp    0x8(%ebp),%eax
  802854:	0f 85 95 00 00 00    	jne    8028ef <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80285a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285e:	75 17                	jne    802877 <alloc_block_NF+0x24c>
  802860:	83 ec 04             	sub    $0x4,%esp
  802863:	68 e8 3e 80 00       	push   $0x803ee8
  802868:	68 fc 00 00 00       	push   $0xfc
  80286d:	68 3f 3e 80 00       	push   $0x803e3f
  802872:	e8 fa d9 ff ff       	call   800271 <_panic>
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	74 10                	je     802890 <alloc_block_NF+0x265>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802888:	8b 52 04             	mov    0x4(%edx),%edx
  80288b:	89 50 04             	mov    %edx,0x4(%eax)
  80288e:	eb 0b                	jmp    80289b <alloc_block_NF+0x270>
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	8b 40 04             	mov    0x4(%eax),%eax
  802896:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 04             	mov    0x4(%eax),%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	74 0f                	je     8028b4 <alloc_block_NF+0x289>
  8028a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ae:	8b 12                	mov    (%edx),%edx
  8028b0:	89 10                	mov    %edx,(%eax)
  8028b2:	eb 0a                	jmp    8028be <alloc_block_NF+0x293>
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	a3 38 41 80 00       	mov    %eax,0x804138
  8028be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d1:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d6:	48                   	dec    %eax
  8028d7:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 08             	mov    0x8(%eax),%eax
  8028e2:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	e9 07 03 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f8:	0f 86 d4 00 00 00    	jbe    8029d2 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028fe:	a1 48 41 80 00       	mov    0x804148,%eax
  802903:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 50 08             	mov    0x8(%eax),%edx
  80290c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290f:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802912:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802915:	8b 55 08             	mov    0x8(%ebp),%edx
  802918:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80291b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80291f:	75 17                	jne    802938 <alloc_block_NF+0x30d>
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	68 e8 3e 80 00       	push   $0x803ee8
  802929:	68 04 01 00 00       	push   $0x104
  80292e:	68 3f 3e 80 00       	push   $0x803e3f
  802933:	e8 39 d9 ff ff       	call   800271 <_panic>
  802938:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 10                	je     802951 <alloc_block_NF+0x326>
  802941:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802949:	8b 52 04             	mov    0x4(%edx),%edx
  80294c:	89 50 04             	mov    %edx,0x4(%eax)
  80294f:	eb 0b                	jmp    80295c <alloc_block_NF+0x331>
  802951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802954:	8b 40 04             	mov    0x4(%eax),%eax
  802957:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80295c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295f:	8b 40 04             	mov    0x4(%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 0f                	je     802975 <alloc_block_NF+0x34a>
  802966:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802969:	8b 40 04             	mov    0x4(%eax),%eax
  80296c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80296f:	8b 12                	mov    (%edx),%edx
  802971:	89 10                	mov    %edx,(%eax)
  802973:	eb 0a                	jmp    80297f <alloc_block_NF+0x354>
  802975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802978:	8b 00                	mov    (%eax),%eax
  80297a:	a3 48 41 80 00       	mov    %eax,0x804148
  80297f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802982:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802988:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802992:	a1 54 41 80 00       	mov    0x804154,%eax
  802997:	48                   	dec    %eax
  802998:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  80299d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a0:	8b 40 08             	mov    0x8(%eax),%eax
  8029a3:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 50 08             	mov    0x8(%eax),%edx
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	01 c2                	add    %eax,%edx
  8029b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b6:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8029bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8029c2:	89 c2                	mov    %eax,%edx
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cd:	e9 24 02 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029d2:	a1 40 41 80 00       	mov    0x804140,%eax
  8029d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029de:	74 07                	je     8029e7 <alloc_block_NF+0x3bc>
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 00                	mov    (%eax),%eax
  8029e5:	eb 05                	jmp    8029ec <alloc_block_NF+0x3c1>
  8029e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8029ec:	a3 40 41 80 00       	mov    %eax,0x804140
  8029f1:	a1 40 41 80 00       	mov    0x804140,%eax
  8029f6:	85 c0                	test   %eax,%eax
  8029f8:	0f 85 2b fe ff ff    	jne    802829 <alloc_block_NF+0x1fe>
  8029fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a02:	0f 85 21 fe ff ff    	jne    802829 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a08:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a10:	e9 ae 01 00 00       	jmp    802bc3 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 50 08             	mov    0x8(%eax),%edx
  802a1b:	a1 28 40 80 00       	mov    0x804028,%eax
  802a20:	39 c2                	cmp    %eax,%edx
  802a22:	0f 83 93 01 00 00    	jae    802bbb <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a31:	0f 82 84 01 00 00    	jb     802bbb <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a40:	0f 85 95 00 00 00    	jne    802adb <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4a:	75 17                	jne    802a63 <alloc_block_NF+0x438>
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	68 e8 3e 80 00       	push   $0x803ee8
  802a54:	68 14 01 00 00       	push   $0x114
  802a59:	68 3f 3e 80 00       	push   $0x803e3f
  802a5e:	e8 0e d8 ff ff       	call   800271 <_panic>
  802a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a66:	8b 00                	mov    (%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 10                	je     802a7c <alloc_block_NF+0x451>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 00                	mov    (%eax),%eax
  802a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a74:	8b 52 04             	mov    0x4(%edx),%edx
  802a77:	89 50 04             	mov    %edx,0x4(%eax)
  802a7a:	eb 0b                	jmp    802a87 <alloc_block_NF+0x45c>
  802a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7f:	8b 40 04             	mov    0x4(%eax),%eax
  802a82:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 40 04             	mov    0x4(%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 0f                	je     802aa0 <alloc_block_NF+0x475>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9a:	8b 12                	mov    (%edx),%edx
  802a9c:	89 10                	mov    %edx,(%eax)
  802a9e:	eb 0a                	jmp    802aaa <alloc_block_NF+0x47f>
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 00                	mov    (%eax),%eax
  802aa5:	a3 38 41 80 00       	mov    %eax,0x804138
  802aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abd:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac2:	48                   	dec    %eax
  802ac3:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 40 08             	mov    0x8(%eax),%eax
  802ace:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	e9 1b 01 00 00       	jmp    802bf6 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae4:	0f 86 d1 00 00 00    	jbe    802bbb <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aea:	a1 48 41 80 00       	mov    0x804148,%eax
  802aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 50 08             	mov    0x8(%eax),%edx
  802af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afb:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b01:	8b 55 08             	mov    0x8(%ebp),%edx
  802b04:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b0b:	75 17                	jne    802b24 <alloc_block_NF+0x4f9>
  802b0d:	83 ec 04             	sub    $0x4,%esp
  802b10:	68 e8 3e 80 00       	push   $0x803ee8
  802b15:	68 1c 01 00 00       	push   $0x11c
  802b1a:	68 3f 3e 80 00       	push   $0x803e3f
  802b1f:	e8 4d d7 ff ff       	call   800271 <_panic>
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 00                	mov    (%eax),%eax
  802b29:	85 c0                	test   %eax,%eax
  802b2b:	74 10                	je     802b3d <alloc_block_NF+0x512>
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b35:	8b 52 04             	mov    0x4(%edx),%edx
  802b38:	89 50 04             	mov    %edx,0x4(%eax)
  802b3b:	eb 0b                	jmp    802b48 <alloc_block_NF+0x51d>
  802b3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b40:	8b 40 04             	mov    0x4(%eax),%eax
  802b43:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4b:	8b 40 04             	mov    0x4(%eax),%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	74 0f                	je     802b61 <alloc_block_NF+0x536>
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	8b 40 04             	mov    0x4(%eax),%eax
  802b58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b5b:	8b 12                	mov    (%edx),%edx
  802b5d:	89 10                	mov    %edx,(%eax)
  802b5f:	eb 0a                	jmp    802b6b <alloc_block_NF+0x540>
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	a3 48 41 80 00       	mov    %eax,0x804148
  802b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7e:	a1 54 41 80 00       	mov    0x804154,%eax
  802b83:	48                   	dec    %eax
  802b84:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b8c:	8b 40 08             	mov    0x8(%eax),%eax
  802b8f:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 50 08             	mov    0x8(%eax),%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	01 c2                	add    %eax,%edx
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bab:	2b 45 08             	sub    0x8(%ebp),%eax
  802bae:	89 c2                	mov    %eax,%edx
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb9:	eb 3b                	jmp    802bf6 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802bbb:	a1 40 41 80 00       	mov    0x804140,%eax
  802bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc7:	74 07                	je     802bd0 <alloc_block_NF+0x5a5>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	eb 05                	jmp    802bd5 <alloc_block_NF+0x5aa>
  802bd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd5:	a3 40 41 80 00       	mov    %eax,0x804140
  802bda:	a1 40 41 80 00       	mov    0x804140,%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	0f 85 2e fe ff ff    	jne    802a15 <alloc_block_NF+0x3ea>
  802be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802beb:	0f 85 24 fe ff ff    	jne    802a15 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bf6:	c9                   	leave  
  802bf7:	c3                   	ret    

00802bf8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
  802bfb:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bfe:	a1 38 41 80 00       	mov    0x804138,%eax
  802c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802c06:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c0b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802c0e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	74 14                	je     802c2b <insert_sorted_with_merge_freeList+0x33>
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	8b 50 08             	mov    0x8(%eax),%edx
  802c1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c20:	8b 40 08             	mov    0x8(%eax),%eax
  802c23:	39 c2                	cmp    %eax,%edx
  802c25:	0f 87 9b 01 00 00    	ja     802dc6 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2f:	75 17                	jne    802c48 <insert_sorted_with_merge_freeList+0x50>
  802c31:	83 ec 04             	sub    $0x4,%esp
  802c34:	68 1c 3e 80 00       	push   $0x803e1c
  802c39:	68 38 01 00 00       	push   $0x138
  802c3e:	68 3f 3e 80 00       	push   $0x803e3f
  802c43:	e8 29 d6 ff ff       	call   800271 <_panic>
  802c48:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	89 10                	mov    %edx,(%eax)
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 00                	mov    (%eax),%eax
  802c58:	85 c0                	test   %eax,%eax
  802c5a:	74 0d                	je     802c69 <insert_sorted_with_merge_freeList+0x71>
  802c5c:	a1 38 41 80 00       	mov    0x804138,%eax
  802c61:	8b 55 08             	mov    0x8(%ebp),%edx
  802c64:	89 50 04             	mov    %edx,0x4(%eax)
  802c67:	eb 08                	jmp    802c71 <insert_sorted_with_merge_freeList+0x79>
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	a3 38 41 80 00       	mov    %eax,0x804138
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c83:	a1 44 41 80 00       	mov    0x804144,%eax
  802c88:	40                   	inc    %eax
  802c89:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c92:	0f 84 a8 06 00 00    	je     803340 <insert_sorted_with_merge_freeList+0x748>
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	8b 50 08             	mov    0x8(%eax),%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	01 c2                	add    %eax,%edx
  802ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca9:	8b 40 08             	mov    0x8(%eax),%eax
  802cac:	39 c2                	cmp    %eax,%edx
  802cae:	0f 85 8c 06 00 00    	jne    803340 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb7:	8b 50 0c             	mov    0xc(%eax),%edx
  802cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc0:	01 c2                	add    %eax,%edx
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802cc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ccc:	75 17                	jne    802ce5 <insert_sorted_with_merge_freeList+0xed>
  802cce:	83 ec 04             	sub    $0x4,%esp
  802cd1:	68 e8 3e 80 00       	push   $0x803ee8
  802cd6:	68 3c 01 00 00       	push   $0x13c
  802cdb:	68 3f 3e 80 00       	push   $0x803e3f
  802ce0:	e8 8c d5 ff ff       	call   800271 <_panic>
  802ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	85 c0                	test   %eax,%eax
  802cec:	74 10                	je     802cfe <insert_sorted_with_merge_freeList+0x106>
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 00                	mov    (%eax),%eax
  802cf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf6:	8b 52 04             	mov    0x4(%edx),%edx
  802cf9:	89 50 04             	mov    %edx,0x4(%eax)
  802cfc:	eb 0b                	jmp    802d09 <insert_sorted_with_merge_freeList+0x111>
  802cfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d01:	8b 40 04             	mov    0x4(%eax),%eax
  802d04:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	85 c0                	test   %eax,%eax
  802d11:	74 0f                	je     802d22 <insert_sorted_with_merge_freeList+0x12a>
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	8b 40 04             	mov    0x4(%eax),%eax
  802d19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d1c:	8b 12                	mov    (%edx),%edx
  802d1e:	89 10                	mov    %edx,(%eax)
  802d20:	eb 0a                	jmp    802d2c <insert_sorted_with_merge_freeList+0x134>
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d44:	48                   	dec    %eax
  802d45:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d62:	75 17                	jne    802d7b <insert_sorted_with_merge_freeList+0x183>
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	68 1c 3e 80 00       	push   $0x803e1c
  802d6c:	68 3f 01 00 00       	push   $0x13f
  802d71:	68 3f 3e 80 00       	push   $0x803e3f
  802d76:	e8 f6 d4 ff ff       	call   800271 <_panic>
  802d7b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	89 10                	mov    %edx,(%eax)
  802d86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0d                	je     802d9c <insert_sorted_with_merge_freeList+0x1a4>
  802d8f:	a1 48 41 80 00       	mov    0x804148,%eax
  802d94:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d97:	89 50 04             	mov    %edx,0x4(%eax)
  802d9a:	eb 08                	jmp    802da4 <insert_sorted_with_merge_freeList+0x1ac>
  802d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	a3 48 41 80 00       	mov    %eax,0x804148
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db6:	a1 54 41 80 00       	mov    0x804154,%eax
  802dbb:	40                   	inc    %eax
  802dbc:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dc1:	e9 7a 05 00 00       	jmp    803340 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	8b 50 08             	mov    0x8(%eax),%edx
  802dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcf:	8b 40 08             	mov    0x8(%eax),%eax
  802dd2:	39 c2                	cmp    %eax,%edx
  802dd4:	0f 82 14 01 00 00    	jb     802eee <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddd:	8b 50 08             	mov    0x8(%eax),%edx
  802de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de3:	8b 40 0c             	mov    0xc(%eax),%eax
  802de6:	01 c2                	add    %eax,%edx
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 40 08             	mov    0x8(%eax),%eax
  802dee:	39 c2                	cmp    %eax,%edx
  802df0:	0f 85 90 00 00 00    	jne    802e86 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 40 0c             	mov    0xc(%eax),%eax
  802e02:	01 c2                	add    %eax,%edx
  802e04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e07:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e22:	75 17                	jne    802e3b <insert_sorted_with_merge_freeList+0x243>
  802e24:	83 ec 04             	sub    $0x4,%esp
  802e27:	68 1c 3e 80 00       	push   $0x803e1c
  802e2c:	68 49 01 00 00       	push   $0x149
  802e31:	68 3f 3e 80 00       	push   $0x803e3f
  802e36:	e8 36 d4 ff ff       	call   800271 <_panic>
  802e3b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	89 10                	mov    %edx,(%eax)
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 0d                	je     802e5c <insert_sorted_with_merge_freeList+0x264>
  802e4f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e54:	8b 55 08             	mov    0x8(%ebp),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	eb 08                	jmp    802e64 <insert_sorted_with_merge_freeList+0x26c>
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e76:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7b:	40                   	inc    %eax
  802e7c:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e81:	e9 bb 04 00 00       	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8a:	75 17                	jne    802ea3 <insert_sorted_with_merge_freeList+0x2ab>
  802e8c:	83 ec 04             	sub    $0x4,%esp
  802e8f:	68 90 3e 80 00       	push   $0x803e90
  802e94:	68 4c 01 00 00       	push   $0x14c
  802e99:	68 3f 3e 80 00       	push   $0x803e3f
  802e9e:	e8 ce d3 ff ff       	call   800271 <_panic>
  802ea3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	89 50 04             	mov    %edx,0x4(%eax)
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	8b 40 04             	mov    0x4(%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 0c                	je     802ec5 <insert_sorted_with_merge_freeList+0x2cd>
  802eb9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec1:	89 10                	mov    %edx,(%eax)
  802ec3:	eb 08                	jmp    802ecd <insert_sorted_with_merge_freeList+0x2d5>
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	a3 38 41 80 00       	mov    %eax,0x804138
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ede:	a1 44 41 80 00       	mov    0x804144,%eax
  802ee3:	40                   	inc    %eax
  802ee4:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ee9:	e9 53 04 00 00       	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802eee:	a1 38 41 80 00       	mov    0x804138,%eax
  802ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef6:	e9 15 04 00 00       	jmp    803310 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	8b 50 08             	mov    0x8(%eax),%edx
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 40 08             	mov    0x8(%eax),%eax
  802f0f:	39 c2                	cmp    %eax,%edx
  802f11:	0f 86 f1 03 00 00    	jbe    803308 <insert_sorted_with_merge_freeList+0x710>
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8b 50 08             	mov    0x8(%eax),%edx
  802f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f20:	8b 40 08             	mov    0x8(%eax),%eax
  802f23:	39 c2                	cmp    %eax,%edx
  802f25:	0f 83 dd 03 00 00    	jae    803308 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 50 08             	mov    0x8(%eax),%edx
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 40 0c             	mov    0xc(%eax),%eax
  802f37:	01 c2                	add    %eax,%edx
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	8b 40 08             	mov    0x8(%eax),%eax
  802f3f:	39 c2                	cmp    %eax,%edx
  802f41:	0f 85 b9 01 00 00    	jne    803100 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 50 08             	mov    0x8(%eax),%edx
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	8b 40 0c             	mov    0xc(%eax),%eax
  802f53:	01 c2                	add    %eax,%edx
  802f55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f58:	8b 40 08             	mov    0x8(%eax),%eax
  802f5b:	39 c2                	cmp    %eax,%edx
  802f5d:	0f 85 0d 01 00 00    	jne    803070 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	8b 50 0c             	mov    0xc(%eax),%edx
  802f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6f:	01 c2                	add    %eax,%edx
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f7b:	75 17                	jne    802f94 <insert_sorted_with_merge_freeList+0x39c>
  802f7d:	83 ec 04             	sub    $0x4,%esp
  802f80:	68 e8 3e 80 00       	push   $0x803ee8
  802f85:	68 5c 01 00 00       	push   $0x15c
  802f8a:	68 3f 3e 80 00       	push   $0x803e3f
  802f8f:	e8 dd d2 ff ff       	call   800271 <_panic>
  802f94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	85 c0                	test   %eax,%eax
  802f9b:	74 10                	je     802fad <insert_sorted_with_merge_freeList+0x3b5>
  802f9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa0:	8b 00                	mov    (%eax),%eax
  802fa2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa5:	8b 52 04             	mov    0x4(%edx),%edx
  802fa8:	89 50 04             	mov    %edx,0x4(%eax)
  802fab:	eb 0b                	jmp    802fb8 <insert_sorted_with_merge_freeList+0x3c0>
  802fad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb0:	8b 40 04             	mov    0x4(%eax),%eax
  802fb3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbb:	8b 40 04             	mov    0x4(%eax),%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 0f                	je     802fd1 <insert_sorted_with_merge_freeList+0x3d9>
  802fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc5:	8b 40 04             	mov    0x4(%eax),%eax
  802fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fcb:	8b 12                	mov    (%edx),%edx
  802fcd:	89 10                	mov    %edx,(%eax)
  802fcf:	eb 0a                	jmp    802fdb <insert_sorted_with_merge_freeList+0x3e3>
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	a3 38 41 80 00       	mov    %eax,0x804138
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fe4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fee:	a1 44 41 80 00       	mov    0x804144,%eax
  802ff3:	48                   	dec    %eax
  802ff4:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803003:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803006:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80300d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803011:	75 17                	jne    80302a <insert_sorted_with_merge_freeList+0x432>
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	68 1c 3e 80 00       	push   $0x803e1c
  80301b:	68 5f 01 00 00       	push   $0x15f
  803020:	68 3f 3e 80 00       	push   $0x803e3f
  803025:	e8 47 d2 ff ff       	call   800271 <_panic>
  80302a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803030:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803033:	89 10                	mov    %edx,(%eax)
  803035:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	74 0d                	je     80304b <insert_sorted_with_merge_freeList+0x453>
  80303e:	a1 48 41 80 00       	mov    0x804148,%eax
  803043:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803046:	89 50 04             	mov    %edx,0x4(%eax)
  803049:	eb 08                	jmp    803053 <insert_sorted_with_merge_freeList+0x45b>
  80304b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80304e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803053:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803056:	a3 48 41 80 00       	mov    %eax,0x804148
  80305b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803065:	a1 54 41 80 00       	mov    0x804154,%eax
  80306a:	40                   	inc    %eax
  80306b:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803073:	8b 50 0c             	mov    0xc(%eax),%edx
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	01 c2                	add    %eax,%edx
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803098:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309c:	75 17                	jne    8030b5 <insert_sorted_with_merge_freeList+0x4bd>
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	68 1c 3e 80 00       	push   $0x803e1c
  8030a6:	68 64 01 00 00       	push   $0x164
  8030ab:	68 3f 3e 80 00       	push   $0x803e3f
  8030b0:	e8 bc d1 ff ff       	call   800271 <_panic>
  8030b5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 0d                	je     8030d6 <insert_sorted_with_merge_freeList+0x4de>
  8030c9:	a1 48 41 80 00       	mov    0x804148,%eax
  8030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d1:	89 50 04             	mov    %edx,0x4(%eax)
  8030d4:	eb 08                	jmp    8030de <insert_sorted_with_merge_freeList+0x4e6>
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8030f5:	40                   	inc    %eax
  8030f6:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030fb:	e9 41 02 00 00       	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 50 08             	mov    0x8(%eax),%edx
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	8b 40 0c             	mov    0xc(%eax),%eax
  80310c:	01 c2                	add    %eax,%edx
  80310e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803111:	8b 40 08             	mov    0x8(%eax),%eax
  803114:	39 c2                	cmp    %eax,%edx
  803116:	0f 85 7c 01 00 00    	jne    803298 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80311c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803120:	74 06                	je     803128 <insert_sorted_with_merge_freeList+0x530>
  803122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803126:	75 17                	jne    80313f <insert_sorted_with_merge_freeList+0x547>
  803128:	83 ec 04             	sub    $0x4,%esp
  80312b:	68 58 3e 80 00       	push   $0x803e58
  803130:	68 69 01 00 00       	push   $0x169
  803135:	68 3f 3e 80 00       	push   $0x803e3f
  80313a:	e8 32 d1 ff ff       	call   800271 <_panic>
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	8b 50 04             	mov    0x4(%eax),%edx
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803151:	89 10                	mov    %edx,(%eax)
  803153:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803156:	8b 40 04             	mov    0x4(%eax),%eax
  803159:	85 c0                	test   %eax,%eax
  80315b:	74 0d                	je     80316a <insert_sorted_with_merge_freeList+0x572>
  80315d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803160:	8b 40 04             	mov    0x4(%eax),%eax
  803163:	8b 55 08             	mov    0x8(%ebp),%edx
  803166:	89 10                	mov    %edx,(%eax)
  803168:	eb 08                	jmp    803172 <insert_sorted_with_merge_freeList+0x57a>
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	a3 38 41 80 00       	mov    %eax,0x804138
  803172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803175:	8b 55 08             	mov    0x8(%ebp),%edx
  803178:	89 50 04             	mov    %edx,0x4(%eax)
  80317b:	a1 44 41 80 00       	mov    0x804144,%eax
  803180:	40                   	inc    %eax
  803181:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	8b 50 0c             	mov    0xc(%eax),%edx
  80318c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80318f:	8b 40 0c             	mov    0xc(%eax),%eax
  803192:	01 c2                	add    %eax,%edx
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80319a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319e:	75 17                	jne    8031b7 <insert_sorted_with_merge_freeList+0x5bf>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 e8 3e 80 00       	push   $0x803ee8
  8031a8:	68 6b 01 00 00       	push   $0x16b
  8031ad:	68 3f 3e 80 00       	push   $0x803e3f
  8031b2:	e8 ba d0 ff ff       	call   800271 <_panic>
  8031b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ba:	8b 00                	mov    (%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	74 10                	je     8031d0 <insert_sorted_with_merge_freeList+0x5d8>
  8031c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c8:	8b 52 04             	mov    0x4(%edx),%edx
  8031cb:	89 50 04             	mov    %edx,0x4(%eax)
  8031ce:	eb 0b                	jmp    8031db <insert_sorted_with_merge_freeList+0x5e3>
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	8b 40 04             	mov    0x4(%eax),%eax
  8031d6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031de:	8b 40 04             	mov    0x4(%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 0f                	je     8031f4 <insert_sorted_with_merge_freeList+0x5fc>
  8031e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e8:	8b 40 04             	mov    0x4(%eax),%eax
  8031eb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ee:	8b 12                	mov    (%edx),%edx
  8031f0:	89 10                	mov    %edx,(%eax)
  8031f2:	eb 0a                	jmp    8031fe <insert_sorted_with_merge_freeList+0x606>
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	8b 00                	mov    (%eax),%eax
  8031f9:	a3 38 41 80 00       	mov    %eax,0x804138
  8031fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803211:	a1 44 41 80 00       	mov    0x804144,%eax
  803216:	48                   	dec    %eax
  803217:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803226:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803229:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803230:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803234:	75 17                	jne    80324d <insert_sorted_with_merge_freeList+0x655>
  803236:	83 ec 04             	sub    $0x4,%esp
  803239:	68 1c 3e 80 00       	push   $0x803e1c
  80323e:	68 6e 01 00 00       	push   $0x16e
  803243:	68 3f 3e 80 00       	push   $0x803e3f
  803248:	e8 24 d0 ff ff       	call   800271 <_panic>
  80324d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803256:	89 10                	mov    %edx,(%eax)
  803258:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	85 c0                	test   %eax,%eax
  80325f:	74 0d                	je     80326e <insert_sorted_with_merge_freeList+0x676>
  803261:	a1 48 41 80 00       	mov    0x804148,%eax
  803266:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803269:	89 50 04             	mov    %edx,0x4(%eax)
  80326c:	eb 08                	jmp    803276 <insert_sorted_with_merge_freeList+0x67e>
  80326e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803271:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803279:	a3 48 41 80 00       	mov    %eax,0x804148
  80327e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803281:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803288:	a1 54 41 80 00       	mov    0x804154,%eax
  80328d:	40                   	inc    %eax
  80328e:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803293:	e9 a9 00 00 00       	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803298:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329c:	74 06                	je     8032a4 <insert_sorted_with_merge_freeList+0x6ac>
  80329e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a2:	75 17                	jne    8032bb <insert_sorted_with_merge_freeList+0x6c3>
  8032a4:	83 ec 04             	sub    $0x4,%esp
  8032a7:	68 b4 3e 80 00       	push   $0x803eb4
  8032ac:	68 73 01 00 00       	push   $0x173
  8032b1:	68 3f 3e 80 00       	push   $0x803e3f
  8032b6:	e8 b6 cf ff ff       	call   800271 <_panic>
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 10                	mov    (%eax),%edx
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	89 10                	mov    %edx,(%eax)
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	74 0b                	je     8032d9 <insert_sorted_with_merge_freeList+0x6e1>
  8032ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d6:	89 50 04             	mov    %edx,0x4(%eax)
  8032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032df:	89 10                	mov    %edx,(%eax)
  8032e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	8b 00                	mov    (%eax),%eax
  8032ef:	85 c0                	test   %eax,%eax
  8032f1:	75 08                	jne    8032fb <insert_sorted_with_merge_freeList+0x703>
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032fb:	a1 44 41 80 00       	mov    0x804144,%eax
  803300:	40                   	inc    %eax
  803301:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803306:	eb 39                	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803308:	a1 40 41 80 00       	mov    0x804140,%eax
  80330d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803310:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803314:	74 07                	je     80331d <insert_sorted_with_merge_freeList+0x725>
  803316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803319:	8b 00                	mov    (%eax),%eax
  80331b:	eb 05                	jmp    803322 <insert_sorted_with_merge_freeList+0x72a>
  80331d:	b8 00 00 00 00       	mov    $0x0,%eax
  803322:	a3 40 41 80 00       	mov    %eax,0x804140
  803327:	a1 40 41 80 00       	mov    0x804140,%eax
  80332c:	85 c0                	test   %eax,%eax
  80332e:	0f 85 c7 fb ff ff    	jne    802efb <insert_sorted_with_merge_freeList+0x303>
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	0f 85 bd fb ff ff    	jne    802efb <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80333e:	eb 01                	jmp    803341 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803340:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803341:	90                   	nop
  803342:	c9                   	leave  
  803343:	c3                   	ret    

00803344 <__udivdi3>:
  803344:	55                   	push   %ebp
  803345:	57                   	push   %edi
  803346:	56                   	push   %esi
  803347:	53                   	push   %ebx
  803348:	83 ec 1c             	sub    $0x1c,%esp
  80334b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80334f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803353:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803357:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80335b:	89 ca                	mov    %ecx,%edx
  80335d:	89 f8                	mov    %edi,%eax
  80335f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803363:	85 f6                	test   %esi,%esi
  803365:	75 2d                	jne    803394 <__udivdi3+0x50>
  803367:	39 cf                	cmp    %ecx,%edi
  803369:	77 65                	ja     8033d0 <__udivdi3+0x8c>
  80336b:	89 fd                	mov    %edi,%ebp
  80336d:	85 ff                	test   %edi,%edi
  80336f:	75 0b                	jne    80337c <__udivdi3+0x38>
  803371:	b8 01 00 00 00       	mov    $0x1,%eax
  803376:	31 d2                	xor    %edx,%edx
  803378:	f7 f7                	div    %edi
  80337a:	89 c5                	mov    %eax,%ebp
  80337c:	31 d2                	xor    %edx,%edx
  80337e:	89 c8                	mov    %ecx,%eax
  803380:	f7 f5                	div    %ebp
  803382:	89 c1                	mov    %eax,%ecx
  803384:	89 d8                	mov    %ebx,%eax
  803386:	f7 f5                	div    %ebp
  803388:	89 cf                	mov    %ecx,%edi
  80338a:	89 fa                	mov    %edi,%edx
  80338c:	83 c4 1c             	add    $0x1c,%esp
  80338f:	5b                   	pop    %ebx
  803390:	5e                   	pop    %esi
  803391:	5f                   	pop    %edi
  803392:	5d                   	pop    %ebp
  803393:	c3                   	ret    
  803394:	39 ce                	cmp    %ecx,%esi
  803396:	77 28                	ja     8033c0 <__udivdi3+0x7c>
  803398:	0f bd fe             	bsr    %esi,%edi
  80339b:	83 f7 1f             	xor    $0x1f,%edi
  80339e:	75 40                	jne    8033e0 <__udivdi3+0x9c>
  8033a0:	39 ce                	cmp    %ecx,%esi
  8033a2:	72 0a                	jb     8033ae <__udivdi3+0x6a>
  8033a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033a8:	0f 87 9e 00 00 00    	ja     80344c <__udivdi3+0x108>
  8033ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8033b3:	89 fa                	mov    %edi,%edx
  8033b5:	83 c4 1c             	add    $0x1c,%esp
  8033b8:	5b                   	pop    %ebx
  8033b9:	5e                   	pop    %esi
  8033ba:	5f                   	pop    %edi
  8033bb:	5d                   	pop    %ebp
  8033bc:	c3                   	ret    
  8033bd:	8d 76 00             	lea    0x0(%esi),%esi
  8033c0:	31 ff                	xor    %edi,%edi
  8033c2:	31 c0                	xor    %eax,%eax
  8033c4:	89 fa                	mov    %edi,%edx
  8033c6:	83 c4 1c             	add    $0x1c,%esp
  8033c9:	5b                   	pop    %ebx
  8033ca:	5e                   	pop    %esi
  8033cb:	5f                   	pop    %edi
  8033cc:	5d                   	pop    %ebp
  8033cd:	c3                   	ret    
  8033ce:	66 90                	xchg   %ax,%ax
  8033d0:	89 d8                	mov    %ebx,%eax
  8033d2:	f7 f7                	div    %edi
  8033d4:	31 ff                	xor    %edi,%edi
  8033d6:	89 fa                	mov    %edi,%edx
  8033d8:	83 c4 1c             	add    $0x1c,%esp
  8033db:	5b                   	pop    %ebx
  8033dc:	5e                   	pop    %esi
  8033dd:	5f                   	pop    %edi
  8033de:	5d                   	pop    %ebp
  8033df:	c3                   	ret    
  8033e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033e5:	89 eb                	mov    %ebp,%ebx
  8033e7:	29 fb                	sub    %edi,%ebx
  8033e9:	89 f9                	mov    %edi,%ecx
  8033eb:	d3 e6                	shl    %cl,%esi
  8033ed:	89 c5                	mov    %eax,%ebp
  8033ef:	88 d9                	mov    %bl,%cl
  8033f1:	d3 ed                	shr    %cl,%ebp
  8033f3:	89 e9                	mov    %ebp,%ecx
  8033f5:	09 f1                	or     %esi,%ecx
  8033f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033fb:	89 f9                	mov    %edi,%ecx
  8033fd:	d3 e0                	shl    %cl,%eax
  8033ff:	89 c5                	mov    %eax,%ebp
  803401:	89 d6                	mov    %edx,%esi
  803403:	88 d9                	mov    %bl,%cl
  803405:	d3 ee                	shr    %cl,%esi
  803407:	89 f9                	mov    %edi,%ecx
  803409:	d3 e2                	shl    %cl,%edx
  80340b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80340f:	88 d9                	mov    %bl,%cl
  803411:	d3 e8                	shr    %cl,%eax
  803413:	09 c2                	or     %eax,%edx
  803415:	89 d0                	mov    %edx,%eax
  803417:	89 f2                	mov    %esi,%edx
  803419:	f7 74 24 0c          	divl   0xc(%esp)
  80341d:	89 d6                	mov    %edx,%esi
  80341f:	89 c3                	mov    %eax,%ebx
  803421:	f7 e5                	mul    %ebp
  803423:	39 d6                	cmp    %edx,%esi
  803425:	72 19                	jb     803440 <__udivdi3+0xfc>
  803427:	74 0b                	je     803434 <__udivdi3+0xf0>
  803429:	89 d8                	mov    %ebx,%eax
  80342b:	31 ff                	xor    %edi,%edi
  80342d:	e9 58 ff ff ff       	jmp    80338a <__udivdi3+0x46>
  803432:	66 90                	xchg   %ax,%ax
  803434:	8b 54 24 08          	mov    0x8(%esp),%edx
  803438:	89 f9                	mov    %edi,%ecx
  80343a:	d3 e2                	shl    %cl,%edx
  80343c:	39 c2                	cmp    %eax,%edx
  80343e:	73 e9                	jae    803429 <__udivdi3+0xe5>
  803440:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803443:	31 ff                	xor    %edi,%edi
  803445:	e9 40 ff ff ff       	jmp    80338a <__udivdi3+0x46>
  80344a:	66 90                	xchg   %ax,%ax
  80344c:	31 c0                	xor    %eax,%eax
  80344e:	e9 37 ff ff ff       	jmp    80338a <__udivdi3+0x46>
  803453:	90                   	nop

00803454 <__umoddi3>:
  803454:	55                   	push   %ebp
  803455:	57                   	push   %edi
  803456:	56                   	push   %esi
  803457:	53                   	push   %ebx
  803458:	83 ec 1c             	sub    $0x1c,%esp
  80345b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80345f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803463:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803467:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80346b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80346f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803473:	89 f3                	mov    %esi,%ebx
  803475:	89 fa                	mov    %edi,%edx
  803477:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80347b:	89 34 24             	mov    %esi,(%esp)
  80347e:	85 c0                	test   %eax,%eax
  803480:	75 1a                	jne    80349c <__umoddi3+0x48>
  803482:	39 f7                	cmp    %esi,%edi
  803484:	0f 86 a2 00 00 00    	jbe    80352c <__umoddi3+0xd8>
  80348a:	89 c8                	mov    %ecx,%eax
  80348c:	89 f2                	mov    %esi,%edx
  80348e:	f7 f7                	div    %edi
  803490:	89 d0                	mov    %edx,%eax
  803492:	31 d2                	xor    %edx,%edx
  803494:	83 c4 1c             	add    $0x1c,%esp
  803497:	5b                   	pop    %ebx
  803498:	5e                   	pop    %esi
  803499:	5f                   	pop    %edi
  80349a:	5d                   	pop    %ebp
  80349b:	c3                   	ret    
  80349c:	39 f0                	cmp    %esi,%eax
  80349e:	0f 87 ac 00 00 00    	ja     803550 <__umoddi3+0xfc>
  8034a4:	0f bd e8             	bsr    %eax,%ebp
  8034a7:	83 f5 1f             	xor    $0x1f,%ebp
  8034aa:	0f 84 ac 00 00 00    	je     80355c <__umoddi3+0x108>
  8034b0:	bf 20 00 00 00       	mov    $0x20,%edi
  8034b5:	29 ef                	sub    %ebp,%edi
  8034b7:	89 fe                	mov    %edi,%esi
  8034b9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034bd:	89 e9                	mov    %ebp,%ecx
  8034bf:	d3 e0                	shl    %cl,%eax
  8034c1:	89 d7                	mov    %edx,%edi
  8034c3:	89 f1                	mov    %esi,%ecx
  8034c5:	d3 ef                	shr    %cl,%edi
  8034c7:	09 c7                	or     %eax,%edi
  8034c9:	89 e9                	mov    %ebp,%ecx
  8034cb:	d3 e2                	shl    %cl,%edx
  8034cd:	89 14 24             	mov    %edx,(%esp)
  8034d0:	89 d8                	mov    %ebx,%eax
  8034d2:	d3 e0                	shl    %cl,%eax
  8034d4:	89 c2                	mov    %eax,%edx
  8034d6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034da:	d3 e0                	shl    %cl,%eax
  8034dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034e0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e4:	89 f1                	mov    %esi,%ecx
  8034e6:	d3 e8                	shr    %cl,%eax
  8034e8:	09 d0                	or     %edx,%eax
  8034ea:	d3 eb                	shr    %cl,%ebx
  8034ec:	89 da                	mov    %ebx,%edx
  8034ee:	f7 f7                	div    %edi
  8034f0:	89 d3                	mov    %edx,%ebx
  8034f2:	f7 24 24             	mull   (%esp)
  8034f5:	89 c6                	mov    %eax,%esi
  8034f7:	89 d1                	mov    %edx,%ecx
  8034f9:	39 d3                	cmp    %edx,%ebx
  8034fb:	0f 82 87 00 00 00    	jb     803588 <__umoddi3+0x134>
  803501:	0f 84 91 00 00 00    	je     803598 <__umoddi3+0x144>
  803507:	8b 54 24 04          	mov    0x4(%esp),%edx
  80350b:	29 f2                	sub    %esi,%edx
  80350d:	19 cb                	sbb    %ecx,%ebx
  80350f:	89 d8                	mov    %ebx,%eax
  803511:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803515:	d3 e0                	shl    %cl,%eax
  803517:	89 e9                	mov    %ebp,%ecx
  803519:	d3 ea                	shr    %cl,%edx
  80351b:	09 d0                	or     %edx,%eax
  80351d:	89 e9                	mov    %ebp,%ecx
  80351f:	d3 eb                	shr    %cl,%ebx
  803521:	89 da                	mov    %ebx,%edx
  803523:	83 c4 1c             	add    $0x1c,%esp
  803526:	5b                   	pop    %ebx
  803527:	5e                   	pop    %esi
  803528:	5f                   	pop    %edi
  803529:	5d                   	pop    %ebp
  80352a:	c3                   	ret    
  80352b:	90                   	nop
  80352c:	89 fd                	mov    %edi,%ebp
  80352e:	85 ff                	test   %edi,%edi
  803530:	75 0b                	jne    80353d <__umoddi3+0xe9>
  803532:	b8 01 00 00 00       	mov    $0x1,%eax
  803537:	31 d2                	xor    %edx,%edx
  803539:	f7 f7                	div    %edi
  80353b:	89 c5                	mov    %eax,%ebp
  80353d:	89 f0                	mov    %esi,%eax
  80353f:	31 d2                	xor    %edx,%edx
  803541:	f7 f5                	div    %ebp
  803543:	89 c8                	mov    %ecx,%eax
  803545:	f7 f5                	div    %ebp
  803547:	89 d0                	mov    %edx,%eax
  803549:	e9 44 ff ff ff       	jmp    803492 <__umoddi3+0x3e>
  80354e:	66 90                	xchg   %ax,%ax
  803550:	89 c8                	mov    %ecx,%eax
  803552:	89 f2                	mov    %esi,%edx
  803554:	83 c4 1c             	add    $0x1c,%esp
  803557:	5b                   	pop    %ebx
  803558:	5e                   	pop    %esi
  803559:	5f                   	pop    %edi
  80355a:	5d                   	pop    %ebp
  80355b:	c3                   	ret    
  80355c:	3b 04 24             	cmp    (%esp),%eax
  80355f:	72 06                	jb     803567 <__umoddi3+0x113>
  803561:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803565:	77 0f                	ja     803576 <__umoddi3+0x122>
  803567:	89 f2                	mov    %esi,%edx
  803569:	29 f9                	sub    %edi,%ecx
  80356b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80356f:	89 14 24             	mov    %edx,(%esp)
  803572:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803576:	8b 44 24 04          	mov    0x4(%esp),%eax
  80357a:	8b 14 24             	mov    (%esp),%edx
  80357d:	83 c4 1c             	add    $0x1c,%esp
  803580:	5b                   	pop    %ebx
  803581:	5e                   	pop    %esi
  803582:	5f                   	pop    %edi
  803583:	5d                   	pop    %ebp
  803584:	c3                   	ret    
  803585:	8d 76 00             	lea    0x0(%esi),%esi
  803588:	2b 04 24             	sub    (%esp),%eax
  80358b:	19 fa                	sbb    %edi,%edx
  80358d:	89 d1                	mov    %edx,%ecx
  80358f:	89 c6                	mov    %eax,%esi
  803591:	e9 71 ff ff ff       	jmp    803507 <__umoddi3+0xb3>
  803596:	66 90                	xchg   %ax,%ax
  803598:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80359c:	72 ea                	jb     803588 <__umoddi3+0x134>
  80359e:	89 d9                	mov    %ebx,%ecx
  8035a0:	e9 62 ff ff ff       	jmp    803507 <__umoddi3+0xb3>
