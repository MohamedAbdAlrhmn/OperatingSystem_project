
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 3e 01 00 00       	call   800174 <libmain>
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
  80003b:	83 ec 18             	sub    $0x18,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 30 80 00       	mov    0x803020,%eax
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
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
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
  80008c:	68 c0 1d 80 00       	push   $0x801dc0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 1d 80 00       	push   $0x801ddc
  800098:	e8 13 02 00 00       	call   8002b0 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 6e 17 00 00       	call   801810 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 f9 1d 80 00       	push   $0x801df9
  8000aa:	50                   	push   %eax
  8000ab:	e8 d3 12 00 00       	call   801383 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 fc 1d 80 00       	push   $0x801dfc
  8000be:	e8 a1 04 00 00       	call   800564 <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 24 1e 80 00       	push   $0x801e24
  8000ce:	e8 91 04 00 00       	call   800564 <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 a6 19 00 00       	call   801a89 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 2c 14 00 00       	call   801517 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 be 12 00 00       	call   8013b7 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 44 1e 80 00       	push   $0x801e44
  800104:	e8 5b 04 00 00       	call   800564 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 06 14 00 00       	call   801517 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 5c 1e 80 00       	push   $0x801e5c
  800127:	6a 20                	push   $0x20
  800129:	68 dc 1d 80 00       	push   $0x801ddc
  80012e:	e8 7d 01 00 00       	call   8002b0 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 17 18 00 00       	call   80194f <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 fc 1e 80 00       	push   $0x801efc
  800145:	6a 23                	push   $0x23
  800147:	68 dc 1d 80 00       	push   $0x801ddc
  80014c:	e8 5f 01 00 00       	call   8002b0 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 08 1f 80 00       	push   $0x801f08
  800159:	e8 06 04 00 00       	call   800564 <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 2c 1f 80 00       	push   $0x801f2c
  800169:	e8 f6 03 00 00       	call   800564 <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	return;
  800171:	90                   	nop
}
  800172:	c9                   	leave  
  800173:	c3                   	ret    

00800174 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80017a:	e8 78 16 00 00       	call   8017f7 <sys_getenvindex>
  80017f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800185:	89 d0                	mov    %edx,%eax
  800187:	c1 e0 03             	shl    $0x3,%eax
  80018a:	01 d0                	add    %edx,%eax
  80018c:	01 c0                	add    %eax,%eax
  80018e:	01 d0                	add    %edx,%eax
  800190:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800197:	01 d0                	add    %edx,%eax
  800199:	c1 e0 04             	shl    $0x4,%eax
  80019c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a1:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ab:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b1:	84 c0                	test   %al,%al
  8001b3:	74 0f                	je     8001c4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ba:	05 5c 05 00 00       	add    $0x55c,%eax
  8001bf:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c8:	7e 0a                	jle    8001d4 <libmain+0x60>
		binaryname = argv[0];
  8001ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001cd:	8b 00                	mov    (%eax),%eax
  8001cf:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	ff 75 0c             	pushl  0xc(%ebp)
  8001da:	ff 75 08             	pushl  0x8(%ebp)
  8001dd:	e8 56 fe ff ff       	call   800038 <_main>
  8001e2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001e5:	e8 1a 14 00 00       	call   801604 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	68 90 1f 80 00       	push   $0x801f90
  8001f2:	e8 6d 03 00 00       	call   800564 <cprintf>
  8001f7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001fa:	a1 20 30 80 00       	mov    0x803020,%eax
  8001ff:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800205:	a1 20 30 80 00       	mov    0x803020,%eax
  80020a:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 b8 1f 80 00       	push   $0x801fb8
  80021a:	e8 45 03 00 00       	call   800564 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800222:	a1 20 30 80 00       	mov    0x803020,%eax
  800227:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80022d:	a1 20 30 80 00       	mov    0x803020,%eax
  800232:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800238:	a1 20 30 80 00       	mov    0x803020,%eax
  80023d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800243:	51                   	push   %ecx
  800244:	52                   	push   %edx
  800245:	50                   	push   %eax
  800246:	68 e0 1f 80 00       	push   $0x801fe0
  80024b:	e8 14 03 00 00       	call   800564 <cprintf>
  800250:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800253:	a1 20 30 80 00       	mov    0x803020,%eax
  800258:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80025e:	83 ec 08             	sub    $0x8,%esp
  800261:	50                   	push   %eax
  800262:	68 38 20 80 00       	push   $0x802038
  800267:	e8 f8 02 00 00       	call   800564 <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 90 1f 80 00       	push   $0x801f90
  800277:	e8 e8 02 00 00       	call   800564 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80027f:	e8 9a 13 00 00       	call   80161e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800284:	e8 19 00 00 00       	call   8002a2 <exit>
}
  800289:	90                   	nop
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 00                	push   $0x0
  800297:	e8 27 15 00 00       	call   8017c3 <sys_destroy_env>
  80029c:	83 c4 10             	add    $0x10,%esp
}
  80029f:	90                   	nop
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <exit>:

void
exit(void)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a8:	e8 7c 15 00 00       	call   801829 <sys_exit_env>
}
  8002ad:	90                   	nop
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002b6:	8d 45 10             	lea    0x10(%ebp),%eax
  8002b9:	83 c0 04             	add    $0x4,%eax
  8002bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002bf:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	74 16                	je     8002de <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002c8:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8002cd:	83 ec 08             	sub    $0x8,%esp
  8002d0:	50                   	push   %eax
  8002d1:	68 4c 20 80 00       	push   $0x80204c
  8002d6:	e8 89 02 00 00       	call   800564 <cprintf>
  8002db:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002de:	a1 00 30 80 00       	mov    0x803000,%eax
  8002e3:	ff 75 0c             	pushl  0xc(%ebp)
  8002e6:	ff 75 08             	pushl  0x8(%ebp)
  8002e9:	50                   	push   %eax
  8002ea:	68 51 20 80 00       	push   $0x802051
  8002ef:	e8 70 02 00 00       	call   800564 <cprintf>
  8002f4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fa:	83 ec 08             	sub    $0x8,%esp
  8002fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800300:	50                   	push   %eax
  800301:	e8 f3 01 00 00       	call   8004f9 <vcprintf>
  800306:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	6a 00                	push   $0x0
  80030e:	68 6d 20 80 00       	push   $0x80206d
  800313:	e8 e1 01 00 00       	call   8004f9 <vcprintf>
  800318:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80031b:	e8 82 ff ff ff       	call   8002a2 <exit>

	// should not return here
	while (1) ;
  800320:	eb fe                	jmp    800320 <_panic+0x70>

