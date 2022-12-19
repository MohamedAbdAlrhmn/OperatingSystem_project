
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 f8 01 00 00       	call   80022e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 47 1c 00 00       	call   801c8a <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 00 38 80 00       	push   $0x803800
  800050:	e8 cf 1a 00 00       	call   801b24 <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 04 38 80 00       	push   $0x803804
  800062:	e8 bd 1a 00 00       	call   801b24 <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 50 80 00       	mov    0x805020,%eax
  80006f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 50 80 00       	mov    0x805020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 0c 38 80 00       	push   $0x80380c
  800088:	e8 a8 1b 00 00       	call   801c35 <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 50 80 00       	mov    0x805020,%eax
  800098:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 0c 38 80 00       	push   $0x80380c
  8000b1:	e8 7f 1b 00 00       	call   801c35 <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8000c1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 0c 38 80 00       	push   $0x80380c
  8000da:	e8 56 1b 00 00       	call   801c35 <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000e5:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000e9:	74 0c                	je     8000f7 <_main+0xbf>
  8000eb:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  8000ef:	74 06                	je     8000f7 <_main+0xbf>
  8000f1:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  8000f5:	75 14                	jne    80010b <_main+0xd3>
		panic("NO AVAILABLE ENVs...");
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 19 38 80 00       	push   $0x803819
  8000ff:	6a 13                	push   $0x13
  800101:	68 30 38 80 00       	push   $0x803830
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 3d 1b 00 00       	call   801c53 <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 2f 1b 00 00       	call   801c53 <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 21 1b 00 00       	call   801c53 <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 04 38 80 00       	push   $0x803804
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 18 1a 00 00       	call   801b5d <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 04 38 80 00       	push   $0x803804
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 05 1a 00 00       	call   801b5d <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 04 38 80 00       	push   $0x803804
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 f2 19 00 00       	call   801b5d <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 00 38 80 00       	push   $0x803800
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 c2 19 00 00       	call   801b40 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 04 38 80 00       	push   $0x803804
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 ac 19 00 00       	call   801b40 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 50 38 80 00       	push   $0x803850
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 98 38 80 00       	push   $0x803898
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 ef 1a 00 00       	call   801cbc <sys_getparentenvid>
  8001cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d4:	7e 55                	jle    80022b <_main+0x1f3>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  8001d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	68 e3 38 80 00       	push   $0x8038e3
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 b2 15 00 00       	call   80179f <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 71 1a 00 00       	call   801c6f <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 63 1a 00 00       	call   801c6f <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 55 1a 00 00       	call   801c6f <sys_destroy_env>
  80021a:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  80021d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 50 01             	lea    0x1(%eax),%edx
  800225:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800228:	89 10                	mov    %edx,(%eax)
	}

	return;
  80022a:	90                   	nop
  80022b:	90                   	nop
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800234:	e8 6a 1a 00 00       	call   801ca3 <sys_getenvindex>
  800239:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80023c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023f:	89 d0                	mov    %edx,%eax
  800241:	c1 e0 03             	shl    $0x3,%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	01 c0                	add    %eax,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 04             	shl    $0x4,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 50 80 00       	mov    0x805020,%eax
  800265:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80026b:	84 c0                	test   %al,%al
  80026d:	74 0f                	je     80027e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026f:	a1 20 50 80 00       	mov    0x805020,%eax
  800274:	05 5c 05 00 00       	add    $0x55c,%eax
  800279:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x60>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029f:	e8 0c 18 00 00       	call   801ab0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 0c 39 80 00       	push   $0x80390c
  8002ac:	e8 6d 03 00 00       	call   80061e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8002c4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 34 39 80 00       	push   $0x803934
  8002d4:	e8 45 03 00 00       	call   80061e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002ec:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 5c 39 80 00       	push   $0x80395c
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 50 80 00       	mov    0x805020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 b4 39 80 00       	push   $0x8039b4
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 0c 39 80 00       	push   $0x80390c
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 8c 17 00 00       	call   801aca <sys_enable_interrupt>

	// exit gracefully
	exit();
  80033e:	e8 19 00 00 00       	call   80035c <exit>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	6a 00                	push   $0x0
  800351:	e8 19 19 00 00       	call   801c6f <sys_destroy_env>
  800356:	83 c4 10             	add    $0x10,%esp
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <exit>:

void
exit(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800362:	e8 6e 19 00 00       	call   801cd5 <sys_exit_env>
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800370:	8d 45 10             	lea    0x10(%ebp),%eax
  800373:	83 c0 04             	add    $0x4,%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800379:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	74 16                	je     800398 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800382:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	50                   	push   %eax
  80038b:	68 c8 39 80 00       	push   $0x8039c8
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 50 80 00       	mov    0x805000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 cd 39 80 00       	push   $0x8039cd
  8003a9:	e8 70 02 00 00       	call   80061e <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	e8 f3 01 00 00       	call   8005b3 <vcprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	6a 00                	push   $0x0
  8003c8:	68 e9 39 80 00       	push   $0x8039e9
  8003cd:	e8 e1 01 00 00       	call   8005b3 <vcprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d5:	e8 82 ff ff ff       	call   80035c <exit>

	// should not return here
	while (1) ;
  8003da:	eb fe                	jmp    8003da <_panic+0x70>

008003dc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003e2:	a1 20 50 80 00       	mov    0x805020,%eax
  8003e7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	74 14                	je     800405 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 ec 39 80 00       	push   $0x8039ec
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 38 3a 80 00       	push   $0x803a38
  800400:	e8 65 ff ff ff       	call   80036a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80040c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800413:	e9 c2 00 00 00       	jmp    8004da <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	75 08                	jne    800435 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80042d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800430:	e9 a2 00 00 00       	jmp    8004d7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800443:	eb 69                	jmp    8004ae <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800445:	a1 20 50 80 00       	mov    0x805020,%eax
  80044a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800453:	89 d0                	mov    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	c1 e0 03             	shl    $0x3,%eax
  80045c:	01 c8                	add    %ecx,%eax
  80045e:	8a 40 04             	mov    0x4(%eax),%al
  800461:	84 c0                	test   %al,%al
  800463:	75 46                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800465:	a1 20 50 80 00       	mov    0x805020,%eax
  80046a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800470:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800473:	89 d0                	mov    %edx,%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 03             	shl    $0x3,%eax
  80047c:	01 c8                	add    %ecx,%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80048b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c8                	add    %ecx,%eax
  80049c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	75 09                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a9:	eb 12                	jmp    8004bd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e8             	incl   -0x18(%ebp)
  8004ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b3:	8b 50 74             	mov    0x74(%eax),%edx
  8004b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b9:	39 c2                	cmp    %eax,%edx
  8004bb:	77 88                	ja     800445 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004c1:	75 14                	jne    8004d7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	68 44 3a 80 00       	push   $0x803a44
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 38 3a 80 00       	push   $0x803a38
  8004d2:	e8 93 fe ff ff       	call   80036a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d7:	ff 45 f0             	incl   -0x10(%ebp)
  8004da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e0:	0f 8c 32 ff ff ff    	jl     800418 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f4:	eb 26                	jmp    80051c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800501:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	01 c0                	add    %eax,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	c1 e0 03             	shl    $0x3,%eax
  80050d:	01 c8                	add    %ecx,%eax
  80050f:	8a 40 04             	mov    0x4(%eax),%al
  800512:	3c 01                	cmp    $0x1,%al
  800514:	75 03                	jne    800519 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800516:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	ff 45 e0             	incl   -0x20(%ebp)
  80051c:	a1 20 50 80 00       	mov    0x805020,%eax
  800521:	8b 50 74             	mov    0x74(%eax),%edx
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	77 cb                	ja     8004f6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80052b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800531:	74 14                	je     800547 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	68 98 3a 80 00       	push   $0x803a98
  80053b:	6a 44                	push   $0x44
  80053d:	68 38 3a 80 00       	push   $0x803a38
  800542:	e8 23 fe ff ff       	call   80036a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 48 01             	lea    0x1(%eax),%ecx
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	89 0a                	mov    %ecx,(%edx)
  80055d:	8b 55 08             	mov    0x8(%ebp),%edx
  800560:	88 d1                	mov    %dl,%cl
  800562:	8b 55 0c             	mov    0xc(%ebp),%edx
  800565:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800573:	75 2c                	jne    8005a1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800575:	a0 24 50 80 00       	mov    0x805024,%al
  80057a:	0f b6 c0             	movzbl %al,%eax
  80057d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800580:	8b 12                	mov    (%edx),%edx
  800582:	89 d1                	mov    %edx,%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	83 c2 08             	add    $0x8,%edx
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	50                   	push   %eax
  80058e:	51                   	push   %ecx
  80058f:	52                   	push   %edx
  800590:	e8 6d 13 00 00       	call   801902 <sys_cputs>
  800595:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 40 04             	mov    0x4(%eax),%eax
  8005a7:	8d 50 01             	lea    0x1(%eax),%edx
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b0:	90                   	nop
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c3:	00 00 00 
	b.cnt = 0;
  8005c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005dc:	50                   	push   %eax
  8005dd:	68 4a 05 80 00       	push   $0x80054a
  8005e2:	e8 11 02 00 00       	call   8007f8 <vprintfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ea:	a0 24 50 80 00       	mov    0x805024,%al
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	52                   	push   %edx
  8005fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	50                   	push   %eax
  800607:	e8 f6 12 00 00       	call   801902 <sys_cputs>
  80060c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060f:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800616:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <cprintf>:

int cprintf(const char *fmt, ...) {
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800624:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80062b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	e8 73 ff ff ff       	call   8005b3 <vcprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800651:	e8 5a 14 00 00       	call   801ab0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800656:	8d 45 0c             	lea    0xc(%ebp),%eax
  800659:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 f4             	pushl  -0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	e8 48 ff ff ff       	call   8005b3 <vcprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800671:	e8 54 14 00 00       	call   801aca <sys_enable_interrupt>
	return cnt;
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	53                   	push   %ebx
  80067f:	83 ec 14             	sub    $0x14,%esp
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068e:	8b 45 18             	mov    0x18(%ebp),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	77 55                	ja     8006f0 <printnum+0x75>
  80069b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069e:	72 05                	jb     8006a5 <printnum+0x2a>
  8006a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a3:	77 4b                	ja     8006f0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bb:	e8 c8 2e 00 00       	call   803588 <__udivdi3>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 20             	pushl  0x20(%ebp)
  8006c9:	53                   	push   %ebx
  8006ca:	ff 75 18             	pushl  0x18(%ebp)
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 a1 ff ff ff       	call   80067b <printnum>
  8006da:	83 c4 20             	add    $0x20,%esp
  8006dd:	eb 1a                	jmp    8006f9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	ff 75 20             	pushl  0x20(%ebp)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f0:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f7:	7f e6                	jg     8006df <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800707:	53                   	push   %ebx
  800708:	51                   	push   %ecx
  800709:	52                   	push   %edx
  80070a:	50                   	push   %eax
  80070b:	e8 88 2f 00 00       	call   803698 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 14 3d 80 00       	add    $0x803d14,%eax
  800718:	8a 00                	mov    (%eax),%al
  80071a:	0f be c0             	movsbl %al,%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	50                   	push   %eax
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
}
  80072c:	90                   	nop
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800735:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800739:	7e 1c                	jle    800757 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 08             	lea    0x8(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 08             	sub    $0x8,%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	eb 40                	jmp    800797 <getuint+0x65>
	else if (lflag)
  800757:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075b:	74 1e                	je     80077b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	ba 00 00 00 00       	mov    $0x0,%edx
  800779:	eb 1c                	jmp    800797 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a0:	7e 1c                	jle    8007be <getint+0x25>
		return va_arg(*ap, long long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 08             	lea    0x8(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 08             	sub    $0x8,%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	eb 38                	jmp    8007f6 <getint+0x5d>
	else if (lflag)
  8007be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c2:	74 1a                	je     8007de <getint+0x45>
		return va_arg(*ap, long);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8d 50 04             	lea    0x4(%eax),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 10                	mov    %edx,(%eax)
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	99                   	cltd   
  8007dc:	eb 18                	jmp    8007f6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	89 10                	mov    %edx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	99                   	cltd   
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	eb 17                	jmp    800819 <vprintfmt+0x21>
			if (ch == '\0')
  800802:	85 db                	test   %ebx,%ebx
  800804:	0f 84 af 03 00 00    	je     800bb9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	8d 50 01             	lea    0x1(%eax),%edx
  80081f:	89 55 10             	mov    %edx,0x10(%ebp)
  800822:	8a 00                	mov    (%eax),%al
  800824:	0f b6 d8             	movzbl %al,%ebx
  800827:	83 fb 25             	cmp    $0x25,%ebx
  80082a:	75 d6                	jne    800802 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800830:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800837:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800845:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085d:	83 f8 55             	cmp    $0x55,%eax
  800860:	0f 87 2b 03 00 00    	ja     800b91 <vprintfmt+0x399>
  800866:	8b 04 85 38 3d 80 00 	mov    0x803d38(,%eax,4),%eax
  80086d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800873:	eb d7                	jmp    80084c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800875:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800879:	eb d1                	jmp    80084c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800882:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800885:	89 d0                	mov    %edx,%eax
  800887:	c1 e0 02             	shl    $0x2,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	01 c0                	add    %eax,%eax
  80088e:	01 d8                	add    %ebx,%eax
  800890:	83 e8 30             	sub    $0x30,%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800896:	8b 45 10             	mov    0x10(%ebp),%eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089e:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a1:	7e 3e                	jle    8008e1 <vprintfmt+0xe9>
  8008a3:	83 fb 39             	cmp    $0x39,%ebx
  8008a6:	7f 39                	jg     8008e1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ab:	eb d5                	jmp    800882 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 e8 04             	sub    $0x4,%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c1:	eb 1f                	jmp    8008e2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	79 83                	jns    80084c <vprintfmt+0x54>
				width = 0;
  8008c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d0:	e9 77 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008dc:	e9 6b ff ff ff       	jmp    80084c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	0f 89 60 ff ff ff    	jns    80084c <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f9:	e9 4e ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800901:	e9 46 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			break;
  800926:	e9 89 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 c0 04             	add    $0x4,%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x14a>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 64             	cmp    $0x64,%ebx
  800945:	7f 0b                	jg     800952 <vprintfmt+0x15a>
  800947:	8b 34 9d 80 3b 80 00 	mov    0x803b80(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 25 3d 80 00       	push   $0x803d25
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 5e 02 00 00       	call   800bc1 <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800966:	e9 49 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096b:	56                   	push   %esi
  80096c:	68 2e 3d 80 00       	push   $0x803d2e
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 45 02 00 00       	call   800bc1 <printfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
			break;
  80097f:	e9 30 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 30                	mov    (%eax),%esi
  800995:	85 f6                	test   %esi,%esi
  800997:	75 05                	jne    80099e <vprintfmt+0x1a6>
				p = "(null)";
  800999:	be 31 3d 80 00       	mov    $0x803d31,%esi
			if (width > 0 && padc != '-')
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7e 6d                	jle    800a11 <vprintfmt+0x219>
  8009a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a8:	74 67                	je     800a11 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	50                   	push   %eax
  8009b1:	56                   	push   %esi
  8009b2:	e8 0c 03 00 00       	call   800cc3 <strnlen>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009bd:	eb 16                	jmp    8009d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	50                   	push   %eax
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7f e4                	jg     8009bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009db:	eb 34                	jmp    800a11 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e1:	74 1c                	je     8009ff <vprintfmt+0x207>
  8009e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e6:	7e 05                	jle    8009ed <vprintfmt+0x1f5>
  8009e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8009eb:	7e 12                	jle    8009ff <vprintfmt+0x207>
					putch('?', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 3f                	push   $0x3f
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a11:	89 f0                	mov    %esi,%eax
  800a13:	8d 70 01             	lea    0x1(%eax),%esi
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f be d8             	movsbl %al,%ebx
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	74 24                	je     800a43 <vprintfmt+0x24b>
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	78 b8                	js     8009dd <vprintfmt+0x1e5>
  800a25:	ff 4d e0             	decl   -0x20(%ebp)
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	79 af                	jns    8009dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2e:	eb 13                	jmp    800a43 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	6a 20                	push   $0x20
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a40:	ff 4d e4             	decl   -0x1c(%ebp)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	7f e7                	jg     800a30 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a49:	e9 66 01 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 3c fd ff ff       	call   800799 <getint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	85 d2                	test   %edx,%edx
  800a6e:	79 23                	jns    800a93 <vprintfmt+0x29b>
				putch('-', putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	6a 2d                	push   $0x2d
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a86:	f7 d8                	neg    %eax
  800a88:	83 d2 00             	adc    $0x0,%edx
  800a8b:	f7 da                	neg    %edx
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9a:	e9 bc 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 84 fc ff ff       	call   800732 <getuint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abe:	e9 98 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 58                	push   $0x58
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 58                	push   $0x58
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 58                	push   $0x58
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	e9 bc 00 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 30                	push   $0x30
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	6a 78                	push   $0x78
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3a:	eb 1f                	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 e7 fb ff ff       	call   800732 <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b62:	83 ec 04             	sub    $0x4,%esp
  800b65:	52                   	push   %edx
  800b66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b69:	50                   	push   %eax
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 00 fb ff ff       	call   80067b <printnum>
  800b7b:	83 c4 20             	add    $0x20,%esp
			break;
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	53                   	push   %ebx
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	eb 23                	jmp    800bb4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 25                	push   $0x25
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	eb 03                	jmp    800ba9 <vprintfmt+0x3b1>
  800ba6:	ff 4d 10             	decl   0x10(%ebp)
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	48                   	dec    %eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	3c 25                	cmp    $0x25,%al
  800bb1:	75 f3                	jne    800ba6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb3:	90                   	nop
		}
	}
  800bb4:	e9 47 fc ff ff       	jmp    800800 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bca:	83 c0 04             	add    $0x4,%eax
  800bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	ff 75 08             	pushl  0x8(%ebp)
  800bdd:	e8 16 fc ff ff       	call   8007f8 <vprintfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8b 40 08             	mov    0x8(%eax),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 10                	mov    (%eax),%edx
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	39 c2                	cmp    %eax,%edx
  800c07:	73 12                	jae    800c1b <sprintputch+0x33>
		*b->buf++ = ch;
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	89 0a                	mov    %ecx,(%edx)
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	88 10                	mov    %dl,(%eax)
}
  800c1b:	90                   	nop
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	01 d0                	add    %edx,%eax
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c43:	74 06                	je     800c4b <vsnprintf+0x2d>
  800c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c49:	7f 07                	jg     800c52 <vsnprintf+0x34>
		return -E_INVAL;
  800c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c50:	eb 20                	jmp    800c72 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c52:	ff 75 14             	pushl  0x14(%ebp)
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5b:	50                   	push   %eax
  800c5c:	68 e8 0b 80 00       	push   $0x800be8
  800c61:	e8 92 fb ff ff       	call   8007f8 <vprintfmt>
  800c66:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 89 ff ff ff       	call   800c1e <vsnprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cad:	eb 06                	jmp    800cb5 <strlen+0x15>
		n++;
  800caf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 f1                	jne    800caf <strlen+0xf>
		n++;
	return n;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd0:	eb 09                	jmp    800cdb <strnlen+0x18>
		n++;
  800cd2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	ff 4d 0c             	decl   0xc(%ebp)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 09                	je     800cea <strnlen+0x27>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 e8                	jne    800cd2 <strnlen+0xf>
		n++;
	return n;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cfb:	90                   	nop
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 08             	mov    %edx,0x8(%ebp)
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0e:	8a 12                	mov    (%edx),%dl
  800d10:	88 10                	mov    %dl,(%eax)
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 e4                	jne    800cfc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d30:	eb 1f                	jmp    800d51 <strncpy+0x34>
		*dst++ = *src;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	74 03                	je     800d4e <strncpy+0x31>
			src++;
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4e:	ff 45 fc             	incl   -0x4(%ebp)
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d57:	72 d9                	jb     800d32 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 30                	je     800da0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d70:	eb 16                	jmp    800d88 <strlcpy+0x2a>
			*dst++ = *src++;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d84:	8a 12                	mov    (%edx),%dl
  800d86:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d88:	ff 4d 10             	decl   0x10(%ebp)
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 09                	je     800d9a <strlcpy+0x3c>
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 d8                	jne    800d72 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	29 c2                	sub    %eax,%edx
  800da8:	89 d0                	mov    %edx,%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daf:	eb 06                	jmp    800db7 <strcmp+0xb>
		p++, q++;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 0e                	je     800dce <strcmp+0x22>
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 10                	mov    (%eax),%dl
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	38 c2                	cmp    %al,%dl
  800dcc:	74 e3                	je     800db1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 d0             	movzbl %al,%edx
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	29 c2                	sub    %eax,%edx
  800de0:	89 d0                	mov    %edx,%eax
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de7:	eb 09                	jmp    800df2 <strncmp+0xe>
		n--, p++, q++;
  800de9:	ff 4d 10             	decl   0x10(%ebp)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	74 17                	je     800e0f <strncmp+0x2b>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	74 0e                	je     800e0f <strncmp+0x2b>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 10                	mov    (%eax),%dl
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	38 c2                	cmp    %al,%dl
  800e0d:	74 da                	je     800de9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	75 07                	jne    800e1c <strncmp+0x38>
		return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	eb 14                	jmp    800e30 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 d0             	movzbl %al,%edx
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f b6 c0             	movzbl %al,%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3e:	eb 12                	jmp    800e52 <strchr+0x20>
		if (*s == c)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e48:	75 05                	jne    800e4f <strchr+0x1d>
			return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	eb 11                	jmp    800e60 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e5                	jne    800e40 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6e:	eb 0d                	jmp    800e7d <strfind+0x1b>
		if (*s == c)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e78:	74 0e                	je     800e88 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 ea                	jne    800e70 <strfind+0xe>
  800e86:	eb 01                	jmp    800e89 <strfind+0x27>
		if (*s == c)
			break;
  800e88:	90                   	nop
	return (char *) s;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea0:	eb 0e                	jmp    800eb0 <memset+0x22>
		*p++ = c;
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb0:	ff 4d f8             	decl   -0x8(%ebp)
  800eb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eb7:	79 e9                	jns    800ea2 <memset+0x14>
		*p++ = c;

	return v;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed0:	eb 16                	jmp    800ee8 <memcpy+0x2a>
		*d++ = *s++;
  800ed2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 dd                	jne    800ed2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f12:	73 50                	jae    800f64 <memmove+0x6a>
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1f:	76 43                	jbe    800f64 <memmove+0x6a>
		s += n;
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f2d:	eb 10                	jmp    800f3f <memmove+0x45>
			*--d = *--s;
  800f2f:	ff 4d f8             	decl   -0x8(%ebp)
  800f32:	ff 4d fc             	decl   -0x4(%ebp)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f45:	89 55 10             	mov    %edx,0x10(%ebp)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 e3                	jne    800f2f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f4c:	eb 23                	jmp    800f71 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 dd                	jne    800f4e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f88:	eb 2a                	jmp    800fb4 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 16                	je     800fae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 d0             	movzbl %al,%edx
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 c0             	movzbl %al,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	eb 18                	jmp    800fc6 <memcmp+0x50>
		s1++, s2++;
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fba:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 c9                	jne    800f8a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd9:	eb 15                	jmp    800ff0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	0f b6 c0             	movzbl %al,%eax
  800fe9:	39 c2                	cmp    %eax,%edx
  800feb:	74 0d                	je     800ffa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff6:	72 e3                	jb     800fdb <memfind+0x13>
  800ff8:	eb 01                	jmp    800ffb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffa:	90                   	nop
	return (void *) s;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80100d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801014:	eb 03                	jmp    801019 <strtol+0x19>
		s++;
  801016:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 20                	cmp    $0x20,%al
  801020:	74 f4                	je     801016 <strtol+0x16>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 09                	cmp    $0x9,%al
  801029:	74 eb                	je     801016 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	3c 2b                	cmp    $0x2b,%al
  801032:	75 05                	jne    801039 <strtol+0x39>
		s++;
  801034:	ff 45 08             	incl   0x8(%ebp)
  801037:	eb 13                	jmp    80104c <strtol+0x4c>
	else if (*s == '-')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 2d                	cmp    $0x2d,%al
  801040:	75 0a                	jne    80104c <strtol+0x4c>
		s++, neg = 1;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	74 06                	je     801058 <strtol+0x58>
  801052:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801056:	75 20                	jne    801078 <strtol+0x78>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 30                	cmp    $0x30,%al
  80105f:	75 17                	jne    801078 <strtol+0x78>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	40                   	inc    %eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 78                	cmp    $0x78,%al
  801069:	75 0d                	jne    801078 <strtol+0x78>
		s += 2, base = 16;
  80106b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80106f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801076:	eb 28                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	75 15                	jne    801093 <strtol+0x93>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 0c                	jne    801093 <strtol+0x93>
		s++, base = 8;
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801091:	eb 0d                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0)
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	75 07                	jne    8010a0 <strtol+0xa0>
		base = 10;
  801099:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 2f                	cmp    $0x2f,%al
  8010a7:	7e 19                	jle    8010c2 <strtol+0xc2>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 39                	cmp    $0x39,%al
  8010b0:	7f 10                	jg     8010c2 <strtol+0xc2>
			dig = *s - '0';
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 30             	sub    $0x30,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c0:	eb 42                	jmp    801104 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 60                	cmp    $0x60,%al
  8010c9:	7e 19                	jle    8010e4 <strtol+0xe4>
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 7a                	cmp    $0x7a,%al
  8010d2:	7f 10                	jg     8010e4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f be c0             	movsbl %al,%eax
  8010dc:	83 e8 57             	sub    $0x57,%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e2:	eb 20                	jmp    801104 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 40                	cmp    $0x40,%al
  8010eb:	7e 39                	jle    801126 <strtol+0x126>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 5a                	cmp    $0x5a,%al
  8010f4:	7f 30                	jg     801126 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	0f be c0             	movsbl %al,%eax
  8010fe:	83 e8 37             	sub    $0x37,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110a:	7d 19                	jge    801125 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801112:	0f af 45 10          	imul   0x10(%ebp),%eax
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	01 d0                	add    %edx,%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801120:	e9 7b ff ff ff       	jmp    8010a0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801125:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112a:	74 08                	je     801134 <strtol+0x134>
		*endptr = (char *) s;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801138:	74 07                	je     801141 <strtol+0x141>
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	f7 d8                	neg    %eax
  80113f:	eb 03                	jmp    801144 <strtol+0x144>
  801141:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <ltostr>:

void
ltostr(long value, char *str)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	79 13                	jns    801173 <ltostr+0x2d>
	{
		neg = 1;
  801160:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80116d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801170:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117b:	99                   	cltd   
  80117c:	f7 f9                	idiv   %ecx
  80117e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801194:	83 c2 30             	add    $0x30,%edx
  801197:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a1:	f7 e9                	imul   %ecx
  8011a3:	c1 fa 02             	sar    $0x2,%edx
  8011a6:	89 c8                	mov    %ecx,%eax
  8011a8:	c1 f8 1f             	sar    $0x1f,%eax
  8011ab:	29 c2                	sub    %eax,%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ba:	f7 e9                	imul   %ecx
  8011bc:	c1 fa 02             	sar    $0x2,%edx
  8011bf:	89 c8                	mov    %ecx,%eax
  8011c1:	c1 f8 1f             	sar    $0x1f,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	c1 e0 02             	shl    $0x2,%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	01 c0                	add    %eax,%eax
  8011cf:	29 c1                	sub    %eax,%ecx
  8011d1:	89 ca                	mov    %ecx,%edx
  8011d3:	85 d2                	test   %edx,%edx
  8011d5:	75 9c                	jne    801173 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e9:	74 3d                	je     801228 <ltostr+0xe2>
		start = 1 ;
  8011eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f2:	eb 34                	jmp    801228 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801220:	88 02                	mov    %al,(%edx)
		start++ ;
  801222:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801225:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122e:	7c c4                	jl     8011f4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801230:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801244:	ff 75 08             	pushl  0x8(%ebp)
  801247:	e8 54 fa ff ff       	call   800ca0 <strlen>
  80124c:	83 c4 04             	add    $0x4,%esp
  80124f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	e8 46 fa ff ff       	call   800ca0 <strlen>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126e:	eb 17                	jmp    801287 <strcconcat+0x49>
		final[s] = str1[s] ;
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	01 c2                	add    %eax,%edx
  801278:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	01 c8                	add    %ecx,%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801284:	ff 45 fc             	incl   -0x4(%ebp)
  801287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128d:	7c e1                	jl     801270 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80128f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129d:	eb 1f                	jmp    8012be <strcconcat+0x80>
		final[s++] = str2[i] ;
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 c8                	add    %ecx,%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bb:	ff 45 f8             	incl   -0x8(%ebp)
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c4:	7c d9                	jl     80129f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f7:	eb 0c                	jmp    801305 <strsplit+0x31>
			*string++ = 0;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801302:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 18                	je     801326 <strsplit+0x52>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 13 fb ff ff       	call   800e32 <strchr>
  80131f:	83 c4 08             	add    $0x8,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	75 d3                	jne    8012f9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 5a                	je     801389 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	8b 00                	mov    (%eax),%eax
  801334:	83 f8 0f             	cmp    $0xf,%eax
  801337:	75 07                	jne    801340 <strsplit+0x6c>
		{
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb 66                	jmp    8013a6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	8d 48 01             	lea    0x1(%eax),%ecx
  801348:	8b 55 14             	mov    0x14(%ebp),%edx
  80134b:	89 0a                	mov    %ecx,(%edx)
  80134d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 c2                	add    %eax,%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135e:	eb 03                	jmp    801363 <strsplit+0x8f>
			string++;
  801360:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 8b                	je     8012f7 <strsplit+0x23>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	50                   	push   %eax
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 b5 fa ff ff       	call   800e32 <strchr>
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	74 dc                	je     801360 <strsplit+0x8c>
			string++;
	}
  801384:	e9 6e ff ff ff       	jmp    8012f7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801389:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013ae:	a1 04 50 80 00       	mov    0x805004,%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 1f                	je     8013d6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013b7:	e8 1d 00 00 00       	call   8013d9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	68 90 3e 80 00       	push   $0x803e90
  8013c4:	e8 55 f2 ff ff       	call   80061e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013cc:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8013d3:	00 00 00 
	}
}
  8013d6:	90                   	nop
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	//panic("initialize_dyn_block_system() is not implemented yet...!!");

	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	LIST_INIT(&AllocMemBlocksList);
  8013df:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8013e6:	00 00 00 
  8013e9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8013f0:	00 00 00 
  8013f3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8013fa:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013fd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801404:	00 00 00 
  801407:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80140e:	00 00 00 
  801411:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801418:	00 00 00 
	uint32 arr_size = 0;
  80141b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	MemBlockNodes  =(struct MemBlock*) USER_DYN_BLKS_ARRAY;
  801422:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801431:	2d 00 10 00 00       	sub    $0x1000,%eax
  801436:	a3 50 50 80 00       	mov    %eax,0x805050
	MAX_MEM_BLOCK_CNT = (USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE;
  80143b:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801442:	00 02 00 
	arr_size =  ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock), PAGE_SIZE);
  801445:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80144c:	a1 20 51 80 00       	mov    0x805120,%eax
  801451:	c1 e0 04             	shl    $0x4,%eax
  801454:	89 c2                	mov    %eax,%edx
  801456:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801459:	01 d0                	add    %edx,%eax
  80145b:	48                   	dec    %eax
  80145c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80145f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801462:	ba 00 00 00 00       	mov    $0x0,%edx
  801467:	f7 75 ec             	divl   -0x14(%ebp)
  80146a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80146d:	29 d0                	sub    %edx,%eax
  80146f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY , arr_size , PERM_WRITEABLE | PERM_USER);
  801472:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801481:	2d 00 10 00 00       	sub    $0x1000,%eax
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	6a 06                	push   $0x6
  80148b:	ff 75 f4             	pushl  -0xc(%ebp)
  80148e:	50                   	push   %eax
  80148f:	e8 b2 05 00 00       	call   801a46 <sys_allocate_chunk>
  801494:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801497:	a1 20 51 80 00       	mov    0x805120,%eax
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	50                   	push   %eax
  8014a0:	e8 27 0c 00 00       	call   8020cc <initialize_MemBlocksList>
  8014a5:	83 c4 10             	add    $0x10,%esp
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	struct MemBlock * NewBlock = LIST_FIRST(&AvailableMemBlocksList);
  8014a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8014ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
	NewBlock->sva = USER_HEAP_START;
  8014b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b3:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	NewBlock->size = (USER_HEAP_MAX-USER_HEAP_START);
  8014ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014bd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	LIST_REMOVE(&AvailableMemBlocksList,NewBlock);
  8014c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014c8:	75 14                	jne    8014de <initialize_dyn_block_system+0x105>
  8014ca:	83 ec 04             	sub    $0x4,%esp
  8014cd:	68 b5 3e 80 00       	push   $0x803eb5
  8014d2:	6a 33                	push   $0x33
  8014d4:	68 d3 3e 80 00       	push   $0x803ed3
  8014d9:	e8 8c ee ff ff       	call   80036a <_panic>
  8014de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e1:	8b 00                	mov    (%eax),%eax
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	74 10                	je     8014f7 <initialize_dyn_block_system+0x11e>
  8014e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ea:	8b 00                	mov    (%eax),%eax
  8014ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014ef:	8b 52 04             	mov    0x4(%edx),%edx
  8014f2:	89 50 04             	mov    %edx,0x4(%eax)
  8014f5:	eb 0b                	jmp    801502 <initialize_dyn_block_system+0x129>
  8014f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014fa:	8b 40 04             	mov    0x4(%eax),%eax
  8014fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	8b 40 04             	mov    0x4(%eax),%eax
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 0f                	je     80151b <initialize_dyn_block_system+0x142>
  80150c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150f:	8b 40 04             	mov    0x4(%eax),%eax
  801512:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801515:	8b 12                	mov    (%edx),%edx
  801517:	89 10                	mov    %edx,(%eax)
  801519:	eb 0a                	jmp    801525 <initialize_dyn_block_system+0x14c>
  80151b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151e:	8b 00                	mov    (%eax),%eax
  801520:	a3 48 51 80 00       	mov    %eax,0x805148
  801525:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801528:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80152e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801531:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801538:	a1 54 51 80 00       	mov    0x805154,%eax
  80153d:	48                   	dec    %eax
  80153e:	a3 54 51 80 00       	mov    %eax,0x805154
	LIST_INSERT_HEAD(&FreeMemBlocksList, NewBlock);
  801543:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801547:	75 14                	jne    80155d <initialize_dyn_block_system+0x184>
  801549:	83 ec 04             	sub    $0x4,%esp
  80154c:	68 e0 3e 80 00       	push   $0x803ee0
  801551:	6a 34                	push   $0x34
  801553:	68 d3 3e 80 00       	push   $0x803ed3
  801558:	e8 0d ee ff ff       	call   80036a <_panic>
  80155d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801563:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801566:	89 10                	mov    %edx,(%eax)
  801568:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80156b:	8b 00                	mov    (%eax),%eax
  80156d:	85 c0                	test   %eax,%eax
  80156f:	74 0d                	je     80157e <initialize_dyn_block_system+0x1a5>
  801571:	a1 38 51 80 00       	mov    0x805138,%eax
  801576:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801579:	89 50 04             	mov    %edx,0x4(%eax)
  80157c:	eb 08                	jmp    801586 <initialize_dyn_block_system+0x1ad>
  80157e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801581:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801586:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801589:	a3 38 51 80 00       	mov    %eax,0x805138
  80158e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801591:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801598:	a1 44 51 80 00       	mov    0x805144,%eax
  80159d:	40                   	inc    %eax
  80159e:	a3 44 51 80 00       	mov    %eax,0x805144
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ac:	e8 f7 fd ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b5:	75 07                	jne    8015be <malloc+0x18>
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	eb 61                	jmp    80161f <malloc+0x79>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
	uint32 malloc_allocsize=ROUNDUP(size,PAGE_SIZE);
  8015be:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	01 d0                	add    %edx,%eax
  8015cd:	48                   	dec    %eax
  8015ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d9:	f7 75 f0             	divl   -0x10(%ebp)
  8015dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015df:	29 d0                	sub    %edx,%eax
  8015e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	 //int ret=0;
	struct MemBlock * user_block;
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015e4:	e8 2b 08 00 00       	call   801e14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	74 11                	je     8015fe <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f3:	e8 96 0e 00 00       	call   80248e <alloc_block_FF>
  8015f8:	83 c4 10             	add    $0x10,%esp
  8015fb:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(user_block!=NULL)
  8015fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801602:	74 16                	je     80161a <malloc+0x74>
	{
		//sys_allocate_chunk(user_block->sva,malloc_allocsize,PERM_WRITEABLE| PERM_PRESENT);
		insert_sorted_allocList(user_block);
  801604:	83 ec 0c             	sub    $0xc,%esp
  801607:	ff 75 f4             	pushl  -0xc(%ebp)
  80160a:	e8 f2 0b 00 00       	call   802201 <insert_sorted_allocList>
  80160f:	83 c4 10             	add    $0x10,%esp
		return (uint32 *)user_block->sva;
  801612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801615:	8b 40 08             	mov    0x8(%eax),%eax
  801618:	eb 05                	jmp    80161f <malloc+0x79>
	}

    return NULL;
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");
	struct MemBlock * free_block=find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	83 ec 08             	sub    $0x8,%esp
  80162d:	50                   	push   %eax
  80162e:	68 40 50 80 00       	push   $0x805040
  801633:	e8 71 0b 00 00       	call   8021a9 <find_block>
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(free_block!=NULL)
  80163e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801642:	0f 84 a6 00 00 00    	je     8016ee <free+0xcd>
	{
		sys_free_user_mem(free_block->sva,free_block->size);
  801648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164b:	8b 50 0c             	mov    0xc(%eax),%edx
  80164e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801651:	8b 40 08             	mov    0x8(%eax),%eax
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	52                   	push   %edx
  801658:	50                   	push   %eax
  801659:	e8 b0 03 00 00       	call   801a0e <sys_free_user_mem>
  80165e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,free_block);
  801661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801665:	75 14                	jne    80167b <free+0x5a>
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	68 b5 3e 80 00       	push   $0x803eb5
  80166f:	6a 74                	push   $0x74
  801671:	68 d3 3e 80 00       	push   $0x803ed3
  801676:	e8 ef ec ff ff       	call   80036a <_panic>
  80167b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167e:	8b 00                	mov    (%eax),%eax
  801680:	85 c0                	test   %eax,%eax
  801682:	74 10                	je     801694 <free+0x73>
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	8b 00                	mov    (%eax),%eax
  801689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80168c:	8b 52 04             	mov    0x4(%edx),%edx
  80168f:	89 50 04             	mov    %edx,0x4(%eax)
  801692:	eb 0b                	jmp    80169f <free+0x7e>
  801694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801697:	8b 40 04             	mov    0x4(%eax),%eax
  80169a:	a3 44 50 80 00       	mov    %eax,0x805044
  80169f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a2:	8b 40 04             	mov    0x4(%eax),%eax
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	74 0f                	je     8016b8 <free+0x97>
  8016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ac:	8b 40 04             	mov    0x4(%eax),%eax
  8016af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b2:	8b 12                	mov    (%edx),%edx
  8016b4:	89 10                	mov    %edx,(%eax)
  8016b6:	eb 0a                	jmp    8016c2 <free+0xa1>
  8016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bb:	8b 00                	mov    (%eax),%eax
  8016bd:	a3 40 50 80 00       	mov    %eax,0x805040
  8016c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016d5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8016da:	48                   	dec    %eax
  8016db:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(free_block);
  8016e0:	83 ec 0c             	sub    $0xc,%esp
  8016e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e6:	e8 4e 17 00 00       	call   802e39 <insert_sorted_with_merge_freeList>
  8016eb:	83 c4 10             	add    $0x10,%esp
	}

	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016ee:	90                   	nop
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 38             	sub    $0x38,%esp
  8016f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fa:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016fd:	e8 a6 fc ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801702:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801706:	75 0a                	jne    801712 <smalloc+0x21>
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
  80170d:	e9 8b 00 00 00       	jmp    80179d <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801712:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171f:	01 d0                	add    %edx,%eax
  801721:	48                   	dec    %eax
  801722:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801728:	ba 00 00 00 00       	mov    $0x0,%edx
  80172d:	f7 75 f0             	divl   -0x10(%ebp)
  801730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801733:	29 d0                	sub    %edx,%eax
  801735:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801738:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80173f:	e8 d0 06 00 00       	call   801e14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801744:	85 c0                	test   %eax,%eax
  801746:	74 11                	je     801759 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801748:	83 ec 0c             	sub    $0xc,%esp
  80174b:	ff 75 e8             	pushl  -0x18(%ebp)
  80174e:	e8 3b 0d 00 00       	call   80248e <alloc_block_FF>
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  801759:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80175d:	74 39                	je     801798 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80175f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801762:	8b 40 08             	mov    0x8(%eax),%eax
  801765:	89 c2                	mov    %eax,%edx
  801767:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80176b:	52                   	push   %edx
  80176c:	50                   	push   %eax
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	ff 75 08             	pushl  0x8(%ebp)
  801773:	e8 21 04 00 00       	call   801b99 <sys_createSharedObject>
  801778:	83 c4 10             	add    $0x10,%esp
  80177b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80177e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801782:	74 14                	je     801798 <smalloc+0xa7>
  801784:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801788:	74 0e                	je     801798 <smalloc+0xa7>
  80178a:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80178e:	74 08                	je     801798 <smalloc+0xa7>
			return (void*) mem_block->sva;
  801790:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801793:	8b 40 08             	mov    0x8(%eax),%eax
  801796:	eb 05                	jmp    80179d <smalloc+0xac>
	}
	return NULL;
  801798:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a5:	e8 fe fb ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017aa:	83 ec 08             	sub    $0x8,%esp
  8017ad:	ff 75 0c             	pushl  0xc(%ebp)
  8017b0:	ff 75 08             	pushl  0x8(%ebp)
  8017b3:	e8 0b 04 00 00       	call   801bc3 <sys_getSizeOfSharedObject>
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  8017be:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  8017c2:	74 76                	je     80183a <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  8017c4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d1:	01 d0                	add    %edx,%eax
  8017d3:	48                   	dec    %eax
  8017d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	f7 75 ec             	divl   -0x14(%ebp)
  8017e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e5:	29 d0                	sub    %edx,%eax
  8017e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  8017ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  8017f1:	e8 1e 06 00 00       	call   801e14 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	74 11                	je     80180b <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  8017fa:	83 ec 0c             	sub    $0xc,%esp
  8017fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801800:	e8 89 0c 00 00       	call   80248e <alloc_block_FF>
  801805:	83 c4 10             	add    $0x10,%esp
  801808:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  80180b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80180f:	74 29                	je     80183a <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  801811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801814:	8b 40 08             	mov    0x8(%eax),%eax
  801817:	83 ec 04             	sub    $0x4,%esp
  80181a:	50                   	push   %eax
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	e8 ba 03 00 00       	call   801be0 <sys_getSharedObject>
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  80182c:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  801830:	74 08                	je     80183a <sget+0x9b>
				return (void *)mem_block->sva;
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	8b 40 08             	mov    0x8(%eax),%eax
  801838:	eb 05                	jmp    80183f <sget+0xa0>
		}
	}
	return NULL;
  80183a:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801847:	e8 5c fb ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80184c:	83 ec 04             	sub    $0x4,%esp
  80184f:	68 04 3f 80 00       	push   $0x803f04
  801854:	68 f7 00 00 00       	push   $0xf7
  801859:	68 d3 3e 80 00       	push   $0x803ed3
  80185e:	e8 07 eb ff ff       	call   80036a <_panic>

