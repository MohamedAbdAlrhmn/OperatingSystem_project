
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 80 35 80 00       	push   $0x803580
  80004a:	e8 b7 14 00 00       	call   801506 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 e3 16 00 00       	call   801746 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 7b 17 00 00       	call   8017e6 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 90 35 80 00       	push   $0x803590
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 c3 35 80 00       	push   $0x8035c3
  800099:	e8 1a 19 00 00       	call   8019b8 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 27 19 00 00       	call   8019d6 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 84 16 00 00       	call   801746 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 cc 35 80 00       	push   $0x8035cc
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 14 19 00 00       	call   8019f2 <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 60 16 00 00       	call   801746 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 f8 16 00 00       	call   8017e6 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 00 36 80 00       	push   $0x803600
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 50 36 80 00       	push   $0x803650
  800114:	6a 1e                	push   $0x1e
  800116:	68 86 36 80 00       	push   $0x803686
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 9c 36 80 00       	push   $0x80369c
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 fc 36 80 00       	push   $0x8036fc
  80013b:	e8 f6 03 00 00       	call   800536 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 d5 18 00 00       	call   801a26 <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 77 16 00 00       	call   801833 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 60 37 80 00       	push   $0x803760
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 88 37 80 00       	push   $0x803788
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 40 80 00       	mov    0x804020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 b0 37 80 00       	push   $0x8037b0
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 08 38 80 00       	push   $0x803808
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 60 37 80 00       	push   $0x803760
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 f7 15 00 00       	call   80184d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 84 17 00 00       	call   8019f2 <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 d9 17 00 00       	call   801a58 <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 1c 38 80 00       	push   $0x80381c
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 21 38 80 00       	push   $0x803821
  8002c1:	e8 70 02 00 00       	call   800536 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 f3 01 00 00       	call   8004cb <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 3d 38 80 00       	push   $0x80383d
  8002e5:	e8 e1 01 00 00       	call   8004cb <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 40 38 80 00       	push   $0x803840
  800311:	6a 26                	push   $0x26
  800313:	68 8c 38 80 00       	push   $0x80388c
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 c2 00 00 00       	jmp    8003f2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 a2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 69                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
  800362:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 46                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	89 d0                	mov    %edx,%eax
  80038d:	01 c0                	add    %eax,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 03             	shl    $0x3,%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	75 09                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c1:	eb 12                	jmp    8003d5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	ff 45 e8             	incl   -0x18(%ebp)
  8003c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cb:	8b 50 74             	mov    0x74(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 88                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 98 38 80 00       	push   $0x803898
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 8c 38 80 00       	push   $0x80388c
  8003ea:	e8 93 fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 32 ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
  800439:	8b 50 74             	mov    0x74(%eax),%edx
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	77 cb                	ja     80040e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800449:	74 14                	je     80045f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	68 ec 38 80 00       	push   $0x8038ec
  800453:	6a 44                	push   $0x44
  800455:	68 8c 38 80 00       	push   $0x80388c
  80045a:	e8 23 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 48 01             	lea    0x1(%eax),%ecx
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	89 0a                	mov    %ecx,(%edx)
  800475:	8b 55 08             	mov    0x8(%ebp),%edx
  800478:	88 d1                	mov    %dl,%cl
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048b:	75 2c                	jne    8004b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048d:	a0 24 40 80 00       	mov    0x804024,%al
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	8b 55 0c             	mov    0xc(%ebp),%edx
  800498:	8b 12                	mov    (%edx),%edx
  80049a:	89 d1                	mov    %edx,%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	83 c2 08             	add    $0x8,%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	51                   	push   %ecx
  8004a7:	52                   	push   %edx
  8004a8:	e8 d8 11 00 00       	call   801685 <sys_cputs>
  8004ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	8b 40 04             	mov    0x4(%eax),%eax
  8004bf:	8d 50 01             	lea    0x1(%eax),%edx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	50                   	push   %eax
  8004f5:	68 62 04 80 00       	push   $0x800462
  8004fa:	e8 11 02 00 00       	call   800710 <vprintfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800502:	a0 24 40 80 00       	mov    0x804024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 61 11 00 00       	call   801685 <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cprintf>:

int cprintf(const char *fmt, ...) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800543:	8d 45 0c             	lea    0xc(%ebp),%eax
  800546:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 f4             	pushl  -0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	e8 73 ff ff ff       	call   8004cb <vcprintf>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800569:	e8 c5 12 00 00       	call   801833 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 48 ff ff ff       	call   8004cb <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800589:	e8 bf 12 00 00       	call   80184d <sys_enable_interrupt>
	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	53                   	push   %ebx
  800597:	83 ec 14             	sub    $0x14,%esp
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	77 55                	ja     800608 <printnum+0x75>
  8005b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b6:	72 05                	jb     8005bd <printnum+0x2a>
  8005b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bb:	77 4b                	ja     800608 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d3:	e8 30 2d 00 00       	call   803308 <__udivdi3>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	ff 75 20             	pushl  0x20(%ebp)
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 18             	pushl  0x18(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 a1 ff ff ff       	call   800593 <printnum>
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	eb 1a                	jmp    800611 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	ff 4d 1c             	decl   0x1c(%ebp)
  80060b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060f:	7f e6                	jg     8005f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800614:	bb 00 00 00 00       	mov    $0x0,%ebx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	53                   	push   %ebx
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	e8 f0 2d 00 00       	call   803418 <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 54 3b 80 00       	add    $0x803b54,%eax
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
}
  800644:	90                   	nop
  800645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800651:	7e 1c                	jle    80066f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 08             	sub    $0x8,%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	eb 40                	jmp    8006af <getuint+0x65>
	else if (lflag)
  80066f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800673:	74 1e                	je     800693 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	eb 1c                	jmp    8006af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 04             	sub    $0x4,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getint+0x25>
		return va_arg(*ap, long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 38                	jmp    80070e <getint+0x5d>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1a                	je     8006f6 <getint+0x45>
		return va_arg(*ap, long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
  8006f4:	eb 18                	jmp    80070e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	56                   	push   %esi
  800714:	53                   	push   %ebx
  800715:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800718:	eb 17                	jmp    800731 <vprintfmt+0x21>
			if (ch == '\0')
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	0f 84 af 03 00 00    	je     800ad1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	53                   	push   %ebx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	89 55 10             	mov    %edx,0x10(%ebp)
  80073a:	8a 00                	mov    (%eax),%al
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d6                	jne    80071a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800756:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 2b 03 00 00    	ja     800aa9 <vprintfmt+0x399>
  80077e:	8b 04 85 78 3b 80 00 	mov    0x803b78(,%eax,4),%eax
  800785:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800787:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078b:	eb d7                	jmp    800764 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800791:	eb d1                	jmp    800764 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	89 d0                	mov    %edx,%eax
  80079f:	c1 e0 02             	shl    $0x2,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d8                	add    %ebx,%eax
  8007a8:	83 e8 30             	sub    $0x30,%eax
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b9:	7e 3e                	jle    8007f9 <vprintfmt+0xe9>
  8007bb:	83 fb 39             	cmp    $0x39,%ebx
  8007be:	7f 39                	jg     8007f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c3:	eb d5                	jmp    80079a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d9:	eb 1f                	jmp    8007fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	79 83                	jns    800764 <vprintfmt+0x54>
				width = 0;
  8007e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e8:	e9 77 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f4:	e9 6b ff ff ff       	jmp    800764 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	0f 89 60 ff ff ff    	jns    800764 <vprintfmt+0x54>
				width = precision, precision = -1;
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800811:	e9 4e ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800816:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800819:	e9 46 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 c0 04             	add    $0x4,%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	e9 89 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800854:	85 db                	test   %ebx,%ebx
  800856:	79 02                	jns    80085a <vprintfmt+0x14a>
				err = -err;
  800858:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085a:	83 fb 64             	cmp    $0x64,%ebx
  80085d:	7f 0b                	jg     80086a <vprintfmt+0x15a>
  80085f:	8b 34 9d c0 39 80 00 	mov    0x8039c0(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 65 3b 80 00       	push   $0x803b65
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 5e 02 00 00       	call   800ad9 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 49 02 00 00       	jmp    800acc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	56                   	push   %esi
  800884:	68 6e 3b 80 00       	push   $0x803b6e
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 45 02 00 00       	call   800ad9 <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 30 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 30                	mov    (%eax),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 05                	jne    8008b6 <vprintfmt+0x1a6>
				p = "(null)";
  8008b1:	be 71 3b 80 00       	mov    $0x803b71,%esi
			if (width > 0 && padc != '-')
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7e 6d                	jle    800929 <vprintfmt+0x219>
  8008bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c0:	74 67                	je     800929 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	50                   	push   %eax
  8008c9:	56                   	push   %esi
  8008ca:	e8 0c 03 00 00       	call   800bdb <strnlen>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e4                	jg     8008d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f3:	eb 34                	jmp    800929 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f9:	74 1c                	je     800917 <vprintfmt+0x207>
  8008fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fe:	7e 05                	jle    800905 <vprintfmt+0x1f5>
  800900:	83 fb 7e             	cmp    $0x7e,%ebx
  800903:	7e 12                	jle    800917 <vprintfmt+0x207>
					putch('?', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 3f                	push   $0x3f
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb 0f                	jmp    800926 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	89 f0                	mov    %esi,%eax
  80092b:	8d 70 01             	lea    0x1(%eax),%esi
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 24                	je     80095b <vprintfmt+0x24b>
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	78 b8                	js     8008f5 <vprintfmt+0x1e5>
  80093d:	ff 4d e0             	decl   -0x20(%ebp)
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	79 af                	jns    8008f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	eb 13                	jmp    80095b <vprintfmt+0x24b>
				putch(' ', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 20                	push   $0x20
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7f e7                	jg     800948 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800961:	e9 66 01 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 e8             	pushl  -0x18(%ebp)
  80096c:	8d 45 14             	lea    0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 3c fd ff ff       	call   8006b1 <getint>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	79 23                	jns    8009ab <vprintfmt+0x29b>
				putch('-', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 2d                	push   $0x2d
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 bc 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 84 fc ff ff       	call   80064a <getuint>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 98 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 58                	push   $0x58
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 58                	push   $0x58
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 58                	push   $0x58
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			break;
  800a0b:	e9 bc 00 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 30                	push   $0x30
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 78                	push   $0x78
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 e7 fb ff ff       	call   80064a <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	52                   	push   %edx
  800a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a81:	50                   	push   %eax
  800a82:	ff 75 f4             	pushl  -0xc(%ebp)
  800a85:	ff 75 f0             	pushl  -0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 00 fb ff ff       	call   800593 <printnum>
  800a93:	83 c4 20             	add    $0x20,%esp
			break;
  800a96:	eb 34                	jmp    800acc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3b1>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 47 fc ff ff       	jmp    800718 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 16 fc ff ff       	call   800710 <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 92 fb ff ff       	call   800710 <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d2:	f7 e9                	imul   %ecx
  8010d4:	c1 fa 02             	sar    $0x2,%edx
  8010d7:	89 c8                	mov    %ecx,%eax
  8010d9:	c1 f8 1f             	sar    $0x1f,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e0 02             	shl    $0x2,%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	01 c0                	add    %eax,%eax
  8010e7:	29 c1                	sub    %eax,%ecx
  8010e9:	89 ca                	mov    %ecx,%edx
  8010eb:	85 d2                	test   %edx,%edx
  8010ed:	75 9c                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xe2>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 54 fa ff ff       	call   800bb8 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 46 fa ff ff       	call   800bb8 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 13 fb ff ff       	call   800d4a <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 b5 fa ff ff       	call   800d4a <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 d0 3c 80 00       	push   $0x803cd0
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012eb:	00 00 00 
	}
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8012f7:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fe:	00 00 00 
  801301:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801308:	00 00 00 
  80130b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801312:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801315:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80131c:	00 00 00 
  80131f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801326:	00 00 00 
  801329:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801330:	00 00 00 
	uint32 arr_size = 0;
  801333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  80133a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801349:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134e:	a3 50 40 80 00       	mov    %eax,0x804050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  801353:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80135a:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  80135d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801364:	a1 20 41 80 00       	mov    0x804120,%eax
  801369:	c1 e0 04             	shl    $0x4,%eax
  80136c:	89 c2                	mov    %eax,%edx
  80136e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801371:	01 d0                	add    %edx,%eax
  801373:	48                   	dec    %eax
  801374:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80137a:	ba 00 00 00 00       	mov    $0x0,%edx
  80137f:	f7 75 ec             	divl   -0x14(%ebp)
  801382:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801385:	29 d0                	sub    %edx,%eax
  801387:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  80138a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801399:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139e:	83 ec 04             	sub    $0x4,%esp
  8013a1:	6a 06                	push   $0x6
  8013a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a6:	50                   	push   %eax
  8013a7:	e8 1d 04 00 00       	call   8017c9 <sys_allocate_chunk>
  8013ac:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013af:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b4:	83 ec 0c             	sub    $0xc,%esp
  8013b7:	50                   	push   %eax
  8013b8:	e8 92 0a 00 00       	call   801e4f <initialize_MemBlocksList>
  8013bd:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8013c0:	a1 48 41 80 00       	mov    0x804148,%eax
  8013c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8013c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cb:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8013d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8013dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013e0:	75 14                	jne    8013f6 <initialize_dyn_block_system+0x105>
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	68 f5 3c 80 00       	push   $0x803cf5
  8013ea:	6a 33                	push   $0x33
  8013ec:	68 13 3d 80 00       	push   $0x803d13
  8013f1:	e8 8c ee ff ff       	call   800282 <_panic>
  8013f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	74 10                	je     80140f <initialize_dyn_block_system+0x11e>
  8013ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801407:	8b 52 04             	mov    0x4(%edx),%edx
  80140a:	89 50 04             	mov    %edx,0x4(%eax)
  80140d:	eb 0b                	jmp    80141a <initialize_dyn_block_system+0x129>
  80140f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801412:	8b 40 04             	mov    0x4(%eax),%eax
  801415:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80141a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141d:	8b 40 04             	mov    0x4(%eax),%eax
  801420:	85 c0                	test   %eax,%eax
  801422:	74 0f                	je     801433 <initialize_dyn_block_system+0x142>
  801424:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801427:	8b 40 04             	mov    0x4(%eax),%eax
  80142a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80142d:	8b 12                	mov    (%edx),%edx
  80142f:	89 10                	mov    %edx,(%eax)
  801431:	eb 0a                	jmp    80143d <initialize_dyn_block_system+0x14c>
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	a3 48 41 80 00       	mov    %eax,0x804148
  80143d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801446:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801450:	a1 54 41 80 00       	mov    0x804154,%eax
  801455:	48                   	dec    %eax
  801456:	a3 54 41 80 00       	mov    %eax,0x804154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  80145b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80145f:	75 14                	jne    801475 <initialize_dyn_block_system+0x184>
  801461:	83 ec 04             	sub    $0x4,%esp
  801464:	68 20 3d 80 00       	push   $0x803d20
  801469:	6a 34                	push   $0x34
  80146b:	68 13 3d 80 00       	push   $0x803d13
  801470:	e8 0d ee ff ff       	call   800282 <_panic>
  801475:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80147b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147e:	89 10                	mov    %edx,(%eax)
  801480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801483:	8b 00                	mov    (%eax),%eax
  801485:	85 c0                	test   %eax,%eax
  801487:	74 0d                	je     801496 <initialize_dyn_block_system+0x1a5>
  801489:	a1 38 41 80 00       	mov    0x804138,%eax
  80148e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801491:	89 50 04             	mov    %edx,0x4(%eax)
  801494:	eb 08                	jmp    80149e <initialize_dyn_block_system+0x1ad>
  801496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801499:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80149e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8014a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8014b5:	40                   	inc    %eax
  8014b6:	a3 44 41 80 00       	mov    %eax,0x804144
}
  8014bb:	90                   	nop
  8014bc:	c9                   	leave  
  8014bd:	c3                   	ret    

008014be <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014c4:	e8 f7 fd ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014cd:	75 07                	jne    8014d6 <malloc+0x18>
  8014cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d4:	eb 14                	jmp    8014ea <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	68 44 3d 80 00       	push   $0x803d44
  8014de:	6a 46                	push   $0x46
  8014e0:	68 13 3d 80 00       	push   $0x803d13
  8014e5:	e8 98 ed ff ff       	call   800282 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	68 6c 3d 80 00       	push   $0x803d6c
  8014fa:	6a 61                	push   $0x61
  8014fc:	68 13 3d 80 00       	push   $0x803d13
  801501:	e8 7c ed ff ff       	call   800282 <_panic>

00801506 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 38             	sub    $0x38,%esp
  80150c:	8b 45 10             	mov    0x10(%ebp),%eax
  80150f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801512:	e8 a9 fd ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801517:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151b:	75 07                	jne    801524 <smalloc+0x1e>
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	eb 7c                	jmp    8015a0 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801524:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80152b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	01 d0                	add    %edx,%eax
  801533:	48                   	dec    %eax
  801534:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153a:	ba 00 00 00 00       	mov    $0x0,%edx
  80153f:	f7 75 f0             	divl   -0x10(%ebp)
  801542:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801545:	29 d0                	sub    %edx,%eax
  801547:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80154a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801551:	e8 41 06 00 00       	call   801b97 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801556:	85 c0                	test   %eax,%eax
  801558:	74 11                	je     80156b <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80155a:	83 ec 0c             	sub    $0xc,%esp
  80155d:	ff 75 e8             	pushl  -0x18(%ebp)
  801560:	e8 ac 0c 00 00       	call   802211 <alloc_block_FF>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  80156b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80156f:	74 2a                	je     80159b <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	8b 40 08             	mov    0x8(%eax),%eax
  801577:	89 c2                	mov    %eax,%edx
  801579:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80157d:	52                   	push   %edx
  80157e:	50                   	push   %eax
  80157f:	ff 75 0c             	pushl  0xc(%ebp)
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	e8 92 03 00 00       	call   80191c <sys_createSharedObject>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  801590:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  801594:	74 05                	je     80159b <smalloc+0x95>
			return (void*)virtual_address;
  801596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801599:	eb 05                	jmp    8015a0 <smalloc+0x9a>
	}
	return NULL;
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015a8:	e8 13 fd ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8015ad:	83 ec 04             	sub    $0x4,%esp
  8015b0:	68 90 3d 80 00       	push   $0x803d90
  8015b5:	68 a2 00 00 00       	push   $0xa2
  8015ba:	68 13 3d 80 00       	push   $0x803d13
  8015bf:	e8 be ec ff ff       	call   800282 <_panic>

008015c4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
  8015c7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ca:	e8 f1 fc ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8015cf:	83 ec 04             	sub    $0x4,%esp
  8015d2:	68 b4 3d 80 00       	push   $0x803db4
  8015d7:	68 e6 00 00 00       	push   $0xe6
  8015dc:	68 13 3d 80 00       	push   $0x803d13
  8015e1:	e8 9c ec ff ff       	call   800282 <_panic>

008015e6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	68 dc 3d 80 00       	push   $0x803ddc
  8015f4:	68 fa 00 00 00       	push   $0xfa
  8015f9:	68 13 3d 80 00       	push   $0x803d13
  8015fe:	e8 7f ec ff ff       	call   800282 <_panic>

00801603 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801609:	83 ec 04             	sub    $0x4,%esp
  80160c:	68 00 3e 80 00       	push   $0x803e00
  801611:	68 05 01 00 00       	push   $0x105
  801616:	68 13 3d 80 00       	push   $0x803d13
  80161b:	e8 62 ec ff ff       	call   800282 <_panic>

00801620 <shrink>:

}
void shrink(uint32 newSize)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801626:	83 ec 04             	sub    $0x4,%esp
  801629:	68 00 3e 80 00       	push   $0x803e00
  80162e:	68 0a 01 00 00       	push   $0x10a
  801633:	68 13 3d 80 00       	push   $0x803d13
  801638:	e8 45 ec ff ff       	call   800282 <_panic>

0080163d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801643:	83 ec 04             	sub    $0x4,%esp
  801646:	68 00 3e 80 00       	push   $0x803e00
  80164b:	68 0f 01 00 00       	push   $0x10f
  801650:	68 13 3d 80 00       	push   $0x803d13
  801655:	e8 28 ec ff ff       	call   800282 <_panic>

0080165a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	57                   	push   %edi
  80165e:	56                   	push   %esi
  80165f:	53                   	push   %ebx
  801660:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801663:	8b 45 08             	mov    0x8(%ebp),%eax
  801666:	8b 55 0c             	mov    0xc(%ebp),%edx
  801669:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80166f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801672:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801675:	cd 30                	int    $0x30
  801677:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80167a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	5b                   	pop    %ebx
  801681:	5e                   	pop    %esi
  801682:	5f                   	pop    %edi
  801683:	5d                   	pop    %ebp
  801684:	c3                   	ret    

00801685 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	83 ec 04             	sub    $0x4,%esp
  80168b:	8b 45 10             	mov    0x10(%ebp),%eax
  80168e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801691:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	52                   	push   %edx
  80169d:	ff 75 0c             	pushl  0xc(%ebp)
  8016a0:	50                   	push   %eax
  8016a1:	6a 00                	push   $0x0
  8016a3:	e8 b2 ff ff ff       	call   80165a <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	90                   	nop
  8016ac:	c9                   	leave  
  8016ad:	c3                   	ret    

008016ae <sys_cgetc>:

int
sys_cgetc(void)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8016b1:	6a 00                	push   $0x0
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 01                	push   $0x1
  8016bd:	e8 98 ff ff ff       	call   80165a <syscall>
  8016c2:	83 c4 18             	add    $0x18,%esp
}
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8016ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	52                   	push   %edx
  8016d7:	50                   	push   %eax
  8016d8:	6a 05                	push   $0x5
  8016da:	e8 7b ff ff ff       	call   80165a <syscall>
  8016df:	83 c4 18             	add    $0x18,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	56                   	push   %esi
  8016e8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8016e9:	8b 75 18             	mov    0x18(%ebp),%esi
  8016ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	56                   	push   %esi
  8016f9:	53                   	push   %ebx
  8016fa:	51                   	push   %ecx
  8016fb:	52                   	push   %edx
  8016fc:	50                   	push   %eax
  8016fd:	6a 06                	push   $0x6
  8016ff:	e8 56 ff ff ff       	call   80165a <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80170a:	5b                   	pop    %ebx
  80170b:	5e                   	pop    %esi
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801711:	8b 55 0c             	mov    0xc(%ebp),%edx
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	52                   	push   %edx
  80171e:	50                   	push   %eax
  80171f:	6a 07                	push   $0x7
  801721:	e8 34 ff ff ff       	call   80165a <syscall>
  801726:	83 c4 18             	add    $0x18,%esp
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	ff 75 0c             	pushl  0xc(%ebp)
  801737:	ff 75 08             	pushl  0x8(%ebp)
  80173a:	6a 08                	push   $0x8
  80173c:	e8 19 ff ff ff       	call   80165a <syscall>
  801741:	83 c4 18             	add    $0x18,%esp
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801749:	6a 00                	push   $0x0
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	6a 09                	push   $0x9
  801755:	e8 00 ff ff ff       	call   80165a <syscall>
  80175a:	83 c4 18             	add    $0x18,%esp
}
  80175d:	c9                   	leave  
  80175e:	c3                   	ret    

0080175f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 0a                	push   $0xa
  80176e:	e8 e7 fe ff ff       	call   80165a <syscall>
  801773:	83 c4 18             	add    $0x18,%esp
}
  801776:	c9                   	leave  
  801777:	c3                   	ret    