00800322 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800328:	a1 20 30 80 00       	mov    0x803020,%eax
  80032d:	8b 50 74             	mov    0x74(%eax),%edx
  800330:	8b 45 0c             	mov    0xc(%ebp),%eax
  800333:	39 c2                	cmp    %eax,%edx
  800335:	74 14                	je     80034b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 70 20 80 00       	push   $0x802070
  80033f:	6a 26                	push   $0x26
  800341:	68 bc 20 80 00       	push   $0x8020bc
  800346:	e8 65 ff ff ff       	call   8002b0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80034b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800352:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800359:	e9 c2 00 00 00       	jmp    800420 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80035e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800368:	8b 45 08             	mov    0x8(%ebp),%eax
  80036b:	01 d0                	add    %edx,%eax
  80036d:	8b 00                	mov    (%eax),%eax
  80036f:	85 c0                	test   %eax,%eax
  800371:	75 08                	jne    80037b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800373:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800376:	e9 a2 00 00 00       	jmp    80041d <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80037b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800382:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800389:	eb 69                	jmp    8003f4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80038b:	a1 20 30 80 00       	mov    0x803020,%eax
  800390:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800399:	89 d0                	mov    %edx,%eax
  80039b:	01 c0                	add    %eax,%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c1 e0 03             	shl    $0x3,%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8a 40 04             	mov    0x4(%eax),%al
  8003a7:	84 c0                	test   %al,%al
  8003a9:	75 46                	jne    8003f1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	a1 20 30 80 00       	mov    0x803020,%eax
  8003b0:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b9:	89 d0                	mov    %edx,%eax
  8003bb:	01 c0                	add    %eax,%eax
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 03             	shl    $0x3,%eax
  8003c2:	01 c8                	add    %ecx,%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	39 c2                	cmp    %eax,%edx
  8003e6:	75 09                	jne    8003f1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003e8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003ef:	eb 12                	jmp    800403 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f1:	ff 45 e8             	incl   -0x18(%ebp)
  8003f4:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f9:	8b 50 74             	mov    0x74(%eax),%edx
  8003fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ff:	39 c2                	cmp    %eax,%edx
  800401:	77 88                	ja     80038b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800403:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800407:	75 14                	jne    80041d <CheckWSWithoutLastIndex+0xfb>
			panic(
  800409:	83 ec 04             	sub    $0x4,%esp
  80040c:	68 c8 20 80 00       	push   $0x8020c8
  800411:	6a 3a                	push   $0x3a
  800413:	68 bc 20 80 00       	push   $0x8020bc
  800418:	e8 93 fe ff ff       	call   8002b0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80041d:	ff 45 f0             	incl   -0x10(%ebp)
  800420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800423:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800426:	0f 8c 32 ff ff ff    	jl     80035e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80042c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800433:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80043a:	eb 26                	jmp    800462 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80043c:	a1 20 30 80 00       	mov    0x803020,%eax
  800441:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800447:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80044a:	89 d0                	mov    %edx,%eax
  80044c:	01 c0                	add    %eax,%eax
  80044e:	01 d0                	add    %edx,%eax
  800450:	c1 e0 03             	shl    $0x3,%eax
  800453:	01 c8                	add    %ecx,%eax
  800455:	8a 40 04             	mov    0x4(%eax),%al
  800458:	3c 01                	cmp    $0x1,%al
  80045a:	75 03                	jne    80045f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80045c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045f:	ff 45 e0             	incl   -0x20(%ebp)
  800462:	a1 20 30 80 00       	mov    0x803020,%eax
  800467:	8b 50 74             	mov    0x74(%eax),%edx
  80046a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80046d:	39 c2                	cmp    %eax,%edx
  80046f:	77 cb                	ja     80043c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800474:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800477:	74 14                	je     80048d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800479:	83 ec 04             	sub    $0x4,%esp
  80047c:	68 1c 21 80 00       	push   $0x80211c
  800481:	6a 44                	push   $0x44
  800483:	68 bc 20 80 00       	push   $0x8020bc
  800488:	e8 23 fe ff ff       	call   8002b0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80048d:	90                   	nop
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800496:	8b 45 0c             	mov    0xc(%ebp),%eax
  800499:	8b 00                	mov    (%eax),%eax
  80049b:	8d 48 01             	lea    0x1(%eax),%ecx
  80049e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a1:	89 0a                	mov    %ecx,(%edx)
  8004a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a6:	88 d1                	mov    %dl,%cl
  8004a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ab:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004b9:	75 2c                	jne    8004e7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bb:	a0 24 30 80 00       	mov    0x803024,%al
  8004c0:	0f b6 c0             	movzbl %al,%eax
  8004c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c6:	8b 12                	mov    (%edx),%edx
  8004c8:	89 d1                	mov    %edx,%ecx
  8004ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cd:	83 c2 08             	add    $0x8,%edx
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	50                   	push   %eax
  8004d4:	51                   	push   %ecx
  8004d5:	52                   	push   %edx
  8004d6:	e8 7b 0f 00 00       	call   801456 <sys_cputs>
  8004db:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ea:	8b 40 04             	mov    0x4(%eax),%eax
  8004ed:	8d 50 01             	lea    0x1(%eax),%edx
  8004f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f6:	90                   	nop
  8004f7:	c9                   	leave  
  8004f8:	c3                   	ret    

008004f9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800502:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800509:	00 00 00 
	b.cnt = 0;
  80050c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800513:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800516:	ff 75 0c             	pushl  0xc(%ebp)
  800519:	ff 75 08             	pushl  0x8(%ebp)
  80051c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800522:	50                   	push   %eax
  800523:	68 90 04 80 00       	push   $0x800490
  800528:	e8 11 02 00 00       	call   80073e <vprintfmt>
  80052d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800530:	a0 24 30 80 00       	mov    0x803024,%al
  800535:	0f b6 c0             	movzbl %al,%eax
  800538:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80053e:	83 ec 04             	sub    $0x4,%esp
  800541:	50                   	push   %eax
  800542:	52                   	push   %edx
  800543:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800549:	83 c0 08             	add    $0x8,%eax
  80054c:	50                   	push   %eax
  80054d:	e8 04 0f 00 00       	call   801456 <sys_cputs>
  800552:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800555:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80055c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800562:	c9                   	leave  
  800563:	c3                   	ret    

00800564 <cprintf>:

int cprintf(const char *fmt, ...) {
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056a:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800571:	8d 45 0c             	lea    0xc(%ebp),%eax
  800574:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	ff 75 f4             	pushl  -0xc(%ebp)
  800580:	50                   	push   %eax
  800581:	e8 73 ff ff ff       	call   8004f9 <vcprintf>
  800586:	83 c4 10             	add    $0x10,%esp
  800589:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058f:	c9                   	leave  
  800590:	c3                   	ret    

00800591 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800591:	55                   	push   %ebp
  800592:	89 e5                	mov    %esp,%ebp
  800594:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800597:	e8 68 10 00 00       	call   801604 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80059f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a5:	83 ec 08             	sub    $0x8,%esp
  8005a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ab:	50                   	push   %eax
  8005ac:	e8 48 ff ff ff       	call   8004f9 <vcprintf>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b7:	e8 62 10 00 00       	call   80161e <sys_enable_interrupt>
	return cnt;
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005bf:	c9                   	leave  
  8005c0:	c3                   	ret    

008005c1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c1:	55                   	push   %ebp
  8005c2:	89 e5                	mov    %esp,%ebp
  8005c4:	53                   	push   %ebx
  8005c5:	83 ec 14             	sub    $0x14,%esp
  8005c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005dc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005df:	77 55                	ja     800636 <printnum+0x75>
  8005e1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e4:	72 05                	jb     8005eb <printnum+0x2a>
  8005e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005e9:	77 4b                	ja     800636 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005eb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f9:	52                   	push   %edx
  8005fa:	50                   	push   %eax
  8005fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fe:	ff 75 f0             	pushl  -0x10(%ebp)
  800601:	e8 3a 15 00 00       	call   801b40 <__udivdi3>
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	83 ec 04             	sub    $0x4,%esp
  80060c:	ff 75 20             	pushl  0x20(%ebp)
  80060f:	53                   	push   %ebx
  800610:	ff 75 18             	pushl  0x18(%ebp)
  800613:	52                   	push   %edx
  800614:	50                   	push   %eax
  800615:	ff 75 0c             	pushl  0xc(%ebp)
  800618:	ff 75 08             	pushl  0x8(%ebp)
  80061b:	e8 a1 ff ff ff       	call   8005c1 <printnum>
  800620:	83 c4 20             	add    $0x20,%esp
  800623:	eb 1a                	jmp    80063f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	ff 75 20             	pushl  0x20(%ebp)
  80062e:	8b 45 08             	mov    0x8(%ebp),%eax
  800631:	ff d0                	call   *%eax
  800633:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800636:	ff 4d 1c             	decl   0x1c(%ebp)
  800639:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063d:	7f e6                	jg     800625 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80063f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800642:	bb 00 00 00 00       	mov    $0x0,%ebx
  800647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064d:	53                   	push   %ebx
  80064e:	51                   	push   %ecx
  80064f:	52                   	push   %edx
  800650:	50                   	push   %eax
  800651:	e8 fa 15 00 00       	call   801c50 <__umoddi3>
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	05 94 23 80 00       	add    $0x802394,%eax
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f be c0             	movsbl %al,%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 0c             	pushl  0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	ff d0                	call   *%eax
  80066f:	83 c4 10             	add    $0x10,%esp
}
  800672:	90                   	nop
  800673:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800676:	c9                   	leave  
  800677:	c3                   	ret    

00800678 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80067f:	7e 1c                	jle    80069d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	8d 50 08             	lea    0x8(%eax),%edx
  800689:	8b 45 08             	mov    0x8(%ebp),%eax
  80068c:	89 10                	mov    %edx,(%eax)
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	83 e8 08             	sub    $0x8,%eax
  800696:	8b 50 04             	mov    0x4(%eax),%edx
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	eb 40                	jmp    8006dd <getuint+0x65>
	else if (lflag)
  80069d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a1:	74 1e                	je     8006c1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	8d 50 04             	lea    0x4(%eax),%edx
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	89 10                	mov    %edx,(%eax)
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	83 e8 04             	sub    $0x4,%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bf:	eb 1c                	jmp    8006dd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	89 10                	mov    %edx,(%eax)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	83 e8 04             	sub    $0x4,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006dd:	5d                   	pop    %ebp
  8006de:	c3                   	ret    

008006df <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006df:	55                   	push   %ebp
  8006e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e6:	7e 1c                	jle    800704 <getint+0x25>
		return va_arg(*ap, long long);
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	8b 00                	mov    (%eax),%eax
  8006ed:	8d 50 08             	lea    0x8(%eax),%edx
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	89 10                	mov    %edx,(%eax)
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	83 e8 08             	sub    $0x8,%eax
  8006fd:	8b 50 04             	mov    0x4(%eax),%edx
  800700:	8b 00                	mov    (%eax),%eax
  800702:	eb 38                	jmp    80073c <getint+0x5d>
	else if (lflag)
  800704:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800708:	74 1a                	je     800724 <getint+0x45>
		return va_arg(*ap, long);
  80070a:	8b 45 08             	mov    0x8(%ebp),%eax
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	8d 50 04             	lea    0x4(%eax),%edx
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	89 10                	mov    %edx,(%eax)
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	83 e8 04             	sub    $0x4,%eax
  80071f:	8b 00                	mov    (%eax),%eax
  800721:	99                   	cltd   
  800722:	eb 18                	jmp    80073c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	8d 50 04             	lea    0x4(%eax),%edx
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	89 10                	mov    %edx,(%eax)
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	83 e8 04             	sub    $0x4,%eax
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	99                   	cltd   
}
  80073c:	5d                   	pop    %ebp
  80073d:	c3                   	ret    

