
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
  80008c:	68 00 35 80 00       	push   $0x803500
  800091:	6a 12                	push   $0x12
  800093:	68 1c 35 80 00       	push   $0x80351c
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
  8000aa:	e8 17 19 00 00       	call   8019c6 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 37 35 80 00       	push   $0x803537
  8000b7:	50                   	push   %eax
  8000b8:	e8 6c 14 00 00       	call   801529 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 05 16 00 00       	call   8016cd <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 3c 35 80 00       	push   $0x80353c
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 87 14 00 00       	call   80156d <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 60 35 80 00       	push   $0x803560
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 cf 15 00 00       	call   8016cd <sys_calculate_free_frames>
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
  80011c:	68 78 35 80 00       	push   $0x803578
  800121:	6a 24                	push   $0x24
  800123:	68 1c 35 80 00       	push   $0x80351c
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 b9 19 00 00       	call   801aeb <inctst>

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
  80013b:	e8 6d 18 00 00       	call   8019ad <sys_getenvindex>
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
  8001a6:	e8 0f 16 00 00       	call   8017ba <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 1c 36 80 00       	push   $0x80361c
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
  8001d6:	68 44 36 80 00       	push   $0x803644
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
  800207:	68 6c 36 80 00       	push   $0x80366c
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 c4 36 80 00       	push   $0x8036c4
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 1c 36 80 00       	push   $0x80361c
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 8f 15 00 00       	call   8017d4 <sys_enable_interrupt>

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
  800258:	e8 1c 17 00 00       	call   801979 <sys_destroy_env>
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
  800269:	e8 71 17 00 00       	call   8019df <sys_exit_env>
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
  800292:	68 d8 36 80 00       	push   $0x8036d8
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 dd 36 80 00       	push   $0x8036dd
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
  8002cf:	68 f9 36 80 00       	push   $0x8036f9
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
  8002fb:	68 fc 36 80 00       	push   $0x8036fc
  800300:	6a 26                	push   $0x26
  800302:	68 48 37 80 00       	push   $0x803748
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
  8003cd:	68 54 37 80 00       	push   $0x803754
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 48 37 80 00       	push   $0x803748
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
  80043d:	68 a8 37 80 00       	push   $0x8037a8
  800442:	6a 44                	push   $0x44
  800444:	68 48 37 80 00       	push   $0x803748
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
  800497:	e8 70 11 00 00       	call   80160c <sys_cputs>
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
  80050e:	e8 f9 10 00 00       	call   80160c <sys_cputs>
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
  800558:	e8 5d 12 00 00       	call   8017ba <sys_disable_interrupt>
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
  800578:	e8 57 12 00 00       	call   8017d4 <sys_enable_interrupt>
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
  8005c2:	e8 c9 2c 00 00       	call   803290 <__udivdi3>
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
  800612:	e8 89 2d 00 00       	call   8033a0 <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 14 3a 80 00       	add    $0x803a14,%eax
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
  80076d:	8b 04 85 38 3a 80 00 	mov    0x803a38(,%eax,4),%eax
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
  80084e:	8b 34 9d 80 38 80 00 	mov    0x803880(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 25 3a 80 00       	push   $0x803a25
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
  800873:	68 2e 3a 80 00       	push   $0x803a2e
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
  8008a0:	be 31 3a 80 00       	mov    $0x803a31,%esi
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
  8012c6:	68 90 3b 80 00       	push   $0x803b90
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
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_PRESENT);
  801379:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801383:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801388:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138d:	83 ec 04             	sub    $0x4,%esp
  801390:	6a 03                	push   $0x3
  801392:	ff 75 f4             	pushl  -0xc(%ebp)
  801395:	50                   	push   %eax
  801396:	e8 b5 03 00 00       	call   801750 <sys_allocate_chunk>
  80139b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139e:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	50                   	push   %eax
  8013a7:	e8 2a 0a 00 00       	call   801dd6 <initialize_MemBlocksList>
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
  8013d4:	68 b5 3b 80 00       	push   $0x803bb5
  8013d9:	6a 33                	push   $0x33
  8013db:	68 d3 3b 80 00       	push   $0x803bd3
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
  801453:	68 e0 3b 80 00       	push   $0x803be0
  801458:	6a 34                	push   $0x34
  80145a:	68 d3 3b 80 00       	push   $0x803bd3
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
  8014c8:	68 04 3c 80 00       	push   $0x803c04
  8014cd:	6a 46                	push   $0x46
  8014cf:	68 d3 3b 80 00       	push   $0x803bd3
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
  8014e4:	68 2c 3c 80 00       	push   $0x803c2c
  8014e9:	6a 61                	push   $0x61
  8014eb:	68 d3 3b 80 00       	push   $0x803bd3
  8014f0:	e8 7c ed ff ff       	call   800271 <_panic>

008014f5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 18             	sub    $0x18,%esp
  8014fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8014fe:	88 45 f4             	mov    %al,-0xc(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801501:	e8 a9 fd ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  801506:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80150a:	75 07                	jne    801513 <smalloc+0x1e>
  80150c:	b8 00 00 00 00       	mov    $0x0,%eax
  801511:	eb 14                	jmp    801527 <smalloc+0x32>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  801513:	83 ec 04             	sub    $0x4,%esp
  801516:	68 50 3c 80 00       	push   $0x803c50
  80151b:	6a 76                	push   $0x76
  80151d:	68 d3 3b 80 00       	push   $0x803bd3
  801522:	e8 4a ed ff ff       	call   800271 <_panic>

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80152f:	e8 7b fd ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801534:	83 ec 04             	sub    $0x4,%esp
  801537:	68 78 3c 80 00       	push   $0x803c78
  80153c:	68 93 00 00 00       	push   $0x93
  801541:	68 d3 3b 80 00       	push   $0x803bd3
  801546:	e8 26 ed ff ff       	call   800271 <_panic>

0080154b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
  80154e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801551:	e8 59 fd ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801556:	83 ec 04             	sub    $0x4,%esp
  801559:	68 9c 3c 80 00       	push   $0x803c9c
  80155e:	68 c5 00 00 00       	push   $0xc5
  801563:	68 d3 3b 80 00       	push   $0x803bd3
  801568:	e8 04 ed ff ff       	call   800271 <_panic>

0080156d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80156d:	55                   	push   %ebp
  80156e:	89 e5                	mov    %esp,%ebp
  801570:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	68 c4 3c 80 00       	push   $0x803cc4
  80157b:	68 d9 00 00 00       	push   $0xd9
  801580:	68 d3 3b 80 00       	push   $0x803bd3
  801585:	e8 e7 ec ff ff       	call   800271 <_panic>

0080158a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801590:	83 ec 04             	sub    $0x4,%esp
  801593:	68 e8 3c 80 00       	push   $0x803ce8
  801598:	68 e4 00 00 00       	push   $0xe4
  80159d:	68 d3 3b 80 00       	push   $0x803bd3
  8015a2:	e8 ca ec ff ff       	call   800271 <_panic>

008015a7 <shrink>:

}
void shrink(uint32 newSize)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	68 e8 3c 80 00       	push   $0x803ce8
  8015b5:	68 e9 00 00 00       	push   $0xe9
  8015ba:	68 d3 3b 80 00       	push   $0x803bd3
  8015bf:	e8 ad ec ff ff       	call   800271 <_panic>

008015c4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8015ca:	83 ec 04             	sub    $0x4,%esp
  8015cd:	68 e8 3c 80 00       	push   $0x803ce8
  8015d2:	68 ee 00 00 00       	push   $0xee
  8015d7:	68 d3 3b 80 00       	push   $0x803bd3
  8015dc:	e8 90 ec ff ff       	call   800271 <_panic>

008015e1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	57                   	push   %edi
  8015e5:	56                   	push   %esi
  8015e6:	53                   	push   %ebx
  8015e7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015f6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8015f9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8015fc:	cd 30                	int    $0x30
  8015fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801601:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801604:	83 c4 10             	add    $0x10,%esp
  801607:	5b                   	pop    %ebx
  801608:	5e                   	pop    %esi
  801609:	5f                   	pop    %edi
  80160a:	5d                   	pop    %ebp
  80160b:	c3                   	ret    

0080160c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 04             	sub    $0x4,%esp
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801618:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	52                   	push   %edx
  801624:	ff 75 0c             	pushl  0xc(%ebp)
  801627:	50                   	push   %eax
  801628:	6a 00                	push   $0x0
  80162a:	e8 b2 ff ff ff       	call   8015e1 <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	90                   	nop
  801633:	c9                   	leave  
  801634:	c3                   	ret    

00801635 <sys_cgetc>:

int
sys_cgetc(void)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 01                	push   $0x1
  801644:	e8 98 ff ff ff       	call   8015e1 <syscall>
  801649:	83 c4 18             	add    $0x18,%esp
}
  80164c:	c9                   	leave  
  80164d:	c3                   	ret    

0080164e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801651:	8b 55 0c             	mov    0xc(%ebp),%edx
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	52                   	push   %edx
  80165e:	50                   	push   %eax
  80165f:	6a 05                	push   $0x5
  801661:	e8 7b ff ff ff       	call   8015e1 <syscall>
  801666:	83 c4 18             	add    $0x18,%esp
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	56                   	push   %esi
  80166f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801670:	8b 75 18             	mov    0x18(%ebp),%esi
  801673:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801676:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801679:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	56                   	push   %esi
  801680:	53                   	push   %ebx
  801681:	51                   	push   %ecx
  801682:	52                   	push   %edx
  801683:	50                   	push   %eax
  801684:	6a 06                	push   $0x6
  801686:	e8 56 ff ff ff       	call   8015e1 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801691:	5b                   	pop    %ebx
  801692:	5e                   	pop    %esi
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    

00801695 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 00                	push   $0x0
  8016a2:	6a 00                	push   $0x0
  8016a4:	52                   	push   %edx
  8016a5:	50                   	push   %eax
  8016a6:	6a 07                	push   $0x7
  8016a8:	e8 34 ff ff ff       	call   8015e1 <syscall>
  8016ad:	83 c4 18             	add    $0x18,%esp
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	ff 75 0c             	pushl  0xc(%ebp)
  8016be:	ff 75 08             	pushl  0x8(%ebp)
  8016c1:	6a 08                	push   $0x8
  8016c3:	e8 19 ff ff ff       	call   8015e1 <syscall>
  8016c8:	83 c4 18             	add    $0x18,%esp
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 09                	push   $0x9
  8016dc:	e8 00 ff ff ff       	call   8015e1 <syscall>
  8016e1:	83 c4 18             	add    $0x18,%esp
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 0a                	push   $0xa
  8016f5:	e8 e7 fe ff ff       	call   8015e1 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 0b                	push   $0xb
  80170e:	e8 ce fe ff ff       	call   8015e1 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	c9                   	leave  
  801717:	c3                   	ret    

00801718 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801718:	55                   	push   %ebp
  801719:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80171b:	6a 00                	push   $0x0
  80171d:	6a 00                	push   $0x0
  80171f:	6a 00                	push   $0x0
  801721:	ff 75 0c             	pushl  0xc(%ebp)
  801724:	ff 75 08             	pushl  0x8(%ebp)
  801727:	6a 0f                	push   $0xf
  801729:	e8 b3 fe ff ff       	call   8015e1 <syscall>
  80172e:	83 c4 18             	add    $0x18,%esp
	return;
  801731:	90                   	nop
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801737:	6a 00                	push   $0x0
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	ff 75 0c             	pushl  0xc(%ebp)
  801740:	ff 75 08             	pushl  0x8(%ebp)
  801743:	6a 10                	push   $0x10
  801745:	e8 97 fe ff ff       	call   8015e1 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
	return ;
  80174d:	90                   	nop
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801753:	6a 00                	push   $0x0
  801755:	6a 00                	push   $0x0
  801757:	ff 75 10             	pushl  0x10(%ebp)
  80175a:	ff 75 0c             	pushl  0xc(%ebp)
  80175d:	ff 75 08             	pushl  0x8(%ebp)
  801760:	6a 11                	push   $0x11
  801762:	e8 7a fe ff ff       	call   8015e1 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
	return ;
  80176a:	90                   	nop
}
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 00                	push   $0x0
  801776:	6a 00                	push   $0x0
  801778:	6a 00                	push   $0x0
  80177a:	6a 0c                	push   $0xc
  80177c:	e8 60 fe ff ff       	call   8015e1 <syscall>
  801781:	83 c4 18             	add    $0x18,%esp
}
  801784:	c9                   	leave  
  801785:	c3                   	ret    

