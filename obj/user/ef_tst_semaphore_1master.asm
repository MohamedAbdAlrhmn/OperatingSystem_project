
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
  80003e:	e8 ff 1a 00 00       	call   801b42 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 c0 36 80 00       	push   $0x8036c0
  800050:	e8 87 19 00 00       	call   8019dc <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 c4 36 80 00       	push   $0x8036c4
  800062:	e8 75 19 00 00       	call   8019dc <sys_createSemaphore>
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
  800083:	68 cc 36 80 00       	push   $0x8036cc
  800088:	e8 60 1a 00 00       	call   801aed <sys_create_env>
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
  8000ac:	68 cc 36 80 00       	push   $0x8036cc
  8000b1:	e8 37 1a 00 00       	call   801aed <sys_create_env>
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
  8000d5:	68 cc 36 80 00       	push   $0x8036cc
  8000da:	e8 0e 1a 00 00       	call   801aed <sys_create_env>
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
  8000fa:	68 d9 36 80 00       	push   $0x8036d9
  8000ff:	6a 13                	push   $0x13
  800101:	68 f0 36 80 00       	push   $0x8036f0
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 f5 19 00 00       	call   801b0b <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 e7 19 00 00       	call   801b0b <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 d9 19 00 00       	call   801b0b <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 c4 36 80 00       	push   $0x8036c4
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 d0 18 00 00       	call   801a15 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 c4 36 80 00       	push   $0x8036c4
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 bd 18 00 00       	call   801a15 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 c4 36 80 00       	push   $0x8036c4
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 aa 18 00 00       	call   801a15 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 c0 36 80 00       	push   $0x8036c0
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 7a 18 00 00       	call   8019f8 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 c4 36 80 00       	push   $0x8036c4
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 64 18 00 00       	call   8019f8 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 10 37 80 00       	push   $0x803710
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 58 37 80 00       	push   $0x803758
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 a7 19 00 00       	call   801b74 <sys_getparentenvid>
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
  8001e0:	68 a3 37 80 00       	push   $0x8037a3
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 ea 14 00 00       	call   8016d7 <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 29 19 00 00       	call   801b27 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 1b 19 00 00       	call   801b27 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 0d 19 00 00       	call   801b27 <sys_destroy_env>
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
  800234:	e8 22 19 00 00       	call   801b5b <sys_getenvindex>
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
  80029f:	e8 c4 16 00 00       	call   801968 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 cc 37 80 00       	push   $0x8037cc
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
  8002cf:	68 f4 37 80 00       	push   $0x8037f4
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
  800300:	68 1c 38 80 00       	push   $0x80381c
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 50 80 00       	mov    0x805020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 74 38 80 00       	push   $0x803874
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 cc 37 80 00       	push   $0x8037cc
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 44 16 00 00       	call   801982 <sys_enable_interrupt>

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
  800351:	e8 d1 17 00 00       	call   801b27 <sys_destroy_env>
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
  800362:	e8 26 18 00 00       	call   801b8d <sys_exit_env>
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
  80038b:	68 88 38 80 00       	push   $0x803888
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 50 80 00       	mov    0x805000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 8d 38 80 00       	push   $0x80388d
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
  8003c8:	68 a9 38 80 00       	push   $0x8038a9
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
  8003f4:	68 ac 38 80 00       	push   $0x8038ac
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 f8 38 80 00       	push   $0x8038f8
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
  8004c6:	68 04 39 80 00       	push   $0x803904
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 f8 38 80 00       	push   $0x8038f8
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
  800536:	68 58 39 80 00       	push   $0x803958
  80053b:	6a 44                	push   $0x44
  80053d:	68 f8 38 80 00       	push   $0x8038f8
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
  800590:	e8 25 12 00 00       	call   8017ba <sys_cputs>
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
  800607:	e8 ae 11 00 00       	call   8017ba <sys_cputs>
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
  800651:	e8 12 13 00 00       	call   801968 <sys_disable_interrupt>
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
  800671:	e8 0c 13 00 00       	call   801982 <sys_enable_interrupt>
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
  8006bb:	e8 80 2d 00 00       	call   803440 <__udivdi3>
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
  80070b:	e8 40 2e 00 00       	call   803550 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 d4 3b 80 00       	add    $0x803bd4,%eax
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
  800866:	8b 04 85 f8 3b 80 00 	mov    0x803bf8(,%eax,4),%eax
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
  800947:	8b 34 9d 40 3a 80 00 	mov    0x803a40(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 e5 3b 80 00       	push   $0x803be5
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
  80096c:	68 ee 3b 80 00       	push   $0x803bee
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
  800999:	be f1 3b 80 00       	mov    $0x803bf1,%esi
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
  8013bf:	68 50 3d 80 00       	push   $0x803d50
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
  80148f:	e8 6a 04 00 00       	call   8018fe <sys_allocate_chunk>
  801494:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801497:	a1 20 51 80 00       	mov    0x805120,%eax
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	50                   	push   %eax
  8014a0:	e8 df 0a 00 00       	call   801f84 <initialize_MemBlocksList>
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
  8014cd:	68 75 3d 80 00       	push   $0x803d75
  8014d2:	6a 33                	push   $0x33
  8014d4:	68 93 3d 80 00       	push   $0x803d93
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
  80154c:	68 a0 3d 80 00       	push   $0x803da0
  801551:	6a 34                	push   $0x34
  801553:	68 93 3d 80 00       	push   $0x803d93
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
  8015e4:	e8 e3 06 00 00       	call   801ccc <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	74 11                	je     8015fe <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f3:	e8 4e 0d 00 00       	call   802346 <alloc_block_FF>
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
  80160a:	e8 aa 0a 00 00       	call   8020b9 <insert_sorted_allocList>
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
  801624:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	panic("free() is not implemented yet...!!");
  801627:	83 ec 04             	sub    $0x4,%esp
  80162a:	68 c4 3d 80 00       	push   $0x803dc4
  80162f:	6a 6f                	push   $0x6f
  801631:	68 93 3d 80 00       	push   $0x803d93
  801636:	e8 2f ed ff ff       	call   80036a <_panic>

0080163b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	83 ec 38             	sub    $0x38,%esp
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801647:	e8 5c fd ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  80164c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801650:	75 07                	jne    801659 <smalloc+0x1e>
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
  801657:	eb 7c                	jmp    8016d5 <smalloc+0x9a>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  801659:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801660:	8b 55 0c             	mov    0xc(%ebp),%edx
  801663:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	48                   	dec    %eax
  801669:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80166c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166f:	ba 00 00 00 00       	mov    $0x0,%edx
  801674:	f7 75 f0             	divl   -0x10(%ebp)
  801677:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167a:	29 d0                	sub    %edx,%eax
  80167c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  80167f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)

	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801686:	e8 41 06 00 00       	call   801ccc <sys_isUHeapPlacementStrategyFIRSTFIT>
  80168b:	85 c0                	test   %eax,%eax
  80168d:	74 11                	je     8016a0 <smalloc+0x65>
		mem_block = alloc_block_FF(allocate_space);
  80168f:	83 ec 0c             	sub    $0xc,%esp
  801692:	ff 75 e8             	pushl  -0x18(%ebp)
  801695:	e8 ac 0c 00 00       	call   802346 <alloc_block_FF>
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(mem_block != NULL)
  8016a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a4:	74 2a                	je     8016d0 <smalloc+0x95>
	{
		virtual_address = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	8b 40 08             	mov    0x8(%eax),%eax
  8016ac:	89 c2                	mov    %eax,%edx
  8016ae:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016b2:	52                   	push   %edx
  8016b3:	50                   	push   %eax
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	ff 75 08             	pushl  0x8(%ebp)
  8016ba:	e8 92 03 00 00       	call   801a51 <sys_createSharedObject>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (virtual_address != -1)
  8016c5:	83 7d e4 ff          	cmpl   $0xffffffff,-0x1c(%ebp)
  8016c9:	74 05                	je     8016d0 <smalloc+0x95>
			return (void*)virtual_address;
  8016cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ce:	eb 05                	jmp    8016d5 <smalloc+0x9a>
	}
	return NULL;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016dd:	e8 c6 fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	panic("sget() is not implemented yet...!!");
  8016e2:	83 ec 04             	sub    $0x4,%esp
  8016e5:	68 e8 3d 80 00       	push   $0x803de8
  8016ea:	68 b0 00 00 00       	push   $0xb0
  8016ef:	68 93 3d 80 00       	push   $0x803d93
  8016f4:	e8 71 ec ff ff       	call   80036a <_panic>

008016f9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ff:	e8 a4 fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801704:	83 ec 04             	sub    $0x4,%esp
  801707:	68 0c 3e 80 00       	push   $0x803e0c
  80170c:	68 f4 00 00 00       	push   $0xf4
  801711:	68 93 3d 80 00       	push   $0x803d93
  801716:	e8 4f ec ff ff       	call   80036a <_panic>

0080171b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801721:	83 ec 04             	sub    $0x4,%esp
  801724:	68 34 3e 80 00       	push   $0x803e34
  801729:	68 08 01 00 00       	push   $0x108
  80172e:	68 93 3d 80 00       	push   $0x803d93
  801733:	e8 32 ec ff ff       	call   80036a <_panic>

00801738 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	68 58 3e 80 00       	push   $0x803e58
  801746:	68 13 01 00 00       	push   $0x113
  80174b:	68 93 3d 80 00       	push   $0x803d93
  801750:	e8 15 ec ff ff       	call   80036a <_panic>

00801755 <shrink>:

}
void shrink(uint32 newSize)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	68 58 3e 80 00       	push   $0x803e58
  801763:	68 18 01 00 00       	push   $0x118
  801768:	68 93 3d 80 00       	push   $0x803d93
  80176d:	e8 f8 eb ff ff       	call   80036a <_panic>

00801772 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	68 58 3e 80 00       	push   $0x803e58
  801780:	68 1d 01 00 00       	push   $0x11d
  801785:	68 93 3d 80 00       	push   $0x803d93
  80178a:	e8 db eb ff ff       	call   80036a <_panic>

0080178f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	57                   	push   %edi
  801793:	56                   	push   %esi
  801794:	53                   	push   %ebx
  801795:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017a7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017aa:	cd 30                	int    $0x30
  8017ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017af:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	5b                   	pop    %ebx
  8017b6:	5e                   	pop    %esi
  8017b7:	5f                   	pop    %edi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    

008017ba <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017c6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	52                   	push   %edx
  8017d2:	ff 75 0c             	pushl  0xc(%ebp)
  8017d5:	50                   	push   %eax
  8017d6:	6a 00                	push   $0x0
  8017d8:	e8 b2 ff ff ff       	call   80178f <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	90                   	nop
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 01                	push   $0x1
  8017f2:	e8 98 ff ff ff       	call   80178f <syscall>
  8017f7:	83 c4 18             	add    $0x18,%esp
}
  8017fa:	c9                   	leave  
  8017fb:	c3                   	ret    