0080073e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80073e:	55                   	push   %ebp
  80073f:	89 e5                	mov    %esp,%ebp
  800741:	56                   	push   %esi
  800742:	53                   	push   %ebx
  800743:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800746:	eb 17                	jmp    80075f <vprintfmt+0x21>
			if (ch == '\0')
  800748:	85 db                	test   %ebx,%ebx
  80074a:	0f 84 af 03 00 00    	je     800aff <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	53                   	push   %ebx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075f:	8b 45 10             	mov    0x10(%ebp),%eax
  800762:	8d 50 01             	lea    0x1(%eax),%edx
  800765:	89 55 10             	mov    %edx,0x10(%ebp)
  800768:	8a 00                	mov    (%eax),%al
  80076a:	0f b6 d8             	movzbl %al,%ebx
  80076d:	83 fb 25             	cmp    $0x25,%ebx
  800770:	75 d6                	jne    800748 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800772:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800776:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800784:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800792:	8b 45 10             	mov    0x10(%ebp),%eax
  800795:	8d 50 01             	lea    0x1(%eax),%edx
  800798:	89 55 10             	mov    %edx,0x10(%ebp)
  80079b:	8a 00                	mov    (%eax),%al
  80079d:	0f b6 d8             	movzbl %al,%ebx
  8007a0:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a3:	83 f8 55             	cmp    $0x55,%eax
  8007a6:	0f 87 2b 03 00 00    	ja     800ad7 <vprintfmt+0x399>
  8007ac:	8b 04 85 b8 23 80 00 	mov    0x8023b8(,%eax,4),%eax
  8007b3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007b9:	eb d7                	jmp    800792 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d1                	jmp    800792 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cb:	89 d0                	mov    %edx,%eax
  8007cd:	c1 e0 02             	shl    $0x2,%eax
  8007d0:	01 d0                	add    %edx,%eax
  8007d2:	01 c0                	add    %eax,%eax
  8007d4:	01 d8                	add    %ebx,%eax
  8007d6:	83 e8 30             	sub    $0x30,%eax
  8007d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007df:	8a 00                	mov    (%eax),%al
  8007e1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e7:	7e 3e                	jle    800827 <vprintfmt+0xe9>
  8007e9:	83 fb 39             	cmp    $0x39,%ebx
  8007ec:	7f 39                	jg     800827 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ee:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f1:	eb d5                	jmp    8007c8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	83 c0 04             	add    $0x4,%eax
  8007f9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	83 e8 04             	sub    $0x4,%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800807:	eb 1f                	jmp    800828 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800809:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080d:	79 83                	jns    800792 <vprintfmt+0x54>
				width = 0;
  80080f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800816:	e9 77 ff ff ff       	jmp    800792 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800822:	e9 6b ff ff ff       	jmp    800792 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800827:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800828:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082c:	0f 89 60 ff ff ff    	jns    800792 <vprintfmt+0x54>
				width = precision, precision = -1;
  800832:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800838:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80083f:	e9 4e ff ff ff       	jmp    800792 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800844:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800847:	e9 46 ff ff ff       	jmp    800792 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 c0 04             	add    $0x4,%eax
  800852:	89 45 14             	mov    %eax,0x14(%ebp)
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	83 e8 04             	sub    $0x4,%eax
  80085b:	8b 00                	mov    (%eax),%eax
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	50                   	push   %eax
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	ff d0                	call   *%eax
  800869:	83 c4 10             	add    $0x10,%esp
			break;
  80086c:	e9 89 02 00 00       	jmp    800afa <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	83 c0 04             	add    $0x4,%eax
  800877:	89 45 14             	mov    %eax,0x14(%ebp)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	83 e8 04             	sub    $0x4,%eax
  800880:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800882:	85 db                	test   %ebx,%ebx
  800884:	79 02                	jns    800888 <vprintfmt+0x14a>
				err = -err;
  800886:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800888:	83 fb 64             	cmp    $0x64,%ebx
  80088b:	7f 0b                	jg     800898 <vprintfmt+0x15a>
  80088d:	8b 34 9d 00 22 80 00 	mov    0x802200(,%ebx,4),%esi
  800894:	85 f6                	test   %esi,%esi
  800896:	75 19                	jne    8008b1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800898:	53                   	push   %ebx
  800899:	68 a5 23 80 00       	push   $0x8023a5
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	ff 75 08             	pushl  0x8(%ebp)
  8008a4:	e8 5e 02 00 00       	call   800b07 <printfmt>
  8008a9:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ac:	e9 49 02 00 00       	jmp    800afa <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b1:	56                   	push   %esi
  8008b2:	68 ae 23 80 00       	push   $0x8023ae
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	ff 75 08             	pushl  0x8(%ebp)
  8008bd:	e8 45 02 00 00       	call   800b07 <printfmt>
  8008c2:	83 c4 10             	add    $0x10,%esp
			break;
  8008c5:	e9 30 02 00 00       	jmp    800afa <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 c0 04             	add    $0x4,%eax
  8008d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 e8 04             	sub    $0x4,%eax
  8008d9:	8b 30                	mov    (%eax),%esi
  8008db:	85 f6                	test   %esi,%esi
  8008dd:	75 05                	jne    8008e4 <vprintfmt+0x1a6>
				p = "(null)";
  8008df:	be b1 23 80 00       	mov    $0x8023b1,%esi
			if (width > 0 && padc != '-')
  8008e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e8:	7e 6d                	jle    800957 <vprintfmt+0x219>
  8008ea:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ee:	74 67                	je     800957 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	83 ec 08             	sub    $0x8,%esp
  8008f6:	50                   	push   %eax
  8008f7:	56                   	push   %esi
  8008f8:	e8 0c 03 00 00       	call   800c09 <strnlen>
  8008fd:	83 c4 10             	add    $0x10,%esp
  800900:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800903:	eb 16                	jmp    80091b <vprintfmt+0x1dd>
					putch(padc, putdat);
  800905:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800909:	83 ec 08             	sub    $0x8,%esp
  80090c:	ff 75 0c             	pushl  0xc(%ebp)
  80090f:	50                   	push   %eax
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	ff d0                	call   *%eax
  800915:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800918:	ff 4d e4             	decl   -0x1c(%ebp)
  80091b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091f:	7f e4                	jg     800905 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800921:	eb 34                	jmp    800957 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800923:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800927:	74 1c                	je     800945 <vprintfmt+0x207>
  800929:	83 fb 1f             	cmp    $0x1f,%ebx
  80092c:	7e 05                	jle    800933 <vprintfmt+0x1f5>
  80092e:	83 fb 7e             	cmp    $0x7e,%ebx
  800931:	7e 12                	jle    800945 <vprintfmt+0x207>
					putch('?', putdat);
  800933:	83 ec 08             	sub    $0x8,%esp
  800936:	ff 75 0c             	pushl  0xc(%ebp)
  800939:	6a 3f                	push   $0x3f
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	ff d0                	call   *%eax
  800940:	83 c4 10             	add    $0x10,%esp
  800943:	eb 0f                	jmp    800954 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	53                   	push   %ebx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800954:	ff 4d e4             	decl   -0x1c(%ebp)
  800957:	89 f0                	mov    %esi,%eax
  800959:	8d 70 01             	lea    0x1(%eax),%esi
  80095c:	8a 00                	mov    (%eax),%al
  80095e:	0f be d8             	movsbl %al,%ebx
  800961:	85 db                	test   %ebx,%ebx
  800963:	74 24                	je     800989 <vprintfmt+0x24b>
  800965:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800969:	78 b8                	js     800923 <vprintfmt+0x1e5>
  80096b:	ff 4d e0             	decl   -0x20(%ebp)
  80096e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800972:	79 af                	jns    800923 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800974:	eb 13                	jmp    800989 <vprintfmt+0x24b>
				putch(' ', putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	6a 20                	push   $0x20
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	ff d0                	call   *%eax
  800983:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800986:	ff 4d e4             	decl   -0x1c(%ebp)
  800989:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098d:	7f e7                	jg     800976 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80098f:	e9 66 01 00 00       	jmp    800afa <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 e8             	pushl  -0x18(%ebp)
  80099a:	8d 45 14             	lea    0x14(%ebp),%eax
  80099d:	50                   	push   %eax
  80099e:	e8 3c fd ff ff       	call   8006df <getint>
  8009a3:	83 c4 10             	add    $0x10,%esp
  8009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b2:	85 d2                	test   %edx,%edx
  8009b4:	79 23                	jns    8009d9 <vprintfmt+0x29b>
				putch('-', putdat);
  8009b6:	83 ec 08             	sub    $0x8,%esp
  8009b9:	ff 75 0c             	pushl  0xc(%ebp)
  8009bc:	6a 2d                	push   $0x2d
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	ff d0                	call   *%eax
  8009c3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009cc:	f7 d8                	neg    %eax
  8009ce:	83 d2 00             	adc    $0x0,%edx
  8009d1:	f7 da                	neg    %edx
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009d9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e0:	e9 bc 00 00 00       	jmp    800aa1 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ee:	50                   	push   %eax
  8009ef:	e8 84 fc ff ff       	call   800678 <getuint>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009fd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a04:	e9 98 00 00 00       	jmp    800aa1 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	6a 58                	push   $0x58
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	ff d0                	call   *%eax
  800a26:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a29:	83 ec 08             	sub    $0x8,%esp
  800a2c:	ff 75 0c             	pushl  0xc(%ebp)
  800a2f:	6a 58                	push   $0x58
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
			break;
  800a39:	e9 bc 00 00 00       	jmp    800afa <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a3e:	83 ec 08             	sub    $0x8,%esp
  800a41:	ff 75 0c             	pushl  0xc(%ebp)
  800a44:	6a 30                	push   $0x30
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	ff d0                	call   *%eax
  800a4b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 0c             	pushl  0xc(%ebp)
  800a54:	6a 78                	push   $0x78
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a61:	83 c0 04             	add    $0x4,%eax
  800a64:	89 45 14             	mov    %eax,0x14(%ebp)
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	83 e8 04             	sub    $0x4,%eax
  800a6d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a79:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a80:	eb 1f                	jmp    800aa1 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 e8             	pushl  -0x18(%ebp)
  800a88:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8b:	50                   	push   %eax
  800a8c:	e8 e7 fb ff ff       	call   800678 <getuint>
  800a91:	83 c4 10             	add    $0x10,%esp
  800a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a97:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa8:	83 ec 04             	sub    $0x4,%esp
  800aab:	52                   	push   %edx
  800aac:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aaf:	50                   	push   %eax
  800ab0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab3:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	ff 75 08             	pushl  0x8(%ebp)
  800abc:	e8 00 fb ff ff       	call   8005c1 <printnum>
  800ac1:	83 c4 20             	add    $0x20,%esp
			break;
  800ac4:	eb 34                	jmp    800afa <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	53                   	push   %ebx
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	ff d0                	call   *%eax
  800ad2:	83 c4 10             	add    $0x10,%esp
			break;
  800ad5:	eb 23                	jmp    800afa <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 25                	push   $0x25
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae7:	ff 4d 10             	decl   0x10(%ebp)
  800aea:	eb 03                	jmp    800aef <vprintfmt+0x3b1>
  800aec:	ff 4d 10             	decl   0x10(%ebp)
  800aef:	8b 45 10             	mov    0x10(%ebp),%eax
  800af2:	48                   	dec    %eax
  800af3:	8a 00                	mov    (%eax),%al
  800af5:	3c 25                	cmp    $0x25,%al
  800af7:	75 f3                	jne    800aec <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800af9:	90                   	nop
		}
	}
  800afa:	e9 47 fc ff ff       	jmp    800746 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aff:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b03:	5b                   	pop    %ebx
  800b04:	5e                   	pop    %esi
  800b05:	5d                   	pop    %ebp
  800b06:	c3                   	ret    

00800b07 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b0d:	8d 45 10             	lea    0x10(%ebp),%eax
  800b10:	83 c0 04             	add    $0x4,%eax
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b16:	8b 45 10             	mov    0x10(%ebp),%eax
  800b19:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1c:	50                   	push   %eax
  800b1d:	ff 75 0c             	pushl  0xc(%ebp)
  800b20:	ff 75 08             	pushl  0x8(%ebp)
  800b23:	e8 16 fc ff ff       	call   80073e <vprintfmt>
  800b28:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2b:	90                   	nop
  800b2c:	c9                   	leave  
  800b2d:	c3                   	ret    

00800b2e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8b 40 08             	mov    0x8(%eax),%eax
  800b37:	8d 50 01             	lea    0x1(%eax),%edx
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	8b 10                	mov    (%eax),%edx
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	8b 40 04             	mov    0x4(%eax),%eax
  800b4b:	39 c2                	cmp    %eax,%edx
  800b4d:	73 12                	jae    800b61 <sprintputch+0x33>
		*b->buf++ = ch;
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 00                	mov    (%eax),%eax
  800b54:	8d 48 01             	lea    0x1(%eax),%ecx
  800b57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5a:	89 0a                	mov    %ecx,(%edx)
  800b5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5f:	88 10                	mov    %dl,(%eax)
}
  800b61:	90                   	nop
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	01 d0                	add    %edx,%eax
  800b7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b89:	74 06                	je     800b91 <vsnprintf+0x2d>
  800b8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8f:	7f 07                	jg     800b98 <vsnprintf+0x34>
		return -E_INVAL;
  800b91:	b8 03 00 00 00       	mov    $0x3,%eax
  800b96:	eb 20                	jmp    800bb8 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b98:	ff 75 14             	pushl  0x14(%ebp)
  800b9b:	ff 75 10             	pushl  0x10(%ebp)
  800b9e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba1:	50                   	push   %eax
  800ba2:	68 2e 0b 80 00       	push   $0x800b2e
  800ba7:	e8 92 fb ff ff       	call   80073e <vprintfmt>
  800bac:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bb8:	c9                   	leave  
  800bb9:	c3                   	ret    

