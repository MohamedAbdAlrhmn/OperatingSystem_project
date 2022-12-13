
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
  80008c:	68 80 35 80 00       	push   $0x803580
  800091:	6a 12                	push   $0x12
  800093:	68 9c 35 80 00       	push   $0x80359c
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
  8000aa:	e8 a4 19 00 00       	call   801a53 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 b7 35 80 00       	push   $0x8035b7
  8000b7:	50                   	push   %eax
  8000b8:	e8 f9 14 00 00       	call   8015b6 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 92 16 00 00       	call   80175a <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 bc 35 80 00       	push   $0x8035bc
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 14 15 00 00       	call   8015fa <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 e0 35 80 00       	push   $0x8035e0
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 5c 16 00 00       	call   80175a <sys_calculate_free_frames>
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
  80011c:	68 f8 35 80 00       	push   $0x8035f8
  800121:	6a 24                	push   $0x24
  800123:	68 9c 35 80 00       	push   $0x80359c
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 46 1a 00 00       	call   801b78 <inctst>

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
  80013b:	e8 fa 18 00 00       	call   801a3a <sys_getenvindex>
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
  8001a6:	e8 9c 16 00 00       	call   801847 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 9c 36 80 00       	push   $0x80369c
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
  8001d6:	68 c4 36 80 00       	push   $0x8036c4
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
  800207:	68 ec 36 80 00       	push   $0x8036ec
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 44 37 80 00       	push   $0x803744
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 9c 36 80 00       	push   $0x80369c
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 1c 16 00 00       	call   801861 <sys_enable_interrupt>

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
  800258:	e8 a9 17 00 00       	call   801a06 <sys_destroy_env>
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
  800269:	e8 fe 17 00 00       	call   801a6c <sys_exit_env>
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
  800292:	68 58 37 80 00       	push   $0x803758
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 5d 37 80 00       	push   $0x80375d
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
  8002cf:	68 79 37 80 00       	push   $0x803779
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
  8002fb:	68 7c 37 80 00       	push   $0x80377c
  800300:	6a 26                	push   $0x26
  800302:	68 c8 37 80 00       	push   $0x8037c8
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
  8003cd:	68 d4 37 80 00       	push   $0x8037d4
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 c8 37 80 00       	push   $0x8037c8
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
  80043d:	68 28 38 80 00       	push   $0x803828
  800442:	6a 44                	push   $0x44
  800444:	68 c8 37 80 00       	push   $0x8037c8
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
  800497:	e8 fd 11 00 00       	call   801699 <sys_cputs>
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
  80050e:	e8 86 11 00 00       	call   801699 <sys_cputs>
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
  800558:	e8 ea 12 00 00       	call   801847 <sys_disable_interrupt>
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
  800578:	e8 e4 12 00 00       	call   801861 <sys_enable_interrupt>
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
  8005c2:	e8 55 2d 00 00       	call   80331c <__udivdi3>
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
  800612:	e8 15 2e 00 00       	call   80342c <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 94 3a 80 00       	add    $0x803a94,%eax
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
  80076d:	8b 04 85 b8 3a 80 00 	mov    0x803ab8(,%eax,4),%eax
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
  80084e:	8b 34 9d 00 39 80 00 	mov    0x803900(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 a5 3a 80 00       	push   $0x803aa5
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
  800873:	68 ae 3a 80 00       	push   $0x803aae
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
  8008a0:	be b1 3a 80 00       	mov    $0x803ab1,%esi
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
  8012c6:	68 10 3c 80 00       	push   $0x803c10
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
  801396:	e8 42 04 00 00       	call   8017dd <sys_allocate_chunk>
  80139b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139e:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	50                   	push   %eax
  8013a7:	e8 b7 0a 00 00       	call   801e63 <initialize_MemBlocksList>
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
  8013d4:	68 35 3c 80 00       	push   $0x803c35
  8013d9:	6a 33                	push   $0x33
  8013db:	68 53 3c 80 00       	push   $0x803c53
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
  801453:	68 60 3c 80 00       	push   $0x803c60
  801458:	6a 34                	push   $0x34
  80145a:	68 53 3c 80 00       	push   $0x803c53
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
  8014c8:	68 84 3c 80 00       	push   $0x803c84
  8014cd:	6a 46                	push   $0x46
  8014cf:	68 53 3c 80 00       	push   $0x803c53
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
  8014e4:	68 ac 3c 80 00       	push   $0x803cac
  8014e9:	6a 61                	push   $0x61
  8014eb:	68 53 3c 80 00       	push   $0x803c53
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
  80150a:	75 0a                	jne    801516 <smalloc+0x21>
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	e9 9e 00 00 00       	jmp    8015b4 <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801516:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80151d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801523:	01 d0                	add    %edx,%eax
  801525:	48                   	dec    %eax
  801526:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152c:	ba 00 00 00 00       	mov    $0x0,%edx
  801531:	f7 75 f0             	divl   -0x10(%ebp)
  801534:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801537:	29 d0                	sub    %edx,%eax
  801539:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80153c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801543:	e8 63 06 00 00       	call   801bab <sys_isUHeapPlacementStrategyFIRSTFIT>
  801548:	85 c0                	test   %eax,%eax
  80154a:	74 11                	je     80155d <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80154c:	83 ec 0c             	sub    $0xc,%esp
  80154f:	ff 75 e8             	pushl  -0x18(%ebp)
  801552:	e8 ce 0c 00 00       	call   802225 <alloc_block_FF>
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80155d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801561:	74 4c                	je     8015af <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801566:	8b 40 08             	mov    0x8(%eax),%eax
  801569:	89 c2                	mov    %eax,%edx
  80156b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80156f:	52                   	push   %edx
  801570:	50                   	push   %eax
  801571:	ff 75 0c             	pushl  0xc(%ebp)
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 b4 03 00 00       	call   801930 <sys_createSharedObject>
  80157c:	83 c4 10             	add    $0x10,%esp
  80157f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	ff 75 e0             	pushl  -0x20(%ebp)
  801588:	68 cf 3c 80 00       	push   $0x803ccf
  80158d:	e8 93 ef ff ff       	call   800525 <cprintf>
  801592:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801595:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801599:	74 14                	je     8015af <smalloc+0xba>
  80159b:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80159f:	74 0e                	je     8015af <smalloc+0xba>
  8015a1:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8015a5:	74 08                	je     8015af <smalloc+0xba>
			return (void*) mem_block->sva;
  8015a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015aa:	8b 40 08             	mov    0x8(%eax),%eax
  8015ad:	eb 05                	jmp    8015b4 <smalloc+0xbf>
	}
	return NULL;
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015bc:	e8 ee fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	68 e4 3c 80 00       	push   $0x803ce4
  8015c9:	68 ab 00 00 00       	push   $0xab
  8015ce:	68 53 3c 80 00       	push   $0x803c53
  8015d3:	e8 99 ec ff ff       	call   800271 <_panic>

008015d8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015de:	e8 cc fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015e3:	83 ec 04             	sub    $0x4,%esp
  8015e6:	68 08 3d 80 00       	push   $0x803d08
  8015eb:	68 ef 00 00 00       	push   $0xef
  8015f0:	68 53 3c 80 00       	push   $0x803c53
  8015f5:	e8 77 ec ff ff       	call   800271 <_panic>

008015fa <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	68 30 3d 80 00       	push   $0x803d30
  801608:	68 03 01 00 00       	push   $0x103
  80160d:	68 53 3c 80 00       	push   $0x803c53
  801612:	e8 5a ec ff ff       	call   800271 <_panic>

00801617 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801617:	55                   	push   %ebp
  801618:	89 e5                	mov    %esp,%ebp
  80161a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80161d:	83 ec 04             	sub    $0x4,%esp
  801620:	68 54 3d 80 00       	push   $0x803d54
  801625:	68 0e 01 00 00       	push   $0x10e
  80162a:	68 53 3c 80 00       	push   $0x803c53
  80162f:	e8 3d ec ff ff       	call   800271 <_panic>

00801634 <shrink>:

}
void shrink(uint32 newSize)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	68 54 3d 80 00       	push   $0x803d54
  801642:	68 13 01 00 00       	push   $0x113
  801647:	68 53 3c 80 00       	push   $0x803c53
  80164c:	e8 20 ec ff ff       	call   800271 <_panic>

00801651 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801657:	83 ec 04             	sub    $0x4,%esp
  80165a:	68 54 3d 80 00       	push   $0x803d54
  80165f:	68 18 01 00 00       	push   $0x118
  801664:	68 53 3c 80 00       	push   $0x803c53
  801669:	e8 03 ec ff ff       	call   800271 <_panic>

0080166e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	57                   	push   %edi
  801672:	56                   	push   %esi
  801673:	53                   	push   %ebx
  801674:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801680:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801683:	8b 7d 18             	mov    0x18(%ebp),%edi
  801686:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801689:	cd 30                	int    $0x30
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801691:	83 c4 10             	add    $0x10,%esp
  801694:	5b                   	pop    %ebx
  801695:	5e                   	pop    %esi
  801696:	5f                   	pop    %edi
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    

00801699 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 04             	sub    $0x4,%esp
  80169f:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8016a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	52                   	push   %edx
  8016b1:	ff 75 0c             	pushl  0xc(%ebp)
  8016b4:	50                   	push   %eax
  8016b5:	6a 00                	push   $0x0
  8016b7:	e8 b2 ff ff ff       	call   80166e <syscall>
  8016bc:	83 c4 18             	add    $0x18,%esp
}
  8016bf:	90                   	nop
  8016c0:	c9                   	leave  
  8016c1:	c3                   	ret    

008016c2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 01                	push   $0x1
  8016d1:	e8 98 ff ff ff       	call   80166e <syscall>
  8016d6:	83 c4 18             	add    $0x18,%esp
}
  8016d9:	c9                   	leave  
  8016da:	c3                   	ret    

008016db <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	6a 00                	push   $0x0
  8016e6:	6a 00                	push   $0x0
  8016e8:	6a 00                	push   $0x0
  8016ea:	52                   	push   %edx
  8016eb:	50                   	push   %eax
  8016ec:	6a 05                	push   $0x5
  8016ee:	e8 7b ff ff ff       	call   80166e <syscall>
  8016f3:	83 c4 18             	add    $0x18,%esp
}
  8016f6:	c9                   	leave  
  8016f7:	c3                   	ret    

008016f8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	56                   	push   %esi
  8016fc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016fd:	8b 75 18             	mov    0x18(%ebp),%esi
  801700:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801703:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801706:	8b 55 0c             	mov    0xc(%ebp),%edx
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
  80170e:	51                   	push   %ecx
  80170f:	52                   	push   %edx
  801710:	50                   	push   %eax
  801711:	6a 06                	push   $0x6
  801713:	e8 56 ff ff ff       	call   80166e <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
}
  80171b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80171e:	5b                   	pop    %ebx
  80171f:	5e                   	pop    %esi
  801720:	5d                   	pop    %ebp
  801721:	c3                   	ret    

00801722 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801725:	8b 55 0c             	mov    0xc(%ebp),%edx
  801728:	8b 45 08             	mov    0x8(%ebp),%eax
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	52                   	push   %edx
  801732:	50                   	push   %eax
  801733:	6a 07                	push   $0x7
  801735:	e8 34 ff ff ff       	call   80166e <syscall>
  80173a:	83 c4 18             	add    $0x18,%esp
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	ff 75 08             	pushl  0x8(%ebp)
  80174e:	6a 08                	push   $0x8
  801750:	e8 19 ff ff ff       	call   80166e <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 09                	push   $0x9
  801769:	e8 00 ff ff ff       	call   80166e <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 00                	push   $0x0
  80177c:	6a 00                	push   $0x0
  80177e:	6a 00                	push   $0x0
  801780:	6a 0a                	push   $0xa
  801782:	e8 e7 fe ff ff       	call   80166e <syscall>
  801787:	83 c4 18             	add    $0x18,%esp
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 00                	push   $0x0
  801799:	6a 0b                	push   $0xb
  80179b:	e8 ce fe ff ff       	call   80166e <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	ff 75 0c             	pushl  0xc(%ebp)
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	6a 0f                	push   $0xf
  8017b6:	e8 b3 fe ff ff       	call   80166e <syscall>
  8017bb:	83 c4 18             	add    $0x18,%esp
	return;
  8017be:	90                   	nop
}
  8017bf:	c9                   	leave  
  8017c0:	c3                   	ret    