008017fc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	6a 00                	push   $0x0
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	52                   	push   %edx
  80180c:	50                   	push   %eax
  80180d:	6a 05                	push   $0x5
  80180f:	e8 7b ff ff ff       	call   80178f <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	56                   	push   %esi
  80181d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80181e:	8b 75 18             	mov    0x18(%ebp),%esi
  801821:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801824:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	56                   	push   %esi
  80182e:	53                   	push   %ebx
  80182f:	51                   	push   %ecx
  801830:	52                   	push   %edx
  801831:	50                   	push   %eax
  801832:	6a 06                	push   $0x6
  801834:	e8 56 ff ff ff       	call   80178f <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183f:	5b                   	pop    %ebx
  801840:	5e                   	pop    %esi
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801846:	8b 55 0c             	mov    0xc(%ebp),%edx
  801849:	8b 45 08             	mov    0x8(%ebp),%eax
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	52                   	push   %edx
  801853:	50                   	push   %eax
  801854:	6a 07                	push   $0x7
  801856:	e8 34 ff ff ff       	call   80178f <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	6a 00                	push   $0x0
  801869:	ff 75 0c             	pushl  0xc(%ebp)
  80186c:	ff 75 08             	pushl  0x8(%ebp)
  80186f:	6a 08                	push   $0x8
  801871:	e8 19 ff ff ff       	call   80178f <syscall>
  801876:	83 c4 18             	add    $0x18,%esp
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 09                	push   $0x9
  80188a:	e8 00 ff ff ff       	call   80178f <syscall>
  80188f:	83 c4 18             	add    $0x18,%esp
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 0a                	push   $0xa
  8018a3:	e8 e7 fe ff ff       	call   80178f <syscall>
  8018a8:	83 c4 18             	add    $0x18,%esp
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 0b                	push   $0xb
  8018bc:	e8 ce fe ff ff       	call   80178f <syscall>
  8018c1:	83 c4 18             	add    $0x18,%esp
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	ff 75 0c             	pushl  0xc(%ebp)
  8018d2:	ff 75 08             	pushl  0x8(%ebp)
  8018d5:	6a 0f                	push   $0xf
  8018d7:	e8 b3 fe ff ff       	call   80178f <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
	return;
  8018df:	90                   	nop
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	ff 75 08             	pushl  0x8(%ebp)
  8018f1:	6a 10                	push   $0x10
  8018f3:	e8 97 fe ff ff       	call   80178f <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8018fb:	90                   	nop
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	ff 75 10             	pushl  0x10(%ebp)
  801908:	ff 75 0c             	pushl  0xc(%ebp)
  80190b:	ff 75 08             	pushl  0x8(%ebp)
  80190e:	6a 11                	push   $0x11
  801910:	e8 7a fe ff ff       	call   80178f <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
	return ;
  801918:	90                   	nop
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 0c                	push   $0xc
  80192a:	e8 60 fe ff ff       	call   80178f <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	ff 75 08             	pushl  0x8(%ebp)
  801942:	6a 0d                	push   $0xd
  801944:	e8 46 fe ff ff       	call   80178f <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 0e                	push   $0xe
  80195d:	e8 2d fe ff ff       	call   80178f <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	90                   	nop
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 13                	push   $0x13
  801977:	e8 13 fe ff ff       	call   80178f <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	90                   	nop
  801980:	c9                   	leave  
  801981:	c3                   	ret    

00801982 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801982:	55                   	push   %ebp
  801983:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 14                	push   $0x14
  801991:	e8 f9 fd ff ff       	call   80178f <syscall>
  801996:	83 c4 18             	add    $0x18,%esp
}
  801999:	90                   	nop
  80199a:	c9                   	leave  
  80199b:	c3                   	ret    

0080199c <sys_cputc>:


void
sys_cputc(const char c)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	83 ec 04             	sub    $0x4,%esp
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019a8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	50                   	push   %eax
  8019b5:	6a 15                	push   $0x15
  8019b7:	e8 d3 fd ff ff       	call   80178f <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	90                   	nop
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 16                	push   $0x16
  8019d1:	e8 b9 fd ff ff       	call   80178f <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	90                   	nop
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	50                   	push   %eax
  8019ec:	6a 17                	push   $0x17
  8019ee:	e8 9c fd ff ff       	call   80178f <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	52                   	push   %edx
  801a08:	50                   	push   %eax
  801a09:	6a 1a                	push   $0x1a
  801a0b:	e8 7f fd ff ff       	call   80178f <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	52                   	push   %edx
  801a25:	50                   	push   %eax
  801a26:	6a 18                	push   $0x18
  801a28:	e8 62 fd ff ff       	call   80178f <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	90                   	nop
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	52                   	push   %edx
  801a43:	50                   	push   %eax
  801a44:	6a 19                	push   $0x19
  801a46:	e8 44 fd ff ff       	call   80178f <syscall>
  801a4b:	83 c4 18             	add    $0x18,%esp
}
  801a4e:	90                   	nop
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 04             	sub    $0x4,%esp
  801a57:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a5d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a60:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	51                   	push   %ecx
  801a6a:	52                   	push   %edx
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	50                   	push   %eax
  801a6f:	6a 1b                	push   $0x1b
  801a71:	e8 19 fd ff ff       	call   80178f <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	52                   	push   %edx
  801a8b:	50                   	push   %eax
  801a8c:	6a 1c                	push   $0x1c
  801a8e:	e8 fc fc ff ff       	call   80178f <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	51                   	push   %ecx
  801aa9:	52                   	push   %edx
  801aaa:	50                   	push   %eax
  801aab:	6a 1d                	push   $0x1d
  801aad:	e8 dd fc ff ff       	call   80178f <syscall>
  801ab2:	83 c4 18             	add    $0x18,%esp
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	52                   	push   %edx
  801ac7:	50                   	push   %eax
  801ac8:	6a 1e                	push   $0x1e
  801aca:	e8 c0 fc ff ff       	call   80178f <syscall>
  801acf:	83 c4 18             	add    $0x18,%esp
}
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 1f                	push   $0x1f
  801ae3:	e8 a7 fc ff ff       	call   80178f <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801af0:	8b 45 08             	mov    0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	ff 75 14             	pushl  0x14(%ebp)
  801af8:	ff 75 10             	pushl  0x10(%ebp)
  801afb:	ff 75 0c             	pushl  0xc(%ebp)
  801afe:	50                   	push   %eax
  801aff:	6a 20                	push   $0x20
  801b01:	e8 89 fc ff ff       	call   80178f <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	50                   	push   %eax
  801b1a:	6a 21                	push   $0x21
  801b1c:	e8 6e fc ff ff       	call   80178f <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	90                   	nop
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	50                   	push   %eax
  801b36:	6a 22                	push   $0x22
  801b38:	e8 52 fc ff ff       	call   80178f <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 02                	push   $0x2
  801b51:	e8 39 fc ff ff       	call   80178f <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 03                	push   $0x3
  801b6a:	e8 20 fc ff ff       	call   80178f <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 04                	push   $0x4
  801b83:	e8 07 fc ff ff       	call   80178f <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_exit_env>:


void sys_exit_env(void)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 23                	push   $0x23
  801b9c:	e8 ee fb ff ff       	call   80178f <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	90                   	nop
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bad:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bb0:	8d 50 04             	lea    0x4(%eax),%edx
  801bb3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	6a 24                	push   $0x24
  801bc0:	e8 ca fb ff ff       	call   80178f <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
	return result;
  801bc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bd1:	89 01                	mov    %eax,(%ecx)
  801bd3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	c9                   	leave  
  801bda:	c2 04 00             	ret    $0x4

00801bdd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	ff 75 10             	pushl  0x10(%ebp)
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	ff 75 08             	pushl  0x8(%ebp)
  801bed:	6a 12                	push   $0x12
  801bef:	e8 9b fb ff ff       	call   80178f <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf7:	90                   	nop
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_rcr2>:
uint32 sys_rcr2()
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 25                	push   $0x25
  801c09:	e8 81 fb ff ff       	call   80178f <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c1f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	50                   	push   %eax
  801c2c:	6a 26                	push   $0x26
  801c2e:	e8 5c fb ff ff       	call   80178f <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
	return ;
  801c36:	90                   	nop
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <rsttst>:
void rsttst()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 28                	push   $0x28
  801c48:	e8 42 fb ff ff       	call   80178f <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c50:	90                   	nop
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	8b 45 14             	mov    0x14(%ebp),%eax
  801c5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c5f:	8b 55 18             	mov    0x18(%ebp),%edx
  801c62:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c66:	52                   	push   %edx
  801c67:	50                   	push   %eax
  801c68:	ff 75 10             	pushl  0x10(%ebp)
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	ff 75 08             	pushl  0x8(%ebp)
  801c71:	6a 27                	push   $0x27
  801c73:	e8 17 fb ff ff       	call   80178f <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7b:	90                   	nop
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <chktst>:
void chktst(uint32 n)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	ff 75 08             	pushl  0x8(%ebp)
  801c8c:	6a 29                	push   $0x29
  801c8e:	e8 fc fa ff ff       	call   80178f <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <inctst>:

void inctst()
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 2a                	push   $0x2a
  801ca8:	e8 e2 fa ff ff       	call   80178f <syscall>
  801cad:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb0:	90                   	nop
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <gettst>:
uint32 gettst()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 2b                	push   $0x2b
  801cc2:	e8 c8 fa ff ff       	call   80178f <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	c9                   	leave  
  801ccb:	c3                   	ret    