00800bba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc0:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc3:	83 c0 04             	add    $0x4,%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bcc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bcf:	50                   	push   %eax
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	ff 75 08             	pushl  0x8(%ebp)
  800bd6:	e8 89 ff ff ff       	call   800b64 <vsnprintf>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf3:	eb 06                	jmp    800bfb <strlen+0x15>
		n++;
  800bf5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf8:	ff 45 08             	incl   0x8(%ebp)
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	84 c0                	test   %al,%al
  800c02:	75 f1                	jne    800bf5 <strlen+0xf>
		n++;
	return n;
  800c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c07:	c9                   	leave  
  800c08:	c3                   	ret    

00800c09 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c09:	55                   	push   %ebp
  800c0a:	89 e5                	mov    %esp,%ebp
  800c0c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c16:	eb 09                	jmp    800c21 <strnlen+0x18>
		n++;
  800c18:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1b:	ff 45 08             	incl   0x8(%ebp)
  800c1e:	ff 4d 0c             	decl   0xc(%ebp)
  800c21:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c25:	74 09                	je     800c30 <strnlen+0x27>
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e8                	jne    800c18 <strnlen+0xf>
		n++;
	return n;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c41:	90                   	nop
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	8d 50 01             	lea    0x1(%eax),%edx
  800c48:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c51:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c54:	8a 12                	mov    (%edx),%dl
  800c56:	88 10                	mov    %dl,(%eax)
  800c58:	8a 00                	mov    (%eax),%al
  800c5a:	84 c0                	test   %al,%al
  800c5c:	75 e4                	jne    800c42 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c6f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c76:	eb 1f                	jmp    800c97 <strncpy+0x34>
		*dst++ = *src;
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c81:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c84:	8a 12                	mov    (%edx),%dl
  800c86:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	8a 00                	mov    (%eax),%al
  800c8d:	84 c0                	test   %al,%al
  800c8f:	74 03                	je     800c94 <strncpy+0x31>
			src++;
  800c91:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c94:	ff 45 fc             	incl   -0x4(%ebp)
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c9d:	72 d9                	jb     800c78 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb4:	74 30                	je     800ce6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb6:	eb 16                	jmp    800cce <strlcpy+0x2a>
			*dst++ = *src++;
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cce:	ff 4d 10             	decl   0x10(%ebp)
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	74 09                	je     800ce0 <strlcpy+0x3c>
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	84 c0                	test   %al,%al
  800cde:	75 d8                	jne    800cb8 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cec:	29 c2                	sub    %eax,%edx
  800cee:	89 d0                	mov    %edx,%eax
}
  800cf0:	c9                   	leave  
  800cf1:	c3                   	ret    

00800cf2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf5:	eb 06                	jmp    800cfd <strcmp+0xb>
		p++, q++;
  800cf7:	ff 45 08             	incl   0x8(%ebp)
  800cfa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	84 c0                	test   %al,%al
  800d04:	74 0e                	je     800d14 <strcmp+0x22>
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 10                	mov    (%eax),%dl
  800d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0e:	8a 00                	mov    (%eax),%al
  800d10:	38 c2                	cmp    %al,%dl
  800d12:	74 e3                	je     800cf7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	0f b6 d0             	movzbl %al,%edx
  800d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	0f b6 c0             	movzbl %al,%eax
  800d24:	29 c2                	sub    %eax,%edx
  800d26:	89 d0                	mov    %edx,%eax
}
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d2d:	eb 09                	jmp    800d38 <strncmp+0xe>
		n--, p++, q++;
  800d2f:	ff 4d 10             	decl   0x10(%ebp)
  800d32:	ff 45 08             	incl   0x8(%ebp)
  800d35:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3c:	74 17                	je     800d55 <strncmp+0x2b>
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	84 c0                	test   %al,%al
  800d45:	74 0e                	je     800d55 <strncmp+0x2b>
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 10                	mov    (%eax),%dl
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	38 c2                	cmp    %al,%dl
  800d53:	74 da                	je     800d2f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d59:	75 07                	jne    800d62 <strncmp+0x38>
		return 0;
  800d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d60:	eb 14                	jmp    800d76 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f b6 d0             	movzbl %al,%edx
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	0f b6 c0             	movzbl %al,%eax
  800d72:	29 c2                	sub    %eax,%edx
  800d74:	89 d0                	mov    %edx,%eax
}
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	83 ec 04             	sub    $0x4,%esp
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d84:	eb 12                	jmp    800d98 <strchr+0x20>
		if (*s == c)
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8e:	75 05                	jne    800d95 <strchr+0x1d>
			return (char *) s;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	eb 11                	jmp    800da6 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d95:	ff 45 08             	incl   0x8(%ebp)
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8a 00                	mov    (%eax),%al
  800d9d:	84 c0                	test   %al,%al
  800d9f:	75 e5                	jne    800d86 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da6:	c9                   	leave  
  800da7:	c3                   	ret    

00800da8 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	83 ec 04             	sub    $0x4,%esp
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db4:	eb 0d                	jmp    800dc3 <strfind+0x1b>
		if (*s == c)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dbe:	74 0e                	je     800dce <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc0:	ff 45 08             	incl   0x8(%ebp)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	75 ea                	jne    800db6 <strfind+0xe>
  800dcc:	eb 01                	jmp    800dcf <strfind+0x27>
		if (*s == c)
			break;
  800dce:	90                   	nop
	return (char *) s;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd2:	c9                   	leave  
  800dd3:	c3                   	ret    

00800dd4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de0:	8b 45 10             	mov    0x10(%ebp),%eax
  800de3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de6:	eb 0e                	jmp    800df6 <memset+0x22>
		*p++ = c;
  800de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800deb:	8d 50 01             	lea    0x1(%eax),%edx
  800dee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df6:	ff 4d f8             	decl   -0x8(%ebp)
  800df9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dfd:	79 e9                	jns    800de8 <memset+0x14>
		*p++ = c;

	return v;
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e16:	eb 16                	jmp    800e2e <memcpy+0x2a>
		*d++ = *s++;
  800e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1b:	8d 50 01             	lea    0x1(%eax),%edx
  800e1e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e27:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2a:	8a 12                	mov    (%edx),%dl
  800e2c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e34:	89 55 10             	mov    %edx,0x10(%ebp)
  800e37:	85 c0                	test   %eax,%eax
  800e39:	75 dd                	jne    800e18 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e58:	73 50                	jae    800eaa <memmove+0x6a>
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e60:	01 d0                	add    %edx,%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	76 43                	jbe    800eaa <memmove+0x6a>
		s += n;
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e73:	eb 10                	jmp    800e85 <memmove+0x45>
			*--d = *--s;
  800e75:	ff 4d f8             	decl   -0x8(%ebp)
  800e78:	ff 4d fc             	decl   -0x4(%ebp)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8e:	85 c0                	test   %eax,%eax
  800e90:	75 e3                	jne    800e75 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e92:	eb 23                	jmp    800eb7 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e97:	8d 50 01             	lea    0x1(%eax),%edx
  800e9a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea6:	8a 12                	mov    (%edx),%dl
  800ea8:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ead:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb0:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	75 dd                	jne    800e94 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eba:	c9                   	leave  
  800ebb:	c3                   	ret    

00800ebc <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ece:	eb 2a                	jmp    800efa <memcmp+0x3e>
		if (*s1 != *s2)
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	8a 10                	mov    (%eax),%dl
  800ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	38 c2                	cmp    %al,%dl
  800edc:	74 16                	je     800ef4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee1:	8a 00                	mov    (%eax),%al
  800ee3:	0f b6 d0             	movzbl %al,%edx
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	0f b6 c0             	movzbl %al,%eax
  800eee:	29 c2                	sub    %eax,%edx
  800ef0:	89 d0                	mov    %edx,%eax
  800ef2:	eb 18                	jmp    800f0c <memcmp+0x50>
		s1++, s2++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
  800ef7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efa:	8b 45 10             	mov    0x10(%ebp),%eax
  800efd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f00:	89 55 10             	mov    %edx,0x10(%ebp)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	75 c9                	jne    800ed0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f1f:	eb 15                	jmp    800f36 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	0f b6 d0             	movzbl %al,%edx
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	39 c2                	cmp    %eax,%edx
  800f31:	74 0d                	je     800f40 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3c:	72 e3                	jb     800f21 <memfind+0x13>
  800f3e:	eb 01                	jmp    800f41 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f40:	90                   	nop
	return (void *) s;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f53:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5a:	eb 03                	jmp    800f5f <strtol+0x19>
		s++;
  800f5c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 20                	cmp    $0x20,%al
  800f66:	74 f4                	je     800f5c <strtol+0x16>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	3c 09                	cmp    $0x9,%al
  800f6f:	74 eb                	je     800f5c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	3c 2b                	cmp    $0x2b,%al
  800f78:	75 05                	jne    800f7f <strtol+0x39>
		s++;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
  800f7d:	eb 13                	jmp    800f92 <strtol+0x4c>
	else if (*s == '-')
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 00                	mov    (%eax),%al
  800f84:	3c 2d                	cmp    $0x2d,%al
  800f86:	75 0a                	jne    800f92 <strtol+0x4c>
		s++, neg = 1;
  800f88:	ff 45 08             	incl   0x8(%ebp)
  800f8b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f96:	74 06                	je     800f9e <strtol+0x58>
  800f98:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9c:	75 20                	jne    800fbe <strtol+0x78>
  800f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa1:	8a 00                	mov    (%eax),%al
  800fa3:	3c 30                	cmp    $0x30,%al
  800fa5:	75 17                	jne    800fbe <strtol+0x78>
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	40                   	inc    %eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3c 78                	cmp    $0x78,%al
  800faf:	75 0d                	jne    800fbe <strtol+0x78>
		s += 2, base = 16;
  800fb1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbc:	eb 28                	jmp    800fe6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc2:	75 15                	jne    800fd9 <strtol+0x93>
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 30                	cmp    $0x30,%al
  800fcb:	75 0c                	jne    800fd9 <strtol+0x93>
		s++, base = 8;
  800fcd:	ff 45 08             	incl   0x8(%ebp)
  800fd0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd7:	eb 0d                	jmp    800fe6 <strtol+0xa0>
	else if (base == 0)
  800fd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdd:	75 07                	jne    800fe6 <strtol+0xa0>
		base = 10;
  800fdf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	3c 2f                	cmp    $0x2f,%al
  800fed:	7e 19                	jle    801008 <strtol+0xc2>
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3c 39                	cmp    $0x39,%al
  800ff6:	7f 10                	jg     801008 <strtol+0xc2>
			dig = *s - '0';
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f be c0             	movsbl %al,%eax
  801000:	83 e8 30             	sub    $0x30,%eax
  801003:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801006:	eb 42                	jmp    80104a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8a 00                	mov    (%eax),%al
  80100d:	3c 60                	cmp    $0x60,%al
  80100f:	7e 19                	jle    80102a <strtol+0xe4>
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	3c 7a                	cmp    $0x7a,%al
  801018:	7f 10                	jg     80102a <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	0f be c0             	movsbl %al,%eax
  801022:	83 e8 57             	sub    $0x57,%eax
  801025:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801028:	eb 20                	jmp    80104a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	3c 40                	cmp    $0x40,%al
  801031:	7e 39                	jle    80106c <strtol+0x126>
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	8a 00                	mov    (%eax),%al
  801038:	3c 5a                	cmp    $0x5a,%al
  80103a:	7f 30                	jg     80106c <strtol+0x126>
			dig = *s - 'A' + 10;
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	0f be c0             	movsbl %al,%eax
  801044:	83 e8 37             	sub    $0x37,%eax
  801047:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801050:	7d 19                	jge    80106b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801058:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105c:	89 c2                	mov    %eax,%edx
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801061:	01 d0                	add    %edx,%eax
  801063:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801066:	e9 7b ff ff ff       	jmp    800fe6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	74 08                	je     80107a <strtol+0x134>
		*endptr = (char *) s;
  801072:	8b 45 0c             	mov    0xc(%ebp),%eax
  801075:	8b 55 08             	mov    0x8(%ebp),%edx
  801078:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80107e:	74 07                	je     801087 <strtol+0x141>
  801080:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801083:	f7 d8                	neg    %eax
  801085:	eb 03                	jmp    80108a <strtol+0x144>
  801087:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    