00801786 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	6a 0d                	push   $0xd
  801796:	e8 46 fe ff ff       	call   8015e1 <syscall>
  80179b:	83 c4 18             	add    $0x18,%esp
}
  80179e:	c9                   	leave  
  80179f:	c3                   	ret    

008017a0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 0e                	push   $0xe
  8017af:	e8 2d fe ff ff       	call   8015e1 <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	90                   	nop
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    

008017ba <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 13                	push   $0x13
  8017c9:	e8 13 fe ff ff       	call   8015e1 <syscall>
  8017ce:	83 c4 18             	add    $0x18,%esp
}
  8017d1:	90                   	nop
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 14                	push   $0x14
  8017e3:	e8 f9 fd ff ff       	call   8015e1 <syscall>
  8017e8:	83 c4 18             	add    $0x18,%esp
}
  8017eb:	90                   	nop
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <sys_cputc>:


void
sys_cputc(const char c)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8017fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	50                   	push   %eax
  801807:	6a 15                	push   $0x15
  801809:	e8 d3 fd ff ff       	call   8015e1 <syscall>
  80180e:	83 c4 18             	add    $0x18,%esp
}
  801811:	90                   	nop
  801812:	c9                   	leave  
  801813:	c3                   	ret    

00801814 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801814:	55                   	push   %ebp
  801815:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	6a 16                	push   $0x16
  801823:	e8 b9 fd ff ff       	call   8015e1 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	90                   	nop
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	50                   	push   %eax
  80183e:	6a 17                	push   $0x17
  801840:	e8 9c fd ff ff       	call   8015e1 <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80184d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	52                   	push   %edx
  80185a:	50                   	push   %eax
  80185b:	6a 1a                	push   $0x1a
  80185d:	e8 7f fd ff ff       	call   8015e1 <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80186a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	52                   	push   %edx
  801877:	50                   	push   %eax
  801878:	6a 18                	push   $0x18
  80187a:	e8 62 fd ff ff       	call   8015e1 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	90                   	nop
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	52                   	push   %edx
  801895:	50                   	push   %eax
  801896:	6a 19                	push   $0x19
  801898:	e8 44 fd ff ff       	call   8015e1 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	90                   	nop
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	83 ec 04             	sub    $0x4,%esp
  8018a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ac:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8018af:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018b2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	6a 00                	push   $0x0
  8018bb:	51                   	push   %ecx
  8018bc:	52                   	push   %edx
  8018bd:	ff 75 0c             	pushl  0xc(%ebp)
  8018c0:	50                   	push   %eax
  8018c1:	6a 1b                	push   $0x1b
  8018c3:	e8 19 fd ff ff       	call   8015e1 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 1c                	push   $0x1c
  8018e0:	e8 fc fc ff ff       	call   8015e1 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8018ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	51                   	push   %ecx
  8018fb:	52                   	push   %edx
  8018fc:	50                   	push   %eax
  8018fd:	6a 1d                	push   $0x1d
  8018ff:	e8 dd fc ff ff       	call   8015e1 <syscall>
  801904:	83 c4 18             	add    $0x18,%esp
}
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80190c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	52                   	push   %edx
  801919:	50                   	push   %eax
  80191a:	6a 1e                	push   $0x1e
  80191c:	e8 c0 fc ff ff       	call   8015e1 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 1f                	push   $0x1f
  801935:	e8 a7 fc ff ff       	call   8015e1 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	ff 75 14             	pushl  0x14(%ebp)
  80194a:	ff 75 10             	pushl  0x10(%ebp)
  80194d:	ff 75 0c             	pushl  0xc(%ebp)
  801950:	50                   	push   %eax
  801951:	6a 20                	push   $0x20
  801953:	e8 89 fc ff ff       	call   8015e1 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	50                   	push   %eax
  80196c:	6a 21                	push   $0x21
  80196e:	e8 6e fc ff ff       	call   8015e1 <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	90                   	nop
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	50                   	push   %eax
  801988:	6a 22                	push   $0x22
  80198a:	e8 52 fc ff ff       	call   8015e1 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 02                	push   $0x2
  8019a3:	e8 39 fc ff ff       	call   8015e1 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 03                	push   $0x3
  8019bc:	e8 20 fc ff ff       	call   8015e1 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 04                	push   $0x4
  8019d5:	e8 07 fc ff ff       	call   8015e1 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <sys_exit_env>:


void sys_exit_env(void)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 23                	push   $0x23
  8019ee:	e8 ee fb ff ff       	call   8015e1 <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	90                   	nop
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8019ff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a02:	8d 50 04             	lea    0x4(%eax),%edx
  801a05:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	52                   	push   %edx
  801a0f:	50                   	push   %eax
  801a10:	6a 24                	push   $0x24
  801a12:	e8 ca fb ff ff       	call   8015e1 <syscall>
  801a17:	83 c4 18             	add    $0x18,%esp
	return result;
  801a1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a20:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a23:	89 01                	mov    %eax,(%ecx)
  801a25:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	c9                   	leave  
  801a2c:	c2 04 00             	ret    $0x4

00801a2f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	ff 75 10             	pushl  0x10(%ebp)
  801a39:	ff 75 0c             	pushl  0xc(%ebp)
  801a3c:	ff 75 08             	pushl  0x8(%ebp)
  801a3f:	6a 12                	push   $0x12
  801a41:	e8 9b fb ff ff       	call   8015e1 <syscall>
  801a46:	83 c4 18             	add    $0x18,%esp
	return ;
  801a49:	90                   	nop
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_rcr2>:
uint32 sys_rcr2()
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 25                	push   $0x25
  801a5b:	e8 81 fb ff ff       	call   8015e1 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 04             	sub    $0x4,%esp
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801a71:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	50                   	push   %eax
  801a7e:	6a 26                	push   $0x26
  801a80:	e8 5c fb ff ff       	call   8015e1 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
	return ;
  801a88:	90                   	nop
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <rsttst>:
void rsttst()
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 28                	push   $0x28
  801a9a:	e8 42 fb ff ff       	call   8015e1 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa2:	90                   	nop
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 04             	sub    $0x4,%esp
  801aab:	8b 45 14             	mov    0x14(%ebp),%eax
  801aae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ab1:	8b 55 18             	mov    0x18(%ebp),%edx
  801ab4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab8:	52                   	push   %edx
  801ab9:	50                   	push   %eax
  801aba:	ff 75 10             	pushl  0x10(%ebp)
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	ff 75 08             	pushl  0x8(%ebp)
  801ac3:	6a 27                	push   $0x27
  801ac5:	e8 17 fb ff ff       	call   8015e1 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
	return ;
  801acd:	90                   	nop
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <chktst>:
void chktst(uint32 n)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	ff 75 08             	pushl  0x8(%ebp)
  801ade:	6a 29                	push   $0x29
  801ae0:	e8 fc fa ff ff       	call   8015e1 <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ae8:	90                   	nop
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <inctst>:

void inctst()
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 2a                	push   $0x2a
  801afa:	e8 e2 fa ff ff       	call   8015e1 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
	return ;
  801b02:	90                   	nop
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <gettst>:
uint32 gettst()
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 2b                	push   $0x2b
  801b14:	e8 c8 fa ff ff       	call   8015e1 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 2c                	push   $0x2c
  801b30:	e8 ac fa ff ff       	call   8015e1 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
  801b38:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801b3b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801b3f:	75 07                	jne    801b48 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801b41:	b8 01 00 00 00       	mov    $0x1,%eax
  801b46:	eb 05                	jmp    801b4d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 2c                	push   $0x2c
  801b61:	e8 7b fa ff ff       	call   8015e1 <syscall>
  801b66:	83 c4 18             	add    $0x18,%esp
  801b69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801b6c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801b70:	75 07                	jne    801b79 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801b72:	b8 01 00 00 00       	mov    $0x1,%eax
  801b77:	eb 05                	jmp    801b7e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801b79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 2c                	push   $0x2c
  801b92:	e8 4a fa ff ff       	call   8015e1 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
  801b9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b9d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ba1:	75 07                	jne    801baa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ba3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba8:	eb 05                	jmp    801baf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801baa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 2c                	push   $0x2c
  801bc3:	e8 19 fa ff ff       	call   8015e1 <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
  801bcb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801bce:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801bd2:	75 07                	jne    801bdb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801bd4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd9:	eb 05                	jmp    801be0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	ff 75 08             	pushl  0x8(%ebp)
  801bf0:	6a 2d                	push   $0x2d
  801bf2:	e8 ea f9 ff ff       	call   8015e1 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
  801c00:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	53                   	push   %ebx
  801c10:	51                   	push   %ecx
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 2e                	push   $0x2e
  801c15:	e8 c7 f9 ff ff       	call   8015e1 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	52                   	push   %edx
  801c32:	50                   	push   %eax
  801c33:	6a 2f                	push   $0x2f
  801c35:	e8 a7 f9 ff ff       	call   8015e1 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
}
  801c3d:	c9                   	leave  
  801c3e:	c3                   	ret    

