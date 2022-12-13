
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
  80003e:	e8 d7 1a 00 00       	call   801b1a <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 80 36 80 00       	push   $0x803680
  800050:	e8 5f 19 00 00       	call   8019b4 <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 84 36 80 00       	push   $0x803684
  800062:	e8 4d 19 00 00       	call   8019b4 <sys_createSemaphore>
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
  800083:	68 8c 36 80 00       	push   $0x80368c
  800088:	e8 38 1a 00 00       	call   801ac5 <sys_create_env>
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
  8000ac:	68 8c 36 80 00       	push   $0x80368c
  8000b1:	e8 0f 1a 00 00       	call   801ac5 <sys_create_env>
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
  8000d5:	68 8c 36 80 00       	push   $0x80368c
  8000da:	e8 e6 19 00 00       	call   801ac5 <sys_create_env>
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
  8000fa:	68 99 36 80 00       	push   $0x803699
  8000ff:	6a 13                	push   $0x13
  800101:	68 b0 36 80 00       	push   $0x8036b0
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 cd 19 00 00       	call   801ae3 <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 bf 19 00 00       	call   801ae3 <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 b1 19 00 00       	call   801ae3 <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 84 36 80 00       	push   $0x803684
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 a8 18 00 00       	call   8019ed <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 84 36 80 00       	push   $0x803684
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 95 18 00 00       	call   8019ed <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 84 36 80 00       	push   $0x803684
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 82 18 00 00       	call   8019ed <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 80 36 80 00       	push   $0x803680
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 52 18 00 00       	call   8019d0 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 84 36 80 00       	push   $0x803684
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 3c 18 00 00       	call   8019d0 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 d0 36 80 00       	push   $0x8036d0
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 18 37 80 00       	push   $0x803718
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 7f 19 00 00       	call   801b4c <sys_getparentenvid>
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
  8001e0:	68 63 37 80 00       	push   $0x803763
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 c2 14 00 00       	call   8016af <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 01 19 00 00       	call   801aff <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 f3 18 00 00       	call   801aff <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 e5 18 00 00       	call   801aff <sys_destroy_env>
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
  800234:	e8 fa 18 00 00       	call   801b33 <sys_getenvindex>
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
  80029f:	e8 9c 16 00 00       	call   801940 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 8c 37 80 00       	push   $0x80378c
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
  8002cf:	68 b4 37 80 00       	push   $0x8037b4
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
  800300:	68 dc 37 80 00       	push   $0x8037dc
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 50 80 00       	mov    0x805020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 34 38 80 00       	push   $0x803834
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 8c 37 80 00       	push   $0x80378c
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 1c 16 00 00       	call   80195a <sys_enable_interrupt>

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
  800351:	e8 a9 17 00 00       	call   801aff <sys_destroy_env>
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
  800362:	e8 fe 17 00 00       	call   801b65 <sys_exit_env>
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
  80038b:	68 48 38 80 00       	push   $0x803848
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 50 80 00       	mov    0x805000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 4d 38 80 00       	push   $0x80384d
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
  8003c8:	68 69 38 80 00       	push   $0x803869
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
  8003f4:	68 6c 38 80 00       	push   $0x80386c
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 b8 38 80 00       	push   $0x8038b8
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
  8004c6:	68 c4 38 80 00       	push   $0x8038c4
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 b8 38 80 00       	push   $0x8038b8
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
  800536:	68 18 39 80 00       	push   $0x803918
  80053b:	6a 44                	push   $0x44
  80053d:	68 b8 38 80 00       	push   $0x8038b8
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
  800590:	e8 fd 11 00 00       	call   801792 <sys_cputs>
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
  800607:	e8 86 11 00 00       	call   801792 <sys_cputs>
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
  800651:	e8 ea 12 00 00       	call   801940 <sys_disable_interrupt>
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
  800671:	e8 e4 12 00 00       	call   80195a <sys_enable_interrupt>
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
  8006bb:	e8 58 2d 00 00       	call   803418 <__udivdi3>
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
  80070b:	e8 18 2e 00 00       	call   803528 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 94 3b 80 00       	add    $0x803b94,%eax
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
  800866:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
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
  800947:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 a5 3b 80 00       	push   $0x803ba5
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
  80096c:	68 ae 3b 80 00       	push   $0x803bae
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
  800999:	be b1 3b 80 00       	mov    $0x803bb1,%esi
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
  8013bf:	68 10 3d 80 00       	push   $0x803d10
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
  80148f:	e8 42 04 00 00       	call   8018d6 <sys_allocate_chunk>
  801494:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801497:	a1 20 51 80 00       	mov    0x805120,%eax
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	50                   	push   %eax
  8014a0:	e8 b7 0a 00 00       	call   801f5c <initialize_MemBlocksList>
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
  8014cd:	68 35 3d 80 00       	push   $0x803d35
  8014d2:	6a 33                	push   $0x33
  8014d4:	68 53 3d 80 00       	push   $0x803d53
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
  80154c:	68 60 3d 80 00       	push   $0x803d60
  801551:	6a 34                	push   $0x34
  801553:	68 53 3d 80 00       	push   $0x803d53
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
  8015a9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ac:	e8 f7 fd ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015b5:	75 07                	jne    8015be <malloc+0x18>
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	eb 14                	jmp    8015d2 <malloc+0x2c>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	panic("malloc() is not implemented yet...!!");
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	68 84 3d 80 00       	push   $0x803d84
  8015c6:	6a 46                	push   $0x46
  8015c8:	68 53 3d 80 00       	push   $0x803d53
  8015cd:	e8 98 ed ff ff       	call   80036a <_panic>
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  8015da:	83 ec 04             	sub    $0x4,%esp
  8015dd:	68 ac 3d 80 00       	push   $0x803dac
  8015e2:	6a 61                	push   $0x61
  8015e4:	68 53 3d 80 00       	push   $0x803d53
  8015e9:	e8 7c ed ff ff       	call   80036a <_panic>

008015ee <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ee:	55                   	push   %ebp
  8015ef:	89 e5                	mov    %esp,%ebp
  8015f1:	83 ec 38             	sub    $0x38,%esp
  8015f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f7:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015fa:	e8 a9 fd ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801603:	75 0a                	jne    80160f <smalloc+0x21>
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
  80160a:	e9 9e 00 00 00       	jmp    8016ad <smalloc+0xbf>
	//3-If the Kernel successfully creates the shared variable, return its virtual address
	//4-Else, return NULL



	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80160f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801616:	8b 55 0c             	mov    0xc(%ebp),%edx
  801619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161c:	01 d0                	add    %edx,%eax
  80161e:	48                   	dec    %eax
  80161f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	f7 75 f0             	divl   -0x10(%ebp)
  80162d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801630:	29 d0                	sub    %edx,%eax
  801632:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801635:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80163c:	e8 63 06 00 00       	call   801ca4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801641:	85 c0                	test   %eax,%eax
  801643:	74 11                	je     801656 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801645:	83 ec 0c             	sub    $0xc,%esp
  801648:	ff 75 e8             	pushl  -0x18(%ebp)
  80164b:	e8 ce 0c 00 00       	call   80231e <alloc_block_FF>
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  801656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80165a:	74 4c                	je     8016a8 <smalloc+0xba>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  80165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165f:	8b 40 08             	mov    0x8(%eax),%eax
  801662:	89 c2                	mov    %eax,%edx
  801664:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801668:	52                   	push   %edx
  801669:	50                   	push   %eax
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	ff 75 08             	pushl  0x8(%ebp)
  801670:	e8 b4 03 00 00       	call   801a29 <sys_createSharedObject>
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("Output is :  %d \n" , result);
  80167b:	83 ec 08             	sub    $0x8,%esp
  80167e:	ff 75 e0             	pushl  -0x20(%ebp)
  801681:	68 cf 3d 80 00       	push   $0x803dcf
  801686:	e8 93 ef ff ff       	call   80061e <cprintf>
  80168b:	83 c4 10             	add    $0x10,%esp
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  80168e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  801692:	74 14                	je     8016a8 <smalloc+0xba>
  801694:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  801698:	74 0e                	je     8016a8 <smalloc+0xba>
  80169a:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  80169e:	74 08                	je     8016a8 <smalloc+0xba>
			return (void*) mem_block->sva;
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	8b 40 08             	mov    0x8(%eax),%eax
  8016a6:	eb 05                	jmp    8016ad <smalloc+0xbf>
	}
	return NULL;
  8016a8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b5:	e8 ee fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	68 e4 3d 80 00       	push   $0x803de4
  8016c2:	68 ab 00 00 00       	push   $0xab
  8016c7:	68 53 3d 80 00       	push   $0x803d53
  8016cc:	e8 99 ec ff ff       	call   80036a <_panic>

008016d1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d7:	e8 cc fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8016dc:	83 ec 04             	sub    $0x4,%esp
  8016df:	68 08 3e 80 00       	push   $0x803e08
  8016e4:	68 ef 00 00 00       	push   $0xef
  8016e9:	68 53 3d 80 00       	push   $0x803d53
  8016ee:	e8 77 ec ff ff       	call   80036a <_panic>

008016f3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	68 30 3e 80 00       	push   $0x803e30
  801701:	68 03 01 00 00       	push   $0x103
  801706:	68 53 3d 80 00       	push   $0x803d53
  80170b:	e8 5a ec ff ff       	call   80036a <_panic>

00801710 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	68 54 3e 80 00       	push   $0x803e54
  80171e:	68 0e 01 00 00       	push   $0x10e
  801723:	68 53 3d 80 00       	push   $0x803d53
  801728:	e8 3d ec ff ff       	call   80036a <_panic>

0080172d <shrink>:

}
void shrink(uint32 newSize)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	68 54 3e 80 00       	push   $0x803e54
  80173b:	68 13 01 00 00       	push   $0x113
  801740:	68 53 3d 80 00       	push   $0x803d53
  801745:	e8 20 ec ff ff       	call   80036a <_panic>

0080174a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 54 3e 80 00       	push   $0x803e54
  801758:	68 18 01 00 00       	push   $0x118
  80175d:	68 53 3d 80 00       	push   $0x803d53
  801762:	e8 03 ec ff ff       	call   80036a <_panic>

00801767 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	57                   	push   %edi
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8b 55 0c             	mov    0xc(%ebp),%edx
  801776:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801779:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80177c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80177f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801782:	cd 30                	int    $0x30
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801787:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5e                   	pop    %esi
  80178f:	5f                   	pop    %edi
  801790:	5d                   	pop    %ebp
  801791:	c3                   	ret    

00801792 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801792:	55                   	push   %ebp
  801793:	89 e5                	mov    %esp,%ebp
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	8b 45 10             	mov    0x10(%ebp),%eax
  80179b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80179e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	6a 00                	push   $0x0
  8017a7:	6a 00                	push   $0x0
  8017a9:	52                   	push   %edx
  8017aa:	ff 75 0c             	pushl  0xc(%ebp)
  8017ad:	50                   	push   %eax
  8017ae:	6a 00                	push   $0x0
  8017b0:	e8 b2 ff ff ff       	call   801767 <syscall>
  8017b5:	83 c4 18             	add    $0x18,%esp
}
  8017b8:	90                   	nop
  8017b9:	c9                   	leave  
  8017ba:	c3                   	ret    

008017bb <sys_cgetc>:

int
sys_cgetc(void)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 01                	push   $0x1
  8017ca:	e8 98 ff ff ff       	call   801767 <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017da:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	52                   	push   %edx
  8017e4:	50                   	push   %eax
  8017e5:	6a 05                	push   $0x5
  8017e7:	e8 7b ff ff ff       	call   801767 <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8017f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	56                   	push   %esi
  801806:	53                   	push   %ebx
  801807:	51                   	push   %ecx
  801808:	52                   	push   %edx
  801809:	50                   	push   %eax
  80180a:	6a 06                	push   $0x6
  80180c:	e8 56 ff ff ff       	call   801767 <syscall>
  801811:	83 c4 18             	add    $0x18,%esp
}
  801814:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801817:	5b                   	pop    %ebx
  801818:	5e                   	pop    %esi
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    