00801778 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	6a 00                	push   $0x0
  801785:	6a 0b                	push   $0xb
  801787:	e8 ce fe ff ff       	call   80165a <syscall>
  80178c:	83 c4 18             	add    $0x18,%esp
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	6a 0f                	push   $0xf
  8017a2:	e8 b3 fe ff ff       	call   80165a <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
	return;
  8017aa:	90                   	nop
}
  8017ab:	c9                   	leave  
  8017ac:	c3                   	ret    

008017ad <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	6a 00                	push   $0x0
  8017b6:	ff 75 0c             	pushl  0xc(%ebp)
  8017b9:	ff 75 08             	pushl  0x8(%ebp)
  8017bc:	6a 10                	push   $0x10
  8017be:	e8 97 fe ff ff       	call   80165a <syscall>
  8017c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8017c6:	90                   	nop
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 00                	push   $0x0
  8017d0:	ff 75 10             	pushl  0x10(%ebp)
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	6a 11                	push   $0x11
  8017db:	e8 7a fe ff ff       	call   80165a <syscall>
  8017e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8017e3:	90                   	nop
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 0c                	push   $0xc
  8017f5:	e8 60 fe ff ff       	call   80165a <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	ff 75 08             	pushl  0x8(%ebp)
  80180d:	6a 0d                	push   $0xd
  80180f:	e8 46 fe ff ff       	call   80165a <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 0e                	push   $0xe
  801828:	e8 2d fe ff ff       	call   80165a <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	90                   	nop
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 13                	push   $0x13
  801842:	e8 13 fe ff ff       	call   80165a <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	90                   	nop
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 14                	push   $0x14
  80185c:	e8 f9 fd ff ff       	call   80165a <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_cputc>:


void
sys_cputc(const char c)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801873:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	50                   	push   %eax
  801880:	6a 15                	push   $0x15
  801882:	e8 d3 fd ff ff       	call   80165a <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 16                	push   $0x16
  80189c:	e8 b9 fd ff ff       	call   80165a <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	90                   	nop
  8018a5:	c9                   	leave  
  8018a6:	c3                   	ret    

008018a7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	50                   	push   %eax
  8018b7:	6a 17                	push   $0x17
  8018b9:	e8 9c fd ff ff       	call   80165a <syscall>
  8018be:	83 c4 18             	add    $0x18,%esp
}
  8018c1:	c9                   	leave  
  8018c2:	c3                   	ret    

