
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
  80008c:	68 00 37 80 00       	push   $0x803700
  800091:	6a 12                	push   $0x12
  800093:	68 1c 37 80 00       	push   $0x80371c
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
  8000aa:	e8 14 1b 00 00       	call   801bc3 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 37 37 80 00       	push   $0x803737
  8000b7:	50                   	push   %eax
  8000b8:	e8 e9 15 00 00       	call   8016a6 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 02 18 00 00       	call   8018ca <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 3c 37 80 00       	push   $0x80373c
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 84 16 00 00       	call   80176a <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 60 37 80 00       	push   $0x803760
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 cc 17 00 00       	call   8018ca <sys_calculate_free_frames>
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
  80011c:	68 78 37 80 00       	push   $0x803778
  800121:	6a 24                	push   $0x24
  800123:	68 1c 37 80 00       	push   $0x80371c
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 b6 1b 00 00       	call   801ce8 <inctst>

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
  80013b:	e8 6a 1a 00 00       	call   801baa <sys_getenvindex>
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
  8001a6:	e8 0c 18 00 00       	call   8019b7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 1c 38 80 00       	push   $0x80381c
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
  8001d6:	68 44 38 80 00       	push   $0x803844
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
  800207:	68 6c 38 80 00       	push   $0x80386c
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 c4 38 80 00       	push   $0x8038c4
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 1c 38 80 00       	push   $0x80381c
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 8c 17 00 00       	call   8019d1 <sys_enable_interrupt>

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
  800258:	e8 19 19 00 00       	call   801b76 <sys_destroy_env>
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
  800269:	e8 6e 19 00 00       	call   801bdc <sys_exit_env>
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
  800292:	68 d8 38 80 00       	push   $0x8038d8
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 dd 38 80 00       	push   $0x8038dd
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
  8002cf:	68 f9 38 80 00       	push   $0x8038f9
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
  8002fb:	68 fc 38 80 00       	push   $0x8038fc
  800300:	6a 26                	push   $0x26
  800302:	68 48 39 80 00       	push   $0x803948
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
  8003cd:	68 54 39 80 00       	push   $0x803954
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 48 39 80 00       	push   $0x803948
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
  80043d:	68 a8 39 80 00       	push   $0x8039a8
  800442:	6a 44                	push   $0x44
  800444:	68 48 39 80 00       	push   $0x803948
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
  800497:	e8 6d 13 00 00       	call   801809 <sys_cputs>
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
  80050e:	e8 f6 12 00 00       	call   801809 <sys_cputs>
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
  800558:	e8 5a 14 00 00       	call   8019b7 <sys_disable_interrupt>
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
  800578:	e8 54 14 00 00       	call   8019d1 <sys_enable_interrupt>
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
  8005c2:	e8 c5 2e 00 00       	call   80348c <__udivdi3>
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
  800612:	e8 85 2f 00 00       	call   80359c <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 14 3c 80 00       	add    $0x803c14,%eax
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
  80076d:	8b 04 85 38 3c 80 00 	mov    0x803c38(,%eax,4),%eax
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
  80084e:	8b 34 9d 80 3a 80 00 	mov    0x803a80(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 25 3c 80 00       	push   $0x803c25
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
  800873:	68 2e 3c 80 00       	push   $0x803c2e
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
  8008a0:	be 31 3c 80 00       	mov    $0x803c31,%esi
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
  8012c6:	68 90 3d 80 00       	push   $0x803d90
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
  801396:	e8 b2 05 00 00       	call   80194d <sys_allocate_chunk>
  80139b:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139e:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	50                   	push   %eax
  8013a7:	e8 27 0c 00 00       	call   801fd3 <initialize_MemBlocksList>
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
  8013d4:	68 b5 3d 80 00       	push   $0x803db5
  8013d9:	6a 33                	push   $0x33
  8013db:	68 d3 3d 80 00       	push   $0x803dd3
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
  801453:	68 e0 3d 80 00       	push   $0x803de0
  801458:	6a 34                	push   $0x34
  80145a:	68 d3 3d 80 00       	push   $0x803dd3
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
  8014eb:	e8 2b 08 00 00       	call   801d1b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 11                	je     801505 <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	ff 75 e8             	pushl  -0x18(%ebp)
  8014fa:	e8 96 0e 00 00       	call   802395 <alloc_block_FF>
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
  801511:	e8 f2 0b 00 00       	call   802108 <insert_sorted_allocList>
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
  80152b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80152e:	8b 45 08             	mov    0x8(%ebp),%eax
  801531:	83 ec 08             	sub    $0x8,%esp
  801534:	50                   	push   %eax
  801535:	68 40 40 80 00       	push   $0x804040
  80153a:	e8 71 0b 00 00       	call   8020b0 <find_block>
  80153f:	83 c4 10             	add    $0x10,%esp
  801542:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  801545:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801549:	0f 84 a6 00 00 00    	je     8015f5 <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  80154f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801552:	8b 50 0c             	mov    0xc(%eax),%edx
  801555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801558:	8b 40 08             	mov    0x8(%eax),%eax
  80155b:	83 ec 08             	sub    $0x8,%esp
  80155e:	52                   	push   %edx
  80155f:	50                   	push   %eax
  801560:	e8 b0 03 00 00       	call   801915 <sys_free_user_mem>
  801565:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80156c:	75 14                	jne    801582 <free+0x5a>
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	68 b5 3d 80 00       	push   $0x803db5
  801576:	6a 74                	push   $0x74
  801578:	68 d3 3d 80 00       	push   $0x803dd3
  80157d:	e8 ef ec ff ff       	call   800271 <_panic>
  801582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	85 c0                	test   %eax,%eax
  801589:	74 10                	je     80159b <free+0x73>
  80158b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158e:	8b 00                	mov    (%eax),%eax
  801590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801593:	8b 52 04             	mov    0x4(%edx),%edx
  801596:	89 50 04             	mov    %edx,0x4(%eax)
  801599:	eb 0b                	jmp    8015a6 <free+0x7e>
  80159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159e:	8b 40 04             	mov    0x4(%eax),%eax
  8015a1:	a3 44 40 80 00       	mov    %eax,0x804044
  8015a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a9:	8b 40 04             	mov    0x4(%eax),%eax
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	74 0f                	je     8015bf <free+0x97>
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	8b 40 04             	mov    0x4(%eax),%eax
  8015b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b9:	8b 12                	mov    (%edx),%edx
  8015bb:	89 10                	mov    %edx,(%eax)
  8015bd:	eb 0a                	jmp    8015c9 <free+0xa1>
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	8b 00                	mov    (%eax),%eax
  8015c4:	a3 40 40 80 00       	mov    %eax,0x804040
  8015c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015dc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015e1:	48                   	dec    %eax
  8015e2:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(free_block);
  8015e7:	83 ec 0c             	sub    $0xc,%esp
  8015ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ed:	e8 4e 17 00 00       	call   802d40 <insert_sorted_with_merge_freeList>
  8015f2:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015f5:	90                   	nop
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
  8015fb:	83 ec 38             	sub    $0x38,%esp
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801604:	e8 a6 fc ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  801609:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80160d:	75 0a                	jne    801619 <smalloc+0x21>
  80160f:	b8 00 00 00 00       	mov    $0x0,%eax
  801614:	e9 8b 00 00 00       	jmp    8016a4 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801619:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	48                   	dec    %eax
  801629:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80162c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80162f:	ba 00 00 00 00       	mov    $0x0,%edx
  801634:	f7 75 f0             	divl   -0x10(%ebp)
  801637:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163a:	29 d0                	sub    %edx,%eax
  80163c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80163f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801646:	e8 d0 06 00 00       	call   801d1b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164b:	85 c0                	test   %eax,%eax
  80164d:	74 11                	je     801660 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  80164f:	83 ec 0c             	sub    $0xc,%esp
  801652:	ff 75 e8             	pushl  -0x18(%ebp)
  801655:	e8 3b 0d 00 00       	call   802395 <alloc_block_FF>
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801664:	74 39                	je     80169f <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801669:	8b 40 08             	mov    0x8(%eax),%eax
  80166c:	89 c2                	mov    %eax,%edx
  80166e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801672:	52                   	push   %edx
  801673:	50                   	push   %eax
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	ff 75 08             	pushl  0x8(%ebp)
  80167a:	e8 21 04 00 00       	call   801aa0 <sys_createSharedObject>
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  801685:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801689:	74 14                	je     80169f <smalloc+0xa7>
  80168b:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  80168f:	74 0e                	je     80169f <smalloc+0xa7>
  801691:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  801695:	74 08                	je     80169f <smalloc+0xa7>
			return (void*) mem_block->sva;
  801697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169a:	8b 40 08             	mov    0x8(%eax),%eax
  80169d:	eb 05                	jmp    8016a4 <smalloc+0xac>
	}
	return NULL;
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ac:	e8 fe fb ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016b1:	83 ec 08             	sub    $0x8,%esp
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	ff 75 08             	pushl  0x8(%ebp)
  8016ba:	e8 0b 04 00 00       	call   801aca <sys_getSizeOfSharedObject>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8016c5:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8016c9:	74 76                	je     801741 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8016cb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d8:	01 d0                	add    %edx,%eax
  8016da:	48                   	dec    %eax
  8016db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e6:	f7 75 ec             	divl   -0x14(%ebp)
  8016e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ec:	29 d0                	sub    %edx,%eax
  8016ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8016f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8016f8:	e8 1e 06 00 00       	call   801d1b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	74 11                	je     801712 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801701:	83 ec 0c             	sub    $0xc,%esp
  801704:	ff 75 e4             	pushl  -0x1c(%ebp)
  801707:	e8 89 0c 00 00       	call   802395 <alloc_block_FF>
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801716:	74 29                	je     801741 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171b:	8b 40 08             	mov    0x8(%eax),%eax
  80171e:	83 ec 04             	sub    $0x4,%esp
  801721:	50                   	push   %eax
  801722:	ff 75 0c             	pushl  0xc(%ebp)
  801725:	ff 75 08             	pushl  0x8(%ebp)
  801728:	e8 ba 03 00 00       	call   801ae7 <sys_getSharedObject>
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801733:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801737:	74 08                	je     801741 <sget+0x9b>
				return (void *)mem_block->sva;
  801739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173c:	8b 40 08             	mov    0x8(%eax),%eax
  80173f:	eb 05                	jmp    801746 <sget+0xa0>
		}
	}
	return NULL;
  801741:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801746:	c9                   	leave  
  801747:	c3                   	ret    

00801748 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801748:	55                   	push   %ebp
  801749:	89 e5                	mov    %esp,%ebp
  80174b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174e:	e8 5c fb ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	68 04 3e 80 00       	push   $0x803e04
  80175b:	68 f7 00 00 00       	push   $0xf7
  801760:	68 d3 3d 80 00       	push   $0x803dd3
  801765:	e8 07 eb ff ff       	call   800271 <_panic>

0080176a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	68 2c 3e 80 00       	push   $0x803e2c
  801778:	68 0b 01 00 00       	push   $0x10b
  80177d:	68 d3 3d 80 00       	push   $0x803dd3
  801782:	e8 ea ea ff ff       	call   800271 <_panic>

00801787 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 50 3e 80 00       	push   $0x803e50
  801795:	68 16 01 00 00       	push   $0x116
  80179a:	68 d3 3d 80 00       	push   $0x803dd3
  80179f:	e8 cd ea ff ff       	call   800271 <_panic>

008017a4 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 50 3e 80 00       	push   $0x803e50
  8017b2:	68 1b 01 00 00       	push   $0x11b
  8017b7:	68 d3 3d 80 00       	push   $0x803dd3
  8017bc:	e8 b0 ea ff ff       	call   800271 <_panic>

008017c1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 50 3e 80 00       	push   $0x803e50
  8017cf:	68 20 01 00 00       	push   $0x120
  8017d4:	68 d3 3d 80 00       	push   $0x803dd3
  8017d9:	e8 93 ea ff ff       	call   800271 <_panic>

008017de <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	57                   	push   %edi
  8017e2:	56                   	push   %esi
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f3:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f9:	cd 30                	int    $0x30
  8017fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801801:	83 c4 10             	add    $0x10,%esp
  801804:	5b                   	pop    %ebx
  801805:	5e                   	pop    %esi
  801806:	5f                   	pop    %edi
  801807:	5d                   	pop    %ebp
  801808:	c3                   	ret    