0080181b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80181e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	52                   	push   %edx
  80182b:	50                   	push   %eax
  80182c:	6a 07                	push   $0x7
  80182e:	e8 34 ff ff ff       	call   801767 <syscall>
  801833:	83 c4 18             	add    $0x18,%esp
}
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	ff 75 08             	pushl  0x8(%ebp)
  801847:	6a 08                	push   $0x8
  801849:	e8 19 ff ff ff       	call   801767 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 09                	push   $0x9
  801862:	e8 00 ff ff ff       	call   801767 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 0a                	push   $0xa
  80187b:	e8 e7 fe ff ff       	call   801767 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 0b                	push   $0xb
  801894:	e8 ce fe ff ff       	call   801767 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	ff 75 0c             	pushl  0xc(%ebp)
  8018aa:	ff 75 08             	pushl  0x8(%ebp)
  8018ad:	6a 0f                	push   $0xf
  8018af:	e8 b3 fe ff ff       	call   801767 <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
	return;
  8018b7:	90                   	nop
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	ff 75 08             	pushl  0x8(%ebp)
  8018c9:	6a 10                	push   $0x10
  8018cb:	e8 97 fe ff ff       	call   801767 <syscall>
  8018d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8018d3:	90                   	nop
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	ff 75 10             	pushl  0x10(%ebp)
  8018e0:	ff 75 0c             	pushl  0xc(%ebp)
  8018e3:	ff 75 08             	pushl  0x8(%ebp)
  8018e6:	6a 11                	push   $0x11
  8018e8:	e8 7a fe ff ff       	call   801767 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8018f0:	90                   	nop
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 0c                	push   $0xc
  801902:	e8 60 fe ff ff       	call   801767 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	ff 75 08             	pushl  0x8(%ebp)
  80191a:	6a 0d                	push   $0xd
  80191c:	e8 46 fe ff ff       	call   801767 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 0e                	push   $0xe
  801935:	e8 2d fe ff ff       	call   801767 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	90                   	nop
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 13                	push   $0x13
  80194f:	e8 13 fe ff ff       	call   801767 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
}
  801957:	90                   	nop
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 14                	push   $0x14
  801969:	e8 f9 fd ff ff       	call   801767 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_cputc>:


void
sys_cputc(const char c)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 04             	sub    $0x4,%esp
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801980:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	50                   	push   %eax
  80198d:	6a 15                	push   $0x15
  80198f:	e8 d3 fd ff ff       	call   801767 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	90                   	nop
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 16                	push   $0x16
  8019a9:	e8 b9 fd ff ff       	call   801767 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	50                   	push   %eax
  8019c4:	6a 17                	push   $0x17
  8019c6:	e8 9c fd ff ff       	call   801767 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	52                   	push   %edx
  8019e0:	50                   	push   %eax
  8019e1:	6a 1a                	push   $0x1a
  8019e3:	e8 7f fd ff ff       	call   801767 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	52                   	push   %edx
  8019fd:	50                   	push   %eax
  8019fe:	6a 18                	push   $0x18
  801a00:	e8 62 fd ff ff       	call   801767 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	52                   	push   %edx
  801a1b:	50                   	push   %eax
  801a1c:	6a 19                	push   $0x19
  801a1e:	e8 44 fd ff ff       	call   801767 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	90                   	nop
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 04             	sub    $0x4,%esp
  801a2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a32:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a35:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a38:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	51                   	push   %ecx
  801a42:	52                   	push   %edx
  801a43:	ff 75 0c             	pushl  0xc(%ebp)
  801a46:	50                   	push   %eax
  801a47:	6a 1b                	push   $0x1b
  801a49:	e8 19 fd ff ff       	call   801767 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	52                   	push   %edx
  801a63:	50                   	push   %eax
  801a64:	6a 1c                	push   $0x1c
  801a66:	e8 fc fc ff ff       	call   801767 <syscall>
  801a6b:	83 c4 18             	add    $0x18,%esp
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	51                   	push   %ecx
  801a81:	52                   	push   %edx
  801a82:	50                   	push   %eax
  801a83:	6a 1d                	push   $0x1d
  801a85:	e8 dd fc ff ff       	call   801767 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    

00801a8f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a95:	8b 45 08             	mov    0x8(%ebp),%eax
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	52                   	push   %edx
  801a9f:	50                   	push   %eax
  801aa0:	6a 1e                	push   $0x1e
  801aa2:	e8 c0 fc ff ff       	call   801767 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 1f                	push   $0x1f
  801abb:	e8 a7 fc ff ff       	call   801767 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	ff 75 14             	pushl  0x14(%ebp)
  801ad0:	ff 75 10             	pushl  0x10(%ebp)
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	50                   	push   %eax
  801ad7:	6a 20                	push   $0x20
  801ad9:	e8 89 fc ff ff       	call   801767 <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	50                   	push   %eax
  801af2:	6a 21                	push   $0x21
  801af4:	e8 6e fc ff ff       	call   801767 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	90                   	nop
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	50                   	push   %eax
  801b0e:	6a 22                	push   $0x22
  801b10:	e8 52 fc ff ff       	call   801767 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 02                	push   $0x2
  801b29:	e8 39 fc ff ff       	call   801767 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 03                	push   $0x3
  801b42:	e8 20 fc ff ff       	call   801767 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 04                	push   $0x4
  801b5b:	e8 07 fc ff ff       	call   801767 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_exit_env>:


void sys_exit_env(void)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 23                	push   $0x23
  801b74:	e8 ee fb ff ff       	call   801767 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	90                   	nop
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b88:	8d 50 04             	lea    0x4(%eax),%edx
  801b8b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 24                	push   $0x24
  801b98:	e8 ca fb ff ff       	call   801767 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
	return result;
  801ba0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ba3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ba6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba9:	89 01                	mov    %eax,(%ecx)
  801bab:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	c9                   	leave  
  801bb2:	c2 04 00             	ret    $0x4

00801bb5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	ff 75 10             	pushl  0x10(%ebp)
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	ff 75 08             	pushl  0x8(%ebp)
  801bc5:	6a 12                	push   $0x12
  801bc7:	e8 9b fb ff ff       	call   801767 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcf:	90                   	nop
}
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 25                	push   $0x25
  801be1:	e8 81 fb ff ff       	call   801767 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bf7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	50                   	push   %eax
  801c04:	6a 26                	push   $0x26
  801c06:	e8 5c fb ff ff       	call   801767 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0e:	90                   	nop
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <rsttst>:
void rsttst()
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 28                	push   $0x28
  801c20:	e8 42 fb ff ff       	call   801767 <syscall>
  801c25:	83 c4 18             	add    $0x18,%esp
	return ;
  801c28:	90                   	nop
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 04             	sub    $0x4,%esp
  801c31:	8b 45 14             	mov    0x14(%ebp),%eax
  801c34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c37:	8b 55 18             	mov    0x18(%ebp),%edx
  801c3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c3e:	52                   	push   %edx
  801c3f:	50                   	push   %eax
  801c40:	ff 75 10             	pushl  0x10(%ebp)
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	ff 75 08             	pushl  0x8(%ebp)
  801c49:	6a 27                	push   $0x27
  801c4b:	e8 17 fb ff ff       	call   801767 <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
	return ;
  801c53:	90                   	nop
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <chktst>:
void chktst(uint32 n)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	ff 75 08             	pushl  0x8(%ebp)
  801c64:	6a 29                	push   $0x29
  801c66:	e8 fc fa ff ff       	call   801767 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6e:	90                   	nop
}
  801c6f:	c9                   	leave  
  801c70:	c3                   	ret    

00801c71 <inctst>:

void inctst()
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 2a                	push   $0x2a
  801c80:	e8 e2 fa ff ff       	call   801767 <syscall>
  801c85:	83 c4 18             	add    $0x18,%esp
	return ;
  801c88:	90                   	nop
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <gettst>:
uint32 gettst()
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 2b                	push   $0x2b
  801c9a:	e8 c8 fa ff ff       	call   801767 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	c9                   	leave  
  801ca3:	c3                   	ret    