00801863 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	68 2c 3f 80 00       	push   $0x803f2c
  801871:	68 0b 01 00 00       	push   $0x10b
  801876:	68 d3 3e 80 00       	push   $0x803ed3
  80187b:	e8 ea ea ff ff       	call   80036a <_panic>

00801880 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	68 50 3f 80 00       	push   $0x803f50
  80188e:	68 16 01 00 00       	push   $0x116
  801893:	68 d3 3e 80 00       	push   $0x803ed3
  801898:	e8 cd ea ff ff       	call   80036a <_panic>

0080189d <shrink>:

}
void shrink(uint32 newSize)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a3:	83 ec 04             	sub    $0x4,%esp
  8018a6:	68 50 3f 80 00       	push   $0x803f50
  8018ab:	68 1b 01 00 00       	push   $0x11b
  8018b0:	68 d3 3e 80 00       	push   $0x803ed3
  8018b5:	e8 b0 ea ff ff       	call   80036a <_panic>

008018ba <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	68 50 3f 80 00       	push   $0x803f50
  8018c8:	68 20 01 00 00       	push   $0x120
  8018cd:	68 d3 3e 80 00       	push   $0x803ed3
  8018d2:	e8 93 ea ff ff       	call   80036a <_panic>

008018d7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	57                   	push   %edi
  8018db:	56                   	push   %esi
  8018dc:	53                   	push   %ebx
  8018dd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ec:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ef:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018f2:	cd 30                	int    $0x30
  8018f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5f                   	pop    %edi
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80190e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	52                   	push   %edx
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	50                   	push   %eax
  80191e:	6a 00                	push   $0x0
  801920:	e8 b2 ff ff ff       	call   8018d7 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	90                   	nop
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_cgetc>:

int
sys_cgetc(void)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 01                	push   $0x1
  80193a:	e8 98 ff ff ff       	call   8018d7 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194a:	8b 45 08             	mov    0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	6a 05                	push   $0x5
  801957:	e8 7b ff ff ff       	call   8018d7 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	56                   	push   %esi
  801965:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801966:	8b 75 18             	mov    0x18(%ebp),%esi
  801969:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80196c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	56                   	push   %esi
  801976:	53                   	push   %ebx
  801977:	51                   	push   %ecx
  801978:	52                   	push   %edx
  801979:	50                   	push   %eax
  80197a:	6a 06                	push   $0x6
  80197c:	e8 56 ff ff ff       	call   8018d7 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    

0080198b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	52                   	push   %edx
  80199b:	50                   	push   %eax
  80199c:	6a 07                	push   $0x7
  80199e:	e8 34 ff ff ff       	call   8018d7 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	ff 75 0c             	pushl  0xc(%ebp)
  8019b4:	ff 75 08             	pushl  0x8(%ebp)
  8019b7:	6a 08                	push   $0x8
  8019b9:	e8 19 ff ff ff       	call   8018d7 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 09                	push   $0x9
  8019d2:	e8 00 ff ff ff       	call   8018d7 <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 0a                	push   $0xa
  8019eb:	e8 e7 fe ff ff       	call   8018d7 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 0b                	push   $0xb
  801a04:	e8 ce fe ff ff       	call   8018d7 <syscall>
  801a09:	83 c4 18             	add    $0x18,%esp
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	6a 0f                	push   $0xf
  801a1f:	e8 b3 fe ff ff       	call   8018d7 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
	return;
  801a27:	90                   	nop
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	ff 75 08             	pushl  0x8(%ebp)
  801a39:	6a 10                	push   $0x10
  801a3b:	e8 97 fe ff ff       	call   8018d7 <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
	return ;
  801a43:	90                   	nop
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	ff 75 10             	pushl  0x10(%ebp)
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	6a 11                	push   $0x11
  801a58:	e8 7a fe ff ff       	call   8018d7 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a60:	90                   	nop
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 0c                	push   $0xc
  801a72:	e8 60 fe ff ff       	call   8018d7 <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 08             	pushl  0x8(%ebp)
  801a8a:	6a 0d                	push   $0xd
  801a8c:	e8 46 fe ff ff       	call   8018d7 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	c9                   	leave  
  801a95:	c3                   	ret    