00801809 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801815:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	52                   	push   %edx
  801821:	ff 75 0c             	pushl  0xc(%ebp)
  801824:	50                   	push   %eax
  801825:	6a 00                	push   $0x0
  801827:	e8 b2 ff ff ff       	call   8017de <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
}
  80182f:	90                   	nop
  801830:	c9                   	leave  
  801831:	c3                   	ret    

00801832 <sys_cgetc>:

int
sys_cgetc(void)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 01                	push   $0x1
  801841:	e8 98 ff ff ff       	call   8017de <syscall>
  801846:	83 c4 18             	add    $0x18,%esp
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80184e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	52                   	push   %edx
  80185b:	50                   	push   %eax
  80185c:	6a 05                	push   $0x5
  80185e:	e8 7b ff ff ff       	call   8017de <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	56                   	push   %esi
  80186c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80186d:	8b 75 18             	mov    0x18(%ebp),%esi
  801870:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801873:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	56                   	push   %esi
  80187d:	53                   	push   %ebx
  80187e:	51                   	push   %ecx
  80187f:	52                   	push   %edx
  801880:	50                   	push   %eax
  801881:	6a 06                	push   $0x6
  801883:	e8 56 ff ff ff       	call   8017de <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188e:	5b                   	pop    %ebx
  80188f:	5e                   	pop    %esi
  801890:	5d                   	pop    %ebp
  801891:	c3                   	ret    

00801892 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801895:	8b 55 0c             	mov    0xc(%ebp),%edx
  801898:	8b 45 08             	mov    0x8(%ebp),%eax
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	52                   	push   %edx
  8018a2:	50                   	push   %eax
  8018a3:	6a 07                	push   $0x7
  8018a5:	e8 34 ff ff ff       	call   8017de <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	ff 75 08             	pushl  0x8(%ebp)
  8018be:	6a 08                	push   $0x8
  8018c0:	e8 19 ff ff ff       	call   8017de <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 09                	push   $0x9
  8018d9:	e8 00 ff ff ff       	call   8017de <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 0a                	push   $0xa
  8018f2:	e8 e7 fe ff ff       	call   8017de <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 0b                	push   $0xb
  80190b:	e8 ce fe ff ff       	call   8017de <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	ff 75 0c             	pushl  0xc(%ebp)
  801921:	ff 75 08             	pushl  0x8(%ebp)
  801924:	6a 0f                	push   $0xf
  801926:	e8 b3 fe ff ff       	call   8017de <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
	return;
  80192e:	90                   	nop
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	6a 10                	push   $0x10
  801942:	e8 97 fe ff ff       	call   8017de <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
	return ;
  80194a:	90                   	nop
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	ff 75 10             	pushl  0x10(%ebp)
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	6a 11                	push   $0x11
  80195f:	e8 7a fe ff ff       	call   8017de <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
	return ;
  801967:	90                   	nop
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 0c                	push   $0xc
  801979:	e8 60 fe ff ff       	call   8017de <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 08             	pushl  0x8(%ebp)
  801991:	6a 0d                	push   $0xd
  801993:	e8 46 fe ff ff       	call   8017de <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 0e                	push   $0xe
  8019ac:	e8 2d fe ff ff       	call   8017de <syscall>
  8019b1:	83 c4 18             	add    $0x18,%esp
}
  8019b4:	90                   	nop
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 13                	push   $0x13
  8019c6:	e8 13 fe ff ff       	call   8017de <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	90                   	nop
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 14                	push   $0x14
  8019e0:	e8 f9 fd ff ff       	call   8017de <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
}
  8019e8:	90                   	nop
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_cputc>:


void
sys_cputc(const char c)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 04             	sub    $0x4,%esp
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	50                   	push   %eax
  801a04:	6a 15                	push   $0x15
  801a06:	e8 d3 fd ff ff       	call   8017de <syscall>
  801a0b:	83 c4 18             	add    $0x18,%esp
}
  801a0e:	90                   	nop
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 16                	push   $0x16
  801a20:	e8 b9 fd ff ff       	call   8017de <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	90                   	nop
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	50                   	push   %eax
  801a3b:	6a 17                	push   $0x17
  801a3d:	e8 9c fd ff ff       	call   8017de <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	52                   	push   %edx
  801a57:	50                   	push   %eax
  801a58:	6a 1a                	push   $0x1a
  801a5a:	e8 7f fd ff ff       	call   8017de <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	52                   	push   %edx
  801a74:	50                   	push   %eax
  801a75:	6a 18                	push   $0x18
  801a77:	e8 62 fd ff ff       	call   8017de <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	90                   	nop
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	52                   	push   %edx
  801a92:	50                   	push   %eax
  801a93:	6a 19                	push   $0x19
  801a95:	e8 44 fd ff ff       	call   8017de <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	90                   	nop
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 04             	sub    $0x4,%esp
  801aa6:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aaf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	51                   	push   %ecx
  801ab9:	52                   	push   %edx
  801aba:	ff 75 0c             	pushl  0xc(%ebp)
  801abd:	50                   	push   %eax
  801abe:	6a 1b                	push   $0x1b
  801ac0:	e8 19 fd ff ff       	call   8017de <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801acd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	52                   	push   %edx
  801ada:	50                   	push   %eax
  801adb:	6a 1c                	push   $0x1c
  801add:	e8 fc fc ff ff       	call   8017de <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	51                   	push   %ecx
  801af8:	52                   	push   %edx
  801af9:	50                   	push   %eax
  801afa:	6a 1d                	push   $0x1d
  801afc:	e8 dd fc ff ff       	call   8017de <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 1e                	push   $0x1e
  801b19:	e8 c0 fc ff ff       	call   8017de <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 1f                	push   $0x1f
  801b32:	e8 a7 fc ff ff       	call   8017de <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	ff 75 14             	pushl  0x14(%ebp)
  801b47:	ff 75 10             	pushl  0x10(%ebp)
  801b4a:	ff 75 0c             	pushl  0xc(%ebp)
  801b4d:	50                   	push   %eax
  801b4e:	6a 20                	push   $0x20
  801b50:	e8 89 fc ff ff       	call   8017de <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	50                   	push   %eax
  801b69:	6a 21                	push   $0x21
  801b6b:	e8 6e fc ff ff       	call   8017de <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	50                   	push   %eax
  801b85:	6a 22                	push   $0x22
  801b87:	e8 52 fc ff ff       	call   8017de <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 02                	push   $0x2
  801ba0:	e8 39 fc ff ff       	call   8017de <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 03                	push   $0x3
  801bb9:	e8 20 fc ff ff       	call   8017de <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 04                	push   $0x4
  801bd2:	e8 07 fc ff ff       	call   8017de <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_exit_env>:


void sys_exit_env(void)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 23                	push   $0x23
  801beb:	e8 ee fb ff ff       	call   8017de <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	90                   	nop
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bfc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bff:	8d 50 04             	lea    0x4(%eax),%edx
  801c02:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	52                   	push   %edx
  801c0c:	50                   	push   %eax
  801c0d:	6a 24                	push   $0x24
  801c0f:	e8 ca fb ff ff       	call   8017de <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
	return result;
  801c17:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c20:	89 01                	mov    %eax,(%ecx)
  801c22:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	c9                   	leave  
  801c29:	c2 04 00             	ret    $0x4

00801c2c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	ff 75 10             	pushl  0x10(%ebp)
  801c36:	ff 75 0c             	pushl  0xc(%ebp)
  801c39:	ff 75 08             	pushl  0x8(%ebp)
  801c3c:	6a 12                	push   $0x12
  801c3e:	e8 9b fb ff ff       	call   8017de <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
	return ;
  801c46:	90                   	nop
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 25                	push   $0x25
  801c58:	e8 81 fb ff ff       	call   8017de <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 04             	sub    $0x4,%esp
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c6e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	50                   	push   %eax
  801c7b:	6a 26                	push   $0x26
  801c7d:	e8 5c fb ff ff       	call   8017de <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
	return ;
  801c85:	90                   	nop
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <rsttst>:
void rsttst()
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 28                	push   $0x28
  801c97:	e8 42 fb ff ff       	call   8017de <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9f:	90                   	nop
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 04             	sub    $0x4,%esp
  801ca8:	8b 45 14             	mov    0x14(%ebp),%eax
  801cab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cae:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb5:	52                   	push   %edx
  801cb6:	50                   	push   %eax
  801cb7:	ff 75 10             	pushl  0x10(%ebp)
  801cba:	ff 75 0c             	pushl  0xc(%ebp)
  801cbd:	ff 75 08             	pushl  0x8(%ebp)
  801cc0:	6a 27                	push   $0x27
  801cc2:	e8 17 fb ff ff       	call   8017de <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cca:	90                   	nop
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <chktst>:
void chktst(uint32 n)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	6a 29                	push   $0x29
  801cdd:	e8 fc fa ff ff       	call   8017de <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <inctst>:

void inctst()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 2a                	push   $0x2a
  801cf7:	e8 e2 fa ff ff       	call   8017de <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cff:	90                   	nop
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <gettst>:
uint32 gettst()
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 2b                	push   $0x2b
  801d11:	e8 c8 fa ff ff       	call   8017de <syscall>
  801d16:	83 c4 18             	add    $0x18,%esp
}
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 2c                	push   $0x2c
  801d2d:	e8 ac fa ff ff       	call   8017de <syscall>
  801d32:	83 c4 18             	add    $0x18,%esp
  801d35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d38:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d3c:	75 07                	jne    801d45 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d43:	eb 05                	jmp    801d4a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4a:	c9                   	leave  
  801d4b:	c3                   	ret    