0080108c <ltostr>:

void
ltostr(long value, char *str)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801092:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801099:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a4:	79 13                	jns    8010b9 <ltostr+0x2d>
	{
		neg = 1;
  8010a6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b3:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b6:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c1:	99                   	cltd   
  8010c2:	f7 f9                	idiv   %ecx
  8010c4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ca:	8d 50 01             	lea    0x1(%eax),%edx
  8010cd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d0:	89 c2                	mov    %eax,%edx
  8010d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d5:	01 d0                	add    %edx,%eax
  8010d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010da:	83 c2 30             	add    $0x30,%edx
  8010dd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e7:	f7 e9                	imul   %ecx
  8010e9:	c1 fa 02             	sar    $0x2,%edx
  8010ec:	89 c8                	mov    %ecx,%eax
  8010ee:	c1 f8 1f             	sar    $0x1f,%eax
  8010f1:	29 c2                	sub    %eax,%edx
  8010f3:	89 d0                	mov    %edx,%eax
  8010f5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801100:	f7 e9                	imul   %ecx
  801102:	c1 fa 02             	sar    $0x2,%edx
  801105:	89 c8                	mov    %ecx,%eax
  801107:	c1 f8 1f             	sar    $0x1f,%eax
  80110a:	29 c2                	sub    %eax,%edx
  80110c:	89 d0                	mov    %edx,%eax
  80110e:	c1 e0 02             	shl    $0x2,%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	01 c0                	add    %eax,%eax
  801115:	29 c1                	sub    %eax,%ecx
  801117:	89 ca                	mov    %ecx,%edx
  801119:	85 d2                	test   %edx,%edx
  80111b:	75 9c                	jne    8010b9 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80111d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801124:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801127:	48                   	dec    %eax
  801128:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80112f:	74 3d                	je     80116e <ltostr+0xe2>
		start = 1 ;
  801131:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801138:	eb 34                	jmp    80116e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	8a 00                	mov    (%eax),%al
  801144:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 c2                	add    %eax,%edx
  80114f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	01 c8                	add    %ecx,%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 c2                	add    %eax,%edx
  801163:	8a 45 eb             	mov    -0x15(%ebp),%al
  801166:	88 02                	mov    %al,(%edx)
		start++ ;
  801168:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80116e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801171:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801174:	7c c4                	jl     80113a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801176:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	01 d0                	add    %edx,%eax
  80117e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801181:	90                   	nop
  801182:	c9                   	leave  
  801183:	c3                   	ret    

00801184 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118a:	ff 75 08             	pushl  0x8(%ebp)
  80118d:	e8 54 fa ff ff       	call   800be6 <strlen>
  801192:	83 c4 04             	add    $0x4,%esp
  801195:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801198:	ff 75 0c             	pushl  0xc(%ebp)
  80119b:	e8 46 fa ff ff       	call   800be6 <strlen>
  8011a0:	83 c4 04             	add    $0x4,%esp
  8011a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b4:	eb 17                	jmp    8011cd <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bc:	01 c2                	add    %eax,%edx
  8011be:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	01 c8                	add    %ecx,%eax
  8011c6:	8a 00                	mov    (%eax),%al
  8011c8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011ca:	ff 45 fc             	incl   -0x4(%ebp)
  8011cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d3:	7c e1                	jl     8011b6 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e3:	eb 1f                	jmp    801204 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e8:	8d 50 01             	lea    0x1(%eax),%edx
  8011eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ee:	89 c2                	mov    %eax,%edx
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	01 c2                	add    %eax,%edx
  8011f5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fb:	01 c8                	add    %ecx,%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801201:	ff 45 f8             	incl   -0x8(%ebp)
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120a:	7c d9                	jl     8011e5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80120f:	8b 45 10             	mov    0x10(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	c6 00 00             	movb   $0x0,(%eax)
}
  801217:	90                   	nop
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80121d:	8b 45 14             	mov    0x14(%ebp),%eax
  801220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801226:	8b 45 14             	mov    0x14(%ebp),%eax
  801229:	8b 00                	mov    (%eax),%eax
  80122b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	01 d0                	add    %edx,%eax
  801237:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123d:	eb 0c                	jmp    80124b <strsplit+0x31>
			*string++ = 0;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8d 50 01             	lea    0x1(%eax),%edx
  801245:	89 55 08             	mov    %edx,0x8(%ebp)
  801248:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	8a 00                	mov    (%eax),%al
  801250:	84 c0                	test   %al,%al
  801252:	74 18                	je     80126c <strsplit+0x52>
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	0f be c0             	movsbl %al,%eax
  80125c:	50                   	push   %eax
  80125d:	ff 75 0c             	pushl  0xc(%ebp)
  801260:	e8 13 fb ff ff       	call   800d78 <strchr>
  801265:	83 c4 08             	add    $0x8,%esp
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 d3                	jne    80123f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 5a                	je     8012cf <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801275:	8b 45 14             	mov    0x14(%ebp),%eax
  801278:	8b 00                	mov    (%eax),%eax
  80127a:	83 f8 0f             	cmp    $0xf,%eax
  80127d:	75 07                	jne    801286 <strsplit+0x6c>
		{
			return 0;
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	eb 66                	jmp    8012ec <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801286:	8b 45 14             	mov    0x14(%ebp),%eax
  801289:	8b 00                	mov    (%eax),%eax
  80128b:	8d 48 01             	lea    0x1(%eax),%ecx
  80128e:	8b 55 14             	mov    0x14(%ebp),%edx
  801291:	89 0a                	mov    %ecx,(%edx)
  801293:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129a:	8b 45 10             	mov    0x10(%ebp),%eax
  80129d:	01 c2                	add    %eax,%edx
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a4:	eb 03                	jmp    8012a9 <strsplit+0x8f>
			string++;
  8012a6:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ac:	8a 00                	mov    (%eax),%al
  8012ae:	84 c0                	test   %al,%al
  8012b0:	74 8b                	je     80123d <strsplit+0x23>
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	8a 00                	mov    (%eax),%al
  8012b7:	0f be c0             	movsbl %al,%eax
  8012ba:	50                   	push   %eax
  8012bb:	ff 75 0c             	pushl  0xc(%ebp)
  8012be:	e8 b5 fa ff ff       	call   800d78 <strchr>
  8012c3:	83 c4 08             	add    $0x8,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	74 dc                	je     8012a6 <strsplit+0x8c>
			string++;
	}
  8012ca:	e9 6e ff ff ff       	jmp    80123d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012cf:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d3:	8b 00                	mov    (%eax),%eax
  8012d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012df:	01 d0                	add    %edx,%eax
  8012e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	panic("initialize_dyn_block_system() is not implemented yet...!!");
  8012f4:	83 ec 04             	sub    $0x4,%esp
  8012f7:	68 10 25 80 00       	push   $0x802510
  8012fc:	6a 0e                	push   $0xe
  8012fe:	68 4a 25 80 00       	push   $0x80254a
  801303:	e8 a8 ef ff ff       	call   8002b0 <_panic>

00801308 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================
int FirstTimeFlag = 1;
void* malloc(uint32 size)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if(FirstTimeFlag)
  80130e:	a1 04 30 80 00       	mov    0x803004,%eax
  801313:	85 c0                	test   %eax,%eax
  801315:	74 0f                	je     801326 <malloc+0x1e>
	{
		initialize_dyn_block_system();
  801317:	e8 d2 ff ff ff       	call   8012ee <initialize_dyn_block_system>
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131c:	c7 05 04 30 80 00 00 	movl   $0x0,0x803004
  801323:	00 00 00 
	}
	if (size == 0) return NULL ;
  801326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80132a:	75 07                	jne    801333 <malloc+0x2b>
  80132c:	b8 00 00 00 00       	mov    $0x0,%eax
  801331:	eb 14                	jmp    801347 <malloc+0x3f>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  801333:	83 ec 04             	sub    $0x4,%esp
  801336:	68 58 25 80 00       	push   $0x802558
  80133b:	6a 2e                	push   $0x2e
  80133d:	68 4a 25 80 00       	push   $0x80254a
  801342:	e8 69 ef ff ff       	call   8002b0 <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyNEXTFIT()... to check the current strategy
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  80134f:	83 ec 04             	sub    $0x4,%esp
  801352:	68 80 25 80 00       	push   $0x802580
  801357:	6a 49                	push   $0x49
  801359:	68 4a 25 80 00       	push   $0x80254a
  80135e:	e8 4d ef ff ff       	call   8002b0 <_panic>

00801363 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801363:	55                   	push   %ebp
  801364:	89 e5                	mov    %esp,%ebp
  801366:	83 ec 18             	sub    $0x18,%esp
  801369:	8b 45 10             	mov    0x10(%ebp),%eax
  80136c:	88 45 f4             	mov    %al,-0xc(%ebp)
	// Write your code here, remove the panic and write your code
	panic("smalloc() is not implemented yet...!!");
  80136f:	83 ec 04             	sub    $0x4,%esp
  801372:	68 a4 25 80 00       	push   $0x8025a4
  801377:	6a 57                	push   $0x57
  801379:	68 4a 25 80 00       	push   $0x80254a
  80137e:	e8 2d ef ff ff       	call   8002b0 <_panic>

00801383 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	68 cc 25 80 00       	push   $0x8025cc
  801391:	6a 60                	push   $0x60
  801393:	68 4a 25 80 00       	push   $0x80254a
  801398:	e8 13 ef ff ff       	call   8002b0 <_panic>

0080139d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	68 f0 25 80 00       	push   $0x8025f0
  8013ab:	6a 7c                	push   $0x7c
  8013ad:	68 4a 25 80 00       	push   $0x80254a
  8013b2:	e8 f9 ee ff ff       	call   8002b0 <_panic>

008013b7 <sfree>:

//=================================
// FREE SHARED VARIABLE:
//=================================
void sfree(void* virtual_address)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 08             	sub    $0x8,%esp
	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8013bd:	83 ec 04             	sub    $0x4,%esp
  8013c0:	68 18 26 80 00       	push   $0x802618
  8013c5:	68 86 00 00 00       	push   $0x86
  8013ca:	68 4a 25 80 00       	push   $0x80254a
  8013cf:	e8 dc ee ff ff       	call   8002b0 <_panic>

008013d4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	68 3c 26 80 00       	push   $0x80263c
  8013e2:	68 91 00 00 00       	push   $0x91
  8013e7:	68 4a 25 80 00       	push   $0x80254a
  8013ec:	e8 bf ee ff ff       	call   8002b0 <_panic>

008013f1 <shrink>:

}
void shrink(uint32 newSize)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	68 3c 26 80 00       	push   $0x80263c
  8013ff:	68 96 00 00 00       	push   $0x96
  801404:	68 4a 25 80 00       	push   $0x80254a
  801409:	e8 a2 ee ff ff       	call   8002b0 <_panic>