008017c1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	ff 75 0c             	pushl  0xc(%ebp)
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	6a 10                	push   $0x10
  8017d2:	e8 97 fe ff ff       	call   80166e <syscall>
  8017d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8017da:	90                   	nop
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	ff 75 10             	pushl  0x10(%ebp)
  8017e7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ea:	ff 75 08             	pushl  0x8(%ebp)
  8017ed:	6a 11                	push   $0x11
  8017ef:	e8 7a fe ff ff       	call   80166e <syscall>
  8017f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8017f7:	90                   	nop
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 00                	push   $0x0
  801807:	6a 0c                	push   $0xc
  801809:	e8 60 fe ff ff       	call   80166e <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	6a 0d                	push   $0xd
  801823:	e8 46 fe ff ff       	call   80166e <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 0e                	push   $0xe
  80183c:	e8 2d fe ff ff       	call   80166e <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 13                	push   $0x13
  801856:	e8 13 fe ff ff       	call   80166e <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	90                   	nop
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 14                	push   $0x14
  801870:	e8 f9 fd ff ff       	call   80166e <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	90                   	nop
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_cputc>:


void
sys_cputc(const char c)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801887:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	50                   	push   %eax
  801894:	6a 15                	push   $0x15
  801896:	e8 d3 fd ff ff       	call   80166e <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	90                   	nop
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 16                	push   $0x16
  8018b0:	e8 b9 fd ff ff       	call   80166e <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	90                   	nop
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	50                   	push   %eax
  8018cb:	6a 17                	push   $0x17
  8018cd:	e8 9c fd ff ff       	call   80166e <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	52                   	push   %edx
  8018e7:	50                   	push   %eax
  8018e8:	6a 1a                	push   $0x1a
  8018ea:	e8 7f fd ff ff       	call   80166e <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	52                   	push   %edx
  801904:	50                   	push   %eax
  801905:	6a 18                	push   $0x18
  801907:	e8 62 fd ff ff       	call   80166e <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	90                   	nop
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801915:	8b 55 0c             	mov    0xc(%ebp),%edx
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	52                   	push   %edx
  801922:	50                   	push   %eax
  801923:	6a 19                	push   $0x19
  801925:	e8 44 fd ff ff       	call   80166e <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	90                   	nop
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	83 ec 04             	sub    $0x4,%esp
  801936:	8b 45 10             	mov    0x10(%ebp),%eax
  801939:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80193c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80193f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	6a 00                	push   $0x0
  801948:	51                   	push   %ecx
  801949:	52                   	push   %edx
  80194a:	ff 75 0c             	pushl  0xc(%ebp)
  80194d:	50                   	push   %eax
  80194e:	6a 1b                	push   $0x1b
  801950:	e8 19 fd ff ff       	call   80166e <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80195d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	52                   	push   %edx
  80196a:	50                   	push   %eax
  80196b:	6a 1c                	push   $0x1c
  80196d:	e8 fc fc ff ff       	call   80166e <syscall>
  801972:	83 c4 18             	add    $0x18,%esp
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80197a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	51                   	push   %ecx
  801988:	52                   	push   %edx
  801989:	50                   	push   %eax
  80198a:	6a 1d                	push   $0x1d
  80198c:	e8 dd fc ff ff       	call   80166e <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	52                   	push   %edx
  8019a6:	50                   	push   %eax
  8019a7:	6a 1e                	push   $0x1e
  8019a9:	e8 c0 fc ff ff       	call   80166e <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 1f                	push   $0x1f
  8019c2:	e8 a7 fc ff ff       	call   80166e <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	6a 00                	push   $0x0
  8019d4:	ff 75 14             	pushl  0x14(%ebp)
  8019d7:	ff 75 10             	pushl  0x10(%ebp)
  8019da:	ff 75 0c             	pushl  0xc(%ebp)
  8019dd:	50                   	push   %eax
  8019de:	6a 20                	push   $0x20
  8019e0:	e8 89 fc ff ff       	call   80166e <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	50                   	push   %eax
  8019f9:	6a 21                	push   $0x21
  8019fb:	e8 6e fc ff ff       	call   80166e <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	50                   	push   %eax
  801a15:	6a 22                	push   $0x22
  801a17:	e8 52 fc ff ff       	call   80166e <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 02                	push   $0x2
  801a30:	e8 39 fc ff ff       	call   80166e <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 03                	push   $0x3
  801a49:	e8 20 fc ff ff       	call   80166e <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 04                	push   $0x4
  801a62:	e8 07 fc ff ff       	call   80166e <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_exit_env>:


void sys_exit_env(void)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 23                	push   $0x23
  801a7b:	e8 ee fb ff ff       	call   80166e <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a8c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a8f:	8d 50 04             	lea    0x4(%eax),%edx
  801a92:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	52                   	push   %edx
  801a9c:	50                   	push   %eax
  801a9d:	6a 24                	push   $0x24
  801a9f:	e8 ca fb ff ff       	call   80166e <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
	return result;
  801aa7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801aaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab0:	89 01                	mov    %eax,(%ecx)
  801ab2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab8:	c9                   	leave  
  801ab9:	c2 04 00             	ret    $0x4

00801abc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	ff 75 10             	pushl  0x10(%ebp)
  801ac6:	ff 75 0c             	pushl  0xc(%ebp)
  801ac9:	ff 75 08             	pushl  0x8(%ebp)
  801acc:	6a 12                	push   $0x12
  801ace:	e8 9b fb ff ff       	call   80166e <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ad6:	90                   	nop
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 25                	push   $0x25
  801ae8:	e8 81 fb ff ff       	call   80166e <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801afe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	50                   	push   %eax
  801b0b:	6a 26                	push   $0x26
  801b0d:	e8 5c fb ff ff       	call   80166e <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
	return ;
  801b15:	90                   	nop
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <rsttst>:
void rsttst()
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 28                	push   $0x28
  801b27:	e8 42 fb ff ff       	call   80166e <syscall>
  801b2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2f:	90                   	nop
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 04             	sub    $0x4,%esp
  801b38:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b3e:	8b 55 18             	mov    0x18(%ebp),%edx
  801b41:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	ff 75 10             	pushl  0x10(%ebp)
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	ff 75 08             	pushl  0x8(%ebp)
  801b50:	6a 27                	push   $0x27
  801b52:	e8 17 fb ff ff       	call   80166e <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5a:	90                   	nop
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <chktst>:
void chktst(uint32 n)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	6a 29                	push   $0x29
  801b6d:	e8 fc fa ff ff       	call   80166e <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <inctst>:

void inctst()
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 2a                	push   $0x2a
  801b87:	e8 e2 fa ff ff       	call   80166e <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8f:	90                   	nop
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <gettst>:
uint32 gettst()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 2b                	push   $0x2b
  801ba1:	e8 c8 fa ff ff       	call   80166e <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 2c                	push   $0x2c
  801bbd:	e8 ac fa ff ff       	call   80166e <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
  801bc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bc8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bcc:	75 07                	jne    801bd5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bce:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd3:	eb 05                	jmp    801bda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 2c                	push   $0x2c
  801bee:	e8 7b fa ff ff       	call   80166e <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
  801bf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801bf9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801bfd:	75 07                	jne    801c06 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801bff:	b8 01 00 00 00       	mov    $0x1,%eax
  801c04:	eb 05                	jmp    801c0b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 2c                	push   $0x2c
  801c1f:	e8 4a fa ff ff       	call   80166e <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
  801c27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c2a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c2e:	75 07                	jne    801c37 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c30:	b8 01 00 00 00       	mov    $0x1,%eax
  801c35:	eb 05                	jmp    801c3c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 2c                	push   $0x2c
  801c50:	e8 19 fa ff ff       	call   80166e <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
  801c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c5b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c5f:	75 07                	jne    801c68 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c61:	b8 01 00 00 00       	mov    $0x1,%eax
  801c66:	eb 05                	jmp    801c6d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	6a 2d                	push   $0x2d
  801c7f:	e8 ea f9 ff ff       	call   80166e <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
	return ;
  801c87:	90                   	nop
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c8e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	53                   	push   %ebx
  801c9d:	51                   	push   %ecx
  801c9e:	52                   	push   %edx
  801c9f:	50                   	push   %eax
  801ca0:	6a 2e                	push   $0x2e
  801ca2:	e8 c7 f9 ff ff       	call   80166e <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 2f                	push   $0x2f
  801cc2:	e8 a7 f9 ff ff       	call   80166e <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cd2:	83 ec 0c             	sub    $0xc,%esp
  801cd5:	68 64 3d 80 00       	push   $0x803d64
  801cda:	e8 46 e8 ff ff       	call   800525 <cprintf>
  801cdf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ce2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ce9:	83 ec 0c             	sub    $0xc,%esp
  801cec:	68 90 3d 80 00       	push   $0x803d90
  801cf1:	e8 2f e8 ff ff       	call   800525 <cprintf>
  801cf6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801cf9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cfd:	a1 38 41 80 00       	mov    0x804138,%eax
  801d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d05:	eb 56                	jmp    801d5d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d0b:	74 1c                	je     801d29 <print_mem_block_lists+0x5d>
  801d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d10:	8b 50 08             	mov    0x8(%eax),%edx
  801d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d16:	8b 48 08             	mov    0x8(%eax),%ecx
  801d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1f:	01 c8                	add    %ecx,%eax
  801d21:	39 c2                	cmp    %eax,%edx
  801d23:	73 04                	jae    801d29 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d25:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2c:	8b 50 08             	mov    0x8(%eax),%edx
  801d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d32:	8b 40 0c             	mov    0xc(%eax),%eax
  801d35:	01 c2                	add    %eax,%edx
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3a:	8b 40 08             	mov    0x8(%eax),%eax
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	52                   	push   %edx
  801d41:	50                   	push   %eax
  801d42:	68 a5 3d 80 00       	push   $0x803da5
  801d47:	e8 d9 e7 ff ff       	call   800525 <cprintf>
  801d4c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d55:	a1 40 41 80 00       	mov    0x804140,%eax
  801d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d61:	74 07                	je     801d6a <print_mem_block_lists+0x9e>
  801d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d66:	8b 00                	mov    (%eax),%eax
  801d68:	eb 05                	jmp    801d6f <print_mem_block_lists+0xa3>
  801d6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6f:	a3 40 41 80 00       	mov    %eax,0x804140
  801d74:	a1 40 41 80 00       	mov    0x804140,%eax
  801d79:	85 c0                	test   %eax,%eax
  801d7b:	75 8a                	jne    801d07 <print_mem_block_lists+0x3b>
  801d7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d81:	75 84                	jne    801d07 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d83:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d87:	75 10                	jne    801d99 <print_mem_block_lists+0xcd>
  801d89:	83 ec 0c             	sub    $0xc,%esp
  801d8c:	68 b4 3d 80 00       	push   $0x803db4
  801d91:	e8 8f e7 ff ff       	call   800525 <cprintf>
  801d96:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d99:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801da0:	83 ec 0c             	sub    $0xc,%esp
  801da3:	68 d8 3d 80 00       	push   $0x803dd8
  801da8:	e8 78 e7 ff ff       	call   800525 <cprintf>
  801dad:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801db0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801db4:	a1 40 40 80 00       	mov    0x804040,%eax
  801db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dbc:	eb 56                	jmp    801e14 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801dbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc2:	74 1c                	je     801de0 <print_mem_block_lists+0x114>
  801dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc7:	8b 50 08             	mov    0x8(%eax),%edx
  801dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcd:	8b 48 08             	mov    0x8(%eax),%ecx
  801dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd6:	01 c8                	add    %ecx,%eax
  801dd8:	39 c2                	cmp    %eax,%edx
  801dda:	73 04                	jae    801de0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ddc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de3:	8b 50 08             	mov    0x8(%eax),%edx
  801de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dec:	01 c2                	add    %eax,%edx
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	8b 40 08             	mov    0x8(%eax),%eax
  801df4:	83 ec 04             	sub    $0x4,%esp
  801df7:	52                   	push   %edx
  801df8:	50                   	push   %eax
  801df9:	68 a5 3d 80 00       	push   $0x803da5
  801dfe:	e8 22 e7 ff ff       	call   800525 <cprintf>
  801e03:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e0c:	a1 48 40 80 00       	mov    0x804048,%eax
  801e11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e18:	74 07                	je     801e21 <print_mem_block_lists+0x155>
  801e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1d:	8b 00                	mov    (%eax),%eax
  801e1f:	eb 05                	jmp    801e26 <print_mem_block_lists+0x15a>
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
  801e26:	a3 48 40 80 00       	mov    %eax,0x804048
  801e2b:	a1 48 40 80 00       	mov    0x804048,%eax
  801e30:	85 c0                	test   %eax,%eax
  801e32:	75 8a                	jne    801dbe <print_mem_block_lists+0xf2>
  801e34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e38:	75 84                	jne    801dbe <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e3a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e3e:	75 10                	jne    801e50 <print_mem_block_lists+0x184>
  801e40:	83 ec 0c             	sub    $0xc,%esp
  801e43:	68 f0 3d 80 00       	push   $0x803df0
  801e48:	e8 d8 e6 ff ff       	call   800525 <cprintf>
  801e4d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	68 64 3d 80 00       	push   $0x803d64
  801e58:	e8 c8 e6 ff ff       	call   800525 <cprintf>
  801e5d:	83 c4 10             	add    $0x10,%esp

}
  801e60:	90                   	nop
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e69:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e70:	00 00 00 
  801e73:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e7a:	00 00 00 
  801e7d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e84:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e8e:	e9 9e 00 00 00       	jmp    801f31 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e93:	a1 50 40 80 00       	mov    0x804050,%eax
  801e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e9b:	c1 e2 04             	shl    $0x4,%edx
  801e9e:	01 d0                	add    %edx,%eax
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	75 14                	jne    801eb8 <initialize_MemBlocksList+0x55>
  801ea4:	83 ec 04             	sub    $0x4,%esp
  801ea7:	68 18 3e 80 00       	push   $0x803e18
  801eac:	6a 46                	push   $0x46
  801eae:	68 3b 3e 80 00       	push   $0x803e3b
  801eb3:	e8 b9 e3 ff ff       	call   800271 <_panic>
  801eb8:	a1 50 40 80 00       	mov    0x804050,%eax
  801ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec0:	c1 e2 04             	shl    $0x4,%edx
  801ec3:	01 d0                	add    %edx,%eax
  801ec5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ecb:	89 10                	mov    %edx,(%eax)
  801ecd:	8b 00                	mov    (%eax),%eax
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	74 18                	je     801eeb <initialize_MemBlocksList+0x88>
  801ed3:	a1 48 41 80 00       	mov    0x804148,%eax
  801ed8:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801ede:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ee1:	c1 e1 04             	shl    $0x4,%ecx
  801ee4:	01 ca                	add    %ecx,%edx
  801ee6:	89 50 04             	mov    %edx,0x4(%eax)
  801ee9:	eb 12                	jmp    801efd <initialize_MemBlocksList+0x9a>
  801eeb:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef3:	c1 e2 04             	shl    $0x4,%edx
  801ef6:	01 d0                	add    %edx,%eax
  801ef8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801efd:	a1 50 40 80 00       	mov    0x804050,%eax
  801f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f05:	c1 e2 04             	shl    $0x4,%edx
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	a3 48 41 80 00       	mov    %eax,0x804148
  801f0f:	a1 50 40 80 00       	mov    0x804050,%eax
  801f14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f17:	c1 e2 04             	shl    $0x4,%edx
  801f1a:	01 d0                	add    %edx,%eax
  801f1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f23:	a1 54 41 80 00       	mov    0x804154,%eax
  801f28:	40                   	inc    %eax
  801f29:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f2e:	ff 45 f4             	incl   -0xc(%ebp)
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f37:	0f 82 56 ff ff ff    	jb     801e93 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f3d:	90                   	nop
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	8b 00                	mov    (%eax),%eax
  801f4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f4e:	eb 19                	jmp    801f69 <find_block+0x29>
	{
		if(va==point->sva)
  801f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f53:	8b 40 08             	mov    0x8(%eax),%eax
  801f56:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f59:	75 05                	jne    801f60 <find_block+0x20>
		   return point;
  801f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5e:	eb 36                	jmp    801f96 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	8b 40 08             	mov    0x8(%eax),%eax
  801f66:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f69:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f6d:	74 07                	je     801f76 <find_block+0x36>
  801f6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f72:	8b 00                	mov    (%eax),%eax
  801f74:	eb 05                	jmp    801f7b <find_block+0x3b>
  801f76:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f7e:	89 42 08             	mov    %eax,0x8(%edx)
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	8b 40 08             	mov    0x8(%eax),%eax
  801f87:	85 c0                	test   %eax,%eax
  801f89:	75 c5                	jne    801f50 <find_block+0x10>
  801f8b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f8f:	75 bf                	jne    801f50 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f9e:	a1 40 40 80 00       	mov    0x804040,%eax
  801fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801fa6:	a1 44 40 80 00       	mov    0x804044,%eax
  801fab:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fb4:	74 24                	je     801fda <insert_sorted_allocList+0x42>
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	8b 50 08             	mov    0x8(%eax),%edx
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbf:	8b 40 08             	mov    0x8(%eax),%eax
  801fc2:	39 c2                	cmp    %eax,%edx
  801fc4:	76 14                	jbe    801fda <insert_sorted_allocList+0x42>
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	8b 50 08             	mov    0x8(%eax),%edx
  801fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fcf:	8b 40 08             	mov    0x8(%eax),%eax
  801fd2:	39 c2                	cmp    %eax,%edx
  801fd4:	0f 82 60 01 00 00    	jb     80213a <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fde:	75 65                	jne    802045 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fe0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fe4:	75 14                	jne    801ffa <insert_sorted_allocList+0x62>
  801fe6:	83 ec 04             	sub    $0x4,%esp
  801fe9:	68 18 3e 80 00       	push   $0x803e18
  801fee:	6a 6b                	push   $0x6b
  801ff0:	68 3b 3e 80 00       	push   $0x803e3b
  801ff5:	e8 77 e2 ff ff       	call   800271 <_panic>
  801ffa:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	89 10                	mov    %edx,(%eax)
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	8b 00                	mov    (%eax),%eax
  80200a:	85 c0                	test   %eax,%eax
  80200c:	74 0d                	je     80201b <insert_sorted_allocList+0x83>
  80200e:	a1 40 40 80 00       	mov    0x804040,%eax
  802013:	8b 55 08             	mov    0x8(%ebp),%edx
  802016:	89 50 04             	mov    %edx,0x4(%eax)
  802019:	eb 08                	jmp    802023 <insert_sorted_allocList+0x8b>
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	a3 44 40 80 00       	mov    %eax,0x804044
  802023:	8b 45 08             	mov    0x8(%ebp),%eax
  802026:	a3 40 40 80 00       	mov    %eax,0x804040
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802035:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80203a:	40                   	inc    %eax
  80203b:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802040:	e9 dc 01 00 00       	jmp    802221 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	8b 50 08             	mov    0x8(%eax),%edx
  80204b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204e:	8b 40 08             	mov    0x8(%eax),%eax
  802051:	39 c2                	cmp    %eax,%edx
  802053:	77 6c                	ja     8020c1 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802055:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802059:	74 06                	je     802061 <insert_sorted_allocList+0xc9>
  80205b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80205f:	75 14                	jne    802075 <insert_sorted_allocList+0xdd>
  802061:	83 ec 04             	sub    $0x4,%esp
  802064:	68 54 3e 80 00       	push   $0x803e54
  802069:	6a 6f                	push   $0x6f
  80206b:	68 3b 3e 80 00       	push   $0x803e3b
  802070:	e8 fc e1 ff ff       	call   800271 <_panic>
  802075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802078:	8b 50 04             	mov    0x4(%eax),%edx
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	89 50 04             	mov    %edx,0x4(%eax)
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802087:	89 10                	mov    %edx,(%eax)
  802089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208c:	8b 40 04             	mov    0x4(%eax),%eax
  80208f:	85 c0                	test   %eax,%eax
  802091:	74 0d                	je     8020a0 <insert_sorted_allocList+0x108>
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802096:	8b 40 04             	mov    0x4(%eax),%eax
  802099:	8b 55 08             	mov    0x8(%ebp),%edx
  80209c:	89 10                	mov    %edx,(%eax)
  80209e:	eb 08                	jmp    8020a8 <insert_sorted_allocList+0x110>
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	a3 40 40 80 00       	mov    %eax,0x804040
  8020a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ae:	89 50 04             	mov    %edx,0x4(%eax)
  8020b1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020b6:	40                   	inc    %eax
  8020b7:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020bc:	e9 60 01 00 00       	jmp    802221 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	8b 50 08             	mov    0x8(%eax),%edx
  8020c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ca:	8b 40 08             	mov    0x8(%eax),%eax
  8020cd:	39 c2                	cmp    %eax,%edx
  8020cf:	0f 82 4c 01 00 00    	jb     802221 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020d9:	75 14                	jne    8020ef <insert_sorted_allocList+0x157>
  8020db:	83 ec 04             	sub    $0x4,%esp
  8020de:	68 8c 3e 80 00       	push   $0x803e8c
  8020e3:	6a 73                	push   $0x73
  8020e5:	68 3b 3e 80 00       	push   $0x803e3b
  8020ea:	e8 82 e1 ff ff       	call   800271 <_panic>
  8020ef:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f8:	89 50 04             	mov    %edx,0x4(%eax)
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	8b 40 04             	mov    0x4(%eax),%eax
  802101:	85 c0                	test   %eax,%eax
  802103:	74 0c                	je     802111 <insert_sorted_allocList+0x179>
  802105:	a1 44 40 80 00       	mov    0x804044,%eax
  80210a:	8b 55 08             	mov    0x8(%ebp),%edx
  80210d:	89 10                	mov    %edx,(%eax)
  80210f:	eb 08                	jmp    802119 <insert_sorted_allocList+0x181>
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	a3 40 40 80 00       	mov    %eax,0x804040
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	a3 44 40 80 00       	mov    %eax,0x804044
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80212a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80212f:	40                   	inc    %eax
  802130:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802135:	e9 e7 00 00 00       	jmp    802221 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80213a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802140:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802147:	a1 40 40 80 00       	mov    0x804040,%eax
  80214c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214f:	e9 9d 00 00 00       	jmp    8021f1 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 00                	mov    (%eax),%eax
  802159:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	8b 50 08             	mov    0x8(%eax),%edx
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	8b 40 08             	mov    0x8(%eax),%eax
  802168:	39 c2                	cmp    %eax,%edx
  80216a:	76 7d                	jbe    8021e9 <insert_sorted_allocList+0x251>
  80216c:	8b 45 08             	mov    0x8(%ebp),%eax
  80216f:	8b 50 08             	mov    0x8(%eax),%edx
  802172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802175:	8b 40 08             	mov    0x8(%eax),%eax
  802178:	39 c2                	cmp    %eax,%edx
  80217a:	73 6d                	jae    8021e9 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80217c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802180:	74 06                	je     802188 <insert_sorted_allocList+0x1f0>
  802182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802186:	75 14                	jne    80219c <insert_sorted_allocList+0x204>
  802188:	83 ec 04             	sub    $0x4,%esp
  80218b:	68 b0 3e 80 00       	push   $0x803eb0
  802190:	6a 7f                	push   $0x7f
  802192:	68 3b 3e 80 00       	push   $0x803e3b
  802197:	e8 d5 e0 ff ff       	call   800271 <_panic>
  80219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219f:	8b 10                	mov    (%eax),%edx
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	89 10                	mov    %edx,(%eax)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 00                	mov    (%eax),%eax
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	74 0b                	je     8021ba <insert_sorted_allocList+0x222>
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c0:	89 10                	mov    %edx,(%eax)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c8:	89 50 04             	mov    %edx,0x4(%eax)
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	8b 00                	mov    (%eax),%eax
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	75 08                	jne    8021dc <insert_sorted_allocList+0x244>
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	a3 44 40 80 00       	mov    %eax,0x804044
  8021dc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e1:	40                   	inc    %eax
  8021e2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021e7:	eb 39                	jmp    802222 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021e9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f5:	74 07                	je     8021fe <insert_sorted_allocList+0x266>
  8021f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	eb 05                	jmp    802203 <insert_sorted_allocList+0x26b>
  8021fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802203:	a3 48 40 80 00       	mov    %eax,0x804048
  802208:	a1 48 40 80 00       	mov    0x804048,%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	0f 85 3f ff ff ff    	jne    802154 <insert_sorted_allocList+0x1bc>
  802215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802219:	0f 85 35 ff ff ff    	jne    802154 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80221f:	eb 01                	jmp    802222 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802221:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802222:	90                   	nop
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80222b:	a1 38 41 80 00       	mov    0x804138,%eax
  802230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802233:	e9 85 01 00 00       	jmp    8023bd <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 40 0c             	mov    0xc(%eax),%eax
  80223e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802241:	0f 82 6e 01 00 00    	jb     8023b5 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 40 0c             	mov    0xc(%eax),%eax
  80224d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802250:	0f 85 8a 00 00 00    	jne    8022e0 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225a:	75 17                	jne    802273 <alloc_block_FF+0x4e>
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	68 e4 3e 80 00       	push   $0x803ee4
  802264:	68 93 00 00 00       	push   $0x93
  802269:	68 3b 3e 80 00       	push   $0x803e3b
  80226e:	e8 fe df ff ff       	call   800271 <_panic>
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	85 c0                	test   %eax,%eax
  80227a:	74 10                	je     80228c <alloc_block_FF+0x67>
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 00                	mov    (%eax),%eax
  802281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802284:	8b 52 04             	mov    0x4(%edx),%edx
  802287:	89 50 04             	mov    %edx,0x4(%eax)
  80228a:	eb 0b                	jmp    802297 <alloc_block_FF+0x72>
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 40 04             	mov    0x4(%eax),%eax
  802292:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 40 04             	mov    0x4(%eax),%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	74 0f                	je     8022b0 <alloc_block_FF+0x8b>
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 40 04             	mov    0x4(%eax),%eax
  8022a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022aa:	8b 12                	mov    (%edx),%edx
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	eb 0a                	jmp    8022ba <alloc_block_FF+0x95>
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 00                	mov    (%eax),%eax
  8022b5:	a3 38 41 80 00       	mov    %eax,0x804138
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022cd:	a1 44 41 80 00       	mov    0x804144,%eax
  8022d2:	48                   	dec    %eax
  8022d3:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	e9 10 01 00 00       	jmp    8023f0 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e9:	0f 86 c6 00 00 00    	jbe    8023b5 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022ef:	a1 48 41 80 00       	mov    0x804148,%eax
  8022f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fa:	8b 50 08             	mov    0x8(%eax),%edx
  8022fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802300:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	8b 55 08             	mov    0x8(%ebp),%edx
  802309:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80230c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802310:	75 17                	jne    802329 <alloc_block_FF+0x104>
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	68 e4 3e 80 00       	push   $0x803ee4
  80231a:	68 9b 00 00 00       	push   $0x9b
  80231f:	68 3b 3e 80 00       	push   $0x803e3b
  802324:	e8 48 df ff ff       	call   800271 <_panic>
  802329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	85 c0                	test   %eax,%eax
  802330:	74 10                	je     802342 <alloc_block_FF+0x11d>
  802332:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802335:	8b 00                	mov    (%eax),%eax
  802337:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233a:	8b 52 04             	mov    0x4(%edx),%edx
  80233d:	89 50 04             	mov    %edx,0x4(%eax)
  802340:	eb 0b                	jmp    80234d <alloc_block_FF+0x128>
  802342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802345:	8b 40 04             	mov    0x4(%eax),%eax
  802348:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80234d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802350:	8b 40 04             	mov    0x4(%eax),%eax
  802353:	85 c0                	test   %eax,%eax
  802355:	74 0f                	je     802366 <alloc_block_FF+0x141>
  802357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802360:	8b 12                	mov    (%edx),%edx
  802362:	89 10                	mov    %edx,(%eax)
  802364:	eb 0a                	jmp    802370 <alloc_block_FF+0x14b>
  802366:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	a3 48 41 80 00       	mov    %eax,0x804148
  802370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802373:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802383:	a1 54 41 80 00       	mov    0x804154,%eax
  802388:	48                   	dec    %eax
  802389:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 50 08             	mov    0x8(%eax),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	01 c2                	add    %eax,%edx
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a8:	89 c2                	mov    %eax,%edx
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8023b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b3:	eb 3b                	jmp    8023f0 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	74 07                	je     8023ca <alloc_block_FF+0x1a5>
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	eb 05                	jmp    8023cf <alloc_block_FF+0x1aa>
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cf:	a3 40 41 80 00       	mov    %eax,0x804140
  8023d4:	a1 40 41 80 00       	mov    0x804140,%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	0f 85 57 fe ff ff    	jne    802238 <alloc_block_FF+0x13>
  8023e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e5:	0f 85 4d fe ff ff    	jne    802238 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023ff:	a1 38 41 80 00       	mov    0x804138,%eax
  802404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802407:	e9 df 00 00 00       	jmp    8024eb <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 40 0c             	mov    0xc(%eax),%eax
  802412:	3b 45 08             	cmp    0x8(%ebp),%eax
  802415:	0f 82 c8 00 00 00    	jb     8024e3 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 0c             	mov    0xc(%eax),%eax
  802421:	3b 45 08             	cmp    0x8(%ebp),%eax
  802424:	0f 85 8a 00 00 00    	jne    8024b4 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80242a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242e:	75 17                	jne    802447 <alloc_block_BF+0x55>
  802430:	83 ec 04             	sub    $0x4,%esp
  802433:	68 e4 3e 80 00       	push   $0x803ee4
  802438:	68 b7 00 00 00       	push   $0xb7
  80243d:	68 3b 3e 80 00       	push   $0x803e3b
  802442:	e8 2a de ff ff       	call   800271 <_panic>
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	85 c0                	test   %eax,%eax
  80244e:	74 10                	je     802460 <alloc_block_BF+0x6e>
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 00                	mov    (%eax),%eax
  802455:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802458:	8b 52 04             	mov    0x4(%edx),%edx
  80245b:	89 50 04             	mov    %edx,0x4(%eax)
  80245e:	eb 0b                	jmp    80246b <alloc_block_BF+0x79>
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 40 04             	mov    0x4(%eax),%eax
  802466:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 40 04             	mov    0x4(%eax),%eax
  802471:	85 c0                	test   %eax,%eax
  802473:	74 0f                	je     802484 <alloc_block_BF+0x92>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 40 04             	mov    0x4(%eax),%eax
  80247b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247e:	8b 12                	mov    (%edx),%edx
  802480:	89 10                	mov    %edx,(%eax)
  802482:	eb 0a                	jmp    80248e <alloc_block_BF+0x9c>
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	a3 38 41 80 00       	mov    %eax,0x804138
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a1:	a1 44 41 80 00       	mov    0x804144,%eax
  8024a6:	48                   	dec    %eax
  8024a7:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  8024ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024af:	e9 4d 01 00 00       	jmp    802601 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024bd:	76 24                	jbe    8024e3 <alloc_block_BF+0xf1>
  8024bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024c8:	73 19                	jae    8024e3 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024ca:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 40 08             	mov    0x8(%eax),%eax
  8024e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ef:	74 07                	je     8024f8 <alloc_block_BF+0x106>
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	eb 05                	jmp    8024fd <alloc_block_BF+0x10b>
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fd:	a3 40 41 80 00       	mov    %eax,0x804140
  802502:	a1 40 41 80 00       	mov    0x804140,%eax
  802507:	85 c0                	test   %eax,%eax
  802509:	0f 85 fd fe ff ff    	jne    80240c <alloc_block_BF+0x1a>
  80250f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802513:	0f 85 f3 fe ff ff    	jne    80240c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802519:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80251d:	0f 84 d9 00 00 00    	je     8025fc <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802523:	a1 48 41 80 00       	mov    0x804148,%eax
  802528:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80252b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802531:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802537:	8b 55 08             	mov    0x8(%ebp),%edx
  80253a:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80253d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802541:	75 17                	jne    80255a <alloc_block_BF+0x168>
  802543:	83 ec 04             	sub    $0x4,%esp
  802546:	68 e4 3e 80 00       	push   $0x803ee4
  80254b:	68 c7 00 00 00       	push   $0xc7
  802550:	68 3b 3e 80 00       	push   $0x803e3b
  802555:	e8 17 dd ff ff       	call   800271 <_panic>
  80255a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	85 c0                	test   %eax,%eax
  802561:	74 10                	je     802573 <alloc_block_BF+0x181>
  802563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802566:	8b 00                	mov    (%eax),%eax
  802568:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80256b:	8b 52 04             	mov    0x4(%edx),%edx
  80256e:	89 50 04             	mov    %edx,0x4(%eax)
  802571:	eb 0b                	jmp    80257e <alloc_block_BF+0x18c>
  802573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80257e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802581:	8b 40 04             	mov    0x4(%eax),%eax
  802584:	85 c0                	test   %eax,%eax
  802586:	74 0f                	je     802597 <alloc_block_BF+0x1a5>
  802588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80258b:	8b 40 04             	mov    0x4(%eax),%eax
  80258e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802591:	8b 12                	mov    (%edx),%edx
  802593:	89 10                	mov    %edx,(%eax)
  802595:	eb 0a                	jmp    8025a1 <alloc_block_BF+0x1af>
  802597:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	a3 48 41 80 00       	mov    %eax,0x804148
  8025a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b4:	a1 54 41 80 00       	mov    0x804154,%eax
  8025b9:	48                   	dec    %eax
  8025ba:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025bf:	83 ec 08             	sub    $0x8,%esp
  8025c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8025c5:	68 38 41 80 00       	push   $0x804138
  8025ca:	e8 71 f9 ff ff       	call   801f40 <find_block>
  8025cf:	83 c4 10             	add    $0x10,%esp
  8025d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d8:	8b 50 08             	mov    0x8(%eax),%edx
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	01 c2                	add    %eax,%edx
  8025e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e3:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ec:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ef:	89 c2                	mov    %eax,%edx
  8025f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025f4:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fa:	eb 05                	jmp    802601 <alloc_block_BF+0x20f>
	}
	return NULL;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802609:	a1 28 40 80 00       	mov    0x804028,%eax
  80260e:	85 c0                	test   %eax,%eax
  802610:	0f 85 de 01 00 00    	jne    8027f4 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802616:	a1 38 41 80 00       	mov    0x804138,%eax
  80261b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261e:	e9 9e 01 00 00       	jmp    8027c1 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	8b 40 0c             	mov    0xc(%eax),%eax
  802629:	3b 45 08             	cmp    0x8(%ebp),%eax
  80262c:	0f 82 87 01 00 00    	jb     8027b9 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 40 0c             	mov    0xc(%eax),%eax
  802638:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263b:	0f 85 95 00 00 00    	jne    8026d6 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802641:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802645:	75 17                	jne    80265e <alloc_block_NF+0x5b>
  802647:	83 ec 04             	sub    $0x4,%esp
  80264a:	68 e4 3e 80 00       	push   $0x803ee4
  80264f:	68 e0 00 00 00       	push   $0xe0
  802654:	68 3b 3e 80 00       	push   $0x803e3b
  802659:	e8 13 dc ff ff       	call   800271 <_panic>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 00                	mov    (%eax),%eax
  802663:	85 c0                	test   %eax,%eax
  802665:	74 10                	je     802677 <alloc_block_NF+0x74>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266f:	8b 52 04             	mov    0x4(%edx),%edx
  802672:	89 50 04             	mov    %edx,0x4(%eax)
  802675:	eb 0b                	jmp    802682 <alloc_block_NF+0x7f>
  802677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267a:	8b 40 04             	mov    0x4(%eax),%eax
  80267d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 40 04             	mov    0x4(%eax),%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	74 0f                	je     80269b <alloc_block_NF+0x98>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 40 04             	mov    0x4(%eax),%eax
  802692:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802695:	8b 12                	mov    (%edx),%edx
  802697:	89 10                	mov    %edx,(%eax)
  802699:	eb 0a                	jmp    8026a5 <alloc_block_NF+0xa2>
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b8:	a1 44 41 80 00       	mov    0x804144,%eax
  8026bd:	48                   	dec    %eax
  8026be:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 08             	mov    0x8(%eax),%eax
  8026c9:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	e9 f8 04 00 00       	jmp    802bce <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026df:	0f 86 d4 00 00 00    	jbe    8027b9 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026e5:	a1 48 41 80 00       	mov    0x804148,%eax
  8026ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 50 08             	mov    0x8(%eax),%edx
  8026f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f6:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ff:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802702:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802706:	75 17                	jne    80271f <alloc_block_NF+0x11c>
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	68 e4 3e 80 00       	push   $0x803ee4
  802710:	68 e9 00 00 00       	push   $0xe9
  802715:	68 3b 3e 80 00       	push   $0x803e3b
  80271a:	e8 52 db ff ff       	call   800271 <_panic>
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	74 10                	je     802738 <alloc_block_NF+0x135>
  802728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272b:	8b 00                	mov    (%eax),%eax
  80272d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802730:	8b 52 04             	mov    0x4(%edx),%edx
  802733:	89 50 04             	mov    %edx,0x4(%eax)
  802736:	eb 0b                	jmp    802743 <alloc_block_NF+0x140>
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	8b 40 04             	mov    0x4(%eax),%eax
  80273e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	74 0f                	je     80275c <alloc_block_NF+0x159>
  80274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802750:	8b 40 04             	mov    0x4(%eax),%eax
  802753:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802756:	8b 12                	mov    (%edx),%edx
  802758:	89 10                	mov    %edx,(%eax)
  80275a:	eb 0a                	jmp    802766 <alloc_block_NF+0x163>
  80275c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275f:	8b 00                	mov    (%eax),%eax
  802761:	a3 48 41 80 00       	mov    %eax,0x804148
  802766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802769:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802779:	a1 54 41 80 00       	mov    0x804154,%eax
  80277e:	48                   	dec    %eax
  80277f:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 40 08             	mov    0x8(%eax),%eax
  80278a:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 50 08             	mov    0x8(%eax),%edx
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	01 c2                	add    %eax,%edx
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a9:	89 c2                	mov    %eax,%edx
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	e9 15 04 00 00       	jmp    802bce <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027b9:	a1 40 41 80 00       	mov    0x804140,%eax
  8027be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c5:	74 07                	je     8027ce <alloc_block_NF+0x1cb>
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	eb 05                	jmp    8027d3 <alloc_block_NF+0x1d0>
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d3:	a3 40 41 80 00       	mov    %eax,0x804140
  8027d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8027dd:	85 c0                	test   %eax,%eax
  8027df:	0f 85 3e fe ff ff    	jne    802623 <alloc_block_NF+0x20>
  8027e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e9:	0f 85 34 fe ff ff    	jne    802623 <alloc_block_NF+0x20>
  8027ef:	e9 d5 03 00 00       	jmp    802bc9 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027f4:	a1 38 41 80 00       	mov    0x804138,%eax
  8027f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fc:	e9 b1 01 00 00       	jmp    8029b2 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 50 08             	mov    0x8(%eax),%edx
  802807:	a1 28 40 80 00       	mov    0x804028,%eax
  80280c:	39 c2                	cmp    %eax,%edx
  80280e:	0f 82 96 01 00 00    	jb     8029aa <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 40 0c             	mov    0xc(%eax),%eax
  80281a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80281d:	0f 82 87 01 00 00    	jb     8029aa <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 40 0c             	mov    0xc(%eax),%eax
  802829:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282c:	0f 85 95 00 00 00    	jne    8028c7 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802836:	75 17                	jne    80284f <alloc_block_NF+0x24c>
  802838:	83 ec 04             	sub    $0x4,%esp
  80283b:	68 e4 3e 80 00       	push   $0x803ee4
  802840:	68 fc 00 00 00       	push   $0xfc
  802845:	68 3b 3e 80 00       	push   $0x803e3b
  80284a:	e8 22 da ff ff       	call   800271 <_panic>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 10                	je     802868 <alloc_block_NF+0x265>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802860:	8b 52 04             	mov    0x4(%edx),%edx
  802863:	89 50 04             	mov    %edx,0x4(%eax)
  802866:	eb 0b                	jmp    802873 <alloc_block_NF+0x270>
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802876:	8b 40 04             	mov    0x4(%eax),%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	74 0f                	je     80288c <alloc_block_NF+0x289>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 40 04             	mov    0x4(%eax),%eax
  802883:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802886:	8b 12                	mov    (%edx),%edx
  802888:	89 10                	mov    %edx,(%eax)
  80288a:	eb 0a                	jmp    802896 <alloc_block_NF+0x293>
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	a3 38 41 80 00       	mov    %eax,0x804138
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a9:	a1 44 41 80 00       	mov    0x804144,%eax
  8028ae:	48                   	dec    %eax
  8028af:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 08             	mov    0x8(%eax),%eax
  8028ba:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	e9 07 03 00 00       	jmp    802bce <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d0:	0f 86 d4 00 00 00    	jbe    8029aa <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028d6:	a1 48 41 80 00       	mov    0x804148,%eax
  8028db:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	8b 50 08             	mov    0x8(%eax),%edx
  8028e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e7:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f0:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028f7:	75 17                	jne    802910 <alloc_block_NF+0x30d>
  8028f9:	83 ec 04             	sub    $0x4,%esp
  8028fc:	68 e4 3e 80 00       	push   $0x803ee4
  802901:	68 04 01 00 00       	push   $0x104
  802906:	68 3b 3e 80 00       	push   $0x803e3b
  80290b:	e8 61 d9 ff ff       	call   800271 <_panic>
  802910:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802913:	8b 00                	mov    (%eax),%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	74 10                	je     802929 <alloc_block_NF+0x326>
  802919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802921:	8b 52 04             	mov    0x4(%edx),%edx
  802924:	89 50 04             	mov    %edx,0x4(%eax)
  802927:	eb 0b                	jmp    802934 <alloc_block_NF+0x331>
  802929:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292c:	8b 40 04             	mov    0x4(%eax),%eax
  80292f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802934:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802937:	8b 40 04             	mov    0x4(%eax),%eax
  80293a:	85 c0                	test   %eax,%eax
  80293c:	74 0f                	je     80294d <alloc_block_NF+0x34a>
  80293e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802947:	8b 12                	mov    (%edx),%edx
  802949:	89 10                	mov    %edx,(%eax)
  80294b:	eb 0a                	jmp    802957 <alloc_block_NF+0x354>
  80294d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	a3 48 41 80 00       	mov    %eax,0x804148
  802957:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80295a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802963:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296a:	a1 54 41 80 00       	mov    0x804154,%eax
  80296f:	48                   	dec    %eax
  802970:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802975:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802978:	8b 40 08             	mov    0x8(%eax),%eax
  80297b:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 50 08             	mov    0x8(%eax),%edx
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	01 c2                	add    %eax,%edx
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 40 0c             	mov    0xc(%eax),%eax
  802997:	2b 45 08             	sub    0x8(%ebp),%eax
  80299a:	89 c2                	mov    %eax,%edx
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  8029a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a5:	e9 24 02 00 00       	jmp    802bce <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8029af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b6:	74 07                	je     8029bf <alloc_block_NF+0x3bc>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 00                	mov    (%eax),%eax
  8029bd:	eb 05                	jmp    8029c4 <alloc_block_NF+0x3c1>
  8029bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c4:	a3 40 41 80 00       	mov    %eax,0x804140
  8029c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	0f 85 2b fe ff ff    	jne    802801 <alloc_block_NF+0x1fe>
  8029d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029da:	0f 85 21 fe ff ff    	jne    802801 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029e0:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029e8:	e9 ae 01 00 00       	jmp    802b9b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 50 08             	mov    0x8(%eax),%edx
  8029f3:	a1 28 40 80 00       	mov    0x804028,%eax
  8029f8:	39 c2                	cmp    %eax,%edx
  8029fa:	0f 83 93 01 00 00    	jae    802b93 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	8b 40 0c             	mov    0xc(%eax),%eax
  802a06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a09:	0f 82 84 01 00 00    	jb     802b93 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 40 0c             	mov    0xc(%eax),%eax
  802a15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a18:	0f 85 95 00 00 00    	jne    802ab3 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a22:	75 17                	jne    802a3b <alloc_block_NF+0x438>
  802a24:	83 ec 04             	sub    $0x4,%esp
  802a27:	68 e4 3e 80 00       	push   $0x803ee4
  802a2c:	68 14 01 00 00       	push   $0x114
  802a31:	68 3b 3e 80 00       	push   $0x803e3b
  802a36:	e8 36 d8 ff ff       	call   800271 <_panic>
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 10                	je     802a54 <alloc_block_NF+0x451>
  802a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a47:	8b 00                	mov    (%eax),%eax
  802a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4c:	8b 52 04             	mov    0x4(%edx),%edx
  802a4f:	89 50 04             	mov    %edx,0x4(%eax)
  802a52:	eb 0b                	jmp    802a5f <alloc_block_NF+0x45c>
  802a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a57:	8b 40 04             	mov    0x4(%eax),%eax
  802a5a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 40 04             	mov    0x4(%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 0f                	je     802a78 <alloc_block_NF+0x475>
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 04             	mov    0x4(%eax),%eax
  802a6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a72:	8b 12                	mov    (%edx),%edx
  802a74:	89 10                	mov    %edx,(%eax)
  802a76:	eb 0a                	jmp    802a82 <alloc_block_NF+0x47f>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	a3 38 41 80 00       	mov    %eax,0x804138
  802a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a95:	a1 44 41 80 00       	mov    0x804144,%eax
  802a9a:	48                   	dec    %eax
  802a9b:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	8b 40 08             	mov    0x8(%eax),%eax
  802aa6:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	e9 1b 01 00 00       	jmp    802bce <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802abc:	0f 86 d1 00 00 00    	jbe    802b93 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802ac2:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 50 08             	mov    0x8(%eax),%edx
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  802adc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802adf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ae3:	75 17                	jne    802afc <alloc_block_NF+0x4f9>
  802ae5:	83 ec 04             	sub    $0x4,%esp
  802ae8:	68 e4 3e 80 00       	push   $0x803ee4
  802aed:	68 1c 01 00 00       	push   $0x11c
  802af2:	68 3b 3e 80 00       	push   $0x803e3b
  802af7:	e8 75 d7 ff ff       	call   800271 <_panic>
  802afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aff:	8b 00                	mov    (%eax),%eax
  802b01:	85 c0                	test   %eax,%eax
  802b03:	74 10                	je     802b15 <alloc_block_NF+0x512>
  802b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b0d:	8b 52 04             	mov    0x4(%edx),%edx
  802b10:	89 50 04             	mov    %edx,0x4(%eax)
  802b13:	eb 0b                	jmp    802b20 <alloc_block_NF+0x51d>
  802b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b18:	8b 40 04             	mov    0x4(%eax),%eax
  802b1b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b23:	8b 40 04             	mov    0x4(%eax),%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	74 0f                	je     802b39 <alloc_block_NF+0x536>
  802b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2d:	8b 40 04             	mov    0x4(%eax),%eax
  802b30:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b33:	8b 12                	mov    (%edx),%edx
  802b35:	89 10                	mov    %edx,(%eax)
  802b37:	eb 0a                	jmp    802b43 <alloc_block_NF+0x540>
  802b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3c:	8b 00                	mov    (%eax),%eax
  802b3e:	a3 48 41 80 00       	mov    %eax,0x804148
  802b43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b56:	a1 54 41 80 00       	mov    0x804154,%eax
  802b5b:	48                   	dec    %eax
  802b5c:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	8b 40 08             	mov    0x8(%eax),%eax
  802b67:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6f:	8b 50 08             	mov    0x8(%eax),%edx
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	01 c2                	add    %eax,%edx
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 40 0c             	mov    0xc(%eax),%eax
  802b83:	2b 45 08             	sub    0x8(%ebp),%eax
  802b86:	89 c2                	mov    %eax,%edx
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b91:	eb 3b                	jmp    802bce <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b93:	a1 40 41 80 00       	mov    0x804140,%eax
  802b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9f:	74 07                	je     802ba8 <alloc_block_NF+0x5a5>
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 00                	mov    (%eax),%eax
  802ba6:	eb 05                	jmp    802bad <alloc_block_NF+0x5aa>
  802ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bad:	a3 40 41 80 00       	mov    %eax,0x804140
  802bb2:	a1 40 41 80 00       	mov    0x804140,%eax
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	0f 85 2e fe ff ff    	jne    8029ed <alloc_block_NF+0x3ea>
  802bbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc3:	0f 85 24 fe ff ff    	jne    8029ed <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bce:	c9                   	leave  
  802bcf:	c3                   	ret    

00802bd0 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bd0:	55                   	push   %ebp
  802bd1:	89 e5                	mov    %esp,%ebp
  802bd3:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bd6:	a1 38 41 80 00       	mov    0x804138,%eax
  802bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bde:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802be3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802be6:	a1 38 41 80 00       	mov    0x804138,%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 14                	je     802c03 <insert_sorted_with_merge_freeList+0x33>
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 50 08             	mov    0x8(%eax),%edx
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 40 08             	mov    0x8(%eax),%eax
  802bfb:	39 c2                	cmp    %eax,%edx
  802bfd:	0f 87 9b 01 00 00    	ja     802d9e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c07:	75 17                	jne    802c20 <insert_sorted_with_merge_freeList+0x50>
  802c09:	83 ec 04             	sub    $0x4,%esp
  802c0c:	68 18 3e 80 00       	push   $0x803e18
  802c11:	68 38 01 00 00       	push   $0x138
  802c16:	68 3b 3e 80 00       	push   $0x803e3b
  802c1b:	e8 51 d6 ff ff       	call   800271 <_panic>
  802c20:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	89 10                	mov    %edx,(%eax)
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 0d                	je     802c41 <insert_sorted_with_merge_freeList+0x71>
  802c34:	a1 38 41 80 00       	mov    0x804138,%eax
  802c39:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3c:	89 50 04             	mov    %edx,0x4(%eax)
  802c3f:	eb 08                	jmp    802c49 <insert_sorted_with_merge_freeList+0x79>
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5b:	a1 44 41 80 00       	mov    0x804144,%eax
  802c60:	40                   	inc    %eax
  802c61:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c6a:	0f 84 a8 06 00 00    	je     803318 <insert_sorted_with_merge_freeList+0x748>
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	8b 50 08             	mov    0x8(%eax),%edx
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7c:	01 c2                	add    %eax,%edx
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 40 08             	mov    0x8(%eax),%eax
  802c84:	39 c2                	cmp    %eax,%edx
  802c86:	0f 85 8c 06 00 00    	jne    803318 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c95:	8b 40 0c             	mov    0xc(%eax),%eax
  802c98:	01 c2                	add    %eax,%edx
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802ca0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ca4:	75 17                	jne    802cbd <insert_sorted_with_merge_freeList+0xed>
  802ca6:	83 ec 04             	sub    $0x4,%esp
  802ca9:	68 e4 3e 80 00       	push   $0x803ee4
  802cae:	68 3c 01 00 00       	push   $0x13c
  802cb3:	68 3b 3e 80 00       	push   $0x803e3b
  802cb8:	e8 b4 d5 ff ff       	call   800271 <_panic>
  802cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc0:	8b 00                	mov    (%eax),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 10                	je     802cd6 <insert_sorted_with_merge_freeList+0x106>
  802cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cce:	8b 52 04             	mov    0x4(%edx),%edx
  802cd1:	89 50 04             	mov    %edx,0x4(%eax)
  802cd4:	eb 0b                	jmp    802ce1 <insert_sorted_with_merge_freeList+0x111>
  802cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd9:	8b 40 04             	mov    0x4(%eax),%eax
  802cdc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	74 0f                	je     802cfa <insert_sorted_with_merge_freeList+0x12a>
  802ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cee:	8b 40 04             	mov    0x4(%eax),%eax
  802cf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cf4:	8b 12                	mov    (%edx),%edx
  802cf6:	89 10                	mov    %edx,(%eax)
  802cf8:	eb 0a                	jmp    802d04 <insert_sorted_with_merge_freeList+0x134>
  802cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	a3 38 41 80 00       	mov    %eax,0x804138
  802d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d17:	a1 44 41 80 00       	mov    0x804144,%eax
  802d1c:	48                   	dec    %eax
  802d1d:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d25:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d3a:	75 17                	jne    802d53 <insert_sorted_with_merge_freeList+0x183>
  802d3c:	83 ec 04             	sub    $0x4,%esp
  802d3f:	68 18 3e 80 00       	push   $0x803e18
  802d44:	68 3f 01 00 00       	push   $0x13f
  802d49:	68 3b 3e 80 00       	push   $0x803e3b
  802d4e:	e8 1e d5 ff ff       	call   800271 <_panic>
  802d53:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5c:	89 10                	mov    %edx,(%eax)
  802d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	85 c0                	test   %eax,%eax
  802d65:	74 0d                	je     802d74 <insert_sorted_with_merge_freeList+0x1a4>
  802d67:	a1 48 41 80 00       	mov    0x804148,%eax
  802d6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6f:	89 50 04             	mov    %edx,0x4(%eax)
  802d72:	eb 08                	jmp    802d7c <insert_sorted_with_merge_freeList+0x1ac>
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	a3 48 41 80 00       	mov    %eax,0x804148
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8e:	a1 54 41 80 00       	mov    0x804154,%eax
  802d93:	40                   	inc    %eax
  802d94:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d99:	e9 7a 05 00 00       	jmp    803318 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	8b 50 08             	mov    0x8(%eax),%edx
  802da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da7:	8b 40 08             	mov    0x8(%eax),%eax
  802daa:	39 c2                	cmp    %eax,%edx
  802dac:	0f 82 14 01 00 00    	jb     802ec6 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db5:	8b 50 08             	mov    0x8(%eax),%edx
  802db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbe:	01 c2                	add    %eax,%edx
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	8b 40 08             	mov    0x8(%eax),%eax
  802dc6:	39 c2                	cmp    %eax,%edx
  802dc8:	0f 85 90 00 00 00    	jne    802e5e <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd1:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dda:	01 c2                	add    %eax,%edx
  802ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddf:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802df6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfa:	75 17                	jne    802e13 <insert_sorted_with_merge_freeList+0x243>
  802dfc:	83 ec 04             	sub    $0x4,%esp
  802dff:	68 18 3e 80 00       	push   $0x803e18
  802e04:	68 49 01 00 00       	push   $0x149
  802e09:	68 3b 3e 80 00       	push   $0x803e3b
  802e0e:	e8 5e d4 ff ff       	call   800271 <_panic>
  802e13:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	89 10                	mov    %edx,(%eax)
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	85 c0                	test   %eax,%eax
  802e25:	74 0d                	je     802e34 <insert_sorted_with_merge_freeList+0x264>
  802e27:	a1 48 41 80 00       	mov    0x804148,%eax
  802e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2f:	89 50 04             	mov    %edx,0x4(%eax)
  802e32:	eb 08                	jmp    802e3c <insert_sorted_with_merge_freeList+0x26c>
  802e34:	8b 45 08             	mov    0x8(%ebp),%eax
  802e37:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	a3 48 41 80 00       	mov    %eax,0x804148
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4e:	a1 54 41 80 00       	mov    0x804154,%eax
  802e53:	40                   	inc    %eax
  802e54:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e59:	e9 bb 04 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e62:	75 17                	jne    802e7b <insert_sorted_with_merge_freeList+0x2ab>
  802e64:	83 ec 04             	sub    $0x4,%esp
  802e67:	68 8c 3e 80 00       	push   $0x803e8c
  802e6c:	68 4c 01 00 00       	push   $0x14c
  802e71:	68 3b 3e 80 00       	push   $0x803e3b
  802e76:	e8 f6 d3 ff ff       	call   800271 <_panic>
  802e7b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	89 50 04             	mov    %edx,0x4(%eax)
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	85 c0                	test   %eax,%eax
  802e8f:	74 0c                	je     802e9d <insert_sorted_with_merge_freeList+0x2cd>
  802e91:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e96:	8b 55 08             	mov    0x8(%ebp),%edx
  802e99:	89 10                	mov    %edx,(%eax)
  802e9b:	eb 08                	jmp    802ea5 <insert_sorted_with_merge_freeList+0x2d5>
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	a3 38 41 80 00       	mov    %eax,0x804138
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb6:	a1 44 41 80 00       	mov    0x804144,%eax
  802ebb:	40                   	inc    %eax
  802ebc:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ec1:	e9 53 04 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802ec6:	a1 38 41 80 00       	mov    0x804138,%eax
  802ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ece:	e9 15 04 00 00       	jmp    8032e8 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8b 50 08             	mov    0x8(%eax),%edx
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	8b 40 08             	mov    0x8(%eax),%eax
  802ee7:	39 c2                	cmp    %eax,%edx
  802ee9:	0f 86 f1 03 00 00    	jbe    8032e0 <insert_sorted_with_merge_freeList+0x710>
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	8b 50 08             	mov    0x8(%eax),%edx
  802ef5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef8:	8b 40 08             	mov    0x8(%eax),%eax
  802efb:	39 c2                	cmp    %eax,%edx
  802efd:	0f 83 dd 03 00 00    	jae    8032e0 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 50 08             	mov    0x8(%eax),%edx
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0f:	01 c2                	add    %eax,%edx
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	8b 40 08             	mov    0x8(%eax),%eax
  802f17:	39 c2                	cmp    %eax,%edx
  802f19:	0f 85 b9 01 00 00    	jne    8030d8 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 50 08             	mov    0x8(%eax),%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2b:	01 c2                	add    %eax,%edx
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	0f 85 0d 01 00 00    	jne    803048 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f44:	8b 40 0c             	mov    0xc(%eax),%eax
  802f47:	01 c2                	add    %eax,%edx
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f53:	75 17                	jne    802f6c <insert_sorted_with_merge_freeList+0x39c>
  802f55:	83 ec 04             	sub    $0x4,%esp
  802f58:	68 e4 3e 80 00       	push   $0x803ee4
  802f5d:	68 5c 01 00 00       	push   $0x15c
  802f62:	68 3b 3e 80 00       	push   $0x803e3b
  802f67:	e8 05 d3 ff ff       	call   800271 <_panic>
  802f6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	85 c0                	test   %eax,%eax
  802f73:	74 10                	je     802f85 <insert_sorted_with_merge_freeList+0x3b5>
  802f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f7d:	8b 52 04             	mov    0x4(%edx),%edx
  802f80:	89 50 04             	mov    %edx,0x4(%eax)
  802f83:	eb 0b                	jmp    802f90 <insert_sorted_with_merge_freeList+0x3c0>
  802f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f88:	8b 40 04             	mov    0x4(%eax),%eax
  802f8b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f93:	8b 40 04             	mov    0x4(%eax),%eax
  802f96:	85 c0                	test   %eax,%eax
  802f98:	74 0f                	je     802fa9 <insert_sorted_with_merge_freeList+0x3d9>
  802f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9d:	8b 40 04             	mov    0x4(%eax),%eax
  802fa0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa3:	8b 12                	mov    (%edx),%edx
  802fa5:	89 10                	mov    %edx,(%eax)
  802fa7:	eb 0a                	jmp    802fb3 <insert_sorted_with_merge_freeList+0x3e3>
  802fa9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	a3 38 41 80 00       	mov    %eax,0x804138
  802fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc6:	a1 44 41 80 00       	mov    0x804144,%eax
  802fcb:	48                   	dec    %eax
  802fcc:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fde:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fe5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fe9:	75 17                	jne    803002 <insert_sorted_with_merge_freeList+0x432>
  802feb:	83 ec 04             	sub    $0x4,%esp
  802fee:	68 18 3e 80 00       	push   $0x803e18
  802ff3:	68 5f 01 00 00       	push   $0x15f
  802ff8:	68 3b 3e 80 00       	push   $0x803e3b
  802ffd:	e8 6f d2 ff ff       	call   800271 <_panic>
  803002:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803008:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80300b:	89 10                	mov    %edx,(%eax)
  80300d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803010:	8b 00                	mov    (%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 0d                	je     803023 <insert_sorted_with_merge_freeList+0x453>
  803016:	a1 48 41 80 00       	mov    0x804148,%eax
  80301b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301e:	89 50 04             	mov    %edx,0x4(%eax)
  803021:	eb 08                	jmp    80302b <insert_sorted_with_merge_freeList+0x45b>
  803023:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803026:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80302b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302e:	a3 48 41 80 00       	mov    %eax,0x804148
  803033:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803036:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303d:	a1 54 41 80 00       	mov    0x804154,%eax
  803042:	40                   	inc    %eax
  803043:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 50 0c             	mov    0xc(%eax),%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 40 0c             	mov    0xc(%eax),%eax
  803054:	01 c2                	add    %eax,%edx
  803056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803059:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803066:	8b 45 08             	mov    0x8(%ebp),%eax
  803069:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803074:	75 17                	jne    80308d <insert_sorted_with_merge_freeList+0x4bd>
  803076:	83 ec 04             	sub    $0x4,%esp
  803079:	68 18 3e 80 00       	push   $0x803e18
  80307e:	68 64 01 00 00       	push   $0x164
  803083:	68 3b 3e 80 00       	push   $0x803e3b
  803088:	e8 e4 d1 ff ff       	call   800271 <_panic>
  80308d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	89 10                	mov    %edx,(%eax)
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	85 c0                	test   %eax,%eax
  80309f:	74 0d                	je     8030ae <insert_sorted_with_merge_freeList+0x4de>
  8030a1:	a1 48 41 80 00       	mov    0x804148,%eax
  8030a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a9:	89 50 04             	mov    %edx,0x4(%eax)
  8030ac:	eb 08                	jmp    8030b6 <insert_sorted_with_merge_freeList+0x4e6>
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	a3 48 41 80 00       	mov    %eax,0x804148
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c8:	a1 54 41 80 00       	mov    0x804154,%eax
  8030cd:	40                   	inc    %eax
  8030ce:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030d3:	e9 41 02 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 50 08             	mov    0x8(%eax),%edx
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e4:	01 c2                	add    %eax,%edx
  8030e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e9:	8b 40 08             	mov    0x8(%eax),%eax
  8030ec:	39 c2                	cmp    %eax,%edx
  8030ee:	0f 85 7c 01 00 00    	jne    803270 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030f8:	74 06                	je     803100 <insert_sorted_with_merge_freeList+0x530>
  8030fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030fe:	75 17                	jne    803117 <insert_sorted_with_merge_freeList+0x547>
  803100:	83 ec 04             	sub    $0x4,%esp
  803103:	68 54 3e 80 00       	push   $0x803e54
  803108:	68 69 01 00 00       	push   $0x169
  80310d:	68 3b 3e 80 00       	push   $0x803e3b
  803112:	e8 5a d1 ff ff       	call   800271 <_panic>
  803117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311a:	8b 50 04             	mov    0x4(%eax),%edx
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	89 50 04             	mov    %edx,0x4(%eax)
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803129:	89 10                	mov    %edx,(%eax)
  80312b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312e:	8b 40 04             	mov    0x4(%eax),%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	74 0d                	je     803142 <insert_sorted_with_merge_freeList+0x572>
  803135:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803138:	8b 40 04             	mov    0x4(%eax),%eax
  80313b:	8b 55 08             	mov    0x8(%ebp),%edx
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	eb 08                	jmp    80314a <insert_sorted_with_merge_freeList+0x57a>
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	a3 38 41 80 00       	mov    %eax,0x804138
  80314a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314d:	8b 55 08             	mov    0x8(%ebp),%edx
  803150:	89 50 04             	mov    %edx,0x4(%eax)
  803153:	a1 44 41 80 00       	mov    0x804144,%eax
  803158:	40                   	inc    %eax
  803159:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80315e:	8b 45 08             	mov    0x8(%ebp),%eax
  803161:	8b 50 0c             	mov    0xc(%eax),%edx
  803164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803167:	8b 40 0c             	mov    0xc(%eax),%eax
  80316a:	01 c2                	add    %eax,%edx
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803172:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803176:	75 17                	jne    80318f <insert_sorted_with_merge_freeList+0x5bf>
  803178:	83 ec 04             	sub    $0x4,%esp
  80317b:	68 e4 3e 80 00       	push   $0x803ee4
  803180:	68 6b 01 00 00       	push   $0x16b
  803185:	68 3b 3e 80 00       	push   $0x803e3b
  80318a:	e8 e2 d0 ff ff       	call   800271 <_panic>
  80318f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803192:	8b 00                	mov    (%eax),%eax
  803194:	85 c0                	test   %eax,%eax
  803196:	74 10                	je     8031a8 <insert_sorted_with_merge_freeList+0x5d8>
  803198:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319b:	8b 00                	mov    (%eax),%eax
  80319d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031a0:	8b 52 04             	mov    0x4(%edx),%edx
  8031a3:	89 50 04             	mov    %edx,0x4(%eax)
  8031a6:	eb 0b                	jmp    8031b3 <insert_sorted_with_merge_freeList+0x5e3>
  8031a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ab:	8b 40 04             	mov    0x4(%eax),%eax
  8031ae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b6:	8b 40 04             	mov    0x4(%eax),%eax
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	74 0f                	je     8031cc <insert_sorted_with_merge_freeList+0x5fc>
  8031bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c0:	8b 40 04             	mov    0x4(%eax),%eax
  8031c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031c6:	8b 12                	mov    (%edx),%edx
  8031c8:	89 10                	mov    %edx,(%eax)
  8031ca:	eb 0a                	jmp    8031d6 <insert_sorted_with_merge_freeList+0x606>
  8031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	a3 38 41 80 00       	mov    %eax,0x804138
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e9:	a1 44 41 80 00       	mov    0x804144,%eax
  8031ee:	48                   	dec    %eax
  8031ef:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803201:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803208:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80320c:	75 17                	jne    803225 <insert_sorted_with_merge_freeList+0x655>
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	68 18 3e 80 00       	push   $0x803e18
  803216:	68 6e 01 00 00       	push   $0x16e
  80321b:	68 3b 3e 80 00       	push   $0x803e3b
  803220:	e8 4c d0 ff ff       	call   800271 <_panic>
  803225:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80322b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80322e:	89 10                	mov    %edx,(%eax)
  803230:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	74 0d                	je     803246 <insert_sorted_with_merge_freeList+0x676>
  803239:	a1 48 41 80 00       	mov    0x804148,%eax
  80323e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	eb 08                	jmp    80324e <insert_sorted_with_merge_freeList+0x67e>
  803246:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803249:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80324e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803251:	a3 48 41 80 00       	mov    %eax,0x804148
  803256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803259:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803260:	a1 54 41 80 00       	mov    0x804154,%eax
  803265:	40                   	inc    %eax
  803266:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  80326b:	e9 a9 00 00 00       	jmp    803319 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803270:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803274:	74 06                	je     80327c <insert_sorted_with_merge_freeList+0x6ac>
  803276:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327a:	75 17                	jne    803293 <insert_sorted_with_merge_freeList+0x6c3>
  80327c:	83 ec 04             	sub    $0x4,%esp
  80327f:	68 b0 3e 80 00       	push   $0x803eb0
  803284:	68 73 01 00 00       	push   $0x173
  803289:	68 3b 3e 80 00       	push   $0x803e3b
  80328e:	e8 de cf ff ff       	call   800271 <_panic>
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 10                	mov    (%eax),%edx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	89 10                	mov    %edx,(%eax)
  80329d:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	74 0b                	je     8032b1 <insert_sorted_with_merge_freeList+0x6e1>
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ae:	89 50 04             	mov    %edx,0x4(%eax)
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b7:	89 10                	mov    %edx,(%eax)
  8032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032bf:	89 50 04             	mov    %edx,0x4(%eax)
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	75 08                	jne    8032d3 <insert_sorted_with_merge_freeList+0x703>
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032d3:	a1 44 41 80 00       	mov    0x804144,%eax
  8032d8:	40                   	inc    %eax
  8032d9:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032de:	eb 39                	jmp    803319 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8032e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ec:	74 07                	je     8032f5 <insert_sorted_with_merge_freeList+0x725>
  8032ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	eb 05                	jmp    8032fa <insert_sorted_with_merge_freeList+0x72a>
  8032f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032fa:	a3 40 41 80 00       	mov    %eax,0x804140
  8032ff:	a1 40 41 80 00       	mov    0x804140,%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	0f 85 c7 fb ff ff    	jne    802ed3 <insert_sorted_with_merge_freeList+0x303>
  80330c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803310:	0f 85 bd fb ff ff    	jne    802ed3 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803316:	eb 01                	jmp    803319 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803318:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803319:	90                   	nop
  80331a:	c9                   	leave  
  80331b:	c3                   	ret    

0080331c <__udivdi3>:
  80331c:	55                   	push   %ebp
  80331d:	57                   	push   %edi
  80331e:	56                   	push   %esi
  80331f:	53                   	push   %ebx
  803320:	83 ec 1c             	sub    $0x1c,%esp
  803323:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803327:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80332b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80332f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803333:	89 ca                	mov    %ecx,%edx
  803335:	89 f8                	mov    %edi,%eax
  803337:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80333b:	85 f6                	test   %esi,%esi
  80333d:	75 2d                	jne    80336c <__udivdi3+0x50>
  80333f:	39 cf                	cmp    %ecx,%edi
  803341:	77 65                	ja     8033a8 <__udivdi3+0x8c>
  803343:	89 fd                	mov    %edi,%ebp
  803345:	85 ff                	test   %edi,%edi
  803347:	75 0b                	jne    803354 <__udivdi3+0x38>
  803349:	b8 01 00 00 00       	mov    $0x1,%eax
  80334e:	31 d2                	xor    %edx,%edx
  803350:	f7 f7                	div    %edi
  803352:	89 c5                	mov    %eax,%ebp
  803354:	31 d2                	xor    %edx,%edx
  803356:	89 c8                	mov    %ecx,%eax
  803358:	f7 f5                	div    %ebp
  80335a:	89 c1                	mov    %eax,%ecx
  80335c:	89 d8                	mov    %ebx,%eax
  80335e:	f7 f5                	div    %ebp
  803360:	89 cf                	mov    %ecx,%edi
  803362:	89 fa                	mov    %edi,%edx
  803364:	83 c4 1c             	add    $0x1c,%esp
  803367:	5b                   	pop    %ebx
  803368:	5e                   	pop    %esi
  803369:	5f                   	pop    %edi
  80336a:	5d                   	pop    %ebp
  80336b:	c3                   	ret    
  80336c:	39 ce                	cmp    %ecx,%esi
  80336e:	77 28                	ja     803398 <__udivdi3+0x7c>
  803370:	0f bd fe             	bsr    %esi,%edi
  803373:	83 f7 1f             	xor    $0x1f,%edi
  803376:	75 40                	jne    8033b8 <__udivdi3+0x9c>
  803378:	39 ce                	cmp    %ecx,%esi
  80337a:	72 0a                	jb     803386 <__udivdi3+0x6a>
  80337c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803380:	0f 87 9e 00 00 00    	ja     803424 <__udivdi3+0x108>
  803386:	b8 01 00 00 00       	mov    $0x1,%eax
  80338b:	89 fa                	mov    %edi,%edx
  80338d:	83 c4 1c             	add    $0x1c,%esp
  803390:	5b                   	pop    %ebx
  803391:	5e                   	pop    %esi
  803392:	5f                   	pop    %edi
  803393:	5d                   	pop    %ebp
  803394:	c3                   	ret    
  803395:	8d 76 00             	lea    0x0(%esi),%esi
  803398:	31 ff                	xor    %edi,%edi
  80339a:	31 c0                	xor    %eax,%eax
  80339c:	89 fa                	mov    %edi,%edx
  80339e:	83 c4 1c             	add    $0x1c,%esp
  8033a1:	5b                   	pop    %ebx
  8033a2:	5e                   	pop    %esi
  8033a3:	5f                   	pop    %edi
  8033a4:	5d                   	pop    %ebp
  8033a5:	c3                   	ret    
  8033a6:	66 90                	xchg   %ax,%ax
  8033a8:	89 d8                	mov    %ebx,%eax
  8033aa:	f7 f7                	div    %edi
  8033ac:	31 ff                	xor    %edi,%edi
  8033ae:	89 fa                	mov    %edi,%edx
  8033b0:	83 c4 1c             	add    $0x1c,%esp
  8033b3:	5b                   	pop    %ebx
  8033b4:	5e                   	pop    %esi
  8033b5:	5f                   	pop    %edi
  8033b6:	5d                   	pop    %ebp
  8033b7:	c3                   	ret    
  8033b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033bd:	89 eb                	mov    %ebp,%ebx
  8033bf:	29 fb                	sub    %edi,%ebx
  8033c1:	89 f9                	mov    %edi,%ecx
  8033c3:	d3 e6                	shl    %cl,%esi
  8033c5:	89 c5                	mov    %eax,%ebp
  8033c7:	88 d9                	mov    %bl,%cl
  8033c9:	d3 ed                	shr    %cl,%ebp
  8033cb:	89 e9                	mov    %ebp,%ecx
  8033cd:	09 f1                	or     %esi,%ecx
  8033cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033d3:	89 f9                	mov    %edi,%ecx
  8033d5:	d3 e0                	shl    %cl,%eax
  8033d7:	89 c5                	mov    %eax,%ebp
  8033d9:	89 d6                	mov    %edx,%esi
  8033db:	88 d9                	mov    %bl,%cl
  8033dd:	d3 ee                	shr    %cl,%esi
  8033df:	89 f9                	mov    %edi,%ecx
  8033e1:	d3 e2                	shl    %cl,%edx
  8033e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033e7:	88 d9                	mov    %bl,%cl
  8033e9:	d3 e8                	shr    %cl,%eax
  8033eb:	09 c2                	or     %eax,%edx
  8033ed:	89 d0                	mov    %edx,%eax
  8033ef:	89 f2                	mov    %esi,%edx
  8033f1:	f7 74 24 0c          	divl   0xc(%esp)
  8033f5:	89 d6                	mov    %edx,%esi
  8033f7:	89 c3                	mov    %eax,%ebx
  8033f9:	f7 e5                	mul    %ebp
  8033fb:	39 d6                	cmp    %edx,%esi
  8033fd:	72 19                	jb     803418 <__udivdi3+0xfc>
  8033ff:	74 0b                	je     80340c <__udivdi3+0xf0>
  803401:	89 d8                	mov    %ebx,%eax
  803403:	31 ff                	xor    %edi,%edi
  803405:	e9 58 ff ff ff       	jmp    803362 <__udivdi3+0x46>
  80340a:	66 90                	xchg   %ax,%ax
  80340c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803410:	89 f9                	mov    %edi,%ecx
  803412:	d3 e2                	shl    %cl,%edx
  803414:	39 c2                	cmp    %eax,%edx
  803416:	73 e9                	jae    803401 <__udivdi3+0xe5>
  803418:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80341b:	31 ff                	xor    %edi,%edi
  80341d:	e9 40 ff ff ff       	jmp    803362 <__udivdi3+0x46>
  803422:	66 90                	xchg   %ax,%ax
  803424:	31 c0                	xor    %eax,%eax
  803426:	e9 37 ff ff ff       	jmp    803362 <__udivdi3+0x46>
  80342b:	90                   	nop

0080342c <__umoddi3>:
  80342c:	55                   	push   %ebp
  80342d:	57                   	push   %edi
  80342e:	56                   	push   %esi
  80342f:	53                   	push   %ebx
  803430:	83 ec 1c             	sub    $0x1c,%esp
  803433:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803437:	8b 74 24 34          	mov    0x34(%esp),%esi
  80343b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80343f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803447:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80344b:	89 f3                	mov    %esi,%ebx
  80344d:	89 fa                	mov    %edi,%edx
  80344f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803453:	89 34 24             	mov    %esi,(%esp)
  803456:	85 c0                	test   %eax,%eax
  803458:	75 1a                	jne    803474 <__umoddi3+0x48>
  80345a:	39 f7                	cmp    %esi,%edi
  80345c:	0f 86 a2 00 00 00    	jbe    803504 <__umoddi3+0xd8>
  803462:	89 c8                	mov    %ecx,%eax
  803464:	89 f2                	mov    %esi,%edx
  803466:	f7 f7                	div    %edi
  803468:	89 d0                	mov    %edx,%eax
  80346a:	31 d2                	xor    %edx,%edx
  80346c:	83 c4 1c             	add    $0x1c,%esp
  80346f:	5b                   	pop    %ebx
  803470:	5e                   	pop    %esi
  803471:	5f                   	pop    %edi
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    
  803474:	39 f0                	cmp    %esi,%eax
  803476:	0f 87 ac 00 00 00    	ja     803528 <__umoddi3+0xfc>
  80347c:	0f bd e8             	bsr    %eax,%ebp
  80347f:	83 f5 1f             	xor    $0x1f,%ebp
  803482:	0f 84 ac 00 00 00    	je     803534 <__umoddi3+0x108>
  803488:	bf 20 00 00 00       	mov    $0x20,%edi
  80348d:	29 ef                	sub    %ebp,%edi
  80348f:	89 fe                	mov    %edi,%esi
  803491:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803495:	89 e9                	mov    %ebp,%ecx
  803497:	d3 e0                	shl    %cl,%eax
  803499:	89 d7                	mov    %edx,%edi
  80349b:	89 f1                	mov    %esi,%ecx
  80349d:	d3 ef                	shr    %cl,%edi
  80349f:	09 c7                	or     %eax,%edi
  8034a1:	89 e9                	mov    %ebp,%ecx
  8034a3:	d3 e2                	shl    %cl,%edx
  8034a5:	89 14 24             	mov    %edx,(%esp)
  8034a8:	89 d8                	mov    %ebx,%eax
  8034aa:	d3 e0                	shl    %cl,%eax
  8034ac:	89 c2                	mov    %eax,%edx
  8034ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034b2:	d3 e0                	shl    %cl,%eax
  8034b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034bc:	89 f1                	mov    %esi,%ecx
  8034be:	d3 e8                	shr    %cl,%eax
  8034c0:	09 d0                	or     %edx,%eax
  8034c2:	d3 eb                	shr    %cl,%ebx
  8034c4:	89 da                	mov    %ebx,%edx
  8034c6:	f7 f7                	div    %edi
  8034c8:	89 d3                	mov    %edx,%ebx
  8034ca:	f7 24 24             	mull   (%esp)
  8034cd:	89 c6                	mov    %eax,%esi
  8034cf:	89 d1                	mov    %edx,%ecx
  8034d1:	39 d3                	cmp    %edx,%ebx
  8034d3:	0f 82 87 00 00 00    	jb     803560 <__umoddi3+0x134>
  8034d9:	0f 84 91 00 00 00    	je     803570 <__umoddi3+0x144>
  8034df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034e3:	29 f2                	sub    %esi,%edx
  8034e5:	19 cb                	sbb    %ecx,%ebx
  8034e7:	89 d8                	mov    %ebx,%eax
  8034e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034ed:	d3 e0                	shl    %cl,%eax
  8034ef:	89 e9                	mov    %ebp,%ecx
  8034f1:	d3 ea                	shr    %cl,%edx
  8034f3:	09 d0                	or     %edx,%eax
  8034f5:	89 e9                	mov    %ebp,%ecx
  8034f7:	d3 eb                	shr    %cl,%ebx
  8034f9:	89 da                	mov    %ebx,%edx
  8034fb:	83 c4 1c             	add    $0x1c,%esp
  8034fe:	5b                   	pop    %ebx
  8034ff:	5e                   	pop    %esi
  803500:	5f                   	pop    %edi
  803501:	5d                   	pop    %ebp
  803502:	c3                   	ret    
  803503:	90                   	nop
  803504:	89 fd                	mov    %edi,%ebp
  803506:	85 ff                	test   %edi,%edi
  803508:	75 0b                	jne    803515 <__umoddi3+0xe9>
  80350a:	b8 01 00 00 00       	mov    $0x1,%eax
  80350f:	31 d2                	xor    %edx,%edx
  803511:	f7 f7                	div    %edi
  803513:	89 c5                	mov    %eax,%ebp
  803515:	89 f0                	mov    %esi,%eax
  803517:	31 d2                	xor    %edx,%edx
  803519:	f7 f5                	div    %ebp
  80351b:	89 c8                	mov    %ecx,%eax
  80351d:	f7 f5                	div    %ebp
  80351f:	89 d0                	mov    %edx,%eax
  803521:	e9 44 ff ff ff       	jmp    80346a <__umoddi3+0x3e>
  803526:	66 90                	xchg   %ax,%ax
  803528:	89 c8                	mov    %ecx,%eax
  80352a:	89 f2                	mov    %esi,%edx
  80352c:	83 c4 1c             	add    $0x1c,%esp
  80352f:	5b                   	pop    %ebx
  803530:	5e                   	pop    %esi
  803531:	5f                   	pop    %edi
  803532:	5d                   	pop    %ebp
  803533:	c3                   	ret    
  803534:	3b 04 24             	cmp    (%esp),%eax
  803537:	72 06                	jb     80353f <__umoddi3+0x113>
  803539:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80353d:	77 0f                	ja     80354e <__umoddi3+0x122>
  80353f:	89 f2                	mov    %esi,%edx
  803541:	29 f9                	sub    %edi,%ecx
  803543:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803547:	89 14 24             	mov    %edx,(%esp)
  80354a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80354e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803552:	8b 14 24             	mov    (%esp),%edx
  803555:	83 c4 1c             	add    $0x1c,%esp
  803558:	5b                   	pop    %ebx
  803559:	5e                   	pop    %esi
  80355a:	5f                   	pop    %edi
  80355b:	5d                   	pop    %ebp
  80355c:	c3                   	ret    
  80355d:	8d 76 00             	lea    0x0(%esi),%esi
  803560:	2b 04 24             	sub    (%esp),%eax
  803563:	19 fa                	sbb    %edi,%edx
  803565:	89 d1                	mov    %edx,%ecx
  803567:	89 c6                	mov    %eax,%esi
  803569:	e9 71 ff ff ff       	jmp    8034df <__umoddi3+0xb3>
  80356e:	66 90                	xchg   %ax,%ax
  803570:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803574:	72 ea                	jb     803560 <__umoddi3+0x134>
  803576:	89 d9                	mov    %ebx,%ecx
  803578:	e9 62 ff ff ff       	jmp    8034df <__umoddi3+0xb3>