00801ccc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 2c                	push   $0x2c
  801cde:	e8 ac fa ff ff       	call   80178f <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
  801ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ce9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ced:	75 07                	jne    801cf6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cef:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf4:	eb 05                	jmp    801cfb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 2c                	push   $0x2c
  801d0f:	e8 7b fa ff ff       	call   80178f <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
  801d17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d1a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d1e:	75 07                	jne    801d27 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d20:	b8 01 00 00 00       	mov    $0x1,%eax
  801d25:	eb 05                	jmp    801d2c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 2c                	push   $0x2c
  801d40:	e8 4a fa ff ff       	call   80178f <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
  801d48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d4b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d4f:	75 07                	jne    801d58 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d51:	b8 01 00 00 00       	mov    $0x1,%eax
  801d56:	eb 05                	jmp    801d5d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 2c                	push   $0x2c
  801d71:	e8 19 fa ff ff       	call   80178f <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
  801d79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d7c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d80:	75 07                	jne    801d89 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d82:	b8 01 00 00 00       	mov    $0x1,%eax
  801d87:	eb 05                	jmp    801d8e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	ff 75 08             	pushl  0x8(%ebp)
  801d9e:	6a 2d                	push   $0x2d
  801da0:	e8 ea f9 ff ff       	call   80178f <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return ;
  801da8:	90                   	nop
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801daf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbb:	6a 00                	push   $0x0
  801dbd:	53                   	push   %ebx
  801dbe:	51                   	push   %ecx
  801dbf:	52                   	push   %edx
  801dc0:	50                   	push   %eax
  801dc1:	6a 2e                	push   $0x2e
  801dc3:	e8 c7 f9 ff ff       	call   80178f <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dd3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	52                   	push   %edx
  801de0:	50                   	push   %eax
  801de1:	6a 2f                	push   $0x2f
  801de3:	e8 a7 f9 ff ff       	call   80178f <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801df3:	83 ec 0c             	sub    $0xc,%esp
  801df6:	68 68 3e 80 00       	push   $0x803e68
  801dfb:	e8 1e e8 ff ff       	call   80061e <cprintf>
  801e00:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e03:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e0a:	83 ec 0c             	sub    $0xc,%esp
  801e0d:	68 94 3e 80 00       	push   $0x803e94
  801e12:	e8 07 e8 ff ff       	call   80061e <cprintf>
  801e17:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e1a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e1e:	a1 38 51 80 00       	mov    0x805138,%eax
  801e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e26:	eb 56                	jmp    801e7e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2c:	74 1c                	je     801e4a <print_mem_block_lists+0x5d>
  801e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e31:	8b 50 08             	mov    0x8(%eax),%edx
  801e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e37:	8b 48 08             	mov    0x8(%eax),%ecx
  801e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e40:	01 c8                	add    %ecx,%eax
  801e42:	39 c2                	cmp    %eax,%edx
  801e44:	73 04                	jae    801e4a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e46:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4d:	8b 50 08             	mov    0x8(%eax),%edx
  801e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e53:	8b 40 0c             	mov    0xc(%eax),%eax
  801e56:	01 c2                	add    %eax,%edx
  801e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5b:	8b 40 08             	mov    0x8(%eax),%eax
  801e5e:	83 ec 04             	sub    $0x4,%esp
  801e61:	52                   	push   %edx
  801e62:	50                   	push   %eax
  801e63:	68 a9 3e 80 00       	push   $0x803ea9
  801e68:	e8 b1 e7 ff ff       	call   80061e <cprintf>
  801e6d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e76:	a1 40 51 80 00       	mov    0x805140,%eax
  801e7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e82:	74 07                	je     801e8b <print_mem_block_lists+0x9e>
  801e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e87:	8b 00                	mov    (%eax),%eax
  801e89:	eb 05                	jmp    801e90 <print_mem_block_lists+0xa3>
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e90:	a3 40 51 80 00       	mov    %eax,0x805140
  801e95:	a1 40 51 80 00       	mov    0x805140,%eax
  801e9a:	85 c0                	test   %eax,%eax
  801e9c:	75 8a                	jne    801e28 <print_mem_block_lists+0x3b>
  801e9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea2:	75 84                	jne    801e28 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ea4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ea8:	75 10                	jne    801eba <print_mem_block_lists+0xcd>
  801eaa:	83 ec 0c             	sub    $0xc,%esp
  801ead:	68 b8 3e 80 00       	push   $0x803eb8
  801eb2:	e8 67 e7 ff ff       	call   80061e <cprintf>
  801eb7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	68 dc 3e 80 00       	push   $0x803edc
  801ec9:	e8 50 e7 ff ff       	call   80061e <cprintf>
  801ece:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ed1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ed5:	a1 40 50 80 00       	mov    0x805040,%eax
  801eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edd:	eb 56                	jmp    801f35 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801edf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee3:	74 1c                	je     801f01 <print_mem_block_lists+0x114>
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	8b 50 08             	mov    0x8(%eax),%edx
  801eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eee:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef7:	01 c8                	add    %ecx,%eax
  801ef9:	39 c2                	cmp    %eax,%edx
  801efb:	73 04                	jae    801f01 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801efd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	8b 50 08             	mov    0x8(%eax),%edx
  801f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0d:	01 c2                	add    %eax,%edx
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 40 08             	mov    0x8(%eax),%eax
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	52                   	push   %edx
  801f19:	50                   	push   %eax
  801f1a:	68 a9 3e 80 00       	push   $0x803ea9
  801f1f:	e8 fa e6 ff ff       	call   80061e <cprintf>
  801f24:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f2d:	a1 48 50 80 00       	mov    0x805048,%eax
  801f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f39:	74 07                	je     801f42 <print_mem_block_lists+0x155>
  801f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3e:	8b 00                	mov    (%eax),%eax
  801f40:	eb 05                	jmp    801f47 <print_mem_block_lists+0x15a>
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
  801f47:	a3 48 50 80 00       	mov    %eax,0x805048
  801f4c:	a1 48 50 80 00       	mov    0x805048,%eax
  801f51:	85 c0                	test   %eax,%eax
  801f53:	75 8a                	jne    801edf <print_mem_block_lists+0xf2>
  801f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f59:	75 84                	jne    801edf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f5b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f5f:	75 10                	jne    801f71 <print_mem_block_lists+0x184>
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	68 f4 3e 80 00       	push   $0x803ef4
  801f69:	e8 b0 e6 ff ff       	call   80061e <cprintf>
  801f6e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f71:	83 ec 0c             	sub    $0xc,%esp
  801f74:	68 68 3e 80 00       	push   $0x803e68
  801f79:	e8 a0 e6 ff ff       	call   80061e <cprintf>
  801f7e:	83 c4 10             	add    $0x10,%esp

}
  801f81:	90                   	nop
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  801f8a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  801f91:	00 00 00 
  801f94:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  801f9b:	00 00 00 
  801f9e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  801fa5:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  801fa8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801faf:	e9 9e 00 00 00       	jmp    802052 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  801fb4:	a1 50 50 80 00       	mov    0x805050,%eax
  801fb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbc:	c1 e2 04             	shl    $0x4,%edx
  801fbf:	01 d0                	add    %edx,%eax
  801fc1:	85 c0                	test   %eax,%eax
  801fc3:	75 14                	jne    801fd9 <initialize_MemBlocksList+0x55>
  801fc5:	83 ec 04             	sub    $0x4,%esp
  801fc8:	68 1c 3f 80 00       	push   $0x803f1c
  801fcd:	6a 46                	push   $0x46
  801fcf:	68 3f 3f 80 00       	push   $0x803f3f
  801fd4:	e8 91 e3 ff ff       	call   80036a <_panic>
  801fd9:	a1 50 50 80 00       	mov    0x805050,%eax
  801fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe1:	c1 e2 04             	shl    $0x4,%edx
  801fe4:	01 d0                	add    %edx,%eax
  801fe6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  801fec:	89 10                	mov    %edx,(%eax)
  801fee:	8b 00                	mov    (%eax),%eax
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	74 18                	je     80200c <initialize_MemBlocksList+0x88>
  801ff4:	a1 48 51 80 00       	mov    0x805148,%eax
  801ff9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  801fff:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802002:	c1 e1 04             	shl    $0x4,%ecx
  802005:	01 ca                	add    %ecx,%edx
  802007:	89 50 04             	mov    %edx,0x4(%eax)
  80200a:	eb 12                	jmp    80201e <initialize_MemBlocksList+0x9a>
  80200c:	a1 50 50 80 00       	mov    0x805050,%eax
  802011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802014:	c1 e2 04             	shl    $0x4,%edx
  802017:	01 d0                	add    %edx,%eax
  802019:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80201e:	a1 50 50 80 00       	mov    0x805050,%eax
  802023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802026:	c1 e2 04             	shl    $0x4,%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	a3 48 51 80 00       	mov    %eax,0x805148
  802030:	a1 50 50 80 00       	mov    0x805050,%eax
  802035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802038:	c1 e2 04             	shl    $0x4,%edx
  80203b:	01 d0                	add    %edx,%eax
  80203d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802044:	a1 54 51 80 00       	mov    0x805154,%eax
  802049:	40                   	inc    %eax
  80204a:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  80204f:	ff 45 f4             	incl   -0xc(%ebp)
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	3b 45 08             	cmp    0x8(%ebp),%eax
  802058:	0f 82 56 ff ff ff    	jb     801fb4 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  80205e:	90                   	nop
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	8b 00                	mov    (%eax),%eax
  80206c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80206f:	eb 19                	jmp    80208a <find_block+0x29>
	{
		if(va==point->sva)
  802071:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802074:	8b 40 08             	mov    0x8(%eax),%eax
  802077:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80207a:	75 05                	jne    802081 <find_block+0x20>
		   return point;
  80207c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207f:	eb 36                	jmp    8020b7 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	8b 40 08             	mov    0x8(%eax),%eax
  802087:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80208a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80208e:	74 07                	je     802097 <find_block+0x36>
  802090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802093:	8b 00                	mov    (%eax),%eax
  802095:	eb 05                	jmp    80209c <find_block+0x3b>
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
  80209c:	8b 55 08             	mov    0x8(%ebp),%edx
  80209f:	89 42 08             	mov    %eax,0x8(%edx)
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8b 40 08             	mov    0x8(%eax),%eax
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	75 c5                	jne    802071 <find_block+0x10>
  8020ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020b0:	75 bf                	jne    802071 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  8020bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8020c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  8020c7:	a1 44 50 80 00       	mov    0x805044,%eax
  8020cc:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  8020cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8020d5:	74 24                	je     8020fb <insert_sorted_allocList+0x42>
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	8b 50 08             	mov    0x8(%eax),%edx
  8020dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e0:	8b 40 08             	mov    0x8(%eax),%eax
  8020e3:	39 c2                	cmp    %eax,%edx
  8020e5:	76 14                	jbe    8020fb <insert_sorted_allocList+0x42>
  8020e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ea:	8b 50 08             	mov    0x8(%eax),%edx
  8020ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f0:	8b 40 08             	mov    0x8(%eax),%eax
  8020f3:	39 c2                	cmp    %eax,%edx
  8020f5:	0f 82 60 01 00 00    	jb     80225b <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  8020fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020ff:	75 65                	jne    802166 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802101:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802105:	75 14                	jne    80211b <insert_sorted_allocList+0x62>
  802107:	83 ec 04             	sub    $0x4,%esp
  80210a:	68 1c 3f 80 00       	push   $0x803f1c
  80210f:	6a 6b                	push   $0x6b
  802111:	68 3f 3f 80 00       	push   $0x803f3f
  802116:	e8 4f e2 ff ff       	call   80036a <_panic>
  80211b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	89 10                	mov    %edx,(%eax)
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	8b 00                	mov    (%eax),%eax
  80212b:	85 c0                	test   %eax,%eax
  80212d:	74 0d                	je     80213c <insert_sorted_allocList+0x83>
  80212f:	a1 40 50 80 00       	mov    0x805040,%eax
  802134:	8b 55 08             	mov    0x8(%ebp),%edx
  802137:	89 50 04             	mov    %edx,0x4(%eax)
  80213a:	eb 08                	jmp    802144 <insert_sorted_allocList+0x8b>
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	a3 44 50 80 00       	mov    %eax,0x805044
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 40 50 80 00       	mov    %eax,0x805040
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802156:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80215b:	40                   	inc    %eax
  80215c:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802161:	e9 dc 01 00 00       	jmp    802342 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	8b 50 08             	mov    0x8(%eax),%edx
  80216c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216f:	8b 40 08             	mov    0x8(%eax),%eax
  802172:	39 c2                	cmp    %eax,%edx
  802174:	77 6c                	ja     8021e2 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802176:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80217a:	74 06                	je     802182 <insert_sorted_allocList+0xc9>
  80217c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802180:	75 14                	jne    802196 <insert_sorted_allocList+0xdd>
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	68 58 3f 80 00       	push   $0x803f58
  80218a:	6a 6f                	push   $0x6f
  80218c:	68 3f 3f 80 00       	push   $0x803f3f
  802191:	e8 d4 e1 ff ff       	call   80036a <_panic>
  802196:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802199:	8b 50 04             	mov    0x4(%eax),%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	89 50 04             	mov    %edx,0x4(%eax)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021a8:	89 10                	mov    %edx,(%eax)
  8021aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ad:	8b 40 04             	mov    0x4(%eax),%eax
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	74 0d                	je     8021c1 <insert_sorted_allocList+0x108>
  8021b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b7:	8b 40 04             	mov    0x4(%eax),%eax
  8021ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8021bd:	89 10                	mov    %edx,(%eax)
  8021bf:	eb 08                	jmp    8021c9 <insert_sorted_allocList+0x110>
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	a3 40 50 80 00       	mov    %eax,0x805040
  8021c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021cf:	89 50 04             	mov    %edx,0x4(%eax)
  8021d2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021d7:	40                   	inc    %eax
  8021d8:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021dd:	e9 60 01 00 00       	jmp    802342 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	8b 50 08             	mov    0x8(%eax),%edx
  8021e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021eb:	8b 40 08             	mov    0x8(%eax),%eax
  8021ee:	39 c2                	cmp    %eax,%edx
  8021f0:	0f 82 4c 01 00 00    	jb     802342 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  8021f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fa:	75 14                	jne    802210 <insert_sorted_allocList+0x157>
  8021fc:	83 ec 04             	sub    $0x4,%esp
  8021ff:	68 90 3f 80 00       	push   $0x803f90
  802204:	6a 73                	push   $0x73
  802206:	68 3f 3f 80 00       	push   $0x803f3f
  80220b:	e8 5a e1 ff ff       	call   80036a <_panic>
  802210:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	89 50 04             	mov    %edx,0x4(%eax)
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	8b 40 04             	mov    0x4(%eax),%eax
  802222:	85 c0                	test   %eax,%eax
  802224:	74 0c                	je     802232 <insert_sorted_allocList+0x179>
  802226:	a1 44 50 80 00       	mov    0x805044,%eax
  80222b:	8b 55 08             	mov    0x8(%ebp),%edx
  80222e:	89 10                	mov    %edx,(%eax)
  802230:	eb 08                	jmp    80223a <insert_sorted_allocList+0x181>
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 40 50 80 00       	mov    %eax,0x805040
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	a3 44 50 80 00       	mov    %eax,0x805044
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80224b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802250:	40                   	inc    %eax
  802251:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802256:	e9 e7 00 00 00       	jmp    802342 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  802261:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  802268:	a1 40 50 80 00       	mov    0x805040,%eax
  80226d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802270:	e9 9d 00 00 00       	jmp    802312 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 00                	mov    (%eax),%eax
  80227a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8b 50 08             	mov    0x8(%eax),%edx
  802283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802286:	8b 40 08             	mov    0x8(%eax),%eax
  802289:	39 c2                	cmp    %eax,%edx
  80228b:	76 7d                	jbe    80230a <insert_sorted_allocList+0x251>
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	8b 50 08             	mov    0x8(%eax),%edx
  802293:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802296:	8b 40 08             	mov    0x8(%eax),%eax
  802299:	39 c2                	cmp    %eax,%edx
  80229b:	73 6d                	jae    80230a <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80229d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a1:	74 06                	je     8022a9 <insert_sorted_allocList+0x1f0>
  8022a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a7:	75 14                	jne    8022bd <insert_sorted_allocList+0x204>
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	68 b4 3f 80 00       	push   $0x803fb4
  8022b1:	6a 7f                	push   $0x7f
  8022b3:	68 3f 3f 80 00       	push   $0x803f3f
  8022b8:	e8 ad e0 ff ff       	call   80036a <_panic>
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 10                	mov    (%eax),%edx
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	89 10                	mov    %edx,(%eax)
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	8b 00                	mov    (%eax),%eax
  8022cc:	85 c0                	test   %eax,%eax
  8022ce:	74 0b                	je     8022db <insert_sorted_allocList+0x222>
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 00                	mov    (%eax),%eax
  8022d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d8:	89 50 04             	mov    %edx,0x4(%eax)
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e1:	89 10                	mov    %edx,(%eax)
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e9:	89 50 04             	mov    %edx,0x4(%eax)
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	8b 00                	mov    (%eax),%eax
  8022f1:	85 c0                	test   %eax,%eax
  8022f3:	75 08                	jne    8022fd <insert_sorted_allocList+0x244>
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	a3 44 50 80 00       	mov    %eax,0x805044
  8022fd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802302:	40                   	inc    %eax
  802303:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  802308:	eb 39                	jmp    802343 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80230a:	a1 48 50 80 00       	mov    0x805048,%eax
  80230f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802312:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802316:	74 07                	je     80231f <insert_sorted_allocList+0x266>
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 00                	mov    (%eax),%eax
  80231d:	eb 05                	jmp    802324 <insert_sorted_allocList+0x26b>
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
  802324:	a3 48 50 80 00       	mov    %eax,0x805048
  802329:	a1 48 50 80 00       	mov    0x805048,%eax
  80232e:	85 c0                	test   %eax,%eax
  802330:	0f 85 3f ff ff ff    	jne    802275 <insert_sorted_allocList+0x1bc>
  802336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233a:	0f 85 35 ff ff ff    	jne    802275 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802340:	eb 01                	jmp    802343 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  802342:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  802343:	90                   	nop
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
  802349:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  80234c:	a1 38 51 80 00       	mov    0x805138,%eax
  802351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802354:	e9 85 01 00 00       	jmp    8024de <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 40 0c             	mov    0xc(%eax),%eax
  80235f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802362:	0f 82 6e 01 00 00    	jb     8024d6 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 40 0c             	mov    0xc(%eax),%eax
  80236e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802371:	0f 85 8a 00 00 00    	jne    802401 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237b:	75 17                	jne    802394 <alloc_block_FF+0x4e>
  80237d:	83 ec 04             	sub    $0x4,%esp
  802380:	68 e8 3f 80 00       	push   $0x803fe8
  802385:	68 93 00 00 00       	push   $0x93
  80238a:	68 3f 3f 80 00       	push   $0x803f3f
  80238f:	e8 d6 df ff ff       	call   80036a <_panic>
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	8b 00                	mov    (%eax),%eax
  802399:	85 c0                	test   %eax,%eax
  80239b:	74 10                	je     8023ad <alloc_block_FF+0x67>
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a5:	8b 52 04             	mov    0x4(%edx),%edx
  8023a8:	89 50 04             	mov    %edx,0x4(%eax)
  8023ab:	eb 0b                	jmp    8023b8 <alloc_block_FF+0x72>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 40 04             	mov    0x4(%eax),%eax
  8023b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 40 04             	mov    0x4(%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	74 0f                	je     8023d1 <alloc_block_FF+0x8b>
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 40 04             	mov    0x4(%eax),%eax
  8023c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023cb:	8b 12                	mov    (%edx),%edx
  8023cd:	89 10                	mov    %edx,(%eax)
  8023cf:	eb 0a                	jmp    8023db <alloc_block_FF+0x95>
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	8b 00                	mov    (%eax),%eax
  8023d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8023f3:	48                   	dec    %eax
  8023f4:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	e9 10 01 00 00       	jmp    802511 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 40 0c             	mov    0xc(%eax),%eax
  802407:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240a:	0f 86 c6 00 00 00    	jbe    8024d6 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802410:	a1 48 51 80 00       	mov    0x805148,%eax
  802415:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 50 08             	mov    0x8(%eax),%edx
  80241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802421:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  802424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802427:	8b 55 08             	mov    0x8(%ebp),%edx
  80242a:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  80242d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802431:	75 17                	jne    80244a <alloc_block_FF+0x104>
  802433:	83 ec 04             	sub    $0x4,%esp
  802436:	68 e8 3f 80 00       	push   $0x803fe8
  80243b:	68 9b 00 00 00       	push   $0x9b
  802440:	68 3f 3f 80 00       	push   $0x803f3f
  802445:	e8 20 df ff ff       	call   80036a <_panic>
  80244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244d:	8b 00                	mov    (%eax),%eax
  80244f:	85 c0                	test   %eax,%eax
  802451:	74 10                	je     802463 <alloc_block_FF+0x11d>
  802453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245b:	8b 52 04             	mov    0x4(%edx),%edx
  80245e:	89 50 04             	mov    %edx,0x4(%eax)
  802461:	eb 0b                	jmp    80246e <alloc_block_FF+0x128>
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	8b 40 04             	mov    0x4(%eax),%eax
  802469:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80246e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802471:	8b 40 04             	mov    0x4(%eax),%eax
  802474:	85 c0                	test   %eax,%eax
  802476:	74 0f                	je     802487 <alloc_block_FF+0x141>
  802478:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247b:	8b 40 04             	mov    0x4(%eax),%eax
  80247e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802481:	8b 12                	mov    (%edx),%edx
  802483:	89 10                	mov    %edx,(%eax)
  802485:	eb 0a                	jmp    802491 <alloc_block_FF+0x14b>
  802487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248a:	8b 00                	mov    (%eax),%eax
  80248c:	a3 48 51 80 00       	mov    %eax,0x805148
  802491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802494:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8024a9:	48                   	dec    %eax
  8024aa:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 50 08             	mov    0x8(%eax),%edx
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	01 c2                	add    %eax,%edx
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8024c9:	89 c2                	mov    %eax,%edx
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  8024d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d4:	eb 3b                	jmp    802511 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8024d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8024db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e2:	74 07                	je     8024eb <alloc_block_FF+0x1a5>
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e7:	8b 00                	mov    (%eax),%eax
  8024e9:	eb 05                	jmp    8024f0 <alloc_block_FF+0x1aa>
  8024eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f0:	a3 40 51 80 00       	mov    %eax,0x805140
  8024f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	0f 85 57 fe ff ff    	jne    802359 <alloc_block_FF+0x13>
  802502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802506:	0f 85 4d fe ff ff    	jne    802359 <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  802519:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802520:	a1 38 51 80 00       	mov    0x805138,%eax
  802525:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802528:	e9 df 00 00 00       	jmp    80260c <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 0c             	mov    0xc(%eax),%eax
  802533:	3b 45 08             	cmp    0x8(%ebp),%eax
  802536:	0f 82 c8 00 00 00    	jb     802604 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 0c             	mov    0xc(%eax),%eax
  802542:	3b 45 08             	cmp    0x8(%ebp),%eax
  802545:	0f 85 8a 00 00 00    	jne    8025d5 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  80254b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254f:	75 17                	jne    802568 <alloc_block_BF+0x55>
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	68 e8 3f 80 00       	push   $0x803fe8
  802559:	68 b7 00 00 00       	push   $0xb7
  80255e:	68 3f 3f 80 00       	push   $0x803f3f
  802563:	e8 02 de ff ff       	call   80036a <_panic>
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 00                	mov    (%eax),%eax
  80256d:	85 c0                	test   %eax,%eax
  80256f:	74 10                	je     802581 <alloc_block_BF+0x6e>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802579:	8b 52 04             	mov    0x4(%edx),%edx
  80257c:	89 50 04             	mov    %edx,0x4(%eax)
  80257f:	eb 0b                	jmp    80258c <alloc_block_BF+0x79>
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 40 04             	mov    0x4(%eax),%eax
  802587:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 04             	mov    0x4(%eax),%eax
  802592:	85 c0                	test   %eax,%eax
  802594:	74 0f                	je     8025a5 <alloc_block_BF+0x92>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 40 04             	mov    0x4(%eax),%eax
  80259c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259f:	8b 12                	mov    (%edx),%edx
  8025a1:	89 10                	mov    %edx,(%eax)
  8025a3:	eb 0a                	jmp    8025af <alloc_block_BF+0x9c>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 00                	mov    (%eax),%eax
  8025aa:	a3 38 51 80 00       	mov    %eax,0x805138
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8025c7:	48                   	dec    %eax
  8025c8:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	e9 4d 01 00 00       	jmp    802722 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025de:	76 24                	jbe    802604 <alloc_block_BF+0xf1>
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025e9:	73 19                	jae    802604 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  8025eb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 08             	mov    0x8(%eax),%eax
  802601:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802604:	a1 40 51 80 00       	mov    0x805140,%eax
  802609:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	74 07                	je     802619 <alloc_block_BF+0x106>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	eb 05                	jmp    80261e <alloc_block_BF+0x10b>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	a3 40 51 80 00       	mov    %eax,0x805140
  802623:	a1 40 51 80 00       	mov    0x805140,%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	0f 85 fd fe ff ff    	jne    80252d <alloc_block_BF+0x1a>
  802630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802634:	0f 85 f3 fe ff ff    	jne    80252d <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  80263a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80263e:	0f 84 d9 00 00 00    	je     80271d <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  802644:	a1 48 51 80 00       	mov    0x805148,%eax
  802649:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  80264c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80264f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802652:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  802655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802658:	8b 55 08             	mov    0x8(%ebp),%edx
  80265b:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  80265e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802662:	75 17                	jne    80267b <alloc_block_BF+0x168>
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 e8 3f 80 00       	push   $0x803fe8
  80266c:	68 c7 00 00 00       	push   $0xc7
  802671:	68 3f 3f 80 00       	push   $0x803f3f
  802676:	e8 ef dc ff ff       	call   80036a <_panic>
  80267b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	74 10                	je     802694 <alloc_block_BF+0x181>
  802684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80268c:	8b 52 04             	mov    0x4(%edx),%edx
  80268f:	89 50 04             	mov    %edx,0x4(%eax)
  802692:	eb 0b                	jmp    80269f <alloc_block_BF+0x18c>
  802694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802697:	8b 40 04             	mov    0x4(%eax),%eax
  80269a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80269f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 0f                	je     8026b8 <alloc_block_BF+0x1a5>
  8026a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ac:	8b 40 04             	mov    0x4(%eax),%eax
  8026af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026b2:	8b 12                	mov    (%edx),%edx
  8026b4:	89 10                	mov    %edx,(%eax)
  8026b6:	eb 0a                	jmp    8026c2 <alloc_block_BF+0x1af>
  8026b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bb:	8b 00                	mov    (%eax),%eax
  8026bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8026c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d5:	a1 54 51 80 00       	mov    0x805154,%eax
  8026da:	48                   	dec    %eax
  8026db:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  8026e0:	83 ec 08             	sub    $0x8,%esp
  8026e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8026e6:	68 38 51 80 00       	push   $0x805138
  8026eb:	e8 71 f9 ff ff       	call   802061 <find_block>
  8026f0:	83 c4 10             	add    $0x10,%esp
  8026f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  8026f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f9:	8b 50 08             	mov    0x8(%eax),%edx
  8026fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ff:	01 c2                	add    %eax,%edx
  802701:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802704:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270a:	8b 40 0c             	mov    0xc(%eax),%eax
  80270d:	2b 45 08             	sub    0x8(%ebp),%eax
  802710:	89 c2                	mov    %eax,%edx
  802712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802715:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  802718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271b:	eb 05                	jmp    802722 <alloc_block_BF+0x20f>
	}
	return NULL;
  80271d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802722:	c9                   	leave  
  802723:	c3                   	ret    

00802724 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802724:	55                   	push   %ebp
  802725:	89 e5                	mov    %esp,%ebp
  802727:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  80272a:	a1 28 50 80 00       	mov    0x805028,%eax
  80272f:	85 c0                	test   %eax,%eax
  802731:	0f 85 de 01 00 00    	jne    802915 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  802737:	a1 38 51 80 00       	mov    0x805138,%eax
  80273c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273f:	e9 9e 01 00 00       	jmp    8028e2 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	8b 40 0c             	mov    0xc(%eax),%eax
  80274a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274d:	0f 82 87 01 00 00    	jb     8028da <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 0c             	mov    0xc(%eax),%eax
  802759:	3b 45 08             	cmp    0x8(%ebp),%eax
  80275c:	0f 85 95 00 00 00    	jne    8027f7 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  802762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802766:	75 17                	jne    80277f <alloc_block_NF+0x5b>
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 e8 3f 80 00       	push   $0x803fe8
  802770:	68 e0 00 00 00       	push   $0xe0
  802775:	68 3f 3f 80 00       	push   $0x803f3f
  80277a:	e8 eb db ff ff       	call   80036a <_panic>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 10                	je     802798 <alloc_block_NF+0x74>
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802790:	8b 52 04             	mov    0x4(%edx),%edx
  802793:	89 50 04             	mov    %edx,0x4(%eax)
  802796:	eb 0b                	jmp    8027a3 <alloc_block_NF+0x7f>
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 0f                	je     8027bc <alloc_block_NF+0x98>
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	8b 40 04             	mov    0x4(%eax),%eax
  8027b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b6:	8b 12                	mov    (%edx),%edx
  8027b8:	89 10                	mov    %edx,(%eax)
  8027ba:	eb 0a                	jmp    8027c6 <alloc_block_NF+0xa2>
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 00                	mov    (%eax),%eax
  8027c1:	a3 38 51 80 00       	mov    %eax,0x805138
  8027c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8027de:	48                   	dec    %eax
  8027df:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 40 08             	mov    0x8(%eax),%eax
  8027ea:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	e9 f8 04 00 00       	jmp    802cef <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802800:	0f 86 d4 00 00 00    	jbe    8028da <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802806:	a1 48 51 80 00       	mov    0x805148,%eax
  80280b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 50 08             	mov    0x8(%eax),%edx
  802814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802817:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  80281a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281d:	8b 55 08             	mov    0x8(%ebp),%edx
  802820:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802823:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802827:	75 17                	jne    802840 <alloc_block_NF+0x11c>
  802829:	83 ec 04             	sub    $0x4,%esp
  80282c:	68 e8 3f 80 00       	push   $0x803fe8
  802831:	68 e9 00 00 00       	push   $0xe9
  802836:	68 3f 3f 80 00       	push   $0x803f3f
  80283b:	e8 2a db ff ff       	call   80036a <_panic>
  802840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802843:	8b 00                	mov    (%eax),%eax
  802845:	85 c0                	test   %eax,%eax
  802847:	74 10                	je     802859 <alloc_block_NF+0x135>
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802851:	8b 52 04             	mov    0x4(%edx),%edx
  802854:	89 50 04             	mov    %edx,0x4(%eax)
  802857:	eb 0b                	jmp    802864 <alloc_block_NF+0x140>
  802859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285c:	8b 40 04             	mov    0x4(%eax),%eax
  80285f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802867:	8b 40 04             	mov    0x4(%eax),%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	74 0f                	je     80287d <alloc_block_NF+0x159>
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	8b 40 04             	mov    0x4(%eax),%eax
  802874:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802877:	8b 12                	mov    (%edx),%edx
  802879:	89 10                	mov    %edx,(%eax)
  80287b:	eb 0a                	jmp    802887 <alloc_block_NF+0x163>
  80287d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	a3 48 51 80 00       	mov    %eax,0x805148
  802887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802893:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289a:	a1 54 51 80 00       	mov    0x805154,%eax
  80289f:	48                   	dec    %eax
  8028a0:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 40 08             	mov    0x8(%eax),%eax
  8028ab:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 50 08             	mov    0x8(%eax),%edx
  8028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b9:	01 c2                	add    %eax,%edx
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c7:	2b 45 08             	sub    0x8(%ebp),%eax
  8028ca:	89 c2                	mov    %eax,%edx
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	e9 15 04 00 00       	jmp    802cef <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8028da:	a1 40 51 80 00       	mov    0x805140,%eax
  8028df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e6:	74 07                	je     8028ef <alloc_block_NF+0x1cb>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	eb 05                	jmp    8028f4 <alloc_block_NF+0x1d0>
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	a3 40 51 80 00       	mov    %eax,0x805140
  8028f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8028fe:	85 c0                	test   %eax,%eax
  802900:	0f 85 3e fe ff ff    	jne    802744 <alloc_block_NF+0x20>
  802906:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290a:	0f 85 34 fe ff ff    	jne    802744 <alloc_block_NF+0x20>
  802910:	e9 d5 03 00 00       	jmp    802cea <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802915:	a1 38 51 80 00       	mov    0x805138,%eax
  80291a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291d:	e9 b1 01 00 00       	jmp    802ad3 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 50 08             	mov    0x8(%eax),%edx
  802928:	a1 28 50 80 00       	mov    0x805028,%eax
  80292d:	39 c2                	cmp    %eax,%edx
  80292f:	0f 82 96 01 00 00    	jb     802acb <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 0c             	mov    0xc(%eax),%eax
  80293b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80293e:	0f 82 87 01 00 00    	jb     802acb <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  802944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802947:	8b 40 0c             	mov    0xc(%eax),%eax
  80294a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294d:	0f 85 95 00 00 00    	jne    8029e8 <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802953:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802957:	75 17                	jne    802970 <alloc_block_NF+0x24c>
  802959:	83 ec 04             	sub    $0x4,%esp
  80295c:	68 e8 3f 80 00       	push   $0x803fe8
  802961:	68 fc 00 00 00       	push   $0xfc
  802966:	68 3f 3f 80 00       	push   $0x803f3f
  80296b:	e8 fa d9 ff ff       	call   80036a <_panic>
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	85 c0                	test   %eax,%eax
  802977:	74 10                	je     802989 <alloc_block_NF+0x265>
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	8b 00                	mov    (%eax),%eax
  80297e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802981:	8b 52 04             	mov    0x4(%edx),%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 0b                	jmp    802994 <alloc_block_NF+0x270>
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 40 04             	mov    0x4(%eax),%eax
  80298f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 04             	mov    0x4(%eax),%eax
  80299a:	85 c0                	test   %eax,%eax
  80299c:	74 0f                	je     8029ad <alloc_block_NF+0x289>
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	8b 40 04             	mov    0x4(%eax),%eax
  8029a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a7:	8b 12                	mov    (%edx),%edx
  8029a9:	89 10                	mov    %edx,(%eax)
  8029ab:	eb 0a                	jmp    8029b7 <alloc_block_NF+0x293>
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8029b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ca:	a1 44 51 80 00       	mov    0x805144,%eax
  8029cf:	48                   	dec    %eax
  8029d0:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 40 08             	mov    0x8(%eax),%eax
  8029db:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	e9 07 03 00 00       	jmp    802cef <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029f1:	0f 86 d4 00 00 00    	jbe    802acb <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8029f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8029fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 50 08             	mov    0x8(%eax),%edx
  802a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a08:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a11:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802a14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a18:	75 17                	jne    802a31 <alloc_block_NF+0x30d>
  802a1a:	83 ec 04             	sub    $0x4,%esp
  802a1d:	68 e8 3f 80 00       	push   $0x803fe8
  802a22:	68 04 01 00 00       	push   $0x104
  802a27:	68 3f 3f 80 00       	push   $0x803f3f
  802a2c:	e8 39 d9 ff ff       	call   80036a <_panic>
  802a31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a34:	8b 00                	mov    (%eax),%eax
  802a36:	85 c0                	test   %eax,%eax
  802a38:	74 10                	je     802a4a <alloc_block_NF+0x326>
  802a3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a3d:	8b 00                	mov    (%eax),%eax
  802a3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a42:	8b 52 04             	mov    0x4(%edx),%edx
  802a45:	89 50 04             	mov    %edx,0x4(%eax)
  802a48:	eb 0b                	jmp    802a55 <alloc_block_NF+0x331>
  802a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4d:	8b 40 04             	mov    0x4(%eax),%eax
  802a50:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a58:	8b 40 04             	mov    0x4(%eax),%eax
  802a5b:	85 c0                	test   %eax,%eax
  802a5d:	74 0f                	je     802a6e <alloc_block_NF+0x34a>
  802a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a62:	8b 40 04             	mov    0x4(%eax),%eax
  802a65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a68:	8b 12                	mov    (%edx),%edx
  802a6a:	89 10                	mov    %edx,(%eax)
  802a6c:	eb 0a                	jmp    802a78 <alloc_block_NF+0x354>
  802a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	a3 48 51 80 00       	mov    %eax,0x805148
  802a78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a7b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8b:	a1 54 51 80 00       	mov    0x805154,%eax
  802a90:	48                   	dec    %eax
  802a91:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a99:	8b 40 08             	mov    0x8(%eax),%eax
  802a9c:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 50 08             	mov    0x8(%eax),%edx
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	01 c2                	add    %eax,%edx
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab8:	2b 45 08             	sub    0x8(%ebp),%eax
  802abb:	89 c2                	mov    %eax,%edx
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac6:	e9 24 02 00 00       	jmp    802cef <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802acb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad7:	74 07                	je     802ae0 <alloc_block_NF+0x3bc>
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	eb 05                	jmp    802ae5 <alloc_block_NF+0x3c1>
  802ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae5:	a3 40 51 80 00       	mov    %eax,0x805140
  802aea:	a1 40 51 80 00       	mov    0x805140,%eax
  802aef:	85 c0                	test   %eax,%eax
  802af1:	0f 85 2b fe ff ff    	jne    802922 <alloc_block_NF+0x1fe>
  802af7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afb:	0f 85 21 fe ff ff    	jne    802922 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b01:	a1 38 51 80 00       	mov    0x805138,%eax
  802b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b09:	e9 ae 01 00 00       	jmp    802cbc <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 50 08             	mov    0x8(%eax),%edx
  802b14:	a1 28 50 80 00       	mov    0x805028,%eax
  802b19:	39 c2                	cmp    %eax,%edx
  802b1b:	0f 83 93 01 00 00    	jae    802cb4 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 40 0c             	mov    0xc(%eax),%eax
  802b27:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2a:	0f 82 84 01 00 00    	jb     802cb4 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 0c             	mov    0xc(%eax),%eax
  802b36:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b39:	0f 85 95 00 00 00    	jne    802bd4 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802b3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b43:	75 17                	jne    802b5c <alloc_block_NF+0x438>
  802b45:	83 ec 04             	sub    $0x4,%esp
  802b48:	68 e8 3f 80 00       	push   $0x803fe8
  802b4d:	68 14 01 00 00       	push   $0x114
  802b52:	68 3f 3f 80 00       	push   $0x803f3f
  802b57:	e8 0e d8 ff ff       	call   80036a <_panic>
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	8b 00                	mov    (%eax),%eax
  802b61:	85 c0                	test   %eax,%eax
  802b63:	74 10                	je     802b75 <alloc_block_NF+0x451>
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b6d:	8b 52 04             	mov    0x4(%edx),%edx
  802b70:	89 50 04             	mov    %edx,0x4(%eax)
  802b73:	eb 0b                	jmp    802b80 <alloc_block_NF+0x45c>
  802b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b78:	8b 40 04             	mov    0x4(%eax),%eax
  802b7b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b83:	8b 40 04             	mov    0x4(%eax),%eax
  802b86:	85 c0                	test   %eax,%eax
  802b88:	74 0f                	je     802b99 <alloc_block_NF+0x475>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 40 04             	mov    0x4(%eax),%eax
  802b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b93:	8b 12                	mov    (%edx),%edx
  802b95:	89 10                	mov    %edx,(%eax)
  802b97:	eb 0a                	jmp    802ba3 <alloc_block_NF+0x47f>
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 00                	mov    (%eax),%eax
  802b9e:	a3 38 51 80 00       	mov    %eax,0x805138
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb6:	a1 44 51 80 00       	mov    0x805144,%eax
  802bbb:	48                   	dec    %eax
  802bbc:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 40 08             	mov    0x8(%eax),%eax
  802bc7:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	e9 1b 01 00 00       	jmp    802cef <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bda:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bdd:	0f 86 d1 00 00 00    	jbe    802cb4 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802be3:	a1 48 51 80 00       	mov    0x805148,%eax
  802be8:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bee:	8b 50 08             	mov    0x8(%eax),%edx
  802bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf4:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfa:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfd:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c04:	75 17                	jne    802c1d <alloc_block_NF+0x4f9>
  802c06:	83 ec 04             	sub    $0x4,%esp
  802c09:	68 e8 3f 80 00       	push   $0x803fe8
  802c0e:	68 1c 01 00 00       	push   $0x11c
  802c13:	68 3f 3f 80 00       	push   $0x803f3f
  802c18:	e8 4d d7 ff ff       	call   80036a <_panic>
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 10                	je     802c36 <alloc_block_NF+0x512>
  802c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c2e:	8b 52 04             	mov    0x4(%edx),%edx
  802c31:	89 50 04             	mov    %edx,0x4(%eax)
  802c34:	eb 0b                	jmp    802c41 <alloc_block_NF+0x51d>
  802c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c39:	8b 40 04             	mov    0x4(%eax),%eax
  802c3c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 0f                	je     802c5a <alloc_block_NF+0x536>
  802c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4e:	8b 40 04             	mov    0x4(%eax),%eax
  802c51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c54:	8b 12                	mov    (%edx),%edx
  802c56:	89 10                	mov    %edx,(%eax)
  802c58:	eb 0a                	jmp    802c64 <alloc_block_NF+0x540>
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c77:	a1 54 51 80 00       	mov    0x805154,%eax
  802c7c:	48                   	dec    %eax
  802c7d:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c85:	8b 40 08             	mov    0x8(%eax),%eax
  802c88:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 50 08             	mov    0x8(%eax),%edx
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	01 c2                	add    %eax,%edx
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ca7:	89 c2                	mov    %eax,%edx
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	eb 3b                	jmp    802cef <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802cb4:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc0:	74 07                	je     802cc9 <alloc_block_NF+0x5a5>
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	eb 05                	jmp    802cce <alloc_block_NF+0x5aa>
  802cc9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cce:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd3:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd8:	85 c0                	test   %eax,%eax
  802cda:	0f 85 2e fe ff ff    	jne    802b0e <alloc_block_NF+0x3ea>
  802ce0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce4:	0f 85 24 fe ff ff    	jne    802b0e <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802cea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cef:	c9                   	leave  
  802cf0:	c3                   	ret    

00802cf1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cf1:	55                   	push   %ebp
  802cf2:	89 e5                	mov    %esp,%ebp
  802cf4:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802cf7:	a1 38 51 80 00       	mov    0x805138,%eax
  802cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802cff:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d04:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d07:	a1 38 51 80 00       	mov    0x805138,%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	74 14                	je     802d24 <insert_sorted_with_merge_freeList+0x33>
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	8b 50 08             	mov    0x8(%eax),%edx
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	8b 40 08             	mov    0x8(%eax),%eax
  802d1c:	39 c2                	cmp    %eax,%edx
  802d1e:	0f 87 9b 01 00 00    	ja     802ebf <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802d24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d28:	75 17                	jne    802d41 <insert_sorted_with_merge_freeList+0x50>
  802d2a:	83 ec 04             	sub    $0x4,%esp
  802d2d:	68 1c 3f 80 00       	push   $0x803f1c
  802d32:	68 38 01 00 00       	push   $0x138
  802d37:	68 3f 3f 80 00       	push   $0x803f3f
  802d3c:	e8 29 d6 ff ff       	call   80036a <_panic>
  802d41:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	89 10                	mov    %edx,(%eax)
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8b 00                	mov    (%eax),%eax
  802d51:	85 c0                	test   %eax,%eax
  802d53:	74 0d                	je     802d62 <insert_sorted_with_merge_freeList+0x71>
  802d55:	a1 38 51 80 00       	mov    0x805138,%eax
  802d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5d:	89 50 04             	mov    %edx,0x4(%eax)
  802d60:	eb 08                	jmp    802d6a <insert_sorted_with_merge_freeList+0x79>
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	a3 38 51 80 00       	mov    %eax,0x805138
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7c:	a1 44 51 80 00       	mov    0x805144,%eax
  802d81:	40                   	inc    %eax
  802d82:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d8b:	0f 84 a8 06 00 00    	je     803439 <insert_sorted_with_merge_freeList+0x748>
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 50 08             	mov    0x8(%eax),%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9d:	01 c2                	add    %eax,%edx
  802d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da2:	8b 40 08             	mov    0x8(%eax),%eax
  802da5:	39 c2                	cmp    %eax,%edx
  802da7:	0f 85 8c 06 00 00    	jne    803439 <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 50 0c             	mov    0xc(%eax),%edx
  802db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db6:	8b 40 0c             	mov    0xc(%eax),%eax
  802db9:	01 c2                	add    %eax,%edx
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802dc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802dc5:	75 17                	jne    802dde <insert_sorted_with_merge_freeList+0xed>
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 e8 3f 80 00       	push   $0x803fe8
  802dcf:	68 3c 01 00 00       	push   $0x13c
  802dd4:	68 3f 3f 80 00       	push   $0x803f3f
  802dd9:	e8 8c d5 ff ff       	call   80036a <_panic>
  802dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 10                	je     802df7 <insert_sorted_with_merge_freeList+0x106>
  802de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dea:	8b 00                	mov    (%eax),%eax
  802dec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802def:	8b 52 04             	mov    0x4(%edx),%edx
  802df2:	89 50 04             	mov    %edx,0x4(%eax)
  802df5:	eb 0b                	jmp    802e02 <insert_sorted_with_merge_freeList+0x111>
  802df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	85 c0                	test   %eax,%eax
  802e0a:	74 0f                	je     802e1b <insert_sorted_with_merge_freeList+0x12a>
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	8b 40 04             	mov    0x4(%eax),%eax
  802e12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e15:	8b 12                	mov    (%edx),%edx
  802e17:	89 10                	mov    %edx,(%eax)
  802e19:	eb 0a                	jmp    802e25 <insert_sorted_with_merge_freeList+0x134>
  802e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1e:	8b 00                	mov    (%eax),%eax
  802e20:	a3 38 51 80 00       	mov    %eax,0x805138
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e38:	a1 44 51 80 00       	mov    0x805144,%eax
  802e3d:	48                   	dec    %eax
  802e3e:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802e57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e5b:	75 17                	jne    802e74 <insert_sorted_with_merge_freeList+0x183>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 1c 3f 80 00       	push   $0x803f1c
  802e65:	68 3f 01 00 00       	push   $0x13f
  802e6a:	68 3f 3f 80 00       	push   $0x803f3f
  802e6f:	e8 f6 d4 ff ff       	call   80036a <_panic>
  802e74:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	85 c0                	test   %eax,%eax
  802e86:	74 0d                	je     802e95 <insert_sorted_with_merge_freeList+0x1a4>
  802e88:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	eb 08                	jmp    802e9d <insert_sorted_with_merge_freeList+0x1ac>
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eaf:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb4:	40                   	inc    %eax
  802eb5:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802eba:	e9 7a 05 00 00       	jmp    803439 <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 50 08             	mov    0x8(%eax),%edx
  802ec5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec8:	8b 40 08             	mov    0x8(%eax),%eax
  802ecb:	39 c2                	cmp    %eax,%edx
  802ecd:	0f 82 14 01 00 00    	jb     802fe7 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802edc:	8b 40 0c             	mov    0xc(%eax),%eax
  802edf:	01 c2                	add    %eax,%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	8b 40 08             	mov    0x8(%eax),%eax
  802ee7:	39 c2                	cmp    %eax,%edx
  802ee9:	0f 85 90 00 00 00    	jne    802f7f <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  802efb:	01 c2                	add    %eax,%edx
  802efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f00:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802f17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f1b:	75 17                	jne    802f34 <insert_sorted_with_merge_freeList+0x243>
  802f1d:	83 ec 04             	sub    $0x4,%esp
  802f20:	68 1c 3f 80 00       	push   $0x803f1c
  802f25:	68 49 01 00 00       	push   $0x149
  802f2a:	68 3f 3f 80 00       	push   $0x803f3f
  802f2f:	e8 36 d4 ff ff       	call   80036a <_panic>
  802f34:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	89 10                	mov    %edx,(%eax)
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	85 c0                	test   %eax,%eax
  802f46:	74 0d                	je     802f55 <insert_sorted_with_merge_freeList+0x264>
  802f48:	a1 48 51 80 00       	mov    0x805148,%eax
  802f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f50:	89 50 04             	mov    %edx,0x4(%eax)
  802f53:	eb 08                	jmp    802f5d <insert_sorted_with_merge_freeList+0x26c>
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	a3 48 51 80 00       	mov    %eax,0x805148
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f6f:	a1 54 51 80 00       	mov    0x805154,%eax
  802f74:	40                   	inc    %eax
  802f75:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802f7a:	e9 bb 04 00 00       	jmp    80343a <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f83:	75 17                	jne    802f9c <insert_sorted_with_merge_freeList+0x2ab>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 90 3f 80 00       	push   $0x803f90
  802f8d:	68 4c 01 00 00       	push   $0x14c
  802f92:	68 3f 3f 80 00       	push   $0x803f3f
  802f97:	e8 ce d3 ff ff       	call   80036a <_panic>
  802f9c:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	89 50 04             	mov    %edx,0x4(%eax)
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0c                	je     802fbe <insert_sorted_with_merge_freeList+0x2cd>
  802fb2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fba:	89 10                	mov    %edx,(%eax)
  802fbc:	eb 08                	jmp    802fc6 <insert_sorted_with_merge_freeList+0x2d5>
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	a3 38 51 80 00       	mov    %eax,0x805138
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd7:	a1 44 51 80 00       	mov    0x805144,%eax
  802fdc:	40                   	inc    %eax
  802fdd:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  802fe2:	e9 53 04 00 00       	jmp    80343a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  802fe7:	a1 38 51 80 00       	mov    0x805138,%eax
  802fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fef:	e9 15 04 00 00       	jmp    803409 <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	8b 50 08             	mov    0x8(%eax),%edx
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 40 08             	mov    0x8(%eax),%eax
  803008:	39 c2                	cmp    %eax,%edx
  80300a:	0f 86 f1 03 00 00    	jbe    803401 <insert_sorted_with_merge_freeList+0x710>
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803019:	8b 40 08             	mov    0x8(%eax),%eax
  80301c:	39 c2                	cmp    %eax,%edx
  80301e:	0f 83 dd 03 00 00    	jae    803401 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 50 08             	mov    0x8(%eax),%edx
  80302a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302d:	8b 40 0c             	mov    0xc(%eax),%eax
  803030:	01 c2                	add    %eax,%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 40 08             	mov    0x8(%eax),%eax
  803038:	39 c2                	cmp    %eax,%edx
  80303a:	0f 85 b9 01 00 00    	jne    8031f9 <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	8b 50 08             	mov    0x8(%eax),%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	8b 40 0c             	mov    0xc(%eax),%eax
  80304c:	01 c2                	add    %eax,%edx
  80304e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803051:	8b 40 08             	mov    0x8(%eax),%eax
  803054:	39 c2                	cmp    %eax,%edx
  803056:	0f 85 0d 01 00 00    	jne    803169 <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 50 0c             	mov    0xc(%eax),%edx
  803062:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803065:	8b 40 0c             	mov    0xc(%eax),%eax
  803068:	01 c2                	add    %eax,%edx
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803070:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803074:	75 17                	jne    80308d <insert_sorted_with_merge_freeList+0x39c>
  803076:	83 ec 04             	sub    $0x4,%esp
  803079:	68 e8 3f 80 00       	push   $0x803fe8
  80307e:	68 5c 01 00 00       	push   $0x15c
  803083:	68 3f 3f 80 00       	push   $0x803f3f
  803088:	e8 dd d2 ff ff       	call   80036a <_panic>
  80308d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	74 10                	je     8030a6 <insert_sorted_with_merge_freeList+0x3b5>
  803096:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80309e:	8b 52 04             	mov    0x4(%edx),%edx
  8030a1:	89 50 04             	mov    %edx,0x4(%eax)
  8030a4:	eb 0b                	jmp    8030b1 <insert_sorted_with_merge_freeList+0x3c0>
  8030a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a9:	8b 40 04             	mov    0x4(%eax),%eax
  8030ac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b4:	8b 40 04             	mov    0x4(%eax),%eax
  8030b7:	85 c0                	test   %eax,%eax
  8030b9:	74 0f                	je     8030ca <insert_sorted_with_merge_freeList+0x3d9>
  8030bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030be:	8b 40 04             	mov    0x4(%eax),%eax
  8030c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c4:	8b 12                	mov    (%edx),%edx
  8030c6:	89 10                	mov    %edx,(%eax)
  8030c8:	eb 0a                	jmp    8030d4 <insert_sorted_with_merge_freeList+0x3e3>
  8030ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e7:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ec:	48                   	dec    %eax
  8030ed:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  8030f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  8030fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803106:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80310a:	75 17                	jne    803123 <insert_sorted_with_merge_freeList+0x432>
  80310c:	83 ec 04             	sub    $0x4,%esp
  80310f:	68 1c 3f 80 00       	push   $0x803f1c
  803114:	68 5f 01 00 00       	push   $0x15f
  803119:	68 3f 3f 80 00       	push   $0x803f3f
  80311e:	e8 47 d2 ff ff       	call   80036a <_panic>
  803123:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803129:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312c:	89 10                	mov    %edx,(%eax)
  80312e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803131:	8b 00                	mov    (%eax),%eax
  803133:	85 c0                	test   %eax,%eax
  803135:	74 0d                	je     803144 <insert_sorted_with_merge_freeList+0x453>
  803137:	a1 48 51 80 00       	mov    0x805148,%eax
  80313c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80313f:	89 50 04             	mov    %edx,0x4(%eax)
  803142:	eb 08                	jmp    80314c <insert_sorted_with_merge_freeList+0x45b>
  803144:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803147:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80314c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314f:	a3 48 51 80 00       	mov    %eax,0x805148
  803154:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803157:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315e:	a1 54 51 80 00       	mov    0x805154,%eax
  803163:	40                   	inc    %eax
  803164:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  803169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316c:	8b 50 0c             	mov    0xc(%eax),%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 40 0c             	mov    0xc(%eax),%eax
  803175:	01 c2                	add    %eax,%edx
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803191:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803195:	75 17                	jne    8031ae <insert_sorted_with_merge_freeList+0x4bd>
  803197:	83 ec 04             	sub    $0x4,%esp
  80319a:	68 1c 3f 80 00       	push   $0x803f1c
  80319f:	68 64 01 00 00       	push   $0x164
  8031a4:	68 3f 3f 80 00       	push   $0x803f3f
  8031a9:	e8 bc d1 ff ff       	call   80036a <_panic>
  8031ae:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	89 10                	mov    %edx,(%eax)
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	8b 00                	mov    (%eax),%eax
  8031be:	85 c0                	test   %eax,%eax
  8031c0:	74 0d                	je     8031cf <insert_sorted_with_merge_freeList+0x4de>
  8031c2:	a1 48 51 80 00       	mov    0x805148,%eax
  8031c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ca:	89 50 04             	mov    %edx,0x4(%eax)
  8031cd:	eb 08                	jmp    8031d7 <insert_sorted_with_merge_freeList+0x4e6>
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	a3 48 51 80 00       	mov    %eax,0x805148
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e9:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ee:	40                   	inc    %eax
  8031ef:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  8031f4:	e9 41 02 00 00       	jmp    80343a <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fc:	8b 50 08             	mov    0x8(%eax),%edx
  8031ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803202:	8b 40 0c             	mov    0xc(%eax),%eax
  803205:	01 c2                	add    %eax,%edx
  803207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80320a:	8b 40 08             	mov    0x8(%eax),%eax
  80320d:	39 c2                	cmp    %eax,%edx
  80320f:	0f 85 7c 01 00 00    	jne    803391 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  803215:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803219:	74 06                	je     803221 <insert_sorted_with_merge_freeList+0x530>
  80321b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321f:	75 17                	jne    803238 <insert_sorted_with_merge_freeList+0x547>
  803221:	83 ec 04             	sub    $0x4,%esp
  803224:	68 58 3f 80 00       	push   $0x803f58
  803229:	68 69 01 00 00       	push   $0x169
  80322e:	68 3f 3f 80 00       	push   $0x803f3f
  803233:	e8 32 d1 ff ff       	call   80036a <_panic>
  803238:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80323b:	8b 50 04             	mov    0x4(%eax),%edx
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80324a:	89 10                	mov    %edx,(%eax)
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	8b 40 04             	mov    0x4(%eax),%eax
  803252:	85 c0                	test   %eax,%eax
  803254:	74 0d                	je     803263 <insert_sorted_with_merge_freeList+0x572>
  803256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803259:	8b 40 04             	mov    0x4(%eax),%eax
  80325c:	8b 55 08             	mov    0x8(%ebp),%edx
  80325f:	89 10                	mov    %edx,(%eax)
  803261:	eb 08                	jmp    80326b <insert_sorted_with_merge_freeList+0x57a>
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	a3 38 51 80 00       	mov    %eax,0x805138
  80326b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326e:	8b 55 08             	mov    0x8(%ebp),%edx
  803271:	89 50 04             	mov    %edx,0x4(%eax)
  803274:	a1 44 51 80 00       	mov    0x805144,%eax
  803279:	40                   	inc    %eax
  80327a:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	8b 50 0c             	mov    0xc(%eax),%edx
  803285:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803288:	8b 40 0c             	mov    0xc(%eax),%eax
  80328b:	01 c2                	add    %eax,%edx
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803293:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803297:	75 17                	jne    8032b0 <insert_sorted_with_merge_freeList+0x5bf>
  803299:	83 ec 04             	sub    $0x4,%esp
  80329c:	68 e8 3f 80 00       	push   $0x803fe8
  8032a1:	68 6b 01 00 00       	push   $0x16b
  8032a6:	68 3f 3f 80 00       	push   $0x803f3f
  8032ab:	e8 ba d0 ff ff       	call   80036a <_panic>
  8032b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b3:	8b 00                	mov    (%eax),%eax
  8032b5:	85 c0                	test   %eax,%eax
  8032b7:	74 10                	je     8032c9 <insert_sorted_with_merge_freeList+0x5d8>
  8032b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032bc:	8b 00                	mov    (%eax),%eax
  8032be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c1:	8b 52 04             	mov    0x4(%edx),%edx
  8032c4:	89 50 04             	mov    %edx,0x4(%eax)
  8032c7:	eb 0b                	jmp    8032d4 <insert_sorted_with_merge_freeList+0x5e3>
  8032c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cc:	8b 40 04             	mov    0x4(%eax),%eax
  8032cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d7:	8b 40 04             	mov    0x4(%eax),%eax
  8032da:	85 c0                	test   %eax,%eax
  8032dc:	74 0f                	je     8032ed <insert_sorted_with_merge_freeList+0x5fc>
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	8b 40 04             	mov    0x4(%eax),%eax
  8032e4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032e7:	8b 12                	mov    (%edx),%edx
  8032e9:	89 10                	mov    %edx,(%eax)
  8032eb:	eb 0a                	jmp    8032f7 <insert_sorted_with_merge_freeList+0x606>
  8032ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803300:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803303:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80330a:	a1 44 51 80 00       	mov    0x805144,%eax
  80330f:	48                   	dec    %eax
  803310:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  803315:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803318:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  80331f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803322:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803329:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80332d:	75 17                	jne    803346 <insert_sorted_with_merge_freeList+0x655>
  80332f:	83 ec 04             	sub    $0x4,%esp
  803332:	68 1c 3f 80 00       	push   $0x803f1c
  803337:	68 6e 01 00 00       	push   $0x16e
  80333c:	68 3f 3f 80 00       	push   $0x803f3f
  803341:	e8 24 d0 ff ff       	call   80036a <_panic>
  803346:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80334c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334f:	89 10                	mov    %edx,(%eax)
  803351:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803354:	8b 00                	mov    (%eax),%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	74 0d                	je     803367 <insert_sorted_with_merge_freeList+0x676>
  80335a:	a1 48 51 80 00       	mov    0x805148,%eax
  80335f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803362:	89 50 04             	mov    %edx,0x4(%eax)
  803365:	eb 08                	jmp    80336f <insert_sorted_with_merge_freeList+0x67e>
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80336f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803372:	a3 48 51 80 00       	mov    %eax,0x805148
  803377:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803381:	a1 54 51 80 00       	mov    0x805154,%eax
  803386:	40                   	inc    %eax
  803387:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80338c:	e9 a9 00 00 00       	jmp    80343a <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803395:	74 06                	je     80339d <insert_sorted_with_merge_freeList+0x6ac>
  803397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339b:	75 17                	jne    8033b4 <insert_sorted_with_merge_freeList+0x6c3>
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	68 b4 3f 80 00       	push   $0x803fb4
  8033a5:	68 73 01 00 00       	push   $0x173
  8033aa:	68 3f 3f 80 00       	push   $0x803f3f
  8033af:	e8 b6 cf ff ff       	call   80036a <_panic>
  8033b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b7:	8b 10                	mov    (%eax),%edx
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	89 10                	mov    %edx,(%eax)
  8033be:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c1:	8b 00                	mov    (%eax),%eax
  8033c3:	85 c0                	test   %eax,%eax
  8033c5:	74 0b                	je     8033d2 <insert_sorted_with_merge_freeList+0x6e1>
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033cf:	89 50 04             	mov    %edx,0x4(%eax)
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d8:	89 10                	mov    %edx,(%eax)
  8033da:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e0:	89 50 04             	mov    %edx,0x4(%eax)
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	75 08                	jne    8033f4 <insert_sorted_with_merge_freeList+0x703>
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8033f9:	40                   	inc    %eax
  8033fa:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  8033ff:	eb 39                	jmp    80343a <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803401:	a1 40 51 80 00       	mov    0x805140,%eax
  803406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80340d:	74 07                	je     803416 <insert_sorted_with_merge_freeList+0x725>
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	8b 00                	mov    (%eax),%eax
  803414:	eb 05                	jmp    80341b <insert_sorted_with_merge_freeList+0x72a>
  803416:	b8 00 00 00 00       	mov    $0x0,%eax
  80341b:	a3 40 51 80 00       	mov    %eax,0x805140
  803420:	a1 40 51 80 00       	mov    0x805140,%eax
  803425:	85 c0                	test   %eax,%eax
  803427:	0f 85 c7 fb ff ff    	jne    802ff4 <insert_sorted_with_merge_freeList+0x303>
  80342d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803431:	0f 85 bd fb ff ff    	jne    802ff4 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803437:	eb 01                	jmp    80343a <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  803439:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80343a:	90                   	nop
  80343b:	c9                   	leave  
  80343c:	c3                   	ret    
  80343d:	66 90                	xchg   %ax,%ax
  80343f:	90                   	nop

00803440 <__udivdi3>:
  803440:	55                   	push   %ebp
  803441:	57                   	push   %edi
  803442:	56                   	push   %esi
  803443:	53                   	push   %ebx
  803444:	83 ec 1c             	sub    $0x1c,%esp
  803447:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80344b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80344f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803453:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803457:	89 ca                	mov    %ecx,%edx
  803459:	89 f8                	mov    %edi,%eax
  80345b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80345f:	85 f6                	test   %esi,%esi
  803461:	75 2d                	jne    803490 <__udivdi3+0x50>
  803463:	39 cf                	cmp    %ecx,%edi
  803465:	77 65                	ja     8034cc <__udivdi3+0x8c>
  803467:	89 fd                	mov    %edi,%ebp
  803469:	85 ff                	test   %edi,%edi
  80346b:	75 0b                	jne    803478 <__udivdi3+0x38>
  80346d:	b8 01 00 00 00       	mov    $0x1,%eax
  803472:	31 d2                	xor    %edx,%edx
  803474:	f7 f7                	div    %edi
  803476:	89 c5                	mov    %eax,%ebp
  803478:	31 d2                	xor    %edx,%edx
  80347a:	89 c8                	mov    %ecx,%eax
  80347c:	f7 f5                	div    %ebp
  80347e:	89 c1                	mov    %eax,%ecx
  803480:	89 d8                	mov    %ebx,%eax
  803482:	f7 f5                	div    %ebp
  803484:	89 cf                	mov    %ecx,%edi
  803486:	89 fa                	mov    %edi,%edx
  803488:	83 c4 1c             	add    $0x1c,%esp
  80348b:	5b                   	pop    %ebx
  80348c:	5e                   	pop    %esi
  80348d:	5f                   	pop    %edi
  80348e:	5d                   	pop    %ebp
  80348f:	c3                   	ret    
  803490:	39 ce                	cmp    %ecx,%esi
  803492:	77 28                	ja     8034bc <__udivdi3+0x7c>
  803494:	0f bd fe             	bsr    %esi,%edi
  803497:	83 f7 1f             	xor    $0x1f,%edi
  80349a:	75 40                	jne    8034dc <__udivdi3+0x9c>
  80349c:	39 ce                	cmp    %ecx,%esi
  80349e:	72 0a                	jb     8034aa <__udivdi3+0x6a>
  8034a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034a4:	0f 87 9e 00 00 00    	ja     803548 <__udivdi3+0x108>
  8034aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8034af:	89 fa                	mov    %edi,%edx
  8034b1:	83 c4 1c             	add    $0x1c,%esp
  8034b4:	5b                   	pop    %ebx
  8034b5:	5e                   	pop    %esi
  8034b6:	5f                   	pop    %edi
  8034b7:	5d                   	pop    %ebp
  8034b8:	c3                   	ret    
  8034b9:	8d 76 00             	lea    0x0(%esi),%esi
  8034bc:	31 ff                	xor    %edi,%edi
  8034be:	31 c0                	xor    %eax,%eax
  8034c0:	89 fa                	mov    %edi,%edx
  8034c2:	83 c4 1c             	add    $0x1c,%esp
  8034c5:	5b                   	pop    %ebx
  8034c6:	5e                   	pop    %esi
  8034c7:	5f                   	pop    %edi
  8034c8:	5d                   	pop    %ebp
  8034c9:	c3                   	ret    
  8034ca:	66 90                	xchg   %ax,%ax
  8034cc:	89 d8                	mov    %ebx,%eax
  8034ce:	f7 f7                	div    %edi
  8034d0:	31 ff                	xor    %edi,%edi
  8034d2:	89 fa                	mov    %edi,%edx
  8034d4:	83 c4 1c             	add    $0x1c,%esp
  8034d7:	5b                   	pop    %ebx
  8034d8:	5e                   	pop    %esi
  8034d9:	5f                   	pop    %edi
  8034da:	5d                   	pop    %ebp
  8034db:	c3                   	ret    
  8034dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034e1:	89 eb                	mov    %ebp,%ebx
  8034e3:	29 fb                	sub    %edi,%ebx
  8034e5:	89 f9                	mov    %edi,%ecx
  8034e7:	d3 e6                	shl    %cl,%esi
  8034e9:	89 c5                	mov    %eax,%ebp
  8034eb:	88 d9                	mov    %bl,%cl
  8034ed:	d3 ed                	shr    %cl,%ebp
  8034ef:	89 e9                	mov    %ebp,%ecx
  8034f1:	09 f1                	or     %esi,%ecx
  8034f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034f7:	89 f9                	mov    %edi,%ecx
  8034f9:	d3 e0                	shl    %cl,%eax
  8034fb:	89 c5                	mov    %eax,%ebp
  8034fd:	89 d6                	mov    %edx,%esi
  8034ff:	88 d9                	mov    %bl,%cl
  803501:	d3 ee                	shr    %cl,%esi
  803503:	89 f9                	mov    %edi,%ecx
  803505:	d3 e2                	shl    %cl,%edx
  803507:	8b 44 24 08          	mov    0x8(%esp),%eax
  80350b:	88 d9                	mov    %bl,%cl
  80350d:	d3 e8                	shr    %cl,%eax
  80350f:	09 c2                	or     %eax,%edx
  803511:	89 d0                	mov    %edx,%eax
  803513:	89 f2                	mov    %esi,%edx
  803515:	f7 74 24 0c          	divl   0xc(%esp)
  803519:	89 d6                	mov    %edx,%esi
  80351b:	89 c3                	mov    %eax,%ebx
  80351d:	f7 e5                	mul    %ebp
  80351f:	39 d6                	cmp    %edx,%esi
  803521:	72 19                	jb     80353c <__udivdi3+0xfc>
  803523:	74 0b                	je     803530 <__udivdi3+0xf0>
  803525:	89 d8                	mov    %ebx,%eax
  803527:	31 ff                	xor    %edi,%edi
  803529:	e9 58 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  80352e:	66 90                	xchg   %ax,%ax
  803530:	8b 54 24 08          	mov    0x8(%esp),%edx
  803534:	89 f9                	mov    %edi,%ecx
  803536:	d3 e2                	shl    %cl,%edx
  803538:	39 c2                	cmp    %eax,%edx
  80353a:	73 e9                	jae    803525 <__udivdi3+0xe5>
  80353c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80353f:	31 ff                	xor    %edi,%edi
  803541:	e9 40 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  803546:	66 90                	xchg   %ax,%ax
  803548:	31 c0                	xor    %eax,%eax
  80354a:	e9 37 ff ff ff       	jmp    803486 <__udivdi3+0x46>
  80354f:	90                   	nop

00803550 <__umoddi3>:
  803550:	55                   	push   %ebp
  803551:	57                   	push   %edi
  803552:	56                   	push   %esi
  803553:	53                   	push   %ebx
  803554:	83 ec 1c             	sub    $0x1c,%esp
  803557:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80355b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80355f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803563:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803567:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80356b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80356f:	89 f3                	mov    %esi,%ebx
  803571:	89 fa                	mov    %edi,%edx
  803573:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803577:	89 34 24             	mov    %esi,(%esp)
  80357a:	85 c0                	test   %eax,%eax
  80357c:	75 1a                	jne    803598 <__umoddi3+0x48>
  80357e:	39 f7                	cmp    %esi,%edi
  803580:	0f 86 a2 00 00 00    	jbe    803628 <__umoddi3+0xd8>
  803586:	89 c8                	mov    %ecx,%eax
  803588:	89 f2                	mov    %esi,%edx
  80358a:	f7 f7                	div    %edi
  80358c:	89 d0                	mov    %edx,%eax
  80358e:	31 d2                	xor    %edx,%edx
  803590:	83 c4 1c             	add    $0x1c,%esp
  803593:	5b                   	pop    %ebx
  803594:	5e                   	pop    %esi
  803595:	5f                   	pop    %edi
  803596:	5d                   	pop    %ebp
  803597:	c3                   	ret    
  803598:	39 f0                	cmp    %esi,%eax
  80359a:	0f 87 ac 00 00 00    	ja     80364c <__umoddi3+0xfc>
  8035a0:	0f bd e8             	bsr    %eax,%ebp
  8035a3:	83 f5 1f             	xor    $0x1f,%ebp
  8035a6:	0f 84 ac 00 00 00    	je     803658 <__umoddi3+0x108>
  8035ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8035b1:	29 ef                	sub    %ebp,%edi
  8035b3:	89 fe                	mov    %edi,%esi
  8035b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035b9:	89 e9                	mov    %ebp,%ecx
  8035bb:	d3 e0                	shl    %cl,%eax
  8035bd:	89 d7                	mov    %edx,%edi
  8035bf:	89 f1                	mov    %esi,%ecx
  8035c1:	d3 ef                	shr    %cl,%edi
  8035c3:	09 c7                	or     %eax,%edi
  8035c5:	89 e9                	mov    %ebp,%ecx
  8035c7:	d3 e2                	shl    %cl,%edx
  8035c9:	89 14 24             	mov    %edx,(%esp)
  8035cc:	89 d8                	mov    %ebx,%eax
  8035ce:	d3 e0                	shl    %cl,%eax
  8035d0:	89 c2                	mov    %eax,%edx
  8035d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d6:	d3 e0                	shl    %cl,%eax
  8035d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e0:	89 f1                	mov    %esi,%ecx
  8035e2:	d3 e8                	shr    %cl,%eax
  8035e4:	09 d0                	or     %edx,%eax
  8035e6:	d3 eb                	shr    %cl,%ebx
  8035e8:	89 da                	mov    %ebx,%edx
  8035ea:	f7 f7                	div    %edi
  8035ec:	89 d3                	mov    %edx,%ebx
  8035ee:	f7 24 24             	mull   (%esp)
  8035f1:	89 c6                	mov    %eax,%esi
  8035f3:	89 d1                	mov    %edx,%ecx
  8035f5:	39 d3                	cmp    %edx,%ebx
  8035f7:	0f 82 87 00 00 00    	jb     803684 <__umoddi3+0x134>
  8035fd:	0f 84 91 00 00 00    	je     803694 <__umoddi3+0x144>
  803603:	8b 54 24 04          	mov    0x4(%esp),%edx
  803607:	29 f2                	sub    %esi,%edx
  803609:	19 cb                	sbb    %ecx,%ebx
  80360b:	89 d8                	mov    %ebx,%eax
  80360d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803611:	d3 e0                	shl    %cl,%eax
  803613:	89 e9                	mov    %ebp,%ecx
  803615:	d3 ea                	shr    %cl,%edx
  803617:	09 d0                	or     %edx,%eax
  803619:	89 e9                	mov    %ebp,%ecx
  80361b:	d3 eb                	shr    %cl,%ebx
  80361d:	89 da                	mov    %ebx,%edx
  80361f:	83 c4 1c             	add    $0x1c,%esp
  803622:	5b                   	pop    %ebx
  803623:	5e                   	pop    %esi
  803624:	5f                   	pop    %edi
  803625:	5d                   	pop    %ebp
  803626:	c3                   	ret    
  803627:	90                   	nop
  803628:	89 fd                	mov    %edi,%ebp
  80362a:	85 ff                	test   %edi,%edi
  80362c:	75 0b                	jne    803639 <__umoddi3+0xe9>
  80362e:	b8 01 00 00 00       	mov    $0x1,%eax
  803633:	31 d2                	xor    %edx,%edx
  803635:	f7 f7                	div    %edi
  803637:	89 c5                	mov    %eax,%ebp
  803639:	89 f0                	mov    %esi,%eax
  80363b:	31 d2                	xor    %edx,%edx
  80363d:	f7 f5                	div    %ebp
  80363f:	89 c8                	mov    %ecx,%eax
  803641:	f7 f5                	div    %ebp
  803643:	89 d0                	mov    %edx,%eax
  803645:	e9 44 ff ff ff       	jmp    80358e <__umoddi3+0x3e>
  80364a:	66 90                	xchg   %ax,%ax
  80364c:	89 c8                	mov    %ecx,%eax
  80364e:	89 f2                	mov    %esi,%edx
  803650:	83 c4 1c             	add    $0x1c,%esp
  803653:	5b                   	pop    %ebx
  803654:	5e                   	pop    %esi
  803655:	5f                   	pop    %edi
  803656:	5d                   	pop    %ebp
  803657:	c3                   	ret    
  803658:	3b 04 24             	cmp    (%esp),%eax
  80365b:	72 06                	jb     803663 <__umoddi3+0x113>
  80365d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803661:	77 0f                	ja     803672 <__umoddi3+0x122>
  803663:	89 f2                	mov    %esi,%edx
  803665:	29 f9                	sub    %edi,%ecx
  803667:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80366b:	89 14 24             	mov    %edx,(%esp)
  80366e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803672:	8b 44 24 04          	mov    0x4(%esp),%eax
  803676:	8b 14 24             	mov    (%esp),%edx
  803679:	83 c4 1c             	add    $0x1c,%esp
  80367c:	5b                   	pop    %ebx
  80367d:	5e                   	pop    %esi
  80367e:	5f                   	pop    %edi
  80367f:	5d                   	pop    %ebp
  803680:	c3                   	ret    
  803681:	8d 76 00             	lea    0x0(%esi),%esi
  803684:	2b 04 24             	sub    (%esp),%eax
  803687:	19 fa                	sbb    %edi,%edx
  803689:	89 d1                	mov    %edx,%ecx
  80368b:	89 c6                	mov    %eax,%esi
  80368d:	e9 71 ff ff ff       	jmp    803603 <__umoddi3+0xb3>
  803692:	66 90                	xchg   %ax,%ax
  803694:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803698:	72 ea                	jb     803684 <__umoddi3+0x134>
  80369a:	89 d9                	mov    %ebx,%ecx
  80369c:	e9 62 ff ff ff       	jmp    803603 <__umoddi3+0xb3>