0080140e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801414:	83 ec 04             	sub    $0x4,%esp
  801417:	68 3c 26 80 00       	push   $0x80263c
  80141c:	68 9b 00 00 00       	push   $0x9b
  801421:	68 4a 25 80 00       	push   $0x80254a
  801426:	e8 85 ee ff ff       	call   8002b0 <_panic>

0080142b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	57                   	push   %edi
  80142f:	56                   	push   %esi
  801430:	53                   	push   %ebx
  801431:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80143d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801440:	8b 7d 18             	mov    0x18(%ebp),%edi
  801443:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801446:	cd 30                	int    $0x30
  801448:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80144e:	83 c4 10             	add    $0x10,%esp
  801451:	5b                   	pop    %ebx
  801452:	5e                   	pop    %esi
  801453:	5f                   	pop    %edi
  801454:	5d                   	pop    %ebp
  801455:	c3                   	ret    

00801456 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801462:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	52                   	push   %edx
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	50                   	push   %eax
  801472:	6a 00                	push   $0x0
  801474:	e8 b2 ff ff ff       	call   80142b <syscall>
  801479:	83 c4 18             	add    $0x18,%esp
}
  80147c:	90                   	nop
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_cgetc>:

int
sys_cgetc(void)
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 01                	push   $0x1
  80148e:	e8 98 ff ff ff       	call   80142b <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	52                   	push   %edx
  8014a8:	50                   	push   %eax
  8014a9:	6a 05                	push   $0x5
  8014ab:	e8 7b ff ff ff       	call   80142b <syscall>
  8014b0:	83 c4 18             	add    $0x18,%esp
}
  8014b3:	c9                   	leave  
  8014b4:	c3                   	ret    

008014b5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014b5:	55                   	push   %ebp
  8014b6:	89 e5                	mov    %esp,%ebp
  8014b8:	56                   	push   %esi
  8014b9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014ba:	8b 75 18             	mov    0x18(%ebp),%esi
  8014bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	56                   	push   %esi
  8014ca:	53                   	push   %ebx
  8014cb:	51                   	push   %ecx
  8014cc:	52                   	push   %edx
  8014cd:	50                   	push   %eax
  8014ce:	6a 06                	push   $0x6
  8014d0:	e8 56 ff ff ff       	call   80142b <syscall>
  8014d5:	83 c4 18             	add    $0x18,%esp
}
  8014d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014db:	5b                   	pop    %ebx
  8014dc:	5e                   	pop    %esi
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    

008014df <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	6a 00                	push   $0x0
  8014ea:	6a 00                	push   $0x0
  8014ec:	6a 00                	push   $0x0
  8014ee:	52                   	push   %edx
  8014ef:	50                   	push   %eax
  8014f0:	6a 07                	push   $0x7
  8014f2:	e8 34 ff ff ff       	call   80142b <syscall>
  8014f7:	83 c4 18             	add    $0x18,%esp
}
  8014fa:	c9                   	leave  
  8014fb:	c3                   	ret    

008014fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014fc:	55                   	push   %ebp
  8014fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	6a 00                	push   $0x0
  801505:	ff 75 0c             	pushl  0xc(%ebp)
  801508:	ff 75 08             	pushl  0x8(%ebp)
  80150b:	6a 08                	push   $0x8
  80150d:	e8 19 ff ff ff       	call   80142b <syscall>
  801512:	83 c4 18             	add    $0x18,%esp
}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 00                	push   $0x0
  801524:	6a 09                	push   $0x9
  801526:	e8 00 ff ff ff       	call   80142b <syscall>
  80152b:	83 c4 18             	add    $0x18,%esp
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	6a 0a                	push   $0xa
  80153f:	e8 e7 fe ff ff       	call   80142b <syscall>
  801544:	83 c4 18             	add    $0x18,%esp
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	6a 0b                	push   $0xb
  801558:	e8 ce fe ff ff       	call   80142b <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
}
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	ff 75 08             	pushl  0x8(%ebp)
  801571:	6a 0f                	push   $0xf
  801573:	e8 b3 fe ff ff       	call   80142b <syscall>
  801578:	83 c4 18             	add    $0x18,%esp
	return;
  80157b:	90                   	nop
}
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	ff 75 0c             	pushl  0xc(%ebp)
  80158a:	ff 75 08             	pushl  0x8(%ebp)
  80158d:	6a 10                	push   $0x10
  80158f:	e8 97 fe ff ff       	call   80142b <syscall>
  801594:	83 c4 18             	add    $0x18,%esp
	return ;
  801597:	90                   	nop
}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	ff 75 10             	pushl  0x10(%ebp)
  8015a4:	ff 75 0c             	pushl  0xc(%ebp)
  8015a7:	ff 75 08             	pushl  0x8(%ebp)
  8015aa:	6a 11                	push   $0x11
  8015ac:	e8 7a fe ff ff       	call   80142b <syscall>
  8015b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b4:	90                   	nop
}
  8015b5:	c9                   	leave  
  8015b6:	c3                   	ret    

008015b7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015b7:	55                   	push   %ebp
  8015b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 00                	push   $0x0
  8015c4:	6a 0c                	push   $0xc
  8015c6:	e8 60 fe ff ff       	call   80142b <syscall>
  8015cb:	83 c4 18             	add    $0x18,%esp
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	ff 75 08             	pushl  0x8(%ebp)
  8015de:	6a 0d                	push   $0xd
  8015e0:	e8 46 fe ff ff       	call   80142b <syscall>
  8015e5:	83 c4 18             	add    $0x18,%esp
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 0e                	push   $0xe
  8015f9:	e8 2d fe ff ff       	call   80142b <syscall>
  8015fe:	83 c4 18             	add    $0x18,%esp
}
  801601:	90                   	nop
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 13                	push   $0x13
  801613:	e8 13 fe ff ff       	call   80142b <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 14                	push   $0x14
  80162d:	e8 f9 fd ff ff       	call   80142b <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	90                   	nop
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_cputc>:


void
sys_cputc(const char c)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 04             	sub    $0x4,%esp
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801644:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	50                   	push   %eax
  801651:	6a 15                	push   $0x15
  801653:	e8 d3 fd ff ff       	call   80142b <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	90                   	nop
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	6a 00                	push   $0x0
  80166b:	6a 16                	push   $0x16
  80166d:	e8 b9 fd ff ff       	call   80142b <syscall>
  801672:	83 c4 18             	add    $0x18,%esp
}
  801675:	90                   	nop
  801676:	c9                   	leave  
  801677:	c3                   	ret    

00801678 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801678:	55                   	push   %ebp
  801679:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	ff 75 0c             	pushl  0xc(%ebp)
  801687:	50                   	push   %eax
  801688:	6a 17                	push   $0x17
  80168a:	e8 9c fd ff ff       	call   80142b <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
}
  801692:	c9                   	leave  
  801693:	c3                   	ret    

00801694 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801694:	55                   	push   %ebp
  801695:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801697:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	6a 00                	push   $0x0
  8016a3:	52                   	push   %edx
  8016a4:	50                   	push   %eax
  8016a5:	6a 1a                	push   $0x1a
  8016a7:	e8 7f fd ff ff       	call   80142b <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
}
  8016af:	c9                   	leave  
  8016b0:	c3                   	ret    

008016b1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016b1:	55                   	push   %ebp
  8016b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	52                   	push   %edx
  8016c1:	50                   	push   %eax
  8016c2:	6a 18                	push   $0x18
  8016c4:	e8 62 fd ff ff       	call   80142b <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	90                   	nop
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	52                   	push   %edx
  8016df:	50                   	push   %eax
  8016e0:	6a 19                	push   $0x19
  8016e2:	e8 44 fd ff ff       	call   80142b <syscall>
  8016e7:	83 c4 18             	add    $0x18,%esp
}
  8016ea:	90                   	nop
  8016eb:	c9                   	leave  
  8016ec:	c3                   	ret    

008016ed <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 04             	sub    $0x4,%esp
  8016f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016f9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016fc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	6a 00                	push   $0x0
  801705:	51                   	push   %ecx
  801706:	52                   	push   %edx
  801707:	ff 75 0c             	pushl  0xc(%ebp)
  80170a:	50                   	push   %eax
  80170b:	6a 1b                	push   $0x1b
  80170d:	e8 19 fd ff ff       	call   80142b <syscall>
  801712:	83 c4 18             	add    $0x18,%esp
}
  801715:	c9                   	leave  
  801716:	c3                   	ret    

00801717 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80171a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171d:	8b 45 08             	mov    0x8(%ebp),%eax
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	6a 1c                	push   $0x1c
  80172a:	e8 fc fc ff ff       	call   80142b <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	c9                   	leave  
  801733:	c3                   	ret    

00801734 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801737:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80173a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173d:	8b 45 08             	mov    0x8(%ebp),%eax
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	51                   	push   %ecx
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	6a 1d                	push   $0x1d
  801749:	e8 dd fc ff ff       	call   80142b <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
}
  801751:	c9                   	leave  
  801752:	c3                   	ret    