00801ca4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 2c                	push   $0x2c
  801cb6:	e8 ac fa ff ff       	call   801767 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
  801cbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cc1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cc5:	75 07                	jne    801cce <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801ccc:	eb 05                	jmp    801cd3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 2c                	push   $0x2c
  801ce7:	e8 7b fa ff ff       	call   801767 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
  801cef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801cf2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cf6:	75 07                	jne    801cff <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cf8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfd:	eb 05                	jmp    801d04 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 2c                	push   $0x2c
  801d18:	e8 4a fa ff ff       	call   801767 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
  801d20:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d23:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d27:	75 07                	jne    801d30 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d29:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2e:	eb 05                	jmp    801d35 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 2c                	push   $0x2c
  801d49:	e8 19 fa ff ff       	call   801767 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
  801d51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d54:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d58:	75 07                	jne    801d61 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5f:	eb 05                	jmp    801d66 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d61:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	ff 75 08             	pushl  0x8(%ebp)
  801d76:	6a 2d                	push   $0x2d
  801d78:	e8 ea f9 ff ff       	call   801767 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d80:	90                   	nop
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d87:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	6a 00                	push   $0x0
  801d95:	53                   	push   %ebx
  801d96:	51                   	push   %ecx
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 2e                	push   $0x2e
  801d9b:	e8 c7 f9 ff ff       	call   801767 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	52                   	push   %edx
  801db8:	50                   	push   %eax
  801db9:	6a 2f                	push   $0x2f
  801dbb:	e8 a7 f9 ff ff       	call   801767 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	68 64 3e 80 00       	push   $0x803e64
  801dd3:	e8 46 e8 ff ff       	call   80061e <cprintf>
  801dd8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ddb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801de2:	83 ec 0c             	sub    $0xc,%esp
  801de5:	68 90 3e 80 00       	push   $0x803e90
  801dea:	e8 2f e8 ff ff       	call   80061e <cprintf>
  801def:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801df2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df6:	a1 38 51 80 00       	mov    0x805138,%eax
  801dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dfe:	eb 56                	jmp    801e56 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e04:	74 1c                	je     801e22 <print_mem_block_lists+0x5d>
  801e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e09:	8b 50 08             	mov    0x8(%eax),%edx
  801e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0f:	8b 48 08             	mov    0x8(%eax),%ecx
  801e12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e15:	8b 40 0c             	mov    0xc(%eax),%eax
  801e18:	01 c8                	add    %ecx,%eax
  801e1a:	39 c2                	cmp    %eax,%edx
  801e1c:	73 04                	jae    801e22 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e1e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e25:	8b 50 08             	mov    0x8(%eax),%edx
  801e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  801e2e:	01 c2                	add    %eax,%edx
  801e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e33:	8b 40 08             	mov    0x8(%eax),%eax
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	52                   	push   %edx
  801e3a:	50                   	push   %eax
  801e3b:	68 a5 3e 80 00       	push   $0x803ea5
  801e40:	e8 d9 e7 ff ff       	call   80061e <cprintf>
  801e45:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e4e:	a1 40 51 80 00       	mov    0x805140,%eax
  801e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e5a:	74 07                	je     801e63 <print_mem_block_lists+0x9e>
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	8b 00                	mov    (%eax),%eax
  801e61:	eb 05                	jmp    801e68 <print_mem_block_lists+0xa3>
  801e63:	b8 00 00 00 00       	mov    $0x0,%eax
  801e68:	a3 40 51 80 00       	mov    %eax,0x805140
  801e6d:	a1 40 51 80 00       	mov    0x805140,%eax
  801e72:	85 c0                	test   %eax,%eax
  801e74:	75 8a                	jne    801e00 <print_mem_block_lists+0x3b>
  801e76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e7a:	75 84                	jne    801e00 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e7c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e80:	75 10                	jne    801e92 <print_mem_block_lists+0xcd>
  801e82:	83 ec 0c             	sub    $0xc,%esp
  801e85:	68 b4 3e 80 00       	push   $0x803eb4
  801e8a:	e8 8f e7 ff ff       	call   80061e <cprintf>
  801e8f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e99:	83 ec 0c             	sub    $0xc,%esp
  801e9c:	68 d8 3e 80 00       	push   $0x803ed8
  801ea1:	e8 78 e7 ff ff       	call   80061e <cprintf>
  801ea6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ea9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ead:	a1 40 50 80 00       	mov    0x805040,%eax
  801eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb5:	eb 56                	jmp    801f0d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebb:	74 1c                	je     801ed9 <print_mem_block_lists+0x114>
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	8b 50 08             	mov    0x8(%eax),%edx
  801ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec6:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecf:	01 c8                	add    %ecx,%eax
  801ed1:	39 c2                	cmp    %eax,%edx
  801ed3:	73 04                	jae    801ed9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ed5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	8b 50 08             	mov    0x8(%eax),%edx
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee5:	01 c2                	add    %eax,%edx
  801ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eea:	8b 40 08             	mov    0x8(%eax),%eax
  801eed:	83 ec 04             	sub    $0x4,%esp
  801ef0:	52                   	push   %edx
  801ef1:	50                   	push   %eax
  801ef2:	68 a5 3e 80 00       	push   $0x803ea5
  801ef7:	e8 22 e7 ff ff       	call   80061e <cprintf>
  801efc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f05:	a1 48 50 80 00       	mov    0x805048,%eax
  801f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f11:	74 07                	je     801f1a <print_mem_block_lists+0x155>
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	8b 00                	mov    (%eax),%eax
  801f18:	eb 05                	jmp    801f1f <print_mem_block_lists+0x15a>
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1f:	a3 48 50 80 00       	mov    %eax,0x805048
  801f24:	a1 48 50 80 00       	mov    0x805048,%eax
  801f29:	85 c0                	test   %eax,%eax
  801f2b:	75 8a                	jne    801eb7 <print_mem_block_lists+0xf2>
  801f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f31:	75 84                	jne    801eb7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f33:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f37:	75 10                	jne    801f49 <print_mem_block_lists+0x184>
  801f39:	83 ec 0c             	sub    $0xc,%esp
  801f3c:	68 f0 3e 80 00       	push   $0x803ef0
  801f41:	e8 d8 e6 ff ff       	call   80061e <cprintf>
  801f46:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	68 64 3e 80 00       	push   $0x803e64
  801f51:	e8 c8 e6 ff ff       	call   80061e <cprintf>
  801f56:	83 c4 10             	add    $0x10,%esp

}
  801f59:	90                   	nop
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f62:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f69:	00 00 00 
  801f6c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f73:	00 00 00 
  801f76:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801f7d:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801f80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f87:	e9 9e 00 00 00       	jmp    80202a <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801f8c:	a1 50 50 80 00       	mov    0x805050,%eax
  801f91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f94:	c1 e2 04             	shl    $0x4,%edx
  801f97:	01 d0                	add    %edx,%eax
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	75 14                	jne    801fb1 <initialize_MemBlocksList+0x55>
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	68 18 3f 80 00       	push   $0x803f18
  801fa5:	6a 46                	push   $0x46
  801fa7:	68 3b 3f 80 00       	push   $0x803f3b
  801fac:	e8 b9 e3 ff ff       	call   80036a <_panic>
  801fb1:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb9:	c1 e2 04             	shl    $0x4,%edx
  801fbc:	01 d0                	add    %edx,%eax
  801fbe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fc4:	89 10                	mov    %edx,(%eax)
  801fc6:	8b 00                	mov    (%eax),%eax
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	74 18                	je     801fe4 <initialize_MemBlocksList+0x88>
  801fcc:	a1 48 51 80 00       	mov    0x805148,%eax
  801fd1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fd7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801fda:	c1 e1 04             	shl    $0x4,%ecx
  801fdd:	01 ca                	add    %ecx,%edx
  801fdf:	89 50 04             	mov    %edx,0x4(%eax)
  801fe2:	eb 12                	jmp    801ff6 <initialize_MemBlocksList+0x9a>
  801fe4:	a1 50 50 80 00       	mov    0x805050,%eax
  801fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fec:	c1 e2 04             	shl    $0x4,%edx
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ff6:	a1 50 50 80 00       	mov    0x805050,%eax
  801ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffe:	c1 e2 04             	shl    $0x4,%edx
  802001:	01 d0                	add    %edx,%eax
  802003:	a3 48 51 80 00       	mov    %eax,0x805148
  802008:	a1 50 50 80 00       	mov    0x805050,%eax
  80200d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802010:	c1 e2 04             	shl    $0x4,%edx
  802013:	01 d0                	add    %edx,%eax
  802015:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80201c:	a1 54 51 80 00       	mov    0x805154,%eax
  802021:	40                   	inc    %eax
  802022:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  802027:	ff 45 f4             	incl   -0xc(%ebp)
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802030:	0f 82 56 ff ff ff    	jb     801f8c <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  802036:	90                   	nop
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	8b 00                	mov    (%eax),%eax
  802044:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802047:	eb 19                	jmp    802062 <find_block+0x29>
	{
		if(va==point->sva)
  802049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204c:	8b 40 08             	mov    0x8(%eax),%eax
  80204f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802052:	75 05                	jne    802059 <find_block+0x20>
		   return point;
  802054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802057:	eb 36                	jmp    80208f <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	8b 40 08             	mov    0x8(%eax),%eax
  80205f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802062:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802066:	74 07                	je     80206f <find_block+0x36>
  802068:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80206b:	8b 00                	mov    (%eax),%eax
  80206d:	eb 05                	jmp    802074 <find_block+0x3b>
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	8b 55 08             	mov    0x8(%ebp),%edx
  802077:	89 42 08             	mov    %eax,0x8(%edx)
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	8b 40 08             	mov    0x8(%eax),%eax
  802080:	85 c0                	test   %eax,%eax
  802082:	75 c5                	jne    802049 <find_block+0x10>
  802084:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802088:	75 bf                	jne    802049 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  80208a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802097:	a1 40 50 80 00       	mov    0x805040,%eax
  80209c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  80209f:	a1 44 50 80 00       	mov    0x805044,%eax
  8020a4:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020ad:	74 24                	je     8020d3 <insert_sorted_allocList+0x42>
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	8b 50 08             	mov    0x8(%eax),%edx
  8020b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b8:	8b 40 08             	mov    0x8(%eax),%eax
  8020bb:	39 c2                	cmp    %eax,%edx
  8020bd:	76 14                	jbe    8020d3 <insert_sorted_allocList+0x42>
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	8b 50 08             	mov    0x8(%eax),%edx
  8020c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020c8:	8b 40 08             	mov    0x8(%eax),%eax
  8020cb:	39 c2                	cmp    %eax,%edx
  8020cd:	0f 82 60 01 00 00    	jb     802233 <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d7:	75 65                	jne    80213e <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  8020d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020dd:	75 14                	jne    8020f3 <insert_sorted_allocList+0x62>
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	68 18 3f 80 00       	push   $0x803f18
  8020e7:	6a 6b                	push   $0x6b
  8020e9:	68 3b 3f 80 00       	push   $0x803f3b
  8020ee:	e8 77 e2 ff ff       	call   80036a <_panic>
  8020f3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	89 10                	mov    %edx,(%eax)
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	8b 00                	mov    (%eax),%eax
  802103:	85 c0                	test   %eax,%eax
  802105:	74 0d                	je     802114 <insert_sorted_allocList+0x83>
  802107:	a1 40 50 80 00       	mov    0x805040,%eax
  80210c:	8b 55 08             	mov    0x8(%ebp),%edx
  80210f:	89 50 04             	mov    %edx,0x4(%eax)
  802112:	eb 08                	jmp    80211c <insert_sorted_allocList+0x8b>
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	a3 44 50 80 00       	mov    %eax,0x805044
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	a3 40 50 80 00       	mov    %eax,0x805040
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80212e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802133:	40                   	inc    %eax
  802134:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802139:	e9 dc 01 00 00       	jmp    80231a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	8b 50 08             	mov    0x8(%eax),%edx
  802144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802147:	8b 40 08             	mov    0x8(%eax),%eax
  80214a:	39 c2                	cmp    %eax,%edx
  80214c:	77 6c                	ja     8021ba <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  80214e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802152:	74 06                	je     80215a <insert_sorted_allocList+0xc9>
  802154:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802158:	75 14                	jne    80216e <insert_sorted_allocList+0xdd>
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	68 54 3f 80 00       	push   $0x803f54
  802162:	6a 6f                	push   $0x6f
  802164:	68 3b 3f 80 00       	push   $0x803f3b
  802169:	e8 fc e1 ff ff       	call   80036a <_panic>
  80216e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802171:	8b 50 04             	mov    0x4(%eax),%edx
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	89 50 04             	mov    %edx,0x4(%eax)
  80217a:	8b 45 08             	mov    0x8(%ebp),%eax
  80217d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802180:	89 10                	mov    %edx,(%eax)
  802182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802185:	8b 40 04             	mov    0x4(%eax),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	74 0d                	je     802199 <insert_sorted_allocList+0x108>
  80218c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218f:	8b 40 04             	mov    0x4(%eax),%eax
  802192:	8b 55 08             	mov    0x8(%ebp),%edx
  802195:	89 10                	mov    %edx,(%eax)
  802197:	eb 08                	jmp    8021a1 <insert_sorted_allocList+0x110>
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 40 50 80 00       	mov    %eax,0x805040
  8021a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a7:	89 50 04             	mov    %edx,0x4(%eax)
  8021aa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021af:	40                   	inc    %eax
  8021b0:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021b5:	e9 60 01 00 00       	jmp    80231a <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 50 08             	mov    0x8(%eax),%edx
  8021c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021c3:	8b 40 08             	mov    0x8(%eax),%eax
  8021c6:	39 c2                	cmp    %eax,%edx
  8021c8:	0f 82 4c 01 00 00    	jb     80231a <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d2:	75 14                	jne    8021e8 <insert_sorted_allocList+0x157>
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	68 8c 3f 80 00       	push   $0x803f8c
  8021dc:	6a 73                	push   $0x73
  8021de:	68 3b 3f 80 00       	push   $0x803f3b
  8021e3:	e8 82 e1 ff ff       	call   80036a <_panic>
  8021e8:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	89 50 04             	mov    %edx,0x4(%eax)
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	8b 40 04             	mov    0x4(%eax),%eax
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	74 0c                	je     80220a <insert_sorted_allocList+0x179>
  8021fe:	a1 44 50 80 00       	mov    0x805044,%eax
  802203:	8b 55 08             	mov    0x8(%ebp),%edx
  802206:	89 10                	mov    %edx,(%eax)
  802208:	eb 08                	jmp    802212 <insert_sorted_allocList+0x181>
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	a3 40 50 80 00       	mov    %eax,0x805040
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	a3 44 50 80 00       	mov    %eax,0x805044
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802223:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802228:	40                   	inc    %eax
  802229:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80222e:	e9 e7 00 00 00       	jmp    80231a <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  802233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802236:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802239:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802240:	a1 40 50 80 00       	mov    0x805040,%eax
  802245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802248:	e9 9d 00 00 00       	jmp    8022ea <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 00                	mov    (%eax),%eax
  802252:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	8b 50 08             	mov    0x8(%eax),%edx
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 08             	mov    0x8(%eax),%eax
  802261:	39 c2                	cmp    %eax,%edx
  802263:	76 7d                	jbe    8022e2 <insert_sorted_allocList+0x251>
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	8b 50 08             	mov    0x8(%eax),%edx
  80226b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80226e:	8b 40 08             	mov    0x8(%eax),%eax
  802271:	39 c2                	cmp    %eax,%edx
  802273:	73 6d                	jae    8022e2 <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  802275:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802279:	74 06                	je     802281 <insert_sorted_allocList+0x1f0>
  80227b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227f:	75 14                	jne    802295 <insert_sorted_allocList+0x204>
  802281:	83 ec 04             	sub    $0x4,%esp
  802284:	68 b0 3f 80 00       	push   $0x803fb0
  802289:	6a 7f                	push   $0x7f
  80228b:	68 3b 3f 80 00       	push   $0x803f3b
  802290:	e8 d5 e0 ff ff       	call   80036a <_panic>
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 10                	mov    (%eax),%edx
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	89 10                	mov    %edx,(%eax)
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	74 0b                	je     8022b3 <insert_sorted_allocList+0x222>
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 00                	mov    (%eax),%eax
  8022ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b0:	89 50 04             	mov    %edx,0x4(%eax)
  8022b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b9:	89 10                	mov    %edx,(%eax)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c1:	89 50 04             	mov    %edx,0x4(%eax)
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	75 08                	jne    8022d5 <insert_sorted_allocList+0x244>
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022da:	40                   	inc    %eax
  8022db:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  8022e0:	eb 39                	jmp    80231b <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022e2:	a1 48 50 80 00       	mov    0x805048,%eax
  8022e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022ee:	74 07                	je     8022f7 <insert_sorted_allocList+0x266>
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 00                	mov    (%eax),%eax
  8022f5:	eb 05                	jmp    8022fc <insert_sorted_allocList+0x26b>
  8022f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fc:	a3 48 50 80 00       	mov    %eax,0x805048
  802301:	a1 48 50 80 00       	mov    0x805048,%eax
  802306:	85 c0                	test   %eax,%eax
  802308:	0f 85 3f ff ff ff    	jne    80224d <insert_sorted_allocList+0x1bc>
  80230e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802312:	0f 85 35 ff ff ff    	jne    80224d <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802318:	eb 01                	jmp    80231b <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80231a:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  80231b:	90                   	nop
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802324:	a1 38 51 80 00       	mov    0x805138,%eax
  802329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232c:	e9 85 01 00 00       	jmp    8024b6 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 40 0c             	mov    0xc(%eax),%eax
  802337:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233a:	0f 82 6e 01 00 00    	jb     8024ae <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 40 0c             	mov    0xc(%eax),%eax
  802346:	3b 45 08             	cmp    0x8(%ebp),%eax
  802349:	0f 85 8a 00 00 00    	jne    8023d9 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  80234f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802353:	75 17                	jne    80236c <alloc_block_FF+0x4e>
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	68 e4 3f 80 00       	push   $0x803fe4
  80235d:	68 93 00 00 00       	push   $0x93
  802362:	68 3b 3f 80 00       	push   $0x803f3b
  802367:	e8 fe df ff ff       	call   80036a <_panic>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	85 c0                	test   %eax,%eax
  802373:	74 10                	je     802385 <alloc_block_FF+0x67>
  802375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802378:	8b 00                	mov    (%eax),%eax
  80237a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237d:	8b 52 04             	mov    0x4(%edx),%edx
  802380:	89 50 04             	mov    %edx,0x4(%eax)
  802383:	eb 0b                	jmp    802390 <alloc_block_FF+0x72>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 40 04             	mov    0x4(%eax),%eax
  80238b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	8b 40 04             	mov    0x4(%eax),%eax
  802396:	85 c0                	test   %eax,%eax
  802398:	74 0f                	je     8023a9 <alloc_block_FF+0x8b>
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 40 04             	mov    0x4(%eax),%eax
  8023a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a3:	8b 12                	mov    (%edx),%edx
  8023a5:	89 10                	mov    %edx,(%eax)
  8023a7:	eb 0a                	jmp    8023b3 <alloc_block_FF+0x95>
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	8b 00                	mov    (%eax),%eax
  8023ae:	a3 38 51 80 00       	mov    %eax,0x805138
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8023cb:	48                   	dec    %eax
  8023cc:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	e9 10 01 00 00       	jmp    8024e9 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e2:	0f 86 c6 00 00 00    	jbe    8024ae <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8023e8:	a1 48 51 80 00       	mov    0x805148,%eax
  8023ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 50 08             	mov    0x8(%eax),%edx
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8023fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802402:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802409:	75 17                	jne    802422 <alloc_block_FF+0x104>
  80240b:	83 ec 04             	sub    $0x4,%esp
  80240e:	68 e4 3f 80 00       	push   $0x803fe4
  802413:	68 9b 00 00 00       	push   $0x9b
  802418:	68 3b 3f 80 00       	push   $0x803f3b
  80241d:	e8 48 df ff ff       	call   80036a <_panic>
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 10                	je     80243b <alloc_block_FF+0x11d>
  80242b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242e:	8b 00                	mov    (%eax),%eax
  802430:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802433:	8b 52 04             	mov    0x4(%edx),%edx
  802436:	89 50 04             	mov    %edx,0x4(%eax)
  802439:	eb 0b                	jmp    802446 <alloc_block_FF+0x128>
  80243b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243e:	8b 40 04             	mov    0x4(%eax),%eax
  802441:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802449:	8b 40 04             	mov    0x4(%eax),%eax
  80244c:	85 c0                	test   %eax,%eax
  80244e:	74 0f                	je     80245f <alloc_block_FF+0x141>
  802450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802453:	8b 40 04             	mov    0x4(%eax),%eax
  802456:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802459:	8b 12                	mov    (%edx),%edx
  80245b:	89 10                	mov    %edx,(%eax)
  80245d:	eb 0a                	jmp    802469 <alloc_block_FF+0x14b>
  80245f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802462:	8b 00                	mov    (%eax),%eax
  802464:	a3 48 51 80 00       	mov    %eax,0x805148
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802475:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247c:	a1 54 51 80 00       	mov    0x805154,%eax
  802481:	48                   	dec    %eax
  802482:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	8b 50 08             	mov    0x8(%eax),%edx
  80248d:	8b 45 08             	mov    0x8(%ebp),%eax
  802490:	01 c2                	add    %eax,%edx
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 40 0c             	mov    0xc(%eax),%eax
  80249e:	2b 45 08             	sub    0x8(%ebp),%eax
  8024a1:	89 c2                	mov    %eax,%edx
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ac:	eb 3b                	jmp    8024e9 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8024b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ba:	74 07                	je     8024c3 <alloc_block_FF+0x1a5>
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	8b 00                	mov    (%eax),%eax
  8024c1:	eb 05                	jmp    8024c8 <alloc_block_FF+0x1aa>
  8024c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c8:	a3 40 51 80 00       	mov    %eax,0x805140
  8024cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	0f 85 57 fe ff ff    	jne    802331 <alloc_block_FF+0x13>
  8024da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024de:	0f 85 4d fe ff ff    	jne    802331 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8024f1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8024f8:	a1 38 51 80 00       	mov    0x805138,%eax
  8024fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802500:	e9 df 00 00 00       	jmp    8025e4 <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  802505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802508:	8b 40 0c             	mov    0xc(%eax),%eax
  80250b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250e:	0f 82 c8 00 00 00    	jb     8025dc <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 40 0c             	mov    0xc(%eax),%eax
  80251a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251d:	0f 85 8a 00 00 00    	jne    8025ad <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  802523:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802527:	75 17                	jne    802540 <alloc_block_BF+0x55>
  802529:	83 ec 04             	sub    $0x4,%esp
  80252c:	68 e4 3f 80 00       	push   $0x803fe4
  802531:	68 b7 00 00 00       	push   $0xb7
  802536:	68 3b 3f 80 00       	push   $0x803f3b
  80253b:	e8 2a de ff ff       	call   80036a <_panic>
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 00                	mov    (%eax),%eax
  802545:	85 c0                	test   %eax,%eax
  802547:	74 10                	je     802559 <alloc_block_BF+0x6e>
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802551:	8b 52 04             	mov    0x4(%edx),%edx
  802554:	89 50 04             	mov    %edx,0x4(%eax)
  802557:	eb 0b                	jmp    802564 <alloc_block_BF+0x79>
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 04             	mov    0x4(%eax),%eax
  80255f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 40 04             	mov    0x4(%eax),%eax
  80256a:	85 c0                	test   %eax,%eax
  80256c:	74 0f                	je     80257d <alloc_block_BF+0x92>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 40 04             	mov    0x4(%eax),%eax
  802574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802577:	8b 12                	mov    (%edx),%edx
  802579:	89 10                	mov    %edx,(%eax)
  80257b:	eb 0a                	jmp    802587 <alloc_block_BF+0x9c>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	a3 38 51 80 00       	mov    %eax,0x805138
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259a:	a1 44 51 80 00       	mov    0x805144,%eax
  80259f:	48                   	dec    %eax
  8025a0:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	e9 4d 01 00 00       	jmp    8026fa <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b6:	76 24                	jbe    8025dc <alloc_block_BF+0xf1>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025c1:	73 19                	jae    8025dc <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025c3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 08             	mov    0x8(%eax),%eax
  8025d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025dc:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e8:	74 07                	je     8025f1 <alloc_block_BF+0x106>
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 00                	mov    (%eax),%eax
  8025ef:	eb 05                	jmp    8025f6 <alloc_block_BF+0x10b>
  8025f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f6:	a3 40 51 80 00       	mov    %eax,0x805140
  8025fb:	a1 40 51 80 00       	mov    0x805140,%eax
  802600:	85 c0                	test   %eax,%eax
  802602:	0f 85 fd fe ff ff    	jne    802505 <alloc_block_BF+0x1a>
  802608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260c:	0f 85 f3 fe ff ff    	jne    802505 <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  802612:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802616:	0f 84 d9 00 00 00    	je     8026f5 <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  80261c:	a1 48 51 80 00       	mov    0x805148,%eax
  802621:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  802624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802627:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80262a:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  80262d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802630:	8b 55 08             	mov    0x8(%ebp),%edx
  802633:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  802636:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80263a:	75 17                	jne    802653 <alloc_block_BF+0x168>
  80263c:	83 ec 04             	sub    $0x4,%esp
  80263f:	68 e4 3f 80 00       	push   $0x803fe4
  802644:	68 c7 00 00 00       	push   $0xc7
  802649:	68 3b 3f 80 00       	push   $0x803f3b
  80264e:	e8 17 dd ff ff       	call   80036a <_panic>
  802653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802656:	8b 00                	mov    (%eax),%eax
  802658:	85 c0                	test   %eax,%eax
  80265a:	74 10                	je     80266c <alloc_block_BF+0x181>
  80265c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802664:	8b 52 04             	mov    0x4(%edx),%edx
  802667:	89 50 04             	mov    %edx,0x4(%eax)
  80266a:	eb 0b                	jmp    802677 <alloc_block_BF+0x18c>
  80266c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802677:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267a:	8b 40 04             	mov    0x4(%eax),%eax
  80267d:	85 c0                	test   %eax,%eax
  80267f:	74 0f                	je     802690 <alloc_block_BF+0x1a5>
  802681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802684:	8b 40 04             	mov    0x4(%eax),%eax
  802687:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268a:	8b 12                	mov    (%edx),%edx
  80268c:	89 10                	mov    %edx,(%eax)
  80268e:	eb 0a                	jmp    80269a <alloc_block_BF+0x1af>
  802690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	a3 48 51 80 00       	mov    %eax,0x805148
  80269a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8026b2:	48                   	dec    %eax
  8026b3:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026b8:	83 ec 08             	sub    $0x8,%esp
  8026bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8026be:	68 38 51 80 00       	push   $0x805138
  8026c3:	e8 71 f9 ff ff       	call   802039 <find_block>
  8026c8:	83 c4 10             	add    $0x10,%esp
  8026cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d1:	8b 50 08             	mov    0x8(%eax),%edx
  8026d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d7:	01 c2                	add    %eax,%edx
  8026d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026dc:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  8026df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e5:	2b 45 08             	sub    0x8(%ebp),%eax
  8026e8:	89 c2                	mov    %eax,%edx
  8026ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ed:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8026f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f3:	eb 05                	jmp    8026fa <alloc_block_BF+0x20f>
	}
	return NULL;
  8026f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fa:	c9                   	leave  
  8026fb:	c3                   	ret    