00801d4c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 2c                	push   $0x2c
  801d5e:	e8 7b fa ff ff       	call   8017de <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
  801d66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d69:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d6d:	75 07                	jne    801d76 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d74:	eb 05                	jmp    801d7b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 2c                	push   $0x2c
  801d8f:	e8 4a fa ff ff       	call   8017de <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
  801d97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d9a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d9e:	75 07                	jne    801da7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801da0:	b8 01 00 00 00       	mov    $0x1,%eax
  801da5:	eb 05                	jmp    801dac <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 2c                	push   $0x2c
  801dc0:	e8 19 fa ff ff       	call   8017de <syscall>
  801dc5:	83 c4 18             	add    $0x18,%esp
  801dc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dcb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dcf:	75 07                	jne    801dd8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd6:	eb 05                	jmp    801ddd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	ff 75 08             	pushl  0x8(%ebp)
  801ded:	6a 2d                	push   $0x2d
  801def:	e8 ea f9 ff ff       	call   8017de <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
	return ;
  801df7:	90                   	nop
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dfe:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e01:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	6a 00                	push   $0x0
  801e0c:	53                   	push   %ebx
  801e0d:	51                   	push   %ecx
  801e0e:	52                   	push   %edx
  801e0f:	50                   	push   %eax
  801e10:	6a 2e                	push   $0x2e
  801e12:	e8 c7 f9 ff ff       	call   8017de <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
}
  801e1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	52                   	push   %edx
  801e2f:	50                   	push   %eax
  801e30:	6a 2f                	push   $0x2f
  801e32:	e8 a7 f9 ff ff       	call   8017de <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e42:	83 ec 0c             	sub    $0xc,%esp
  801e45:	68 60 3e 80 00       	push   $0x803e60
  801e4a:	e8 d6 e6 ff ff       	call   800525 <cprintf>
  801e4f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e52:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e59:	83 ec 0c             	sub    $0xc,%esp
  801e5c:	68 8c 3e 80 00       	push   $0x803e8c
  801e61:	e8 bf e6 ff ff       	call   800525 <cprintf>
  801e66:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e69:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e6d:	a1 38 41 80 00       	mov    0x804138,%eax
  801e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e75:	eb 56                	jmp    801ecd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e7b:	74 1c                	je     801e99 <print_mem_block_lists+0x5d>
  801e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e80:	8b 50 08             	mov    0x8(%eax),%edx
  801e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e86:	8b 48 08             	mov    0x8(%eax),%ecx
  801e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8f:	01 c8                	add    %ecx,%eax
  801e91:	39 c2                	cmp    %eax,%edx
  801e93:	73 04                	jae    801e99 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e95:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	8b 50 08             	mov    0x8(%eax),%edx
  801e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea5:	01 c2                	add    %eax,%edx
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaa:	8b 40 08             	mov    0x8(%eax),%eax
  801ead:	83 ec 04             	sub    $0x4,%esp
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	68 a1 3e 80 00       	push   $0x803ea1
  801eb7:	e8 69 e6 ff ff       	call   800525 <cprintf>
  801ebc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec5:	a1 40 41 80 00       	mov    0x804140,%eax
  801eca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed1:	74 07                	je     801eda <print_mem_block_lists+0x9e>
  801ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed6:	8b 00                	mov    (%eax),%eax
  801ed8:	eb 05                	jmp    801edf <print_mem_block_lists+0xa3>
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
  801edf:	a3 40 41 80 00       	mov    %eax,0x804140
  801ee4:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	75 8a                	jne    801e77 <print_mem_block_lists+0x3b>
  801eed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef1:	75 84                	jne    801e77 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ef3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef7:	75 10                	jne    801f09 <print_mem_block_lists+0xcd>
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	68 b0 3e 80 00       	push   $0x803eb0
  801f01:	e8 1f e6 ff ff       	call   800525 <cprintf>
  801f06:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	68 d4 3e 80 00       	push   $0x803ed4
  801f18:	e8 08 e6 ff ff       	call   800525 <cprintf>
  801f1d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f20:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f24:	a1 40 40 80 00       	mov    0x804040,%eax
  801f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2c:	eb 56                	jmp    801f84 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f32:	74 1c                	je     801f50 <print_mem_block_lists+0x114>
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	8b 50 08             	mov    0x8(%eax),%edx
  801f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3d:	8b 48 08             	mov    0x8(%eax),%ecx
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	8b 40 0c             	mov    0xc(%eax),%eax
  801f46:	01 c8                	add    %ecx,%eax
  801f48:	39 c2                	cmp    %eax,%edx
  801f4a:	73 04                	jae    801f50 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f4c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 50 08             	mov    0x8(%eax),%edx
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5c:	01 c2                	add    %eax,%edx
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 40 08             	mov    0x8(%eax),%eax
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	52                   	push   %edx
  801f68:	50                   	push   %eax
  801f69:	68 a1 3e 80 00       	push   $0x803ea1
  801f6e:	e8 b2 e5 ff ff       	call   800525 <cprintf>
  801f73:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7c:	a1 48 40 80 00       	mov    0x804048,%eax
  801f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f88:	74 07                	je     801f91 <print_mem_block_lists+0x155>
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	8b 00                	mov    (%eax),%eax
  801f8f:	eb 05                	jmp    801f96 <print_mem_block_lists+0x15a>
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
  801f96:	a3 48 40 80 00       	mov    %eax,0x804048
  801f9b:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	75 8a                	jne    801f2e <print_mem_block_lists+0xf2>
  801fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa8:	75 84                	jne    801f2e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801faa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fae:	75 10                	jne    801fc0 <print_mem_block_lists+0x184>
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	68 ec 3e 80 00       	push   $0x803eec
  801fb8:	e8 68 e5 ff ff       	call   800525 <cprintf>
  801fbd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fc0:	83 ec 0c             	sub    $0xc,%esp
  801fc3:	68 60 3e 80 00       	push   $0x803e60
  801fc8:	e8 58 e5 ff ff       	call   800525 <cprintf>
  801fcd:	83 c4 10             	add    $0x10,%esp

}
  801fd0:	90                   	nop
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801fd9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fe0:	00 00 00 
  801fe3:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fea:	00 00 00 
  801fed:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ff4:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801ff7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ffe:	e9 9e 00 00 00       	jmp    8020a1 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802003:	a1 50 40 80 00       	mov    0x804050,%eax
  802008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200b:	c1 e2 04             	shl    $0x4,%edx
  80200e:	01 d0                	add    %edx,%eax
  802010:	85 c0                	test   %eax,%eax
  802012:	75 14                	jne    802028 <initialize_MemBlocksList+0x55>
  802014:	83 ec 04             	sub    $0x4,%esp
  802017:	68 14 3f 80 00       	push   $0x803f14
  80201c:	6a 46                	push   $0x46
  80201e:	68 37 3f 80 00       	push   $0x803f37
  802023:	e8 49 e2 ff ff       	call   800271 <_panic>
  802028:	a1 50 40 80 00       	mov    0x804050,%eax
  80202d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802030:	c1 e2 04             	shl    $0x4,%edx
  802033:	01 d0                	add    %edx,%eax
  802035:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80203b:	89 10                	mov    %edx,(%eax)
  80203d:	8b 00                	mov    (%eax),%eax
  80203f:	85 c0                	test   %eax,%eax
  802041:	74 18                	je     80205b <initialize_MemBlocksList+0x88>
  802043:	a1 48 41 80 00       	mov    0x804148,%eax
  802048:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80204e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802051:	c1 e1 04             	shl    $0x4,%ecx
  802054:	01 ca                	add    %ecx,%edx
  802056:	89 50 04             	mov    %edx,0x4(%eax)
  802059:	eb 12                	jmp    80206d <initialize_MemBlocksList+0x9a>
  80205b:	a1 50 40 80 00       	mov    0x804050,%eax
  802060:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802063:	c1 e2 04             	shl    $0x4,%edx
  802066:	01 d0                	add    %edx,%eax
  802068:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80206d:	a1 50 40 80 00       	mov    0x804050,%eax
  802072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802075:	c1 e2 04             	shl    $0x4,%edx
  802078:	01 d0                	add    %edx,%eax
  80207a:	a3 48 41 80 00       	mov    %eax,0x804148
  80207f:	a1 50 40 80 00       	mov    0x804050,%eax
  802084:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802087:	c1 e2 04             	shl    $0x4,%edx
  80208a:	01 d0                	add    %edx,%eax
  80208c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802093:	a1 54 41 80 00       	mov    0x804154,%eax
  802098:	40                   	inc    %eax
  802099:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80209e:	ff 45 f4             	incl   -0xc(%ebp)
  8020a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a7:	0f 82 56 ff ff ff    	jb     802003 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020ad:	90                   	nop
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	8b 00                	mov    (%eax),%eax
  8020bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020be:	eb 19                	jmp    8020d9 <find_block+0x29>
	{
		if(va==point->sva)
  8020c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c3:	8b 40 08             	mov    0x8(%eax),%eax
  8020c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020c9:	75 05                	jne    8020d0 <find_block+0x20>
		   return point;
  8020cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ce:	eb 36                	jmp    802106 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	8b 40 08             	mov    0x8(%eax),%eax
  8020d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020dd:	74 07                	je     8020e6 <find_block+0x36>
  8020df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e2:	8b 00                	mov    (%eax),%eax
  8020e4:	eb 05                	jmp    8020eb <find_block+0x3b>
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ee:	89 42 08             	mov    %eax,0x8(%edx)
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	8b 40 08             	mov    0x8(%eax),%eax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	75 c5                	jne    8020c0 <find_block+0x10>
  8020fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020ff:	75 bf                	jne    8020c0 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  80210e:	a1 40 40 80 00       	mov    0x804040,%eax
  802113:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802116:	a1 44 40 80 00       	mov    0x804044,%eax
  80211b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  80211e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802121:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802124:	74 24                	je     80214a <insert_sorted_allocList+0x42>
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	8b 50 08             	mov    0x8(%eax),%edx
  80212c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212f:	8b 40 08             	mov    0x8(%eax),%eax
  802132:	39 c2                	cmp    %eax,%edx
  802134:	76 14                	jbe    80214a <insert_sorted_allocList+0x42>
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	8b 50 08             	mov    0x8(%eax),%edx
  80213c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80213f:	8b 40 08             	mov    0x8(%eax),%eax
  802142:	39 c2                	cmp    %eax,%edx
  802144:	0f 82 60 01 00 00    	jb     8022aa <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80214a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214e:	75 65                	jne    8021b5 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802150:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802154:	75 14                	jne    80216a <insert_sorted_allocList+0x62>
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	68 14 3f 80 00       	push   $0x803f14
  80215e:	6a 6b                	push   $0x6b
  802160:	68 37 3f 80 00       	push   $0x803f37
  802165:	e8 07 e1 ff ff       	call   800271 <_panic>
  80216a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	89 10                	mov    %edx,(%eax)
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	8b 00                	mov    (%eax),%eax
  80217a:	85 c0                	test   %eax,%eax
  80217c:	74 0d                	je     80218b <insert_sorted_allocList+0x83>
  80217e:	a1 40 40 80 00       	mov    0x804040,%eax
  802183:	8b 55 08             	mov    0x8(%ebp),%edx
  802186:	89 50 04             	mov    %edx,0x4(%eax)
  802189:	eb 08                	jmp    802193 <insert_sorted_allocList+0x8b>
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	a3 44 40 80 00       	mov    %eax,0x804044
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	a3 40 40 80 00       	mov    %eax,0x804040
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021aa:	40                   	inc    %eax
  8021ab:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b0:	e9 dc 01 00 00       	jmp    802391 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8b 50 08             	mov    0x8(%eax),%edx
  8021bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021be:	8b 40 08             	mov    0x8(%eax),%eax
  8021c1:	39 c2                	cmp    %eax,%edx
  8021c3:	77 6c                	ja     802231 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8021c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021c9:	74 06                	je     8021d1 <insert_sorted_allocList+0xc9>
  8021cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021cf:	75 14                	jne    8021e5 <insert_sorted_allocList+0xdd>
  8021d1:	83 ec 04             	sub    $0x4,%esp
  8021d4:	68 50 3f 80 00       	push   $0x803f50
  8021d9:	6a 6f                	push   $0x6f
  8021db:	68 37 3f 80 00       	push   $0x803f37
  8021e0:	e8 8c e0 ff ff       	call   800271 <_panic>
  8021e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e8:	8b 50 04             	mov    0x4(%eax),%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	89 50 04             	mov    %edx,0x4(%eax)
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021f7:	89 10                	mov    %edx,(%eax)
  8021f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fc:	8b 40 04             	mov    0x4(%eax),%eax
  8021ff:	85 c0                	test   %eax,%eax
  802201:	74 0d                	je     802210 <insert_sorted_allocList+0x108>
  802203:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802206:	8b 40 04             	mov    0x4(%eax),%eax
  802209:	8b 55 08             	mov    0x8(%ebp),%edx
  80220c:	89 10                	mov    %edx,(%eax)
  80220e:	eb 08                	jmp    802218 <insert_sorted_allocList+0x110>
  802210:	8b 45 08             	mov    0x8(%ebp),%eax
  802213:	a3 40 40 80 00       	mov    %eax,0x804040
  802218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221b:	8b 55 08             	mov    0x8(%ebp),%edx
  80221e:	89 50 04             	mov    %edx,0x4(%eax)
  802221:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802226:	40                   	inc    %eax
  802227:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80222c:	e9 60 01 00 00       	jmp    802391 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	8b 50 08             	mov    0x8(%eax),%edx
  802237:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80223a:	8b 40 08             	mov    0x8(%eax),%eax
  80223d:	39 c2                	cmp    %eax,%edx
  80223f:	0f 82 4c 01 00 00    	jb     802391 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802249:	75 14                	jne    80225f <insert_sorted_allocList+0x157>
  80224b:	83 ec 04             	sub    $0x4,%esp
  80224e:	68 88 3f 80 00       	push   $0x803f88
  802253:	6a 73                	push   $0x73
  802255:	68 37 3f 80 00       	push   $0x803f37
  80225a:	e8 12 e0 ff ff       	call   800271 <_panic>
  80225f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	89 50 04             	mov    %edx,0x4(%eax)
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	74 0c                	je     802281 <insert_sorted_allocList+0x179>
  802275:	a1 44 40 80 00       	mov    0x804044,%eax
  80227a:	8b 55 08             	mov    0x8(%ebp),%edx
  80227d:	89 10                	mov    %edx,(%eax)
  80227f:	eb 08                	jmp    802289 <insert_sorted_allocList+0x181>
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	a3 40 40 80 00       	mov    %eax,0x804040
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	a3 44 40 80 00       	mov    %eax,0x804044
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80229a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80229f:	40                   	inc    %eax
  8022a0:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a5:	e9 e7 00 00 00       	jmp    802391 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022b7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022bf:	e9 9d 00 00 00       	jmp    802361 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	8b 50 08             	mov    0x8(%eax),%edx
  8022d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d5:	8b 40 08             	mov    0x8(%eax),%eax
  8022d8:	39 c2                	cmp    %eax,%edx
  8022da:	76 7d                	jbe    802359 <insert_sorted_allocList+0x251>
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	8b 50 08             	mov    0x8(%eax),%edx
  8022e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022e5:	8b 40 08             	mov    0x8(%eax),%eax
  8022e8:	39 c2                	cmp    %eax,%edx
  8022ea:	73 6d                	jae    802359 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8022ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f0:	74 06                	je     8022f8 <insert_sorted_allocList+0x1f0>
  8022f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f6:	75 14                	jne    80230c <insert_sorted_allocList+0x204>
  8022f8:	83 ec 04             	sub    $0x4,%esp
  8022fb:	68 ac 3f 80 00       	push   $0x803fac
  802300:	6a 7f                	push   $0x7f
  802302:	68 37 3f 80 00       	push   $0x803f37
  802307:	e8 65 df ff ff       	call   800271 <_panic>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 10                	mov    (%eax),%edx
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	89 10                	mov    %edx,(%eax)
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	8b 00                	mov    (%eax),%eax
  80231b:	85 c0                	test   %eax,%eax
  80231d:	74 0b                	je     80232a <insert_sorted_allocList+0x222>
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	8b 00                	mov    (%eax),%eax
  802324:	8b 55 08             	mov    0x8(%ebp),%edx
  802327:	89 50 04             	mov    %edx,0x4(%eax)
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 55 08             	mov    0x8(%ebp),%edx
  802330:	89 10                	mov    %edx,(%eax)
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802338:	89 50 04             	mov    %edx,0x4(%eax)
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	8b 00                	mov    (%eax),%eax
  802340:	85 c0                	test   %eax,%eax
  802342:	75 08                	jne    80234c <insert_sorted_allocList+0x244>
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	a3 44 40 80 00       	mov    %eax,0x804044
  80234c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802351:	40                   	inc    %eax
  802352:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  802357:	eb 39                	jmp    802392 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802359:	a1 48 40 80 00       	mov    0x804048,%eax
  80235e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802365:	74 07                	je     80236e <insert_sorted_allocList+0x266>
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	8b 00                	mov    (%eax),%eax
  80236c:	eb 05                	jmp    802373 <insert_sorted_allocList+0x26b>
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
  802373:	a3 48 40 80 00       	mov    %eax,0x804048
  802378:	a1 48 40 80 00       	mov    0x804048,%eax
  80237d:	85 c0                	test   %eax,%eax
  80237f:	0f 85 3f ff ff ff    	jne    8022c4 <insert_sorted_allocList+0x1bc>
  802385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802389:	0f 85 35 ff ff ff    	jne    8022c4 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80238f:	eb 01                	jmp    802392 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802391:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802392:	90                   	nop
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80239b:	a1 38 41 80 00       	mov    0x804138,%eax
  8023a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a3:	e9 85 01 00 00       	jmp    80252d <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b1:	0f 82 6e 01 00 00    	jb     802525 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c0:	0f 85 8a 00 00 00    	jne    802450 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8023c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ca:	75 17                	jne    8023e3 <alloc_block_FF+0x4e>
  8023cc:	83 ec 04             	sub    $0x4,%esp
  8023cf:	68 e0 3f 80 00       	push   $0x803fe0
  8023d4:	68 93 00 00 00       	push   $0x93
  8023d9:	68 37 3f 80 00       	push   $0x803f37
  8023de:	e8 8e de ff ff       	call   800271 <_panic>
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	74 10                	je     8023fc <alloc_block_FF+0x67>
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 00                	mov    (%eax),%eax
  8023f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f4:	8b 52 04             	mov    0x4(%edx),%edx
  8023f7:	89 50 04             	mov    %edx,0x4(%eax)
  8023fa:	eb 0b                	jmp    802407 <alloc_block_FF+0x72>
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 40 04             	mov    0x4(%eax),%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	74 0f                	je     802420 <alloc_block_FF+0x8b>
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241a:	8b 12                	mov    (%edx),%edx
  80241c:	89 10                	mov    %edx,(%eax)
  80241e:	eb 0a                	jmp    80242a <alloc_block_FF+0x95>
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	a3 38 41 80 00       	mov    %eax,0x804138
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243d:	a1 44 41 80 00       	mov    0x804144,%eax
  802442:	48                   	dec    %eax
  802443:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	e9 10 01 00 00       	jmp    802560 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 40 0c             	mov    0xc(%eax),%eax
  802456:	3b 45 08             	cmp    0x8(%ebp),%eax
  802459:	0f 86 c6 00 00 00    	jbe    802525 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80245f:	a1 48 41 80 00       	mov    0x804148,%eax
  802464:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 50 08             	mov    0x8(%eax),%edx
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802476:	8b 55 08             	mov    0x8(%ebp),%edx
  802479:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80247c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802480:	75 17                	jne    802499 <alloc_block_FF+0x104>
  802482:	83 ec 04             	sub    $0x4,%esp
  802485:	68 e0 3f 80 00       	push   $0x803fe0
  80248a:	68 9b 00 00 00       	push   $0x9b
  80248f:	68 37 3f 80 00       	push   $0x803f37
  802494:	e8 d8 dd ff ff       	call   800271 <_panic>
  802499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	85 c0                	test   %eax,%eax
  8024a0:	74 10                	je     8024b2 <alloc_block_FF+0x11d>
  8024a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024aa:	8b 52 04             	mov    0x4(%edx),%edx
  8024ad:	89 50 04             	mov    %edx,0x4(%eax)
  8024b0:	eb 0b                	jmp    8024bd <alloc_block_FF+0x128>
  8024b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b5:	8b 40 04             	mov    0x4(%eax),%eax
  8024b8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	74 0f                	je     8024d6 <alloc_block_FF+0x141>
  8024c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ca:	8b 40 04             	mov    0x4(%eax),%eax
  8024cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d0:	8b 12                	mov    (%edx),%edx
  8024d2:	89 10                	mov    %edx,(%eax)
  8024d4:	eb 0a                	jmp    8024e0 <alloc_block_FF+0x14b>
  8024d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	a3 48 41 80 00       	mov    %eax,0x804148
  8024e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f3:	a1 54 41 80 00       	mov    0x804154,%eax
  8024f8:	48                   	dec    %eax
  8024f9:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 50 08             	mov    0x8(%eax),%edx
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	01 c2                	add    %eax,%edx
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 0c             	mov    0xc(%eax),%eax
  802515:	2b 45 08             	sub    0x8(%ebp),%eax
  802518:	89 c2                	mov    %eax,%edx
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802523:	eb 3b                	jmp    802560 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802525:	a1 40 41 80 00       	mov    0x804140,%eax
  80252a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802531:	74 07                	je     80253a <alloc_block_FF+0x1a5>
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 00                	mov    (%eax),%eax
  802538:	eb 05                	jmp    80253f <alloc_block_FF+0x1aa>
  80253a:	b8 00 00 00 00       	mov    $0x0,%eax
  80253f:	a3 40 41 80 00       	mov    %eax,0x804140
  802544:	a1 40 41 80 00       	mov    0x804140,%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	0f 85 57 fe ff ff    	jne    8023a8 <alloc_block_FF+0x13>
  802551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802555:	0f 85 4d fe ff ff    	jne    8023a8 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80255b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802560:	c9                   	leave  
  802561:	c3                   	ret    

00802562 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802562:	55                   	push   %ebp
  802563:	89 e5                	mov    %esp,%ebp
  802565:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802568:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80256f:	a1 38 41 80 00       	mov    0x804138,%eax
  802574:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802577:	e9 df 00 00 00       	jmp    80265b <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 40 0c             	mov    0xc(%eax),%eax
  802582:	3b 45 08             	cmp    0x8(%ebp),%eax
  802585:	0f 82 c8 00 00 00    	jb     802653 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 40 0c             	mov    0xc(%eax),%eax
  802591:	3b 45 08             	cmp    0x8(%ebp),%eax
  802594:	0f 85 8a 00 00 00    	jne    802624 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80259a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259e:	75 17                	jne    8025b7 <alloc_block_BF+0x55>
  8025a0:	83 ec 04             	sub    $0x4,%esp
  8025a3:	68 e0 3f 80 00       	push   $0x803fe0
  8025a8:	68 b7 00 00 00       	push   $0xb7
  8025ad:	68 37 3f 80 00       	push   $0x803f37
  8025b2:	e8 ba dc ff ff       	call   800271 <_panic>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 10                	je     8025d0 <alloc_block_BF+0x6e>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c8:	8b 52 04             	mov    0x4(%edx),%edx
  8025cb:	89 50 04             	mov    %edx,0x4(%eax)
  8025ce:	eb 0b                	jmp    8025db <alloc_block_BF+0x79>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 40 04             	mov    0x4(%eax),%eax
  8025d6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 40 04             	mov    0x4(%eax),%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	74 0f                	je     8025f4 <alloc_block_BF+0x92>
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 40 04             	mov    0x4(%eax),%eax
  8025eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ee:	8b 12                	mov    (%edx),%edx
  8025f0:	89 10                	mov    %edx,(%eax)
  8025f2:	eb 0a                	jmp    8025fe <alloc_block_BF+0x9c>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	a3 38 41 80 00       	mov    %eax,0x804138
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802611:	a1 44 41 80 00       	mov    0x804144,%eax
  802616:	48                   	dec    %eax
  802617:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	e9 4d 01 00 00       	jmp    802771 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 40 0c             	mov    0xc(%eax),%eax
  80262a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80262d:	76 24                	jbe    802653 <alloc_block_BF+0xf1>
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 40 0c             	mov    0xc(%eax),%eax
  802635:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802638:	73 19                	jae    802653 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80263a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 40 0c             	mov    0xc(%eax),%eax
  802647:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 40 08             	mov    0x8(%eax),%eax
  802650:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802653:	a1 40 41 80 00       	mov    0x804140,%eax
  802658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265f:	74 07                	je     802668 <alloc_block_BF+0x106>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	eb 05                	jmp    80266d <alloc_block_BF+0x10b>
  802668:	b8 00 00 00 00       	mov    $0x0,%eax
  80266d:	a3 40 41 80 00       	mov    %eax,0x804140
  802672:	a1 40 41 80 00       	mov    0x804140,%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	0f 85 fd fe ff ff    	jne    80257c <alloc_block_BF+0x1a>
  80267f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802683:	0f 85 f3 fe ff ff    	jne    80257c <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802689:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80268d:	0f 84 d9 00 00 00    	je     80276c <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802693:	a1 48 41 80 00       	mov    0x804148,%eax
  802698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80269b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a1:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026aa:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026b1:	75 17                	jne    8026ca <alloc_block_BF+0x168>
  8026b3:	83 ec 04             	sub    $0x4,%esp
  8026b6:	68 e0 3f 80 00       	push   $0x803fe0
  8026bb:	68 c7 00 00 00       	push   $0xc7
  8026c0:	68 37 3f 80 00       	push   $0x803f37
  8026c5:	e8 a7 db ff ff       	call   800271 <_panic>
  8026ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	74 10                	je     8026e3 <alloc_block_BF+0x181>
  8026d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d6:	8b 00                	mov    (%eax),%eax
  8026d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026db:	8b 52 04             	mov    0x4(%edx),%edx
  8026de:	89 50 04             	mov    %edx,0x4(%eax)
  8026e1:	eb 0b                	jmp    8026ee <alloc_block_BF+0x18c>
  8026e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e6:	8b 40 04             	mov    0x4(%eax),%eax
  8026e9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	74 0f                	je     802707 <alloc_block_BF+0x1a5>
  8026f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fb:	8b 40 04             	mov    0x4(%eax),%eax
  8026fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802701:	8b 12                	mov    (%edx),%edx
  802703:	89 10                	mov    %edx,(%eax)
  802705:	eb 0a                	jmp    802711 <alloc_block_BF+0x1af>
  802707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270a:	8b 00                	mov    (%eax),%eax
  80270c:	a3 48 41 80 00       	mov    %eax,0x804148
  802711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802714:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802724:	a1 54 41 80 00       	mov    0x804154,%eax
  802729:	48                   	dec    %eax
  80272a:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  80272f:	83 ec 08             	sub    $0x8,%esp
  802732:	ff 75 ec             	pushl  -0x14(%ebp)
  802735:	68 38 41 80 00       	push   $0x804138
  80273a:	e8 71 f9 ff ff       	call   8020b0 <find_block>
  80273f:	83 c4 10             	add    $0x10,%esp
  802742:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802745:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802748:	8b 50 08             	mov    0x8(%eax),%edx
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	01 c2                	add    %eax,%edx
  802750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802753:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802756:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802759:	8b 40 0c             	mov    0xc(%eax),%eax
  80275c:	2b 45 08             	sub    0x8(%ebp),%eax
  80275f:	89 c2                	mov    %eax,%edx
  802761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802764:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276a:	eb 05                	jmp    802771 <alloc_block_BF+0x20f>
	}
	return NULL;
  80276c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802771:	c9                   	leave  
  802772:	c3                   	ret    