00801c3f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801c45:	83 ec 0c             	sub    $0xc,%esp
  801c48:	68 f8 3c 80 00       	push   $0x803cf8
  801c4d:	e8 d3 e8 ff ff       	call   800525 <cprintf>
  801c52:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801c55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801c5c:	83 ec 0c             	sub    $0xc,%esp
  801c5f:	68 24 3d 80 00       	push   $0x803d24
  801c64:	e8 bc e8 ff ff       	call   800525 <cprintf>
  801c69:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801c6c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801c70:	a1 38 41 80 00       	mov    0x804138,%eax
  801c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c78:	eb 56                	jmp    801cd0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801c7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c7e:	74 1c                	je     801c9c <print_mem_block_lists+0x5d>
  801c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c83:	8b 50 08             	mov    0x8(%eax),%edx
  801c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c89:	8b 48 08             	mov    0x8(%eax),%ecx
  801c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c92:	01 c8                	add    %ecx,%eax
  801c94:	39 c2                	cmp    %eax,%edx
  801c96:	73 04                	jae    801c9c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801c98:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9f:	8b 50 08             	mov    0x8(%eax),%edx
  801ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca8:	01 c2                	add    %eax,%edx
  801caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cad:	8b 40 08             	mov    0x8(%eax),%eax
  801cb0:	83 ec 04             	sub    $0x4,%esp
  801cb3:	52                   	push   %edx
  801cb4:	50                   	push   %eax
  801cb5:	68 39 3d 80 00       	push   $0x803d39
  801cba:	e8 66 e8 ff ff       	call   800525 <cprintf>
  801cbf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801cc8:	a1 40 41 80 00       	mov    0x804140,%eax
  801ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cd4:	74 07                	je     801cdd <print_mem_block_lists+0x9e>
  801cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd9:	8b 00                	mov    (%eax),%eax
  801cdb:	eb 05                	jmp    801ce2 <print_mem_block_lists+0xa3>
  801cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce2:	a3 40 41 80 00       	mov    %eax,0x804140
  801ce7:	a1 40 41 80 00       	mov    0x804140,%eax
  801cec:	85 c0                	test   %eax,%eax
  801cee:	75 8a                	jne    801c7a <print_mem_block_lists+0x3b>
  801cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cf4:	75 84                	jne    801c7a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801cf6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801cfa:	75 10                	jne    801d0c <print_mem_block_lists+0xcd>
  801cfc:	83 ec 0c             	sub    $0xc,%esp
  801cff:	68 48 3d 80 00       	push   $0x803d48
  801d04:	e8 1c e8 ff ff       	call   800525 <cprintf>
  801d09:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d0c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d13:	83 ec 0c             	sub    $0xc,%esp
  801d16:	68 6c 3d 80 00       	push   $0x803d6c
  801d1b:	e8 05 e8 ff ff       	call   800525 <cprintf>
  801d20:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d23:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d27:	a1 40 40 80 00       	mov    0x804040,%eax
  801d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d2f:	eb 56                	jmp    801d87 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d35:	74 1c                	je     801d53 <print_mem_block_lists+0x114>
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3a:	8b 50 08             	mov    0x8(%eax),%edx
  801d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d40:	8b 48 08             	mov    0x8(%eax),%ecx
  801d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d46:	8b 40 0c             	mov    0xc(%eax),%eax
  801d49:	01 c8                	add    %ecx,%eax
  801d4b:	39 c2                	cmp    %eax,%edx
  801d4d:	73 04                	jae    801d53 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801d4f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d56:	8b 50 08             	mov    0x8(%eax),%edx
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5f:	01 c2                	add    %eax,%edx
  801d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d64:	8b 40 08             	mov    0x8(%eax),%eax
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	52                   	push   %edx
  801d6b:	50                   	push   %eax
  801d6c:	68 39 3d 80 00       	push   $0x803d39
  801d71:	e8 af e7 ff ff       	call   800525 <cprintf>
  801d76:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801d7f:	a1 48 40 80 00       	mov    0x804048,%eax
  801d84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d8b:	74 07                	je     801d94 <print_mem_block_lists+0x155>
  801d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d90:	8b 00                	mov    (%eax),%eax
  801d92:	eb 05                	jmp    801d99 <print_mem_block_lists+0x15a>
  801d94:	b8 00 00 00 00       	mov    $0x0,%eax
  801d99:	a3 48 40 80 00       	mov    %eax,0x804048
  801d9e:	a1 48 40 80 00       	mov    0x804048,%eax
  801da3:	85 c0                	test   %eax,%eax
  801da5:	75 8a                	jne    801d31 <print_mem_block_lists+0xf2>
  801da7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dab:	75 84                	jne    801d31 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801dad:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801db1:	75 10                	jne    801dc3 <print_mem_block_lists+0x184>
  801db3:	83 ec 0c             	sub    $0xc,%esp
  801db6:	68 84 3d 80 00       	push   $0x803d84
  801dbb:	e8 65 e7 ff ff       	call   800525 <cprintf>
  801dc0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801dc3:	83 ec 0c             	sub    $0xc,%esp
  801dc6:	68 f8 3c 80 00       	push   $0x803cf8
  801dcb:	e8 55 e7 ff ff       	call   800525 <cprintf>
  801dd0:	83 c4 10             	add    $0x10,%esp

}
  801dd3:	90                   	nop
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801ddc:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801de3:	00 00 00 
  801de6:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ded:	00 00 00 
  801df0:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801df7:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801dfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e01:	e9 9e 00 00 00       	jmp    801ea4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e06:	a1 50 40 80 00       	mov    0x804050,%eax
  801e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0e:	c1 e2 04             	shl    $0x4,%edx
  801e11:	01 d0                	add    %edx,%eax
  801e13:	85 c0                	test   %eax,%eax
  801e15:	75 14                	jne    801e2b <initialize_MemBlocksList+0x55>
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	68 ac 3d 80 00       	push   $0x803dac
  801e1f:	6a 46                	push   $0x46
  801e21:	68 cf 3d 80 00       	push   $0x803dcf
  801e26:	e8 46 e4 ff ff       	call   800271 <_panic>
  801e2b:	a1 50 40 80 00       	mov    0x804050,%eax
  801e30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e33:	c1 e2 04             	shl    $0x4,%edx
  801e36:	01 d0                	add    %edx,%eax
  801e38:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801e3e:	89 10                	mov    %edx,(%eax)
  801e40:	8b 00                	mov    (%eax),%eax
  801e42:	85 c0                	test   %eax,%eax
  801e44:	74 18                	je     801e5e <initialize_MemBlocksList+0x88>
  801e46:	a1 48 41 80 00       	mov    0x804148,%eax
  801e4b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801e51:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801e54:	c1 e1 04             	shl    $0x4,%ecx
  801e57:	01 ca                	add    %ecx,%edx
  801e59:	89 50 04             	mov    %edx,0x4(%eax)
  801e5c:	eb 12                	jmp    801e70 <initialize_MemBlocksList+0x9a>
  801e5e:	a1 50 40 80 00       	mov    0x804050,%eax
  801e63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e66:	c1 e2 04             	shl    $0x4,%edx
  801e69:	01 d0                	add    %edx,%eax
  801e6b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801e70:	a1 50 40 80 00       	mov    0x804050,%eax
  801e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e78:	c1 e2 04             	shl    $0x4,%edx
  801e7b:	01 d0                	add    %edx,%eax
  801e7d:	a3 48 41 80 00       	mov    %eax,0x804148
  801e82:	a1 50 40 80 00       	mov    0x804050,%eax
  801e87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e8a:	c1 e2 04             	shl    $0x4,%edx
  801e8d:	01 d0                	add    %edx,%eax
  801e8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e96:	a1 54 41 80 00       	mov    0x804154,%eax
  801e9b:	40                   	inc    %eax
  801e9c:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801ea1:	ff 45 f4             	incl   -0xc(%ebp)
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	3b 45 08             	cmp    0x8(%ebp),%eax
  801eaa:	0f 82 56 ff ff ff    	jb     801e06 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801eb0:	90                   	nop
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebc:	8b 00                	mov    (%eax),%eax
  801ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801ec1:	eb 19                	jmp    801edc <find_block+0x29>
	{
		if(va==point->sva)
  801ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ec6:	8b 40 08             	mov    0x8(%eax),%eax
  801ec9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ecc:	75 05                	jne    801ed3 <find_block+0x20>
		   return point;
  801ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ed1:	eb 36                	jmp    801f09 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	8b 40 08             	mov    0x8(%eax),%eax
  801ed9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801edc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ee0:	74 07                	je     801ee9 <find_block+0x36>
  801ee2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	eb 05                	jmp    801eee <find_block+0x3b>
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eee:	8b 55 08             	mov    0x8(%ebp),%edx
  801ef1:	89 42 08             	mov    %eax,0x8(%edx)
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	8b 40 08             	mov    0x8(%eax),%eax
  801efa:	85 c0                	test   %eax,%eax
  801efc:	75 c5                	jne    801ec3 <find_block+0x10>
  801efe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f02:	75 bf                	jne    801ec3 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f11:	a1 40 40 80 00       	mov    0x804040,%eax
  801f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f19:	a1 44 40 80 00       	mov    0x804044,%eax
  801f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801f27:	74 24                	je     801f4d <insert_sorted_allocList+0x42>
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	8b 50 08             	mov    0x8(%eax),%edx
  801f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f32:	8b 40 08             	mov    0x8(%eax),%eax
  801f35:	39 c2                	cmp    %eax,%edx
  801f37:	76 14                	jbe    801f4d <insert_sorted_allocList+0x42>
  801f39:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3c:	8b 50 08             	mov    0x8(%eax),%edx
  801f3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f42:	8b 40 08             	mov    0x8(%eax),%eax
  801f45:	39 c2                	cmp    %eax,%edx
  801f47:	0f 82 60 01 00 00    	jb     8020ad <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801f4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f51:	75 65                	jne    801fb8 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801f53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801f57:	75 14                	jne    801f6d <insert_sorted_allocList+0x62>
  801f59:	83 ec 04             	sub    $0x4,%esp
  801f5c:	68 ac 3d 80 00       	push   $0x803dac
  801f61:	6a 6b                	push   $0x6b
  801f63:	68 cf 3d 80 00       	push   $0x803dcf
  801f68:	e8 04 e3 ff ff       	call   800271 <_panic>
  801f6d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	89 10                	mov    %edx,(%eax)
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	8b 00                	mov    (%eax),%eax
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	74 0d                	je     801f8e <insert_sorted_allocList+0x83>
  801f81:	a1 40 40 80 00       	mov    0x804040,%eax
  801f86:	8b 55 08             	mov    0x8(%ebp),%edx
  801f89:	89 50 04             	mov    %edx,0x4(%eax)
  801f8c:	eb 08                	jmp    801f96 <insert_sorted_allocList+0x8b>
  801f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f91:	a3 44 40 80 00       	mov    %eax,0x804044
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	a3 40 40 80 00       	mov    %eax,0x804040
  801f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fa8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fad:	40                   	inc    %eax
  801fae:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  801fb3:	e9 dc 01 00 00       	jmp    802194 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	8b 50 08             	mov    0x8(%eax),%edx
  801fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc1:	8b 40 08             	mov    0x8(%eax),%eax
  801fc4:	39 c2                	cmp    %eax,%edx
  801fc6:	77 6c                	ja     802034 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  801fc8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fcc:	74 06                	je     801fd4 <insert_sorted_allocList+0xc9>
  801fce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fd2:	75 14                	jne    801fe8 <insert_sorted_allocList+0xdd>
  801fd4:	83 ec 04             	sub    $0x4,%esp
  801fd7:	68 e8 3d 80 00       	push   $0x803de8
  801fdc:	6a 6f                	push   $0x6f
  801fde:	68 cf 3d 80 00       	push   $0x803dcf
  801fe3:	e8 89 e2 ff ff       	call   800271 <_panic>
  801fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801feb:	8b 50 04             	mov    0x4(%eax),%edx
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	89 50 04             	mov    %edx,0x4(%eax)
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ffa:	89 10                	mov    %edx,(%eax)
  801ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fff:	8b 40 04             	mov    0x4(%eax),%eax
  802002:	85 c0                	test   %eax,%eax
  802004:	74 0d                	je     802013 <insert_sorted_allocList+0x108>
  802006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802009:	8b 40 04             	mov    0x4(%eax),%eax
  80200c:	8b 55 08             	mov    0x8(%ebp),%edx
  80200f:	89 10                	mov    %edx,(%eax)
  802011:	eb 08                	jmp    80201b <insert_sorted_allocList+0x110>
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	a3 40 40 80 00       	mov    %eax,0x804040
  80201b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201e:	8b 55 08             	mov    0x8(%ebp),%edx
  802021:	89 50 04             	mov    %edx,0x4(%eax)
  802024:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802029:	40                   	inc    %eax
  80202a:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80202f:	e9 60 01 00 00       	jmp    802194 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	8b 50 08             	mov    0x8(%eax),%edx
  80203a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203d:	8b 40 08             	mov    0x8(%eax),%eax
  802040:	39 c2                	cmp    %eax,%edx
  802042:	0f 82 4c 01 00 00    	jb     802194 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802048:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204c:	75 14                	jne    802062 <insert_sorted_allocList+0x157>
  80204e:	83 ec 04             	sub    $0x4,%esp
  802051:	68 20 3e 80 00       	push   $0x803e20
  802056:	6a 73                	push   $0x73
  802058:	68 cf 3d 80 00       	push   $0x803dcf
  80205d:	e8 0f e2 ff ff       	call   800271 <_panic>
  802062:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	89 50 04             	mov    %edx,0x4(%eax)
  80206e:	8b 45 08             	mov    0x8(%ebp),%eax
  802071:	8b 40 04             	mov    0x4(%eax),%eax
  802074:	85 c0                	test   %eax,%eax
  802076:	74 0c                	je     802084 <insert_sorted_allocList+0x179>
  802078:	a1 44 40 80 00       	mov    0x804044,%eax
  80207d:	8b 55 08             	mov    0x8(%ebp),%edx
  802080:	89 10                	mov    %edx,(%eax)
  802082:	eb 08                	jmp    80208c <insert_sorted_allocList+0x181>
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	a3 40 40 80 00       	mov    %eax,0x804040
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	a3 44 40 80 00       	mov    %eax,0x804044
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80209d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020a2:	40                   	inc    %eax
  8020a3:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020a8:	e9 e7 00 00 00       	jmp    802194 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8020ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8020b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8020ba:	a1 40 40 80 00       	mov    0x804040,%eax
  8020bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c2:	e9 9d 00 00 00       	jmp    802164 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8020c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ca:	8b 00                	mov    (%eax),%eax
  8020cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	8b 50 08             	mov    0x8(%eax),%edx
  8020d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d8:	8b 40 08             	mov    0x8(%eax),%eax
  8020db:	39 c2                	cmp    %eax,%edx
  8020dd:	76 7d                	jbe    80215c <insert_sorted_allocList+0x251>
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	8b 50 08             	mov    0x8(%eax),%edx
  8020e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020e8:	8b 40 08             	mov    0x8(%eax),%eax
  8020eb:	39 c2                	cmp    %eax,%edx
  8020ed:	73 6d                	jae    80215c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8020ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f3:	74 06                	je     8020fb <insert_sorted_allocList+0x1f0>
  8020f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f9:	75 14                	jne    80210f <insert_sorted_allocList+0x204>
  8020fb:	83 ec 04             	sub    $0x4,%esp
  8020fe:	68 44 3e 80 00       	push   $0x803e44
  802103:	6a 7f                	push   $0x7f
  802105:	68 cf 3d 80 00       	push   $0x803dcf
  80210a:	e8 62 e1 ff ff       	call   800271 <_panic>
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	8b 10                	mov    (%eax),%edx
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	89 10                	mov    %edx,(%eax)
  802119:	8b 45 08             	mov    0x8(%ebp),%eax
  80211c:	8b 00                	mov    (%eax),%eax
  80211e:	85 c0                	test   %eax,%eax
  802120:	74 0b                	je     80212d <insert_sorted_allocList+0x222>
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802125:	8b 00                	mov    (%eax),%eax
  802127:	8b 55 08             	mov    0x8(%ebp),%edx
  80212a:	89 50 04             	mov    %edx,0x4(%eax)
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 55 08             	mov    0x8(%ebp),%edx
  802133:	89 10                	mov    %edx,(%eax)
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213b:	89 50 04             	mov    %edx,0x4(%eax)
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	8b 00                	mov    (%eax),%eax
  802143:	85 c0                	test   %eax,%eax
  802145:	75 08                	jne    80214f <insert_sorted_allocList+0x244>
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	a3 44 40 80 00       	mov    %eax,0x804044
  80214f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802154:	40                   	inc    %eax
  802155:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  80215a:	eb 39                	jmp    802195 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80215c:	a1 48 40 80 00       	mov    0x804048,%eax
  802161:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802164:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802168:	74 07                	je     802171 <insert_sorted_allocList+0x266>
  80216a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216d:	8b 00                	mov    (%eax),%eax
  80216f:	eb 05                	jmp    802176 <insert_sorted_allocList+0x26b>
  802171:	b8 00 00 00 00       	mov    $0x0,%eax
  802176:	a3 48 40 80 00       	mov    %eax,0x804048
  80217b:	a1 48 40 80 00       	mov    0x804048,%eax
  802180:	85 c0                	test   %eax,%eax
  802182:	0f 85 3f ff ff ff    	jne    8020c7 <insert_sorted_allocList+0x1bc>
  802188:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80218c:	0f 85 35 ff ff ff    	jne    8020c7 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802192:	eb 01                	jmp    802195 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802194:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802195:	90                   	nop
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80219e:	a1 38 41 80 00       	mov    0x804138,%eax
  8021a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a6:	e9 85 01 00 00       	jmp    802330 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8021ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b4:	0f 82 6e 01 00 00    	jb     802328 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021c3:	0f 85 8a 00 00 00    	jne    802253 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8021c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cd:	75 17                	jne    8021e6 <alloc_block_FF+0x4e>
  8021cf:	83 ec 04             	sub    $0x4,%esp
  8021d2:	68 78 3e 80 00       	push   $0x803e78
  8021d7:	68 93 00 00 00       	push   $0x93
  8021dc:	68 cf 3d 80 00       	push   $0x803dcf
  8021e1:	e8 8b e0 ff ff       	call   800271 <_panic>
  8021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e9:	8b 00                	mov    (%eax),%eax
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	74 10                	je     8021ff <alloc_block_FF+0x67>
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	8b 00                	mov    (%eax),%eax
  8021f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f7:	8b 52 04             	mov    0x4(%edx),%edx
  8021fa:	89 50 04             	mov    %edx,0x4(%eax)
  8021fd:	eb 0b                	jmp    80220a <alloc_block_FF+0x72>
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	8b 40 04             	mov    0x4(%eax),%eax
  802205:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	8b 40 04             	mov    0x4(%eax),%eax
  802210:	85 c0                	test   %eax,%eax
  802212:	74 0f                	je     802223 <alloc_block_FF+0x8b>
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	8b 40 04             	mov    0x4(%eax),%eax
  80221a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221d:	8b 12                	mov    (%edx),%edx
  80221f:	89 10                	mov    %edx,(%eax)
  802221:	eb 0a                	jmp    80222d <alloc_block_FF+0x95>
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	8b 00                	mov    (%eax),%eax
  802228:	a3 38 41 80 00       	mov    %eax,0x804138
  80222d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802230:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802240:	a1 44 41 80 00       	mov    0x804144,%eax
  802245:	48                   	dec    %eax
  802246:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	e9 10 01 00 00       	jmp    802363 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 40 0c             	mov    0xc(%eax),%eax
  802259:	3b 45 08             	cmp    0x8(%ebp),%eax
  80225c:	0f 86 c6 00 00 00    	jbe    802328 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802262:	a1 48 41 80 00       	mov    0x804148,%eax
  802267:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	8b 50 08             	mov    0x8(%eax),%edx
  802270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802273:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802276:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802279:	8b 55 08             	mov    0x8(%ebp),%edx
  80227c:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80227f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802283:	75 17                	jne    80229c <alloc_block_FF+0x104>
  802285:	83 ec 04             	sub    $0x4,%esp
  802288:	68 78 3e 80 00       	push   $0x803e78
  80228d:	68 9b 00 00 00       	push   $0x9b
  802292:	68 cf 3d 80 00       	push   $0x803dcf
  802297:	e8 d5 df ff ff       	call   800271 <_panic>
  80229c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80229f:	8b 00                	mov    (%eax),%eax
  8022a1:	85 c0                	test   %eax,%eax
  8022a3:	74 10                	je     8022b5 <alloc_block_FF+0x11d>
  8022a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a8:	8b 00                	mov    (%eax),%eax
  8022aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ad:	8b 52 04             	mov    0x4(%edx),%edx
  8022b0:	89 50 04             	mov    %edx,0x4(%eax)
  8022b3:	eb 0b                	jmp    8022c0 <alloc_block_FF+0x128>
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b8:	8b 40 04             	mov    0x4(%eax),%eax
  8022bb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c3:	8b 40 04             	mov    0x4(%eax),%eax
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	74 0f                	je     8022d9 <alloc_block_FF+0x141>
  8022ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022cd:	8b 40 04             	mov    0x4(%eax),%eax
  8022d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d3:	8b 12                	mov    (%edx),%edx
  8022d5:	89 10                	mov    %edx,(%eax)
  8022d7:	eb 0a                	jmp    8022e3 <alloc_block_FF+0x14b>
  8022d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	a3 48 41 80 00       	mov    %eax,0x804148
  8022e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f6:	a1 54 41 80 00       	mov    0x804154,%eax
  8022fb:	48                   	dec    %eax
  8022fc:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 50 08             	mov    0x8(%eax),%edx
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	01 c2                	add    %eax,%edx
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 40 0c             	mov    0xc(%eax),%eax
  802318:	2b 45 08             	sub    0x8(%ebp),%eax
  80231b:	89 c2                	mov    %eax,%edx
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802326:	eb 3b                	jmp    802363 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802328:	a1 40 41 80 00       	mov    0x804140,%eax
  80232d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802334:	74 07                	je     80233d <alloc_block_FF+0x1a5>
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 00                	mov    (%eax),%eax
  80233b:	eb 05                	jmp    802342 <alloc_block_FF+0x1aa>
  80233d:	b8 00 00 00 00       	mov    $0x0,%eax
  802342:	a3 40 41 80 00       	mov    %eax,0x804140
  802347:	a1 40 41 80 00       	mov    0x804140,%eax
  80234c:	85 c0                	test   %eax,%eax
  80234e:	0f 85 57 fe ff ff    	jne    8021ab <alloc_block_FF+0x13>
  802354:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802358:	0f 85 4d fe ff ff    	jne    8021ab <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  80236b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802372:	a1 38 41 80 00       	mov    0x804138,%eax
  802377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237a:	e9 df 00 00 00       	jmp    80245e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 40 0c             	mov    0xc(%eax),%eax
  802385:	3b 45 08             	cmp    0x8(%ebp),%eax
  802388:	0f 82 c8 00 00 00    	jb     802456 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 40 0c             	mov    0xc(%eax),%eax
  802394:	3b 45 08             	cmp    0x8(%ebp),%eax
  802397:	0f 85 8a 00 00 00    	jne    802427 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80239d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a1:	75 17                	jne    8023ba <alloc_block_BF+0x55>
  8023a3:	83 ec 04             	sub    $0x4,%esp
  8023a6:	68 78 3e 80 00       	push   $0x803e78
  8023ab:	68 b7 00 00 00       	push   $0xb7
  8023b0:	68 cf 3d 80 00       	push   $0x803dcf
  8023b5:	e8 b7 de ff ff       	call   800271 <_panic>
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 00                	mov    (%eax),%eax
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	74 10                	je     8023d3 <alloc_block_BF+0x6e>
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cb:	8b 52 04             	mov    0x4(%edx),%edx
  8023ce:	89 50 04             	mov    %edx,0x4(%eax)
  8023d1:	eb 0b                	jmp    8023de <alloc_block_BF+0x79>
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	8b 40 04             	mov    0x4(%eax),%eax
  8023d9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 40 04             	mov    0x4(%eax),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	74 0f                	je     8023f7 <alloc_block_BF+0x92>
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 40 04             	mov    0x4(%eax),%eax
  8023ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f1:	8b 12                	mov    (%edx),%edx
  8023f3:	89 10                	mov    %edx,(%eax)
  8023f5:	eb 0a                	jmp    802401 <alloc_block_BF+0x9c>
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	a3 38 41 80 00       	mov    %eax,0x804138
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802414:	a1 44 41 80 00       	mov    0x804144,%eax
  802419:	48                   	dec    %eax
  80241a:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	e9 4d 01 00 00       	jmp    802574 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 0c             	mov    0xc(%eax),%eax
  80242d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802430:	76 24                	jbe    802456 <alloc_block_BF+0xf1>
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 40 0c             	mov    0xc(%eax),%eax
  802438:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80243b:	73 19                	jae    802456 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80243d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 40 0c             	mov    0xc(%eax),%eax
  80244a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 40 08             	mov    0x8(%eax),%eax
  802453:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802456:	a1 40 41 80 00       	mov    0x804140,%eax
  80245b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802462:	74 07                	je     80246b <alloc_block_BF+0x106>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	eb 05                	jmp    802470 <alloc_block_BF+0x10b>
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	a3 40 41 80 00       	mov    %eax,0x804140
  802475:	a1 40 41 80 00       	mov    0x804140,%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	0f 85 fd fe ff ff    	jne    80237f <alloc_block_BF+0x1a>
  802482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802486:	0f 85 f3 fe ff ff    	jne    80237f <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80248c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802490:	0f 84 d9 00 00 00    	je     80256f <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802496:	a1 48 41 80 00       	mov    0x804148,%eax
  80249b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80249e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8024a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ad:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8024b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8024b4:	75 17                	jne    8024cd <alloc_block_BF+0x168>
  8024b6:	83 ec 04             	sub    $0x4,%esp
  8024b9:	68 78 3e 80 00       	push   $0x803e78
  8024be:	68 c7 00 00 00       	push   $0xc7
  8024c3:	68 cf 3d 80 00       	push   $0x803dcf
  8024c8:	e8 a4 dd ff ff       	call   800271 <_panic>
  8024cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 10                	je     8024e6 <alloc_block_BF+0x181>
  8024d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024de:	8b 52 04             	mov    0x4(%edx),%edx
  8024e1:	89 50 04             	mov    %edx,0x4(%eax)
  8024e4:	eb 0b                	jmp    8024f1 <alloc_block_BF+0x18c>
  8024e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f4:	8b 40 04             	mov    0x4(%eax),%eax
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	74 0f                	je     80250a <alloc_block_BF+0x1a5>
  8024fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fe:	8b 40 04             	mov    0x4(%eax),%eax
  802501:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802504:	8b 12                	mov    (%edx),%edx
  802506:	89 10                	mov    %edx,(%eax)
  802508:	eb 0a                	jmp    802514 <alloc_block_BF+0x1af>
  80250a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	a3 48 41 80 00       	mov    %eax,0x804148
  802514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802517:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802527:	a1 54 41 80 00       	mov    0x804154,%eax
  80252c:	48                   	dec    %eax
  80252d:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802532:	83 ec 08             	sub    $0x8,%esp
  802535:	ff 75 ec             	pushl  -0x14(%ebp)
  802538:	68 38 41 80 00       	push   $0x804138
  80253d:	e8 71 f9 ff ff       	call   801eb3 <find_block>
  802542:	83 c4 10             	add    $0x10,%esp
  802545:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802548:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80254b:	8b 50 08             	mov    0x8(%eax),%edx
  80254e:	8b 45 08             	mov    0x8(%ebp),%eax
  802551:	01 c2                	add    %eax,%edx
  802553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802556:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802559:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80255c:	8b 40 0c             	mov    0xc(%eax),%eax
  80255f:	2b 45 08             	sub    0x8(%ebp),%eax
  802562:	89 c2                	mov    %eax,%edx
  802564:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802567:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  80256a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256d:	eb 05                	jmp    802574 <alloc_block_BF+0x20f>
	}
	return NULL;
  80256f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80257c:	a1 28 40 80 00       	mov    0x804028,%eax
  802581:	85 c0                	test   %eax,%eax
  802583:	0f 85 de 01 00 00    	jne    802767 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802589:	a1 38 41 80 00       	mov    0x804138,%eax
  80258e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802591:	e9 9e 01 00 00       	jmp    802734 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 40 0c             	mov    0xc(%eax),%eax
  80259c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259f:	0f 82 87 01 00 00    	jb     80272c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ab:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ae:	0f 85 95 00 00 00    	jne    802649 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8025b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b8:	75 17                	jne    8025d1 <alloc_block_NF+0x5b>
  8025ba:	83 ec 04             	sub    $0x4,%esp
  8025bd:	68 78 3e 80 00       	push   $0x803e78
  8025c2:	68 e0 00 00 00       	push   $0xe0
  8025c7:	68 cf 3d 80 00       	push   $0x803dcf
  8025cc:	e8 a0 dc ff ff       	call   800271 <_panic>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	74 10                	je     8025ea <alloc_block_NF+0x74>
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e2:	8b 52 04             	mov    0x4(%edx),%edx
  8025e5:	89 50 04             	mov    %edx,0x4(%eax)
  8025e8:	eb 0b                	jmp    8025f5 <alloc_block_NF+0x7f>
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 40 04             	mov    0x4(%eax),%eax
  8025f0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 40 04             	mov    0x4(%eax),%eax
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	74 0f                	je     80260e <alloc_block_NF+0x98>
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 40 04             	mov    0x4(%eax),%eax
  802605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802608:	8b 12                	mov    (%edx),%edx
  80260a:	89 10                	mov    %edx,(%eax)
  80260c:	eb 0a                	jmp    802618 <alloc_block_NF+0xa2>
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 00                	mov    (%eax),%eax
  802613:	a3 38 41 80 00       	mov    %eax,0x804138
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262b:	a1 44 41 80 00       	mov    0x804144,%eax
  802630:	48                   	dec    %eax
  802631:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 40 08             	mov    0x8(%eax),%eax
  80263c:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	e9 f8 04 00 00       	jmp    802b41 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 0c             	mov    0xc(%eax),%eax
  80264f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802652:	0f 86 d4 00 00 00    	jbe    80272c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802658:	a1 48 41 80 00       	mov    0x804148,%eax
  80265d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	8b 50 08             	mov    0x8(%eax),%edx
  802666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802669:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	8b 55 08             	mov    0x8(%ebp),%edx
  802672:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802675:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802679:	75 17                	jne    802692 <alloc_block_NF+0x11c>
  80267b:	83 ec 04             	sub    $0x4,%esp
  80267e:	68 78 3e 80 00       	push   $0x803e78
  802683:	68 e9 00 00 00       	push   $0xe9
  802688:	68 cf 3d 80 00       	push   $0x803dcf
  80268d:	e8 df db ff ff       	call   800271 <_panic>
  802692:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	85 c0                	test   %eax,%eax
  802699:	74 10                	je     8026ab <alloc_block_NF+0x135>
  80269b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269e:	8b 00                	mov    (%eax),%eax
  8026a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a3:	8b 52 04             	mov    0x4(%edx),%edx
  8026a6:	89 50 04             	mov    %edx,0x4(%eax)
  8026a9:	eb 0b                	jmp    8026b6 <alloc_block_NF+0x140>
  8026ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	8b 40 04             	mov    0x4(%eax),%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	74 0f                	je     8026cf <alloc_block_NF+0x159>
  8026c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c3:	8b 40 04             	mov    0x4(%eax),%eax
  8026c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c9:	8b 12                	mov    (%edx),%edx
  8026cb:	89 10                	mov    %edx,(%eax)
  8026cd:	eb 0a                	jmp    8026d9 <alloc_block_NF+0x163>
  8026cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	a3 48 41 80 00       	mov    %eax,0x804148
  8026d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ec:	a1 54 41 80 00       	mov    0x804154,%eax
  8026f1:	48                   	dec    %eax
  8026f2:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fa:	8b 40 08             	mov    0x8(%eax),%eax
  8026fd:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 50 08             	mov    0x8(%eax),%edx
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
  80270b:	01 c2                	add    %eax,%edx
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 40 0c             	mov    0xc(%eax),%eax
  802719:	2b 45 08             	sub    0x8(%ebp),%eax
  80271c:	89 c2                	mov    %eax,%edx
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802727:	e9 15 04 00 00       	jmp    802b41 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80272c:	a1 40 41 80 00       	mov    0x804140,%eax
  802731:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802734:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802738:	74 07                	je     802741 <alloc_block_NF+0x1cb>
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 00                	mov    (%eax),%eax
  80273f:	eb 05                	jmp    802746 <alloc_block_NF+0x1d0>
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
  802746:	a3 40 41 80 00       	mov    %eax,0x804140
  80274b:	a1 40 41 80 00       	mov    0x804140,%eax
  802750:	85 c0                	test   %eax,%eax
  802752:	0f 85 3e fe ff ff    	jne    802596 <alloc_block_NF+0x20>
  802758:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275c:	0f 85 34 fe ff ff    	jne    802596 <alloc_block_NF+0x20>
  802762:	e9 d5 03 00 00       	jmp    802b3c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802767:	a1 38 41 80 00       	mov    0x804138,%eax
  80276c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276f:	e9 b1 01 00 00       	jmp    802925 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802777:	8b 50 08             	mov    0x8(%eax),%edx
  80277a:	a1 28 40 80 00       	mov    0x804028,%eax
  80277f:	39 c2                	cmp    %eax,%edx
  802781:	0f 82 96 01 00 00    	jb     80291d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 0c             	mov    0xc(%eax),%eax
  80278d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802790:	0f 82 87 01 00 00    	jb     80291d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 0c             	mov    0xc(%eax),%eax
  80279c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279f:	0f 85 95 00 00 00    	jne    80283a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8027a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a9:	75 17                	jne    8027c2 <alloc_block_NF+0x24c>
  8027ab:	83 ec 04             	sub    $0x4,%esp
  8027ae:	68 78 3e 80 00       	push   $0x803e78
  8027b3:	68 fc 00 00 00       	push   $0xfc
  8027b8:	68 cf 3d 80 00       	push   $0x803dcf
  8027bd:	e8 af da ff ff       	call   800271 <_panic>
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 00                	mov    (%eax),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	74 10                	je     8027db <alloc_block_NF+0x265>
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d3:	8b 52 04             	mov    0x4(%edx),%edx
  8027d6:	89 50 04             	mov    %edx,0x4(%eax)
  8027d9:	eb 0b                	jmp    8027e6 <alloc_block_NF+0x270>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 04             	mov    0x4(%eax),%eax
  8027e1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	74 0f                	je     8027ff <alloc_block_NF+0x289>
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 04             	mov    0x4(%eax),%eax
  8027f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f9:	8b 12                	mov    (%edx),%edx
  8027fb:	89 10                	mov    %edx,(%eax)
  8027fd:	eb 0a                	jmp    802809 <alloc_block_NF+0x293>
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 00                	mov    (%eax),%eax
  802804:	a3 38 41 80 00       	mov    %eax,0x804138
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802815:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281c:	a1 44 41 80 00       	mov    0x804144,%eax
  802821:	48                   	dec    %eax
  802822:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282a:	8b 40 08             	mov    0x8(%eax),%eax
  80282d:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	e9 07 03 00 00       	jmp    802b41 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	8b 40 0c             	mov    0xc(%eax),%eax
  802840:	3b 45 08             	cmp    0x8(%ebp),%eax
  802843:	0f 86 d4 00 00 00    	jbe    80291d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802849:	a1 48 41 80 00       	mov    0x804148,%eax
  80284e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 50 08             	mov    0x8(%eax),%edx
  802857:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80285a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  80285d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802860:	8b 55 08             	mov    0x8(%ebp),%edx
  802863:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802866:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80286a:	75 17                	jne    802883 <alloc_block_NF+0x30d>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 78 3e 80 00       	push   $0x803e78
  802874:	68 04 01 00 00       	push   $0x104
  802879:	68 cf 3d 80 00       	push   $0x803dcf
  80287e:	e8 ee d9 ff ff       	call   800271 <_panic>
  802883:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 10                	je     80289c <alloc_block_NF+0x326>
  80288c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802894:	8b 52 04             	mov    0x4(%edx),%edx
  802897:	89 50 04             	mov    %edx,0x4(%eax)
  80289a:	eb 0b                	jmp    8028a7 <alloc_block_NF+0x331>
  80289c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0f                	je     8028c0 <alloc_block_NF+0x34a>
  8028b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028ba:	8b 12                	mov    (%edx),%edx
  8028bc:	89 10                	mov    %edx,(%eax)
  8028be:	eb 0a                	jmp    8028ca <alloc_block_NF+0x354>
  8028c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dd:	a1 54 41 80 00       	mov    0x804154,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  8028e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028eb:	8b 40 08             	mov    0x8(%eax),%eax
  8028ee:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	8b 50 08             	mov    0x8(%eax),%edx
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	01 c2                	add    %eax,%edx
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 0c             	mov    0xc(%eax),%eax
  80290a:	2b 45 08             	sub    0x8(%ebp),%eax
  80290d:	89 c2                	mov    %eax,%edx
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802918:	e9 24 02 00 00       	jmp    802b41 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  80291d:	a1 40 41 80 00       	mov    0x804140,%eax
  802922:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802929:	74 07                	je     802932 <alloc_block_NF+0x3bc>
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	eb 05                	jmp    802937 <alloc_block_NF+0x3c1>
  802932:	b8 00 00 00 00       	mov    $0x0,%eax
  802937:	a3 40 41 80 00       	mov    %eax,0x804140
  80293c:	a1 40 41 80 00       	mov    0x804140,%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	0f 85 2b fe ff ff    	jne    802774 <alloc_block_NF+0x1fe>
  802949:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294d:	0f 85 21 fe ff ff    	jne    802774 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802953:	a1 38 41 80 00       	mov    0x804138,%eax
  802958:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295b:	e9 ae 01 00 00       	jmp    802b0e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 50 08             	mov    0x8(%eax),%edx
  802966:	a1 28 40 80 00       	mov    0x804028,%eax
  80296b:	39 c2                	cmp    %eax,%edx
  80296d:	0f 83 93 01 00 00    	jae    802b06 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 40 0c             	mov    0xc(%eax),%eax
  802979:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297c:	0f 82 84 01 00 00    	jb     802b06 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 40 0c             	mov    0xc(%eax),%eax
  802988:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298b:	0f 85 95 00 00 00    	jne    802a26 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	75 17                	jne    8029ae <alloc_block_NF+0x438>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 78 3e 80 00       	push   $0x803e78
  80299f:	68 14 01 00 00       	push   $0x114
  8029a4:	68 cf 3d 80 00       	push   $0x803dcf
  8029a9:	e8 c3 d8 ff ff       	call   800271 <_panic>
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	74 10                	je     8029c7 <alloc_block_NF+0x451>
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	8b 00                	mov    (%eax),%eax
  8029bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029bf:	8b 52 04             	mov    0x4(%edx),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%eax)
  8029c5:	eb 0b                	jmp    8029d2 <alloc_block_NF+0x45c>
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 04             	mov    0x4(%eax),%eax
  8029cd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d5:	8b 40 04             	mov    0x4(%eax),%eax
  8029d8:	85 c0                	test   %eax,%eax
  8029da:	74 0f                	je     8029eb <alloc_block_NF+0x475>
  8029dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029df:	8b 40 04             	mov    0x4(%eax),%eax
  8029e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e5:	8b 12                	mov    (%edx),%edx
  8029e7:	89 10                	mov    %edx,(%eax)
  8029e9:	eb 0a                	jmp    8029f5 <alloc_block_NF+0x47f>
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 00                	mov    (%eax),%eax
  8029f0:	a3 38 41 80 00       	mov    %eax,0x804138
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a08:	a1 44 41 80 00       	mov    0x804144,%eax
  802a0d:	48                   	dec    %eax
  802a0e:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 40 08             	mov    0x8(%eax),%eax
  802a19:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	e9 1b 01 00 00       	jmp    802b41 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2f:	0f 86 d1 00 00 00    	jbe    802b06 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a35:	a1 48 41 80 00       	mov    0x804148,%eax
  802a3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	8b 50 08             	mov    0x8(%eax),%edx
  802a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a46:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a56:	75 17                	jne    802a6f <alloc_block_NF+0x4f9>
  802a58:	83 ec 04             	sub    $0x4,%esp
  802a5b:	68 78 3e 80 00       	push   $0x803e78
  802a60:	68 1c 01 00 00       	push   $0x11c
  802a65:	68 cf 3d 80 00       	push   $0x803dcf
  802a6a:	e8 02 d8 ff ff       	call   800271 <_panic>
  802a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a72:	8b 00                	mov    (%eax),%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	74 10                	je     802a88 <alloc_block_NF+0x512>
  802a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a80:	8b 52 04             	mov    0x4(%edx),%edx
  802a83:	89 50 04             	mov    %edx,0x4(%eax)
  802a86:	eb 0b                	jmp    802a93 <alloc_block_NF+0x51d>
  802a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a96:	8b 40 04             	mov    0x4(%eax),%eax
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	74 0f                	je     802aac <alloc_block_NF+0x536>
  802a9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aa6:	8b 12                	mov    (%edx),%edx
  802aa8:	89 10                	mov    %edx,(%eax)
  802aaa:	eb 0a                	jmp    802ab6 <alloc_block_NF+0x540>
  802aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	a3 48 41 80 00       	mov    %eax,0x804148
  802ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802abf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac9:	a1 54 41 80 00       	mov    0x804154,%eax
  802ace:	48                   	dec    %eax
  802acf:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad7:	8b 40 08             	mov    0x8(%eax),%eax
  802ada:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 50 08             	mov    0x8(%eax),%edx
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	01 c2                	add    %eax,%edx
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 40 0c             	mov    0xc(%eax),%eax
  802af6:	2b 45 08             	sub    0x8(%ebp),%eax
  802af9:	89 c2                	mov    %eax,%edx
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	eb 3b                	jmp    802b41 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b06:	a1 40 41 80 00       	mov    0x804140,%eax
  802b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b12:	74 07                	je     802b1b <alloc_block_NF+0x5a5>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	eb 05                	jmp    802b20 <alloc_block_NF+0x5aa>
  802b1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802b20:	a3 40 41 80 00       	mov    %eax,0x804140
  802b25:	a1 40 41 80 00       	mov    0x804140,%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	0f 85 2e fe ff ff    	jne    802960 <alloc_block_NF+0x3ea>
  802b32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b36:	0f 85 24 fe ff ff    	jne    802960 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802b3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b41:	c9                   	leave  
  802b42:	c3                   	ret    