00801a96 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 0e                	push   $0xe
  801aa5:	e8 2d fe ff ff       	call   8018d7 <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	90                   	nop
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 13                	push   $0x13
  801abf:	e8 13 fe ff ff       	call   8018d7 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	90                   	nop
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 14                	push   $0x14
  801ad9:	e8 f9 fd ff ff       	call   8018d7 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801af0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	50                   	push   %eax
  801afd:	6a 15                	push   $0x15
  801aff:	e8 d3 fd ff ff       	call   8018d7 <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	90                   	nop
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 16                	push   $0x16
  801b19:	e8 b9 fd ff ff       	call   8018d7 <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	90                   	nop
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	50                   	push   %eax
  801b34:	6a 17                	push   $0x17
  801b36:	e8 9c fd ff ff       	call   8018d7 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 1a                	push   $0x1a
  801b53:	e8 7f fd ff ff       	call   8018d7 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	6a 18                	push   $0x18
  801b70:	e8 62 fd ff ff       	call   8018d7 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	90                   	nop
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	52                   	push   %edx
  801b8b:	50                   	push   %eax
  801b8c:	6a 19                	push   $0x19
  801b8e:	e8 44 fd ff ff       	call   8018d7 <syscall>
  801b93:	83 c4 18             	add    $0x18,%esp
}
  801b96:	90                   	nop
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 04             	sub    $0x4,%esp
  801b9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bac:	8b 45 08             	mov    0x8(%ebp),%eax
  801baf:	6a 00                	push   $0x0
  801bb1:	51                   	push   %ecx
  801bb2:	52                   	push   %edx
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	50                   	push   %eax
  801bb7:	6a 1b                	push   $0x1b
  801bb9:	e8 19 fd ff ff       	call   8018d7 <syscall>
  801bbe:	83 c4 18             	add    $0x18,%esp
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	52                   	push   %edx
  801bd3:	50                   	push   %eax
  801bd4:	6a 1c                	push   $0x1c
  801bd6:	e8 fc fc ff ff       	call   8018d7 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801be3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	51                   	push   %ecx
  801bf1:	52                   	push   %edx
  801bf2:	50                   	push   %eax
  801bf3:	6a 1d                	push   $0x1d
  801bf5:	e8 dd fc ff ff       	call   8018d7 <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c05:	8b 45 08             	mov    0x8(%ebp),%eax
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	52                   	push   %edx
  801c0f:	50                   	push   %eax
  801c10:	6a 1e                	push   $0x1e
  801c12:	e8 c0 fc ff ff       	call   8018d7 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 1f                	push   $0x1f
  801c2b:	e8 a7 fc ff ff       	call   8018d7 <syscall>
  801c30:	83 c4 18             	add    $0x18,%esp
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	ff 75 14             	pushl  0x14(%ebp)
  801c40:	ff 75 10             	pushl  0x10(%ebp)
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	50                   	push   %eax
  801c47:	6a 20                	push   $0x20
  801c49:	e8 89 fc ff ff       	call   8018d7 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	50                   	push   %eax
  801c62:	6a 21                	push   $0x21
  801c64:	e8 6e fc ff ff       	call   8018d7 <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	90                   	nop
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c72:	8b 45 08             	mov    0x8(%ebp),%eax
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	50                   	push   %eax
  801c7e:	6a 22                	push   $0x22
  801c80:	e8 52 fc ff ff       	call   8018d7 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 02                	push   $0x2
  801c99:	e8 39 fc ff ff       	call   8018d7 <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 03                	push   $0x3
  801cb2:	e8 20 fc ff ff       	call   8018d7 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 04                	push   $0x4
  801ccb:	e8 07 fc ff ff       	call   8018d7 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 23                	push   $0x23
  801ce4:	e8 ee fb ff ff       	call   8018d7 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
}
  801cec:	90                   	nop
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf8:	8d 50 04             	lea    0x4(%eax),%edx
  801cfb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	52                   	push   %edx
  801d05:	50                   	push   %eax
  801d06:	6a 24                	push   $0x24
  801d08:	e8 ca fb ff ff       	call   8018d7 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
	return result;
  801d10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d19:	89 01                	mov    %eax,(%ecx)
  801d1b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	c9                   	leave  
  801d22:	c2 04 00             	ret    $0x4

00801d25 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	ff 75 10             	pushl  0x10(%ebp)
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	ff 75 08             	pushl  0x8(%ebp)
  801d35:	6a 12                	push   $0x12
  801d37:	e8 9b fb ff ff       	call   8018d7 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3f:	90                   	nop
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 25                	push   $0x25
  801d51:	e8 81 fb ff ff       	call   8018d7 <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	c9                   	leave  
  801d5a:	c3                   	ret    

00801d5b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	83 ec 04             	sub    $0x4,%esp
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d67:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	50                   	push   %eax
  801d74:	6a 26                	push   $0x26
  801d76:	e8 5c fb ff ff       	call   8018d7 <syscall>
  801d7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7e:	90                   	nop
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <rsttst>:
void rsttst()
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 28                	push   $0x28
  801d90:	e8 42 fb ff ff       	call   8018d7 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
	return ;
  801d98:	90                   	nop
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	8b 45 14             	mov    0x14(%ebp),%eax
  801da4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801da7:	8b 55 18             	mov    0x18(%ebp),%edx
  801daa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dae:	52                   	push   %edx
  801daf:	50                   	push   %eax
  801db0:	ff 75 10             	pushl  0x10(%ebp)
  801db3:	ff 75 0c             	pushl  0xc(%ebp)
  801db6:	ff 75 08             	pushl  0x8(%ebp)
  801db9:	6a 27                	push   $0x27
  801dbb:	e8 17 fb ff ff       	call   8018d7 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc3:	90                   	nop
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <chktst>:
void chktst(uint32 n)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	6a 29                	push   $0x29
  801dd6:	e8 fc fa ff ff       	call   8018d7 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dde:	90                   	nop
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <inctst>:

void inctst()
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 2a                	push   $0x2a
  801df0:	e8 e2 fa ff ff       	call   8018d7 <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
	return ;
  801df8:	90                   	nop
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <gettst>:
uint32 gettst()
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 2b                	push   $0x2b
  801e0a:	e8 c8 fa ff ff       	call   8018d7 <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 2c                	push   $0x2c
  801e26:	e8 ac fa ff ff       	call   8018d7 <syscall>
  801e2b:	83 c4 18             	add    $0x18,%esp
  801e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e31:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e35:	75 07                	jne    801e3e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e37:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3c:	eb 05                	jmp    801e43 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 2c                	push   $0x2c
  801e57:	e8 7b fa ff ff       	call   8018d7 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
  801e5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e62:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e66:	75 07                	jne    801e6f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e68:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6d:	eb 05                	jmp    801e74 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 2c                	push   $0x2c
  801e88:	e8 4a fa ff ff       	call   8018d7 <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
  801e90:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e93:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e97:	75 07                	jne    801ea0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e99:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9e:	eb 05                	jmp    801ea5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
  801eaa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 2c                	push   $0x2c
  801eb9:	e8 19 fa ff ff       	call   8018d7 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
  801ec1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ec4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec8:	75 07                	jne    801ed1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eca:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecf:	eb 05                	jmp    801ed6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	ff 75 08             	pushl  0x8(%ebp)
  801ee6:	6a 2d                	push   $0x2d
  801ee8:	e8 ea f9 ff ff       	call   8018d7 <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef0:	90                   	nop
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ef7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801efa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801efd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	6a 00                	push   $0x0
  801f05:	53                   	push   %ebx
  801f06:	51                   	push   %ecx
  801f07:	52                   	push   %edx
  801f08:	50                   	push   %eax
  801f09:	6a 2e                	push   $0x2e
  801f0b:	e8 c7 f9 ff ff       	call   8018d7 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	52                   	push   %edx
  801f28:	50                   	push   %eax
  801f29:	6a 2f                	push   $0x2f
  801f2b:	e8 a7 f9 ff ff       	call   8018d7 <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
}
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	68 60 3f 80 00       	push   $0x803f60
  801f43:	e8 d6 e6 ff ff       	call   80061e <cprintf>
  801f48:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	68 8c 3f 80 00       	push   $0x803f8c
  801f5a:	e8 bf e6 ff ff       	call   80061e <cprintf>
  801f5f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f62:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f66:	a1 38 51 80 00       	mov    0x805138,%eax
  801f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6e:	eb 56                	jmp    801fc6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f74:	74 1c                	je     801f92 <print_mem_block_lists+0x5d>
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	8b 50 08             	mov    0x8(%eax),%edx
  801f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7f:	8b 48 08             	mov    0x8(%eax),%ecx
  801f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f85:	8b 40 0c             	mov    0xc(%eax),%eax
  801f88:	01 c8                	add    %ecx,%eax
  801f8a:	39 c2                	cmp    %eax,%edx
  801f8c:	73 04                	jae    801f92 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f8e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	8b 50 08             	mov    0x8(%eax),%edx
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9e:	01 c2                	add    %eax,%edx
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 40 08             	mov    0x8(%eax),%eax
  801fa6:	83 ec 04             	sub    $0x4,%esp
  801fa9:	52                   	push   %edx
  801faa:	50                   	push   %eax
  801fab:	68 a1 3f 80 00       	push   $0x803fa1
  801fb0:	e8 69 e6 ff ff       	call   80061e <cprintf>
  801fb5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fbe:	a1 40 51 80 00       	mov    0x805140,%eax
  801fc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fca:	74 07                	je     801fd3 <print_mem_block_lists+0x9e>
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	8b 00                	mov    (%eax),%eax
  801fd1:	eb 05                	jmp    801fd8 <print_mem_block_lists+0xa3>
  801fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd8:	a3 40 51 80 00       	mov    %eax,0x805140
  801fdd:	a1 40 51 80 00       	mov    0x805140,%eax
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	75 8a                	jne    801f70 <print_mem_block_lists+0x3b>
  801fe6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fea:	75 84                	jne    801f70 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fec:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff0:	75 10                	jne    802002 <print_mem_block_lists+0xcd>
  801ff2:	83 ec 0c             	sub    $0xc,%esp
  801ff5:	68 b0 3f 80 00       	push   $0x803fb0
  801ffa:	e8 1f e6 ff ff       	call   80061e <cprintf>
  801fff:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802002:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	68 d4 3f 80 00       	push   $0x803fd4
  802011:	e8 08 e6 ff ff       	call   80061e <cprintf>
  802016:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802019:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80201d:	a1 40 50 80 00       	mov    0x805040,%eax
  802022:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802025:	eb 56                	jmp    80207d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802027:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80202b:	74 1c                	je     802049 <print_mem_block_lists+0x114>
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 50 08             	mov    0x8(%eax),%edx
  802033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802036:	8b 48 08             	mov    0x8(%eax),%ecx
  802039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203c:	8b 40 0c             	mov    0xc(%eax),%eax
  80203f:	01 c8                	add    %ecx,%eax
  802041:	39 c2                	cmp    %eax,%edx
  802043:	73 04                	jae    802049 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802045:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204c:	8b 50 08             	mov    0x8(%eax),%edx
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802052:	8b 40 0c             	mov    0xc(%eax),%eax
  802055:	01 c2                	add    %eax,%edx
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	8b 40 08             	mov    0x8(%eax),%eax
  80205d:	83 ec 04             	sub    $0x4,%esp
  802060:	52                   	push   %edx
  802061:	50                   	push   %eax
  802062:	68 a1 3f 80 00       	push   $0x803fa1
  802067:	e8 b2 e5 ff ff       	call   80061e <cprintf>
  80206c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802075:	a1 48 50 80 00       	mov    0x805048,%eax
  80207a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802081:	74 07                	je     80208a <print_mem_block_lists+0x155>
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	8b 00                	mov    (%eax),%eax
  802088:	eb 05                	jmp    80208f <print_mem_block_lists+0x15a>
  80208a:	b8 00 00 00 00       	mov    $0x0,%eax
  80208f:	a3 48 50 80 00       	mov    %eax,0x805048
  802094:	a1 48 50 80 00       	mov    0x805048,%eax
  802099:	85 c0                	test   %eax,%eax
  80209b:	75 8a                	jne    802027 <print_mem_block_lists+0xf2>
  80209d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a1:	75 84                	jne    802027 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020a3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a7:	75 10                	jne    8020b9 <print_mem_block_lists+0x184>
  8020a9:	83 ec 0c             	sub    $0xc,%esp
  8020ac:	68 ec 3f 80 00       	push   $0x803fec
  8020b1:	e8 68 e5 ff ff       	call   80061e <cprintf>
  8020b6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020b9:	83 ec 0c             	sub    $0xc,%esp
  8020bc:	68 60 3f 80 00       	push   $0x803f60
  8020c1:	e8 58 e5 ff ff       	call   80061e <cprintf>
  8020c6:	83 c4 10             	add    $0x10,%esp

}
  8020c9:	90                   	nop
  8020ca:	c9                   	leave  
  8020cb:	c3                   	ret    