00801753 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801756:	8b 55 0c             	mov    0xc(%ebp),%edx
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	52                   	push   %edx
  801763:	50                   	push   %eax
  801764:	6a 1e                	push   $0x1e
  801766:	e8 c0 fc ff ff       	call   80142b <syscall>
  80176b:	83 c4 18             	add    $0x18,%esp
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 1f                	push   $0x1f
  80177f:	e8 a7 fc ff ff       	call   80142b <syscall>
  801784:	83 c4 18             	add    $0x18,%esp
}
  801787:	c9                   	leave  
  801788:	c3                   	ret    

00801789 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	6a 00                	push   $0x0
  801791:	ff 75 14             	pushl  0x14(%ebp)
  801794:	ff 75 10             	pushl  0x10(%ebp)
  801797:	ff 75 0c             	pushl  0xc(%ebp)
  80179a:	50                   	push   %eax
  80179b:	6a 20                	push   $0x20
  80179d:	e8 89 fc ff ff       	call   80142b <syscall>
  8017a2:	83 c4 18             	add    $0x18,%esp
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	50                   	push   %eax
  8017b6:	6a 21                	push   $0x21
  8017b8:	e8 6e fc ff ff       	call   80142b <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
}
  8017c0:	90                   	nop
  8017c1:	c9                   	leave  
  8017c2:	c3                   	ret    

008017c3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	50                   	push   %eax
  8017d2:	6a 22                	push   $0x22
  8017d4:	e8 52 fc ff ff       	call   80142b <syscall>
  8017d9:	83 c4 18             	add    $0x18,%esp
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 02                	push   $0x2
  8017ed:	e8 39 fc ff ff       	call   80142b <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	c9                   	leave  
  8017f6:	c3                   	ret    

008017f7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017f7:	55                   	push   %ebp
  8017f8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	6a 03                	push   $0x3
  801806:	e8 20 fc ff ff       	call   80142b <syscall>
  80180b:	83 c4 18             	add    $0x18,%esp
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	6a 04                	push   $0x4
  80181f:	e8 07 fc ff ff       	call   80142b <syscall>
  801824:	83 c4 18             	add    $0x18,%esp
}
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_exit_env>:


void sys_exit_env(void)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 23                	push   $0x23
  801838:	e8 ee fb ff ff       	call   80142b <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	90                   	nop
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801849:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80184c:	8d 50 04             	lea    0x4(%eax),%edx
  80184f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	52                   	push   %edx
  801859:	50                   	push   %eax
  80185a:	6a 24                	push   $0x24
  80185c:	e8 ca fb ff ff       	call   80142b <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
	return result;
  801864:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801867:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186d:	89 01                	mov    %eax,(%ecx)
  80186f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	c9                   	leave  
  801876:	c2 04 00             	ret    $0x4

00801879 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	ff 75 10             	pushl  0x10(%ebp)
  801883:	ff 75 0c             	pushl  0xc(%ebp)
  801886:	ff 75 08             	pushl  0x8(%ebp)
  801889:	6a 12                	push   $0x12
  80188b:	e8 9b fb ff ff       	call   80142b <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
	return ;
  801893:	90                   	nop
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_rcr2>:
uint32 sys_rcr2()
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 25                	push   $0x25
  8018a5:	e8 81 fb ff ff       	call   80142b <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018bb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	50                   	push   %eax
  8018c8:	6a 26                	push   $0x26
  8018ca:	e8 5c fb ff ff       	call   80142b <syscall>
  8018cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d2:	90                   	nop
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <rsttst>:
void rsttst()
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 28                	push   $0x28
  8018e4:	e8 42 fb ff ff       	call   80142b <syscall>
  8018e9:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ec:	90                   	nop
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 04             	sub    $0x4,%esp
  8018f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018fb:	8b 55 18             	mov    0x18(%ebp),%edx
  8018fe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801902:	52                   	push   %edx
  801903:	50                   	push   %eax
  801904:	ff 75 10             	pushl  0x10(%ebp)
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 08             	pushl  0x8(%ebp)
  80190d:	6a 27                	push   $0x27
  80190f:	e8 17 fb ff ff       	call   80142b <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
	return ;
  801917:	90                   	nop
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <chktst>:
void chktst(uint32 n)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	ff 75 08             	pushl  0x8(%ebp)
  801928:	6a 29                	push   $0x29
  80192a:	e8 fc fa ff ff       	call   80142b <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
	return ;
  801932:	90                   	nop
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <inctst>:

void inctst()
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 2a                	push   $0x2a
  801944:	e8 e2 fa ff ff       	call   80142b <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
	return ;
  80194c:	90                   	nop
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <gettst>:
uint32 gettst()
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 2b                	push   $0x2b
  80195e:	e8 c8 fa ff ff       	call   80142b <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 2c                	push   $0x2c
  80197a:	e8 ac fa ff ff       	call   80142b <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
  801982:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801985:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801989:	75 07                	jne    801992 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80198b:	b8 01 00 00 00       	mov    $0x1,%eax
  801990:	eb 05                	jmp    801997 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801992:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 2c                	push   $0x2c
  8019ab:	e8 7b fa ff ff       	call   80142b <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
  8019b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019b6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019ba:	75 07                	jne    8019c3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c1:	eb 05                	jmp    8019c8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    

008019ca <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019ca:	55                   	push   %ebp
  8019cb:	89 e5                	mov    %esp,%ebp
  8019cd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 2c                	push   $0x2c
  8019dc:	e8 4a fa ff ff       	call   80142b <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
  8019e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019e7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019eb:	75 07                	jne    8019f4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8019f2:	eb 05                	jmp    8019f9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 2c                	push   $0x2c
  801a0d:	e8 19 fa ff ff       	call   80142b <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
  801a15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a18:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a1c:	75 07                	jne    801a25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a23:	eb 05                	jmp    801a2a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 2d                	push   $0x2d
  801a3c:	e8 ea f9 ff ff       	call   80142b <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return ;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	6a 00                	push   $0x0
  801a59:	53                   	push   %ebx
  801a5a:	51                   	push   %ecx
  801a5b:	52                   	push   %edx
  801a5c:	50                   	push   %eax
  801a5d:	6a 2e                	push   $0x2e
  801a5f:	e8 c7 f9 ff ff       	call   80142b <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	52                   	push   %edx
  801a7c:	50                   	push   %eax
  801a7d:	6a 2f                	push   $0x2f
  801a7f:	e8 a7 f9 ff ff       	call   80142b <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a92:	89 d0                	mov    %edx,%eax
  801a94:	c1 e0 02             	shl    $0x2,%eax
  801a97:	01 d0                	add    %edx,%eax
  801a99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aa0:	01 d0                	add    %edx,%eax
  801aa2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aa9:	01 d0                	add    %edx,%eax
  801aab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ab2:	01 d0                	add    %edx,%eax
  801ab4:	c1 e0 04             	shl    $0x4,%eax
  801ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801aba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801ac1:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801ac4:	83 ec 0c             	sub    $0xc,%esp
  801ac7:	50                   	push   %eax
  801ac8:	e8 76 fd ff ff       	call   801843 <sys_get_virtual_time>
  801acd:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801ad0:	eb 41                	jmp    801b13 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801ad2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	50                   	push   %eax
  801ad9:	e8 65 fd ff ff       	call   801843 <sys_get_virtual_time>
  801ade:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801ae1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae7:	29 c2                	sub    %eax,%edx
  801ae9:	89 d0                	mov    %edx,%eax
  801aeb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801aee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801af1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af4:	89 d1                	mov    %edx,%ecx
  801af6:	29 c1                	sub    %eax,%ecx
  801af8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801afb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afe:	39 c2                	cmp    %eax,%edx
  801b00:	0f 97 c0             	seta   %al
  801b03:	0f b6 c0             	movzbl %al,%eax
  801b06:	29 c1                	sub    %eax,%ecx
  801b08:	89 c8                	mov    %ecx,%eax
  801b0a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b10:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b16:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b19:	72 b7                	jb     801ad2 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b1b:	90                   	nop
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b2b:	eb 03                	jmp    801b30 <busy_wait+0x12>
  801b2d:	ff 45 fc             	incl   -0x4(%ebp)
  801b30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b33:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b36:	72 f5                	jb     801b2d <busy_wait+0xf>
	return i;
  801b38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    
  801b3d:	66 90                	xchg   %ax,%ax
  801b3f:	90                   	nop