00802b43 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b43:	55                   	push   %ebp
  802b44:	89 e5                	mov    %esp,%ebp
  802b46:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802b49:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802b51:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b56:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802b59:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 14                	je     802b76 <insert_sorted_with_merge_freeList+0x33>
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	8b 50 08             	mov    0x8(%eax),%edx
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	8b 40 08             	mov    0x8(%eax),%eax
  802b6e:	39 c2                	cmp    %eax,%edx
  802b70:	0f 87 9b 01 00 00    	ja     802d11 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802b76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7a:	75 17                	jne    802b93 <insert_sorted_with_merge_freeList+0x50>
  802b7c:	83 ec 04             	sub    $0x4,%esp
  802b7f:	68 ac 3d 80 00       	push   $0x803dac
  802b84:	68 38 01 00 00       	push   $0x138
  802b89:	68 cf 3d 80 00       	push   $0x803dcf
  802b8e:	e8 de d6 ff ff       	call   800271 <_panic>
  802b93:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	89 10                	mov    %edx,(%eax)
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	74 0d                	je     802bb4 <insert_sorted_with_merge_freeList+0x71>
  802ba7:	a1 38 41 80 00       	mov    0x804138,%eax
  802bac:	8b 55 08             	mov    0x8(%ebp),%edx
  802baf:	89 50 04             	mov    %edx,0x4(%eax)
  802bb2:	eb 08                	jmp    802bbc <insert_sorted_with_merge_freeList+0x79>
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	a3 38 41 80 00       	mov    %eax,0x804138
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bce:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd3:	40                   	inc    %eax
  802bd4:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802bd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bdd:	0f 84 a8 06 00 00    	je     80328b <insert_sorted_with_merge_freeList+0x748>
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	8b 50 08             	mov    0x8(%eax),%edx
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	8b 40 0c             	mov    0xc(%eax),%eax
  802bef:	01 c2                	add    %eax,%edx
  802bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf4:	8b 40 08             	mov    0x8(%eax),%eax
  802bf7:	39 c2                	cmp    %eax,%edx
  802bf9:	0f 85 8c 06 00 00    	jne    80328b <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	8b 50 0c             	mov    0xc(%eax),%edx
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0b:	01 c2                	add    %eax,%edx
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c17:	75 17                	jne    802c30 <insert_sorted_with_merge_freeList+0xed>
  802c19:	83 ec 04             	sub    $0x4,%esp
  802c1c:	68 78 3e 80 00       	push   $0x803e78
  802c21:	68 3c 01 00 00       	push   $0x13c
  802c26:	68 cf 3d 80 00       	push   $0x803dcf
  802c2b:	e8 41 d6 ff ff       	call   800271 <_panic>
  802c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	85 c0                	test   %eax,%eax
  802c37:	74 10                	je     802c49 <insert_sorted_with_merge_freeList+0x106>
  802c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3c:	8b 00                	mov    (%eax),%eax
  802c3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c41:	8b 52 04             	mov    0x4(%edx),%edx
  802c44:	89 50 04             	mov    %edx,0x4(%eax)
  802c47:	eb 0b                	jmp    802c54 <insert_sorted_with_merge_freeList+0x111>
  802c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4c:	8b 40 04             	mov    0x4(%eax),%eax
  802c4f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c57:	8b 40 04             	mov    0x4(%eax),%eax
  802c5a:	85 c0                	test   %eax,%eax
  802c5c:	74 0f                	je     802c6d <insert_sorted_with_merge_freeList+0x12a>
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	8b 40 04             	mov    0x4(%eax),%eax
  802c64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c67:	8b 12                	mov    (%edx),%edx
  802c69:	89 10                	mov    %edx,(%eax)
  802c6b:	eb 0a                	jmp    802c77 <insert_sorted_with_merge_freeList+0x134>
  802c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	a3 38 41 80 00       	mov    %eax,0x804138
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8a:	a1 44 41 80 00       	mov    0x804144,%eax
  802c8f:	48                   	dec    %eax
  802c90:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ca9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cad:	75 17                	jne    802cc6 <insert_sorted_with_merge_freeList+0x183>
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	68 ac 3d 80 00       	push   $0x803dac
  802cb7:	68 3f 01 00 00       	push   $0x13f
  802cbc:	68 cf 3d 80 00       	push   $0x803dcf
  802cc1:	e8 ab d5 ff ff       	call   800271 <_panic>
  802cc6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ccf:	89 10                	mov    %edx,(%eax)
  802cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd4:	8b 00                	mov    (%eax),%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	74 0d                	je     802ce7 <insert_sorted_with_merge_freeList+0x1a4>
  802cda:	a1 48 41 80 00       	mov    0x804148,%eax
  802cdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce2:	89 50 04             	mov    %edx,0x4(%eax)
  802ce5:	eb 08                	jmp    802cef <insert_sorted_with_merge_freeList+0x1ac>
  802ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cea:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf2:	a3 48 41 80 00       	mov    %eax,0x804148
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d01:	a1 54 41 80 00       	mov    0x804154,%eax
  802d06:	40                   	inc    %eax
  802d07:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d0c:	e9 7a 05 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	8b 50 08             	mov    0x8(%eax),%edx
  802d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1a:	8b 40 08             	mov    0x8(%eax),%eax
  802d1d:	39 c2                	cmp    %eax,%edx
  802d1f:	0f 82 14 01 00 00    	jb     802e39 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d28:	8b 50 08             	mov    0x8(%eax),%edx
  802d2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d31:	01 c2                	add    %eax,%edx
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	8b 40 08             	mov    0x8(%eax),%eax
  802d39:	39 c2                	cmp    %eax,%edx
  802d3b:	0f 85 90 00 00 00    	jne    802dd1 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d44:	8b 50 0c             	mov    0xc(%eax),%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4d:	01 c2                	add    %eax,%edx
  802d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d52:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6d:	75 17                	jne    802d86 <insert_sorted_with_merge_freeList+0x243>
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 ac 3d 80 00       	push   $0x803dac
  802d77:	68 49 01 00 00       	push   $0x149
  802d7c:	68 cf 3d 80 00       	push   $0x803dcf
  802d81:	e8 eb d4 ff ff       	call   800271 <_panic>
  802d86:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 0d                	je     802da7 <insert_sorted_with_merge_freeList+0x264>
  802d9a:	a1 48 41 80 00       	mov    0x804148,%eax
  802d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	eb 08                	jmp    802daf <insert_sorted_with_merge_freeList+0x26c>
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	a3 48 41 80 00       	mov    %eax,0x804148
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 54 41 80 00       	mov    0x804154,%eax
  802dc6:	40                   	inc    %eax
  802dc7:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802dcc:	e9 bb 04 00 00       	jmp    80328c <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802dd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd5:	75 17                	jne    802dee <insert_sorted_with_merge_freeList+0x2ab>
  802dd7:	83 ec 04             	sub    $0x4,%esp
  802dda:	68 20 3e 80 00       	push   $0x803e20
  802ddf:	68 4c 01 00 00       	push   $0x14c
  802de4:	68 cf 3d 80 00       	push   $0x803dcf
  802de9:	e8 83 d4 ff ff       	call   800271 <_panic>
  802dee:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	89 50 04             	mov    %edx,0x4(%eax)
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	85 c0                	test   %eax,%eax
  802e02:	74 0c                	je     802e10 <insert_sorted_with_merge_freeList+0x2cd>
  802e04:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e09:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0c:	89 10                	mov    %edx,(%eax)
  802e0e:	eb 08                	jmp    802e18 <insert_sorted_with_merge_freeList+0x2d5>
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	a3 38 41 80 00       	mov    %eax,0x804138
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e29:	a1 44 41 80 00       	mov    0x804144,%eax
  802e2e:	40                   	inc    %eax
  802e2f:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e34:	e9 53 04 00 00       	jmp    80328c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802e39:	a1 38 41 80 00       	mov    0x804138,%eax
  802e3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e41:	e9 15 04 00 00       	jmp    80325b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	8b 50 08             	mov    0x8(%eax),%edx
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 40 08             	mov    0x8(%eax),%eax
  802e5a:	39 c2                	cmp    %eax,%edx
  802e5c:	0f 86 f1 03 00 00    	jbe    803253 <insert_sorted_with_merge_freeList+0x710>
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	8b 50 08             	mov    0x8(%eax),%edx
  802e68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6b:	8b 40 08             	mov    0x8(%eax),%eax
  802e6e:	39 c2                	cmp    %eax,%edx
  802e70:	0f 83 dd 03 00 00    	jae    803253 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 50 08             	mov    0x8(%eax),%edx
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e82:	01 c2                	add    %eax,%edx
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	8b 40 08             	mov    0x8(%eax),%eax
  802e8a:	39 c2                	cmp    %eax,%edx
  802e8c:	0f 85 b9 01 00 00    	jne    80304b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 50 08             	mov    0x8(%eax),%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9e:	01 c2                	add    %eax,%edx
  802ea0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea3:	8b 40 08             	mov    0x8(%eax),%eax
  802ea6:	39 c2                	cmp    %eax,%edx
  802ea8:	0f 85 0d 01 00 00    	jne    802fbb <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eba:	01 c2                	add    %eax,%edx
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802ec2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ec6:	75 17                	jne    802edf <insert_sorted_with_merge_freeList+0x39c>
  802ec8:	83 ec 04             	sub    $0x4,%esp
  802ecb:	68 78 3e 80 00       	push   $0x803e78
  802ed0:	68 5c 01 00 00       	push   $0x15c
  802ed5:	68 cf 3d 80 00       	push   $0x803dcf
  802eda:	e8 92 d3 ff ff       	call   800271 <_panic>
  802edf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	74 10                	je     802ef8 <insert_sorted_with_merge_freeList+0x3b5>
  802ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eeb:	8b 00                	mov    (%eax),%eax
  802eed:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef0:	8b 52 04             	mov    0x4(%edx),%edx
  802ef3:	89 50 04             	mov    %edx,0x4(%eax)
  802ef6:	eb 0b                	jmp    802f03 <insert_sorted_with_merge_freeList+0x3c0>
  802ef8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f06:	8b 40 04             	mov    0x4(%eax),%eax
  802f09:	85 c0                	test   %eax,%eax
  802f0b:	74 0f                	je     802f1c <insert_sorted_with_merge_freeList+0x3d9>
  802f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f16:	8b 12                	mov    (%edx),%edx
  802f18:	89 10                	mov    %edx,(%eax)
  802f1a:	eb 0a                	jmp    802f26 <insert_sorted_with_merge_freeList+0x3e3>
  802f1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	a3 38 41 80 00       	mov    %eax,0x804138
  802f26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f39:	a1 44 41 80 00       	mov    0x804144,%eax
  802f3e:	48                   	dec    %eax
  802f3f:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802f44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f51:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802f58:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f5c:	75 17                	jne    802f75 <insert_sorted_with_merge_freeList+0x432>
  802f5e:	83 ec 04             	sub    $0x4,%esp
  802f61:	68 ac 3d 80 00       	push   $0x803dac
  802f66:	68 5f 01 00 00       	push   $0x15f
  802f6b:	68 cf 3d 80 00       	push   $0x803dcf
  802f70:	e8 fc d2 ff ff       	call   800271 <_panic>
  802f75:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7e:	89 10                	mov    %edx,(%eax)
  802f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	85 c0                	test   %eax,%eax
  802f87:	74 0d                	je     802f96 <insert_sorted_with_merge_freeList+0x453>
  802f89:	a1 48 41 80 00       	mov    0x804148,%eax
  802f8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f91:	89 50 04             	mov    %edx,0x4(%eax)
  802f94:	eb 08                	jmp    802f9e <insert_sorted_with_merge_freeList+0x45b>
  802f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f99:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa1:	a3 48 41 80 00       	mov    %eax,0x804148
  802fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb0:	a1 54 41 80 00       	mov    0x804154,%eax
  802fb5:	40                   	inc    %eax
  802fb6:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc7:	01 c2                	add    %eax,%edx
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fe3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe7:	75 17                	jne    803000 <insert_sorted_with_merge_freeList+0x4bd>
  802fe9:	83 ec 04             	sub    $0x4,%esp
  802fec:	68 ac 3d 80 00       	push   $0x803dac
  802ff1:	68 64 01 00 00       	push   $0x164
  802ff6:	68 cf 3d 80 00       	push   $0x803dcf
  802ffb:	e8 71 d2 ff ff       	call   800271 <_panic>
  803000:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	89 10                	mov    %edx,(%eax)
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	8b 00                	mov    (%eax),%eax
  803010:	85 c0                	test   %eax,%eax
  803012:	74 0d                	je     803021 <insert_sorted_with_merge_freeList+0x4de>
  803014:	a1 48 41 80 00       	mov    0x804148,%eax
  803019:	8b 55 08             	mov    0x8(%ebp),%edx
  80301c:	89 50 04             	mov    %edx,0x4(%eax)
  80301f:	eb 08                	jmp    803029 <insert_sorted_with_merge_freeList+0x4e6>
  803021:	8b 45 08             	mov    0x8(%ebp),%eax
  803024:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	a3 48 41 80 00       	mov    %eax,0x804148
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303b:	a1 54 41 80 00       	mov    0x804154,%eax
  803040:	40                   	inc    %eax
  803041:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803046:	e9 41 02 00 00       	jmp    80328c <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 50 08             	mov    0x8(%eax),%edx
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	8b 40 0c             	mov    0xc(%eax),%eax
  803057:	01 c2                	add    %eax,%edx
  803059:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305c:	8b 40 08             	mov    0x8(%eax),%eax
  80305f:	39 c2                	cmp    %eax,%edx
  803061:	0f 85 7c 01 00 00    	jne    8031e3 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803067:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80306b:	74 06                	je     803073 <insert_sorted_with_merge_freeList+0x530>
  80306d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803071:	75 17                	jne    80308a <insert_sorted_with_merge_freeList+0x547>
  803073:	83 ec 04             	sub    $0x4,%esp
  803076:	68 e8 3d 80 00       	push   $0x803de8
  80307b:	68 69 01 00 00       	push   $0x169
  803080:	68 cf 3d 80 00       	push   $0x803dcf
  803085:	e8 e7 d1 ff ff       	call   800271 <_panic>
  80308a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308d:	8b 50 04             	mov    0x4(%eax),%edx
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	89 50 04             	mov    %edx,0x4(%eax)
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309c:	89 10                	mov    %edx,(%eax)
  80309e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a1:	8b 40 04             	mov    0x4(%eax),%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	74 0d                	je     8030b5 <insert_sorted_with_merge_freeList+0x572>
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	8b 40 04             	mov    0x4(%eax),%eax
  8030ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b1:	89 10                	mov    %edx,(%eax)
  8030b3:	eb 08                	jmp    8030bd <insert_sorted_with_merge_freeList+0x57a>
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	a3 38 41 80 00       	mov    %eax,0x804138
  8030bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c3:	89 50 04             	mov    %edx,0x4(%eax)
  8030c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8030cb:	40                   	inc    %eax
  8030cc:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030da:	8b 40 0c             	mov    0xc(%eax),%eax
  8030dd:	01 c2                	add    %eax,%edx
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030e5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e9:	75 17                	jne    803102 <insert_sorted_with_merge_freeList+0x5bf>
  8030eb:	83 ec 04             	sub    $0x4,%esp
  8030ee:	68 78 3e 80 00       	push   $0x803e78
  8030f3:	68 6b 01 00 00       	push   $0x16b
  8030f8:	68 cf 3d 80 00       	push   $0x803dcf
  8030fd:	e8 6f d1 ff ff       	call   800271 <_panic>
  803102:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803105:	8b 00                	mov    (%eax),%eax
  803107:	85 c0                	test   %eax,%eax
  803109:	74 10                	je     80311b <insert_sorted_with_merge_freeList+0x5d8>
  80310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803113:	8b 52 04             	mov    0x4(%edx),%edx
  803116:	89 50 04             	mov    %edx,0x4(%eax)
  803119:	eb 0b                	jmp    803126 <insert_sorted_with_merge_freeList+0x5e3>
  80311b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311e:	8b 40 04             	mov    0x4(%eax),%eax
  803121:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803126:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803129:	8b 40 04             	mov    0x4(%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	74 0f                	je     80313f <insert_sorted_with_merge_freeList+0x5fc>
  803130:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803133:	8b 40 04             	mov    0x4(%eax),%eax
  803136:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803139:	8b 12                	mov    (%edx),%edx
  80313b:	89 10                	mov    %edx,(%eax)
  80313d:	eb 0a                	jmp    803149 <insert_sorted_with_merge_freeList+0x606>
  80313f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803142:	8b 00                	mov    (%eax),%eax
  803144:	a3 38 41 80 00       	mov    %eax,0x804138
  803149:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803152:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803155:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315c:	a1 44 41 80 00       	mov    0x804144,%eax
  803161:	48                   	dec    %eax
  803162:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803171:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803174:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80317b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80317f:	75 17                	jne    803198 <insert_sorted_with_merge_freeList+0x655>
  803181:	83 ec 04             	sub    $0x4,%esp
  803184:	68 ac 3d 80 00       	push   $0x803dac
  803189:	68 6e 01 00 00       	push   $0x16e
  80318e:	68 cf 3d 80 00       	push   $0x803dcf
  803193:	e8 d9 d0 ff ff       	call   800271 <_panic>
  803198:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80319e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a1:	89 10                	mov    %edx,(%eax)
  8031a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a6:	8b 00                	mov    (%eax),%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	74 0d                	je     8031b9 <insert_sorted_with_merge_freeList+0x676>
  8031ac:	a1 48 41 80 00       	mov    0x804148,%eax
  8031b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b4:	89 50 04             	mov    %edx,0x4(%eax)
  8031b7:	eb 08                	jmp    8031c1 <insert_sorted_with_merge_freeList+0x67e>
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	a3 48 41 80 00       	mov    %eax,0x804148
  8031c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d3:	a1 54 41 80 00       	mov    0x804154,%eax
  8031d8:	40                   	inc    %eax
  8031d9:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8031de:	e9 a9 00 00 00       	jmp    80328c <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8031e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e7:	74 06                	je     8031ef <insert_sorted_with_merge_freeList+0x6ac>
  8031e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ed:	75 17                	jne    803206 <insert_sorted_with_merge_freeList+0x6c3>
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	68 44 3e 80 00       	push   $0x803e44
  8031f7:	68 73 01 00 00       	push   $0x173
  8031fc:	68 cf 3d 80 00       	push   $0x803dcf
  803201:	e8 6b d0 ff ff       	call   800271 <_panic>
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 10                	mov    (%eax),%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	89 10                	mov    %edx,(%eax)
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0b                	je     803224 <insert_sorted_with_merge_freeList+0x6e1>
  803219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	8b 55 08             	mov    0x8(%ebp),%edx
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 55 08             	mov    0x8(%ebp),%edx
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803232:	89 50 04             	mov    %edx,0x4(%eax)
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	8b 00                	mov    (%eax),%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	75 08                	jne    803246 <insert_sorted_with_merge_freeList+0x703>
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803246:	a1 44 41 80 00       	mov    0x804144,%eax
  80324b:	40                   	inc    %eax
  80324c:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  803251:	eb 39                	jmp    80328c <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803253:	a1 40 41 80 00       	mov    0x804140,%eax
  803258:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325f:	74 07                	je     803268 <insert_sorted_with_merge_freeList+0x725>
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	8b 00                	mov    (%eax),%eax
  803266:	eb 05                	jmp    80326d <insert_sorted_with_merge_freeList+0x72a>
  803268:	b8 00 00 00 00       	mov    $0x0,%eax
  80326d:	a3 40 41 80 00       	mov    %eax,0x804140
  803272:	a1 40 41 80 00       	mov    0x804140,%eax
  803277:	85 c0                	test   %eax,%eax
  803279:	0f 85 c7 fb ff ff    	jne    802e46 <insert_sorted_with_merge_freeList+0x303>
  80327f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803283:	0f 85 bd fb ff ff    	jne    802e46 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803289:	eb 01                	jmp    80328c <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  80328b:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80328c:	90                   	nop
  80328d:	c9                   	leave  
  80328e:	c3                   	ret    
  80328f:	90                   	nop

00803290 <__udivdi3>:
  803290:	55                   	push   %ebp
  803291:	57                   	push   %edi
  803292:	56                   	push   %esi
  803293:	53                   	push   %ebx
  803294:	83 ec 1c             	sub    $0x1c,%esp
  803297:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80329b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80329f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032a7:	89 ca                	mov    %ecx,%edx
  8032a9:	89 f8                	mov    %edi,%eax
  8032ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032af:	85 f6                	test   %esi,%esi
  8032b1:	75 2d                	jne    8032e0 <__udivdi3+0x50>
  8032b3:	39 cf                	cmp    %ecx,%edi
  8032b5:	77 65                	ja     80331c <__udivdi3+0x8c>
  8032b7:	89 fd                	mov    %edi,%ebp
  8032b9:	85 ff                	test   %edi,%edi
  8032bb:	75 0b                	jne    8032c8 <__udivdi3+0x38>
  8032bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c2:	31 d2                	xor    %edx,%edx
  8032c4:	f7 f7                	div    %edi
  8032c6:	89 c5                	mov    %eax,%ebp
  8032c8:	31 d2                	xor    %edx,%edx
  8032ca:	89 c8                	mov    %ecx,%eax
  8032cc:	f7 f5                	div    %ebp
  8032ce:	89 c1                	mov    %eax,%ecx
  8032d0:	89 d8                	mov    %ebx,%eax
  8032d2:	f7 f5                	div    %ebp
  8032d4:	89 cf                	mov    %ecx,%edi
  8032d6:	89 fa                	mov    %edi,%edx
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	39 ce                	cmp    %ecx,%esi
  8032e2:	77 28                	ja     80330c <__udivdi3+0x7c>
  8032e4:	0f bd fe             	bsr    %esi,%edi
  8032e7:	83 f7 1f             	xor    $0x1f,%edi
  8032ea:	75 40                	jne    80332c <__udivdi3+0x9c>
  8032ec:	39 ce                	cmp    %ecx,%esi
  8032ee:	72 0a                	jb     8032fa <__udivdi3+0x6a>
  8032f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032f4:	0f 87 9e 00 00 00    	ja     803398 <__udivdi3+0x108>
  8032fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ff:	89 fa                	mov    %edi,%edx
  803301:	83 c4 1c             	add    $0x1c,%esp
  803304:	5b                   	pop    %ebx
  803305:	5e                   	pop    %esi
  803306:	5f                   	pop    %edi
  803307:	5d                   	pop    %ebp
  803308:	c3                   	ret    
  803309:	8d 76 00             	lea    0x0(%esi),%esi
  80330c:	31 ff                	xor    %edi,%edi
  80330e:	31 c0                	xor    %eax,%eax
  803310:	89 fa                	mov    %edi,%edx
  803312:	83 c4 1c             	add    $0x1c,%esp
  803315:	5b                   	pop    %ebx
  803316:	5e                   	pop    %esi
  803317:	5f                   	pop    %edi
  803318:	5d                   	pop    %ebp
  803319:	c3                   	ret    
  80331a:	66 90                	xchg   %ax,%ax
  80331c:	89 d8                	mov    %ebx,%eax
  80331e:	f7 f7                	div    %edi
  803320:	31 ff                	xor    %edi,%edi
  803322:	89 fa                	mov    %edi,%edx
  803324:	83 c4 1c             	add    $0x1c,%esp
  803327:	5b                   	pop    %ebx
  803328:	5e                   	pop    %esi
  803329:	5f                   	pop    %edi
  80332a:	5d                   	pop    %ebp
  80332b:	c3                   	ret    
  80332c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803331:	89 eb                	mov    %ebp,%ebx
  803333:	29 fb                	sub    %edi,%ebx
  803335:	89 f9                	mov    %edi,%ecx
  803337:	d3 e6                	shl    %cl,%esi
  803339:	89 c5                	mov    %eax,%ebp
  80333b:	88 d9                	mov    %bl,%cl
  80333d:	d3 ed                	shr    %cl,%ebp
  80333f:	89 e9                	mov    %ebp,%ecx
  803341:	09 f1                	or     %esi,%ecx
  803343:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803347:	89 f9                	mov    %edi,%ecx
  803349:	d3 e0                	shl    %cl,%eax
  80334b:	89 c5                	mov    %eax,%ebp
  80334d:	89 d6                	mov    %edx,%esi
  80334f:	88 d9                	mov    %bl,%cl
  803351:	d3 ee                	shr    %cl,%esi
  803353:	89 f9                	mov    %edi,%ecx
  803355:	d3 e2                	shl    %cl,%edx
  803357:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335b:	88 d9                	mov    %bl,%cl
  80335d:	d3 e8                	shr    %cl,%eax
  80335f:	09 c2                	or     %eax,%edx
  803361:	89 d0                	mov    %edx,%eax
  803363:	89 f2                	mov    %esi,%edx
  803365:	f7 74 24 0c          	divl   0xc(%esp)
  803369:	89 d6                	mov    %edx,%esi
  80336b:	89 c3                	mov    %eax,%ebx
  80336d:	f7 e5                	mul    %ebp
  80336f:	39 d6                	cmp    %edx,%esi
  803371:	72 19                	jb     80338c <__udivdi3+0xfc>
  803373:	74 0b                	je     803380 <__udivdi3+0xf0>
  803375:	89 d8                	mov    %ebx,%eax
  803377:	31 ff                	xor    %edi,%edi
  803379:	e9 58 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	8b 54 24 08          	mov    0x8(%esp),%edx
  803384:	89 f9                	mov    %edi,%ecx
  803386:	d3 e2                	shl    %cl,%edx
  803388:	39 c2                	cmp    %eax,%edx
  80338a:	73 e9                	jae    803375 <__udivdi3+0xe5>
  80338c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80338f:	31 ff                	xor    %edi,%edi
  803391:	e9 40 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  803396:	66 90                	xchg   %ax,%ax
  803398:	31 c0                	xor    %eax,%eax
  80339a:	e9 37 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  80339f:	90                   	nop

008033a0 <__umoddi3>:
  8033a0:	55                   	push   %ebp
  8033a1:	57                   	push   %edi
  8033a2:	56                   	push   %esi
  8033a3:	53                   	push   %ebx
  8033a4:	83 ec 1c             	sub    $0x1c,%esp
  8033a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033bf:	89 f3                	mov    %esi,%ebx
  8033c1:	89 fa                	mov    %edi,%edx
  8033c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033c7:	89 34 24             	mov    %esi,(%esp)
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	75 1a                	jne    8033e8 <__umoddi3+0x48>
  8033ce:	39 f7                	cmp    %esi,%edi
  8033d0:	0f 86 a2 00 00 00    	jbe    803478 <__umoddi3+0xd8>
  8033d6:	89 c8                	mov    %ecx,%eax
  8033d8:	89 f2                	mov    %esi,%edx
  8033da:	f7 f7                	div    %edi
  8033dc:	89 d0                	mov    %edx,%eax
  8033de:	31 d2                	xor    %edx,%edx
  8033e0:	83 c4 1c             	add    $0x1c,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
  8033e8:	39 f0                	cmp    %esi,%eax
  8033ea:	0f 87 ac 00 00 00    	ja     80349c <__umoddi3+0xfc>
  8033f0:	0f bd e8             	bsr    %eax,%ebp
  8033f3:	83 f5 1f             	xor    $0x1f,%ebp
  8033f6:	0f 84 ac 00 00 00    	je     8034a8 <__umoddi3+0x108>
  8033fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803401:	29 ef                	sub    %ebp,%edi
  803403:	89 fe                	mov    %edi,%esi
  803405:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803409:	89 e9                	mov    %ebp,%ecx
  80340b:	d3 e0                	shl    %cl,%eax
  80340d:	89 d7                	mov    %edx,%edi
  80340f:	89 f1                	mov    %esi,%ecx
  803411:	d3 ef                	shr    %cl,%edi
  803413:	09 c7                	or     %eax,%edi
  803415:	89 e9                	mov    %ebp,%ecx
  803417:	d3 e2                	shl    %cl,%edx
  803419:	89 14 24             	mov    %edx,(%esp)
  80341c:	89 d8                	mov    %ebx,%eax
  80341e:	d3 e0                	shl    %cl,%eax
  803420:	89 c2                	mov    %eax,%edx
  803422:	8b 44 24 08          	mov    0x8(%esp),%eax
  803426:	d3 e0                	shl    %cl,%eax
  803428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80342c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803430:	89 f1                	mov    %esi,%ecx
  803432:	d3 e8                	shr    %cl,%eax
  803434:	09 d0                	or     %edx,%eax
  803436:	d3 eb                	shr    %cl,%ebx
  803438:	89 da                	mov    %ebx,%edx
  80343a:	f7 f7                	div    %edi
  80343c:	89 d3                	mov    %edx,%ebx
  80343e:	f7 24 24             	mull   (%esp)
  803441:	89 c6                	mov    %eax,%esi
  803443:	89 d1                	mov    %edx,%ecx
  803445:	39 d3                	cmp    %edx,%ebx
  803447:	0f 82 87 00 00 00    	jb     8034d4 <__umoddi3+0x134>
  80344d:	0f 84 91 00 00 00    	je     8034e4 <__umoddi3+0x144>
  803453:	8b 54 24 04          	mov    0x4(%esp),%edx
  803457:	29 f2                	sub    %esi,%edx
  803459:	19 cb                	sbb    %ecx,%ebx
  80345b:	89 d8                	mov    %ebx,%eax
  80345d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803461:	d3 e0                	shl    %cl,%eax
  803463:	89 e9                	mov    %ebp,%ecx
  803465:	d3 ea                	shr    %cl,%edx
  803467:	09 d0                	or     %edx,%eax
  803469:	89 e9                	mov    %ebp,%ecx
  80346b:	d3 eb                	shr    %cl,%ebx
  80346d:	89 da                	mov    %ebx,%edx
  80346f:	83 c4 1c             	add    $0x1c,%esp
  803472:	5b                   	pop    %ebx
  803473:	5e                   	pop    %esi
  803474:	5f                   	pop    %edi
  803475:	5d                   	pop    %ebp
  803476:	c3                   	ret    
  803477:	90                   	nop
  803478:	89 fd                	mov    %edi,%ebp
  80347a:	85 ff                	test   %edi,%edi
  80347c:	75 0b                	jne    803489 <__umoddi3+0xe9>
  80347e:	b8 01 00 00 00       	mov    $0x1,%eax
  803483:	31 d2                	xor    %edx,%edx
  803485:	f7 f7                	div    %edi
  803487:	89 c5                	mov    %eax,%ebp
  803489:	89 f0                	mov    %esi,%eax
  80348b:	31 d2                	xor    %edx,%edx
  80348d:	f7 f5                	div    %ebp
  80348f:	89 c8                	mov    %ecx,%eax
  803491:	f7 f5                	div    %ebp
  803493:	89 d0                	mov    %edx,%eax
  803495:	e9 44 ff ff ff       	jmp    8033de <__umoddi3+0x3e>
  80349a:	66 90                	xchg   %ax,%ax
  80349c:	89 c8                	mov    %ecx,%eax
  80349e:	89 f2                	mov    %esi,%edx
  8034a0:	83 c4 1c             	add    $0x1c,%esp
  8034a3:	5b                   	pop    %ebx
  8034a4:	5e                   	pop    %esi
  8034a5:	5f                   	pop    %edi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    
  8034a8:	3b 04 24             	cmp    (%esp),%eax
  8034ab:	72 06                	jb     8034b3 <__umoddi3+0x113>
  8034ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034b1:	77 0f                	ja     8034c2 <__umoddi3+0x122>
  8034b3:	89 f2                	mov    %esi,%edx
  8034b5:	29 f9                	sub    %edi,%ecx
  8034b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034bb:	89 14 24             	mov    %edx,(%esp)
  8034be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034c6:	8b 14 24             	mov    (%esp),%edx
  8034c9:	83 c4 1c             	add    $0x1c,%esp
  8034cc:	5b                   	pop    %ebx
  8034cd:	5e                   	pop    %esi
  8034ce:	5f                   	pop    %edi
  8034cf:	5d                   	pop    %ebp
  8034d0:	c3                   	ret    
  8034d1:	8d 76 00             	lea    0x0(%esi),%esi
  8034d4:	2b 04 24             	sub    (%esp),%eax
  8034d7:	19 fa                	sbb    %edi,%edx
  8034d9:	89 d1                	mov    %edx,%ecx
  8034db:	89 c6                	mov    %eax,%esi
  8034dd:	e9 71 ff ff ff       	jmp    803453 <__umoddi3+0xb3>
  8034e2:	66 90                	xchg   %ax,%ax
  8034e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034e8:	72 ea                	jb     8034d4 <__umoddi3+0x134>
  8034ea:	89 d9                	mov    %ebx,%ecx
  8034ec:	e9 62 ff ff ff       	jmp    803453 <__umoddi3+0xb3>