008026fc <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  802702:	a1 28 50 80 00       	mov    0x805028,%eax
  802707:	85 c0                	test   %eax,%eax
  802709:	0f 85 de 01 00 00    	jne    8028ed <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80270f:	a1 38 51 80 00       	mov    0x805138,%eax
  802714:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802717:	e9 9e 01 00 00       	jmp    8028ba <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 0c             	mov    0xc(%eax),%eax
  802722:	3b 45 08             	cmp    0x8(%ebp),%eax
  802725:	0f 82 87 01 00 00    	jb     8028b2 <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 40 0c             	mov    0xc(%eax),%eax
  802731:	3b 45 08             	cmp    0x8(%ebp),%eax
  802734:	0f 85 95 00 00 00    	jne    8027cf <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  80273a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273e:	75 17                	jne    802757 <alloc_block_NF+0x5b>
  802740:	83 ec 04             	sub    $0x4,%esp
  802743:	68 e4 3f 80 00       	push   $0x803fe4
  802748:	68 e0 00 00 00       	push   $0xe0
  80274d:	68 3b 3f 80 00       	push   $0x803f3b
  802752:	e8 13 dc ff ff       	call   80036a <_panic>
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	74 10                	je     802770 <alloc_block_NF+0x74>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802768:	8b 52 04             	mov    0x4(%edx),%edx
  80276b:	89 50 04             	mov    %edx,0x4(%eax)
  80276e:	eb 0b                	jmp    80277b <alloc_block_NF+0x7f>
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 04             	mov    0x4(%eax),%eax
  802776:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	8b 40 04             	mov    0x4(%eax),%eax
  802781:	85 c0                	test   %eax,%eax
  802783:	74 0f                	je     802794 <alloc_block_NF+0x98>
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 40 04             	mov    0x4(%eax),%eax
  80278b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278e:	8b 12                	mov    (%edx),%edx
  802790:	89 10                	mov    %edx,(%eax)
  802792:	eb 0a                	jmp    80279e <alloc_block_NF+0xa2>
  802794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802797:	8b 00                	mov    (%eax),%eax
  802799:	a3 38 51 80 00       	mov    %eax,0x805138
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b1:	a1 44 51 80 00       	mov    0x805144,%eax
  8027b6:	48                   	dec    %eax
  8027b7:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 40 08             	mov    0x8(%eax),%eax
  8027c2:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	e9 f8 04 00 00       	jmp    802cc7 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027d8:	0f 86 d4 00 00 00    	jbe    8028b2 <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8027de:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 50 08             	mov    0x8(%eax),%edx
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ef:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f8:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8027fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ff:	75 17                	jne    802818 <alloc_block_NF+0x11c>
  802801:	83 ec 04             	sub    $0x4,%esp
  802804:	68 e4 3f 80 00       	push   $0x803fe4
  802809:	68 e9 00 00 00       	push   $0xe9
  80280e:	68 3b 3f 80 00       	push   $0x803f3b
  802813:	e8 52 db ff ff       	call   80036a <_panic>
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	85 c0                	test   %eax,%eax
  80281f:	74 10                	je     802831 <alloc_block_NF+0x135>
  802821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802824:	8b 00                	mov    (%eax),%eax
  802826:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802829:	8b 52 04             	mov    0x4(%edx),%edx
  80282c:	89 50 04             	mov    %edx,0x4(%eax)
  80282f:	eb 0b                	jmp    80283c <alloc_block_NF+0x140>
  802831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802834:	8b 40 04             	mov    0x4(%eax),%eax
  802837:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80283c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283f:	8b 40 04             	mov    0x4(%eax),%eax
  802842:	85 c0                	test   %eax,%eax
  802844:	74 0f                	je     802855 <alloc_block_NF+0x159>
  802846:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802849:	8b 40 04             	mov    0x4(%eax),%eax
  80284c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80284f:	8b 12                	mov    (%edx),%edx
  802851:	89 10                	mov    %edx,(%eax)
  802853:	eb 0a                	jmp    80285f <alloc_block_NF+0x163>
  802855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802858:	8b 00                	mov    (%eax),%eax
  80285a:	a3 48 51 80 00       	mov    %eax,0x805148
  80285f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802862:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802872:	a1 54 51 80 00       	mov    0x805154,%eax
  802877:	48                   	dec    %eax
  802878:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	8b 40 08             	mov    0x8(%eax),%eax
  802883:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	8b 50 08             	mov    0x8(%eax),%edx
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	01 c2                	add    %eax,%edx
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	8b 40 0c             	mov    0xc(%eax),%eax
  80289f:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a2:	89 c2                	mov    %eax,%edx
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	e9 15 04 00 00       	jmp    802cc7 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028be:	74 07                	je     8028c7 <alloc_block_NF+0x1cb>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	eb 05                	jmp    8028cc <alloc_block_NF+0x1d0>
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028cc:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	0f 85 3e fe ff ff    	jne    80271c <alloc_block_NF+0x20>
  8028de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e2:	0f 85 34 fe ff ff    	jne    80271c <alloc_block_NF+0x20>
  8028e8:	e9 d5 03 00 00       	jmp    802cc2 <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8028ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8028f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f5:	e9 b1 01 00 00       	jmp    802aab <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 50 08             	mov    0x8(%eax),%edx
  802900:	a1 28 50 80 00       	mov    0x805028,%eax
  802905:	39 c2                	cmp    %eax,%edx
  802907:	0f 82 96 01 00 00    	jb     802aa3 <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 0c             	mov    0xc(%eax),%eax
  802913:	3b 45 08             	cmp    0x8(%ebp),%eax
  802916:	0f 82 87 01 00 00    	jb     802aa3 <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  80291c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291f:	8b 40 0c             	mov    0xc(%eax),%eax
  802922:	3b 45 08             	cmp    0x8(%ebp),%eax
  802925:	0f 85 95 00 00 00    	jne    8029c0 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  80292b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292f:	75 17                	jne    802948 <alloc_block_NF+0x24c>
  802931:	83 ec 04             	sub    $0x4,%esp
  802934:	68 e4 3f 80 00       	push   $0x803fe4
  802939:	68 fc 00 00 00       	push   $0xfc
  80293e:	68 3b 3f 80 00       	push   $0x803f3b
  802943:	e8 22 da ff ff       	call   80036a <_panic>
  802948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	74 10                	je     802961 <alloc_block_NF+0x265>
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802959:	8b 52 04             	mov    0x4(%edx),%edx
  80295c:	89 50 04             	mov    %edx,0x4(%eax)
  80295f:	eb 0b                	jmp    80296c <alloc_block_NF+0x270>
  802961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802964:	8b 40 04             	mov    0x4(%eax),%eax
  802967:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 0f                	je     802985 <alloc_block_NF+0x289>
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297f:	8b 12                	mov    (%edx),%edx
  802981:	89 10                	mov    %edx,(%eax)
  802983:	eb 0a                	jmp    80298f <alloc_block_NF+0x293>
  802985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802988:	8b 00                	mov    (%eax),%eax
  80298a:	a3 38 51 80 00       	mov    %eax,0x805138
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8029a7:	48                   	dec    %eax
  8029a8:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 40 08             	mov    0x8(%eax),%eax
  8029b3:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	e9 07 03 00 00       	jmp    802cc7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c9:	0f 86 d4 00 00 00    	jbe    802aa3 <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029cf:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 50 08             	mov    0x8(%eax),%edx
  8029dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e0:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  8029e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e9:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8029ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029f0:	75 17                	jne    802a09 <alloc_block_NF+0x30d>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 e4 3f 80 00       	push   $0x803fe4
  8029fa:	68 04 01 00 00       	push   $0x104
  8029ff:	68 3b 3f 80 00       	push   $0x803f3b
  802a04:	e8 61 d9 ff ff       	call   80036a <_panic>
  802a09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 10                	je     802a22 <alloc_block_NF+0x326>
  802a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a1a:	8b 52 04             	mov    0x4(%edx),%edx
  802a1d:	89 50 04             	mov    %edx,0x4(%eax)
  802a20:	eb 0b                	jmp    802a2d <alloc_block_NF+0x331>
  802a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a25:	8b 40 04             	mov    0x4(%eax),%eax
  802a28:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a30:	8b 40 04             	mov    0x4(%eax),%eax
  802a33:	85 c0                	test   %eax,%eax
  802a35:	74 0f                	je     802a46 <alloc_block_NF+0x34a>
  802a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a40:	8b 12                	mov    (%edx),%edx
  802a42:	89 10                	mov    %edx,(%eax)
  802a44:	eb 0a                	jmp    802a50 <alloc_block_NF+0x354>
  802a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a49:	8b 00                	mov    (%eax),%eax
  802a4b:	a3 48 51 80 00       	mov    %eax,0x805148
  802a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a63:	a1 54 51 80 00       	mov    0x805154,%eax
  802a68:	48                   	dec    %eax
  802a69:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a71:	8b 40 08             	mov    0x8(%eax),%eax
  802a74:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 50 08             	mov    0x8(%eax),%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	01 c2                	add    %eax,%edx
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a90:	2b 45 08             	sub    0x8(%ebp),%eax
  802a93:	89 c2                	mov    %eax,%edx
  802a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a98:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802a9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9e:	e9 24 02 00 00       	jmp    802cc7 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802aa3:	a1 40 51 80 00       	mov    0x805140,%eax
  802aa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aaf:	74 07                	je     802ab8 <alloc_block_NF+0x3bc>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	eb 05                	jmp    802abd <alloc_block_NF+0x3c1>
  802ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  802abd:	a3 40 51 80 00       	mov    %eax,0x805140
  802ac2:	a1 40 51 80 00       	mov    0x805140,%eax
  802ac7:	85 c0                	test   %eax,%eax
  802ac9:	0f 85 2b fe ff ff    	jne    8028fa <alloc_block_NF+0x1fe>
  802acf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad3:	0f 85 21 fe ff ff    	jne    8028fa <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802ad9:	a1 38 51 80 00       	mov    0x805138,%eax
  802ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ae1:	e9 ae 01 00 00       	jmp    802c94 <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	8b 50 08             	mov    0x8(%eax),%edx
  802aec:	a1 28 50 80 00       	mov    0x805028,%eax
  802af1:	39 c2                	cmp    %eax,%edx
  802af3:	0f 83 93 01 00 00    	jae    802c8c <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 0c             	mov    0xc(%eax),%eax
  802aff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b02:	0f 82 84 01 00 00    	jb     802c8c <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b11:	0f 85 95 00 00 00    	jne    802bac <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1b:	75 17                	jne    802b34 <alloc_block_NF+0x438>
  802b1d:	83 ec 04             	sub    $0x4,%esp
  802b20:	68 e4 3f 80 00       	push   $0x803fe4
  802b25:	68 14 01 00 00       	push   $0x114
  802b2a:	68 3b 3f 80 00       	push   $0x803f3b
  802b2f:	e8 36 d8 ff ff       	call   80036a <_panic>
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 00                	mov    (%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 10                	je     802b4d <alloc_block_NF+0x451>
  802b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b45:	8b 52 04             	mov    0x4(%edx),%edx
  802b48:	89 50 04             	mov    %edx,0x4(%eax)
  802b4b:	eb 0b                	jmp    802b58 <alloc_block_NF+0x45c>
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 40 04             	mov    0x4(%eax),%eax
  802b53:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 04             	mov    0x4(%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 0f                	je     802b71 <alloc_block_NF+0x475>
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6b:	8b 12                	mov    (%edx),%edx
  802b6d:	89 10                	mov    %edx,(%eax)
  802b6f:	eb 0a                	jmp    802b7b <alloc_block_NF+0x47f>
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	a3 38 51 80 00       	mov    %eax,0x805138
  802b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b8e:	a1 44 51 80 00       	mov    0x805144,%eax
  802b93:	48                   	dec    %eax
  802b94:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 08             	mov    0x8(%eax),%eax
  802b9f:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	e9 1b 01 00 00       	jmp    802cc7 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb5:	0f 86 d1 00 00 00    	jbe    802c8c <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802bbb:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 50 08             	mov    0x8(%eax),%edx
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd5:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802bd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bdc:	75 17                	jne    802bf5 <alloc_block_NF+0x4f9>
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 e4 3f 80 00       	push   $0x803fe4
  802be6:	68 1c 01 00 00       	push   $0x11c
  802beb:	68 3b 3f 80 00       	push   $0x803f3b
  802bf0:	e8 75 d7 ff ff       	call   80036a <_panic>
  802bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	74 10                	je     802c0e <alloc_block_NF+0x512>
  802bfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c06:	8b 52 04             	mov    0x4(%edx),%edx
  802c09:	89 50 04             	mov    %edx,0x4(%eax)
  802c0c:	eb 0b                	jmp    802c19 <alloc_block_NF+0x51d>
  802c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c11:	8b 40 04             	mov    0x4(%eax),%eax
  802c14:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	74 0f                	je     802c32 <alloc_block_NF+0x536>
  802c23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c26:	8b 40 04             	mov    0x4(%eax),%eax
  802c29:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c2c:	8b 12                	mov    (%edx),%edx
  802c2e:	89 10                	mov    %edx,(%eax)
  802c30:	eb 0a                	jmp    802c3c <alloc_block_NF+0x540>
  802c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	a3 48 51 80 00       	mov    %eax,0x805148
  802c3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4f:	a1 54 51 80 00       	mov    0x805154,%eax
  802c54:	48                   	dec    %eax
  802c55:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 50 08             	mov    0x8(%eax),%edx
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	01 c2                	add    %eax,%edx
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c79:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7c:	2b 45 08             	sub    0x8(%ebp),%eax
  802c7f:	89 c2                	mov    %eax,%edx
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802c87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8a:	eb 3b                	jmp    802cc7 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802c8c:	a1 40 51 80 00       	mov    0x805140,%eax
  802c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c98:	74 07                	je     802ca1 <alloc_block_NF+0x5a5>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	eb 05                	jmp    802ca6 <alloc_block_NF+0x5aa>
  802ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca6:	a3 40 51 80 00       	mov    %eax,0x805140
  802cab:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb0:	85 c0                	test   %eax,%eax
  802cb2:	0f 85 2e fe ff ff    	jne    802ae6 <alloc_block_NF+0x3ea>
  802cb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbc:	0f 85 24 fe ff ff    	jne    802ae6 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cc7:	c9                   	leave  
  802cc8:	c3                   	ret    

00802cc9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
  802ccc:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802ccf:	a1 38 51 80 00       	mov    0x805138,%eax
  802cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cd7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cdc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802cdf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	74 14                	je     802cfc <insert_sorted_with_merge_freeList+0x33>
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8b 50 08             	mov    0x8(%eax),%edx
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	8b 40 08             	mov    0x8(%eax),%eax
  802cf4:	39 c2                	cmp    %eax,%edx
  802cf6:	0f 87 9b 01 00 00    	ja     802e97 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802cfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d00:	75 17                	jne    802d19 <insert_sorted_with_merge_freeList+0x50>
  802d02:	83 ec 04             	sub    $0x4,%esp
  802d05:	68 18 3f 80 00       	push   $0x803f18
  802d0a:	68 38 01 00 00       	push   $0x138
  802d0f:	68 3b 3f 80 00       	push   $0x803f3b
  802d14:	e8 51 d6 ff ff       	call   80036a <_panic>
  802d19:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	89 10                	mov    %edx,(%eax)
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0d                	je     802d3a <insert_sorted_with_merge_freeList+0x71>
  802d2d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d32:	8b 55 08             	mov    0x8(%ebp),%edx
  802d35:	89 50 04             	mov    %edx,0x4(%eax)
  802d38:	eb 08                	jmp    802d42 <insert_sorted_with_merge_freeList+0x79>
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	a3 38 51 80 00       	mov    %eax,0x805138
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d54:	a1 44 51 80 00       	mov    0x805144,%eax
  802d59:	40                   	inc    %eax
  802d5a:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d63:	0f 84 a8 06 00 00    	je     803411 <insert_sorted_with_merge_freeList+0x748>
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	8b 50 08             	mov    0x8(%eax),%edx
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	8b 40 0c             	mov    0xc(%eax),%eax
  802d75:	01 c2                	add    %eax,%edx
  802d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7a:	8b 40 08             	mov    0x8(%eax),%eax
  802d7d:	39 c2                	cmp    %eax,%edx
  802d7f:	0f 85 8c 06 00 00    	jne    803411 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d91:	01 c2                	add    %eax,%edx
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d9d:	75 17                	jne    802db6 <insert_sorted_with_merge_freeList+0xed>
  802d9f:	83 ec 04             	sub    $0x4,%esp
  802da2:	68 e4 3f 80 00       	push   $0x803fe4
  802da7:	68 3c 01 00 00       	push   $0x13c
  802dac:	68 3b 3f 80 00       	push   $0x803f3b
  802db1:	e8 b4 d5 ff ff       	call   80036a <_panic>
  802db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	85 c0                	test   %eax,%eax
  802dbd:	74 10                	je     802dcf <insert_sorted_with_merge_freeList+0x106>
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dc7:	8b 52 04             	mov    0x4(%edx),%edx
  802dca:	89 50 04             	mov    %edx,0x4(%eax)
  802dcd:	eb 0b                	jmp    802dda <insert_sorted_with_merge_freeList+0x111>
  802dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	8b 40 04             	mov    0x4(%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	74 0f                	je     802df3 <insert_sorted_with_merge_freeList+0x12a>
  802de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de7:	8b 40 04             	mov    0x4(%eax),%eax
  802dea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ded:	8b 12                	mov    (%edx),%edx
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	eb 0a                	jmp    802dfd <insert_sorted_with_merge_freeList+0x134>
  802df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df6:	8b 00                	mov    (%eax),%eax
  802df8:	a3 38 51 80 00       	mov    %eax,0x805138
  802dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e10:	a1 44 51 80 00       	mov    0x805144,%eax
  802e15:	48                   	dec    %eax
  802e16:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e33:	75 17                	jne    802e4c <insert_sorted_with_merge_freeList+0x183>
  802e35:	83 ec 04             	sub    $0x4,%esp
  802e38:	68 18 3f 80 00       	push   $0x803f18
  802e3d:	68 3f 01 00 00       	push   $0x13f
  802e42:	68 3b 3f 80 00       	push   $0x803f3b
  802e47:	e8 1e d5 ff ff       	call   80036a <_panic>
  802e4c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e55:	89 10                	mov    %edx,(%eax)
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	85 c0                	test   %eax,%eax
  802e5e:	74 0d                	je     802e6d <insert_sorted_with_merge_freeList+0x1a4>
  802e60:	a1 48 51 80 00       	mov    0x805148,%eax
  802e65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e68:	89 50 04             	mov    %edx,0x4(%eax)
  802e6b:	eb 08                	jmp    802e75 <insert_sorted_with_merge_freeList+0x1ac>
  802e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e78:	a3 48 51 80 00       	mov    %eax,0x805148
  802e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e87:	a1 54 51 80 00       	mov    0x805154,%eax
  802e8c:	40                   	inc    %eax
  802e8d:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e92:	e9 7a 05 00 00       	jmp    803411 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	8b 50 08             	mov    0x8(%eax),%edx
  802e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea0:	8b 40 08             	mov    0x8(%eax),%eax
  802ea3:	39 c2                	cmp    %eax,%edx
  802ea5:	0f 82 14 01 00 00    	jb     802fbf <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eae:	8b 50 08             	mov    0x8(%eax),%edx
  802eb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb4:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb7:	01 c2                	add    %eax,%edx
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	8b 40 08             	mov    0x8(%eax),%eax
  802ebf:	39 c2                	cmp    %eax,%edx
  802ec1:	0f 85 90 00 00 00    	jne    802f57 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eca:	8b 50 0c             	mov    0xc(%eax),%edx
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed3:	01 c2                	add    %eax,%edx
  802ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed8:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802eef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef3:	75 17                	jne    802f0c <insert_sorted_with_merge_freeList+0x243>
  802ef5:	83 ec 04             	sub    $0x4,%esp
  802ef8:	68 18 3f 80 00       	push   $0x803f18
  802efd:	68 49 01 00 00       	push   $0x149
  802f02:	68 3b 3f 80 00       	push   $0x803f3b
  802f07:	e8 5e d4 ff ff       	call   80036a <_panic>
  802f0c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	89 10                	mov    %edx,(%eax)
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	85 c0                	test   %eax,%eax
  802f1e:	74 0d                	je     802f2d <insert_sorted_with_merge_freeList+0x264>
  802f20:	a1 48 51 80 00       	mov    0x805148,%eax
  802f25:	8b 55 08             	mov    0x8(%ebp),%edx
  802f28:	89 50 04             	mov    %edx,0x4(%eax)
  802f2b:	eb 08                	jmp    802f35 <insert_sorted_with_merge_freeList+0x26c>
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	a3 48 51 80 00       	mov    %eax,0x805148
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f47:	a1 54 51 80 00       	mov    0x805154,%eax
  802f4c:	40                   	inc    %eax
  802f4d:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f52:	e9 bb 04 00 00       	jmp    803412 <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f5b:	75 17                	jne    802f74 <insert_sorted_with_merge_freeList+0x2ab>
  802f5d:	83 ec 04             	sub    $0x4,%esp
  802f60:	68 8c 3f 80 00       	push   $0x803f8c
  802f65:	68 4c 01 00 00       	push   $0x14c
  802f6a:	68 3b 3f 80 00       	push   $0x803f3b
  802f6f:	e8 f6 d3 ff ff       	call   80036a <_panic>
  802f74:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	89 50 04             	mov    %edx,0x4(%eax)
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 40 04             	mov    0x4(%eax),%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	74 0c                	je     802f96 <insert_sorted_with_merge_freeList+0x2cd>
  802f8a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f92:	89 10                	mov    %edx,(%eax)
  802f94:	eb 08                	jmp    802f9e <insert_sorted_with_merge_freeList+0x2d5>
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	a3 38 51 80 00       	mov    %eax,0x805138
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802faf:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb4:	40                   	inc    %eax
  802fb5:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fba:	e9 53 04 00 00       	jmp    803412 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fbf:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc7:	e9 15 04 00 00       	jmp    8033e1 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 00                	mov    (%eax),%eax
  802fd1:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	8b 50 08             	mov    0x8(%eax),%edx
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 40 08             	mov    0x8(%eax),%eax
  802fe0:	39 c2                	cmp    %eax,%edx
  802fe2:	0f 86 f1 03 00 00    	jbe    8033d9 <insert_sorted_with_merge_freeList+0x710>
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 50 08             	mov    0x8(%eax),%edx
  802fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff1:	8b 40 08             	mov    0x8(%eax),%eax
  802ff4:	39 c2                	cmp    %eax,%edx
  802ff6:	0f 83 dd 03 00 00    	jae    8033d9 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 50 08             	mov    0x8(%eax),%edx
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 40 0c             	mov    0xc(%eax),%eax
  803008:	01 c2                	add    %eax,%edx
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	8b 40 08             	mov    0x8(%eax),%eax
  803010:	39 c2                	cmp    %eax,%edx
  803012:	0f 85 b9 01 00 00    	jne    8031d1 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	8b 50 08             	mov    0x8(%eax),%edx
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	8b 40 0c             	mov    0xc(%eax),%eax
  803024:	01 c2                	add    %eax,%edx
  803026:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803029:	8b 40 08             	mov    0x8(%eax),%eax
  80302c:	39 c2                	cmp    %eax,%edx
  80302e:	0f 85 0d 01 00 00    	jne    803141 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  803034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803037:	8b 50 0c             	mov    0xc(%eax),%edx
  80303a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303d:	8b 40 0c             	mov    0xc(%eax),%eax
  803040:	01 c2                	add    %eax,%edx
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803048:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80304c:	75 17                	jne    803065 <insert_sorted_with_merge_freeList+0x39c>
  80304e:	83 ec 04             	sub    $0x4,%esp
  803051:	68 e4 3f 80 00       	push   $0x803fe4
  803056:	68 5c 01 00 00       	push   $0x15c
  80305b:	68 3b 3f 80 00       	push   $0x803f3b
  803060:	e8 05 d3 ff ff       	call   80036a <_panic>
  803065:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803068:	8b 00                	mov    (%eax),%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	74 10                	je     80307e <insert_sorted_with_merge_freeList+0x3b5>
  80306e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803076:	8b 52 04             	mov    0x4(%edx),%edx
  803079:	89 50 04             	mov    %edx,0x4(%eax)
  80307c:	eb 0b                	jmp    803089 <insert_sorted_with_merge_freeList+0x3c0>
  80307e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803089:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308c:	8b 40 04             	mov    0x4(%eax),%eax
  80308f:	85 c0                	test   %eax,%eax
  803091:	74 0f                	je     8030a2 <insert_sorted_with_merge_freeList+0x3d9>
  803093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309c:	8b 12                	mov    (%edx),%edx
  80309e:	89 10                	mov    %edx,(%eax)
  8030a0:	eb 0a                	jmp    8030ac <insert_sorted_with_merge_freeList+0x3e3>
  8030a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a5:	8b 00                	mov    (%eax),%eax
  8030a7:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c4:	48                   	dec    %eax
  8030c5:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8030de:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030e2:	75 17                	jne    8030fb <insert_sorted_with_merge_freeList+0x432>
  8030e4:	83 ec 04             	sub    $0x4,%esp
  8030e7:	68 18 3f 80 00       	push   $0x803f18
  8030ec:	68 5f 01 00 00       	push   $0x15f
  8030f1:	68 3b 3f 80 00       	push   $0x803f3b
  8030f6:	e8 6f d2 ff ff       	call   80036a <_panic>
  8030fb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803101:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803104:	89 10                	mov    %edx,(%eax)
  803106:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803109:	8b 00                	mov    (%eax),%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	74 0d                	je     80311c <insert_sorted_with_merge_freeList+0x453>
  80310f:	a1 48 51 80 00       	mov    0x805148,%eax
  803114:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803117:	89 50 04             	mov    %edx,0x4(%eax)
  80311a:	eb 08                	jmp    803124 <insert_sorted_with_merge_freeList+0x45b>
  80311c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803124:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803127:	a3 48 51 80 00       	mov    %eax,0x805148
  80312c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803136:	a1 54 51 80 00       	mov    0x805154,%eax
  80313b:	40                   	inc    %eax
  80313c:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	8b 50 0c             	mov    0xc(%eax),%edx
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 40 0c             	mov    0xc(%eax),%eax
  80314d:	01 c2                	add    %eax,%edx
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  803155:	8b 45 08             	mov    0x8(%ebp),%eax
  803158:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803169:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316d:	75 17                	jne    803186 <insert_sorted_with_merge_freeList+0x4bd>
  80316f:	83 ec 04             	sub    $0x4,%esp
  803172:	68 18 3f 80 00       	push   $0x803f18
  803177:	68 64 01 00 00       	push   $0x164
  80317c:	68 3b 3f 80 00       	push   $0x803f3b
  803181:	e8 e4 d1 ff ff       	call   80036a <_panic>
  803186:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	89 10                	mov    %edx,(%eax)
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 0d                	je     8031a7 <insert_sorted_with_merge_freeList+0x4de>
  80319a:	a1 48 51 80 00       	mov    0x805148,%eax
  80319f:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a2:	89 50 04             	mov    %edx,0x4(%eax)
  8031a5:	eb 08                	jmp    8031af <insert_sorted_with_merge_freeList+0x4e6>
  8031a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031aa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031c1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c6:	40                   	inc    %eax
  8031c7:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031cc:	e9 41 02 00 00       	jmp    803412 <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	8b 50 08             	mov    0x8(%eax),%edx
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	8b 40 0c             	mov    0xc(%eax),%eax
  8031dd:	01 c2                	add    %eax,%edx
  8031df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e2:	8b 40 08             	mov    0x8(%eax),%eax
  8031e5:	39 c2                	cmp    %eax,%edx
  8031e7:	0f 85 7c 01 00 00    	jne    803369 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8031ed:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8031f1:	74 06                	je     8031f9 <insert_sorted_with_merge_freeList+0x530>
  8031f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031f7:	75 17                	jne    803210 <insert_sorted_with_merge_freeList+0x547>
  8031f9:	83 ec 04             	sub    $0x4,%esp
  8031fc:	68 54 3f 80 00       	push   $0x803f54
  803201:	68 69 01 00 00       	push   $0x169
  803206:	68 3b 3f 80 00       	push   $0x803f3b
  80320b:	e8 5a d1 ff ff       	call   80036a <_panic>
  803210:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803213:	8b 50 04             	mov    0x4(%eax),%edx
  803216:	8b 45 08             	mov    0x8(%ebp),%eax
  803219:	89 50 04             	mov    %edx,0x4(%eax)
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803222:	89 10                	mov    %edx,(%eax)
  803224:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803227:	8b 40 04             	mov    0x4(%eax),%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	74 0d                	je     80323b <insert_sorted_with_merge_freeList+0x572>
  80322e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803231:	8b 40 04             	mov    0x4(%eax),%eax
  803234:	8b 55 08             	mov    0x8(%ebp),%edx
  803237:	89 10                	mov    %edx,(%eax)
  803239:	eb 08                	jmp    803243 <insert_sorted_with_merge_freeList+0x57a>
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	a3 38 51 80 00       	mov    %eax,0x805138
  803243:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803246:	8b 55 08             	mov    0x8(%ebp),%edx
  803249:	89 50 04             	mov    %edx,0x4(%eax)
  80324c:	a1 44 51 80 00       	mov    0x805144,%eax
  803251:	40                   	inc    %eax
  803252:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	8b 50 0c             	mov    0xc(%eax),%edx
  80325d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803260:	8b 40 0c             	mov    0xc(%eax),%eax
  803263:	01 c2                	add    %eax,%edx
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  80326b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80326f:	75 17                	jne    803288 <insert_sorted_with_merge_freeList+0x5bf>
  803271:	83 ec 04             	sub    $0x4,%esp
  803274:	68 e4 3f 80 00       	push   $0x803fe4
  803279:	68 6b 01 00 00       	push   $0x16b
  80327e:	68 3b 3f 80 00       	push   $0x803f3b
  803283:	e8 e2 d0 ff ff       	call   80036a <_panic>
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	8b 00                	mov    (%eax),%eax
  80328d:	85 c0                	test   %eax,%eax
  80328f:	74 10                	je     8032a1 <insert_sorted_with_merge_freeList+0x5d8>
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803299:	8b 52 04             	mov    0x4(%edx),%edx
  80329c:	89 50 04             	mov    %edx,0x4(%eax)
  80329f:	eb 0b                	jmp    8032ac <insert_sorted_with_merge_freeList+0x5e3>
  8032a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a4:	8b 40 04             	mov    0x4(%eax),%eax
  8032a7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032af:	8b 40 04             	mov    0x4(%eax),%eax
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	74 0f                	je     8032c5 <insert_sorted_with_merge_freeList+0x5fc>
  8032b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b9:	8b 40 04             	mov    0x4(%eax),%eax
  8032bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032bf:	8b 12                	mov    (%edx),%edx
  8032c1:	89 10                	mov    %edx,(%eax)
  8032c3:	eb 0a                	jmp    8032cf <insert_sorted_with_merge_freeList+0x606>
  8032c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c8:	8b 00                	mov    (%eax),%eax
  8032ca:	a3 38 51 80 00       	mov    %eax,0x805138
  8032cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e7:	48                   	dec    %eax
  8032e8:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8032ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8032f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803301:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803305:	75 17                	jne    80331e <insert_sorted_with_merge_freeList+0x655>
  803307:	83 ec 04             	sub    $0x4,%esp
  80330a:	68 18 3f 80 00       	push   $0x803f18
  80330f:	68 6e 01 00 00       	push   $0x16e
  803314:	68 3b 3f 80 00       	push   $0x803f3b
  803319:	e8 4c d0 ff ff       	call   80036a <_panic>
  80331e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803324:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803327:	89 10                	mov    %edx,(%eax)
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	8b 00                	mov    (%eax),%eax
  80332e:	85 c0                	test   %eax,%eax
  803330:	74 0d                	je     80333f <insert_sorted_with_merge_freeList+0x676>
  803332:	a1 48 51 80 00       	mov    0x805148,%eax
  803337:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80333a:	89 50 04             	mov    %edx,0x4(%eax)
  80333d:	eb 08                	jmp    803347 <insert_sorted_with_merge_freeList+0x67e>
  80333f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803342:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334a:	a3 48 51 80 00       	mov    %eax,0x805148
  80334f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803352:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803359:	a1 54 51 80 00       	mov    0x805154,%eax
  80335e:	40                   	inc    %eax
  80335f:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803364:	e9 a9 00 00 00       	jmp    803412 <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803369:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336d:	74 06                	je     803375 <insert_sorted_with_merge_freeList+0x6ac>
  80336f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803373:	75 17                	jne    80338c <insert_sorted_with_merge_freeList+0x6c3>
  803375:	83 ec 04             	sub    $0x4,%esp
  803378:	68 b0 3f 80 00       	push   $0x803fb0
  80337d:	68 73 01 00 00       	push   $0x173
  803382:	68 3b 3f 80 00       	push   $0x803f3b
  803387:	e8 de cf ff ff       	call   80036a <_panic>
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	8b 10                	mov    (%eax),%edx
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	89 10                	mov    %edx,(%eax)
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	8b 00                	mov    (%eax),%eax
  80339b:	85 c0                	test   %eax,%eax
  80339d:	74 0b                	je     8033aa <insert_sorted_with_merge_freeList+0x6e1>
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a7:	89 50 04             	mov    %edx,0x4(%eax)
  8033aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b0:	89 10                	mov    %edx,(%eax)
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033b8:	89 50 04             	mov    %edx,0x4(%eax)
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	8b 00                	mov    (%eax),%eax
  8033c0:	85 c0                	test   %eax,%eax
  8033c2:	75 08                	jne    8033cc <insert_sorted_with_merge_freeList+0x703>
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d1:	40                   	inc    %eax
  8033d2:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033d7:	eb 39                	jmp    803412 <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  8033d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8033de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e5:	74 07                	je     8033ee <insert_sorted_with_merge_freeList+0x725>
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	eb 05                	jmp    8033f3 <insert_sorted_with_merge_freeList+0x72a>
  8033ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f3:	a3 40 51 80 00       	mov    %eax,0x805140
  8033f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8033fd:	85 c0                	test   %eax,%eax
  8033ff:	0f 85 c7 fb ff ff    	jne    802fcc <insert_sorted_with_merge_freeList+0x303>
  803405:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803409:	0f 85 bd fb ff ff    	jne    802fcc <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80340f:	eb 01                	jmp    803412 <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803411:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803412:	90                   	nop
  803413:	c9                   	leave  
  803414:	c3                   	ret    
  803415:	66 90                	xchg   %ax,%ax
  803417:	90                   	nop

00803418 <__udivdi3>:
  803418:	55                   	push   %ebp
  803419:	57                   	push   %edi
  80341a:	56                   	push   %esi
  80341b:	53                   	push   %ebx
  80341c:	83 ec 1c             	sub    $0x1c,%esp
  80341f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803423:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80342f:	89 ca                	mov    %ecx,%edx
  803431:	89 f8                	mov    %edi,%eax
  803433:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803437:	85 f6                	test   %esi,%esi
  803439:	75 2d                	jne    803468 <__udivdi3+0x50>
  80343b:	39 cf                	cmp    %ecx,%edi
  80343d:	77 65                	ja     8034a4 <__udivdi3+0x8c>
  80343f:	89 fd                	mov    %edi,%ebp
  803441:	85 ff                	test   %edi,%edi
  803443:	75 0b                	jne    803450 <__udivdi3+0x38>
  803445:	b8 01 00 00 00       	mov    $0x1,%eax
  80344a:	31 d2                	xor    %edx,%edx
  80344c:	f7 f7                	div    %edi
  80344e:	89 c5                	mov    %eax,%ebp
  803450:	31 d2                	xor    %edx,%edx
  803452:	89 c8                	mov    %ecx,%eax
  803454:	f7 f5                	div    %ebp
  803456:	89 c1                	mov    %eax,%ecx
  803458:	89 d8                	mov    %ebx,%eax
  80345a:	f7 f5                	div    %ebp
  80345c:	89 cf                	mov    %ecx,%edi
  80345e:	89 fa                	mov    %edi,%edx
  803460:	83 c4 1c             	add    $0x1c,%esp
  803463:	5b                   	pop    %ebx
  803464:	5e                   	pop    %esi
  803465:	5f                   	pop    %edi
  803466:	5d                   	pop    %ebp
  803467:	c3                   	ret    
  803468:	39 ce                	cmp    %ecx,%esi
  80346a:	77 28                	ja     803494 <__udivdi3+0x7c>
  80346c:	0f bd fe             	bsr    %esi,%edi
  80346f:	83 f7 1f             	xor    $0x1f,%edi
  803472:	75 40                	jne    8034b4 <__udivdi3+0x9c>
  803474:	39 ce                	cmp    %ecx,%esi
  803476:	72 0a                	jb     803482 <__udivdi3+0x6a>
  803478:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80347c:	0f 87 9e 00 00 00    	ja     803520 <__udivdi3+0x108>
  803482:	b8 01 00 00 00       	mov    $0x1,%eax
  803487:	89 fa                	mov    %edi,%edx
  803489:	83 c4 1c             	add    $0x1c,%esp
  80348c:	5b                   	pop    %ebx
  80348d:	5e                   	pop    %esi
  80348e:	5f                   	pop    %edi
  80348f:	5d                   	pop    %ebp
  803490:	c3                   	ret    
  803491:	8d 76 00             	lea    0x0(%esi),%esi
  803494:	31 ff                	xor    %edi,%edi
  803496:	31 c0                	xor    %eax,%eax
  803498:	89 fa                	mov    %edi,%edx
  80349a:	83 c4 1c             	add    $0x1c,%esp
  80349d:	5b                   	pop    %ebx
  80349e:	5e                   	pop    %esi
  80349f:	5f                   	pop    %edi
  8034a0:	5d                   	pop    %ebp
  8034a1:	c3                   	ret    
  8034a2:	66 90                	xchg   %ax,%ax
  8034a4:	89 d8                	mov    %ebx,%eax
  8034a6:	f7 f7                	div    %edi
  8034a8:	31 ff                	xor    %edi,%edi
  8034aa:	89 fa                	mov    %edi,%edx
  8034ac:	83 c4 1c             	add    $0x1c,%esp
  8034af:	5b                   	pop    %ebx
  8034b0:	5e                   	pop    %esi
  8034b1:	5f                   	pop    %edi
  8034b2:	5d                   	pop    %ebp
  8034b3:	c3                   	ret    
  8034b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034b9:	89 eb                	mov    %ebp,%ebx
  8034bb:	29 fb                	sub    %edi,%ebx
  8034bd:	89 f9                	mov    %edi,%ecx
  8034bf:	d3 e6                	shl    %cl,%esi
  8034c1:	89 c5                	mov    %eax,%ebp
  8034c3:	88 d9                	mov    %bl,%cl
  8034c5:	d3 ed                	shr    %cl,%ebp
  8034c7:	89 e9                	mov    %ebp,%ecx
  8034c9:	09 f1                	or     %esi,%ecx
  8034cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034cf:	89 f9                	mov    %edi,%ecx
  8034d1:	d3 e0                	shl    %cl,%eax
  8034d3:	89 c5                	mov    %eax,%ebp
  8034d5:	89 d6                	mov    %edx,%esi
  8034d7:	88 d9                	mov    %bl,%cl
  8034d9:	d3 ee                	shr    %cl,%esi
  8034db:	89 f9                	mov    %edi,%ecx
  8034dd:	d3 e2                	shl    %cl,%edx
  8034df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e3:	88 d9                	mov    %bl,%cl
  8034e5:	d3 e8                	shr    %cl,%eax
  8034e7:	09 c2                	or     %eax,%edx
  8034e9:	89 d0                	mov    %edx,%eax
  8034eb:	89 f2                	mov    %esi,%edx
  8034ed:	f7 74 24 0c          	divl   0xc(%esp)
  8034f1:	89 d6                	mov    %edx,%esi
  8034f3:	89 c3                	mov    %eax,%ebx
  8034f5:	f7 e5                	mul    %ebp
  8034f7:	39 d6                	cmp    %edx,%esi
  8034f9:	72 19                	jb     803514 <__udivdi3+0xfc>
  8034fb:	74 0b                	je     803508 <__udivdi3+0xf0>
  8034fd:	89 d8                	mov    %ebx,%eax
  8034ff:	31 ff                	xor    %edi,%edi
  803501:	e9 58 ff ff ff       	jmp    80345e <__udivdi3+0x46>
  803506:	66 90                	xchg   %ax,%ax
  803508:	8b 54 24 08          	mov    0x8(%esp),%edx
  80350c:	89 f9                	mov    %edi,%ecx
  80350e:	d3 e2                	shl    %cl,%edx
  803510:	39 c2                	cmp    %eax,%edx
  803512:	73 e9                	jae    8034fd <__udivdi3+0xe5>
  803514:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803517:	31 ff                	xor    %edi,%edi
  803519:	e9 40 ff ff ff       	jmp    80345e <__udivdi3+0x46>
  80351e:	66 90                	xchg   %ax,%ax
  803520:	31 c0                	xor    %eax,%eax
  803522:	e9 37 ff ff ff       	jmp    80345e <__udivdi3+0x46>
  803527:	90                   	nop

00803528 <__umoddi3>:
  803528:	55                   	push   %ebp
  803529:	57                   	push   %edi
  80352a:	56                   	push   %esi
  80352b:	53                   	push   %ebx
  80352c:	83 ec 1c             	sub    $0x1c,%esp
  80352f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803533:	8b 74 24 34          	mov    0x34(%esp),%esi
  803537:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80353b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80353f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803543:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803547:	89 f3                	mov    %esi,%ebx
  803549:	89 fa                	mov    %edi,%edx
  80354b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80354f:	89 34 24             	mov    %esi,(%esp)
  803552:	85 c0                	test   %eax,%eax
  803554:	75 1a                	jne    803570 <__umoddi3+0x48>
  803556:	39 f7                	cmp    %esi,%edi
  803558:	0f 86 a2 00 00 00    	jbe    803600 <__umoddi3+0xd8>
  80355e:	89 c8                	mov    %ecx,%eax
  803560:	89 f2                	mov    %esi,%edx
  803562:	f7 f7                	div    %edi
  803564:	89 d0                	mov    %edx,%eax
  803566:	31 d2                	xor    %edx,%edx
  803568:	83 c4 1c             	add    $0x1c,%esp
  80356b:	5b                   	pop    %ebx
  80356c:	5e                   	pop    %esi
  80356d:	5f                   	pop    %edi
  80356e:	5d                   	pop    %ebp
  80356f:	c3                   	ret    
  803570:	39 f0                	cmp    %esi,%eax
  803572:	0f 87 ac 00 00 00    	ja     803624 <__umoddi3+0xfc>
  803578:	0f bd e8             	bsr    %eax,%ebp
  80357b:	83 f5 1f             	xor    $0x1f,%ebp
  80357e:	0f 84 ac 00 00 00    	je     803630 <__umoddi3+0x108>
  803584:	bf 20 00 00 00       	mov    $0x20,%edi
  803589:	29 ef                	sub    %ebp,%edi
  80358b:	89 fe                	mov    %edi,%esi
  80358d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803591:	89 e9                	mov    %ebp,%ecx
  803593:	d3 e0                	shl    %cl,%eax
  803595:	89 d7                	mov    %edx,%edi
  803597:	89 f1                	mov    %esi,%ecx
  803599:	d3 ef                	shr    %cl,%edi
  80359b:	09 c7                	or     %eax,%edi
  80359d:	89 e9                	mov    %ebp,%ecx
  80359f:	d3 e2                	shl    %cl,%edx
  8035a1:	89 14 24             	mov    %edx,(%esp)
  8035a4:	89 d8                	mov    %ebx,%eax
  8035a6:	d3 e0                	shl    %cl,%eax
  8035a8:	89 c2                	mov    %eax,%edx
  8035aa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ae:	d3 e0                	shl    %cl,%eax
  8035b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b8:	89 f1                	mov    %esi,%ecx
  8035ba:	d3 e8                	shr    %cl,%eax
  8035bc:	09 d0                	or     %edx,%eax
  8035be:	d3 eb                	shr    %cl,%ebx
  8035c0:	89 da                	mov    %ebx,%edx
  8035c2:	f7 f7                	div    %edi
  8035c4:	89 d3                	mov    %edx,%ebx
  8035c6:	f7 24 24             	mull   (%esp)
  8035c9:	89 c6                	mov    %eax,%esi
  8035cb:	89 d1                	mov    %edx,%ecx
  8035cd:	39 d3                	cmp    %edx,%ebx
  8035cf:	0f 82 87 00 00 00    	jb     80365c <__umoddi3+0x134>
  8035d5:	0f 84 91 00 00 00    	je     80366c <__umoddi3+0x144>
  8035db:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035df:	29 f2                	sub    %esi,%edx
  8035e1:	19 cb                	sbb    %ecx,%ebx
  8035e3:	89 d8                	mov    %ebx,%eax
  8035e5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035e9:	d3 e0                	shl    %cl,%eax
  8035eb:	89 e9                	mov    %ebp,%ecx
  8035ed:	d3 ea                	shr    %cl,%edx
  8035ef:	09 d0                	or     %edx,%eax
  8035f1:	89 e9                	mov    %ebp,%ecx
  8035f3:	d3 eb                	shr    %cl,%ebx
  8035f5:	89 da                	mov    %ebx,%edx
  8035f7:	83 c4 1c             	add    $0x1c,%esp
  8035fa:	5b                   	pop    %ebx
  8035fb:	5e                   	pop    %esi
  8035fc:	5f                   	pop    %edi
  8035fd:	5d                   	pop    %ebp
  8035fe:	c3                   	ret    
  8035ff:	90                   	nop
  803600:	89 fd                	mov    %edi,%ebp
  803602:	85 ff                	test   %edi,%edi
  803604:	75 0b                	jne    803611 <__umoddi3+0xe9>
  803606:	b8 01 00 00 00       	mov    $0x1,%eax
  80360b:	31 d2                	xor    %edx,%edx
  80360d:	f7 f7                	div    %edi
  80360f:	89 c5                	mov    %eax,%ebp
  803611:	89 f0                	mov    %esi,%eax
  803613:	31 d2                	xor    %edx,%edx
  803615:	f7 f5                	div    %ebp
  803617:	89 c8                	mov    %ecx,%eax
  803619:	f7 f5                	div    %ebp
  80361b:	89 d0                	mov    %edx,%eax
  80361d:	e9 44 ff ff ff       	jmp    803566 <__umoddi3+0x3e>
  803622:	66 90                	xchg   %ax,%ax
  803624:	89 c8                	mov    %ecx,%eax
  803626:	89 f2                	mov    %esi,%edx
  803628:	83 c4 1c             	add    $0x1c,%esp
  80362b:	5b                   	pop    %ebx
  80362c:	5e                   	pop    %esi
  80362d:	5f                   	pop    %edi
  80362e:	5d                   	pop    %ebp
  80362f:	c3                   	ret    
  803630:	3b 04 24             	cmp    (%esp),%eax
  803633:	72 06                	jb     80363b <__umoddi3+0x113>
  803635:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803639:	77 0f                	ja     80364a <__umoddi3+0x122>
  80363b:	89 f2                	mov    %esi,%edx
  80363d:	29 f9                	sub    %edi,%ecx
  80363f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803643:	89 14 24             	mov    %edx,(%esp)
  803646:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80364a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80364e:	8b 14 24             	mov    (%esp),%edx
  803651:	83 c4 1c             	add    $0x1c,%esp
  803654:	5b                   	pop    %ebx
  803655:	5e                   	pop    %esi
  803656:	5f                   	pop    %edi
  803657:	5d                   	pop    %ebp
  803658:	c3                   	ret    
  803659:	8d 76 00             	lea    0x0(%esi),%esi
  80365c:	2b 04 24             	sub    (%esp),%eax
  80365f:	19 fa                	sbb    %edi,%edx
  803661:	89 d1                	mov    %edx,%ecx
  803663:	89 c6                	mov    %eax,%esi
  803665:	e9 71 ff ff ff       	jmp    8035db <__umoddi3+0xb3>
  80366a:	66 90                	xchg   %ax,%ax
  80366c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803670:	72 ea                	jb     80365c <__umoddi3+0x134>
  803672:	89 d9                	mov    %ebx,%ecx
  803674:	e9 62 ff ff ff       	jmp    8035db <__umoddi3+0xb3>