008020cc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  8020d2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8020d9:	00 00 00 
  8020dc:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8020e3:	00 00 00 
  8020e6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8020ed:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  8020f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020f7:	e9 9e 00 00 00       	jmp    80219a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  8020fc:	a1 50 50 80 00       	mov    0x805050,%eax
  802101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802104:	c1 e2 04             	shl    $0x4,%edx
  802107:	01 d0                	add    %edx,%eax
  802109:	85 c0                	test   %eax,%eax
  80210b:	75 14                	jne    802121 <initialize_MemBlocksList+0x55>
  80210d:	83 ec 04             	sub    $0x4,%esp
  802110:	68 14 40 80 00       	push   $0x804014
  802115:	6a 46                	push   $0x46
  802117:	68 37 40 80 00       	push   $0x804037
  80211c:	e8 49 e2 ff ff       	call   80036a <_panic>
  802121:	a1 50 50 80 00       	mov    0x805050,%eax
  802126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802129:	c1 e2 04             	shl    $0x4,%edx
  80212c:	01 d0                	add    %edx,%eax
  80212e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802134:	89 10                	mov    %edx,(%eax)
  802136:	8b 00                	mov    (%eax),%eax
  802138:	85 c0                	test   %eax,%eax
  80213a:	74 18                	je     802154 <initialize_MemBlocksList+0x88>
  80213c:	a1 48 51 80 00       	mov    0x805148,%eax
  802141:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802147:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80214a:	c1 e1 04             	shl    $0x4,%ecx
  80214d:	01 ca                	add    %ecx,%edx
  80214f:	89 50 04             	mov    %edx,0x4(%eax)
  802152:	eb 12                	jmp    802166 <initialize_MemBlocksList+0x9a>
  802154:	a1 50 50 80 00       	mov    0x805050,%eax
  802159:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215c:	c1 e2 04             	shl    $0x4,%edx
  80215f:	01 d0                	add    %edx,%eax
  802161:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802166:	a1 50 50 80 00       	mov    0x805050,%eax
  80216b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216e:	c1 e2 04             	shl    $0x4,%edx
  802171:	01 d0                	add    %edx,%eax
  802173:	a3 48 51 80 00       	mov    %eax,0x805148
  802178:	a1 50 50 80 00       	mov    0x805050,%eax
  80217d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802180:	c1 e2 04             	shl    $0x4,%edx
  802183:	01 d0                	add    %edx,%eax
  802185:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218c:	a1 54 51 80 00       	mov    0x805154,%eax
  802191:	40                   	inc    %eax
  802192:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802197:	ff 45 f4             	incl   -0xc(%ebp)
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021a0:	0f 82 56 ff ff ff    	jb     8020fc <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8021a6:	90                   	nop
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b7:	eb 19                	jmp    8021d2 <find_block+0x29>
	{
		if(va==point->sva)
  8021b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021bc:	8b 40 08             	mov    0x8(%eax),%eax
  8021bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021c2:	75 05                	jne    8021c9 <find_block+0x20>
		   return point;
  8021c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c7:	eb 36                	jmp    8021ff <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	8b 40 08             	mov    0x8(%eax),%eax
  8021cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d6:	74 07                	je     8021df <find_block+0x36>
  8021d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021db:	8b 00                	mov    (%eax),%eax
  8021dd:	eb 05                	jmp    8021e4 <find_block+0x3b>
  8021df:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e7:	89 42 08             	mov    %eax,0x8(%edx)
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	8b 40 08             	mov    0x8(%eax),%eax
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	75 c5                	jne    8021b9 <find_block+0x10>
  8021f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f8:	75 bf                	jne    8021b9 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8021fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
  802204:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802207:	a1 40 50 80 00       	mov    0x805040,%eax
  80220c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80220f:	a1 44 50 80 00       	mov    0x805044,%eax
  802214:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80221a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80221d:	74 24                	je     802243 <insert_sorted_allocList+0x42>
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	8b 50 08             	mov    0x8(%eax),%edx
  802225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802228:	8b 40 08             	mov    0x8(%eax),%eax
  80222b:	39 c2                	cmp    %eax,%edx
  80222d:	76 14                	jbe    802243 <insert_sorted_allocList+0x42>
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	8b 50 08             	mov    0x8(%eax),%edx
  802235:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802238:	8b 40 08             	mov    0x8(%eax),%eax
  80223b:	39 c2                	cmp    %eax,%edx
  80223d:	0f 82 60 01 00 00    	jb     8023a3 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  802243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802247:	75 65                	jne    8022ae <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224d:	75 14                	jne    802263 <insert_sorted_allocList+0x62>
  80224f:	83 ec 04             	sub    $0x4,%esp
  802252:	68 14 40 80 00       	push   $0x804014
  802257:	6a 6b                	push   $0x6b
  802259:	68 37 40 80 00       	push   $0x804037
  80225e:	e8 07 e1 ff ff       	call   80036a <_panic>
  802263:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	89 10                	mov    %edx,(%eax)
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	8b 00                	mov    (%eax),%eax
  802273:	85 c0                	test   %eax,%eax
  802275:	74 0d                	je     802284 <insert_sorted_allocList+0x83>
  802277:	a1 40 50 80 00       	mov    0x805040,%eax
  80227c:	8b 55 08             	mov    0x8(%ebp),%edx
  80227f:	89 50 04             	mov    %edx,0x4(%eax)
  802282:	eb 08                	jmp    80228c <insert_sorted_allocList+0x8b>
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	a3 44 50 80 00       	mov    %eax,0x805044
  80228c:	8b 45 08             	mov    0x8(%ebp),%eax
  80228f:	a3 40 50 80 00       	mov    %eax,0x805040
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022a3:	40                   	inc    %eax
  8022a4:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022a9:	e9 dc 01 00 00       	jmp    80248a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	8b 50 08             	mov    0x8(%eax),%edx
  8022b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b7:	8b 40 08             	mov    0x8(%eax),%eax
  8022ba:	39 c2                	cmp    %eax,%edx
  8022bc:	77 6c                	ja     80232a <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  8022be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022c2:	74 06                	je     8022ca <insert_sorted_allocList+0xc9>
  8022c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c8:	75 14                	jne    8022de <insert_sorted_allocList+0xdd>
  8022ca:	83 ec 04             	sub    $0x4,%esp
  8022cd:	68 50 40 80 00       	push   $0x804050
  8022d2:	6a 6f                	push   $0x6f
  8022d4:	68 37 40 80 00       	push   $0x804037
  8022d9:	e8 8c e0 ff ff       	call   80036a <_panic>
  8022de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e1:	8b 50 04             	mov    0x4(%eax),%edx
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022f0:	89 10                	mov    %edx,(%eax)
  8022f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f5:	8b 40 04             	mov    0x4(%eax),%eax
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	74 0d                	je     802309 <insert_sorted_allocList+0x108>
  8022fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ff:	8b 40 04             	mov    0x4(%eax),%eax
  802302:	8b 55 08             	mov    0x8(%ebp),%edx
  802305:	89 10                	mov    %edx,(%eax)
  802307:	eb 08                	jmp    802311 <insert_sorted_allocList+0x110>
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	a3 40 50 80 00       	mov    %eax,0x805040
  802311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802314:	8b 55 08             	mov    0x8(%ebp),%edx
  802317:	89 50 04             	mov    %edx,0x4(%eax)
  80231a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80231f:	40                   	inc    %eax
  802320:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802325:	e9 60 01 00 00       	jmp    80248a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	8b 50 08             	mov    0x8(%eax),%edx
  802330:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802333:	8b 40 08             	mov    0x8(%eax),%eax
  802336:	39 c2                	cmp    %eax,%edx
  802338:	0f 82 4c 01 00 00    	jb     80248a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  80233e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802342:	75 14                	jne    802358 <insert_sorted_allocList+0x157>
  802344:	83 ec 04             	sub    $0x4,%esp
  802347:	68 88 40 80 00       	push   $0x804088
  80234c:	6a 73                	push   $0x73
  80234e:	68 37 40 80 00       	push   $0x804037
  802353:	e8 12 e0 ff ff       	call   80036a <_panic>
  802358:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	89 50 04             	mov    %edx,0x4(%eax)
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 40 04             	mov    0x4(%eax),%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	74 0c                	je     80237a <insert_sorted_allocList+0x179>
  80236e:	a1 44 50 80 00       	mov    0x805044,%eax
  802373:	8b 55 08             	mov    0x8(%ebp),%edx
  802376:	89 10                	mov    %edx,(%eax)
  802378:	eb 08                	jmp    802382 <insert_sorted_allocList+0x181>
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	a3 40 50 80 00       	mov    %eax,0x805040
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	a3 44 50 80 00       	mov    %eax,0x805044
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802393:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802398:	40                   	inc    %eax
  802399:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80239e:	e9 e7 00 00 00       	jmp    80248a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8023a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8023a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8023b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8023b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b8:	e9 9d 00 00 00       	jmp    80245a <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	8b 50 08             	mov    0x8(%eax),%edx
  8023cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ce:	8b 40 08             	mov    0x8(%eax),%eax
  8023d1:	39 c2                	cmp    %eax,%edx
  8023d3:	76 7d                	jbe    802452 <insert_sorted_allocList+0x251>
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	8b 50 08             	mov    0x8(%eax),%edx
  8023db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023de:	8b 40 08             	mov    0x8(%eax),%eax
  8023e1:	39 c2                	cmp    %eax,%edx
  8023e3:	73 6d                	jae    802452 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	74 06                	je     8023f1 <insert_sorted_allocList+0x1f0>
  8023eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ef:	75 14                	jne    802405 <insert_sorted_allocList+0x204>
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	68 ac 40 80 00       	push   $0x8040ac
  8023f9:	6a 7f                	push   $0x7f
  8023fb:	68 37 40 80 00       	push   $0x804037
  802400:	e8 65 df ff ff       	call   80036a <_panic>
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 10                	mov    (%eax),%edx
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	89 10                	mov    %edx,(%eax)
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	85 c0                	test   %eax,%eax
  802416:	74 0b                	je     802423 <insert_sorted_allocList+0x222>
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	8b 55 08             	mov    0x8(%ebp),%edx
  802420:	89 50 04             	mov    %edx,0x4(%eax)
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 55 08             	mov    0x8(%ebp),%edx
  802429:	89 10                	mov    %edx,(%eax)
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802431:	89 50 04             	mov    %edx,0x4(%eax)
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	75 08                	jne    802445 <insert_sorted_allocList+0x244>
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	a3 44 50 80 00       	mov    %eax,0x805044
  802445:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80244a:	40                   	inc    %eax
  80244b:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802450:	eb 39                	jmp    80248b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802452:	a1 48 50 80 00       	mov    0x805048,%eax
  802457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245e:	74 07                	je     802467 <insert_sorted_allocList+0x266>
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 00                	mov    (%eax),%eax
  802465:	eb 05                	jmp    80246c <insert_sorted_allocList+0x26b>
  802467:	b8 00 00 00 00       	mov    $0x0,%eax
  80246c:	a3 48 50 80 00       	mov    %eax,0x805048
  802471:	a1 48 50 80 00       	mov    0x805048,%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	0f 85 3f ff ff ff    	jne    8023bd <insert_sorted_allocList+0x1bc>
  80247e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802482:	0f 85 35 ff ff ff    	jne    8023bd <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802488:	eb 01                	jmp    80248b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80248a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80248b:	90                   	nop
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802494:	a1 38 51 80 00       	mov    0x805138,%eax
  802499:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249c:	e9 85 01 00 00       	jmp    802626 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024aa:	0f 82 6e 01 00 00    	jb     80261e <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b9:	0f 85 8a 00 00 00    	jne    802549 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  8024bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c3:	75 17                	jne    8024dc <alloc_block_FF+0x4e>
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	68 e0 40 80 00       	push   $0x8040e0
  8024cd:	68 93 00 00 00       	push   $0x93
  8024d2:	68 37 40 80 00       	push   $0x804037
  8024d7:	e8 8e de ff ff       	call   80036a <_panic>
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 10                	je     8024f5 <alloc_block_FF+0x67>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ed:	8b 52 04             	mov    0x4(%edx),%edx
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	eb 0b                	jmp    802500 <alloc_block_FF+0x72>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0f                	je     802519 <alloc_block_FF+0x8b>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802513:	8b 12                	mov    (%edx),%edx
  802515:	89 10                	mov    %edx,(%eax)
  802517:	eb 0a                	jmp    802523 <alloc_block_FF+0x95>
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	a3 38 51 80 00       	mov    %eax,0x805138
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802536:	a1 44 51 80 00       	mov    0x805144,%eax
  80253b:	48                   	dec    %eax
  80253c:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	e9 10 01 00 00       	jmp    802659 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 40 0c             	mov    0xc(%eax),%eax
  80254f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802552:	0f 86 c6 00 00 00    	jbe    80261e <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802558:	a1 48 51 80 00       	mov    0x805148,%eax
  80255d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 50 08             	mov    0x8(%eax),%edx
  802566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802569:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  80256c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256f:	8b 55 08             	mov    0x8(%ebp),%edx
  802572:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802579:	75 17                	jne    802592 <alloc_block_FF+0x104>
  80257b:	83 ec 04             	sub    $0x4,%esp
  80257e:	68 e0 40 80 00       	push   $0x8040e0
  802583:	68 9b 00 00 00       	push   $0x9b
  802588:	68 37 40 80 00       	push   $0x804037
  80258d:	e8 d8 dd ff ff       	call   80036a <_panic>
  802592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	85 c0                	test   %eax,%eax
  802599:	74 10                	je     8025ab <alloc_block_FF+0x11d>
  80259b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259e:	8b 00                	mov    (%eax),%eax
  8025a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025a3:	8b 52 04             	mov    0x4(%edx),%edx
  8025a6:	89 50 04             	mov    %edx,0x4(%eax)
  8025a9:	eb 0b                	jmp    8025b6 <alloc_block_FF+0x128>
  8025ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ae:	8b 40 04             	mov    0x4(%eax),%eax
  8025b1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	8b 40 04             	mov    0x4(%eax),%eax
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	74 0f                	je     8025cf <alloc_block_FF+0x141>
  8025c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c3:	8b 40 04             	mov    0x4(%eax),%eax
  8025c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8025c9:	8b 12                	mov    (%edx),%edx
  8025cb:	89 10                	mov    %edx,(%eax)
  8025cd:	eb 0a                	jmp    8025d9 <alloc_block_FF+0x14b>
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	8b 00                	mov    (%eax),%eax
  8025d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8025d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8025f1:	48                   	dec    %eax
  8025f2:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 50 08             	mov    0x8(%eax),%edx
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	01 c2                	add    %eax,%edx
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 0c             	mov    0xc(%eax),%eax
  80260e:	2b 45 08             	sub    0x8(%ebp),%eax
  802611:	89 c2                	mov    %eax,%edx
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261c:	eb 3b                	jmp    802659 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80261e:	a1 40 51 80 00       	mov    0x805140,%eax
  802623:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262a:	74 07                	je     802633 <alloc_block_FF+0x1a5>
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	eb 05                	jmp    802638 <alloc_block_FF+0x1aa>
  802633:	b8 00 00 00 00       	mov    $0x0,%eax
  802638:	a3 40 51 80 00       	mov    %eax,0x805140
  80263d:	a1 40 51 80 00       	mov    0x805140,%eax
  802642:	85 c0                	test   %eax,%eax
  802644:	0f 85 57 fe ff ff    	jne    8024a1 <alloc_block_FF+0x13>
  80264a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264e:	0f 85 4d fe ff ff    	jne    8024a1 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  802654:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802661:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802668:	a1 38 51 80 00       	mov    0x805138,%eax
  80266d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802670:	e9 df 00 00 00       	jmp    802754 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	8b 40 0c             	mov    0xc(%eax),%eax
  80267b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267e:	0f 82 c8 00 00 00    	jb     80274c <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 0c             	mov    0xc(%eax),%eax
  80268a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268d:	0f 85 8a 00 00 00    	jne    80271d <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802693:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802697:	75 17                	jne    8026b0 <alloc_block_BF+0x55>
  802699:	83 ec 04             	sub    $0x4,%esp
  80269c:	68 e0 40 80 00       	push   $0x8040e0
  8026a1:	68 b7 00 00 00       	push   $0xb7
  8026a6:	68 37 40 80 00       	push   $0x804037
  8026ab:	e8 ba dc ff ff       	call   80036a <_panic>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 00                	mov    (%eax),%eax
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	74 10                	je     8026c9 <alloc_block_BF+0x6e>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 00                	mov    (%eax),%eax
  8026be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c1:	8b 52 04             	mov    0x4(%edx),%edx
  8026c4:	89 50 04             	mov    %edx,0x4(%eax)
  8026c7:	eb 0b                	jmp    8026d4 <alloc_block_BF+0x79>
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	8b 40 04             	mov    0x4(%eax),%eax
  8026cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 40 04             	mov    0x4(%eax),%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	74 0f                	je     8026ed <alloc_block_BF+0x92>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 40 04             	mov    0x4(%eax),%eax
  8026e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e7:	8b 12                	mov    (%edx),%edx
  8026e9:	89 10                	mov    %edx,(%eax)
  8026eb:	eb 0a                	jmp    8026f7 <alloc_block_BF+0x9c>
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 00                	mov    (%eax),%eax
  8026f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270a:	a1 44 51 80 00       	mov    0x805144,%eax
  80270f:	48                   	dec    %eax
  802710:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	e9 4d 01 00 00       	jmp    80286a <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	8b 40 0c             	mov    0xc(%eax),%eax
  802723:	3b 45 08             	cmp    0x8(%ebp),%eax
  802726:	76 24                	jbe    80274c <alloc_block_BF+0xf1>
  802728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272b:	8b 40 0c             	mov    0xc(%eax),%eax
  80272e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802731:	73 19                	jae    80274c <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  802733:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	8b 40 08             	mov    0x8(%eax),%eax
  802749:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  80274c:	a1 40 51 80 00       	mov    0x805140,%eax
  802751:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	74 07                	je     802761 <alloc_block_BF+0x106>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 00                	mov    (%eax),%eax
  80275f:	eb 05                	jmp    802766 <alloc_block_BF+0x10b>
  802761:	b8 00 00 00 00       	mov    $0x0,%eax
  802766:	a3 40 51 80 00       	mov    %eax,0x805140
  80276b:	a1 40 51 80 00       	mov    0x805140,%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	0f 85 fd fe ff ff    	jne    802675 <alloc_block_BF+0x1a>
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	0f 85 f3 fe ff ff    	jne    802675 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802782:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802786:	0f 84 d9 00 00 00    	je     802865 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80278c:	a1 48 51 80 00       	mov    0x805148,%eax
  802791:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802797:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80279a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80279d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a3:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8027a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8027aa:	75 17                	jne    8027c3 <alloc_block_BF+0x168>
  8027ac:	83 ec 04             	sub    $0x4,%esp
  8027af:	68 e0 40 80 00       	push   $0x8040e0
  8027b4:	68 c7 00 00 00       	push   $0xc7
  8027b9:	68 37 40 80 00       	push   $0x804037
  8027be:	e8 a7 db ff ff       	call   80036a <_panic>
  8027c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 10                	je     8027dc <alloc_block_BF+0x181>
  8027cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027d4:	8b 52 04             	mov    0x4(%edx),%edx
  8027d7:	89 50 04             	mov    %edx,0x4(%eax)
  8027da:	eb 0b                	jmp    8027e7 <alloc_block_BF+0x18c>
  8027dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 0f                	je     802800 <alloc_block_BF+0x1a5>
  8027f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027fa:	8b 12                	mov    (%edx),%edx
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	eb 0a                	jmp    80280a <alloc_block_BF+0x1af>
  802800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	a3 48 51 80 00       	mov    %eax,0x805148
  80280a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80280d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281d:	a1 54 51 80 00       	mov    0x805154,%eax
  802822:	48                   	dec    %eax
  802823:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802828:	83 ec 08             	sub    $0x8,%esp
  80282b:	ff 75 ec             	pushl  -0x14(%ebp)
  80282e:	68 38 51 80 00       	push   $0x805138
  802833:	e8 71 f9 ff ff       	call   8021a9 <find_block>
  802838:	83 c4 10             	add    $0x10,%esp
  80283b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  80283e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802841:	8b 50 08             	mov    0x8(%eax),%edx
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	01 c2                	add    %eax,%edx
  802849:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284c:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  80284f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802852:	8b 40 0c             	mov    0xc(%eax),%eax
  802855:	2b 45 08             	sub    0x8(%ebp),%eax
  802858:	89 c2                	mov    %eax,%edx
  80285a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285d:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802863:	eb 05                	jmp    80286a <alloc_block_BF+0x20f>
	}
	return NULL;
  802865:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286a:	c9                   	leave  
  80286b:	c3                   	ret    