008018c3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	52                   	push   %edx
  8018d3:	50                   	push   %eax
  8018d4:	6a 1a                	push   $0x1a
  8018d6:	e8 7f fd ff ff       	call   80165a <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8018e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	52                   	push   %edx
  8018f0:	50                   	push   %eax
  8018f1:	6a 18                	push   $0x18
  8018f3:	e8 62 fd ff ff       	call   80165a <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	90                   	nop
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801901:	8b 55 0c             	mov    0xc(%ebp),%edx
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	52                   	push   %edx
  80190e:	50                   	push   %eax
  80190f:	6a 19                	push   $0x19
  801911:	e8 44 fd ff ff       	call   80165a <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	90                   	nop
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 04             	sub    $0x4,%esp
  801922:	8b 45 10             	mov    0x10(%ebp),%eax
  801925:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801928:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80192b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	6a 00                	push   $0x0
  801934:	51                   	push   %ecx
  801935:	52                   	push   %edx
  801936:	ff 75 0c             	pushl  0xc(%ebp)
  801939:	50                   	push   %eax
  80193a:	6a 1b                	push   $0x1b
  80193c:	e8 19 fd ff ff       	call   80165a <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	52                   	push   %edx
  801956:	50                   	push   %eax
  801957:	6a 1c                	push   $0x1c
  801959:	e8 fc fc ff ff       	call   80165a <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801966:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	51                   	push   %ecx
  801974:	52                   	push   %edx
  801975:	50                   	push   %eax
  801976:	6a 1d                	push   $0x1d
  801978:	e8 dd fc ff ff       	call   80165a <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	52                   	push   %edx
  801992:	50                   	push   %eax
  801993:	6a 1e                	push   $0x1e
  801995:	e8 c0 fc ff ff       	call   80165a <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 1f                	push   $0x1f
  8019ae:	e8 a7 fc ff ff       	call   80165a <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	ff 75 14             	pushl  0x14(%ebp)
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	50                   	push   %eax
  8019ca:	6a 20                	push   $0x20
  8019cc:	e8 89 fc ff ff       	call   80165a <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8019d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	50                   	push   %eax
  8019e5:	6a 21                	push   $0x21
  8019e7:	e8 6e fc ff ff       	call   80165a <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	50                   	push   %eax
  801a01:	6a 22                	push   $0x22
  801a03:	e8 52 fc ff ff       	call   80165a <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 02                	push   $0x2
  801a1c:	e8 39 fc ff ff       	call   80165a <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 03                	push   $0x3
  801a35:	e8 20 fc ff ff       	call   80165a <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 04                	push   $0x4
  801a4e:	e8 07 fc ff ff       	call   80165a <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_exit_env>:


void sys_exit_env(void)
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 23                	push   $0x23
  801a67:	e8 ee fb ff ff       	call   80165a <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801a78:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a7b:	8d 50 04             	lea    0x4(%eax),%edx
  801a7e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 24                	push   $0x24
  801a8b:	e8 ca fb ff ff       	call   80165a <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
	return result;
  801a93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a9c:	89 01                	mov    %eax,(%ecx)
  801a9e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	c9                   	leave  
  801aa5:	c2 04 00             	ret    $0x4

00801aa8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 10             	pushl  0x10(%ebp)
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	ff 75 08             	pushl  0x8(%ebp)
  801ab8:	6a 12                	push   $0x12
  801aba:	e8 9b fb ff ff       	call   80165a <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac2:	90                   	nop
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 25                	push   $0x25
  801ad4:	e8 81 fb ff ff       	call   80165a <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801aea:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	50                   	push   %eax
  801af7:	6a 26                	push   $0x26
  801af9:	e8 5c fb ff ff       	call   80165a <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <rsttst>:
void rsttst()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 28                	push   $0x28
  801b13:	e8 42 fb ff ff       	call   80165a <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1b:	90                   	nop
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 04             	sub    $0x4,%esp
  801b24:	8b 45 14             	mov    0x14(%ebp),%eax
  801b27:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b2a:	8b 55 18             	mov    0x18(%ebp),%edx
  801b2d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b31:	52                   	push   %edx
  801b32:	50                   	push   %eax
  801b33:	ff 75 10             	pushl  0x10(%ebp)
  801b36:	ff 75 0c             	pushl  0xc(%ebp)
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	6a 27                	push   $0x27
  801b3e:	e8 17 fb ff ff       	call   80165a <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
	return ;
  801b46:	90                   	nop
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <chktst>:
void chktst(uint32 n)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	ff 75 08             	pushl  0x8(%ebp)
  801b57:	6a 29                	push   $0x29
  801b59:	e8 fc fa ff ff       	call   80165a <syscall>
  801b5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801b61:	90                   	nop
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <inctst>:

void inctst()
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 2a                	push   $0x2a
  801b73:	e8 e2 fa ff ff       	call   80165a <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
	return ;
  801b7b:	90                   	nop
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <gettst>:
uint32 gettst()
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 2b                	push   $0x2b
  801b8d:	e8 c8 fa ff ff       	call   80165a <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 2c                	push   $0x2c
  801ba9:	e8 ac fa ff ff       	call   80165a <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
  801bb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801bb4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801bb8:	75 07                	jne    801bc1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801bba:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbf:	eb 05                	jmp    801bc6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 2c                	push   $0x2c
  801bda:	e8 7b fa ff ff       	call   80165a <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
  801be2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801be5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801be9:	75 07                	jne    801bf2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801beb:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf0:	eb 05                	jmp    801bf7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 2c                	push   $0x2c
  801c0b:	e8 4a fa ff ff       	call   80165a <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
  801c13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c16:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c1a:	75 07                	jne    801c23 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c1c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c21:	eb 05                	jmp    801c28 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 2c                	push   $0x2c
  801c3c:	e8 19 fa ff ff       	call   80165a <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
  801c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801c47:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801c4b:	75 07                	jne    801c54 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801c4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c52:	eb 05                	jmp    801c59 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801c54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	ff 75 08             	pushl  0x8(%ebp)
  801c69:	6a 2d                	push   $0x2d
  801c6b:	e8 ea f9 ff ff       	call   80165a <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return ;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801c7a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	6a 00                	push   $0x0
  801c88:	53                   	push   %ebx
  801c89:	51                   	push   %ecx
  801c8a:	52                   	push   %edx
  801c8b:	50                   	push   %eax
  801c8c:	6a 2e                	push   $0x2e
  801c8e:	e8 c7 f9 ff ff       	call   80165a <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	52                   	push   %edx
  801cab:	50                   	push   %eax
  801cac:	6a 2f                	push   $0x2f
  801cae:	e8 a7 f9 ff ff       	call   80165a <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801cbe:	83 ec 0c             	sub    $0xc,%esp
  801cc1:	68 10 3e 80 00       	push   $0x803e10
  801cc6:	e8 6b e8 ff ff       	call   800536 <cprintf>
  801ccb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801cce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801cd5:	83 ec 0c             	sub    $0xc,%esp
  801cd8:	68 3c 3e 80 00       	push   $0x803e3c
  801cdd:	e8 54 e8 ff ff       	call   800536 <cprintf>
  801ce2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ce5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ce9:	a1 38 41 80 00       	mov    0x804138,%eax
  801cee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801cf1:	eb 56                	jmp    801d49 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801cf3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cf7:	74 1c                	je     801d15 <print_mem_block_lists+0x5d>
  801cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cfc:	8b 50 08             	mov    0x8(%eax),%edx
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d02:	8b 48 08             	mov    0x8(%eax),%ecx
  801d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d08:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0b:	01 c8                	add    %ecx,%eax
  801d0d:	39 c2                	cmp    %eax,%edx
  801d0f:	73 04                	jae    801d15 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d11:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d18:	8b 50 08             	mov    0x8(%eax),%edx
  801d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d21:	01 c2                	add    %eax,%edx
  801d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d26:	8b 40 08             	mov    0x8(%eax),%eax
  801d29:	83 ec 04             	sub    $0x4,%esp
  801d2c:	52                   	push   %edx
  801d2d:	50                   	push   %eax
  801d2e:	68 51 3e 80 00       	push   $0x803e51
  801d33:	e8 fe e7 ff ff       	call   800536 <cprintf>
  801d38:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d41:	a1 40 41 80 00       	mov    0x804140,%eax
  801d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4d:	74 07                	je     801d56 <print_mem_block_lists+0x9e>
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	8b 00                	mov    (%eax),%eax
  801d54:	eb 05                	jmp    801d5b <print_mem_block_lists+0xa3>
  801d56:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5b:	a3 40 41 80 00       	mov    %eax,0x804140
  801d60:	a1 40 41 80 00       	mov    0x804140,%eax
  801d65:	85 c0                	test   %eax,%eax
  801d67:	75 8a                	jne    801cf3 <print_mem_block_lists+0x3b>
  801d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6d:	75 84                	jne    801cf3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801d6f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801d73:	75 10                	jne    801d85 <print_mem_block_lists+0xcd>
  801d75:	83 ec 0c             	sub    $0xc,%esp
  801d78:	68 60 3e 80 00       	push   $0x803e60
  801d7d:	e8 b4 e7 ff ff       	call   800536 <cprintf>
  801d82:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801d85:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801d8c:	83 ec 0c             	sub    $0xc,%esp
  801d8f:	68 84 3e 80 00       	push   $0x803e84
  801d94:	e8 9d e7 ff ff       	call   800536 <cprintf>
  801d99:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801d9c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801da0:	a1 40 40 80 00       	mov    0x804040,%eax
  801da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da8:	eb 56                	jmp    801e00 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801daa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dae:	74 1c                	je     801dcc <print_mem_block_lists+0x114>
  801db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db3:	8b 50 08             	mov    0x8(%eax),%edx
  801db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db9:	8b 48 08             	mov    0x8(%eax),%ecx
  801dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc2:	01 c8                	add    %ecx,%eax
  801dc4:	39 c2                	cmp    %eax,%edx
  801dc6:	73 04                	jae    801dcc <print_mem_block_lists+0x114>
			sorted = 0 ;
  801dc8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	8b 50 08             	mov    0x8(%eax),%edx
  801dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd5:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd8:	01 c2                	add    %eax,%edx
  801dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ddd:	8b 40 08             	mov    0x8(%eax),%eax
  801de0:	83 ec 04             	sub    $0x4,%esp
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	68 51 3e 80 00       	push   $0x803e51
  801dea:	e8 47 e7 ff ff       	call   800536 <cprintf>
  801def:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801df8:	a1 48 40 80 00       	mov    0x804048,%eax
  801dfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e04:	74 07                	je     801e0d <print_mem_block_lists+0x155>
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	8b 00                	mov    (%eax),%eax
  801e0b:	eb 05                	jmp    801e12 <print_mem_block_lists+0x15a>
  801e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e12:	a3 48 40 80 00       	mov    %eax,0x804048
  801e17:	a1 48 40 80 00       	mov    0x804048,%eax
  801e1c:	85 c0                	test   %eax,%eax
  801e1e:	75 8a                	jne    801daa <print_mem_block_lists+0xf2>
  801e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e24:	75 84                	jne    801daa <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e26:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e2a:	75 10                	jne    801e3c <print_mem_block_lists+0x184>
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	68 9c 3e 80 00       	push   $0x803e9c
  801e34:	e8 fd e6 ff ff       	call   800536 <cprintf>
  801e39:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	68 10 3e 80 00       	push   $0x803e10
  801e44:	e8 ed e6 ff ff       	call   800536 <cprintf>
  801e49:	83 c4 10             	add    $0x10,%esp

}
  801e4c:	90                   	nop
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801e55:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801e5c:	00 00 00 
  801e5f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801e66:	00 00 00 
  801e69:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801e70:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801e73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e7a:	e9 9e 00 00 00       	jmp    801f1d <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801e7f:	a1 50 40 80 00       	mov    0x804050,%eax
  801e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e87:	c1 e2 04             	shl    $0x4,%edx
  801e8a:	01 d0                	add    %edx,%eax
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	75 14                	jne    801ea4 <initialize_MemBlocksList+0x55>
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	68 c4 3e 80 00       	push   $0x803ec4
  801e98:	6a 46                	push   $0x46
  801e9a:	68 e7 3e 80 00       	push   $0x803ee7
  801e9f:	e8 de e3 ff ff       	call   800282 <_panic>
  801ea4:	a1 50 40 80 00       	mov    0x804050,%eax
  801ea9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eac:	c1 e2 04             	shl    $0x4,%edx
  801eaf:	01 d0                	add    %edx,%eax
  801eb1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801eb7:	89 10                	mov    %edx,(%eax)
  801eb9:	8b 00                	mov    (%eax),%eax
  801ebb:	85 c0                	test   %eax,%eax
  801ebd:	74 18                	je     801ed7 <initialize_MemBlocksList+0x88>
  801ebf:	a1 48 41 80 00       	mov    0x804148,%eax
  801ec4:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801eca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ecd:	c1 e1 04             	shl    $0x4,%ecx
  801ed0:	01 ca                	add    %ecx,%edx
  801ed2:	89 50 04             	mov    %edx,0x4(%eax)
  801ed5:	eb 12                	jmp    801ee9 <initialize_MemBlocksList+0x9a>
  801ed7:	a1 50 40 80 00       	mov    0x804050,%eax
  801edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801edf:	c1 e2 04             	shl    $0x4,%edx
  801ee2:	01 d0                	add    %edx,%eax
  801ee4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801ee9:	a1 50 40 80 00       	mov    0x804050,%eax
  801eee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef1:	c1 e2 04             	shl    $0x4,%edx
  801ef4:	01 d0                	add    %edx,%eax
  801ef6:	a3 48 41 80 00       	mov    %eax,0x804148
  801efb:	a1 50 40 80 00       	mov    0x804050,%eax
  801f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f03:	c1 e2 04             	shl    $0x4,%edx
  801f06:	01 d0                	add    %edx,%eax
  801f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f0f:	a1 54 41 80 00       	mov    0x804154,%eax
  801f14:	40                   	inc    %eax
  801f15:	a3 54 41 80 00       	mov    %eax,0x804154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  801f1a:	ff 45 f4             	incl   -0xc(%ebp)
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f23:	0f 82 56 ff ff ff    	jb     801e7f <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  801f29:	90                   	nop
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
  801f2f:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f32:	8b 45 08             	mov    0x8(%ebp),%eax
  801f35:	8b 00                	mov    (%eax),%eax
  801f37:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f3a:	eb 19                	jmp    801f55 <find_block+0x29>
	{
		if(va==point->sva)
  801f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f3f:	8b 40 08             	mov    0x8(%eax),%eax
  801f42:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801f45:	75 05                	jne    801f4c <find_block+0x20>
		   return point;
  801f47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f4a:	eb 36                	jmp    801f82 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	8b 40 08             	mov    0x8(%eax),%eax
  801f52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801f55:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f59:	74 07                	je     801f62 <find_block+0x36>
  801f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f5e:	8b 00                	mov    (%eax),%eax
  801f60:	eb 05                	jmp    801f67 <find_block+0x3b>
  801f62:	b8 00 00 00 00       	mov    $0x0,%eax
  801f67:	8b 55 08             	mov    0x8(%ebp),%edx
  801f6a:	89 42 08             	mov    %eax,0x8(%edx)
  801f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f70:	8b 40 08             	mov    0x8(%eax),%eax
  801f73:	85 c0                	test   %eax,%eax
  801f75:	75 c5                	jne    801f3c <find_block+0x10>
  801f77:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f7b:	75 bf                	jne    801f3c <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  801f8a:	a1 40 40 80 00       	mov    0x804040,%eax
  801f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  801f92:	a1 44 40 80 00       	mov    0x804044,%eax
  801f97:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  801f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801fa0:	74 24                	je     801fc6 <insert_sorted_allocList+0x42>
  801fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa5:	8b 50 08             	mov    0x8(%eax),%edx
  801fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fab:	8b 40 08             	mov    0x8(%eax),%eax
  801fae:	39 c2                	cmp    %eax,%edx
  801fb0:	76 14                	jbe    801fc6 <insert_sorted_allocList+0x42>
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	8b 50 08             	mov    0x8(%eax),%edx
  801fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fbb:	8b 40 08             	mov    0x8(%eax),%eax
  801fbe:	39 c2                	cmp    %eax,%edx
  801fc0:	0f 82 60 01 00 00    	jb     802126 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  801fc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fca:	75 65                	jne    802031 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  801fcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801fd0:	75 14                	jne    801fe6 <insert_sorted_allocList+0x62>
  801fd2:	83 ec 04             	sub    $0x4,%esp
  801fd5:	68 c4 3e 80 00       	push   $0x803ec4
  801fda:	6a 6b                	push   $0x6b
  801fdc:	68 e7 3e 80 00       	push   $0x803ee7
  801fe1:	e8 9c e2 ff ff       	call   800282 <_panic>
  801fe6:	8b 15 40 40 80 00    	mov    0x804040,%edx
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	89 10                	mov    %edx,(%eax)
  801ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff4:	8b 00                	mov    (%eax),%eax
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	74 0d                	je     802007 <insert_sorted_allocList+0x83>
  801ffa:	a1 40 40 80 00       	mov    0x804040,%eax
  801fff:	8b 55 08             	mov    0x8(%ebp),%edx
  802002:	89 50 04             	mov    %edx,0x4(%eax)
  802005:	eb 08                	jmp    80200f <insert_sorted_allocList+0x8b>
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	a3 44 40 80 00       	mov    %eax,0x804044
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	a3 40 40 80 00       	mov    %eax,0x804040
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802021:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802026:	40                   	inc    %eax
  802027:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80202c:	e9 dc 01 00 00       	jmp    80220d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	8b 50 08             	mov    0x8(%eax),%edx
  802037:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203a:	8b 40 08             	mov    0x8(%eax),%eax
  80203d:	39 c2                	cmp    %eax,%edx
  80203f:	77 6c                	ja     8020ad <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802041:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802045:	74 06                	je     80204d <insert_sorted_allocList+0xc9>
  802047:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80204b:	75 14                	jne    802061 <insert_sorted_allocList+0xdd>
  80204d:	83 ec 04             	sub    $0x4,%esp
  802050:	68 00 3f 80 00       	push   $0x803f00
  802055:	6a 6f                	push   $0x6f
  802057:	68 e7 3e 80 00       	push   $0x803ee7
  80205c:	e8 21 e2 ff ff       	call   800282 <_panic>
  802061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802064:	8b 50 04             	mov    0x4(%eax),%edx
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	89 50 04             	mov    %edx,0x4(%eax)
  80206d:	8b 45 08             	mov    0x8(%ebp),%eax
  802070:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802073:	89 10                	mov    %edx,(%eax)
  802075:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802078:	8b 40 04             	mov    0x4(%eax),%eax
  80207b:	85 c0                	test   %eax,%eax
  80207d:	74 0d                	je     80208c <insert_sorted_allocList+0x108>
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802082:	8b 40 04             	mov    0x4(%eax),%eax
  802085:	8b 55 08             	mov    0x8(%ebp),%edx
  802088:	89 10                	mov    %edx,(%eax)
  80208a:	eb 08                	jmp    802094 <insert_sorted_allocList+0x110>
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	a3 40 40 80 00       	mov    %eax,0x804040
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802097:	8b 55 08             	mov    0x8(%ebp),%edx
  80209a:	89 50 04             	mov    %edx,0x4(%eax)
  80209d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020a2:	40                   	inc    %eax
  8020a3:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8020a8:	e9 60 01 00 00       	jmp    80220d <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8b 50 08             	mov    0x8(%eax),%edx
  8020b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b6:	8b 40 08             	mov    0x8(%eax),%eax
  8020b9:	39 c2                	cmp    %eax,%edx
  8020bb:	0f 82 4c 01 00 00    	jb     80220d <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8020c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020c5:	75 14                	jne    8020db <insert_sorted_allocList+0x157>
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	68 38 3f 80 00       	push   $0x803f38
  8020cf:	6a 73                	push   $0x73
  8020d1:	68 e7 3e 80 00       	push   $0x803ee7
  8020d6:	e8 a7 e1 ff ff       	call   800282 <_panic>
  8020db:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	89 50 04             	mov    %edx,0x4(%eax)
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	8b 40 04             	mov    0x4(%eax),%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	74 0c                	je     8020fd <insert_sorted_allocList+0x179>
  8020f1:	a1 44 40 80 00       	mov    0x804044,%eax
  8020f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f9:	89 10                	mov    %edx,(%eax)
  8020fb:	eb 08                	jmp    802105 <insert_sorted_allocList+0x181>
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	a3 40 40 80 00       	mov    %eax,0x804040
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	a3 44 40 80 00       	mov    %eax,0x804044
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802116:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80211b:	40                   	inc    %eax
  80211c:	a3 4c 40 80 00       	mov    %eax,0x80404c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802121:	e9 e7 00 00 00       	jmp    80220d <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802129:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  80212c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802133:	a1 40 40 80 00       	mov    0x804040,%eax
  802138:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213b:	e9 9d 00 00 00       	jmp    8021dd <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	8b 00                	mov    (%eax),%eax
  802145:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	8b 50 08             	mov    0x8(%eax),%edx
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	8b 40 08             	mov    0x8(%eax),%eax
  802154:	39 c2                	cmp    %eax,%edx
  802156:	76 7d                	jbe    8021d5 <insert_sorted_allocList+0x251>
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	8b 50 08             	mov    0x8(%eax),%edx
  80215e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802161:	8b 40 08             	mov    0x8(%eax),%eax
  802164:	39 c2                	cmp    %eax,%edx
  802166:	73 6d                	jae    8021d5 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216c:	74 06                	je     802174 <insert_sorted_allocList+0x1f0>
  80216e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802172:	75 14                	jne    802188 <insert_sorted_allocList+0x204>
  802174:	83 ec 04             	sub    $0x4,%esp
  802177:	68 5c 3f 80 00       	push   $0x803f5c
  80217c:	6a 7f                	push   $0x7f
  80217e:	68 e7 3e 80 00       	push   $0x803ee7
  802183:	e8 fa e0 ff ff       	call   800282 <_panic>
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	8b 10                	mov    (%eax),%edx
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	89 10                	mov    %edx,(%eax)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	8b 00                	mov    (%eax),%eax
  802197:	85 c0                	test   %eax,%eax
  802199:	74 0b                	je     8021a6 <insert_sorted_allocList+0x222>
  80219b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a3:	89 50 04             	mov    %edx,0x4(%eax)
  8021a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ac:	89 10                	mov    %edx,(%eax)
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b4:	89 50 04             	mov    %edx,0x4(%eax)
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	8b 00                	mov    (%eax),%eax
  8021bc:	85 c0                	test   %eax,%eax
  8021be:	75 08                	jne    8021c8 <insert_sorted_allocList+0x244>
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	a3 44 40 80 00       	mov    %eax,0x804044
  8021c8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021cd:	40                   	inc    %eax
  8021ce:	a3 4c 40 80 00       	mov    %eax,0x80404c
				break;
  8021d3:	eb 39                	jmp    80220e <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8021d5:	a1 48 40 80 00       	mov    0x804048,%eax
  8021da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021e1:	74 07                	je     8021ea <insert_sorted_allocList+0x266>
  8021e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e6:	8b 00                	mov    (%eax),%eax
  8021e8:	eb 05                	jmp    8021ef <insert_sorted_allocList+0x26b>
  8021ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ef:	a3 48 40 80 00       	mov    %eax,0x804048
  8021f4:	a1 48 40 80 00       	mov    0x804048,%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	0f 85 3f ff ff ff    	jne    802140 <insert_sorted_allocList+0x1bc>
  802201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802205:	0f 85 35 ff ff ff    	jne    802140 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80220b:	eb 01                	jmp    80220e <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80220d:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80220e:	90                   	nop
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802217:	a1 38 41 80 00       	mov    0x804138,%eax
  80221c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80221f:	e9 85 01 00 00       	jmp    8023a9 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802227:	8b 40 0c             	mov    0xc(%eax),%eax
  80222a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80222d:	0f 82 6e 01 00 00    	jb     8023a1 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802236:	8b 40 0c             	mov    0xc(%eax),%eax
  802239:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223c:	0f 85 8a 00 00 00    	jne    8022cc <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802242:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802246:	75 17                	jne    80225f <alloc_block_FF+0x4e>
  802248:	83 ec 04             	sub    $0x4,%esp
  80224b:	68 90 3f 80 00       	push   $0x803f90
  802250:	68 93 00 00 00       	push   $0x93
  802255:	68 e7 3e 80 00       	push   $0x803ee7
  80225a:	e8 23 e0 ff ff       	call   800282 <_panic>
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	8b 00                	mov    (%eax),%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	74 10                	je     802278 <alloc_block_FF+0x67>
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 00                	mov    (%eax),%eax
  80226d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802270:	8b 52 04             	mov    0x4(%edx),%edx
  802273:	89 50 04             	mov    %edx,0x4(%eax)
  802276:	eb 0b                	jmp    802283 <alloc_block_FF+0x72>
  802278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227b:	8b 40 04             	mov    0x4(%eax),%eax
  80227e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8b 40 04             	mov    0x4(%eax),%eax
  802289:	85 c0                	test   %eax,%eax
  80228b:	74 0f                	je     80229c <alloc_block_FF+0x8b>
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 40 04             	mov    0x4(%eax),%eax
  802293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802296:	8b 12                	mov    (%edx),%edx
  802298:	89 10                	mov    %edx,(%eax)
  80229a:	eb 0a                	jmp    8022a6 <alloc_block_FF+0x95>
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 00                	mov    (%eax),%eax
  8022a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b9:	a1 44 41 80 00       	mov    0x804144,%eax
  8022be:	48                   	dec    %eax
  8022bf:	a3 44 41 80 00       	mov    %eax,0x804144
			   return  point;
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	e9 10 01 00 00       	jmp    8023dc <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d5:	0f 86 c6 00 00 00    	jbe    8023a1 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8022db:	a1 48 41 80 00       	mov    0x804148,%eax
  8022e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 50 08             	mov    0x8(%eax),%edx
  8022e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ec:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8022ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f5:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8022f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022fc:	75 17                	jne    802315 <alloc_block_FF+0x104>
  8022fe:	83 ec 04             	sub    $0x4,%esp
  802301:	68 90 3f 80 00       	push   $0x803f90
  802306:	68 9b 00 00 00       	push   $0x9b
  80230b:	68 e7 3e 80 00       	push   $0x803ee7
  802310:	e8 6d df ff ff       	call   800282 <_panic>
  802315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802318:	8b 00                	mov    (%eax),%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	74 10                	je     80232e <alloc_block_FF+0x11d>
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802326:	8b 52 04             	mov    0x4(%edx),%edx
  802329:	89 50 04             	mov    %edx,0x4(%eax)
  80232c:	eb 0b                	jmp    802339 <alloc_block_FF+0x128>
  80232e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802331:	8b 40 04             	mov    0x4(%eax),%eax
  802334:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233c:	8b 40 04             	mov    0x4(%eax),%eax
  80233f:	85 c0                	test   %eax,%eax
  802341:	74 0f                	je     802352 <alloc_block_FF+0x141>
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	8b 40 04             	mov    0x4(%eax),%eax
  802349:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234c:	8b 12                	mov    (%edx),%edx
  80234e:	89 10                	mov    %edx,(%eax)
  802350:	eb 0a                	jmp    80235c <alloc_block_FF+0x14b>
  802352:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802355:	8b 00                	mov    (%eax),%eax
  802357:	a3 48 41 80 00       	mov    %eax,0x804148
  80235c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802368:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236f:	a1 54 41 80 00       	mov    0x804154,%eax
  802374:	48                   	dec    %eax
  802375:	a3 54 41 80 00       	mov    %eax,0x804154
			   point->sva += size;
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 50 08             	mov    0x8(%eax),%edx
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	01 c2                	add    %eax,%edx
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	8b 40 0c             	mov    0xc(%eax),%eax
  802391:	2b 45 08             	sub    0x8(%ebp),%eax
  802394:	89 c2                	mov    %eax,%edx
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  80239c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239f:	eb 3b                	jmp    8023dc <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023a1:	a1 40 41 80 00       	mov    0x804140,%eax
  8023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ad:	74 07                	je     8023b6 <alloc_block_FF+0x1a5>
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 00                	mov    (%eax),%eax
  8023b4:	eb 05                	jmp    8023bb <alloc_block_FF+0x1aa>
  8023b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023bb:	a3 40 41 80 00       	mov    %eax,0x804140
  8023c0:	a1 40 41 80 00       	mov    0x804140,%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	0f 85 57 fe ff ff    	jne    802224 <alloc_block_FF+0x13>
  8023cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d1:	0f 85 4d fe ff ff    	jne    802224 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8023e4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8023eb:	a1 38 41 80 00       	mov    0x804138,%eax
  8023f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f3:	e9 df 00 00 00       	jmp    8024d7 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802401:	0f 82 c8 00 00 00    	jb     8024cf <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	8b 40 0c             	mov    0xc(%eax),%eax
  80240d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802410:	0f 85 8a 00 00 00    	jne    8024a0 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802416:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241a:	75 17                	jne    802433 <alloc_block_BF+0x55>
  80241c:	83 ec 04             	sub    $0x4,%esp
  80241f:	68 90 3f 80 00       	push   $0x803f90
  802424:	68 b7 00 00 00       	push   $0xb7
  802429:	68 e7 3e 80 00       	push   $0x803ee7
  80242e:	e8 4f de ff ff       	call   800282 <_panic>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 00                	mov    (%eax),%eax
  802438:	85 c0                	test   %eax,%eax
  80243a:	74 10                	je     80244c <alloc_block_BF+0x6e>
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802444:	8b 52 04             	mov    0x4(%edx),%edx
  802447:	89 50 04             	mov    %edx,0x4(%eax)
  80244a:	eb 0b                	jmp    802457 <alloc_block_BF+0x79>
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 40 04             	mov    0x4(%eax),%eax
  80245d:	85 c0                	test   %eax,%eax
  80245f:	74 0f                	je     802470 <alloc_block_BF+0x92>
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 40 04             	mov    0x4(%eax),%eax
  802467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246a:	8b 12                	mov    (%edx),%edx
  80246c:	89 10                	mov    %edx,(%eax)
  80246e:	eb 0a                	jmp    80247a <alloc_block_BF+0x9c>
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 00                	mov    (%eax),%eax
  802475:	a3 38 41 80 00       	mov    %eax,0x804138
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248d:	a1 44 41 80 00       	mov    0x804144,%eax
  802492:	48                   	dec    %eax
  802493:	a3 44 41 80 00       	mov    %eax,0x804144
			   return currentMemBlock;
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	e9 4d 01 00 00       	jmp    8025ed <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a9:	76 24                	jbe    8024cf <alloc_block_BF+0xf1>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024b4:	73 19                	jae    8024cf <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8024b6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 08             	mov    0x8(%eax),%eax
  8024cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024cf:	a1 40 41 80 00       	mov    0x804140,%eax
  8024d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024db:	74 07                	je     8024e4 <alloc_block_BF+0x106>
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	eb 05                	jmp    8024e9 <alloc_block_BF+0x10b>
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e9:	a3 40 41 80 00       	mov    %eax,0x804140
  8024ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f3:	85 c0                	test   %eax,%eax
  8024f5:	0f 85 fd fe ff ff    	jne    8023f8 <alloc_block_BF+0x1a>
  8024fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ff:	0f 85 f3 fe ff ff    	jne    8023f8 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802505:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802509:	0f 84 d9 00 00 00    	je     8025e8 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80250f:	a1 48 41 80 00       	mov    0x804148,%eax
  802514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80251a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80251d:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802520:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802523:	8b 55 08             	mov    0x8(%ebp),%edx
  802526:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802529:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80252d:	75 17                	jne    802546 <alloc_block_BF+0x168>
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	68 90 3f 80 00       	push   $0x803f90
  802537:	68 c7 00 00 00       	push   $0xc7
  80253c:	68 e7 3e 80 00       	push   $0x803ee7
  802541:	e8 3c dd ff ff       	call   800282 <_panic>
  802546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	85 c0                	test   %eax,%eax
  80254d:	74 10                	je     80255f <alloc_block_BF+0x181>
  80254f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802557:	8b 52 04             	mov    0x4(%edx),%edx
  80255a:	89 50 04             	mov    %edx,0x4(%eax)
  80255d:	eb 0b                	jmp    80256a <alloc_block_BF+0x18c>
  80255f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802562:	8b 40 04             	mov    0x4(%eax),%eax
  802565:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80256a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	85 c0                	test   %eax,%eax
  802572:	74 0f                	je     802583 <alloc_block_BF+0x1a5>
  802574:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802577:	8b 40 04             	mov    0x4(%eax),%eax
  80257a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257d:	8b 12                	mov    (%edx),%edx
  80257f:	89 10                	mov    %edx,(%eax)
  802581:	eb 0a                	jmp    80258d <alloc_block_BF+0x1af>
  802583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	a3 48 41 80 00       	mov    %eax,0x804148
  80258d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802599:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8025a5:	48                   	dec    %eax
  8025a6:	a3 54 41 80 00       	mov    %eax,0x804154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8025ab:	83 ec 08             	sub    $0x8,%esp
  8025ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8025b1:	68 38 41 80 00       	push   $0x804138
  8025b6:	e8 71 f9 ff ff       	call   801f2c <find_block>
  8025bb:	83 c4 10             	add    $0x10,%esp
  8025be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c4:	8b 50 08             	mov    0x8(%eax),%edx
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	01 c2                	add    %eax,%edx
  8025cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025cf:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8025d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d8:	2b 45 08             	sub    0x8(%ebp),%eax
  8025db:	89 c2                	mov    %eax,%edx
  8025dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025e0:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8025e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e6:	eb 05                	jmp    8025ed <alloc_block_BF+0x20f>
	}
	return NULL;
  8025e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ed:	c9                   	leave  
  8025ee:	c3                   	ret    