00802773 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802779:	a1 28 40 80 00       	mov    0x804028,%eax
  80277e:	85 c0                	test   %eax,%eax
  802780:	0f 85 de 01 00 00    	jne    802964 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802786:	a1 38 41 80 00       	mov    0x804138,%eax
  80278b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278e:	e9 9e 01 00 00       	jmp    802931 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 40 0c             	mov    0xc(%eax),%eax
  802799:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279c:	0f 82 87 01 00 00    	jb     802929 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ab:	0f 85 95 00 00 00    	jne    802846 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b5:	75 17                	jne    8027ce <alloc_block_NF+0x5b>
  8027b7:	83 ec 04             	sub    $0x4,%esp
  8027ba:	68 e0 3f 80 00       	push   $0x803fe0
  8027bf:	68 e0 00 00 00       	push   $0xe0
  8027c4:	68 37 3f 80 00       	push   $0x803f37
  8027c9:	e8 a3 da ff ff       	call   800271 <_panic>
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 10                	je     8027e7 <alloc_block_NF+0x74>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027df:	8b 52 04             	mov    0x4(%edx),%edx
  8027e2:	89 50 04             	mov    %edx,0x4(%eax)
  8027e5:	eb 0b                	jmp    8027f2 <alloc_block_NF+0x7f>
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 40 04             	mov    0x4(%eax),%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	74 0f                	je     80280b <alloc_block_NF+0x98>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 04             	mov    0x4(%eax),%eax
  802802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802805:	8b 12                	mov    (%edx),%edx
  802807:	89 10                	mov    %edx,(%eax)
  802809:	eb 0a                	jmp    802815 <alloc_block_NF+0xa2>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	a3 38 41 80 00       	mov    %eax,0x804138
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802828:	a1 44 41 80 00       	mov    0x804144,%eax
  80282d:	48                   	dec    %eax
  80282e:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 08             	mov    0x8(%eax),%eax
  802839:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	e9 f8 04 00 00       	jmp    802d3e <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 0c             	mov    0xc(%eax),%eax
  80284c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284f:	0f 86 d4 00 00 00    	jbe    802929 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802855:	a1 48 41 80 00       	mov    0x804148,%eax
  80285a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	8b 50 08             	mov    0x8(%eax),%edx
  802863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802866:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286c:	8b 55 08             	mov    0x8(%ebp),%edx
  80286f:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802872:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802876:	75 17                	jne    80288f <alloc_block_NF+0x11c>
  802878:	83 ec 04             	sub    $0x4,%esp
  80287b:	68 e0 3f 80 00       	push   $0x803fe0
  802880:	68 e9 00 00 00       	push   $0xe9
  802885:	68 37 3f 80 00       	push   $0x803f37
  80288a:	e8 e2 d9 ff ff       	call   800271 <_panic>
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	85 c0                	test   %eax,%eax
  802896:	74 10                	je     8028a8 <alloc_block_NF+0x135>
  802898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028a0:	8b 52 04             	mov    0x4(%edx),%edx
  8028a3:	89 50 04             	mov    %edx,0x4(%eax)
  8028a6:	eb 0b                	jmp    8028b3 <alloc_block_NF+0x140>
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	8b 40 04             	mov    0x4(%eax),%eax
  8028ae:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	8b 40 04             	mov    0x4(%eax),%eax
  8028b9:	85 c0                	test   %eax,%eax
  8028bb:	74 0f                	je     8028cc <alloc_block_NF+0x159>
  8028bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c0:	8b 40 04             	mov    0x4(%eax),%eax
  8028c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c6:	8b 12                	mov    (%edx),%edx
  8028c8:	89 10                	mov    %edx,(%eax)
  8028ca:	eb 0a                	jmp    8028d6 <alloc_block_NF+0x163>
  8028cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cf:	8b 00                	mov    (%eax),%eax
  8028d1:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e9:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ee:	48                   	dec    %eax
  8028ef:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	8b 40 08             	mov    0x8(%eax),%eax
  8028fa:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 50 08             	mov    0x8(%eax),%edx
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	01 c2                	add    %eax,%edx
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	8b 40 0c             	mov    0xc(%eax),%eax
  802916:	2b 45 08             	sub    0x8(%ebp),%eax
  802919:	89 c2                	mov    %eax,%edx
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802921:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802924:	e9 15 04 00 00       	jmp    802d3e <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802929:	a1 40 41 80 00       	mov    0x804140,%eax
  80292e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802935:	74 07                	je     80293e <alloc_block_NF+0x1cb>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	eb 05                	jmp    802943 <alloc_block_NF+0x1d0>
  80293e:	b8 00 00 00 00       	mov    $0x0,%eax
  802943:	a3 40 41 80 00       	mov    %eax,0x804140
  802948:	a1 40 41 80 00       	mov    0x804140,%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	0f 85 3e fe ff ff    	jne    802793 <alloc_block_NF+0x20>
  802955:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802959:	0f 85 34 fe ff ff    	jne    802793 <alloc_block_NF+0x20>
  80295f:	e9 d5 03 00 00       	jmp    802d39 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802964:	a1 38 41 80 00       	mov    0x804138,%eax
  802969:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80296c:	e9 b1 01 00 00       	jmp    802b22 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802974:	8b 50 08             	mov    0x8(%eax),%edx
  802977:	a1 28 40 80 00       	mov    0x804028,%eax
  80297c:	39 c2                	cmp    %eax,%edx
  80297e:	0f 82 96 01 00 00    	jb     802b1a <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 0c             	mov    0xc(%eax),%eax
  80298a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80298d:	0f 82 87 01 00 00    	jb     802b1a <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	8b 40 0c             	mov    0xc(%eax),%eax
  802999:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299c:	0f 85 95 00 00 00    	jne    802a37 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a6:	75 17                	jne    8029bf <alloc_block_NF+0x24c>
  8029a8:	83 ec 04             	sub    $0x4,%esp
  8029ab:	68 e0 3f 80 00       	push   $0x803fe0
  8029b0:	68 fc 00 00 00       	push   $0xfc
  8029b5:	68 37 3f 80 00       	push   $0x803f37
  8029ba:	e8 b2 d8 ff ff       	call   800271 <_panic>
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 00                	mov    (%eax),%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	74 10                	je     8029d8 <alloc_block_NF+0x265>
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	8b 00                	mov    (%eax),%eax
  8029cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d0:	8b 52 04             	mov    0x4(%edx),%edx
  8029d3:	89 50 04             	mov    %edx,0x4(%eax)
  8029d6:	eb 0b                	jmp    8029e3 <alloc_block_NF+0x270>
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 04             	mov    0x4(%eax),%eax
  8029de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 40 04             	mov    0x4(%eax),%eax
  8029e9:	85 c0                	test   %eax,%eax
  8029eb:	74 0f                	je     8029fc <alloc_block_NF+0x289>
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	8b 40 04             	mov    0x4(%eax),%eax
  8029f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f6:	8b 12                	mov    (%edx),%edx
  8029f8:	89 10                	mov    %edx,(%eax)
  8029fa:	eb 0a                	jmp    802a06 <alloc_block_NF+0x293>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	a3 38 41 80 00       	mov    %eax,0x804138
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a19:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1e:	48                   	dec    %eax
  802a1f:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 08             	mov    0x8(%eax),%eax
  802a2a:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	e9 07 03 00 00       	jmp    802d3e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a40:	0f 86 d4 00 00 00    	jbe    802b1a <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a46:	a1 48 41 80 00       	mov    0x804148,%eax
  802a4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 50 08             	mov    0x8(%eax),%edx
  802a54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a57:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a60:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a63:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a67:	75 17                	jne    802a80 <alloc_block_NF+0x30d>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 e0 3f 80 00       	push   $0x803fe0
  802a71:	68 04 01 00 00       	push   $0x104
  802a76:	68 37 3f 80 00       	push   $0x803f37
  802a7b:	e8 f1 d7 ff ff       	call   800271 <_panic>
  802a80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 10                	je     802a99 <alloc_block_NF+0x326>
  802a89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8c:	8b 00                	mov    (%eax),%eax
  802a8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a91:	8b 52 04             	mov    0x4(%edx),%edx
  802a94:	89 50 04             	mov    %edx,0x4(%eax)
  802a97:	eb 0b                	jmp    802aa4 <alloc_block_NF+0x331>
  802a99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9c:	8b 40 04             	mov    0x4(%eax),%eax
  802a9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa7:	8b 40 04             	mov    0x4(%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 0f                	je     802abd <alloc_block_NF+0x34a>
  802aae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab1:	8b 40 04             	mov    0x4(%eax),%eax
  802ab4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ab7:	8b 12                	mov    (%edx),%edx
  802ab9:	89 10                	mov    %edx,(%eax)
  802abb:	eb 0a                	jmp    802ac7 <alloc_block_NF+0x354>
  802abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ac7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ada:	a1 54 41 80 00       	mov    0x804154,%eax
  802adf:	48                   	dec    %eax
  802ae0:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae8:	8b 40 08             	mov    0x8(%eax),%eax
  802aeb:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 50 08             	mov    0x8(%eax),%edx
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	01 c2                	add    %eax,%edx
  802afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afe:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 40 0c             	mov    0xc(%eax),%eax
  802b07:	2b 45 08             	sub    0x8(%ebp),%eax
  802b0a:	89 c2                	mov    %eax,%edx
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b15:	e9 24 02 00 00       	jmp    802d3e <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b1a:	a1 40 41 80 00       	mov    0x804140,%eax
  802b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b26:	74 07                	je     802b2f <alloc_block_NF+0x3bc>
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	eb 05                	jmp    802b34 <alloc_block_NF+0x3c1>
  802b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b34:	a3 40 41 80 00       	mov    %eax,0x804140
  802b39:	a1 40 41 80 00       	mov    0x804140,%eax
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	0f 85 2b fe ff ff    	jne    802971 <alloc_block_NF+0x1fe>
  802b46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4a:	0f 85 21 fe ff ff    	jne    802971 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b50:	a1 38 41 80 00       	mov    0x804138,%eax
  802b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b58:	e9 ae 01 00 00       	jmp    802d0b <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 50 08             	mov    0x8(%eax),%edx
  802b63:	a1 28 40 80 00       	mov    0x804028,%eax
  802b68:	39 c2                	cmp    %eax,%edx
  802b6a:	0f 83 93 01 00 00    	jae    802d03 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 0c             	mov    0xc(%eax),%eax
  802b76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b79:	0f 82 84 01 00 00    	jb     802d03 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 40 0c             	mov    0xc(%eax),%eax
  802b85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b88:	0f 85 95 00 00 00    	jne    802c23 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b92:	75 17                	jne    802bab <alloc_block_NF+0x438>
  802b94:	83 ec 04             	sub    $0x4,%esp
  802b97:	68 e0 3f 80 00       	push   $0x803fe0
  802b9c:	68 14 01 00 00       	push   $0x114
  802ba1:	68 37 3f 80 00       	push   $0x803f37
  802ba6:	e8 c6 d6 ff ff       	call   800271 <_panic>
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 00                	mov    (%eax),%eax
  802bb0:	85 c0                	test   %eax,%eax
  802bb2:	74 10                	je     802bc4 <alloc_block_NF+0x451>
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbc:	8b 52 04             	mov    0x4(%edx),%edx
  802bbf:	89 50 04             	mov    %edx,0x4(%eax)
  802bc2:	eb 0b                	jmp    802bcf <alloc_block_NF+0x45c>
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 40 04             	mov    0x4(%eax),%eax
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	74 0f                	je     802be8 <alloc_block_NF+0x475>
  802bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdc:	8b 40 04             	mov    0x4(%eax),%eax
  802bdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be2:	8b 12                	mov    (%edx),%edx
  802be4:	89 10                	mov    %edx,(%eax)
  802be6:	eb 0a                	jmp    802bf2 <alloc_block_NF+0x47f>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	a3 38 41 80 00       	mov    %eax,0x804138
  802bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c05:	a1 44 41 80 00       	mov    0x804144,%eax
  802c0a:	48                   	dec    %eax
  802c0b:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 40 08             	mov    0x8(%eax),%eax
  802c16:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	e9 1b 01 00 00       	jmp    802d3e <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c26:	8b 40 0c             	mov    0xc(%eax),%eax
  802c29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2c:	0f 86 d1 00 00 00    	jbe    802d03 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c32:	a1 48 41 80 00       	mov    0x804148,%eax
  802c37:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 50 08             	mov    0x8(%eax),%edx
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c49:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4c:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c4f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c53:	75 17                	jne    802c6c <alloc_block_NF+0x4f9>
  802c55:	83 ec 04             	sub    $0x4,%esp
  802c58:	68 e0 3f 80 00       	push   $0x803fe0
  802c5d:	68 1c 01 00 00       	push   $0x11c
  802c62:	68 37 3f 80 00       	push   $0x803f37
  802c67:	e8 05 d6 ff ff       	call   800271 <_panic>
  802c6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 10                	je     802c85 <alloc_block_NF+0x512>
  802c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c7d:	8b 52 04             	mov    0x4(%edx),%edx
  802c80:	89 50 04             	mov    %edx,0x4(%eax)
  802c83:	eb 0b                	jmp    802c90 <alloc_block_NF+0x51d>
  802c85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c88:	8b 40 04             	mov    0x4(%eax),%eax
  802c8b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	74 0f                	je     802ca9 <alloc_block_NF+0x536>
  802c9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9d:	8b 40 04             	mov    0x4(%eax),%eax
  802ca0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ca3:	8b 12                	mov    (%edx),%edx
  802ca5:	89 10                	mov    %edx,(%eax)
  802ca7:	eb 0a                	jmp    802cb3 <alloc_block_NF+0x540>
  802ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	a3 48 41 80 00       	mov    %eax,0x804148
  802cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc6:	a1 54 41 80 00       	mov    0x804154,%eax
  802ccb:	48                   	dec    %eax
  802ccc:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802cd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd4:	8b 40 08             	mov    0x8(%eax),%eax
  802cd7:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 50 08             	mov    0x8(%eax),%edx
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	01 c2                	add    %eax,%edx
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf3:	2b 45 08             	sub    0x8(%ebp),%eax
  802cf6:	89 c2                	mov    %eax,%edx
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d01:	eb 3b                	jmp    802d3e <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d03:	a1 40 41 80 00       	mov    0x804140,%eax
  802d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0f:	74 07                	je     802d18 <alloc_block_NF+0x5a5>
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	eb 05                	jmp    802d1d <alloc_block_NF+0x5aa>
  802d18:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1d:	a3 40 41 80 00       	mov    %eax,0x804140
  802d22:	a1 40 41 80 00       	mov    0x804140,%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	0f 85 2e fe ff ff    	jne    802b5d <alloc_block_NF+0x3ea>
  802d2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d33:	0f 85 24 fe ff ff    	jne    802b5d <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d3e:	c9                   	leave  
  802d3f:	c3                   	ret    

00802d40 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d40:	55                   	push   %ebp
  802d41:	89 e5                	mov    %esp,%ebp
  802d43:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d46:	a1 38 41 80 00       	mov    0x804138,%eax
  802d4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d4e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d53:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d56:	a1 38 41 80 00       	mov    0x804138,%eax
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	74 14                	je     802d73 <insert_sorted_with_merge_freeList+0x33>
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	8b 50 08             	mov    0x8(%eax),%edx
  802d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d68:	8b 40 08             	mov    0x8(%eax),%eax
  802d6b:	39 c2                	cmp    %eax,%edx
  802d6d:	0f 87 9b 01 00 00    	ja     802f0e <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d77:	75 17                	jne    802d90 <insert_sorted_with_merge_freeList+0x50>
  802d79:	83 ec 04             	sub    $0x4,%esp
  802d7c:	68 14 3f 80 00       	push   $0x803f14
  802d81:	68 38 01 00 00       	push   $0x138
  802d86:	68 37 3f 80 00       	push   $0x803f37
  802d8b:	e8 e1 d4 ff ff       	call   800271 <_panic>
  802d90:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	89 10                	mov    %edx,(%eax)
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	8b 00                	mov    (%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 0d                	je     802db1 <insert_sorted_with_merge_freeList+0x71>
  802da4:	a1 38 41 80 00       	mov    0x804138,%eax
  802da9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dac:	89 50 04             	mov    %edx,0x4(%eax)
  802daf:	eb 08                	jmp    802db9 <insert_sorted_with_merge_freeList+0x79>
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	a3 38 41 80 00       	mov    %eax,0x804138
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcb:	a1 44 41 80 00       	mov    0x804144,%eax
  802dd0:	40                   	inc    %eax
  802dd1:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802dd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dda:	0f 84 a8 06 00 00    	je     803488 <insert_sorted_with_merge_freeList+0x748>
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 50 08             	mov    0x8(%eax),%edx
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dec:	01 c2                	add    %eax,%edx
  802dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df1:	8b 40 08             	mov    0x8(%eax),%eax
  802df4:	39 c2                	cmp    %eax,%edx
  802df6:	0f 85 8c 06 00 00    	jne    803488 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 50 0c             	mov    0xc(%eax),%edx
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 40 0c             	mov    0xc(%eax),%eax
  802e08:	01 c2                	add    %eax,%edx
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e14:	75 17                	jne    802e2d <insert_sorted_with_merge_freeList+0xed>
  802e16:	83 ec 04             	sub    $0x4,%esp
  802e19:	68 e0 3f 80 00       	push   $0x803fe0
  802e1e:	68 3c 01 00 00       	push   $0x13c
  802e23:	68 37 3f 80 00       	push   $0x803f37
  802e28:	e8 44 d4 ff ff       	call   800271 <_panic>
  802e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e30:	8b 00                	mov    (%eax),%eax
  802e32:	85 c0                	test   %eax,%eax
  802e34:	74 10                	je     802e46 <insert_sorted_with_merge_freeList+0x106>
  802e36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e39:	8b 00                	mov    (%eax),%eax
  802e3b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e3e:	8b 52 04             	mov    0x4(%edx),%edx
  802e41:	89 50 04             	mov    %edx,0x4(%eax)
  802e44:	eb 0b                	jmp    802e51 <insert_sorted_with_merge_freeList+0x111>
  802e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e54:	8b 40 04             	mov    0x4(%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	74 0f                	je     802e6a <insert_sorted_with_merge_freeList+0x12a>
  802e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5e:	8b 40 04             	mov    0x4(%eax),%eax
  802e61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e64:	8b 12                	mov    (%edx),%edx
  802e66:	89 10                	mov    %edx,(%eax)
  802e68:	eb 0a                	jmp    802e74 <insert_sorted_with_merge_freeList+0x134>
  802e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	a3 38 41 80 00       	mov    %eax,0x804138
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e87:	a1 44 41 80 00       	mov    0x804144,%eax
  802e8c:	48                   	dec    %eax
  802e8d:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e95:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ea6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eaa:	75 17                	jne    802ec3 <insert_sorted_with_merge_freeList+0x183>
  802eac:	83 ec 04             	sub    $0x4,%esp
  802eaf:	68 14 3f 80 00       	push   $0x803f14
  802eb4:	68 3f 01 00 00       	push   $0x13f
  802eb9:	68 37 3f 80 00       	push   $0x803f37
  802ebe:	e8 ae d3 ff ff       	call   800271 <_panic>
  802ec3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	89 10                	mov    %edx,(%eax)
  802ece:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed1:	8b 00                	mov    (%eax),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	74 0d                	je     802ee4 <insert_sorted_with_merge_freeList+0x1a4>
  802ed7:	a1 48 41 80 00       	mov    0x804148,%eax
  802edc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802edf:	89 50 04             	mov    %edx,0x4(%eax)
  802ee2:	eb 08                	jmp    802eec <insert_sorted_with_merge_freeList+0x1ac>
  802ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eef:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efe:	a1 54 41 80 00       	mov    0x804154,%eax
  802f03:	40                   	inc    %eax
  802f04:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f09:	e9 7a 05 00 00       	jmp    803488 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 50 08             	mov    0x8(%eax),%edx
  802f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f17:	8b 40 08             	mov    0x8(%eax),%eax
  802f1a:	39 c2                	cmp    %eax,%edx
  802f1c:	0f 82 14 01 00 00    	jb     803036 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	8b 50 08             	mov    0x8(%eax),%edx
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2e:	01 c2                	add    %eax,%edx
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	8b 40 08             	mov    0x8(%eax),%eax
  802f36:	39 c2                	cmp    %eax,%edx
  802f38:	0f 85 90 00 00 00    	jne    802fce <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f41:	8b 50 0c             	mov    0xc(%eax),%edx
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4a:	01 c2                	add    %eax,%edx
  802f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4f:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6a:	75 17                	jne    802f83 <insert_sorted_with_merge_freeList+0x243>
  802f6c:	83 ec 04             	sub    $0x4,%esp
  802f6f:	68 14 3f 80 00       	push   $0x803f14
  802f74:	68 49 01 00 00       	push   $0x149
  802f79:	68 37 3f 80 00       	push   $0x803f37
  802f7e:	e8 ee d2 ff ff       	call   800271 <_panic>
  802f83:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	89 10                	mov    %edx,(%eax)
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 0d                	je     802fa4 <insert_sorted_with_merge_freeList+0x264>
  802f97:	a1 48 41 80 00       	mov    0x804148,%eax
  802f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 08                	jmp    802fac <insert_sorted_with_merge_freeList+0x26c>
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	a3 48 41 80 00       	mov    %eax,0x804148
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbe:	a1 54 41 80 00       	mov    0x804154,%eax
  802fc3:	40                   	inc    %eax
  802fc4:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fc9:	e9 bb 04 00 00       	jmp    803489 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802fce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd2:	75 17                	jne    802feb <insert_sorted_with_merge_freeList+0x2ab>
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	68 88 3f 80 00       	push   $0x803f88
  802fdc:	68 4c 01 00 00       	push   $0x14c
  802fe1:	68 37 3f 80 00       	push   $0x803f37
  802fe6:	e8 86 d2 ff ff       	call   800271 <_panic>
  802feb:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	89 50 04             	mov    %edx,0x4(%eax)
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 0c                	je     80300d <insert_sorted_with_merge_freeList+0x2cd>
  803001:	a1 3c 41 80 00       	mov    0x80413c,%eax
  803006:	8b 55 08             	mov    0x8(%ebp),%edx
  803009:	89 10                	mov    %edx,(%eax)
  80300b:	eb 08                	jmp    803015 <insert_sorted_with_merge_freeList+0x2d5>
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	a3 38 41 80 00       	mov    %eax,0x804138
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803026:	a1 44 41 80 00       	mov    0x804144,%eax
  80302b:	40                   	inc    %eax
  80302c:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803031:	e9 53 04 00 00       	jmp    803489 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803036:	a1 38 41 80 00       	mov    0x804138,%eax
  80303b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303e:	e9 15 04 00 00       	jmp    803458 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 50 08             	mov    0x8(%eax),%edx
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 40 08             	mov    0x8(%eax),%eax
  803057:	39 c2                	cmp    %eax,%edx
  803059:	0f 86 f1 03 00 00    	jbe    803450 <insert_sorted_with_merge_freeList+0x710>
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 50 08             	mov    0x8(%eax),%edx
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	8b 40 08             	mov    0x8(%eax),%eax
  80306b:	39 c2                	cmp    %eax,%edx
  80306d:	0f 83 dd 03 00 00    	jae    803450 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 50 08             	mov    0x8(%eax),%edx
  803079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307c:	8b 40 0c             	mov    0xc(%eax),%eax
  80307f:	01 c2                	add    %eax,%edx
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	8b 40 08             	mov    0x8(%eax),%eax
  803087:	39 c2                	cmp    %eax,%edx
  803089:	0f 85 b9 01 00 00    	jne    803248 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	8b 50 08             	mov    0x8(%eax),%edx
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 40 0c             	mov    0xc(%eax),%eax
  80309b:	01 c2                	add    %eax,%edx
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	8b 40 08             	mov    0x8(%eax),%eax
  8030a3:	39 c2                	cmp    %eax,%edx
  8030a5:	0f 85 0d 01 00 00    	jne    8031b8 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b7:	01 c2                	add    %eax,%edx
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8030bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030c3:	75 17                	jne    8030dc <insert_sorted_with_merge_freeList+0x39c>
  8030c5:	83 ec 04             	sub    $0x4,%esp
  8030c8:	68 e0 3f 80 00       	push   $0x803fe0
  8030cd:	68 5c 01 00 00       	push   $0x15c
  8030d2:	68 37 3f 80 00       	push   $0x803f37
  8030d7:	e8 95 d1 ff ff       	call   800271 <_panic>
  8030dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	85 c0                	test   %eax,%eax
  8030e3:	74 10                	je     8030f5 <insert_sorted_with_merge_freeList+0x3b5>
  8030e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e8:	8b 00                	mov    (%eax),%eax
  8030ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030ed:	8b 52 04             	mov    0x4(%edx),%edx
  8030f0:	89 50 04             	mov    %edx,0x4(%eax)
  8030f3:	eb 0b                	jmp    803100 <insert_sorted_with_merge_freeList+0x3c0>
  8030f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f8:	8b 40 04             	mov    0x4(%eax),%eax
  8030fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	8b 40 04             	mov    0x4(%eax),%eax
  803106:	85 c0                	test   %eax,%eax
  803108:	74 0f                	je     803119 <insert_sorted_with_merge_freeList+0x3d9>
  80310a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310d:	8b 40 04             	mov    0x4(%eax),%eax
  803110:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803113:	8b 12                	mov    (%edx),%edx
  803115:	89 10                	mov    %edx,(%eax)
  803117:	eb 0a                	jmp    803123 <insert_sorted_with_merge_freeList+0x3e3>
  803119:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311c:	8b 00                	mov    (%eax),%eax
  80311e:	a3 38 41 80 00       	mov    %eax,0x804138
  803123:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803136:	a1 44 41 80 00       	mov    0x804144,%eax
  80313b:	48                   	dec    %eax
  80313c:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  803141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803144:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80314b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803155:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803159:	75 17                	jne    803172 <insert_sorted_with_merge_freeList+0x432>
  80315b:	83 ec 04             	sub    $0x4,%esp
  80315e:	68 14 3f 80 00       	push   $0x803f14
  803163:	68 5f 01 00 00       	push   $0x15f
  803168:	68 37 3f 80 00       	push   $0x803f37
  80316d:	e8 ff d0 ff ff       	call   800271 <_panic>
  803172:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317b:	89 10                	mov    %edx,(%eax)
  80317d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803180:	8b 00                	mov    (%eax),%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	74 0d                	je     803193 <insert_sorted_with_merge_freeList+0x453>
  803186:	a1 48 41 80 00       	mov    0x804148,%eax
  80318b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318e:	89 50 04             	mov    %edx,0x4(%eax)
  803191:	eb 08                	jmp    80319b <insert_sorted_with_merge_freeList+0x45b>
  803193:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803196:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80319b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319e:	a3 48 41 80 00       	mov    %eax,0x804148
  8031a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ad:	a1 54 41 80 00       	mov    0x804154,%eax
  8031b2:	40                   	inc    %eax
  8031b3:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c4:	01 c2                	add    %eax,%edx
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8031e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e4:	75 17                	jne    8031fd <insert_sorted_with_merge_freeList+0x4bd>
  8031e6:	83 ec 04             	sub    $0x4,%esp
  8031e9:	68 14 3f 80 00       	push   $0x803f14
  8031ee:	68 64 01 00 00       	push   $0x164
  8031f3:	68 37 3f 80 00       	push   $0x803f37
  8031f8:	e8 74 d0 ff ff       	call   800271 <_panic>
  8031fd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	89 10                	mov    %edx,(%eax)
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	8b 00                	mov    (%eax),%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	74 0d                	je     80321e <insert_sorted_with_merge_freeList+0x4de>
  803211:	a1 48 41 80 00       	mov    0x804148,%eax
  803216:	8b 55 08             	mov    0x8(%ebp),%edx
  803219:	89 50 04             	mov    %edx,0x4(%eax)
  80321c:	eb 08                	jmp    803226 <insert_sorted_with_merge_freeList+0x4e6>
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	a3 48 41 80 00       	mov    %eax,0x804148
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803238:	a1 54 41 80 00       	mov    0x804154,%eax
  80323d:	40                   	inc    %eax
  80323e:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803243:	e9 41 02 00 00       	jmp    803489 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	8b 50 08             	mov    0x8(%eax),%edx
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	8b 40 0c             	mov    0xc(%eax),%eax
  803254:	01 c2                	add    %eax,%edx
  803256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803259:	8b 40 08             	mov    0x8(%eax),%eax
  80325c:	39 c2                	cmp    %eax,%edx
  80325e:	0f 85 7c 01 00 00    	jne    8033e0 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803264:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803268:	74 06                	je     803270 <insert_sorted_with_merge_freeList+0x530>
  80326a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326e:	75 17                	jne    803287 <insert_sorted_with_merge_freeList+0x547>
  803270:	83 ec 04             	sub    $0x4,%esp
  803273:	68 50 3f 80 00       	push   $0x803f50
  803278:	68 69 01 00 00       	push   $0x169
  80327d:	68 37 3f 80 00       	push   $0x803f37
  803282:	e8 ea cf ff ff       	call   800271 <_panic>
  803287:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328a:	8b 50 04             	mov    0x4(%eax),%edx
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	89 50 04             	mov    %edx,0x4(%eax)
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803299:	89 10                	mov    %edx,(%eax)
  80329b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329e:	8b 40 04             	mov    0x4(%eax),%eax
  8032a1:	85 c0                	test   %eax,%eax
  8032a3:	74 0d                	je     8032b2 <insert_sorted_with_merge_freeList+0x572>
  8032a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a8:	8b 40 04             	mov    0x4(%eax),%eax
  8032ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ae:	89 10                	mov    %edx,(%eax)
  8032b0:	eb 08                	jmp    8032ba <insert_sorted_with_merge_freeList+0x57a>
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	a3 38 41 80 00       	mov    %eax,0x804138
  8032ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c0:	89 50 04             	mov    %edx,0x4(%eax)
  8032c3:	a1 44 41 80 00       	mov    0x804144,%eax
  8032c8:	40                   	inc    %eax
  8032c9:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032da:	01 c2                	add    %eax,%edx
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8032e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032e6:	75 17                	jne    8032ff <insert_sorted_with_merge_freeList+0x5bf>
  8032e8:	83 ec 04             	sub    $0x4,%esp
  8032eb:	68 e0 3f 80 00       	push   $0x803fe0
  8032f0:	68 6b 01 00 00       	push   $0x16b
  8032f5:	68 37 3f 80 00       	push   $0x803f37
  8032fa:	e8 72 cf ff ff       	call   800271 <_panic>
  8032ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803302:	8b 00                	mov    (%eax),%eax
  803304:	85 c0                	test   %eax,%eax
  803306:	74 10                	je     803318 <insert_sorted_with_merge_freeList+0x5d8>
  803308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330b:	8b 00                	mov    (%eax),%eax
  80330d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803310:	8b 52 04             	mov    0x4(%edx),%edx
  803313:	89 50 04             	mov    %edx,0x4(%eax)
  803316:	eb 0b                	jmp    803323 <insert_sorted_with_merge_freeList+0x5e3>
  803318:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331b:	8b 40 04             	mov    0x4(%eax),%eax
  80331e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803323:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803326:	8b 40 04             	mov    0x4(%eax),%eax
  803329:	85 c0                	test   %eax,%eax
  80332b:	74 0f                	je     80333c <insert_sorted_with_merge_freeList+0x5fc>
  80332d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803330:	8b 40 04             	mov    0x4(%eax),%eax
  803333:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803336:	8b 12                	mov    (%edx),%edx
  803338:	89 10                	mov    %edx,(%eax)
  80333a:	eb 0a                	jmp    803346 <insert_sorted_with_merge_freeList+0x606>
  80333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333f:	8b 00                	mov    (%eax),%eax
  803341:	a3 38 41 80 00       	mov    %eax,0x804138
  803346:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803359:	a1 44 41 80 00       	mov    0x804144,%eax
  80335e:	48                   	dec    %eax
  80335f:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  803364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803367:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80336e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803371:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803378:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80337c:	75 17                	jne    803395 <insert_sorted_with_merge_freeList+0x655>
  80337e:	83 ec 04             	sub    $0x4,%esp
  803381:	68 14 3f 80 00       	push   $0x803f14
  803386:	68 6e 01 00 00       	push   $0x16e
  80338b:	68 37 3f 80 00       	push   $0x803f37
  803390:	e8 dc ce ff ff       	call   800271 <_panic>
  803395:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80339b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80339e:	89 10                	mov    %edx,(%eax)
  8033a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	85 c0                	test   %eax,%eax
  8033a7:	74 0d                	je     8033b6 <insert_sorted_with_merge_freeList+0x676>
  8033a9:	a1 48 41 80 00       	mov    0x804148,%eax
  8033ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033b1:	89 50 04             	mov    %edx,0x4(%eax)
  8033b4:	eb 08                	jmp    8033be <insert_sorted_with_merge_freeList+0x67e>
  8033b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8033be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c1:	a3 48 41 80 00       	mov    %eax,0x804148
  8033c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033d0:	a1 54 41 80 00       	mov    0x804154,%eax
  8033d5:	40                   	inc    %eax
  8033d6:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8033db:	e9 a9 00 00 00       	jmp    803489 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8033e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e4:	74 06                	je     8033ec <insert_sorted_with_merge_freeList+0x6ac>
  8033e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ea:	75 17                	jne    803403 <insert_sorted_with_merge_freeList+0x6c3>
  8033ec:	83 ec 04             	sub    $0x4,%esp
  8033ef:	68 ac 3f 80 00       	push   $0x803fac
  8033f4:	68 73 01 00 00       	push   $0x173
  8033f9:	68 37 3f 80 00       	push   $0x803f37
  8033fe:	e8 6e ce ff ff       	call   800271 <_panic>
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 10                	mov    (%eax),%edx
  803408:	8b 45 08             	mov    0x8(%ebp),%eax
  80340b:	89 10                	mov    %edx,(%eax)
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	8b 00                	mov    (%eax),%eax
  803412:	85 c0                	test   %eax,%eax
  803414:	74 0b                	je     803421 <insert_sorted_with_merge_freeList+0x6e1>
  803416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	8b 55 08             	mov    0x8(%ebp),%edx
  80341e:	89 50 04             	mov    %edx,0x4(%eax)
  803421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803424:	8b 55 08             	mov    0x8(%ebp),%edx
  803427:	89 10                	mov    %edx,(%eax)
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342f:	89 50 04             	mov    %edx,0x4(%eax)
  803432:	8b 45 08             	mov    0x8(%ebp),%eax
  803435:	8b 00                	mov    (%eax),%eax
  803437:	85 c0                	test   %eax,%eax
  803439:	75 08                	jne    803443 <insert_sorted_with_merge_freeList+0x703>
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803443:	a1 44 41 80 00       	mov    0x804144,%eax
  803448:	40                   	inc    %eax
  803449:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  80344e:	eb 39                	jmp    803489 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803450:	a1 40 41 80 00       	mov    0x804140,%eax
  803455:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80345c:	74 07                	je     803465 <insert_sorted_with_merge_freeList+0x725>
  80345e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	eb 05                	jmp    80346a <insert_sorted_with_merge_freeList+0x72a>
  803465:	b8 00 00 00 00       	mov    $0x0,%eax
  80346a:	a3 40 41 80 00       	mov    %eax,0x804140
  80346f:	a1 40 41 80 00       	mov    0x804140,%eax
  803474:	85 c0                	test   %eax,%eax
  803476:	0f 85 c7 fb ff ff    	jne    803043 <insert_sorted_with_merge_freeList+0x303>
  80347c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803480:	0f 85 bd fb ff ff    	jne    803043 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803486:	eb 01                	jmp    803489 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803488:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803489:	90                   	nop
  80348a:	c9                   	leave  
  80348b:	c3                   	ret    

0080348c <__udivdi3>:
  80348c:	55                   	push   %ebp
  80348d:	57                   	push   %edi
  80348e:	56                   	push   %esi
  80348f:	53                   	push   %ebx
  803490:	83 ec 1c             	sub    $0x1c,%esp
  803493:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803497:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80349b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80349f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034a3:	89 ca                	mov    %ecx,%edx
  8034a5:	89 f8                	mov    %edi,%eax
  8034a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034ab:	85 f6                	test   %esi,%esi
  8034ad:	75 2d                	jne    8034dc <__udivdi3+0x50>
  8034af:	39 cf                	cmp    %ecx,%edi
  8034b1:	77 65                	ja     803518 <__udivdi3+0x8c>
  8034b3:	89 fd                	mov    %edi,%ebp
  8034b5:	85 ff                	test   %edi,%edi
  8034b7:	75 0b                	jne    8034c4 <__udivdi3+0x38>
  8034b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8034be:	31 d2                	xor    %edx,%edx
  8034c0:	f7 f7                	div    %edi
  8034c2:	89 c5                	mov    %eax,%ebp
  8034c4:	31 d2                	xor    %edx,%edx
  8034c6:	89 c8                	mov    %ecx,%eax
  8034c8:	f7 f5                	div    %ebp
  8034ca:	89 c1                	mov    %eax,%ecx
  8034cc:	89 d8                	mov    %ebx,%eax
  8034ce:	f7 f5                	div    %ebp
  8034d0:	89 cf                	mov    %ecx,%edi
  8034d2:	89 fa                	mov    %edi,%edx
  8034d4:	83 c4 1c             	add    $0x1c,%esp
  8034d7:	5b                   	pop    %ebx
  8034d8:	5e                   	pop    %esi
  8034d9:	5f                   	pop    %edi
  8034da:	5d                   	pop    %ebp
  8034db:	c3                   	ret    
  8034dc:	39 ce                	cmp    %ecx,%esi
  8034de:	77 28                	ja     803508 <__udivdi3+0x7c>
  8034e0:	0f bd fe             	bsr    %esi,%edi
  8034e3:	83 f7 1f             	xor    $0x1f,%edi
  8034e6:	75 40                	jne    803528 <__udivdi3+0x9c>
  8034e8:	39 ce                	cmp    %ecx,%esi
  8034ea:	72 0a                	jb     8034f6 <__udivdi3+0x6a>
  8034ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034f0:	0f 87 9e 00 00 00    	ja     803594 <__udivdi3+0x108>
  8034f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fb:	89 fa                	mov    %edi,%edx
  8034fd:	83 c4 1c             	add    $0x1c,%esp
  803500:	5b                   	pop    %ebx
  803501:	5e                   	pop    %esi
  803502:	5f                   	pop    %edi
  803503:	5d                   	pop    %ebp
  803504:	c3                   	ret    
  803505:	8d 76 00             	lea    0x0(%esi),%esi
  803508:	31 ff                	xor    %edi,%edi
  80350a:	31 c0                	xor    %eax,%eax
  80350c:	89 fa                	mov    %edi,%edx
  80350e:	83 c4 1c             	add    $0x1c,%esp
  803511:	5b                   	pop    %ebx
  803512:	5e                   	pop    %esi
  803513:	5f                   	pop    %edi
  803514:	5d                   	pop    %ebp
  803515:	c3                   	ret    
  803516:	66 90                	xchg   %ax,%ax
  803518:	89 d8                	mov    %ebx,%eax
  80351a:	f7 f7                	div    %edi
  80351c:	31 ff                	xor    %edi,%edi
  80351e:	89 fa                	mov    %edi,%edx
  803520:	83 c4 1c             	add    $0x1c,%esp
  803523:	5b                   	pop    %ebx
  803524:	5e                   	pop    %esi
  803525:	5f                   	pop    %edi
  803526:	5d                   	pop    %ebp
  803527:	c3                   	ret    
  803528:	bd 20 00 00 00       	mov    $0x20,%ebp
  80352d:	89 eb                	mov    %ebp,%ebx
  80352f:	29 fb                	sub    %edi,%ebx
  803531:	89 f9                	mov    %edi,%ecx
  803533:	d3 e6                	shl    %cl,%esi
  803535:	89 c5                	mov    %eax,%ebp
  803537:	88 d9                	mov    %bl,%cl
  803539:	d3 ed                	shr    %cl,%ebp
  80353b:	89 e9                	mov    %ebp,%ecx
  80353d:	09 f1                	or     %esi,%ecx
  80353f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803543:	89 f9                	mov    %edi,%ecx
  803545:	d3 e0                	shl    %cl,%eax
  803547:	89 c5                	mov    %eax,%ebp
  803549:	89 d6                	mov    %edx,%esi
  80354b:	88 d9                	mov    %bl,%cl
  80354d:	d3 ee                	shr    %cl,%esi
  80354f:	89 f9                	mov    %edi,%ecx
  803551:	d3 e2                	shl    %cl,%edx
  803553:	8b 44 24 08          	mov    0x8(%esp),%eax
  803557:	88 d9                	mov    %bl,%cl
  803559:	d3 e8                	shr    %cl,%eax
  80355b:	09 c2                	or     %eax,%edx
  80355d:	89 d0                	mov    %edx,%eax
  80355f:	89 f2                	mov    %esi,%edx
  803561:	f7 74 24 0c          	divl   0xc(%esp)
  803565:	89 d6                	mov    %edx,%esi
  803567:	89 c3                	mov    %eax,%ebx
  803569:	f7 e5                	mul    %ebp
  80356b:	39 d6                	cmp    %edx,%esi
  80356d:	72 19                	jb     803588 <__udivdi3+0xfc>
  80356f:	74 0b                	je     80357c <__udivdi3+0xf0>
  803571:	89 d8                	mov    %ebx,%eax
  803573:	31 ff                	xor    %edi,%edi
  803575:	e9 58 ff ff ff       	jmp    8034d2 <__udivdi3+0x46>
  80357a:	66 90                	xchg   %ax,%ax
  80357c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803580:	89 f9                	mov    %edi,%ecx
  803582:	d3 e2                	shl    %cl,%edx
  803584:	39 c2                	cmp    %eax,%edx
  803586:	73 e9                	jae    803571 <__udivdi3+0xe5>
  803588:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80358b:	31 ff                	xor    %edi,%edi
  80358d:	e9 40 ff ff ff       	jmp    8034d2 <__udivdi3+0x46>
  803592:	66 90                	xchg   %ax,%ax
  803594:	31 c0                	xor    %eax,%eax
  803596:	e9 37 ff ff ff       	jmp    8034d2 <__udivdi3+0x46>
  80359b:	90                   	nop

0080359c <__umoddi3>:
  80359c:	55                   	push   %ebp
  80359d:	57                   	push   %edi
  80359e:	56                   	push   %esi
  80359f:	53                   	push   %ebx
  8035a0:	83 ec 1c             	sub    $0x1c,%esp
  8035a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035bb:	89 f3                	mov    %esi,%ebx
  8035bd:	89 fa                	mov    %edi,%edx
  8035bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035c3:	89 34 24             	mov    %esi,(%esp)
  8035c6:	85 c0                	test   %eax,%eax
  8035c8:	75 1a                	jne    8035e4 <__umoddi3+0x48>
  8035ca:	39 f7                	cmp    %esi,%edi
  8035cc:	0f 86 a2 00 00 00    	jbe    803674 <__umoddi3+0xd8>
  8035d2:	89 c8                	mov    %ecx,%eax
  8035d4:	89 f2                	mov    %esi,%edx
  8035d6:	f7 f7                	div    %edi
  8035d8:	89 d0                	mov    %edx,%eax
  8035da:	31 d2                	xor    %edx,%edx
  8035dc:	83 c4 1c             	add    $0x1c,%esp
  8035df:	5b                   	pop    %ebx
  8035e0:	5e                   	pop    %esi
  8035e1:	5f                   	pop    %edi
  8035e2:	5d                   	pop    %ebp
  8035e3:	c3                   	ret    
  8035e4:	39 f0                	cmp    %esi,%eax
  8035e6:	0f 87 ac 00 00 00    	ja     803698 <__umoddi3+0xfc>
  8035ec:	0f bd e8             	bsr    %eax,%ebp
  8035ef:	83 f5 1f             	xor    $0x1f,%ebp
  8035f2:	0f 84 ac 00 00 00    	je     8036a4 <__umoddi3+0x108>
  8035f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8035fd:	29 ef                	sub    %ebp,%edi
  8035ff:	89 fe                	mov    %edi,%esi
  803601:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803605:	89 e9                	mov    %ebp,%ecx
  803607:	d3 e0                	shl    %cl,%eax
  803609:	89 d7                	mov    %edx,%edi
  80360b:	89 f1                	mov    %esi,%ecx
  80360d:	d3 ef                	shr    %cl,%edi
  80360f:	09 c7                	or     %eax,%edi
  803611:	89 e9                	mov    %ebp,%ecx
  803613:	d3 e2                	shl    %cl,%edx
  803615:	89 14 24             	mov    %edx,(%esp)
  803618:	89 d8                	mov    %ebx,%eax
  80361a:	d3 e0                	shl    %cl,%eax
  80361c:	89 c2                	mov    %eax,%edx
  80361e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803622:	d3 e0                	shl    %cl,%eax
  803624:	89 44 24 04          	mov    %eax,0x4(%esp)
  803628:	8b 44 24 08          	mov    0x8(%esp),%eax
  80362c:	89 f1                	mov    %esi,%ecx
  80362e:	d3 e8                	shr    %cl,%eax
  803630:	09 d0                	or     %edx,%eax
  803632:	d3 eb                	shr    %cl,%ebx
  803634:	89 da                	mov    %ebx,%edx
  803636:	f7 f7                	div    %edi
  803638:	89 d3                	mov    %edx,%ebx
  80363a:	f7 24 24             	mull   (%esp)
  80363d:	89 c6                	mov    %eax,%esi
  80363f:	89 d1                	mov    %edx,%ecx
  803641:	39 d3                	cmp    %edx,%ebx
  803643:	0f 82 87 00 00 00    	jb     8036d0 <__umoddi3+0x134>
  803649:	0f 84 91 00 00 00    	je     8036e0 <__umoddi3+0x144>
  80364f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803653:	29 f2                	sub    %esi,%edx
  803655:	19 cb                	sbb    %ecx,%ebx
  803657:	89 d8                	mov    %ebx,%eax
  803659:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80365d:	d3 e0                	shl    %cl,%eax
  80365f:	89 e9                	mov    %ebp,%ecx
  803661:	d3 ea                	shr    %cl,%edx
  803663:	09 d0                	or     %edx,%eax
  803665:	89 e9                	mov    %ebp,%ecx
  803667:	d3 eb                	shr    %cl,%ebx
  803669:	89 da                	mov    %ebx,%edx
  80366b:	83 c4 1c             	add    $0x1c,%esp
  80366e:	5b                   	pop    %ebx
  80366f:	5e                   	pop    %esi
  803670:	5f                   	pop    %edi
  803671:	5d                   	pop    %ebp
  803672:	c3                   	ret    
  803673:	90                   	nop
  803674:	89 fd                	mov    %edi,%ebp
  803676:	85 ff                	test   %edi,%edi
  803678:	75 0b                	jne    803685 <__umoddi3+0xe9>
  80367a:	b8 01 00 00 00       	mov    $0x1,%eax
  80367f:	31 d2                	xor    %edx,%edx
  803681:	f7 f7                	div    %edi
  803683:	89 c5                	mov    %eax,%ebp
  803685:	89 f0                	mov    %esi,%eax
  803687:	31 d2                	xor    %edx,%edx
  803689:	f7 f5                	div    %ebp
  80368b:	89 c8                	mov    %ecx,%eax
  80368d:	f7 f5                	div    %ebp
  80368f:	89 d0                	mov    %edx,%eax
  803691:	e9 44 ff ff ff       	jmp    8035da <__umoddi3+0x3e>
  803696:	66 90                	xchg   %ax,%ax
  803698:	89 c8                	mov    %ecx,%eax
  80369a:	89 f2                	mov    %esi,%edx
  80369c:	83 c4 1c             	add    $0x1c,%esp
  80369f:	5b                   	pop    %ebx
  8036a0:	5e                   	pop    %esi
  8036a1:	5f                   	pop    %edi
  8036a2:	5d                   	pop    %ebp
  8036a3:	c3                   	ret    
  8036a4:	3b 04 24             	cmp    (%esp),%eax
  8036a7:	72 06                	jb     8036af <__umoddi3+0x113>
  8036a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036ad:	77 0f                	ja     8036be <__umoddi3+0x122>
  8036af:	89 f2                	mov    %esi,%edx
  8036b1:	29 f9                	sub    %edi,%ecx
  8036b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036b7:	89 14 24             	mov    %edx,(%esp)
  8036ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036c2:	8b 14 24             	mov    (%esp),%edx
  8036c5:	83 c4 1c             	add    $0x1c,%esp
  8036c8:	5b                   	pop    %ebx
  8036c9:	5e                   	pop    %esi
  8036ca:	5f                   	pop    %edi
  8036cb:	5d                   	pop    %ebp
  8036cc:	c3                   	ret    
  8036cd:	8d 76 00             	lea    0x0(%esi),%esi
  8036d0:	2b 04 24             	sub    (%esp),%eax
  8036d3:	19 fa                	sbb    %edi,%edx
  8036d5:	89 d1                	mov    %edx,%ecx
  8036d7:	89 c6                	mov    %eax,%esi
  8036d9:	e9 71 ff ff ff       	jmp    80364f <__umoddi3+0xb3>
  8036de:	66 90                	xchg   %ax,%ax
  8036e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036e4:	72 ea                	jb     8036d0 <__umoddi3+0x134>
  8036e6:	89 d9                	mov    %ebx,%ecx
  8036e8:	e9 62 ff ff ff       	jmp    80364f <__umoddi3+0xb3>