00801b40 <__udivdi3>:
  801b40:	55                   	push   %ebp
  801b41:	57                   	push   %edi
  801b42:	56                   	push   %esi
  801b43:	53                   	push   %ebx
  801b44:	83 ec 1c             	sub    $0x1c,%esp
  801b47:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b4b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b4f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b57:	89 ca                	mov    %ecx,%edx
  801b59:	89 f8                	mov    %edi,%eax
  801b5b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b5f:	85 f6                	test   %esi,%esi
  801b61:	75 2d                	jne    801b90 <__udivdi3+0x50>
  801b63:	39 cf                	cmp    %ecx,%edi
  801b65:	77 65                	ja     801bcc <__udivdi3+0x8c>
  801b67:	89 fd                	mov    %edi,%ebp
  801b69:	85 ff                	test   %edi,%edi
  801b6b:	75 0b                	jne    801b78 <__udivdi3+0x38>
  801b6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b72:	31 d2                	xor    %edx,%edx
  801b74:	f7 f7                	div    %edi
  801b76:	89 c5                	mov    %eax,%ebp
  801b78:	31 d2                	xor    %edx,%edx
  801b7a:	89 c8                	mov    %ecx,%eax
  801b7c:	f7 f5                	div    %ebp
  801b7e:	89 c1                	mov    %eax,%ecx
  801b80:	89 d8                	mov    %ebx,%eax
  801b82:	f7 f5                	div    %ebp
  801b84:	89 cf                	mov    %ecx,%edi
  801b86:	89 fa                	mov    %edi,%edx
  801b88:	83 c4 1c             	add    $0x1c,%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5f                   	pop    %edi
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    
  801b90:	39 ce                	cmp    %ecx,%esi
  801b92:	77 28                	ja     801bbc <__udivdi3+0x7c>
  801b94:	0f bd fe             	bsr    %esi,%edi
  801b97:	83 f7 1f             	xor    $0x1f,%edi
  801b9a:	75 40                	jne    801bdc <__udivdi3+0x9c>
  801b9c:	39 ce                	cmp    %ecx,%esi
  801b9e:	72 0a                	jb     801baa <__udivdi3+0x6a>
  801ba0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ba4:	0f 87 9e 00 00 00    	ja     801c48 <__udivdi3+0x108>
  801baa:	b8 01 00 00 00       	mov    $0x1,%eax
  801baf:	89 fa                	mov    %edi,%edx
  801bb1:	83 c4 1c             	add    $0x1c,%esp
  801bb4:	5b                   	pop    %ebx
  801bb5:	5e                   	pop    %esi
  801bb6:	5f                   	pop    %edi
  801bb7:	5d                   	pop    %ebp
  801bb8:	c3                   	ret    
  801bb9:	8d 76 00             	lea    0x0(%esi),%esi
  801bbc:	31 ff                	xor    %edi,%edi
  801bbe:	31 c0                	xor    %eax,%eax
  801bc0:	89 fa                	mov    %edi,%edx
  801bc2:	83 c4 1c             	add    $0x1c,%esp
  801bc5:	5b                   	pop    %ebx
  801bc6:	5e                   	pop    %esi
  801bc7:	5f                   	pop    %edi
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	89 d8                	mov    %ebx,%eax
  801bce:	f7 f7                	div    %edi
  801bd0:	31 ff                	xor    %edi,%edi
  801bd2:	89 fa                	mov    %edi,%edx
  801bd4:	83 c4 1c             	add    $0x1c,%esp
  801bd7:	5b                   	pop    %ebx
  801bd8:	5e                   	pop    %esi
  801bd9:	5f                   	pop    %edi
  801bda:	5d                   	pop    %ebp
  801bdb:	c3                   	ret    
  801bdc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801be1:	89 eb                	mov    %ebp,%ebx
  801be3:	29 fb                	sub    %edi,%ebx
  801be5:	89 f9                	mov    %edi,%ecx
  801be7:	d3 e6                	shl    %cl,%esi
  801be9:	89 c5                	mov    %eax,%ebp
  801beb:	88 d9                	mov    %bl,%cl
  801bed:	d3 ed                	shr    %cl,%ebp
  801bef:	89 e9                	mov    %ebp,%ecx
  801bf1:	09 f1                	or     %esi,%ecx
  801bf3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bf7:	89 f9                	mov    %edi,%ecx
  801bf9:	d3 e0                	shl    %cl,%eax
  801bfb:	89 c5                	mov    %eax,%ebp
  801bfd:	89 d6                	mov    %edx,%esi
  801bff:	88 d9                	mov    %bl,%cl
  801c01:	d3 ee                	shr    %cl,%esi
  801c03:	89 f9                	mov    %edi,%ecx
  801c05:	d3 e2                	shl    %cl,%edx
  801c07:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c0b:	88 d9                	mov    %bl,%cl
  801c0d:	d3 e8                	shr    %cl,%eax
  801c0f:	09 c2                	or     %eax,%edx
  801c11:	89 d0                	mov    %edx,%eax
  801c13:	89 f2                	mov    %esi,%edx
  801c15:	f7 74 24 0c          	divl   0xc(%esp)
  801c19:	89 d6                	mov    %edx,%esi
  801c1b:	89 c3                	mov    %eax,%ebx
  801c1d:	f7 e5                	mul    %ebp
  801c1f:	39 d6                	cmp    %edx,%esi
  801c21:	72 19                	jb     801c3c <__udivdi3+0xfc>
  801c23:	74 0b                	je     801c30 <__udivdi3+0xf0>
  801c25:	89 d8                	mov    %ebx,%eax
  801c27:	31 ff                	xor    %edi,%edi
  801c29:	e9 58 ff ff ff       	jmp    801b86 <__udivdi3+0x46>
  801c2e:	66 90                	xchg   %ax,%ax
  801c30:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c34:	89 f9                	mov    %edi,%ecx
  801c36:	d3 e2                	shl    %cl,%edx
  801c38:	39 c2                	cmp    %eax,%edx
  801c3a:	73 e9                	jae    801c25 <__udivdi3+0xe5>
  801c3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c3f:	31 ff                	xor    %edi,%edi
  801c41:	e9 40 ff ff ff       	jmp    801b86 <__udivdi3+0x46>
  801c46:	66 90                	xchg   %ax,%ax
  801c48:	31 c0                	xor    %eax,%eax
  801c4a:	e9 37 ff ff ff       	jmp    801b86 <__udivdi3+0x46>
  801c4f:	90                   	nop

00801c50 <__umoddi3>:
  801c50:	55                   	push   %ebp
  801c51:	57                   	push   %edi
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	83 ec 1c             	sub    $0x1c,%esp
  801c57:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c5b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c63:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c6b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c6f:	89 f3                	mov    %esi,%ebx
  801c71:	89 fa                	mov    %edi,%edx
  801c73:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c77:	89 34 24             	mov    %esi,(%esp)
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	75 1a                	jne    801c98 <__umoddi3+0x48>
  801c7e:	39 f7                	cmp    %esi,%edi
  801c80:	0f 86 a2 00 00 00    	jbe    801d28 <__umoddi3+0xd8>
  801c86:	89 c8                	mov    %ecx,%eax
  801c88:	89 f2                	mov    %esi,%edx
  801c8a:	f7 f7                	div    %edi
  801c8c:	89 d0                	mov    %edx,%eax
  801c8e:	31 d2                	xor    %edx,%edx
  801c90:	83 c4 1c             	add    $0x1c,%esp
  801c93:	5b                   	pop    %ebx
  801c94:	5e                   	pop    %esi
  801c95:	5f                   	pop    %edi
  801c96:	5d                   	pop    %ebp
  801c97:	c3                   	ret    
  801c98:	39 f0                	cmp    %esi,%eax
  801c9a:	0f 87 ac 00 00 00    	ja     801d4c <__umoddi3+0xfc>
  801ca0:	0f bd e8             	bsr    %eax,%ebp
  801ca3:	83 f5 1f             	xor    $0x1f,%ebp
  801ca6:	0f 84 ac 00 00 00    	je     801d58 <__umoddi3+0x108>
  801cac:	bf 20 00 00 00       	mov    $0x20,%edi
  801cb1:	29 ef                	sub    %ebp,%edi
  801cb3:	89 fe                	mov    %edi,%esi
  801cb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cb9:	89 e9                	mov    %ebp,%ecx
  801cbb:	d3 e0                	shl    %cl,%eax
  801cbd:	89 d7                	mov    %edx,%edi
  801cbf:	89 f1                	mov    %esi,%ecx
  801cc1:	d3 ef                	shr    %cl,%edi
  801cc3:	09 c7                	or     %eax,%edi
  801cc5:	89 e9                	mov    %ebp,%ecx
  801cc7:	d3 e2                	shl    %cl,%edx
  801cc9:	89 14 24             	mov    %edx,(%esp)
  801ccc:	89 d8                	mov    %ebx,%eax
  801cce:	d3 e0                	shl    %cl,%eax
  801cd0:	89 c2                	mov    %eax,%edx
  801cd2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cd6:	d3 e0                	shl    %cl,%eax
  801cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdc:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce0:	89 f1                	mov    %esi,%ecx
  801ce2:	d3 e8                	shr    %cl,%eax
  801ce4:	09 d0                	or     %edx,%eax
  801ce6:	d3 eb                	shr    %cl,%ebx
  801ce8:	89 da                	mov    %ebx,%edx
  801cea:	f7 f7                	div    %edi
  801cec:	89 d3                	mov    %edx,%ebx
  801cee:	f7 24 24             	mull   (%esp)
  801cf1:	89 c6                	mov    %eax,%esi
  801cf3:	89 d1                	mov    %edx,%ecx
  801cf5:	39 d3                	cmp    %edx,%ebx
  801cf7:	0f 82 87 00 00 00    	jb     801d84 <__umoddi3+0x134>
  801cfd:	0f 84 91 00 00 00    	je     801d94 <__umoddi3+0x144>
  801d03:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d07:	29 f2                	sub    %esi,%edx
  801d09:	19 cb                	sbb    %ecx,%ebx
  801d0b:	89 d8                	mov    %ebx,%eax
  801d0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d11:	d3 e0                	shl    %cl,%eax
  801d13:	89 e9                	mov    %ebp,%ecx
  801d15:	d3 ea                	shr    %cl,%edx
  801d17:	09 d0                	or     %edx,%eax
  801d19:	89 e9                	mov    %ebp,%ecx
  801d1b:	d3 eb                	shr    %cl,%ebx
  801d1d:	89 da                	mov    %ebx,%edx
  801d1f:	83 c4 1c             	add    $0x1c,%esp
  801d22:	5b                   	pop    %ebx
  801d23:	5e                   	pop    %esi
  801d24:	5f                   	pop    %edi
  801d25:	5d                   	pop    %ebp
  801d26:	c3                   	ret    
  801d27:	90                   	nop
  801d28:	89 fd                	mov    %edi,%ebp
  801d2a:	85 ff                	test   %edi,%edi
  801d2c:	75 0b                	jne    801d39 <__umoddi3+0xe9>
  801d2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d33:	31 d2                	xor    %edx,%edx
  801d35:	f7 f7                	div    %edi
  801d37:	89 c5                	mov    %eax,%ebp
  801d39:	89 f0                	mov    %esi,%eax
  801d3b:	31 d2                	xor    %edx,%edx
  801d3d:	f7 f5                	div    %ebp
  801d3f:	89 c8                	mov    %ecx,%eax
  801d41:	f7 f5                	div    %ebp
  801d43:	89 d0                	mov    %edx,%eax
  801d45:	e9 44 ff ff ff       	jmp    801c8e <__umoddi3+0x3e>
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	89 c8                	mov    %ecx,%eax
  801d4e:	89 f2                	mov    %esi,%edx
  801d50:	83 c4 1c             	add    $0x1c,%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5e                   	pop    %esi
  801d55:	5f                   	pop    %edi
  801d56:	5d                   	pop    %ebp
  801d57:	c3                   	ret    
  801d58:	3b 04 24             	cmp    (%esp),%eax
  801d5b:	72 06                	jb     801d63 <__umoddi3+0x113>
  801d5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d61:	77 0f                	ja     801d72 <__umoddi3+0x122>
  801d63:	89 f2                	mov    %esi,%edx
  801d65:	29 f9                	sub    %edi,%ecx
  801d67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d6b:	89 14 24             	mov    %edx,(%esp)
  801d6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d72:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d76:	8b 14 24             	mov    (%esp),%edx
  801d79:	83 c4 1c             	add    $0x1c,%esp
  801d7c:	5b                   	pop    %ebx
  801d7d:	5e                   	pop    %esi
  801d7e:	5f                   	pop    %edi
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    
  801d81:	8d 76 00             	lea    0x0(%esi),%esi
  801d84:	2b 04 24             	sub    (%esp),%eax
  801d87:	19 fa                	sbb    %edi,%edx
  801d89:	89 d1                	mov    %edx,%ecx
  801d8b:	89 c6                	mov    %eax,%esi
  801d8d:	e9 71 ff ff ff       	jmp    801d03 <__umoddi3+0xb3>
  801d92:	66 90                	xchg   %ax,%ax
  801d94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d98:	72 ea                	jb     801d84 <__umoddi3+0x134>
  801d9a:	89 d9                	mov    %ebx,%ecx
  801d9c:	e9 62 ff ff ff       	jmp    801d03 <__umoddi3+0xb3>