0080286c <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80286c:	55                   	push   %ebp
  80286d:	89 e5                	mov    %esp,%ebp
  80286f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802872:	a1 28 50 80 00       	mov    0x805028,%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	0f 85 de 01 00 00    	jne    802a5d <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80287f:	a1 38 51 80 00       	mov    0x805138,%eax
  802884:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802887:	e9 9e 01 00 00       	jmp    802a2a <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 0c             	mov    0xc(%eax),%eax
  802892:	3b 45 08             	cmp    0x8(%ebp),%eax
  802895:	0f 82 87 01 00 00    	jb     802a22 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a4:	0f 85 95 00 00 00    	jne    80293f <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8028aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ae:	75 17                	jne    8028c7 <alloc_block_NF+0x5b>
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 e0 40 80 00       	push   $0x8040e0
  8028b8:	68 e0 00 00 00       	push   $0xe0
  8028bd:	68 37 40 80 00       	push   $0x804037
  8028c2:	e8 a3 da ff ff       	call   80036a <_panic>
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 10                	je     8028e0 <alloc_block_NF+0x74>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d8:	8b 52 04             	mov    0x4(%edx),%edx
  8028db:	89 50 04             	mov    %edx,0x4(%eax)
  8028de:	eb 0b                	jmp    8028eb <alloc_block_NF+0x7f>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 0f                	je     802904 <alloc_block_NF+0x98>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fe:	8b 12                	mov    (%edx),%edx
  802900:	89 10                	mov    %edx,(%eax)
  802902:	eb 0a                	jmp    80290e <alloc_block_NF+0xa2>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	a3 38 51 80 00       	mov    %eax,0x805138
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 44 51 80 00       	mov    0x805144,%eax
  802926:	48                   	dec    %eax
  802927:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 40 08             	mov    0x8(%eax),%eax
  802932:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	e9 f8 04 00 00       	jmp    802e37 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  80293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802942:	8b 40 0c             	mov    0xc(%eax),%eax
  802945:	3b 45 08             	cmp    0x8(%ebp),%eax
  802948:	0f 86 d4 00 00 00    	jbe    802a22 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  80294e:	a1 48 51 80 00       	mov    0x805148,%eax
  802953:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 50 08             	mov    0x8(%eax),%edx
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	8b 55 08             	mov    0x8(%ebp),%edx
  802968:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80296b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80296f:	75 17                	jne    802988 <alloc_block_NF+0x11c>
  802971:	83 ec 04             	sub    $0x4,%esp
  802974:	68 e0 40 80 00       	push   $0x8040e0
  802979:	68 e9 00 00 00       	push   $0xe9
  80297e:	68 37 40 80 00       	push   $0x804037
  802983:	e8 e2 d9 ff ff       	call   80036a <_panic>
  802988:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298b:	8b 00                	mov    (%eax),%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	74 10                	je     8029a1 <alloc_block_NF+0x135>
  802991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802994:	8b 00                	mov    (%eax),%eax
  802996:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802999:	8b 52 04             	mov    0x4(%edx),%edx
  80299c:	89 50 04             	mov    %edx,0x4(%eax)
  80299f:	eb 0b                	jmp    8029ac <alloc_block_NF+0x140>
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	8b 40 04             	mov    0x4(%eax),%eax
  8029a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 0f                	je     8029c5 <alloc_block_NF+0x159>
  8029b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b9:	8b 40 04             	mov    0x4(%eax),%eax
  8029bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029bf:	8b 12                	mov    (%edx),%edx
  8029c1:	89 10                	mov    %edx,(%eax)
  8029c3:	eb 0a                	jmp    8029cf <alloc_block_NF+0x163>
  8029c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c8:	8b 00                	mov    (%eax),%eax
  8029ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e2:	a1 54 51 80 00       	mov    0x805154,%eax
  8029e7:	48                   	dec    %eax
  8029e8:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 40 08             	mov    0x8(%eax),%eax
  8029f3:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	8b 50 08             	mov    0x8(%eax),%edx
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	01 c2                	add    %eax,%edx
  802a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a06:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a12:	89 c2                	mov    %eax,%edx
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	e9 15 04 00 00       	jmp    802e37 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802a22:	a1 40 51 80 00       	mov    0x805140,%eax
  802a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a2e:	74 07                	je     802a37 <alloc_block_NF+0x1cb>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 00                	mov    (%eax),%eax
  802a35:	eb 05                	jmp    802a3c <alloc_block_NF+0x1d0>
  802a37:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3c:	a3 40 51 80 00       	mov    %eax,0x805140
  802a41:	a1 40 51 80 00       	mov    0x805140,%eax
  802a46:	85 c0                	test   %eax,%eax
  802a48:	0f 85 3e fe ff ff    	jne    80288c <alloc_block_NF+0x20>
  802a4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a52:	0f 85 34 fe ff ff    	jne    80288c <alloc_block_NF+0x20>
  802a58:	e9 d5 03 00 00       	jmp    802e32 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802a5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a65:	e9 b1 01 00 00       	jmp    802c1b <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	8b 50 08             	mov    0x8(%eax),%edx
  802a70:	a1 28 50 80 00       	mov    0x805028,%eax
  802a75:	39 c2                	cmp    %eax,%edx
  802a77:	0f 82 96 01 00 00    	jb     802c13 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 0c             	mov    0xc(%eax),%eax
  802a83:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a86:	0f 82 87 01 00 00    	jb     802c13 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a92:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a95:	0f 85 95 00 00 00    	jne    802b30 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9f:	75 17                	jne    802ab8 <alloc_block_NF+0x24c>
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	68 e0 40 80 00       	push   $0x8040e0
  802aa9:	68 fc 00 00 00       	push   $0xfc
  802aae:	68 37 40 80 00       	push   $0x804037
  802ab3:	e8 b2 d8 ff ff       	call   80036a <_panic>
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	8b 00                	mov    (%eax),%eax
  802abd:	85 c0                	test   %eax,%eax
  802abf:	74 10                	je     802ad1 <alloc_block_NF+0x265>
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac9:	8b 52 04             	mov    0x4(%edx),%edx
  802acc:	89 50 04             	mov    %edx,0x4(%eax)
  802acf:	eb 0b                	jmp    802adc <alloc_block_NF+0x270>
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 40 04             	mov    0x4(%eax),%eax
  802ad7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 40 04             	mov    0x4(%eax),%eax
  802ae2:	85 c0                	test   %eax,%eax
  802ae4:	74 0f                	je     802af5 <alloc_block_NF+0x289>
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 40 04             	mov    0x4(%eax),%eax
  802aec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aef:	8b 12                	mov    (%edx),%edx
  802af1:	89 10                	mov    %edx,(%eax)
  802af3:	eb 0a                	jmp    802aff <alloc_block_NF+0x293>
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 00                	mov    (%eax),%eax
  802afa:	a3 38 51 80 00       	mov    %eax,0x805138
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b12:	a1 44 51 80 00       	mov    0x805144,%eax
  802b17:	48                   	dec    %eax
  802b18:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b20:	8b 40 08             	mov    0x8(%eax),%eax
  802b23:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	e9 07 03 00 00       	jmp    802e37 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 0c             	mov    0xc(%eax),%eax
  802b36:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b39:	0f 86 d4 00 00 00    	jbe    802c13 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802b3f:	a1 48 51 80 00       	mov    0x805148,%eax
  802b44:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 50 08             	mov    0x8(%eax),%edx
  802b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b50:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802b53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b56:	8b 55 08             	mov    0x8(%ebp),%edx
  802b59:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802b5c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b60:	75 17                	jne    802b79 <alloc_block_NF+0x30d>
  802b62:	83 ec 04             	sub    $0x4,%esp
  802b65:	68 e0 40 80 00       	push   $0x8040e0
  802b6a:	68 04 01 00 00       	push   $0x104
  802b6f:	68 37 40 80 00       	push   $0x804037
  802b74:	e8 f1 d7 ff ff       	call   80036a <_panic>
  802b79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 10                	je     802b92 <alloc_block_NF+0x326>
  802b82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b8a:	8b 52 04             	mov    0x4(%edx),%edx
  802b8d:	89 50 04             	mov    %edx,0x4(%eax)
  802b90:	eb 0b                	jmp    802b9d <alloc_block_NF+0x331>
  802b92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b95:	8b 40 04             	mov    0x4(%eax),%eax
  802b98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba0:	8b 40 04             	mov    0x4(%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	74 0f                	je     802bb6 <alloc_block_NF+0x34a>
  802ba7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802bb0:	8b 12                	mov    (%edx),%edx
  802bb2:	89 10                	mov    %edx,(%eax)
  802bb4:	eb 0a                	jmp    802bc0 <alloc_block_NF+0x354>
  802bb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb9:	8b 00                	mov    (%eax),%eax
  802bbb:	a3 48 51 80 00       	mov    %eax,0x805148
  802bc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd3:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd8:	48                   	dec    %eax
  802bd9:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802bde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be1:	8b 40 08             	mov    0x8(%eax),%eax
  802be4:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 50 08             	mov    0x8(%eax),%edx
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	01 c2                	add    %eax,%edx
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802c00:	2b 45 08             	sub    0x8(%ebp),%eax
  802c03:	89 c2                	mov    %eax,%edx
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c0e:	e9 24 02 00 00       	jmp    802e37 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c13:	a1 40 51 80 00       	mov    0x805140,%eax
  802c18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1f:	74 07                	je     802c28 <alloc_block_NF+0x3bc>
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	eb 05                	jmp    802c2d <alloc_block_NF+0x3c1>
  802c28:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c32:	a1 40 51 80 00       	mov    0x805140,%eax
  802c37:	85 c0                	test   %eax,%eax
  802c39:	0f 85 2b fe ff ff    	jne    802a6a <alloc_block_NF+0x1fe>
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c43:	0f 85 21 fe ff ff    	jne    802a6a <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c49:	a1 38 51 80 00       	mov    0x805138,%eax
  802c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c51:	e9 ae 01 00 00       	jmp    802e04 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 50 08             	mov    0x8(%eax),%edx
  802c5c:	a1 28 50 80 00       	mov    0x805028,%eax
  802c61:	39 c2                	cmp    %eax,%edx
  802c63:	0f 83 93 01 00 00    	jae    802dfc <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c72:	0f 82 84 01 00 00    	jb     802dfc <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c81:	0f 85 95 00 00 00    	jne    802d1c <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	75 17                	jne    802ca4 <alloc_block_NF+0x438>
  802c8d:	83 ec 04             	sub    $0x4,%esp
  802c90:	68 e0 40 80 00       	push   $0x8040e0
  802c95:	68 14 01 00 00       	push   $0x114
  802c9a:	68 37 40 80 00       	push   $0x804037
  802c9f:	e8 c6 d6 ff ff       	call   80036a <_panic>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 10                	je     802cbd <alloc_block_NF+0x451>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb5:	8b 52 04             	mov    0x4(%edx),%edx
  802cb8:	89 50 04             	mov    %edx,0x4(%eax)
  802cbb:	eb 0b                	jmp    802cc8 <alloc_block_NF+0x45c>
  802cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc0:	8b 40 04             	mov    0x4(%eax),%eax
  802cc3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 0f                	je     802ce1 <alloc_block_NF+0x475>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cdb:	8b 12                	mov    (%edx),%edx
  802cdd:	89 10                	mov    %edx,(%eax)
  802cdf:	eb 0a                	jmp    802ceb <alloc_block_NF+0x47f>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	a3 38 51 80 00       	mov    %eax,0x805138
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cfe:	a1 44 51 80 00       	mov    0x805144,%eax
  802d03:	48                   	dec    %eax
  802d04:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	8b 40 08             	mov    0x8(%eax),%eax
  802d0f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d17:	e9 1b 01 00 00       	jmp    802e37 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d22:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d25:	0f 86 d1 00 00 00    	jbe    802dfc <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802d2b:	a1 48 51 80 00       	mov    0x805148,%eax
  802d30:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 50 08             	mov    0x8(%eax),%edx
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d42:	8b 55 08             	mov    0x8(%ebp),%edx
  802d45:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802d48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d4c:	75 17                	jne    802d65 <alloc_block_NF+0x4f9>
  802d4e:	83 ec 04             	sub    $0x4,%esp
  802d51:	68 e0 40 80 00       	push   $0x8040e0
  802d56:	68 1c 01 00 00       	push   $0x11c
  802d5b:	68 37 40 80 00       	push   $0x804037
  802d60:	e8 05 d6 ff ff       	call   80036a <_panic>
  802d65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	74 10                	je     802d7e <alloc_block_NF+0x512>
  802d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d76:	8b 52 04             	mov    0x4(%edx),%edx
  802d79:	89 50 04             	mov    %edx,0x4(%eax)
  802d7c:	eb 0b                	jmp    802d89 <alloc_block_NF+0x51d>
  802d7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d81:	8b 40 04             	mov    0x4(%eax),%eax
  802d84:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8c:	8b 40 04             	mov    0x4(%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 0f                	je     802da2 <alloc_block_NF+0x536>
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d9c:	8b 12                	mov    (%edx),%edx
  802d9e:	89 10                	mov    %edx,(%eax)
  802da0:	eb 0a                	jmp    802dac <alloc_block_NF+0x540>
  802da2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	a3 48 51 80 00       	mov    %eax,0x805148
  802dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbf:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc4:	48                   	dec    %eax
  802dc5:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802dca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcd:	8b 40 08             	mov    0x8(%eax),%eax
  802dd0:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 50 08             	mov    0x8(%eax),%edx
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	01 c2                	add    %eax,%edx
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dec:	2b 45 08             	sub    0x8(%ebp),%eax
  802def:	89 c2                	mov    %eax,%edx
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfa:	eb 3b                	jmp    802e37 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802dfc:	a1 40 51 80 00       	mov    0x805140,%eax
  802e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e08:	74 07                	je     802e11 <alloc_block_NF+0x5a5>
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 00                	mov    (%eax),%eax
  802e0f:	eb 05                	jmp    802e16 <alloc_block_NF+0x5aa>
  802e11:	b8 00 00 00 00       	mov    $0x0,%eax
  802e16:	a3 40 51 80 00       	mov    %eax,0x805140
  802e1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802e20:	85 c0                	test   %eax,%eax
  802e22:	0f 85 2e fe ff ff    	jne    802c56 <alloc_block_NF+0x3ea>
  802e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2c:	0f 85 24 fe ff ff    	jne    802c56 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802e32:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e37:	c9                   	leave  
  802e38:	c3                   	ret    

00802e39 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802e39:	55                   	push   %ebp
  802e3a:	89 e5                	mov    %esp,%ebp
  802e3c:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802e3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802e47:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802e4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e54:	85 c0                	test   %eax,%eax
  802e56:	74 14                	je     802e6c <insert_sorted_with_merge_freeList+0x33>
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	8b 50 08             	mov    0x8(%eax),%edx
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	8b 40 08             	mov    0x8(%eax),%eax
  802e64:	39 c2                	cmp    %eax,%edx
  802e66:	0f 87 9b 01 00 00    	ja     803007 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802e6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e70:	75 17                	jne    802e89 <insert_sorted_with_merge_freeList+0x50>
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	68 14 40 80 00       	push   $0x804014
  802e7a:	68 38 01 00 00       	push   $0x138
  802e7f:	68 37 40 80 00       	push   $0x804037
  802e84:	e8 e1 d4 ff ff       	call   80036a <_panic>
  802e89:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	85 c0                	test   %eax,%eax
  802e9b:	74 0d                	je     802eaa <insert_sorted_with_merge_freeList+0x71>
  802e9d:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea5:	89 50 04             	mov    %edx,0x4(%eax)
  802ea8:	eb 08                	jmp    802eb2 <insert_sorted_with_merge_freeList+0x79>
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	a3 38 51 80 00       	mov    %eax,0x805138
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec9:	40                   	inc    %eax
  802eca:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802ecf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed3:	0f 84 a8 06 00 00    	je     803581 <insert_sorted_with_merge_freeList+0x748>
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	8b 50 08             	mov    0x8(%eax),%edx
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee5:	01 c2                	add    %eax,%edx
  802ee7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eea:	8b 40 08             	mov    0x8(%eax),%eax
  802eed:	39 c2                	cmp    %eax,%edx
  802eef:	0f 85 8c 06 00 00    	jne    803581 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 50 0c             	mov    0xc(%eax),%edx
  802efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efe:	8b 40 0c             	mov    0xc(%eax),%eax
  802f01:	01 c2                	add    %eax,%edx
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802f09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f0d:	75 17                	jne    802f26 <insert_sorted_with_merge_freeList+0xed>
  802f0f:	83 ec 04             	sub    $0x4,%esp
  802f12:	68 e0 40 80 00       	push   $0x8040e0
  802f17:	68 3c 01 00 00       	push   $0x13c
  802f1c:	68 37 40 80 00       	push   $0x804037
  802f21:	e8 44 d4 ff ff       	call   80036a <_panic>
  802f26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f29:	8b 00                	mov    (%eax),%eax
  802f2b:	85 c0                	test   %eax,%eax
  802f2d:	74 10                	je     802f3f <insert_sorted_with_merge_freeList+0x106>
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	8b 00                	mov    (%eax),%eax
  802f34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f37:	8b 52 04             	mov    0x4(%edx),%edx
  802f3a:	89 50 04             	mov    %edx,0x4(%eax)
  802f3d:	eb 0b                	jmp    802f4a <insert_sorted_with_merge_freeList+0x111>
  802f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f42:	8b 40 04             	mov    0x4(%eax),%eax
  802f45:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4d:	8b 40 04             	mov    0x4(%eax),%eax
  802f50:	85 c0                	test   %eax,%eax
  802f52:	74 0f                	je     802f63 <insert_sorted_with_merge_freeList+0x12a>
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	8b 40 04             	mov    0x4(%eax),%eax
  802f5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f5d:	8b 12                	mov    (%edx),%edx
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	eb 0a                	jmp    802f6d <insert_sorted_with_merge_freeList+0x134>
  802f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f66:	8b 00                	mov    (%eax),%eax
  802f68:	a3 38 51 80 00       	mov    %eax,0x805138
  802f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f80:	a1 44 51 80 00       	mov    0x805144,%eax
  802f85:	48                   	dec    %eax
  802f86:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802f9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa3:	75 17                	jne    802fbc <insert_sorted_with_merge_freeList+0x183>
  802fa5:	83 ec 04             	sub    $0x4,%esp
  802fa8:	68 14 40 80 00       	push   $0x804014
  802fad:	68 3f 01 00 00       	push   $0x13f
  802fb2:	68 37 40 80 00       	push   $0x804037
  802fb7:	e8 ae d3 ff ff       	call   80036a <_panic>
  802fbc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc5:	89 10                	mov    %edx,(%eax)
  802fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fca:	8b 00                	mov    (%eax),%eax
  802fcc:	85 c0                	test   %eax,%eax
  802fce:	74 0d                	je     802fdd <insert_sorted_with_merge_freeList+0x1a4>
  802fd0:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fd8:	89 50 04             	mov    %edx,0x4(%eax)
  802fdb:	eb 08                	jmp    802fe5 <insert_sorted_with_merge_freeList+0x1ac>
  802fdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe8:	a3 48 51 80 00       	mov    %eax,0x805148
  802fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff7:	a1 54 51 80 00       	mov    0x805154,%eax
  802ffc:	40                   	inc    %eax
  802ffd:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803002:	e9 7a 05 00 00       	jmp    803581 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	8b 50 08             	mov    0x8(%eax),%edx
  80300d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803010:	8b 40 08             	mov    0x8(%eax),%eax
  803013:	39 c2                	cmp    %eax,%edx
  803015:	0f 82 14 01 00 00    	jb     80312f <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  80301b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301e:	8b 50 08             	mov    0x8(%eax),%edx
  803021:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803024:	8b 40 0c             	mov    0xc(%eax),%eax
  803027:	01 c2                	add    %eax,%edx
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	8b 40 08             	mov    0x8(%eax),%eax
  80302f:	39 c2                	cmp    %eax,%edx
  803031:	0f 85 90 00 00 00    	jne    8030c7 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  803037:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303a:	8b 50 0c             	mov    0xc(%eax),%edx
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	8b 40 0c             	mov    0xc(%eax),%eax
  803043:	01 c2                	add    %eax,%edx
  803045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803048:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  80305f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803063:	75 17                	jne    80307c <insert_sorted_with_merge_freeList+0x243>
  803065:	83 ec 04             	sub    $0x4,%esp
  803068:	68 14 40 80 00       	push   $0x804014
  80306d:	68 49 01 00 00       	push   $0x149
  803072:	68 37 40 80 00       	push   $0x804037
  803077:	e8 ee d2 ff ff       	call   80036a <_panic>
  80307c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	89 10                	mov    %edx,(%eax)
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 00                	mov    (%eax),%eax
  80308c:	85 c0                	test   %eax,%eax
  80308e:	74 0d                	je     80309d <insert_sorted_with_merge_freeList+0x264>
  803090:	a1 48 51 80 00       	mov    0x805148,%eax
  803095:	8b 55 08             	mov    0x8(%ebp),%edx
  803098:	89 50 04             	mov    %edx,0x4(%eax)
  80309b:	eb 08                	jmp    8030a5 <insert_sorted_with_merge_freeList+0x26c>
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8030bc:	40                   	inc    %eax
  8030bd:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8030c2:	e9 bb 04 00 00       	jmp    803582 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030cb:	75 17                	jne    8030e4 <insert_sorted_with_merge_freeList+0x2ab>
  8030cd:	83 ec 04             	sub    $0x4,%esp
  8030d0:	68 88 40 80 00       	push   $0x804088
  8030d5:	68 4c 01 00 00       	push   $0x14c
  8030da:	68 37 40 80 00       	push   $0x804037
  8030df:	e8 86 d2 ff ff       	call   80036a <_panic>
  8030e4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	89 50 04             	mov    %edx,0x4(%eax)
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	8b 40 04             	mov    0x4(%eax),%eax
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	74 0c                	je     803106 <insert_sorted_with_merge_freeList+0x2cd>
  8030fa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803102:	89 10                	mov    %edx,(%eax)
  803104:	eb 08                	jmp    80310e <insert_sorted_with_merge_freeList+0x2d5>
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	a3 38 51 80 00       	mov    %eax,0x805138
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80311f:	a1 44 51 80 00       	mov    0x805144,%eax
  803124:	40                   	inc    %eax
  803125:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80312a:	e9 53 04 00 00       	jmp    803582 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  80312f:	a1 38 51 80 00       	mov    0x805138,%eax
  803134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803137:	e9 15 04 00 00       	jmp    803551 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	8b 50 08             	mov    0x8(%eax),%edx
  80314a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314d:	8b 40 08             	mov    0x8(%eax),%eax
  803150:	39 c2                	cmp    %eax,%edx
  803152:	0f 86 f1 03 00 00    	jbe    803549 <insert_sorted_with_merge_freeList+0x710>
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	8b 50 08             	mov    0x8(%eax),%edx
  80315e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803161:	8b 40 08             	mov    0x8(%eax),%eax
  803164:	39 c2                	cmp    %eax,%edx
  803166:	0f 83 dd 03 00 00    	jae    803549 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	8b 50 08             	mov    0x8(%eax),%edx
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	8b 40 0c             	mov    0xc(%eax),%eax
  803178:	01 c2                	add    %eax,%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 40 08             	mov    0x8(%eax),%eax
  803180:	39 c2                	cmp    %eax,%edx
  803182:	0f 85 b9 01 00 00    	jne    803341 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	8b 50 08             	mov    0x8(%eax),%edx
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	8b 40 0c             	mov    0xc(%eax),%eax
  803194:	01 c2                	add    %eax,%edx
  803196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803199:	8b 40 08             	mov    0x8(%eax),%eax
  80319c:	39 c2                	cmp    %eax,%edx
  80319e:	0f 85 0d 01 00 00    	jne    8032b1 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8031a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8031aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b0:	01 c2                	add    %eax,%edx
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8031b8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031bc:	75 17                	jne    8031d5 <insert_sorted_with_merge_freeList+0x39c>
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	68 e0 40 80 00       	push   $0x8040e0
  8031c6:	68 5c 01 00 00       	push   $0x15c
  8031cb:	68 37 40 80 00       	push   $0x804037
  8031d0:	e8 95 d1 ff ff       	call   80036a <_panic>
  8031d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d8:	8b 00                	mov    (%eax),%eax
  8031da:	85 c0                	test   %eax,%eax
  8031dc:	74 10                	je     8031ee <insert_sorted_with_merge_freeList+0x3b5>
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031e6:	8b 52 04             	mov    0x4(%edx),%edx
  8031e9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ec:	eb 0b                	jmp    8031f9 <insert_sorted_with_merge_freeList+0x3c0>
  8031ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f1:	8b 40 04             	mov    0x4(%eax),%eax
  8031f4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031fc:	8b 40 04             	mov    0x4(%eax),%eax
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0f                	je     803212 <insert_sorted_with_merge_freeList+0x3d9>
  803203:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803206:	8b 40 04             	mov    0x4(%eax),%eax
  803209:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320c:	8b 12                	mov    (%edx),%edx
  80320e:	89 10                	mov    %edx,(%eax)
  803210:	eb 0a                	jmp    80321c <insert_sorted_with_merge_freeList+0x3e3>
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	8b 00                	mov    (%eax),%eax
  803217:	a3 38 51 80 00       	mov    %eax,0x805138
  80321c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80321f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803225:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803228:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322f:	a1 44 51 80 00       	mov    0x805144,%eax
  803234:	48                   	dec    %eax
  803235:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  80323a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  803244:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803247:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  80324e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803252:	75 17                	jne    80326b <insert_sorted_with_merge_freeList+0x432>
  803254:	83 ec 04             	sub    $0x4,%esp
  803257:	68 14 40 80 00       	push   $0x804014
  80325c:	68 5f 01 00 00       	push   $0x15f
  803261:	68 37 40 80 00       	push   $0x804037
  803266:	e8 ff d0 ff ff       	call   80036a <_panic>
  80326b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803271:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803274:	89 10                	mov    %edx,(%eax)
  803276:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803279:	8b 00                	mov    (%eax),%eax
  80327b:	85 c0                	test   %eax,%eax
  80327d:	74 0d                	je     80328c <insert_sorted_with_merge_freeList+0x453>
  80327f:	a1 48 51 80 00       	mov    0x805148,%eax
  803284:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803287:	89 50 04             	mov    %edx,0x4(%eax)
  80328a:	eb 08                	jmp    803294 <insert_sorted_with_merge_freeList+0x45b>
  80328c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803297:	a3 48 51 80 00       	mov    %eax,0x805148
  80329c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ab:	40                   	inc    %eax
  8032ac:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8032b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bd:	01 c2                	add    %eax,%edx
  8032bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c2:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  8032d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032dd:	75 17                	jne    8032f6 <insert_sorted_with_merge_freeList+0x4bd>
  8032df:	83 ec 04             	sub    $0x4,%esp
  8032e2:	68 14 40 80 00       	push   $0x804014
  8032e7:	68 64 01 00 00       	push   $0x164
  8032ec:	68 37 40 80 00       	push   $0x804037
  8032f1:	e8 74 d0 ff ff       	call   80036a <_panic>
  8032f6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	89 10                	mov    %edx,(%eax)
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	8b 00                	mov    (%eax),%eax
  803306:	85 c0                	test   %eax,%eax
  803308:	74 0d                	je     803317 <insert_sorted_with_merge_freeList+0x4de>
  80330a:	a1 48 51 80 00       	mov    0x805148,%eax
  80330f:	8b 55 08             	mov    0x8(%ebp),%edx
  803312:	89 50 04             	mov    %edx,0x4(%eax)
  803315:	eb 08                	jmp    80331f <insert_sorted_with_merge_freeList+0x4e6>
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	a3 48 51 80 00       	mov    %eax,0x805148
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803331:	a1 54 51 80 00       	mov    0x805154,%eax
  803336:	40                   	inc    %eax
  803337:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80333c:	e9 41 02 00 00       	jmp    803582 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803341:	8b 45 08             	mov    0x8(%ebp),%eax
  803344:	8b 50 08             	mov    0x8(%eax),%edx
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	8b 40 0c             	mov    0xc(%eax),%eax
  80334d:	01 c2                	add    %eax,%edx
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	8b 40 08             	mov    0x8(%eax),%eax
  803355:	39 c2                	cmp    %eax,%edx
  803357:	0f 85 7c 01 00 00    	jne    8034d9 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  80335d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803361:	74 06                	je     803369 <insert_sorted_with_merge_freeList+0x530>
  803363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803367:	75 17                	jne    803380 <insert_sorted_with_merge_freeList+0x547>
  803369:	83 ec 04             	sub    $0x4,%esp
  80336c:	68 50 40 80 00       	push   $0x804050
  803371:	68 69 01 00 00       	push   $0x169
  803376:	68 37 40 80 00       	push   $0x804037
  80337b:	e8 ea cf ff ff       	call   80036a <_panic>
  803380:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803383:	8b 50 04             	mov    0x4(%eax),%edx
  803386:	8b 45 08             	mov    0x8(%ebp),%eax
  803389:	89 50 04             	mov    %edx,0x4(%eax)
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803392:	89 10                	mov    %edx,(%eax)
  803394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803397:	8b 40 04             	mov    0x4(%eax),%eax
  80339a:	85 c0                	test   %eax,%eax
  80339c:	74 0d                	je     8033ab <insert_sorted_with_merge_freeList+0x572>
  80339e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a1:	8b 40 04             	mov    0x4(%eax),%eax
  8033a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a7:	89 10                	mov    %edx,(%eax)
  8033a9:	eb 08                	jmp    8033b3 <insert_sorted_with_merge_freeList+0x57a>
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	a3 38 51 80 00       	mov    %eax,0x805138
  8033b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b9:	89 50 04             	mov    %edx,0x4(%eax)
  8033bc:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c1:	40                   	inc    %eax
  8033c2:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	8b 50 0c             	mov    0xc(%eax),%edx
  8033cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d3:	01 c2                	add    %eax,%edx
  8033d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d8:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  8033db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033df:	75 17                	jne    8033f8 <insert_sorted_with_merge_freeList+0x5bf>
  8033e1:	83 ec 04             	sub    $0x4,%esp
  8033e4:	68 e0 40 80 00       	push   $0x8040e0
  8033e9:	68 6b 01 00 00       	push   $0x16b
  8033ee:	68 37 40 80 00       	push   $0x804037
  8033f3:	e8 72 cf ff ff       	call   80036a <_panic>
  8033f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fb:	8b 00                	mov    (%eax),%eax
  8033fd:	85 c0                	test   %eax,%eax
  8033ff:	74 10                	je     803411 <insert_sorted_with_merge_freeList+0x5d8>
  803401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803404:	8b 00                	mov    (%eax),%eax
  803406:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803409:	8b 52 04             	mov    0x4(%edx),%edx
  80340c:	89 50 04             	mov    %edx,0x4(%eax)
  80340f:	eb 0b                	jmp    80341c <insert_sorted_with_merge_freeList+0x5e3>
  803411:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803414:	8b 40 04             	mov    0x4(%eax),%eax
  803417:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80341c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341f:	8b 40 04             	mov    0x4(%eax),%eax
  803422:	85 c0                	test   %eax,%eax
  803424:	74 0f                	je     803435 <insert_sorted_with_merge_freeList+0x5fc>
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	8b 40 04             	mov    0x4(%eax),%eax
  80342c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80342f:	8b 12                	mov    (%edx),%edx
  803431:	89 10                	mov    %edx,(%eax)
  803433:	eb 0a                	jmp    80343f <insert_sorted_with_merge_freeList+0x606>
  803435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803438:	8b 00                	mov    (%eax),%eax
  80343a:	a3 38 51 80 00       	mov    %eax,0x805138
  80343f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803442:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803448:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803452:	a1 44 51 80 00       	mov    0x805144,%eax
  803457:	48                   	dec    %eax
  803458:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  80345d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803460:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  803467:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803471:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803475:	75 17                	jne    80348e <insert_sorted_with_merge_freeList+0x655>
  803477:	83 ec 04             	sub    $0x4,%esp
  80347a:	68 14 40 80 00       	push   $0x804014
  80347f:	68 6e 01 00 00       	push   $0x16e
  803484:	68 37 40 80 00       	push   $0x804037
  803489:	e8 dc ce ff ff       	call   80036a <_panic>
  80348e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803494:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803497:	89 10                	mov    %edx,(%eax)
  803499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	74 0d                	je     8034af <insert_sorted_with_merge_freeList+0x676>
  8034a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034aa:	89 50 04             	mov    %edx,0x4(%eax)
  8034ad:	eb 08                	jmp    8034b7 <insert_sorted_with_merge_freeList+0x67e>
  8034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ba:	a3 48 51 80 00       	mov    %eax,0x805148
  8034bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ce:	40                   	inc    %eax
  8034cf:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8034d4:	e9 a9 00 00 00       	jmp    803582 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  8034d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034dd:	74 06                	je     8034e5 <insert_sorted_with_merge_freeList+0x6ac>
  8034df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034e3:	75 17                	jne    8034fc <insert_sorted_with_merge_freeList+0x6c3>
  8034e5:	83 ec 04             	sub    $0x4,%esp
  8034e8:	68 ac 40 80 00       	push   $0x8040ac
  8034ed:	68 73 01 00 00       	push   $0x173
  8034f2:	68 37 40 80 00       	push   $0x804037
  8034f7:	e8 6e ce ff ff       	call   80036a <_panic>
  8034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ff:	8b 10                	mov    (%eax),%edx
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	89 10                	mov    %edx,(%eax)
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	8b 00                	mov    (%eax),%eax
  80350b:	85 c0                	test   %eax,%eax
  80350d:	74 0b                	je     80351a <insert_sorted_with_merge_freeList+0x6e1>
  80350f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803512:	8b 00                	mov    (%eax),%eax
  803514:	8b 55 08             	mov    0x8(%ebp),%edx
  803517:	89 50 04             	mov    %edx,0x4(%eax)
  80351a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351d:	8b 55 08             	mov    0x8(%ebp),%edx
  803520:	89 10                	mov    %edx,(%eax)
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803528:	89 50 04             	mov    %edx,0x4(%eax)
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	8b 00                	mov    (%eax),%eax
  803530:	85 c0                	test   %eax,%eax
  803532:	75 08                	jne    80353c <insert_sorted_with_merge_freeList+0x703>
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80353c:	a1 44 51 80 00       	mov    0x805144,%eax
  803541:	40                   	inc    %eax
  803542:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803547:	eb 39                	jmp    803582 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803549:	a1 40 51 80 00       	mov    0x805140,%eax
  80354e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803555:	74 07                	je     80355e <insert_sorted_with_merge_freeList+0x725>
  803557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355a:	8b 00                	mov    (%eax),%eax
  80355c:	eb 05                	jmp    803563 <insert_sorted_with_merge_freeList+0x72a>
  80355e:	b8 00 00 00 00       	mov    $0x0,%eax
  803563:	a3 40 51 80 00       	mov    %eax,0x805140
  803568:	a1 40 51 80 00       	mov    0x805140,%eax
  80356d:	85 c0                	test   %eax,%eax
  80356f:	0f 85 c7 fb ff ff    	jne    80313c <insert_sorted_with_merge_freeList+0x303>
  803575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803579:	0f 85 bd fb ff ff    	jne    80313c <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80357f:	eb 01                	jmp    803582 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803581:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803582:	90                   	nop
  803583:	c9                   	leave  
  803584:	c3                   	ret    
  803585:	66 90                	xchg   %ax,%ax
  803587:	90                   	nop

00803588 <__udivdi3>:
  803588:	55                   	push   %ebp
  803589:	57                   	push   %edi
  80358a:	56                   	push   %esi
  80358b:	53                   	push   %ebx
  80358c:	83 ec 1c             	sub    $0x1c,%esp
  80358f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803593:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803597:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80359b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80359f:	89 ca                	mov    %ecx,%edx
  8035a1:	89 f8                	mov    %edi,%eax
  8035a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035a7:	85 f6                	test   %esi,%esi
  8035a9:	75 2d                	jne    8035d8 <__udivdi3+0x50>
  8035ab:	39 cf                	cmp    %ecx,%edi
  8035ad:	77 65                	ja     803614 <__udivdi3+0x8c>
  8035af:	89 fd                	mov    %edi,%ebp
  8035b1:	85 ff                	test   %edi,%edi
  8035b3:	75 0b                	jne    8035c0 <__udivdi3+0x38>
  8035b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ba:	31 d2                	xor    %edx,%edx
  8035bc:	f7 f7                	div    %edi
  8035be:	89 c5                	mov    %eax,%ebp
  8035c0:	31 d2                	xor    %edx,%edx
  8035c2:	89 c8                	mov    %ecx,%eax
  8035c4:	f7 f5                	div    %ebp
  8035c6:	89 c1                	mov    %eax,%ecx
  8035c8:	89 d8                	mov    %ebx,%eax
  8035ca:	f7 f5                	div    %ebp
  8035cc:	89 cf                	mov    %ecx,%edi
  8035ce:	89 fa                	mov    %edi,%edx
  8035d0:	83 c4 1c             	add    $0x1c,%esp
  8035d3:	5b                   	pop    %ebx
  8035d4:	5e                   	pop    %esi
  8035d5:	5f                   	pop    %edi
  8035d6:	5d                   	pop    %ebp
  8035d7:	c3                   	ret    
  8035d8:	39 ce                	cmp    %ecx,%esi
  8035da:	77 28                	ja     803604 <__udivdi3+0x7c>
  8035dc:	0f bd fe             	bsr    %esi,%edi
  8035df:	83 f7 1f             	xor    $0x1f,%edi
  8035e2:	75 40                	jne    803624 <__udivdi3+0x9c>
  8035e4:	39 ce                	cmp    %ecx,%esi
  8035e6:	72 0a                	jb     8035f2 <__udivdi3+0x6a>
  8035e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035ec:	0f 87 9e 00 00 00    	ja     803690 <__udivdi3+0x108>
  8035f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035f7:	89 fa                	mov    %edi,%edx
  8035f9:	83 c4 1c             	add    $0x1c,%esp
  8035fc:	5b                   	pop    %ebx
  8035fd:	5e                   	pop    %esi
  8035fe:	5f                   	pop    %edi
  8035ff:	5d                   	pop    %ebp
  803600:	c3                   	ret    
  803601:	8d 76 00             	lea    0x0(%esi),%esi
  803604:	31 ff                	xor    %edi,%edi
  803606:	31 c0                	xor    %eax,%eax
  803608:	89 fa                	mov    %edi,%edx
  80360a:	83 c4 1c             	add    $0x1c,%esp
  80360d:	5b                   	pop    %ebx
  80360e:	5e                   	pop    %esi
  80360f:	5f                   	pop    %edi
  803610:	5d                   	pop    %ebp
  803611:	c3                   	ret    
  803612:	66 90                	xchg   %ax,%ax
  803614:	89 d8                	mov    %ebx,%eax
  803616:	f7 f7                	div    %edi
  803618:	31 ff                	xor    %edi,%edi
  80361a:	89 fa                	mov    %edi,%edx
  80361c:	83 c4 1c             	add    $0x1c,%esp
  80361f:	5b                   	pop    %ebx
  803620:	5e                   	pop    %esi
  803621:	5f                   	pop    %edi
  803622:	5d                   	pop    %ebp
  803623:	c3                   	ret    
  803624:	bd 20 00 00 00       	mov    $0x20,%ebp
  803629:	89 eb                	mov    %ebp,%ebx
  80362b:	29 fb                	sub    %edi,%ebx
  80362d:	89 f9                	mov    %edi,%ecx
  80362f:	d3 e6                	shl    %cl,%esi
  803631:	89 c5                	mov    %eax,%ebp
  803633:	88 d9                	mov    %bl,%cl
  803635:	d3 ed                	shr    %cl,%ebp
  803637:	89 e9                	mov    %ebp,%ecx
  803639:	09 f1                	or     %esi,%ecx
  80363b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80363f:	89 f9                	mov    %edi,%ecx
  803641:	d3 e0                	shl    %cl,%eax
  803643:	89 c5                	mov    %eax,%ebp
  803645:	89 d6                	mov    %edx,%esi
  803647:	88 d9                	mov    %bl,%cl
  803649:	d3 ee                	shr    %cl,%esi
  80364b:	89 f9                	mov    %edi,%ecx
  80364d:	d3 e2                	shl    %cl,%edx
  80364f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803653:	88 d9                	mov    %bl,%cl
  803655:	d3 e8                	shr    %cl,%eax
  803657:	09 c2                	or     %eax,%edx
  803659:	89 d0                	mov    %edx,%eax
  80365b:	89 f2                	mov    %esi,%edx
  80365d:	f7 74 24 0c          	divl   0xc(%esp)
  803661:	89 d6                	mov    %edx,%esi
  803663:	89 c3                	mov    %eax,%ebx
  803665:	f7 e5                	mul    %ebp
  803667:	39 d6                	cmp    %edx,%esi
  803669:	72 19                	jb     803684 <__udivdi3+0xfc>
  80366b:	74 0b                	je     803678 <__udivdi3+0xf0>
  80366d:	89 d8                	mov    %ebx,%eax
  80366f:	31 ff                	xor    %edi,%edi
  803671:	e9 58 ff ff ff       	jmp    8035ce <__udivdi3+0x46>
  803676:	66 90                	xchg   %ax,%ax
  803678:	8b 54 24 08          	mov    0x8(%esp),%edx
  80367c:	89 f9                	mov    %edi,%ecx
  80367e:	d3 e2                	shl    %cl,%edx
  803680:	39 c2                	cmp    %eax,%edx
  803682:	73 e9                	jae    80366d <__udivdi3+0xe5>
  803684:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803687:	31 ff                	xor    %edi,%edi
  803689:	e9 40 ff ff ff       	jmp    8035ce <__udivdi3+0x46>
  80368e:	66 90                	xchg   %ax,%ax
  803690:	31 c0                	xor    %eax,%eax
  803692:	e9 37 ff ff ff       	jmp    8035ce <__udivdi3+0x46>
  803697:	90                   	nop

00803698 <__umoddi3>:
  803698:	55                   	push   %ebp
  803699:	57                   	push   %edi
  80369a:	56                   	push   %esi
  80369b:	53                   	push   %ebx
  80369c:	83 ec 1c             	sub    $0x1c,%esp
  80369f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036b7:	89 f3                	mov    %esi,%ebx
  8036b9:	89 fa                	mov    %edi,%edx
  8036bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036bf:	89 34 24             	mov    %esi,(%esp)
  8036c2:	85 c0                	test   %eax,%eax
  8036c4:	75 1a                	jne    8036e0 <__umoddi3+0x48>
  8036c6:	39 f7                	cmp    %esi,%edi
  8036c8:	0f 86 a2 00 00 00    	jbe    803770 <__umoddi3+0xd8>
  8036ce:	89 c8                	mov    %ecx,%eax
  8036d0:	89 f2                	mov    %esi,%edx
  8036d2:	f7 f7                	div    %edi
  8036d4:	89 d0                	mov    %edx,%eax
  8036d6:	31 d2                	xor    %edx,%edx
  8036d8:	83 c4 1c             	add    $0x1c,%esp
  8036db:	5b                   	pop    %ebx
  8036dc:	5e                   	pop    %esi
  8036dd:	5f                   	pop    %edi
  8036de:	5d                   	pop    %ebp
  8036df:	c3                   	ret    
  8036e0:	39 f0                	cmp    %esi,%eax
  8036e2:	0f 87 ac 00 00 00    	ja     803794 <__umoddi3+0xfc>
  8036e8:	0f bd e8             	bsr    %eax,%ebp
  8036eb:	83 f5 1f             	xor    $0x1f,%ebp
  8036ee:	0f 84 ac 00 00 00    	je     8037a0 <__umoddi3+0x108>
  8036f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036f9:	29 ef                	sub    %ebp,%edi
  8036fb:	89 fe                	mov    %edi,%esi
  8036fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803701:	89 e9                	mov    %ebp,%ecx
  803703:	d3 e0                	shl    %cl,%eax
  803705:	89 d7                	mov    %edx,%edi
  803707:	89 f1                	mov    %esi,%ecx
  803709:	d3 ef                	shr    %cl,%edi
  80370b:	09 c7                	or     %eax,%edi
  80370d:	89 e9                	mov    %ebp,%ecx
  80370f:	d3 e2                	shl    %cl,%edx
  803711:	89 14 24             	mov    %edx,(%esp)
  803714:	89 d8                	mov    %ebx,%eax
  803716:	d3 e0                	shl    %cl,%eax
  803718:	89 c2                	mov    %eax,%edx
  80371a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80371e:	d3 e0                	shl    %cl,%eax
  803720:	89 44 24 04          	mov    %eax,0x4(%esp)
  803724:	8b 44 24 08          	mov    0x8(%esp),%eax
  803728:	89 f1                	mov    %esi,%ecx
  80372a:	d3 e8                	shr    %cl,%eax
  80372c:	09 d0                	or     %edx,%eax
  80372e:	d3 eb                	shr    %cl,%ebx
  803730:	89 da                	mov    %ebx,%edx
  803732:	f7 f7                	div    %edi
  803734:	89 d3                	mov    %edx,%ebx
  803736:	f7 24 24             	mull   (%esp)
  803739:	89 c6                	mov    %eax,%esi
  80373b:	89 d1                	mov    %edx,%ecx
  80373d:	39 d3                	cmp    %edx,%ebx
  80373f:	0f 82 87 00 00 00    	jb     8037cc <__umoddi3+0x134>
  803745:	0f 84 91 00 00 00    	je     8037dc <__umoddi3+0x144>
  80374b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80374f:	29 f2                	sub    %esi,%edx
  803751:	19 cb                	sbb    %ecx,%ebx
  803753:	89 d8                	mov    %ebx,%eax
  803755:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803759:	d3 e0                	shl    %cl,%eax
  80375b:	89 e9                	mov    %ebp,%ecx
  80375d:	d3 ea                	shr    %cl,%edx
  80375f:	09 d0                	or     %edx,%eax
  803761:	89 e9                	mov    %ebp,%ecx
  803763:	d3 eb                	shr    %cl,%ebx
  803765:	89 da                	mov    %ebx,%edx
  803767:	83 c4 1c             	add    $0x1c,%esp
  80376a:	5b                   	pop    %ebx
  80376b:	5e                   	pop    %esi
  80376c:	5f                   	pop    %edi
  80376d:	5d                   	pop    %ebp
  80376e:	c3                   	ret    
  80376f:	90                   	nop
  803770:	89 fd                	mov    %edi,%ebp
  803772:	85 ff                	test   %edi,%edi
  803774:	75 0b                	jne    803781 <__umoddi3+0xe9>
  803776:	b8 01 00 00 00       	mov    $0x1,%eax
  80377b:	31 d2                	xor    %edx,%edx
  80377d:	f7 f7                	div    %edi
  80377f:	89 c5                	mov    %eax,%ebp
  803781:	89 f0                	mov    %esi,%eax
  803783:	31 d2                	xor    %edx,%edx
  803785:	f7 f5                	div    %ebp
  803787:	89 c8                	mov    %ecx,%eax
  803789:	f7 f5                	div    %ebp
  80378b:	89 d0                	mov    %edx,%eax
  80378d:	e9 44 ff ff ff       	jmp    8036d6 <__umoddi3+0x3e>
  803792:	66 90                	xchg   %ax,%ax
  803794:	89 c8                	mov    %ecx,%eax
  803796:	89 f2                	mov    %esi,%edx
  803798:	83 c4 1c             	add    $0x1c,%esp
  80379b:	5b                   	pop    %ebx
  80379c:	5e                   	pop    %esi
  80379d:	5f                   	pop    %edi
  80379e:	5d                   	pop    %ebp
  80379f:	c3                   	ret    
  8037a0:	3b 04 24             	cmp    (%esp),%eax
  8037a3:	72 06                	jb     8037ab <__umoddi3+0x113>
  8037a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037a9:	77 0f                	ja     8037ba <__umoddi3+0x122>
  8037ab:	89 f2                	mov    %esi,%edx
  8037ad:	29 f9                	sub    %edi,%ecx
  8037af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037b3:	89 14 24             	mov    %edx,(%esp)
  8037b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037be:	8b 14 24             	mov    (%esp),%edx
  8037c1:	83 c4 1c             	add    $0x1c,%esp
  8037c4:	5b                   	pop    %ebx
  8037c5:	5e                   	pop    %esi
  8037c6:	5f                   	pop    %edi
  8037c7:	5d                   	pop    %ebp
  8037c8:	c3                   	ret    
  8037c9:	8d 76 00             	lea    0x0(%esi),%esi
  8037cc:	2b 04 24             	sub    (%esp),%eax
  8037cf:	19 fa                	sbb    %edi,%edx
  8037d1:	89 d1                	mov    %edx,%ecx
  8037d3:	89 c6                	mov    %eax,%esi
  8037d5:	e9 71 ff ff ff       	jmp    80374b <__umoddi3+0xb3>
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037e0:	72 ea                	jb     8037cc <__umoddi3+0x134>
  8037e2:	89 d9                	mov    %ebx,%ecx
  8037e4:	e9 62 ff ff ff       	jmp    80374b <__umoddi3+0xb3>