008025ef <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8025ef:	55                   	push   %ebp
  8025f0:	89 e5                	mov    %esp,%ebp
  8025f2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8025f5:	a1 28 40 80 00       	mov    0x804028,%eax
  8025fa:	85 c0                	test   %eax,%eax
  8025fc:	0f 85 de 01 00 00    	jne    8027e0 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802602:	a1 38 41 80 00       	mov    0x804138,%eax
  802607:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260a:	e9 9e 01 00 00       	jmp    8027ad <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 0c             	mov    0xc(%eax),%eax
  802615:	3b 45 08             	cmp    0x8(%ebp),%eax
  802618:	0f 82 87 01 00 00    	jb     8027a5 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 0c             	mov    0xc(%eax),%eax
  802624:	3b 45 08             	cmp    0x8(%ebp),%eax
  802627:	0f 85 95 00 00 00    	jne    8026c2 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80262d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802631:	75 17                	jne    80264a <alloc_block_NF+0x5b>
  802633:	83 ec 04             	sub    $0x4,%esp
  802636:	68 90 3f 80 00       	push   $0x803f90
  80263b:	68 e0 00 00 00       	push   $0xe0
  802640:	68 e7 3e 80 00       	push   $0x803ee7
  802645:	e8 38 dc ff ff       	call   800282 <_panic>
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	8b 00                	mov    (%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 10                	je     802663 <alloc_block_NF+0x74>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265b:	8b 52 04             	mov    0x4(%edx),%edx
  80265e:	89 50 04             	mov    %edx,0x4(%eax)
  802661:	eb 0b                	jmp    80266e <alloc_block_NF+0x7f>
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	8b 40 04             	mov    0x4(%eax),%eax
  802669:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 40 04             	mov    0x4(%eax),%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	74 0f                	je     802687 <alloc_block_NF+0x98>
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802681:	8b 12                	mov    (%edx),%edx
  802683:	89 10                	mov    %edx,(%eax)
  802685:	eb 0a                	jmp    802691 <alloc_block_NF+0xa2>
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	a3 38 41 80 00       	mov    %eax,0x804138
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a4:	a1 44 41 80 00       	mov    0x804144,%eax
  8026a9:	48                   	dec    %eax
  8026aa:	a3 44 41 80 00       	mov    %eax,0x804144
				   svaOfNF = point->sva;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 40 08             	mov    0x8(%eax),%eax
  8026b5:	a3 28 40 80 00       	mov    %eax,0x804028
				   return  point;
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	e9 f8 04 00 00       	jmp    802bba <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cb:	0f 86 d4 00 00 00    	jbe    8027a5 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d1:	a1 48 41 80 00       	mov    0x804148,%eax
  8026d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 50 08             	mov    0x8(%eax),%edx
  8026df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e2:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8026e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026eb:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8026ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f2:	75 17                	jne    80270b <alloc_block_NF+0x11c>
  8026f4:	83 ec 04             	sub    $0x4,%esp
  8026f7:	68 90 3f 80 00       	push   $0x803f90
  8026fc:	68 e9 00 00 00       	push   $0xe9
  802701:	68 e7 3e 80 00       	push   $0x803ee7
  802706:	e8 77 db ff ff       	call   800282 <_panic>
  80270b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270e:	8b 00                	mov    (%eax),%eax
  802710:	85 c0                	test   %eax,%eax
  802712:	74 10                	je     802724 <alloc_block_NF+0x135>
  802714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802717:	8b 00                	mov    (%eax),%eax
  802719:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271c:	8b 52 04             	mov    0x4(%edx),%edx
  80271f:	89 50 04             	mov    %edx,0x4(%eax)
  802722:	eb 0b                	jmp    80272f <alloc_block_NF+0x140>
  802724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802727:	8b 40 04             	mov    0x4(%eax),%eax
  80272a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	8b 40 04             	mov    0x4(%eax),%eax
  802735:	85 c0                	test   %eax,%eax
  802737:	74 0f                	je     802748 <alloc_block_NF+0x159>
  802739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273c:	8b 40 04             	mov    0x4(%eax),%eax
  80273f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802742:	8b 12                	mov    (%edx),%edx
  802744:	89 10                	mov    %edx,(%eax)
  802746:	eb 0a                	jmp    802752 <alloc_block_NF+0x163>
  802748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	a3 48 41 80 00       	mov    %eax,0x804148
  802752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802755:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802765:	a1 54 41 80 00       	mov    0x804154,%eax
  80276a:	48                   	dec    %eax
  80276b:	a3 54 41 80 00       	mov    %eax,0x804154
				   svaOfNF = ReturnedBlock->sva;
  802770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802773:	8b 40 08             	mov    0x8(%eax),%eax
  802776:	a3 28 40 80 00       	mov    %eax,0x804028
				   point->sva += size;
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 50 08             	mov    0x8(%eax),%edx
  802781:	8b 45 08             	mov    0x8(%ebp),%eax
  802784:	01 c2                	add    %eax,%edx
  802786:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802789:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 40 0c             	mov    0xc(%eax),%eax
  802792:	2b 45 08             	sub    0x8(%ebp),%eax
  802795:	89 c2                	mov    %eax,%edx
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	e9 15 04 00 00       	jmp    802bba <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027a5:	a1 40 41 80 00       	mov    0x804140,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b1:	74 07                	je     8027ba <alloc_block_NF+0x1cb>
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	eb 05                	jmp    8027bf <alloc_block_NF+0x1d0>
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bf:	a3 40 41 80 00       	mov    %eax,0x804140
  8027c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	0f 85 3e fe ff ff    	jne    80260f <alloc_block_NF+0x20>
  8027d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d5:	0f 85 34 fe ff ff    	jne    80260f <alloc_block_NF+0x20>
  8027db:	e9 d5 03 00 00       	jmp    802bb5 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8027e0:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e8:	e9 b1 01 00 00       	jmp    80299e <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 50 08             	mov    0x8(%eax),%edx
  8027f3:	a1 28 40 80 00       	mov    0x804028,%eax
  8027f8:	39 c2                	cmp    %eax,%edx
  8027fa:	0f 82 96 01 00 00    	jb     802996 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 40 0c             	mov    0xc(%eax),%eax
  802806:	3b 45 08             	cmp    0x8(%ebp),%eax
  802809:	0f 82 87 01 00 00    	jb     802996 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 0c             	mov    0xc(%eax),%eax
  802815:	3b 45 08             	cmp    0x8(%ebp),%eax
  802818:	0f 85 95 00 00 00    	jne    8028b3 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80281e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802822:	75 17                	jne    80283b <alloc_block_NF+0x24c>
  802824:	83 ec 04             	sub    $0x4,%esp
  802827:	68 90 3f 80 00       	push   $0x803f90
  80282c:	68 fc 00 00 00       	push   $0xfc
  802831:	68 e7 3e 80 00       	push   $0x803ee7
  802836:	e8 47 da ff ff       	call   800282 <_panic>
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 00                	mov    (%eax),%eax
  802840:	85 c0                	test   %eax,%eax
  802842:	74 10                	je     802854 <alloc_block_NF+0x265>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284c:	8b 52 04             	mov    0x4(%edx),%edx
  80284f:	89 50 04             	mov    %edx,0x4(%eax)
  802852:	eb 0b                	jmp    80285f <alloc_block_NF+0x270>
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 40 04             	mov    0x4(%eax),%eax
  80285a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 40 04             	mov    0x4(%eax),%eax
  802865:	85 c0                	test   %eax,%eax
  802867:	74 0f                	je     802878 <alloc_block_NF+0x289>
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	8b 40 04             	mov    0x4(%eax),%eax
  80286f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802872:	8b 12                	mov    (%edx),%edx
  802874:	89 10                	mov    %edx,(%eax)
  802876:	eb 0a                	jmp    802882 <alloc_block_NF+0x293>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	a3 38 41 80 00       	mov    %eax,0x804138
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802895:	a1 44 41 80 00       	mov    0x804144,%eax
  80289a:	48                   	dec    %eax
  80289b:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 08             	mov    0x8(%eax),%eax
  8028a6:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	e9 07 03 00 00       	jmp    802bba <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8028b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028bc:	0f 86 d4 00 00 00    	jbe    802996 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8028c2:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 50 08             	mov    0x8(%eax),%edx
  8028d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d3:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8028d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028dc:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028e3:	75 17                	jne    8028fc <alloc_block_NF+0x30d>
  8028e5:	83 ec 04             	sub    $0x4,%esp
  8028e8:	68 90 3f 80 00       	push   $0x803f90
  8028ed:	68 04 01 00 00       	push   $0x104
  8028f2:	68 e7 3e 80 00       	push   $0x803ee7
  8028f7:	e8 86 d9 ff ff       	call   800282 <_panic>
  8028fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	85 c0                	test   %eax,%eax
  802903:	74 10                	je     802915 <alloc_block_NF+0x326>
  802905:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802908:	8b 00                	mov    (%eax),%eax
  80290a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80290d:	8b 52 04             	mov    0x4(%edx),%edx
  802910:	89 50 04             	mov    %edx,0x4(%eax)
  802913:	eb 0b                	jmp    802920 <alloc_block_NF+0x331>
  802915:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802918:	8b 40 04             	mov    0x4(%eax),%eax
  80291b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802920:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802923:	8b 40 04             	mov    0x4(%eax),%eax
  802926:	85 c0                	test   %eax,%eax
  802928:	74 0f                	je     802939 <alloc_block_NF+0x34a>
  80292a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292d:	8b 40 04             	mov    0x4(%eax),%eax
  802930:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802933:	8b 12                	mov    (%edx),%edx
  802935:	89 10                	mov    %edx,(%eax)
  802937:	eb 0a                	jmp    802943 <alloc_block_NF+0x354>
  802939:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293c:	8b 00                	mov    (%eax),%eax
  80293e:	a3 48 41 80 00       	mov    %eax,0x804148
  802943:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802946:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802956:	a1 54 41 80 00       	mov    0x804154,%eax
  80295b:	48                   	dec    %eax
  80295c:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802961:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802964:	8b 40 08             	mov    0x8(%eax),%eax
  802967:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 50 08             	mov    0x8(%eax),%edx
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	01 c2                	add    %eax,%edx
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 40 0c             	mov    0xc(%eax),%eax
  802983:	2b 45 08             	sub    0x8(%ebp),%eax
  802986:	89 c2                	mov    %eax,%edx
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  80298e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802991:	e9 24 02 00 00       	jmp    802bba <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802996:	a1 40 41 80 00       	mov    0x804140,%eax
  80299b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80299e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a2:	74 07                	je     8029ab <alloc_block_NF+0x3bc>
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	8b 00                	mov    (%eax),%eax
  8029a9:	eb 05                	jmp    8029b0 <alloc_block_NF+0x3c1>
  8029ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b0:	a3 40 41 80 00       	mov    %eax,0x804140
  8029b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8029ba:	85 c0                	test   %eax,%eax
  8029bc:	0f 85 2b fe ff ff    	jne    8027ed <alloc_block_NF+0x1fe>
  8029c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c6:	0f 85 21 fe ff ff    	jne    8027ed <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029cc:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d4:	e9 ae 01 00 00       	jmp    802b87 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 50 08             	mov    0x8(%eax),%edx
  8029df:	a1 28 40 80 00       	mov    0x804028,%eax
  8029e4:	39 c2                	cmp    %eax,%edx
  8029e6:	0f 83 93 01 00 00    	jae    802b7f <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f5:	0f 82 84 01 00 00    	jb     802b7f <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  8029fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802a01:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a04:	0f 85 95 00 00 00    	jne    802a9f <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0e:	75 17                	jne    802a27 <alloc_block_NF+0x438>
  802a10:	83 ec 04             	sub    $0x4,%esp
  802a13:	68 90 3f 80 00       	push   $0x803f90
  802a18:	68 14 01 00 00       	push   $0x114
  802a1d:	68 e7 3e 80 00       	push   $0x803ee7
  802a22:	e8 5b d8 ff ff       	call   800282 <_panic>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 10                	je     802a40 <alloc_block_NF+0x451>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a38:	8b 52 04             	mov    0x4(%edx),%edx
  802a3b:	89 50 04             	mov    %edx,0x4(%eax)
  802a3e:	eb 0b                	jmp    802a4b <alloc_block_NF+0x45c>
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 40 04             	mov    0x4(%eax),%eax
  802a46:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	85 c0                	test   %eax,%eax
  802a53:	74 0f                	je     802a64 <alloc_block_NF+0x475>
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5e:	8b 12                	mov    (%edx),%edx
  802a60:	89 10                	mov    %edx,(%eax)
  802a62:	eb 0a                	jmp    802a6e <alloc_block_NF+0x47f>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	a3 38 41 80 00       	mov    %eax,0x804138
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a81:	a1 44 41 80 00       	mov    0x804144,%eax
  802a86:	48                   	dec    %eax
  802a87:	a3 44 41 80 00       	mov    %eax,0x804144
					   svaOfNF = point->sva;
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 08             	mov    0x8(%eax),%eax
  802a92:	a3 28 40 80 00       	mov    %eax,0x804028
					   return  point;
  802a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9a:	e9 1b 01 00 00       	jmp    802bba <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa8:	0f 86 d1 00 00 00    	jbe    802b7f <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802aae:	a1 48 41 80 00       	mov    0x804148,%eax
  802ab3:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	8b 50 08             	mov    0x8(%eax),%edx
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac8:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802acb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802acf:	75 17                	jne    802ae8 <alloc_block_NF+0x4f9>
  802ad1:	83 ec 04             	sub    $0x4,%esp
  802ad4:	68 90 3f 80 00       	push   $0x803f90
  802ad9:	68 1c 01 00 00       	push   $0x11c
  802ade:	68 e7 3e 80 00       	push   $0x803ee7
  802ae3:	e8 9a d7 ff ff       	call   800282 <_panic>
  802ae8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 10                	je     802b01 <alloc_block_NF+0x512>
  802af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af9:	8b 52 04             	mov    0x4(%edx),%edx
  802afc:	89 50 04             	mov    %edx,0x4(%eax)
  802aff:	eb 0b                	jmp    802b0c <alloc_block_NF+0x51d>
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0f:	8b 40 04             	mov    0x4(%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	74 0f                	je     802b25 <alloc_block_NF+0x536>
  802b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b19:	8b 40 04             	mov    0x4(%eax),%eax
  802b1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b1f:	8b 12                	mov    (%edx),%edx
  802b21:	89 10                	mov    %edx,(%eax)
  802b23:	eb 0a                	jmp    802b2f <alloc_block_NF+0x540>
  802b25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b28:	8b 00                	mov    (%eax),%eax
  802b2a:	a3 48 41 80 00       	mov    %eax,0x804148
  802b2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b42:	a1 54 41 80 00       	mov    0x804154,%eax
  802b47:	48                   	dec    %eax
  802b48:	a3 54 41 80 00       	mov    %eax,0x804154
					   svaOfNF = ReturnedBlock->sva;
  802b4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b50:	8b 40 08             	mov    0x8(%eax),%eax
  802b53:	a3 28 40 80 00       	mov    %eax,0x804028
					   point->sva += size;
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 50 08             	mov    0x8(%eax),%edx
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	01 c2                	add    %eax,%edx
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6f:	2b 45 08             	sub    0x8(%ebp),%eax
  802b72:	89 c2                	mov    %eax,%edx
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7d:	eb 3b                	jmp    802bba <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b7f:	a1 40 41 80 00       	mov    0x804140,%eax
  802b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8b:	74 07                	je     802b94 <alloc_block_NF+0x5a5>
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	eb 05                	jmp    802b99 <alloc_block_NF+0x5aa>
  802b94:	b8 00 00 00 00       	mov    $0x0,%eax
  802b99:	a3 40 41 80 00       	mov    %eax,0x804140
  802b9e:	a1 40 41 80 00       	mov    0x804140,%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	0f 85 2e fe ff ff    	jne    8029d9 <alloc_block_NF+0x3ea>
  802bab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baf:	0f 85 24 fe ff ff    	jne    8029d9 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bba:	c9                   	leave  
  802bbb:	c3                   	ret    

00802bbc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802bbc:	55                   	push   %ebp
  802bbd:	89 e5                	mov    %esp,%ebp
  802bbf:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802bc2:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802bca:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802bd2:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	74 14                	je     802bef <insert_sorted_with_merge_freeList+0x33>
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	8b 50 08             	mov    0x8(%eax),%edx
  802be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be4:	8b 40 08             	mov    0x8(%eax),%eax
  802be7:	39 c2                	cmp    %eax,%edx
  802be9:	0f 87 9b 01 00 00    	ja     802d8a <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf3:	75 17                	jne    802c0c <insert_sorted_with_merge_freeList+0x50>
  802bf5:	83 ec 04             	sub    $0x4,%esp
  802bf8:	68 c4 3e 80 00       	push   $0x803ec4
  802bfd:	68 38 01 00 00       	push   $0x138
  802c02:	68 e7 3e 80 00       	push   $0x803ee7
  802c07:	e8 76 d6 ff ff       	call   800282 <_panic>
  802c0c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	89 10                	mov    %edx,(%eax)
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	8b 00                	mov    (%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 0d                	je     802c2d <insert_sorted_with_merge_freeList+0x71>
  802c20:	a1 38 41 80 00       	mov    0x804138,%eax
  802c25:	8b 55 08             	mov    0x8(%ebp),%edx
  802c28:	89 50 04             	mov    %edx,0x4(%eax)
  802c2b:	eb 08                	jmp    802c35 <insert_sorted_with_merge_freeList+0x79>
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	a3 38 41 80 00       	mov    %eax,0x804138
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c47:	a1 44 41 80 00       	mov    0x804144,%eax
  802c4c:	40                   	inc    %eax
  802c4d:	a3 44 41 80 00       	mov    %eax,0x804144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802c52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c56:	0f 84 a8 06 00 00    	je     803304 <insert_sorted_with_merge_freeList+0x748>
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	8b 50 08             	mov    0x8(%eax),%edx
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	8b 40 0c             	mov    0xc(%eax),%eax
  802c68:	01 c2                	add    %eax,%edx
  802c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c6d:	8b 40 08             	mov    0x8(%eax),%eax
  802c70:	39 c2                	cmp    %eax,%edx
  802c72:	0f 85 8c 06 00 00    	jne    803304 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	8b 50 0c             	mov    0xc(%eax),%edx
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 40 0c             	mov    0xc(%eax),%eax
  802c84:	01 c2                	add    %eax,%edx
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802c8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c90:	75 17                	jne    802ca9 <insert_sorted_with_merge_freeList+0xed>
  802c92:	83 ec 04             	sub    $0x4,%esp
  802c95:	68 90 3f 80 00       	push   $0x803f90
  802c9a:	68 3c 01 00 00       	push   $0x13c
  802c9f:	68 e7 3e 80 00       	push   $0x803ee7
  802ca4:	e8 d9 d5 ff ff       	call   800282 <_panic>
  802ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	74 10                	je     802cc2 <insert_sorted_with_merge_freeList+0x106>
  802cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cba:	8b 52 04             	mov    0x4(%edx),%edx
  802cbd:	89 50 04             	mov    %edx,0x4(%eax)
  802cc0:	eb 0b                	jmp    802ccd <insert_sorted_with_merge_freeList+0x111>
  802cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	8b 40 04             	mov    0x4(%eax),%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	74 0f                	je     802ce6 <insert_sorted_with_merge_freeList+0x12a>
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ce0:	8b 12                	mov    (%edx),%edx
  802ce2:	89 10                	mov    %edx,(%eax)
  802ce4:	eb 0a                	jmp    802cf0 <insert_sorted_with_merge_freeList+0x134>
  802ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	a3 38 41 80 00       	mov    %eax,0x804138
  802cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d03:	a1 44 41 80 00       	mov    0x804144,%eax
  802d08:	48                   	dec    %eax
  802d09:	a3 44 41 80 00       	mov    %eax,0x804144
			head->size = 0;
  802d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802d22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d26:	75 17                	jne    802d3f <insert_sorted_with_merge_freeList+0x183>
  802d28:	83 ec 04             	sub    $0x4,%esp
  802d2b:	68 c4 3e 80 00       	push   $0x803ec4
  802d30:	68 3f 01 00 00       	push   $0x13f
  802d35:	68 e7 3e 80 00       	push   $0x803ee7
  802d3a:	e8 43 d5 ff ff       	call   800282 <_panic>
  802d3f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d48:	89 10                	mov    %edx,(%eax)
  802d4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	74 0d                	je     802d60 <insert_sorted_with_merge_freeList+0x1a4>
  802d53:	a1 48 41 80 00       	mov    0x804148,%eax
  802d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	eb 08                	jmp    802d68 <insert_sorted_with_merge_freeList+0x1ac>
  802d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d63:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d7f:	40                   	inc    %eax
  802d80:	a3 54 41 80 00       	mov    %eax,0x804154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d85:	e9 7a 05 00 00       	jmp    803304 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 50 08             	mov    0x8(%eax),%edx
  802d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d93:	8b 40 08             	mov    0x8(%eax),%eax
  802d96:	39 c2                	cmp    %eax,%edx
  802d98:	0f 82 14 01 00 00    	jb     802eb2 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802d9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da1:	8b 50 08             	mov    0x8(%eax),%edx
  802da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da7:	8b 40 0c             	mov    0xc(%eax),%eax
  802daa:	01 c2                	add    %eax,%edx
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	8b 40 08             	mov    0x8(%eax),%eax
  802db2:	39 c2                	cmp    %eax,%edx
  802db4:	0f 85 90 00 00 00    	jne    802e4a <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	01 c2                	add    %eax,%edx
  802dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcb:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802de2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de6:	75 17                	jne    802dff <insert_sorted_with_merge_freeList+0x243>
  802de8:	83 ec 04             	sub    $0x4,%esp
  802deb:	68 c4 3e 80 00       	push   $0x803ec4
  802df0:	68 49 01 00 00       	push   $0x149
  802df5:	68 e7 3e 80 00       	push   $0x803ee7
  802dfa:	e8 83 d4 ff ff       	call   800282 <_panic>
  802dff:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	89 10                	mov    %edx,(%eax)
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	74 0d                	je     802e20 <insert_sorted_with_merge_freeList+0x264>
  802e13:	a1 48 41 80 00       	mov    0x804148,%eax
  802e18:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1b:	89 50 04             	mov    %edx,0x4(%eax)
  802e1e:	eb 08                	jmp    802e28 <insert_sorted_with_merge_freeList+0x26c>
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	a3 48 41 80 00       	mov    %eax,0x804148
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3a:	a1 54 41 80 00       	mov    0x804154,%eax
  802e3f:	40                   	inc    %eax
  802e40:	a3 54 41 80 00       	mov    %eax,0x804154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802e45:	e9 bb 04 00 00       	jmp    803305 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802e4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4e:	75 17                	jne    802e67 <insert_sorted_with_merge_freeList+0x2ab>
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	68 38 3f 80 00       	push   $0x803f38
  802e58:	68 4c 01 00 00       	push   $0x14c
  802e5d:	68 e7 3e 80 00       	push   $0x803ee7
  802e62:	e8 1b d4 ff ff       	call   800282 <_panic>
  802e67:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	89 50 04             	mov    %edx,0x4(%eax)
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	8b 40 04             	mov    0x4(%eax),%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	74 0c                	je     802e89 <insert_sorted_with_merge_freeList+0x2cd>
  802e7d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802e82:	8b 55 08             	mov    0x8(%ebp),%edx
  802e85:	89 10                	mov    %edx,(%eax)
  802e87:	eb 08                	jmp    802e91 <insert_sorted_with_merge_freeList+0x2d5>
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	a3 38 41 80 00       	mov    %eax,0x804138
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea2:	a1 44 41 80 00       	mov    0x804144,%eax
  802ea7:	40                   	inc    %eax
  802ea8:	a3 44 41 80 00       	mov    %eax,0x804144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802ead:	e9 53 04 00 00       	jmp    803305 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802eb2:	a1 38 41 80 00       	mov    0x804138,%eax
  802eb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eba:	e9 15 04 00 00       	jmp    8032d4 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec2:	8b 00                	mov    (%eax),%eax
  802ec4:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	8b 50 08             	mov    0x8(%eax),%edx
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 40 08             	mov    0x8(%eax),%eax
  802ed3:	39 c2                	cmp    %eax,%edx
  802ed5:	0f 86 f1 03 00 00    	jbe    8032cc <insert_sorted_with_merge_freeList+0x710>
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8b 50 08             	mov    0x8(%eax),%edx
  802ee1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee4:	8b 40 08             	mov    0x8(%eax),%eax
  802ee7:	39 c2                	cmp    %eax,%edx
  802ee9:	0f 83 dd 03 00 00    	jae    8032cc <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	8b 50 08             	mov    0x8(%eax),%edx
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  802efb:	01 c2                	add    %eax,%edx
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8b 40 08             	mov    0x8(%eax),%eax
  802f03:	39 c2                	cmp    %eax,%edx
  802f05:	0f 85 b9 01 00 00    	jne    8030c4 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	8b 50 08             	mov    0x8(%eax),%edx
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	8b 40 0c             	mov    0xc(%eax),%eax
  802f17:	01 c2                	add    %eax,%edx
  802f19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1c:	8b 40 08             	mov    0x8(%eax),%eax
  802f1f:	39 c2                	cmp    %eax,%edx
  802f21:	0f 85 0d 01 00 00    	jne    803034 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 40 0c             	mov    0xc(%eax),%eax
  802f33:	01 c2                	add    %eax,%edx
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  802f3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f3f:	75 17                	jne    802f58 <insert_sorted_with_merge_freeList+0x39c>
  802f41:	83 ec 04             	sub    $0x4,%esp
  802f44:	68 90 3f 80 00       	push   $0x803f90
  802f49:	68 5c 01 00 00       	push   $0x15c
  802f4e:	68 e7 3e 80 00       	push   $0x803ee7
  802f53:	e8 2a d3 ff ff       	call   800282 <_panic>
  802f58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	74 10                	je     802f71 <insert_sorted_with_merge_freeList+0x3b5>
  802f61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f69:	8b 52 04             	mov    0x4(%edx),%edx
  802f6c:	89 50 04             	mov    %edx,0x4(%eax)
  802f6f:	eb 0b                	jmp    802f7c <insert_sorted_with_merge_freeList+0x3c0>
  802f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7f:	8b 40 04             	mov    0x4(%eax),%eax
  802f82:	85 c0                	test   %eax,%eax
  802f84:	74 0f                	je     802f95 <insert_sorted_with_merge_freeList+0x3d9>
  802f86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f89:	8b 40 04             	mov    0x4(%eax),%eax
  802f8c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f8f:	8b 12                	mov    (%edx),%edx
  802f91:	89 10                	mov    %edx,(%eax)
  802f93:	eb 0a                	jmp    802f9f <insert_sorted_with_merge_freeList+0x3e3>
  802f95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb2:	a1 44 41 80 00       	mov    0x804144,%eax
  802fb7:	48                   	dec    %eax
  802fb8:	a3 44 41 80 00       	mov    %eax,0x804144
						nextBlock->sva = 0;
  802fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  802fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  802fd1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802fd5:	75 17                	jne    802fee <insert_sorted_with_merge_freeList+0x432>
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	68 c4 3e 80 00       	push   $0x803ec4
  802fdf:	68 5f 01 00 00       	push   $0x15f
  802fe4:	68 e7 3e 80 00       	push   $0x803ee7
  802fe9:	e8 94 d2 ff ff       	call   800282 <_panic>
  802fee:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	85 c0                	test   %eax,%eax
  803000:	74 0d                	je     80300f <insert_sorted_with_merge_freeList+0x453>
  803002:	a1 48 41 80 00       	mov    0x804148,%eax
  803007:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80300a:	89 50 04             	mov    %edx,0x4(%eax)
  80300d:	eb 08                	jmp    803017 <insert_sorted_with_merge_freeList+0x45b>
  80300f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803012:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803017:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301a:	a3 48 41 80 00       	mov    %eax,0x804148
  80301f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803022:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803029:	a1 54 41 80 00       	mov    0x804154,%eax
  80302e:	40                   	inc    %eax
  80302f:	a3 54 41 80 00       	mov    %eax,0x804154
					}
					currentBlock->size += blockToInsert->size;
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 50 0c             	mov    0xc(%eax),%edx
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 40 0c             	mov    0xc(%eax),%eax
  803040:	01 c2                	add    %eax,%edx
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80305c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803060:	75 17                	jne    803079 <insert_sorted_with_merge_freeList+0x4bd>
  803062:	83 ec 04             	sub    $0x4,%esp
  803065:	68 c4 3e 80 00       	push   $0x803ec4
  80306a:	68 64 01 00 00       	push   $0x164
  80306f:	68 e7 3e 80 00       	push   $0x803ee7
  803074:	e8 09 d2 ff ff       	call   800282 <_panic>
  803079:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	89 10                	mov    %edx,(%eax)
  803084:	8b 45 08             	mov    0x8(%ebp),%eax
  803087:	8b 00                	mov    (%eax),%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	74 0d                	je     80309a <insert_sorted_with_merge_freeList+0x4de>
  80308d:	a1 48 41 80 00       	mov    0x804148,%eax
  803092:	8b 55 08             	mov    0x8(%ebp),%edx
  803095:	89 50 04             	mov    %edx,0x4(%eax)
  803098:	eb 08                	jmp    8030a2 <insert_sorted_with_merge_freeList+0x4e6>
  80309a:	8b 45 08             	mov    0x8(%ebp),%eax
  80309d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	a3 48 41 80 00       	mov    %eax,0x804148
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b4:	a1 54 41 80 00       	mov    0x804154,%eax
  8030b9:	40                   	inc    %eax
  8030ba:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  8030bf:	e9 41 02 00 00       	jmp    803305 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 50 08             	mov    0x8(%eax),%edx
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d0:	01 c2                	add    %eax,%edx
  8030d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d5:	8b 40 08             	mov    0x8(%eax),%eax
  8030d8:	39 c2                	cmp    %eax,%edx
  8030da:	0f 85 7c 01 00 00    	jne    80325c <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8030e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e4:	74 06                	je     8030ec <insert_sorted_with_merge_freeList+0x530>
  8030e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ea:	75 17                	jne    803103 <insert_sorted_with_merge_freeList+0x547>
  8030ec:	83 ec 04             	sub    $0x4,%esp
  8030ef:	68 00 3f 80 00       	push   $0x803f00
  8030f4:	68 69 01 00 00       	push   $0x169
  8030f9:	68 e7 3e 80 00       	push   $0x803ee7
  8030fe:	e8 7f d1 ff ff       	call   800282 <_panic>
  803103:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803106:	8b 50 04             	mov    0x4(%eax),%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	89 50 04             	mov    %edx,0x4(%eax)
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803115:	89 10                	mov    %edx,(%eax)
  803117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311a:	8b 40 04             	mov    0x4(%eax),%eax
  80311d:	85 c0                	test   %eax,%eax
  80311f:	74 0d                	je     80312e <insert_sorted_with_merge_freeList+0x572>
  803121:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803124:	8b 40 04             	mov    0x4(%eax),%eax
  803127:	8b 55 08             	mov    0x8(%ebp),%edx
  80312a:	89 10                	mov    %edx,(%eax)
  80312c:	eb 08                	jmp    803136 <insert_sorted_with_merge_freeList+0x57a>
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	a3 38 41 80 00       	mov    %eax,0x804138
  803136:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803139:	8b 55 08             	mov    0x8(%ebp),%edx
  80313c:	89 50 04             	mov    %edx,0x4(%eax)
  80313f:	a1 44 41 80 00       	mov    0x804144,%eax
  803144:	40                   	inc    %eax
  803145:	a3 44 41 80 00       	mov    %eax,0x804144
					blockToInsert->size += nextBlock->size;
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	8b 50 0c             	mov    0xc(%eax),%edx
  803150:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803153:	8b 40 0c             	mov    0xc(%eax),%eax
  803156:	01 c2                	add    %eax,%edx
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80315e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803162:	75 17                	jne    80317b <insert_sorted_with_merge_freeList+0x5bf>
  803164:	83 ec 04             	sub    $0x4,%esp
  803167:	68 90 3f 80 00       	push   $0x803f90
  80316c:	68 6b 01 00 00       	push   $0x16b
  803171:	68 e7 3e 80 00       	push   $0x803ee7
  803176:	e8 07 d1 ff ff       	call   800282 <_panic>
  80317b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	85 c0                	test   %eax,%eax
  803182:	74 10                	je     803194 <insert_sorted_with_merge_freeList+0x5d8>
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	8b 00                	mov    (%eax),%eax
  803189:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80318c:	8b 52 04             	mov    0x4(%edx),%edx
  80318f:	89 50 04             	mov    %edx,0x4(%eax)
  803192:	eb 0b                	jmp    80319f <insert_sorted_with_merge_freeList+0x5e3>
  803194:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803197:	8b 40 04             	mov    0x4(%eax),%eax
  80319a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80319f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a2:	8b 40 04             	mov    0x4(%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 0f                	je     8031b8 <insert_sorted_with_merge_freeList+0x5fc>
  8031a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ac:	8b 40 04             	mov    0x4(%eax),%eax
  8031af:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b2:	8b 12                	mov    (%edx),%edx
  8031b4:	89 10                	mov    %edx,(%eax)
  8031b6:	eb 0a                	jmp    8031c2 <insert_sorted_with_merge_freeList+0x606>
  8031b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	a3 38 41 80 00       	mov    %eax,0x804138
  8031c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8031da:	48                   	dec    %eax
  8031db:	a3 44 41 80 00       	mov    %eax,0x804144
					nextBlock->sva = 0;
  8031e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8031f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f8:	75 17                	jne    803211 <insert_sorted_with_merge_freeList+0x655>
  8031fa:	83 ec 04             	sub    $0x4,%esp
  8031fd:	68 c4 3e 80 00       	push   $0x803ec4
  803202:	68 6e 01 00 00       	push   $0x16e
  803207:	68 e7 3e 80 00       	push   $0x803ee7
  80320c:	e8 71 d0 ff ff       	call   800282 <_panic>
  803211:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803217:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321a:	89 10                	mov    %edx,(%eax)
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 0d                	je     803232 <insert_sorted_with_merge_freeList+0x676>
  803225:	a1 48 41 80 00       	mov    0x804148,%eax
  80322a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322d:	89 50 04             	mov    %edx,0x4(%eax)
  803230:	eb 08                	jmp    80323a <insert_sorted_with_merge_freeList+0x67e>
  803232:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803235:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80323a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323d:	a3 48 41 80 00       	mov    %eax,0x804148
  803242:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324c:	a1 54 41 80 00       	mov    0x804154,%eax
  803251:	40                   	inc    %eax
  803252:	a3 54 41 80 00       	mov    %eax,0x804154
					break;
  803257:	e9 a9 00 00 00       	jmp    803305 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  80325c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803260:	74 06                	je     803268 <insert_sorted_with_merge_freeList+0x6ac>
  803262:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803266:	75 17                	jne    80327f <insert_sorted_with_merge_freeList+0x6c3>
  803268:	83 ec 04             	sub    $0x4,%esp
  80326b:	68 5c 3f 80 00       	push   $0x803f5c
  803270:	68 73 01 00 00       	push   $0x173
  803275:	68 e7 3e 80 00       	push   $0x803ee7
  80327a:	e8 03 d0 ff ff       	call   800282 <_panic>
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 10                	mov    (%eax),%edx
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	89 10                	mov    %edx,(%eax)
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	85 c0                	test   %eax,%eax
  803290:	74 0b                	je     80329d <insert_sorted_with_merge_freeList+0x6e1>
  803292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803295:	8b 00                	mov    (%eax),%eax
  803297:	8b 55 08             	mov    0x8(%ebp),%edx
  80329a:	89 50 04             	mov    %edx,0x4(%eax)
  80329d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032a3:	89 10                	mov    %edx,(%eax)
  8032a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032ab:	89 50 04             	mov    %edx,0x4(%eax)
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 00                	mov    (%eax),%eax
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	75 08                	jne    8032bf <insert_sorted_with_merge_freeList+0x703>
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8032bf:	a1 44 41 80 00       	mov    0x804144,%eax
  8032c4:	40                   	inc    %eax
  8032c5:	a3 44 41 80 00       	mov    %eax,0x804144
					break;
  8032ca:	eb 39                	jmp    803305 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8032cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8032d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d8:	74 07                	je     8032e1 <insert_sorted_with_merge_freeList+0x725>
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	eb 05                	jmp    8032e6 <insert_sorted_with_merge_freeList+0x72a>
  8032e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e6:	a3 40 41 80 00       	mov    %eax,0x804140
  8032eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8032f0:	85 c0                	test   %eax,%eax
  8032f2:	0f 85 c7 fb ff ff    	jne    802ebf <insert_sorted_with_merge_freeList+0x303>
  8032f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032fc:	0f 85 bd fb ff ff    	jne    802ebf <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803302:	eb 01                	jmp    803305 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803304:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803305:	90                   	nop
  803306:	c9                   	leave  
  803307:	c3                   	ret    

00803308 <__udivdi3>:
  803308:	55                   	push   %ebp
  803309:	57                   	push   %edi
  80330a:	56                   	push   %esi
  80330b:	53                   	push   %ebx
  80330c:	83 ec 1c             	sub    $0x1c,%esp
  80330f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803313:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803317:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80331b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80331f:	89 ca                	mov    %ecx,%edx
  803321:	89 f8                	mov    %edi,%eax
  803323:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803327:	85 f6                	test   %esi,%esi
  803329:	75 2d                	jne    803358 <__udivdi3+0x50>
  80332b:	39 cf                	cmp    %ecx,%edi
  80332d:	77 65                	ja     803394 <__udivdi3+0x8c>
  80332f:	89 fd                	mov    %edi,%ebp
  803331:	85 ff                	test   %edi,%edi
  803333:	75 0b                	jne    803340 <__udivdi3+0x38>
  803335:	b8 01 00 00 00       	mov    $0x1,%eax
  80333a:	31 d2                	xor    %edx,%edx
  80333c:	f7 f7                	div    %edi
  80333e:	89 c5                	mov    %eax,%ebp
  803340:	31 d2                	xor    %edx,%edx
  803342:	89 c8                	mov    %ecx,%eax
  803344:	f7 f5                	div    %ebp
  803346:	89 c1                	mov    %eax,%ecx
  803348:	89 d8                	mov    %ebx,%eax
  80334a:	f7 f5                	div    %ebp
  80334c:	89 cf                	mov    %ecx,%edi
  80334e:	89 fa                	mov    %edi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	39 ce                	cmp    %ecx,%esi
  80335a:	77 28                	ja     803384 <__udivdi3+0x7c>
  80335c:	0f bd fe             	bsr    %esi,%edi
  80335f:	83 f7 1f             	xor    $0x1f,%edi
  803362:	75 40                	jne    8033a4 <__udivdi3+0x9c>
  803364:	39 ce                	cmp    %ecx,%esi
  803366:	72 0a                	jb     803372 <__udivdi3+0x6a>
  803368:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80336c:	0f 87 9e 00 00 00    	ja     803410 <__udivdi3+0x108>
  803372:	b8 01 00 00 00       	mov    $0x1,%eax
  803377:	89 fa                	mov    %edi,%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	31 ff                	xor    %edi,%edi
  803386:	31 c0                	xor    %eax,%eax
  803388:	89 fa                	mov    %edi,%edx
  80338a:	83 c4 1c             	add    $0x1c,%esp
  80338d:	5b                   	pop    %ebx
  80338e:	5e                   	pop    %esi
  80338f:	5f                   	pop    %edi
  803390:	5d                   	pop    %ebp
  803391:	c3                   	ret    
  803392:	66 90                	xchg   %ax,%ax
  803394:	89 d8                	mov    %ebx,%eax
  803396:	f7 f7                	div    %edi
  803398:	31 ff                	xor    %edi,%edi
  80339a:	89 fa                	mov    %edi,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033a9:	89 eb                	mov    %ebp,%ebx
  8033ab:	29 fb                	sub    %edi,%ebx
  8033ad:	89 f9                	mov    %edi,%ecx
  8033af:	d3 e6                	shl    %cl,%esi
  8033b1:	89 c5                	mov    %eax,%ebp
  8033b3:	88 d9                	mov    %bl,%cl
  8033b5:	d3 ed                	shr    %cl,%ebp
  8033b7:	89 e9                	mov    %ebp,%ecx
  8033b9:	09 f1                	or     %esi,%ecx
  8033bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033bf:	89 f9                	mov    %edi,%ecx
  8033c1:	d3 e0                	shl    %cl,%eax
  8033c3:	89 c5                	mov    %eax,%ebp
  8033c5:	89 d6                	mov    %edx,%esi
  8033c7:	88 d9                	mov    %bl,%cl
  8033c9:	d3 ee                	shr    %cl,%esi
  8033cb:	89 f9                	mov    %edi,%ecx
  8033cd:	d3 e2                	shl    %cl,%edx
  8033cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d3:	88 d9                	mov    %bl,%cl
  8033d5:	d3 e8                	shr    %cl,%eax
  8033d7:	09 c2                	or     %eax,%edx
  8033d9:	89 d0                	mov    %edx,%eax
  8033db:	89 f2                	mov    %esi,%edx
  8033dd:	f7 74 24 0c          	divl   0xc(%esp)
  8033e1:	89 d6                	mov    %edx,%esi
  8033e3:	89 c3                	mov    %eax,%ebx
  8033e5:	f7 e5                	mul    %ebp
  8033e7:	39 d6                	cmp    %edx,%esi
  8033e9:	72 19                	jb     803404 <__udivdi3+0xfc>
  8033eb:	74 0b                	je     8033f8 <__udivdi3+0xf0>
  8033ed:	89 d8                	mov    %ebx,%eax
  8033ef:	31 ff                	xor    %edi,%edi
  8033f1:	e9 58 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  8033f6:	66 90                	xchg   %ax,%ax
  8033f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033fc:	89 f9                	mov    %edi,%ecx
  8033fe:	d3 e2                	shl    %cl,%edx
  803400:	39 c2                	cmp    %eax,%edx
  803402:	73 e9                	jae    8033ed <__udivdi3+0xe5>
  803404:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803407:	31 ff                	xor    %edi,%edi
  803409:	e9 40 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  80340e:	66 90                	xchg   %ax,%ax
  803410:	31 c0                	xor    %eax,%eax
  803412:	e9 37 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  803417:	90                   	nop

00803418 <__umoddi3>:
  803418:	55                   	push   %ebp
  803419:	57                   	push   %edi
  80341a:	56                   	push   %esi
  80341b:	53                   	push   %ebx
  80341c:	83 ec 1c             	sub    $0x1c,%esp
  80341f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803423:	8b 74 24 34          	mov    0x34(%esp),%esi
  803427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80342f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803433:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803437:	89 f3                	mov    %esi,%ebx
  803439:	89 fa                	mov    %edi,%edx
  80343b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80343f:	89 34 24             	mov    %esi,(%esp)
  803442:	85 c0                	test   %eax,%eax
  803444:	75 1a                	jne    803460 <__umoddi3+0x48>
  803446:	39 f7                	cmp    %esi,%edi
  803448:	0f 86 a2 00 00 00    	jbe    8034f0 <__umoddi3+0xd8>
  80344e:	89 c8                	mov    %ecx,%eax
  803450:	89 f2                	mov    %esi,%edx
  803452:	f7 f7                	div    %edi
  803454:	89 d0                	mov    %edx,%eax
  803456:	31 d2                	xor    %edx,%edx
  803458:	83 c4 1c             	add    $0x1c,%esp
  80345b:	5b                   	pop    %ebx
  80345c:	5e                   	pop    %esi
  80345d:	5f                   	pop    %edi
  80345e:	5d                   	pop    %ebp
  80345f:	c3                   	ret    
  803460:	39 f0                	cmp    %esi,%eax
  803462:	0f 87 ac 00 00 00    	ja     803514 <__umoddi3+0xfc>
  803468:	0f bd e8             	bsr    %eax,%ebp
  80346b:	83 f5 1f             	xor    $0x1f,%ebp
  80346e:	0f 84 ac 00 00 00    	je     803520 <__umoddi3+0x108>
  803474:	bf 20 00 00 00       	mov    $0x20,%edi
  803479:	29 ef                	sub    %ebp,%edi
  80347b:	89 fe                	mov    %edi,%esi
  80347d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803481:	89 e9                	mov    %ebp,%ecx
  803483:	d3 e0                	shl    %cl,%eax
  803485:	89 d7                	mov    %edx,%edi
  803487:	89 f1                	mov    %esi,%ecx
  803489:	d3 ef                	shr    %cl,%edi
  80348b:	09 c7                	or     %eax,%edi
  80348d:	89 e9                	mov    %ebp,%ecx
  80348f:	d3 e2                	shl    %cl,%edx
  803491:	89 14 24             	mov    %edx,(%esp)
  803494:	89 d8                	mov    %ebx,%eax
  803496:	d3 e0                	shl    %cl,%eax
  803498:	89 c2                	mov    %eax,%edx
  80349a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80349e:	d3 e0                	shl    %cl,%eax
  8034a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a8:	89 f1                	mov    %esi,%ecx
  8034aa:	d3 e8                	shr    %cl,%eax
  8034ac:	09 d0                	or     %edx,%eax
  8034ae:	d3 eb                	shr    %cl,%ebx
  8034b0:	89 da                	mov    %ebx,%edx
  8034b2:	f7 f7                	div    %edi
  8034b4:	89 d3                	mov    %edx,%ebx
  8034b6:	f7 24 24             	mull   (%esp)
  8034b9:	89 c6                	mov    %eax,%esi
  8034bb:	89 d1                	mov    %edx,%ecx
  8034bd:	39 d3                	cmp    %edx,%ebx
  8034bf:	0f 82 87 00 00 00    	jb     80354c <__umoddi3+0x134>
  8034c5:	0f 84 91 00 00 00    	je     80355c <__umoddi3+0x144>
  8034cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034cf:	29 f2                	sub    %esi,%edx
  8034d1:	19 cb                	sbb    %ecx,%ebx
  8034d3:	89 d8                	mov    %ebx,%eax
  8034d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034d9:	d3 e0                	shl    %cl,%eax
  8034db:	89 e9                	mov    %ebp,%ecx
  8034dd:	d3 ea                	shr    %cl,%edx
  8034df:	09 d0                	or     %edx,%eax
  8034e1:	89 e9                	mov    %ebp,%ecx
  8034e3:	d3 eb                	shr    %cl,%ebx
  8034e5:	89 da                	mov    %ebx,%edx
  8034e7:	83 c4 1c             	add    $0x1c,%esp
  8034ea:	5b                   	pop    %ebx
  8034eb:	5e                   	pop    %esi
  8034ec:	5f                   	pop    %edi
  8034ed:	5d                   	pop    %ebp
  8034ee:	c3                   	ret    
  8034ef:	90                   	nop
  8034f0:	89 fd                	mov    %edi,%ebp
  8034f2:	85 ff                	test   %edi,%edi
  8034f4:	75 0b                	jne    803501 <__umoddi3+0xe9>
  8034f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fb:	31 d2                	xor    %edx,%edx
  8034fd:	f7 f7                	div    %edi
  8034ff:	89 c5                	mov    %eax,%ebp
  803501:	89 f0                	mov    %esi,%eax
  803503:	31 d2                	xor    %edx,%edx
  803505:	f7 f5                	div    %ebp
  803507:	89 c8                	mov    %ecx,%eax
  803509:	f7 f5                	div    %ebp
  80350b:	89 d0                	mov    %edx,%eax
  80350d:	e9 44 ff ff ff       	jmp    803456 <__umoddi3+0x3e>
  803512:	66 90                	xchg   %ax,%ax
  803514:	89 c8                	mov    %ecx,%eax
  803516:	89 f2                	mov    %esi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	3b 04 24             	cmp    (%esp),%eax
  803523:	72 06                	jb     80352b <__umoddi3+0x113>
  803525:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803529:	77 0f                	ja     80353a <__umoddi3+0x122>
  80352b:	89 f2                	mov    %esi,%edx
  80352d:	29 f9                	sub    %edi,%ecx
  80352f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803533:	89 14 24             	mov    %edx,(%esp)
  803536:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80353e:	8b 14 24             	mov    (%esp),%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	2b 04 24             	sub    (%esp),%eax
  80354f:	19 fa                	sbb    %edi,%edx
  803551:	89 d1                	mov    %edx,%ecx
  803553:	89 c6                	mov    %eax,%esi
  803555:	e9 71 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803560:	72 ea                	jb     80354c <__umoddi3+0x134>
  803562:	89 d9                	mov    %ebx,%ecx
  803564:	e9 62 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
