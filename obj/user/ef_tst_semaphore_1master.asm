
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
  80003e:	e8 91 1b 00 00       	call   801bd4 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 40 37 80 00       	push   $0x803740
  800050:	e8 19 1a 00 00       	call   801a6e <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 44 37 80 00       	push   $0x803744
  800062:	e8 07 1a 00 00       	call   801a6e <sys_createSemaphore>
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
  800083:	68 4c 37 80 00       	push   $0x80374c
  800088:	e8 f2 1a 00 00       	call   801b7f <sys_create_env>
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
  8000ac:	68 4c 37 80 00       	push   $0x80374c
  8000b1:	e8 c9 1a 00 00       	call   801b7f <sys_create_env>
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
  8000d5:	68 4c 37 80 00       	push   $0x80374c
  8000da:	e8 a0 1a 00 00       	call   801b7f <sys_create_env>
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
  8000fa:	68 59 37 80 00       	push   $0x803759
  8000ff:	6a 13                	push   $0x13
  800101:	68 70 37 80 00       	push   $0x803770
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 87 1a 00 00       	call   801b9d <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 79 1a 00 00       	call   801b9d <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 6b 1a 00 00       	call   801b9d <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 44 37 80 00       	push   $0x803744
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 62 19 00 00       	call   801aa7 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 44 37 80 00       	push   $0x803744
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 4f 19 00 00       	call   801aa7 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 44 37 80 00       	push   $0x803744
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 3c 19 00 00       	call   801aa7 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 40 37 80 00       	push   $0x803740
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 0c 19 00 00       	call   801a8a <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 44 37 80 00       	push   $0x803744
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 f6 18 00 00       	call   801a8a <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 90 37 80 00       	push   $0x803790
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 d8 37 80 00       	push   $0x8037d8
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 39 1a 00 00       	call   801c06 <sys_getparentenvid>
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
  8001e0:	68 23 38 80 00       	push   $0x803823
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 fc 14 00 00       	call   8016e9 <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 bb 19 00 00       	call   801bb9 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 ad 19 00 00       	call   801bb9 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 9f 19 00 00       	call   801bb9 <sys_destroy_env>
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
  800234:	e8 b4 19 00 00       	call   801bed <sys_getenvindex>
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
  80029f:	e8 56 17 00 00       	call   8019fa <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 4c 38 80 00       	push   $0x80384c
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
  8002cf:	68 74 38 80 00       	push   $0x803874
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
  800300:	68 9c 38 80 00       	push   $0x80389c
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 50 80 00       	mov    0x805020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 f4 38 80 00       	push   $0x8038f4
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 4c 38 80 00       	push   $0x80384c
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 d6 16 00 00       	call   801a14 <sys_enable_interrupt>

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
  800351:	e8 63 18 00 00       	call   801bb9 <sys_destroy_env>
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
  800362:	e8 b8 18 00 00       	call   801c1f <sys_exit_env>
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
  80038b:	68 08 39 80 00       	push   $0x803908
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 50 80 00       	mov    0x805000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 0d 39 80 00       	push   $0x80390d
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
  8003c8:	68 29 39 80 00       	push   $0x803929
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
  8003f4:	68 2c 39 80 00       	push   $0x80392c
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 78 39 80 00       	push   $0x803978
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
  8004c6:	68 84 39 80 00       	push   $0x803984
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 78 39 80 00       	push   $0x803978
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
  800536:	68 d8 39 80 00       	push   $0x8039d8
  80053b:	6a 44                	push   $0x44
  80053d:	68 78 39 80 00       	push   $0x803978
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
  800590:	e8 b7 12 00 00       	call   80184c <sys_cputs>
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
  800607:	e8 40 12 00 00       	call   80184c <sys_cputs>
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
  800651:	e8 a4 13 00 00       	call   8019fa <sys_disable_interrupt>
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
  800671:	e8 9e 13 00 00       	call   801a14 <sys_enable_interrupt>
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
  8006bb:	e8 10 2e 00 00       	call   8034d0 <__udivdi3>
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
  80070b:	e8 d0 2e 00 00       	call   8035e0 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 54 3c 80 00       	add    $0x803c54,%eax
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
  800866:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
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
  800947:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 65 3c 80 00       	push   $0x803c65
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
  80096c:	68 6e 3c 80 00       	push   $0x803c6e
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
  800999:	be 71 3c 80 00       	mov    $0x803c71,%esi
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
  8013bf:	68 d0 3d 80 00       	push   $0x803dd0
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
  80148f:	e8 fc 04 00 00       	call   801990 <sys_allocate_chunk>
  801494:	83 c4 10             	add    $0x10,%esp
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801497:	a1 20 51 80 00       	mov    0x805120,%eax
  80149c:	83 ec 0c             	sub    $0xc,%esp
  80149f:	50                   	push   %eax
  8014a0:	e8 71 0b 00 00       	call   802016 <initialize_MemBlocksList>
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
  8014cd:	68 f5 3d 80 00       	push   $0x803df5
  8014d2:	6a 33                	push   $0x33
  8014d4:	68 13 3e 80 00       	push   $0x803e13
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
  80154c:	68 20 3e 80 00       	push   $0x803e20
  801551:	6a 34                	push   $0x34
  801553:	68 13 3e 80 00       	push   $0x803e13
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
  8015e4:	e8 75 07 00 00       	call   801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	74 11                	je     8015fe <malloc+0x58>
		user_block = alloc_block_FF(malloc_allocsize);
  8015ed:	83 ec 0c             	sub    $0xc,%esp
  8015f0:	ff 75 e8             	pushl  -0x18(%ebp)
  8015f3:	e8 e0 0d 00 00       	call   8023d8 <alloc_block_FF>
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
  80160a:	e8 3c 0b 00 00       	call   80214b <insert_sorted_allocList>
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
  80162a:	68 44 3e 80 00       	push   $0x803e44
  80162f:	6a 6f                	push   $0x6f
  801631:	68 13 3e 80 00       	push   $0x803e13
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
  801650:	75 0a                	jne    80165c <smalloc+0x21>
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
  801657:	e9 8b 00 00 00       	jmp    8016e7 <smalloc+0xac>
	//	   Else, return NULL

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80165c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801663:	8b 55 0c             	mov    0xc(%ebp),%edx
  801666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801669:	01 d0                	add    %edx,%eax
  80166b:	48                   	dec    %eax
  80166c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80166f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801672:	ba 00 00 00 00       	mov    $0x0,%edx
  801677:	f7 75 f0             	divl   -0x10(%ebp)
  80167a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167d:	29 d0                	sub    %edx,%eax
  80167f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	struct MemBlock * mem_block;
	uint32 virtual_address = -1;
  801682:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
	if (sys_isUHeapPlacementStrategyFIRSTFIT())
  801689:	e8 d0 06 00 00       	call   801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80168e:	85 c0                	test   %eax,%eax
  801690:	74 11                	je     8016a3 <smalloc+0x68>
		mem_block = alloc_block_FF(allocate_space);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 e8             	pushl  -0x18(%ebp)
  801698:	e8 3b 0d 00 00       	call   8023d8 <alloc_block_FF>
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(mem_block != NULL)
  8016a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016a7:	74 39                	je     8016e2 <smalloc+0xa7>
	{
		int result = sys_createSharedObject(sharedVarName,size,isWritable,(void*)mem_block->sva);
  8016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ac:	8b 40 08             	mov    0x8(%eax),%eax
  8016af:	89 c2                	mov    %eax,%edx
  8016b1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016b5:	52                   	push   %edx
  8016b6:	50                   	push   %eax
  8016b7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ba:	ff 75 08             	pushl  0x8(%ebp)
  8016bd:	e8 21 04 00 00       	call   801ae3 <sys_createSharedObject>
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (result != -1 && result != E_NO_SHARE && result != E_SHARED_MEM_EXISTS)
  8016c8:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8016cc:	74 14                	je     8016e2 <smalloc+0xa7>
  8016ce:	83 7d e0 f2          	cmpl   $0xfffffff2,-0x20(%ebp)
  8016d2:	74 0e                	je     8016e2 <smalloc+0xa7>
  8016d4:	83 7d e0 f1          	cmpl   $0xfffffff1,-0x20(%ebp)
  8016d8:	74 08                	je     8016e2 <smalloc+0xa7>
			return (void*) mem_block->sva;
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	8b 40 08             	mov    0x8(%eax),%eax
  8016e0:	eb 05                	jmp    8016e7 <smalloc+0xac>
	}
	return NULL;
  8016e2:	b8 00 00 00 00       	mov    $0x0,%eax

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ef:	e8 b4 fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	ff 75 0c             	pushl  0xc(%ebp)
  8016fa:	ff 75 08             	pushl  0x8(%ebp)
  8016fd:	e8 0b 04 00 00       	call   801b0d <sys_getSizeOfSharedObject>
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (size != E_SHARED_MEM_NOT_EXISTS)
  801708:	83 7d f0 f0          	cmpl   $0xfffffff0,-0x10(%ebp)
  80170c:	74 76                	je     801784 <sget+0x9b>
	{
		uint32 allocate_space=ROUNDUP(size,PAGE_SIZE);
  80170e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801715:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80171b:	01 d0                	add    %edx,%eax
  80171d:	48                   	dec    %eax
  80171e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	f7 75 ec             	divl   -0x14(%ebp)
  80172c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172f:	29 d0                	sub    %edx,%eax
  801731:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		struct MemBlock * mem_block = NULL;
  801734:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

		if (sys_isUHeapPlacementStrategyFIRSTFIT())
  80173b:	e8 1e 06 00 00       	call   801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801740:	85 c0                	test   %eax,%eax
  801742:	74 11                	je     801755 <sget+0x6c>
			mem_block = alloc_block_FF(allocate_space);
  801744:	83 ec 0c             	sub    $0xc,%esp
  801747:	ff 75 e4             	pushl  -0x1c(%ebp)
  80174a:	e8 89 0c 00 00       	call   8023d8 <alloc_block_FF>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(mem_block != NULL)
  801755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801759:	74 29                	je     801784 <sget+0x9b>
		{
			uint32 shared_object_id = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)mem_block->sva);
  80175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175e:	8b 40 08             	mov    0x8(%eax),%eax
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	50                   	push   %eax
  801765:	ff 75 0c             	pushl  0xc(%ebp)
  801768:	ff 75 08             	pushl  0x8(%ebp)
  80176b:	e8 ba 03 00 00       	call   801b2a <sys_getSharedObject>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if (shared_object_id != E_SHARED_MEM_NOT_EXISTS)
  801776:	83 7d e0 f0          	cmpl   $0xfffffff0,-0x20(%ebp)
  80177a:	74 08                	je     801784 <sget+0x9b>
				return (void *)mem_block->sva;
  80177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177f:	8b 40 08             	mov    0x8(%eax),%eax
  801782:	eb 05                	jmp    801789 <sget+0xa0>
		}
	}
	return (void *)NULL;
  801784:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801791:	e8 12 fc ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	68 68 3e 80 00       	push   $0x803e68
  80179e:	68 f1 00 00 00       	push   $0xf1
  8017a3:	68 13 3e 80 00       	push   $0x803e13
  8017a8:	e8 bd eb ff ff       	call   80036a <_panic>

008017ad <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	68 90 3e 80 00       	push   $0x803e90
  8017bb:	68 05 01 00 00       	push   $0x105
  8017c0:	68 13 3e 80 00       	push   $0x803e13
  8017c5:	e8 a0 eb ff ff       	call   80036a <_panic>

008017ca <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	68 b4 3e 80 00       	push   $0x803eb4
  8017d8:	68 10 01 00 00       	push   $0x110
  8017dd:	68 13 3e 80 00       	push   $0x803e13
  8017e2:	e8 83 eb ff ff       	call   80036a <_panic>

008017e7 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	68 b4 3e 80 00       	push   $0x803eb4
  8017f5:	68 15 01 00 00       	push   $0x115
  8017fa:	68 13 3e 80 00       	push   $0x803e13
  8017ff:	e8 66 eb ff ff       	call   80036a <_panic>

00801804 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 b4 3e 80 00       	push   $0x803eb4
  801812:	68 1a 01 00 00       	push   $0x11a
  801817:	68 13 3e 80 00       	push   $0x803e13
  80181c:	e8 49 eb ff ff       	call   80036a <_panic>

00801821 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	57                   	push   %edi
  801825:	56                   	push   %esi
  801826:	53                   	push   %ebx
  801827:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801833:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801836:	8b 7d 18             	mov    0x18(%ebp),%edi
  801839:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183c:	cd 30                	int    $0x30
  80183e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5f                   	pop    %edi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801858:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	52                   	push   %edx
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	50                   	push   %eax
  801868:	6a 00                	push   $0x0
  80186a:	e8 b2 ff ff ff       	call   801821 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_cgetc>:

int
sys_cgetc(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 01                	push   $0x1
  801884:	e8 98 ff ff ff       	call   801821 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 05                	push   $0x5
  8018a1:	e8 7b ff ff ff       	call   801821 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	51                   	push   %ecx
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 06                	push   $0x6
  8018c6:	e8 56 ff ff ff       	call   801821 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 07                	push   $0x7
  8018e8:	e8 34 ff ff ff       	call   801821 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	6a 08                	push   $0x8
  801903:	e8 19 ff ff ff       	call   801821 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 09                	push   $0x9
  80191c:	e8 00 ff ff ff       	call   801821 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 0a                	push   $0xa
  801935:	e8 e7 fe ff ff       	call   801821 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 0b                	push   $0xb
  80194e:	e8 ce fe ff ff       	call   801821 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 0f                	push   $0xf
  801969:	e8 b3 fe ff ff       	call   801821 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 10                	push   $0x10
  801985:	e8 97 fe ff ff       	call   801821 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return ;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 11                	push   $0x11
  8019a2:	e8 7a fe ff ff       	call   801821 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019aa:	90                   	nop
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 0c                	push   $0xc
  8019bc:	e8 60 fe ff ff       	call   801821 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 0d                	push   $0xd
  8019d6:	e8 46 fe ff ff       	call   801821 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0e                	push   $0xe
  8019ef:	e8 2d fe ff ff       	call   801821 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 13                	push   $0x13
  801a09:	e8 13 fe ff ff       	call   801821 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 14                	push   $0x14
  801a23:	e8 f9 fd ff ff       	call   801821 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	50                   	push   %eax
  801a47:	6a 15                	push   $0x15
  801a49:	e8 d3 fd ff ff       	call   801821 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 16                	push   $0x16
  801a63:	e8 b9 fd ff ff       	call   801821 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	6a 17                	push   $0x17
  801a80:	e8 9c fd ff ff       	call   801821 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	6a 1a                	push   $0x1a
  801a9d:	e8 7f fd ff ff       	call   801821 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	6a 18                	push   $0x18
  801aba:	e8 62 fd ff ff       	call   801821 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	52                   	push   %edx
  801ad5:	50                   	push   %eax
  801ad6:	6a 19                	push   $0x19
  801ad8:	e8 44 fd ff ff       	call   801821 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	90                   	nop
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	51                   	push   %ecx
  801afc:	52                   	push   %edx
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	50                   	push   %eax
  801b01:	6a 1b                	push   $0x1b
  801b03:	e8 19 fd ff ff       	call   801821 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 1c                	push   $0x1c
  801b20:	e8 fc fc ff ff       	call   801821 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	51                   	push   %ecx
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 1d                	push   $0x1d
  801b3f:	e8 dd fc ff ff       	call   801821 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 1e                	push   $0x1e
  801b5c:	e8 c0 fc ff ff       	call   801821 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 1f                	push   $0x1f
  801b75:	e8 a7 fc ff ff       	call   801821 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	ff 75 14             	pushl  0x14(%ebp)
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	50                   	push   %eax
  801b91:	6a 20                	push   $0x20
  801b93:	e8 89 fc ff ff       	call   801821 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	50                   	push   %eax
  801bac:	6a 21                	push   $0x21
  801bae:	e8 6e fc ff ff       	call   801821 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	90                   	nop
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	50                   	push   %eax
  801bc8:	6a 22                	push   $0x22
  801bca:	e8 52 fc ff ff       	call   801821 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 02                	push   $0x2
  801be3:	e8 39 fc ff ff       	call   801821 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 03                	push   $0x3
  801bfc:	e8 20 fc ff ff       	call   801821 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 04                	push   $0x4
  801c15:	e8 07 fc ff ff       	call   801821 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_exit_env>:


void sys_exit_env(void)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 23                	push   $0x23
  801c2e:	e8 ee fb ff ff       	call   801821 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	90                   	nop
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c42:	8d 50 04             	lea    0x4(%eax),%edx
  801c45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	52                   	push   %edx
  801c4f:	50                   	push   %eax
  801c50:	6a 24                	push   $0x24
  801c52:	e8 ca fb ff ff       	call   801821 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return result;
  801c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c63:	89 01                	mov    %eax,(%ecx)
  801c65:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	c9                   	leave  
  801c6c:	c2 04 00             	ret    $0x4

00801c6f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 10             	pushl  0x10(%ebp)
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	ff 75 08             	pushl  0x8(%ebp)
  801c7f:	6a 12                	push   $0x12
  801c81:	e8 9b fb ff ff       	call   801821 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
	return ;
  801c89:	90                   	nop
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 25                	push   $0x25
  801c9b:	e8 81 fb ff ff       	call   801821 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cb1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	50                   	push   %eax
  801cbe:	6a 26                	push   $0x26
  801cc0:	e8 5c fb ff ff       	call   801821 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <rsttst>:
void rsttst()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 28                	push   $0x28
  801cda:	e8 42 fb ff ff       	call   801821 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cf1:	8b 55 18             	mov    0x18(%ebp),%edx
  801cf4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	ff 75 10             	pushl  0x10(%ebp)
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	6a 27                	push   $0x27
  801d05:	e8 17 fb ff ff       	call   801821 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0d:	90                   	nop
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <chktst>:
void chktst(uint32 n)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	ff 75 08             	pushl  0x8(%ebp)
  801d1e:	6a 29                	push   $0x29
  801d20:	e8 fc fa ff ff       	call   801821 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return ;
  801d28:	90                   	nop
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <inctst>:

void inctst()
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 2a                	push   $0x2a
  801d3a:	e8 e2 fa ff ff       	call   801821 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <gettst>:
uint32 gettst()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 2b                	push   $0x2b
  801d54:	e8 c8 fa ff ff       	call   801821 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 2c                	push   $0x2c
  801d70:	e8 ac fa ff ff       	call   801821 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
  801d78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d7b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d7f:	75 07                	jne    801d88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	eb 05                	jmp    801d8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 2c                	push   $0x2c
  801da1:	e8 7b fa ff ff       	call   801821 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
  801da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801db0:	75 07                	jne    801db9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	eb 05                	jmp    801dbe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 2c                	push   $0x2c
  801dd2:	e8 4a fa ff ff       	call   801821 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
  801dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ddd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801de1:	75 07                	jne    801dea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801de3:	b8 01 00 00 00       	mov    $0x1,%eax
  801de8:	eb 05                	jmp    801def <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 2c                	push   $0x2c
  801e03:	e8 19 fa ff ff       	call   801821 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
  801e0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e0e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e12:	75 07                	jne    801e1b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e14:	b8 01 00 00 00       	mov    $0x1,%eax
  801e19:	eb 05                	jmp    801e20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	6a 2d                	push   $0x2d
  801e32:	e8 ea f9 ff ff       	call   801821 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3a:	90                   	nop
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	53                   	push   %ebx
  801e50:	51                   	push   %ecx
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	6a 2e                	push   $0x2e
  801e55:	e8 c7 f9 ff ff       	call   801821 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	52                   	push   %edx
  801e72:	50                   	push   %eax
  801e73:	6a 2f                	push   $0x2f
  801e75:	e8 a7 f9 ff ff       	call   801821 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e85:	83 ec 0c             	sub    $0xc,%esp
  801e88:	68 c4 3e 80 00       	push   $0x803ec4
  801e8d:	e8 8c e7 ff ff       	call   80061e <cprintf>
  801e92:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	68 f0 3e 80 00       	push   $0x803ef0
  801ea4:	e8 75 e7 ff ff       	call   80061e <cprintf>
  801ea9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eac:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eb0:	a1 38 51 80 00       	mov    0x805138,%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb8:	eb 56                	jmp    801f10 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebe:	74 1c                	je     801edc <print_mem_block_lists+0x5d>
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	8b 50 08             	mov    0x8(%eax),%edx
  801ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec9:	8b 48 08             	mov    0x8(%eax),%ecx
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed2:	01 c8                	add    %ecx,%eax
  801ed4:	39 c2                	cmp    %eax,%edx
  801ed6:	73 04                	jae    801edc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ed8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	8b 50 08             	mov    0x8(%eax),%edx
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee8:	01 c2                	add    %eax,%edx
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	8b 40 08             	mov    0x8(%eax),%eax
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	52                   	push   %edx
  801ef4:	50                   	push   %eax
  801ef5:	68 05 3f 80 00       	push   $0x803f05
  801efa:	e8 1f e7 ff ff       	call   80061e <cprintf>
  801eff:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f08:	a1 40 51 80 00       	mov    0x805140,%eax
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f14:	74 07                	je     801f1d <print_mem_block_lists+0x9e>
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	8b 00                	mov    (%eax),%eax
  801f1b:	eb 05                	jmp    801f22 <print_mem_block_lists+0xa3>
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f22:	a3 40 51 80 00       	mov    %eax,0x805140
  801f27:	a1 40 51 80 00       	mov    0x805140,%eax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	75 8a                	jne    801eba <print_mem_block_lists+0x3b>
  801f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f34:	75 84                	jne    801eba <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f36:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3a:	75 10                	jne    801f4c <print_mem_block_lists+0xcd>
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	68 14 3f 80 00       	push   $0x803f14
  801f44:	e8 d5 e6 ff ff       	call   80061e <cprintf>
  801f49:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	68 38 3f 80 00       	push   $0x803f38
  801f5b:	e8 be e6 ff ff       	call   80061e <cprintf>
  801f60:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f63:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f67:	a1 40 50 80 00       	mov    0x805040,%eax
  801f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6f:	eb 56                	jmp    801fc7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f75:	74 1c                	je     801f93 <print_mem_block_lists+0x114>
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 50 08             	mov    0x8(%eax),%edx
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f80:	8b 48 08             	mov    0x8(%eax),%ecx
  801f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f86:	8b 40 0c             	mov    0xc(%eax),%eax
  801f89:	01 c8                	add    %ecx,%eax
  801f8b:	39 c2                	cmp    %eax,%edx
  801f8d:	73 04                	jae    801f93 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f8f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 50 08             	mov    0x8(%eax),%edx
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9f:	01 c2                	add    %eax,%edx
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	8b 40 08             	mov    0x8(%eax),%eax
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	52                   	push   %edx
  801fab:	50                   	push   %eax
  801fac:	68 05 3f 80 00       	push   $0x803f05
  801fb1:	e8 68 e6 ff ff       	call   80061e <cprintf>
  801fb6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fbf:	a1 48 50 80 00       	mov    0x805048,%eax
  801fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcb:	74 07                	je     801fd4 <print_mem_block_lists+0x155>
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 00                	mov    (%eax),%eax
  801fd2:	eb 05                	jmp    801fd9 <print_mem_block_lists+0x15a>
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	a3 48 50 80 00       	mov    %eax,0x805048
  801fde:	a1 48 50 80 00       	mov    0x805048,%eax
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	75 8a                	jne    801f71 <print_mem_block_lists+0xf2>
  801fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801feb:	75 84                	jne    801f71 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fed:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff1:	75 10                	jne    802003 <print_mem_block_lists+0x184>
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	68 50 3f 80 00       	push   $0x803f50
  801ffb:	e8 1e e6 ff ff       	call   80061e <cprintf>
  802000:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	68 c4 3e 80 00       	push   $0x803ec4
  80200b:	e8 0e e6 ff ff       	call   80061e <cprintf>
  802010:	83 c4 10             	add    $0x10,%esp

}
  802013:	90                   	nop
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);
  80201c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802023:	00 00 00 
  802026:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80202d:	00 00 00 
  802030:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802037:	00 00 00 

	for(int y=0;y<numOfBlocks;y++)
  80203a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802041:	e9 9e 00 00 00       	jmp    8020e4 <initialize_MemBlocksList+0xce>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
  802046:	a1 50 50 80 00       	mov    0x805050,%eax
  80204b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204e:	c1 e2 04             	shl    $0x4,%edx
  802051:	01 d0                	add    %edx,%eax
  802053:	85 c0                	test   %eax,%eax
  802055:	75 14                	jne    80206b <initialize_MemBlocksList+0x55>
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 78 3f 80 00       	push   $0x803f78
  80205f:	6a 46                	push   $0x46
  802061:	68 9b 3f 80 00       	push   $0x803f9b
  802066:	e8 ff e2 ff ff       	call   80036a <_panic>
  80206b:	a1 50 50 80 00       	mov    0x805050,%eax
  802070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802073:	c1 e2 04             	shl    $0x4,%edx
  802076:	01 d0                	add    %edx,%eax
  802078:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80207e:	89 10                	mov    %edx,(%eax)
  802080:	8b 00                	mov    (%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 18                	je     80209e <initialize_MemBlocksList+0x88>
  802086:	a1 48 51 80 00       	mov    0x805148,%eax
  80208b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802091:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802094:	c1 e1 04             	shl    $0x4,%ecx
  802097:	01 ca                	add    %ecx,%edx
  802099:	89 50 04             	mov    %edx,0x4(%eax)
  80209c:	eb 12                	jmp    8020b0 <initialize_MemBlocksList+0x9a>
  80209e:	a1 50 50 80 00       	mov    0x805050,%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	c1 e2 04             	shl    $0x4,%edx
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8020b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8020b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b8:	c1 e2 04             	shl    $0x4,%edx
  8020bb:	01 d0                	add    %edx,%eax
  8020bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8020c2:	a1 50 50 80 00       	mov    0x805050,%eax
  8020c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ca:	c1 e2 04             	shl    $0x4,%edx
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d6:	a1 54 51 80 00       	mov    0x805154,%eax
  8020db:	40                   	inc    %eax
  8020dc:	a3 54 51 80 00       	mov    %eax,0x805154
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
	// Write your code here, remove the panic and write your code
	//panic("initialize_MemBlocksList() is not implemented yet...!!");
	LIST_INIT(&AvailableMemBlocksList);

	for(int y=0;y<numOfBlocks;y++)
  8020e1:	ff 45 f4             	incl   -0xc(%ebp)
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ea:	0f 82 56 ff ff ff    	jb     802046 <initialize_MemBlocksList+0x30>
	{
		LIST_INSERT_HEAD(&AvailableMemBlocksList, &(MemBlockNodes[y]));
	}
}
  8020f0:	90                   	nop
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802101:	eb 19                	jmp    80211c <find_block+0x29>
	{
		if(va==point->sva)
  802103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802106:	8b 40 08             	mov    0x8(%eax),%eax
  802109:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80210c:	75 05                	jne    802113 <find_block+0x20>
		   return point;
  80210e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802111:	eb 36                	jmp    802149 <find_block+0x56>
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] find_block
	// Write your code here, remove the panic and write your code
	//panic("find_block() is not implemented yet...!!");
	struct MemBlock *point;

	LIST_FOREACH(point,blockList)
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	8b 40 08             	mov    0x8(%eax),%eax
  802119:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802120:	74 07                	je     802129 <find_block+0x36>
  802122:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802125:	8b 00                	mov    (%eax),%eax
  802127:	eb 05                	jmp    80212e <find_block+0x3b>
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
  80212e:	8b 55 08             	mov    0x8(%ebp),%edx
  802131:	89 42 08             	mov    %eax,0x8(%edx)
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	8b 40 08             	mov    0x8(%eax),%eax
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 c5                	jne    802103 <find_block+0x10>
  80213e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802142:	75 bf                	jne    802103 <find_block+0x10>
	{
		if(va==point->sva)
		   return point;
	}
	return NULL;
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_allocList
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_allocList() is not implemented yet...!!");
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
  802151:	a1 40 50 80 00       	mov    0x805040,%eax
  802156:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;
  802159:	a1 44 50 80 00       	mov    0x805044,%eax
  80215e:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
  802161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802164:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802167:	74 24                	je     80218d <insert_sorted_allocList+0x42>
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8b 50 08             	mov    0x8(%eax),%edx
  80216f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802172:	8b 40 08             	mov    0x8(%eax),%eax
  802175:	39 c2                	cmp    %eax,%edx
  802177:	76 14                	jbe    80218d <insert_sorted_allocList+0x42>
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	8b 50 08             	mov    0x8(%eax),%edx
  80217f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802182:	8b 40 08             	mov    0x8(%eax),%eax
  802185:	39 c2                	cmp    %eax,%edx
  802187:	0f 82 60 01 00 00    	jb     8022ed <insert_sorted_allocList+0x1a2>
	{
		if(head == NULL )
  80218d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802191:	75 65                	jne    8021f8 <insert_sorted_allocList+0xad>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
  802193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802197:	75 14                	jne    8021ad <insert_sorted_allocList+0x62>
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 78 3f 80 00       	push   $0x803f78
  8021a1:	6a 6b                	push   $0x6b
  8021a3:	68 9b 3f 80 00       	push   $0x803f9b
  8021a8:	e8 bd e1 ff ff       	call   80036a <_panic>
  8021ad:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	89 10                	mov    %edx,(%eax)
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	8b 00                	mov    (%eax),%eax
  8021bd:	85 c0                	test   %eax,%eax
  8021bf:	74 0d                	je     8021ce <insert_sorted_allocList+0x83>
  8021c1:	a1 40 50 80 00       	mov    0x805040,%eax
  8021c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c9:	89 50 04             	mov    %edx,0x4(%eax)
  8021cc:	eb 08                	jmp    8021d6 <insert_sorted_allocList+0x8b>
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	a3 44 50 80 00       	mov    %eax,0x805044
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	a3 40 50 80 00       	mov    %eax,0x805040
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8021ed:	40                   	inc    %eax
  8021ee:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8021f3:	e9 dc 01 00 00       	jmp    8023d4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList, blockToInsert);
		}
		else if (blockToInsert->sva <= head->sva)
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	8b 50 08             	mov    0x8(%eax),%edx
  8021fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802201:	8b 40 08             	mov    0x8(%eax),%eax
  802204:	39 c2                	cmp    %eax,%edx
  802206:	77 6c                	ja     802274 <insert_sorted_allocList+0x129>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
  802208:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80220c:	74 06                	je     802214 <insert_sorted_allocList+0xc9>
  80220e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802212:	75 14                	jne    802228 <insert_sorted_allocList+0xdd>
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 b4 3f 80 00       	push   $0x803fb4
  80221c:	6a 6f                	push   $0x6f
  80221e:	68 9b 3f 80 00       	push   $0x803f9b
  802223:	e8 42 e1 ff ff       	call   80036a <_panic>
  802228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80222b:	8b 50 04             	mov    0x4(%eax),%edx
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	89 50 04             	mov    %edx,0x4(%eax)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80223a:	89 10                	mov    %edx,(%eax)
  80223c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223f:	8b 40 04             	mov    0x4(%eax),%eax
  802242:	85 c0                	test   %eax,%eax
  802244:	74 0d                	je     802253 <insert_sorted_allocList+0x108>
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	8b 40 04             	mov    0x4(%eax),%eax
  80224c:	8b 55 08             	mov    0x8(%ebp),%edx
  80224f:	89 10                	mov    %edx,(%eax)
  802251:	eb 08                	jmp    80225b <insert_sorted_allocList+0x110>
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	a3 40 50 80 00       	mov    %eax,0x805040
  80225b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225e:	8b 55 08             	mov    0x8(%ebp),%edx
  802261:	89 50 04             	mov    %edx,0x4(%eax)
  802264:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802269:	40                   	inc    %eax
  80226a:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  80226f:	e9 60 01 00 00       	jmp    8023d4 <insert_sorted_allocList+0x289>
		}
		else if (blockToInsert->sva <= head->sva)
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,head, blockToInsert);
		}
		else if (blockToInsert->sva >= tail->sva )
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	8b 50 08             	mov    0x8(%eax),%edx
  80227a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227d:	8b 40 08             	mov    0x8(%eax),%eax
  802280:	39 c2                	cmp    %eax,%edx
  802282:	0f 82 4c 01 00 00    	jb     8023d4 <insert_sorted_allocList+0x289>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
  802288:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228c:	75 14                	jne    8022a2 <insert_sorted_allocList+0x157>
  80228e:	83 ec 04             	sub    $0x4,%esp
  802291:	68 ec 3f 80 00       	push   $0x803fec
  802296:	6a 73                	push   $0x73
  802298:	68 9b 3f 80 00       	push   $0x803f9b
  80229d:	e8 c8 e0 ff ff       	call   80036a <_panic>
  8022a2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	89 50 04             	mov    %edx,0x4(%eax)
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	8b 40 04             	mov    0x4(%eax),%eax
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	74 0c                	je     8022c4 <insert_sorted_allocList+0x179>
  8022b8:	a1 44 50 80 00       	mov    0x805044,%eax
  8022bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c0:	89 10                	mov    %edx,(%eax)
  8022c2:	eb 08                	jmp    8022cc <insert_sorted_allocList+0x181>
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 40 50 80 00       	mov    %eax,0x805040
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	a3 44 50 80 00       	mov    %eax,0x805044
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8022e2:	40                   	inc    %eax
  8022e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8022e8:	e9 e7 00 00 00       	jmp    8023d4 <insert_sorted_allocList+0x289>
			LIST_INSERT_TAIL(&AllocMemBlocksList, blockToInsert);
		}
	}
	else
	{
		struct MemBlock *current_block = head;
  8022ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		struct MemBlock *next_block = NULL;
  8022f3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  8022fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8022ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802302:	e9 9d 00 00 00       	jmp    8023a4 <insert_sorted_allocList+0x259>
		{
			next_block = LIST_NEXT(current_block);
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 00                	mov    (%eax),%eax
  80230c:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (blockToInsert->sva > current_block->sva && blockToInsert->sva < next_block->sva)
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	8b 50 08             	mov    0x8(%eax),%edx
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 40 08             	mov    0x8(%eax),%eax
  80231b:	39 c2                	cmp    %eax,%edx
  80231d:	76 7d                	jbe    80239c <insert_sorted_allocList+0x251>
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	8b 50 08             	mov    0x8(%eax),%edx
  802325:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802328:	8b 40 08             	mov    0x8(%eax),%eax
  80232b:	39 c2                	cmp    %eax,%edx
  80232d:	73 6d                	jae    80239c <insert_sorted_allocList+0x251>
			{
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	74 06                	je     80233b <insert_sorted_allocList+0x1f0>
  802335:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802339:	75 14                	jne    80234f <insert_sorted_allocList+0x204>
  80233b:	83 ec 04             	sub    $0x4,%esp
  80233e:	68 10 40 80 00       	push   $0x804010
  802343:	6a 7f                	push   $0x7f
  802345:	68 9b 3f 80 00       	push   $0x803f9b
  80234a:	e8 1b e0 ff ff       	call   80036a <_panic>
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 10                	mov    (%eax),%edx
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	89 10                	mov    %edx,(%eax)
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	74 0b                	je     80236d <insert_sorted_allocList+0x222>
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	8b 55 08             	mov    0x8(%ebp),%edx
  80236a:	89 50 04             	mov    %edx,0x4(%eax)
  80236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802370:	8b 55 08             	mov    0x8(%ebp),%edx
  802373:	89 10                	mov    %edx,(%eax)
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	89 50 04             	mov    %edx,0x4(%eax)
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	8b 00                	mov    (%eax),%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	75 08                	jne    80238f <insert_sorted_allocList+0x244>
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	a3 44 50 80 00       	mov    %eax,0x805044
  80238f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802394:	40                   	inc    %eax
  802395:	a3 4c 50 80 00       	mov    %eax,0x80504c
				break;
  80239a:	eb 39                	jmp    8023d5 <insert_sorted_allocList+0x28a>
	}
	else
	{
		struct MemBlock *current_block = head;
		struct MemBlock *next_block = NULL;
		LIST_FOREACH (current_block, &AllocMemBlocksList)
  80239c:	a1 48 50 80 00       	mov    0x805048,%eax
  8023a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a8:	74 07                	je     8023b1 <insert_sorted_allocList+0x266>
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 00                	mov    (%eax),%eax
  8023af:	eb 05                	jmp    8023b6 <insert_sorted_allocList+0x26b>
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b6:	a3 48 50 80 00       	mov    %eax,0x805048
  8023bb:	a1 48 50 80 00       	mov    0x805048,%eax
  8023c0:	85 c0                	test   %eax,%eax
  8023c2:	0f 85 3f ff ff ff    	jne    802307 <insert_sorted_allocList+0x1bc>
  8023c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cc:	0f 85 35 ff ff ff    	jne    802307 <insert_sorted_allocList+0x1bc>
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d2:	eb 01                	jmp    8023d5 <insert_sorted_allocList+0x28a>
	struct MemBlock *head = LIST_FIRST(&AllocMemBlocksList) ;
	struct MemBlock *tail = LIST_LAST(&AllocMemBlocksList) ;

	if (head == tail || blockToInsert->sva <= head->sva || blockToInsert->sva >= tail->sva )
	{
		if(head == NULL )
  8023d4:	90                   	nop
				LIST_INSERT_AFTER(&AllocMemBlocksList,current_block,blockToInsert);
				break;
			}
		}
	}
}
  8023d5:	90                   	nop
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  8023de:	a1 38 51 80 00       	mov    0x805138,%eax
  8023e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e6:	e9 85 01 00 00       	jmp    802570 <alloc_block_FF+0x198>
	{
		if(size <= point->size)
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f4:	0f 82 6e 01 00 00    	jb     802568 <alloc_block_FF+0x190>
		{
		   if(size == point->size){
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802400:	3b 45 08             	cmp    0x8(%ebp),%eax
  802403:	0f 85 8a 00 00 00    	jne    802493 <alloc_block_FF+0xbb>
			   LIST_REMOVE(&FreeMemBlocksList,point);
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	75 17                	jne    802426 <alloc_block_FF+0x4e>
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 44 40 80 00       	push   $0x804044
  802417:	68 93 00 00 00       	push   $0x93
  80241c:	68 9b 3f 80 00       	push   $0x803f9b
  802421:	e8 44 df ff ff       	call   80036a <_panic>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 10                	je     80243f <alloc_block_FF+0x67>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802437:	8b 52 04             	mov    0x4(%edx),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
  80243d:	eb 0b                	jmp    80244a <alloc_block_FF+0x72>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 04             	mov    0x4(%eax),%eax
  802445:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 0f                	je     802463 <alloc_block_FF+0x8b>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	8b 12                	mov    (%edx),%edx
  80245f:	89 10                	mov    %edx,(%eax)
  802461:	eb 0a                	jmp    80246d <alloc_block_FF+0x95>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	a3 38 51 80 00       	mov    %eax,0x805138
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802480:	a1 44 51 80 00       	mov    0x805144,%eax
  802485:	48                   	dec    %eax
  802486:	a3 44 51 80 00       	mov    %eax,0x805144
			   return  point;
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	e9 10 01 00 00       	jmp    8025a3 <alloc_block_FF+0x1cb>
			   break;
		   }
		   else if (size < point->size){
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249c:	0f 86 c6 00 00 00    	jbe    802568 <alloc_block_FF+0x190>
			   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  8024a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8024a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   ReturnedBlock->sva = point->sva;
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 50 08             	mov    0x8(%eax),%edx
  8024b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b3:	89 50 08             	mov    %edx,0x8(%eax)
			   ReturnedBlock->size = size;
  8024b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bc:	89 50 0c             	mov    %edx,0xc(%eax)
			   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8024bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c3:	75 17                	jne    8024dc <alloc_block_FF+0x104>
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	68 44 40 80 00       	push   $0x804044
  8024cd:	68 9b 00 00 00       	push   $0x9b
  8024d2:	68 9b 3f 80 00       	push   $0x803f9b
  8024d7:	e8 8e de ff ff       	call   80036a <_panic>
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 10                	je     8024f5 <alloc_block_FF+0x11d>
  8024e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ed:	8b 52 04             	mov    0x4(%edx),%edx
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	eb 0b                	jmp    802500 <alloc_block_FF+0x128>
  8024f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0f                	je     802519 <alloc_block_FF+0x141>
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802513:	8b 12                	mov    (%edx),%edx
  802515:	89 10                	mov    %edx,(%eax)
  802517:	eb 0a                	jmp    802523 <alloc_block_FF+0x14b>
  802519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	a3 48 51 80 00       	mov    %eax,0x805148
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802536:	a1 54 51 80 00       	mov    0x805154,%eax
  80253b:	48                   	dec    %eax
  80253c:	a3 54 51 80 00       	mov    %eax,0x805154
			   point->sva += size;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 50 08             	mov    0x8(%eax),%edx
  802547:	8b 45 08             	mov    0x8(%ebp),%eax
  80254a:	01 c2                	add    %eax,%edx
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	89 50 08             	mov    %edx,0x8(%eax)
			   point->size -= size;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 0c             	mov    0xc(%eax),%eax
  802558:	2b 45 08             	sub    0x8(%ebp),%eax
  80255b:	89 c2                	mov    %eax,%edx
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	89 50 0c             	mov    %edx,0xc(%eax)
			   return ReturnedBlock;
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	eb 3b                	jmp    8025a3 <alloc_block_FF+0x1cb>
struct MemBlock *alloc_block_FF(uint32 size)
{
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_FF
	// Write your code here, remove the panic and write your code
	struct MemBlock *point;
	LIST_FOREACH(point,&FreeMemBlocksList)
  802568:	a1 40 51 80 00       	mov    0x805140,%eax
  80256d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802574:	74 07                	je     80257d <alloc_block_FF+0x1a5>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 00                	mov    (%eax),%eax
  80257b:	eb 05                	jmp    802582 <alloc_block_FF+0x1aa>
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
  802582:	a3 40 51 80 00       	mov    %eax,0x805140
  802587:	a1 40 51 80 00       	mov    0x805140,%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	0f 85 57 fe ff ff    	jne    8023eb <alloc_block_FF+0x13>
  802594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802598:	0f 85 4d fe ff ff    	jne    8023eb <alloc_block_FF+0x13>
			   return ReturnedBlock;
			   break;
		   }
		}
	}
	return NULL;
  80259e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] alloc_block_BF
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
  8025ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  8025b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ba:	e9 df 00 00 00       	jmp    80269e <alloc_block_BF+0xf9>
	{
		if(size <= currentMemBlock->size)
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c8:	0f 82 c8 00 00 00    	jb     802696 <alloc_block_BF+0xf1>
		{
		   if(size == currentMemBlock->size)
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d7:	0f 85 8a 00 00 00    	jne    802667 <alloc_block_BF+0xc2>
		   {
			   LIST_REMOVE(&FreeMemBlocksList,currentMemBlock);
  8025dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e1:	75 17                	jne    8025fa <alloc_block_BF+0x55>
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	68 44 40 80 00       	push   $0x804044
  8025eb:	68 b7 00 00 00       	push   $0xb7
  8025f0:	68 9b 3f 80 00       	push   $0x803f9b
  8025f5:	e8 70 dd ff ff       	call   80036a <_panic>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	74 10                	je     802613 <alloc_block_BF+0x6e>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260b:	8b 52 04             	mov    0x4(%edx),%edx
  80260e:	89 50 04             	mov    %edx,0x4(%eax)
  802611:	eb 0b                	jmp    80261e <alloc_block_BF+0x79>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 0f                	je     802637 <alloc_block_BF+0x92>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802631:	8b 12                	mov    (%edx),%edx
  802633:	89 10                	mov    %edx,(%eax)
  802635:	eb 0a                	jmp    802641 <alloc_block_BF+0x9c>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	a3 38 51 80 00       	mov    %eax,0x805138
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802654:	a1 44 51 80 00       	mov    0x805144,%eax
  802659:	48                   	dec    %eax
  80265a:	a3 44 51 80 00       	mov    %eax,0x805144
			   return currentMemBlock;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	e9 4d 01 00 00       	jmp    8027b4 <alloc_block_BF+0x20f>
		   }
		   else if (size < currentMemBlock->size && currentMemBlock->size < minSize)
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 0c             	mov    0xc(%eax),%eax
  80266d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802670:	76 24                	jbe    802696 <alloc_block_BF+0xf1>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 40 0c             	mov    0xc(%eax),%eax
  802678:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80267b:	73 19                	jae    802696 <alloc_block_BF+0xf1>
		   {
			   isFound = 1==1;
  80267d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
			   minSize = currentMemBlock->size;
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 40 0c             	mov    0xc(%eax),%eax
  80268a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			   svaOfMinSize = currentMemBlock->sva;
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 40 08             	mov    0x8(%eax),%eax
  802693:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// Write your code here, remove the panic and write your code
	struct MemBlock *currentMemBlock;
	uint32 minSize;
	uint32 svaOfMinSize;
	bool isFound = 1==0;
	LIST_FOREACH(currentMemBlock,&FreeMemBlocksList)
  802696:	a1 40 51 80 00       	mov    0x805140,%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	74 07                	je     8026ab <alloc_block_BF+0x106>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	eb 05                	jmp    8026b0 <alloc_block_BF+0x10b>
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	a3 40 51 80 00       	mov    %eax,0x805140
  8026b5:	a1 40 51 80 00       	mov    0x805140,%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	0f 85 fd fe ff ff    	jne    8025bf <alloc_block_BF+0x1a>
  8026c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c6:	0f 85 f3 fe ff ff    	jne    8025bf <alloc_block_BF+0x1a>
			   minSize = currentMemBlock->size;
			   svaOfMinSize = currentMemBlock->sva;
		   }
		}
	}
	if(isFound)
  8026cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026d0:	0f 84 d9 00 00 00    	je     8027af <alloc_block_BF+0x20a>
	{
		struct MemBlock * foundBlock = LIST_FIRST(&AvailableMemBlocksList);
  8026d6:	a1 48 51 80 00       	mov    0x805148,%eax
  8026db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		foundBlock->sva = svaOfMinSize;
  8026de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e4:	89 50 08             	mov    %edx,0x8(%eax)
		foundBlock->size = size;
  8026e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ed:	89 50 0c             	mov    %edx,0xc(%eax)
		LIST_REMOVE(&AvailableMemBlocksList,foundBlock);
  8026f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8026f4:	75 17                	jne    80270d <alloc_block_BF+0x168>
  8026f6:	83 ec 04             	sub    $0x4,%esp
  8026f9:	68 44 40 80 00       	push   $0x804044
  8026fe:	68 c7 00 00 00       	push   $0xc7
  802703:	68 9b 3f 80 00       	push   $0x803f9b
  802708:	e8 5d dc ff ff       	call   80036a <_panic>
  80270d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802710:	8b 00                	mov    (%eax),%eax
  802712:	85 c0                	test   %eax,%eax
  802714:	74 10                	je     802726 <alloc_block_BF+0x181>
  802716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802719:	8b 00                	mov    (%eax),%eax
  80271b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80271e:	8b 52 04             	mov    0x4(%edx),%edx
  802721:	89 50 04             	mov    %edx,0x4(%eax)
  802724:	eb 0b                	jmp    802731 <alloc_block_BF+0x18c>
  802726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802731:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	85 c0                	test   %eax,%eax
  802739:	74 0f                	je     80274a <alloc_block_BF+0x1a5>
  80273b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80273e:	8b 40 04             	mov    0x4(%eax),%eax
  802741:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802744:	8b 12                	mov    (%edx),%edx
  802746:	89 10                	mov    %edx,(%eax)
  802748:	eb 0a                	jmp    802754 <alloc_block_BF+0x1af>
  80274a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	a3 48 51 80 00       	mov    %eax,0x805148
  802754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802757:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80275d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802760:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802767:	a1 54 51 80 00       	mov    0x805154,%eax
  80276c:	48                   	dec    %eax
  80276d:	a3 54 51 80 00       	mov    %eax,0x805154
		struct MemBlock *cMemBlock = find_block(&FreeMemBlocksList, svaOfMinSize);
  802772:	83 ec 08             	sub    $0x8,%esp
  802775:	ff 75 ec             	pushl  -0x14(%ebp)
  802778:	68 38 51 80 00       	push   $0x805138
  80277d:	e8 71 f9 ff ff       	call   8020f3 <find_block>
  802782:	83 c4 10             	add    $0x10,%esp
  802785:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cMemBlock->sva += size;
  802788:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278b:	8b 50 08             	mov    0x8(%eax),%edx
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	01 c2                	add    %eax,%edx
  802793:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802796:	89 50 08             	mov    %edx,0x8(%eax)
		cMemBlock->size -= size;
  802799:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a2:	89 c2                	mov    %eax,%edx
  8027a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a7:	89 50 0c             	mov    %edx,0xc(%eax)
		return foundBlock;
  8027aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027ad:	eb 05                	jmp    8027b4 <alloc_block_BF+0x20f>
	}
	return NULL;
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <alloc_block_NF>:
uint32 svaOfNF = 0;
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
  8027bc:	a1 28 50 80 00       	mov    0x805028,%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	0f 85 de 01 00 00    	jne    8029a7 <alloc_block_NF+0x1f1>
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  8027c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d1:	e9 9e 01 00 00       	jmp    802974 <alloc_block_NF+0x1be>
		{
			if(size <= point->size)
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027df:	0f 82 87 01 00 00    	jb     80296c <alloc_block_NF+0x1b6>
			{
			   if(size == point->size){
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ee:	0f 85 95 00 00 00    	jne    802889 <alloc_block_NF+0xd3>
				   LIST_REMOVE(&FreeMemBlocksList,point);
  8027f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f8:	75 17                	jne    802811 <alloc_block_NF+0x5b>
  8027fa:	83 ec 04             	sub    $0x4,%esp
  8027fd:	68 44 40 80 00       	push   $0x804044
  802802:	68 e0 00 00 00       	push   $0xe0
  802807:	68 9b 3f 80 00       	push   $0x803f9b
  80280c:	e8 59 db ff ff       	call   80036a <_panic>
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	85 c0                	test   %eax,%eax
  802818:	74 10                	je     80282a <alloc_block_NF+0x74>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802822:	8b 52 04             	mov    0x4(%edx),%edx
  802825:	89 50 04             	mov    %edx,0x4(%eax)
  802828:	eb 0b                	jmp    802835 <alloc_block_NF+0x7f>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 40 04             	mov    0x4(%eax),%eax
  802830:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	85 c0                	test   %eax,%eax
  80283d:	74 0f                	je     80284e <alloc_block_NF+0x98>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802848:	8b 12                	mov    (%edx),%edx
  80284a:	89 10                	mov    %edx,(%eax)
  80284c:	eb 0a                	jmp    802858 <alloc_block_NF+0xa2>
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	a3 38 51 80 00       	mov    %eax,0x805138
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286b:	a1 44 51 80 00       	mov    0x805144,%eax
  802870:	48                   	dec    %eax
  802871:	a3 44 51 80 00       	mov    %eax,0x805144
				   svaOfNF = point->sva;
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 08             	mov    0x8(%eax),%eax
  80287c:	a3 28 50 80 00       	mov    %eax,0x805028
				   return  point;
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	e9 f8 04 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
				   break;
			   }
			   else if (size < point->size){
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	8b 40 0c             	mov    0xc(%eax),%eax
  80288f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802892:	0f 86 d4 00 00 00    	jbe    80296c <alloc_block_NF+0x1b6>
				   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802898:	a1 48 51 80 00       	mov    0x805148,%eax
  80289d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				   ReturnedBlock->sva = point->sva;
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 50 08             	mov    0x8(%eax),%edx
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	89 50 08             	mov    %edx,0x8(%eax)
				   ReturnedBlock->size = size;
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b2:	89 50 0c             	mov    %edx,0xc(%eax)
				   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  8028b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b9:	75 17                	jne    8028d2 <alloc_block_NF+0x11c>
  8028bb:	83 ec 04             	sub    $0x4,%esp
  8028be:	68 44 40 80 00       	push   $0x804044
  8028c3:	68 e9 00 00 00       	push   $0xe9
  8028c8:	68 9b 3f 80 00       	push   $0x803f9b
  8028cd:	e8 98 da ff ff       	call   80036a <_panic>
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 10                	je     8028eb <alloc_block_NF+0x135>
  8028db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e3:	8b 52 04             	mov    0x4(%edx),%edx
  8028e6:	89 50 04             	mov    %edx,0x4(%eax)
  8028e9:	eb 0b                	jmp    8028f6 <alloc_block_NF+0x140>
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	74 0f                	je     80290f <alloc_block_NF+0x159>
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	8b 40 04             	mov    0x4(%eax),%eax
  802906:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802909:	8b 12                	mov    (%edx),%edx
  80290b:	89 10                	mov    %edx,(%eax)
  80290d:	eb 0a                	jmp    802919 <alloc_block_NF+0x163>
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	a3 48 51 80 00       	mov    %eax,0x805148
  802919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292c:	a1 54 51 80 00       	mov    0x805154,%eax
  802931:	48                   	dec    %eax
  802932:	a3 54 51 80 00       	mov    %eax,0x805154
				   svaOfNF = ReturnedBlock->sva;
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 08             	mov    0x8(%eax),%eax
  80293d:	a3 28 50 80 00       	mov    %eax,0x805028
				   point->sva += size;
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	8b 50 08             	mov    0x8(%eax),%edx
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	01 c2                	add    %eax,%edx
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	89 50 08             	mov    %edx,0x8(%eax)
				   point->size -= size;
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	8b 40 0c             	mov    0xc(%eax),%eax
  802959:	2b 45 08             	sub    0x8(%ebp),%eax
  80295c:	89 c2                	mov    %eax,%edx
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	89 50 0c             	mov    %edx,0xc(%eax)
				   return ReturnedBlock;
  802964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802967:	e9 15 04 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your codestruct MemBlock *point;
	struct MemBlock *point;
	if(svaOfNF == 0)
	{
		LIST_FOREACH(point,&FreeMemBlocksList)
  80296c:	a1 40 51 80 00       	mov    0x805140,%eax
  802971:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802974:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802978:	74 07                	je     802981 <alloc_block_NF+0x1cb>
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 00                	mov    (%eax),%eax
  80297f:	eb 05                	jmp    802986 <alloc_block_NF+0x1d0>
  802981:	b8 00 00 00 00       	mov    $0x0,%eax
  802986:	a3 40 51 80 00       	mov    %eax,0x805140
  80298b:	a1 40 51 80 00       	mov    0x805140,%eax
  802990:	85 c0                	test   %eax,%eax
  802992:	0f 85 3e fe ff ff    	jne    8027d6 <alloc_block_NF+0x20>
  802998:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299c:	0f 85 34 fe ff ff    	jne    8027d6 <alloc_block_NF+0x20>
  8029a2:	e9 d5 03 00 00       	jmp    802d7c <alloc_block_NF+0x5c6>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  8029a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8029ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029af:	e9 b1 01 00 00       	jmp    802b65 <alloc_block_NF+0x3af>
		{
			if(point->sva >= svaOfNF)
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ba:	a1 28 50 80 00       	mov    0x805028,%eax
  8029bf:	39 c2                	cmp    %eax,%edx
  8029c1:	0f 82 96 01 00 00    	jb     802b5d <alloc_block_NF+0x3a7>
			{
				if(size <= point->size)
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8029cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d0:	0f 82 87 01 00 00    	jb     802b5d <alloc_block_NF+0x3a7>
				{
				   if(size == point->size){
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8029dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029df:	0f 85 95 00 00 00    	jne    802a7a <alloc_block_NF+0x2c4>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  8029e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e9:	75 17                	jne    802a02 <alloc_block_NF+0x24c>
  8029eb:	83 ec 04             	sub    $0x4,%esp
  8029ee:	68 44 40 80 00       	push   $0x804044
  8029f3:	68 fc 00 00 00       	push   $0xfc
  8029f8:	68 9b 3f 80 00       	push   $0x803f9b
  8029fd:	e8 68 d9 ff ff       	call   80036a <_panic>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	85 c0                	test   %eax,%eax
  802a09:	74 10                	je     802a1b <alloc_block_NF+0x265>
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a13:	8b 52 04             	mov    0x4(%edx),%edx
  802a16:	89 50 04             	mov    %edx,0x4(%eax)
  802a19:	eb 0b                	jmp    802a26 <alloc_block_NF+0x270>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 40 04             	mov    0x4(%eax),%eax
  802a21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 0f                	je     802a3f <alloc_block_NF+0x289>
  802a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a33:	8b 40 04             	mov    0x4(%eax),%eax
  802a36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a39:	8b 12                	mov    (%edx),%edx
  802a3b:	89 10                	mov    %edx,(%eax)
  802a3d:	eb 0a                	jmp    802a49 <alloc_block_NF+0x293>
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	8b 00                	mov    (%eax),%eax
  802a44:	a3 38 51 80 00       	mov    %eax,0x805138
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802a61:	48                   	dec    %eax
  802a62:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 40 08             	mov    0x8(%eax),%eax
  802a6d:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	e9 07 03 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a80:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a83:	0f 86 d4 00 00 00    	jbe    802b5d <alloc_block_NF+0x3a7>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802a89:	a1 48 51 80 00       	mov    0x805148,%eax
  802a8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
					   ReturnedBlock->sva = point->sva;
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 50 08             	mov    0x8(%eax),%edx
  802a97:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9a:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802a9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa3:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802aa6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aaa:	75 17                	jne    802ac3 <alloc_block_NF+0x30d>
  802aac:	83 ec 04             	sub    $0x4,%esp
  802aaf:	68 44 40 80 00       	push   $0x804044
  802ab4:	68 04 01 00 00       	push   $0x104
  802ab9:	68 9b 3f 80 00       	push   $0x803f9b
  802abe:	e8 a7 d8 ff ff       	call   80036a <_panic>
  802ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 10                	je     802adc <alloc_block_NF+0x326>
  802acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acf:	8b 00                	mov    (%eax),%eax
  802ad1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad4:	8b 52 04             	mov    0x4(%edx),%edx
  802ad7:	89 50 04             	mov    %edx,0x4(%eax)
  802ada:	eb 0b                	jmp    802ae7 <alloc_block_NF+0x331>
  802adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802adf:	8b 40 04             	mov    0x4(%eax),%eax
  802ae2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 0f                	je     802b00 <alloc_block_NF+0x34a>
  802af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af4:	8b 40 04             	mov    0x4(%eax),%eax
  802af7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802afa:	8b 12                	mov    (%edx),%edx
  802afc:	89 10                	mov    %edx,(%eax)
  802afe:	eb 0a                	jmp    802b0a <alloc_block_NF+0x354>
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	8b 00                	mov    (%eax),%eax
  802b05:	a3 48 51 80 00       	mov    %eax,0x805148
  802b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1d:	a1 54 51 80 00       	mov    0x805154,%eax
  802b22:	48                   	dec    %eax
  802b23:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2b:	8b 40 08             	mov    0x8(%eax),%eax
  802b2e:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 50 08             	mov    0x8(%eax),%edx
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	01 c2                	add    %eax,%edx
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	2b 45 08             	sub    0x8(%ebp),%eax
  802b4d:	89 c2                	mov    %eax,%edx
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802b55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b58:	e9 24 02 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
			}
		}
	}
	else
	{
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b5d:	a1 40 51 80 00       	mov    0x805140,%eax
  802b62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b69:	74 07                	je     802b72 <alloc_block_NF+0x3bc>
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	eb 05                	jmp    802b77 <alloc_block_NF+0x3c1>
  802b72:	b8 00 00 00 00       	mov    $0x0,%eax
  802b77:	a3 40 51 80 00       	mov    %eax,0x805140
  802b7c:	a1 40 51 80 00       	mov    0x805140,%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	0f 85 2b fe ff ff    	jne    8029b4 <alloc_block_NF+0x1fe>
  802b89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8d:	0f 85 21 fe ff ff    	jne    8029b4 <alloc_block_NF+0x1fe>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802b93:	a1 38 51 80 00       	mov    0x805138,%eax
  802b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9b:	e9 ae 01 00 00       	jmp    802d4e <alloc_block_NF+0x598>
		{
			if(point->sva < svaOfNF)
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 50 08             	mov    0x8(%eax),%edx
  802ba6:	a1 28 50 80 00       	mov    0x805028,%eax
  802bab:	39 c2                	cmp    %eax,%edx
  802bad:	0f 83 93 01 00 00    	jae    802d46 <alloc_block_NF+0x590>
			{
				if(size <= point->size)
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bbc:	0f 82 84 01 00 00    	jb     802d46 <alloc_block_NF+0x590>
				{
				   if(size == point->size){
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bcb:	0f 85 95 00 00 00    	jne    802c66 <alloc_block_NF+0x4b0>
					   LIST_REMOVE(&FreeMemBlocksList,point);
  802bd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd5:	75 17                	jne    802bee <alloc_block_NF+0x438>
  802bd7:	83 ec 04             	sub    $0x4,%esp
  802bda:	68 44 40 80 00       	push   $0x804044
  802bdf:	68 14 01 00 00       	push   $0x114
  802be4:	68 9b 3f 80 00       	push   $0x803f9b
  802be9:	e8 7c d7 ff ff       	call   80036a <_panic>
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	74 10                	je     802c07 <alloc_block_NF+0x451>
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bff:	8b 52 04             	mov    0x4(%edx),%edx
  802c02:	89 50 04             	mov    %edx,0x4(%eax)
  802c05:	eb 0b                	jmp    802c12 <alloc_block_NF+0x45c>
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 40 04             	mov    0x4(%eax),%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	74 0f                	je     802c2b <alloc_block_NF+0x475>
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c25:	8b 12                	mov    (%edx),%edx
  802c27:	89 10                	mov    %edx,(%eax)
  802c29:	eb 0a                	jmp    802c35 <alloc_block_NF+0x47f>
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	a3 38 51 80 00       	mov    %eax,0x805138
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c48:	a1 44 51 80 00       	mov    0x805144,%eax
  802c4d:	48                   	dec    %eax
  802c4e:	a3 44 51 80 00       	mov    %eax,0x805144
					   svaOfNF = point->sva;
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 08             	mov    0x8(%eax),%eax
  802c59:	a3 28 50 80 00       	mov    %eax,0x805028
					   return  point;
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	e9 1b 01 00 00       	jmp    802d81 <alloc_block_NF+0x5cb>
				   }
				   else if (size < point->size){
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c6f:	0f 86 d1 00 00 00    	jbe    802d46 <alloc_block_NF+0x590>
					   struct MemBlock * ReturnedBlock = LIST_FIRST(&AvailableMemBlocksList);
  802c75:	a1 48 51 80 00       	mov    0x805148,%eax
  802c7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
					   ReturnedBlock->sva = point->sva;
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 50 08             	mov    0x8(%eax),%edx
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c86:	89 50 08             	mov    %edx,0x8(%eax)
					   ReturnedBlock->size = size;
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8f:	89 50 0c             	mov    %edx,0xc(%eax)
					   LIST_REMOVE(&AvailableMemBlocksList,ReturnedBlock);
  802c92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c96:	75 17                	jne    802caf <alloc_block_NF+0x4f9>
  802c98:	83 ec 04             	sub    $0x4,%esp
  802c9b:	68 44 40 80 00       	push   $0x804044
  802ca0:	68 1c 01 00 00       	push   $0x11c
  802ca5:	68 9b 3f 80 00       	push   $0x803f9b
  802caa:	e8 bb d6 ff ff       	call   80036a <_panic>
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	74 10                	je     802cc8 <alloc_block_NF+0x512>
  802cb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cc0:	8b 52 04             	mov    0x4(%edx),%edx
  802cc3:	89 50 04             	mov    %edx,0x4(%eax)
  802cc6:	eb 0b                	jmp    802cd3 <alloc_block_NF+0x51d>
  802cc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd6:	8b 40 04             	mov    0x4(%eax),%eax
  802cd9:	85 c0                	test   %eax,%eax
  802cdb:	74 0f                	je     802cec <alloc_block_NF+0x536>
  802cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce0:	8b 40 04             	mov    0x4(%eax),%eax
  802ce3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce6:	8b 12                	mov    (%edx),%edx
  802ce8:	89 10                	mov    %edx,(%eax)
  802cea:	eb 0a                	jmp    802cf6 <alloc_block_NF+0x540>
  802cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cef:	8b 00                	mov    (%eax),%eax
  802cf1:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d09:	a1 54 51 80 00       	mov    0x805154,%eax
  802d0e:	48                   	dec    %eax
  802d0f:	a3 54 51 80 00       	mov    %eax,0x805154
					   svaOfNF = ReturnedBlock->sva;
  802d14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d17:	8b 40 08             	mov    0x8(%eax),%eax
  802d1a:	a3 28 50 80 00       	mov    %eax,0x805028
					   point->sva += size;
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	01 c2                	add    %eax,%edx
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	89 50 08             	mov    %edx,0x8(%eax)
					   point->size -= size;
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 40 0c             	mov    0xc(%eax),%eax
  802d36:	2b 45 08             	sub    0x8(%ebp),%eax
  802d39:	89 c2                	mov    %eax,%edx
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	89 50 0c             	mov    %edx,0xc(%eax)
					   return ReturnedBlock;
  802d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d44:	eb 3b                	jmp    802d81 <alloc_block_NF+0x5cb>
					   return ReturnedBlock;
				   }
				}
			}
		}
		LIST_FOREACH(point, &FreeMemBlocksList)
  802d46:	a1 40 51 80 00       	mov    0x805140,%eax
  802d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d52:	74 07                	je     802d5b <alloc_block_NF+0x5a5>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	eb 05                	jmp    802d60 <alloc_block_NF+0x5aa>
  802d5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d60:	a3 40 51 80 00       	mov    %eax,0x805140
  802d65:	a1 40 51 80 00       	mov    0x805140,%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	0f 85 2e fe ff ff    	jne    802ba0 <alloc_block_NF+0x3ea>
  802d72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d76:	0f 85 24 fe ff ff    	jne    802ba0 <alloc_block_NF+0x3ea>
				   }
				}
			}
		}
	}
	return NULL;
  802d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d81:	c9                   	leave  
  802d82:	c3                   	ret    

00802d83 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d83:	55                   	push   %ebp
  802d84:	89 e5                	mov    %esp,%ebp
  802d86:	83 ec 18             	sub    $0x18,%esp
	//cprintf("BEFORE INSERT with MERGE: insert [%x, %x)\n=====================\n", blockToInsert->sva, blockToInsert->sva + blockToInsert->size);
	//print_mem_block_lists() ;

	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] insert_sorted_with_merge_freeList
	// Write your code here, remove the panic and write your code
	struct MemBlock *head = LIST_FIRST(&FreeMemBlocksList) ;
  802d89:	a1 38 51 80 00       	mov    0x805138,%eax
  802d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;
  802d91:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d96:	89 45 ec             	mov    %eax,-0x14(%ebp)

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
  802d99:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9e:	85 c0                	test   %eax,%eax
  802da0:	74 14                	je     802db6 <insert_sorted_with_merge_freeList+0x33>
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dab:	8b 40 08             	mov    0x8(%eax),%eax
  802dae:	39 c2                	cmp    %eax,%edx
  802db0:	0f 87 9b 01 00 00    	ja     802f51 <insert_sorted_with_merge_freeList+0x1ce>
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
  802db6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dba:	75 17                	jne    802dd3 <insert_sorted_with_merge_freeList+0x50>
  802dbc:	83 ec 04             	sub    $0x4,%esp
  802dbf:	68 78 3f 80 00       	push   $0x803f78
  802dc4:	68 38 01 00 00       	push   $0x138
  802dc9:	68 9b 3f 80 00       	push   $0x803f9b
  802dce:	e8 97 d5 ff ff       	call   80036a <_panic>
  802dd3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	89 10                	mov    %edx,(%eax)
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 0d                	je     802df4 <insert_sorted_with_merge_freeList+0x71>
  802de7:	a1 38 51 80 00       	mov    0x805138,%eax
  802dec:	8b 55 08             	mov    0x8(%ebp),%edx
  802def:	89 50 04             	mov    %edx,0x4(%eax)
  802df2:	eb 08                	jmp    802dfc <insert_sorted_with_merge_freeList+0x79>
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	a3 38 51 80 00       	mov    %eax,0x805138
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e13:	40                   	inc    %eax
  802e14:	a3 44 51 80 00       	mov    %eax,0x805144
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802e19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e1d:	0f 84 a8 06 00 00    	je     8034cb <insert_sorted_with_merge_freeList+0x748>
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	8b 50 08             	mov    0x8(%eax),%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2f:	01 c2                	add    %eax,%edx
  802e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e34:	8b 40 08             	mov    0x8(%eax),%eax
  802e37:	39 c2                	cmp    %eax,%edx
  802e39:	0f 85 8c 06 00 00    	jne    8034cb <insert_sorted_with_merge_freeList+0x748>
		{
			blockToInsert->size += head->size;
  802e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e42:	8b 50 0c             	mov    0xc(%eax),%edx
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4b:	01 c2                	add    %eax,%edx
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	89 50 0c             	mov    %edx,0xc(%eax)
			LIST_REMOVE(&FreeMemBlocksList, head);
  802e53:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e57:	75 17                	jne    802e70 <insert_sorted_with_merge_freeList+0xed>
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	68 44 40 80 00       	push   $0x804044
  802e61:	68 3c 01 00 00       	push   $0x13c
  802e66:	68 9b 3f 80 00       	push   $0x803f9b
  802e6b:	e8 fa d4 ff ff       	call   80036a <_panic>
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	8b 00                	mov    (%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 10                	je     802e89 <insert_sorted_with_merge_freeList+0x106>
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e81:	8b 52 04             	mov    0x4(%edx),%edx
  802e84:	89 50 04             	mov    %edx,0x4(%eax)
  802e87:	eb 0b                	jmp    802e94 <insert_sorted_with_merge_freeList+0x111>
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e97:	8b 40 04             	mov    0x4(%eax),%eax
  802e9a:	85 c0                	test   %eax,%eax
  802e9c:	74 0f                	je     802ead <insert_sorted_with_merge_freeList+0x12a>
  802e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea1:	8b 40 04             	mov    0x4(%eax),%eax
  802ea4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ea7:	8b 12                	mov    (%edx),%edx
  802ea9:	89 10                	mov    %edx,(%eax)
  802eab:	eb 0a                	jmp    802eb7 <insert_sorted_with_merge_freeList+0x134>
  802ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eca:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecf:	48                   	dec    %eax
  802ed0:	a3 44 51 80 00       	mov    %eax,0x805144
			head->size = 0;
  802ed5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			head->sva = 0;
  802edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
  802ee9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802eed:	75 17                	jne    802f06 <insert_sorted_with_merge_freeList+0x183>
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	68 78 3f 80 00       	push   $0x803f78
  802ef7:	68 3f 01 00 00       	push   $0x13f
  802efc:	68 9b 3f 80 00       	push   $0x803f9b
  802f01:	e8 64 d4 ff ff       	call   80036a <_panic>
  802f06:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0f:	89 10                	mov    %edx,(%eax)
  802f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	74 0d                	je     802f27 <insert_sorted_with_merge_freeList+0x1a4>
  802f1a:	a1 48 51 80 00       	mov    0x805148,%eax
  802f1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f22:	89 50 04             	mov    %edx,0x4(%eax)
  802f25:	eb 08                	jmp    802f2f <insert_sorted_with_merge_freeList+0x1ac>
  802f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f32:	a3 48 51 80 00       	mov    %eax,0x805148
  802f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f41:	a1 54 51 80 00       	mov    0x805154,%eax
  802f46:	40                   	inc    %eax
  802f47:	a3 54 51 80 00       	mov    %eax,0x805154
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  802f4c:	e9 7a 05 00 00       	jmp    8034cb <insert_sorted_with_merge_freeList+0x748>
			head->size = 0;
			head->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, head);
		}
	}
	else if (blockToInsert->sva >= tail->sva)
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	8b 50 08             	mov    0x8(%eax),%edx
  802f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5a:	8b 40 08             	mov    0x8(%eax),%eax
  802f5d:	39 c2                	cmp    %eax,%edx
  802f5f:	0f 82 14 01 00 00    	jb     803079 <insert_sorted_with_merge_freeList+0x2f6>
	{
		if(tail->sva + tail->size == blockToInsert->sva)
  802f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f68:	8b 50 08             	mov    0x8(%eax),%edx
  802f6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f71:	01 c2                	add    %eax,%edx
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 40 08             	mov    0x8(%eax),%eax
  802f79:	39 c2                	cmp    %eax,%edx
  802f7b:	0f 85 90 00 00 00    	jne    803011 <insert_sorted_with_merge_freeList+0x28e>
		{
			tail->size += blockToInsert->size;
  802f81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f84:	8b 50 0c             	mov    0xc(%eax),%edx
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8d:	01 c2                	add    %eax,%edx
  802f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f92:	89 50 0c             	mov    %edx,0xc(%eax)
			blockToInsert->size = 0;
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
			blockToInsert->sva = 0;
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  802fa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fad:	75 17                	jne    802fc6 <insert_sorted_with_merge_freeList+0x243>
  802faf:	83 ec 04             	sub    $0x4,%esp
  802fb2:	68 78 3f 80 00       	push   $0x803f78
  802fb7:	68 49 01 00 00       	push   $0x149
  802fbc:	68 9b 3f 80 00       	push   $0x803f9b
  802fc1:	e8 a4 d3 ff ff       	call   80036a <_panic>
  802fc6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcf:	89 10                	mov    %edx,(%eax)
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 0d                	je     802fe7 <insert_sorted_with_merge_freeList+0x264>
  802fda:	a1 48 51 80 00       	mov    0x805148,%eax
  802fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe2:	89 50 04             	mov    %edx,0x4(%eax)
  802fe5:	eb 08                	jmp    802fef <insert_sorted_with_merge_freeList+0x26c>
  802fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803001:	a1 54 51 80 00       	mov    0x805154,%eax
  803006:	40                   	inc    %eax
  803007:	a3 54 51 80 00       	mov    %eax,0x805154
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  80300c:	e9 bb 04 00 00       	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
			blockToInsert->size = 0;
			blockToInsert->sva = 0;
			LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
		}
		else
			LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803011:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803015:	75 17                	jne    80302e <insert_sorted_with_merge_freeList+0x2ab>
  803017:	83 ec 04             	sub    $0x4,%esp
  80301a:	68 ec 3f 80 00       	push   $0x803fec
  80301f:	68 4c 01 00 00       	push   $0x14c
  803024:	68 9b 3f 80 00       	push   $0x803f9b
  803029:	e8 3c d3 ff ff       	call   80036a <_panic>
  80302e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	89 50 04             	mov    %edx,0x4(%eax)
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	8b 40 04             	mov    0x4(%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 0c                	je     803050 <insert_sorted_with_merge_freeList+0x2cd>
  803044:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803049:	8b 55 08             	mov    0x8(%ebp),%edx
  80304c:	89 10                	mov    %edx,(%eax)
  80304e:	eb 08                	jmp    803058 <insert_sorted_with_merge_freeList+0x2d5>
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	a3 38 51 80 00       	mov    %eax,0x805138
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803069:	a1 44 51 80 00       	mov    0x805144,%eax
  80306e:	40                   	inc    %eax
  80306f:	a3 44 51 80 00       	mov    %eax,0x805144
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  803074:	e9 53 04 00 00       	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803079:	a1 38 51 80 00       	mov    0x805138,%eax
  80307e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803081:	e9 15 04 00 00       	jmp    80349b <insert_sorted_with_merge_freeList+0x718>
		{
			nextBlock = LIST_NEXT(currentBlock);
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	8b 00                	mov    (%eax),%eax
  80308b:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if(blockToInsert->sva > currentBlock->sva && blockToInsert->sva < nextBlock->sva)
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	8b 50 08             	mov    0x8(%eax),%edx
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 40 08             	mov    0x8(%eax),%eax
  80309a:	39 c2                	cmp    %eax,%edx
  80309c:	0f 86 f1 03 00 00    	jbe    803493 <insert_sorted_with_merge_freeList+0x710>
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 50 08             	mov    0x8(%eax),%edx
  8030a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ab:	8b 40 08             	mov    0x8(%eax),%eax
  8030ae:	39 c2                	cmp    %eax,%edx
  8030b0:	0f 83 dd 03 00 00    	jae    803493 <insert_sorted_with_merge_freeList+0x710>
			{
				if(currentBlock->sva + currentBlock->size == blockToInsert->sva)
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	8b 50 08             	mov    0x8(%eax),%edx
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c2:	01 c2                	add    %eax,%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ca:	39 c2                	cmp    %eax,%edx
  8030cc:	0f 85 b9 01 00 00    	jne    80328b <insert_sorted_with_merge_freeList+0x508>
				{
					if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	8b 50 08             	mov    0x8(%eax),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 0c             	mov    0xc(%eax),%eax
  8030de:	01 c2                	add    %eax,%edx
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	8b 40 08             	mov    0x8(%eax),%eax
  8030e6:	39 c2                	cmp    %eax,%edx
  8030e8:	0f 85 0d 01 00 00    	jne    8031fb <insert_sorted_with_merge_freeList+0x478>
					{
						currentBlock->size += nextBlock->size;
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030fa:	01 c2                	add    %eax,%edx
  8030fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ff:	89 50 0c             	mov    %edx,0xc(%eax)
						LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803102:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803106:	75 17                	jne    80311f <insert_sorted_with_merge_freeList+0x39c>
  803108:	83 ec 04             	sub    $0x4,%esp
  80310b:	68 44 40 80 00       	push   $0x804044
  803110:	68 5c 01 00 00       	push   $0x15c
  803115:	68 9b 3f 80 00       	push   $0x803f9b
  80311a:	e8 4b d2 ff ff       	call   80036a <_panic>
  80311f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803122:	8b 00                	mov    (%eax),%eax
  803124:	85 c0                	test   %eax,%eax
  803126:	74 10                	je     803138 <insert_sorted_with_merge_freeList+0x3b5>
  803128:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803130:	8b 52 04             	mov    0x4(%edx),%edx
  803133:	89 50 04             	mov    %edx,0x4(%eax)
  803136:	eb 0b                	jmp    803143 <insert_sorted_with_merge_freeList+0x3c0>
  803138:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313b:	8b 40 04             	mov    0x4(%eax),%eax
  80313e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803143:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803146:	8b 40 04             	mov    0x4(%eax),%eax
  803149:	85 c0                	test   %eax,%eax
  80314b:	74 0f                	je     80315c <insert_sorted_with_merge_freeList+0x3d9>
  80314d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803150:	8b 40 04             	mov    0x4(%eax),%eax
  803153:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803156:	8b 12                	mov    (%edx),%edx
  803158:	89 10                	mov    %edx,(%eax)
  80315a:	eb 0a                	jmp    803166 <insert_sorted_with_merge_freeList+0x3e3>
  80315c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	a3 38 51 80 00       	mov    %eax,0x805138
  803166:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80316f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803172:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803179:	a1 44 51 80 00       	mov    0x805144,%eax
  80317e:	48                   	dec    %eax
  80317f:	a3 44 51 80 00       	mov    %eax,0x805144
						nextBlock->sva = 0;
  803184:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803187:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
						nextBlock->size = 0;
  80318e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803191:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
						LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  803198:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80319c:	75 17                	jne    8031b5 <insert_sorted_with_merge_freeList+0x432>
  80319e:	83 ec 04             	sub    $0x4,%esp
  8031a1:	68 78 3f 80 00       	push   $0x803f78
  8031a6:	68 5f 01 00 00       	push   $0x15f
  8031ab:	68 9b 3f 80 00       	push   $0x803f9b
  8031b0:	e8 b5 d1 ff ff       	call   80036a <_panic>
  8031b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031be:	89 10                	mov    %edx,(%eax)
  8031c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	85 c0                	test   %eax,%eax
  8031c7:	74 0d                	je     8031d6 <insert_sorted_with_merge_freeList+0x453>
  8031c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d1:	89 50 04             	mov    %edx,0x4(%eax)
  8031d4:	eb 08                	jmp    8031de <insert_sorted_with_merge_freeList+0x45b>
  8031d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8031e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f5:	40                   	inc    %eax
  8031f6:	a3 54 51 80 00       	mov    %eax,0x805154
					}
					currentBlock->size += blockToInsert->size;
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	8b 50 0c             	mov    0xc(%eax),%edx
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	8b 40 0c             	mov    0xc(%eax),%eax
  803207:	01 c2                	add    %eax,%edx
  803209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->sva = 0;
  80320f:	8b 45 08             	mov    0x8(%ebp),%eax
  803212:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					blockToInsert->size = 0;
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert);
  803223:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803227:	75 17                	jne    803240 <insert_sorted_with_merge_freeList+0x4bd>
  803229:	83 ec 04             	sub    $0x4,%esp
  80322c:	68 78 3f 80 00       	push   $0x803f78
  803231:	68 64 01 00 00       	push   $0x164
  803236:	68 9b 3f 80 00       	push   $0x803f9b
  80323b:	e8 2a d1 ff ff       	call   80036a <_panic>
  803240:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	89 10                	mov    %edx,(%eax)
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	8b 00                	mov    (%eax),%eax
  803250:	85 c0                	test   %eax,%eax
  803252:	74 0d                	je     803261 <insert_sorted_with_merge_freeList+0x4de>
  803254:	a1 48 51 80 00       	mov    0x805148,%eax
  803259:	8b 55 08             	mov    0x8(%ebp),%edx
  80325c:	89 50 04             	mov    %edx,0x4(%eax)
  80325f:	eb 08                	jmp    803269 <insert_sorted_with_merge_freeList+0x4e6>
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	a3 48 51 80 00       	mov    %eax,0x805148
  803271:	8b 45 08             	mov    0x8(%ebp),%eax
  803274:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80327b:	a1 54 51 80 00       	mov    0x805154,%eax
  803280:	40                   	inc    %eax
  803281:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  803286:	e9 41 02 00 00       	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
				}
				else if(blockToInsert->sva + blockToInsert->size == nextBlock->sva)
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 50 08             	mov    0x8(%eax),%edx
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	8b 40 0c             	mov    0xc(%eax),%eax
  803297:	01 c2                	add    %eax,%edx
  803299:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329c:	8b 40 08             	mov    0x8(%eax),%eax
  80329f:	39 c2                	cmp    %eax,%edx
  8032a1:	0f 85 7c 01 00 00    	jne    803423 <insert_sorted_with_merge_freeList+0x6a0>
				{
					LIST_INSERT_BEFORE(&FreeMemBlocksList, nextBlock, blockToInsert);
  8032a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ab:	74 06                	je     8032b3 <insert_sorted_with_merge_freeList+0x530>
  8032ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b1:	75 17                	jne    8032ca <insert_sorted_with_merge_freeList+0x547>
  8032b3:	83 ec 04             	sub    $0x4,%esp
  8032b6:	68 b4 3f 80 00       	push   $0x803fb4
  8032bb:	68 69 01 00 00       	push   $0x169
  8032c0:	68 9b 3f 80 00       	push   $0x803f9b
  8032c5:	e8 a0 d0 ff ff       	call   80036a <_panic>
  8032ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032cd:	8b 50 04             	mov    0x4(%eax),%edx
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	89 50 04             	mov    %edx,0x4(%eax)
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032dc:	89 10                	mov    %edx,(%eax)
  8032de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e1:	8b 40 04             	mov    0x4(%eax),%eax
  8032e4:	85 c0                	test   %eax,%eax
  8032e6:	74 0d                	je     8032f5 <insert_sorted_with_merge_freeList+0x572>
  8032e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032eb:	8b 40 04             	mov    0x4(%eax),%eax
  8032ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f1:	89 10                	mov    %edx,(%eax)
  8032f3:	eb 08                	jmp    8032fd <insert_sorted_with_merge_freeList+0x57a>
  8032f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8032fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803300:	8b 55 08             	mov    0x8(%ebp),%edx
  803303:	89 50 04             	mov    %edx,0x4(%eax)
  803306:	a1 44 51 80 00       	mov    0x805144,%eax
  80330b:	40                   	inc    %eax
  80330c:	a3 44 51 80 00       	mov    %eax,0x805144
					blockToInsert->size += nextBlock->size;
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 50 0c             	mov    0xc(%eax),%edx
  803317:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80331a:	8b 40 0c             	mov    0xc(%eax),%eax
  80331d:	01 c2                	add    %eax,%edx
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_REMOVE(&FreeMemBlocksList, nextBlock);
  803325:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803329:	75 17                	jne    803342 <insert_sorted_with_merge_freeList+0x5bf>
  80332b:	83 ec 04             	sub    $0x4,%esp
  80332e:	68 44 40 80 00       	push   $0x804044
  803333:	68 6b 01 00 00       	push   $0x16b
  803338:	68 9b 3f 80 00       	push   $0x803f9b
  80333d:	e8 28 d0 ff ff       	call   80036a <_panic>
  803342:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803345:	8b 00                	mov    (%eax),%eax
  803347:	85 c0                	test   %eax,%eax
  803349:	74 10                	je     80335b <insert_sorted_with_merge_freeList+0x5d8>
  80334b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334e:	8b 00                	mov    (%eax),%eax
  803350:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803353:	8b 52 04             	mov    0x4(%edx),%edx
  803356:	89 50 04             	mov    %edx,0x4(%eax)
  803359:	eb 0b                	jmp    803366 <insert_sorted_with_merge_freeList+0x5e3>
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	8b 40 04             	mov    0x4(%eax),%eax
  80336c:	85 c0                	test   %eax,%eax
  80336e:	74 0f                	je     80337f <insert_sorted_with_merge_freeList+0x5fc>
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	8b 40 04             	mov    0x4(%eax),%eax
  803376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803379:	8b 12                	mov    (%edx),%edx
  80337b:	89 10                	mov    %edx,(%eax)
  80337d:	eb 0a                	jmp    803389 <insert_sorted_with_merge_freeList+0x606>
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	a3 38 51 80 00       	mov    %eax,0x805138
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803392:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803395:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80339c:	a1 44 51 80 00       	mov    0x805144,%eax
  8033a1:	48                   	dec    %eax
  8033a2:	a3 44 51 80 00       	mov    %eax,0x805144
					nextBlock->sva = 0;
  8033a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
					nextBlock->size = 0;
  8033b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, nextBlock);
  8033bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033bf:	75 17                	jne    8033d8 <insert_sorted_with_merge_freeList+0x655>
  8033c1:	83 ec 04             	sub    $0x4,%esp
  8033c4:	68 78 3f 80 00       	push   $0x803f78
  8033c9:	68 6e 01 00 00       	push   $0x16e
  8033ce:	68 9b 3f 80 00       	push   $0x803f9b
  8033d3:	e8 92 cf ff ff       	call   80036a <_panic>
  8033d8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e1:	89 10                	mov    %edx,(%eax)
  8033e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e6:	8b 00                	mov    (%eax),%eax
  8033e8:	85 c0                	test   %eax,%eax
  8033ea:	74 0d                	je     8033f9 <insert_sorted_with_merge_freeList+0x676>
  8033ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8033f4:	89 50 04             	mov    %edx,0x4(%eax)
  8033f7:	eb 08                	jmp    803401 <insert_sorted_with_merge_freeList+0x67e>
  8033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803401:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803404:	a3 48 51 80 00       	mov    %eax,0x805148
  803409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803413:	a1 54 51 80 00       	mov    0x805154,%eax
  803418:	40                   	inc    %eax
  803419:	a3 54 51 80 00       	mov    %eax,0x805154
					break;
  80341e:	e9 a9 00 00 00       	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
				}
				else
				{
					LIST_INSERT_AFTER(&FreeMemBlocksList, currentBlock, blockToInsert);
  803423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803427:	74 06                	je     80342f <insert_sorted_with_merge_freeList+0x6ac>
  803429:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342d:	75 17                	jne    803446 <insert_sorted_with_merge_freeList+0x6c3>
  80342f:	83 ec 04             	sub    $0x4,%esp
  803432:	68 10 40 80 00       	push   $0x804010
  803437:	68 73 01 00 00       	push   $0x173
  80343c:	68 9b 3f 80 00       	push   $0x803f9b
  803441:	e8 24 cf ff ff       	call   80036a <_panic>
  803446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803449:	8b 10                	mov    (%eax),%edx
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	89 10                	mov    %edx,(%eax)
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	8b 00                	mov    (%eax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	74 0b                	je     803464 <insert_sorted_with_merge_freeList+0x6e1>
  803459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345c:	8b 00                	mov    (%eax),%eax
  80345e:	8b 55 08             	mov    0x8(%ebp),%edx
  803461:	89 50 04             	mov    %edx,0x4(%eax)
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 55 08             	mov    0x8(%ebp),%edx
  80346a:	89 10                	mov    %edx,(%eax)
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803472:	89 50 04             	mov    %edx,0x4(%eax)
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	85 c0                	test   %eax,%eax
  80347c:	75 08                	jne    803486 <insert_sorted_with_merge_freeList+0x703>
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803486:	a1 44 51 80 00       	mov    0x805144,%eax
  80348b:	40                   	inc    %eax
  80348c:	a3 44 51 80 00       	mov    %eax,0x805144
					break;
  803491:	eb 39                	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
	}
	else
	{
		struct MemBlock *currentBlock;
		struct MemBlock *nextBlock;
		LIST_FOREACH(currentBlock, &FreeMemBlocksList)
  803493:	a1 40 51 80 00       	mov    0x805140,%eax
  803498:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80349b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349f:	74 07                	je     8034a8 <insert_sorted_with_merge_freeList+0x725>
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 00                	mov    (%eax),%eax
  8034a6:	eb 05                	jmp    8034ad <insert_sorted_with_merge_freeList+0x72a>
  8034a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8034ad:	a3 40 51 80 00       	mov    %eax,0x805140
  8034b2:	a1 40 51 80 00       	mov    0x805140,%eax
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	0f 85 c7 fb ff ff    	jne    803086 <insert_sorted_with_merge_freeList+0x303>
  8034bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c3:	0f 85 bd fb ff ff    	jne    803086 <insert_sorted_with_merge_freeList+0x303>
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034c9:	eb 01                	jmp    8034cc <insert_sorted_with_merge_freeList+0x749>
	struct MemBlock *tail = LIST_LAST(&FreeMemBlocksList) ;

	if (LIST_EMPTY(&FreeMemBlocksList) || blockToInsert->sva <= head->sva)
	{
		LIST_INSERT_HEAD(&FreeMemBlocksList, blockToInsert);
		if(head != NULL && blockToInsert->sva + blockToInsert->size == head->sva)
  8034cb:	90                   	nop
			}
		}
	}
	//cprintf("\nAFTER INSERT with MERGE:\n=====================\n");
	//print_mem_block_lists();
}
  8034cc:	90                   	nop
  8034cd:	c9                   	leave  
  8034ce:	c3                   	ret    
  8034cf:	90                   	nop

008034d0 <__udivdi3>:
  8034d0:	55                   	push   %ebp
  8034d1:	57                   	push   %edi
  8034d2:	56                   	push   %esi
  8034d3:	53                   	push   %ebx
  8034d4:	83 ec 1c             	sub    $0x1c,%esp
  8034d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034e7:	89 ca                	mov    %ecx,%edx
  8034e9:	89 f8                	mov    %edi,%eax
  8034eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034ef:	85 f6                	test   %esi,%esi
  8034f1:	75 2d                	jne    803520 <__udivdi3+0x50>
  8034f3:	39 cf                	cmp    %ecx,%edi
  8034f5:	77 65                	ja     80355c <__udivdi3+0x8c>
  8034f7:	89 fd                	mov    %edi,%ebp
  8034f9:	85 ff                	test   %edi,%edi
  8034fb:	75 0b                	jne    803508 <__udivdi3+0x38>
  8034fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803502:	31 d2                	xor    %edx,%edx
  803504:	f7 f7                	div    %edi
  803506:	89 c5                	mov    %eax,%ebp
  803508:	31 d2                	xor    %edx,%edx
  80350a:	89 c8                	mov    %ecx,%eax
  80350c:	f7 f5                	div    %ebp
  80350e:	89 c1                	mov    %eax,%ecx
  803510:	89 d8                	mov    %ebx,%eax
  803512:	f7 f5                	div    %ebp
  803514:	89 cf                	mov    %ecx,%edi
  803516:	89 fa                	mov    %edi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	39 ce                	cmp    %ecx,%esi
  803522:	77 28                	ja     80354c <__udivdi3+0x7c>
  803524:	0f bd fe             	bsr    %esi,%edi
  803527:	83 f7 1f             	xor    $0x1f,%edi
  80352a:	75 40                	jne    80356c <__udivdi3+0x9c>
  80352c:	39 ce                	cmp    %ecx,%esi
  80352e:	72 0a                	jb     80353a <__udivdi3+0x6a>
  803530:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803534:	0f 87 9e 00 00 00    	ja     8035d8 <__udivdi3+0x108>
  80353a:	b8 01 00 00 00       	mov    $0x1,%eax
  80353f:	89 fa                	mov    %edi,%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	31 ff                	xor    %edi,%edi
  80354e:	31 c0                	xor    %eax,%eax
  803550:	89 fa                	mov    %edi,%edx
  803552:	83 c4 1c             	add    $0x1c,%esp
  803555:	5b                   	pop    %ebx
  803556:	5e                   	pop    %esi
  803557:	5f                   	pop    %edi
  803558:	5d                   	pop    %ebp
  803559:	c3                   	ret    
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	89 d8                	mov    %ebx,%eax
  80355e:	f7 f7                	div    %edi
  803560:	31 ff                	xor    %edi,%edi
  803562:	89 fa                	mov    %edi,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803571:	89 eb                	mov    %ebp,%ebx
  803573:	29 fb                	sub    %edi,%ebx
  803575:	89 f9                	mov    %edi,%ecx
  803577:	d3 e6                	shl    %cl,%esi
  803579:	89 c5                	mov    %eax,%ebp
  80357b:	88 d9                	mov    %bl,%cl
  80357d:	d3 ed                	shr    %cl,%ebp
  80357f:	89 e9                	mov    %ebp,%ecx
  803581:	09 f1                	or     %esi,%ecx
  803583:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803587:	89 f9                	mov    %edi,%ecx
  803589:	d3 e0                	shl    %cl,%eax
  80358b:	89 c5                	mov    %eax,%ebp
  80358d:	89 d6                	mov    %edx,%esi
  80358f:	88 d9                	mov    %bl,%cl
  803591:	d3 ee                	shr    %cl,%esi
  803593:	89 f9                	mov    %edi,%ecx
  803595:	d3 e2                	shl    %cl,%edx
  803597:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359b:	88 d9                	mov    %bl,%cl
  80359d:	d3 e8                	shr    %cl,%eax
  80359f:	09 c2                	or     %eax,%edx
  8035a1:	89 d0                	mov    %edx,%eax
  8035a3:	89 f2                	mov    %esi,%edx
  8035a5:	f7 74 24 0c          	divl   0xc(%esp)
  8035a9:	89 d6                	mov    %edx,%esi
  8035ab:	89 c3                	mov    %eax,%ebx
  8035ad:	f7 e5                	mul    %ebp
  8035af:	39 d6                	cmp    %edx,%esi
  8035b1:	72 19                	jb     8035cc <__udivdi3+0xfc>
  8035b3:	74 0b                	je     8035c0 <__udivdi3+0xf0>
  8035b5:	89 d8                	mov    %ebx,%eax
  8035b7:	31 ff                	xor    %edi,%edi
  8035b9:	e9 58 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035be:	66 90                	xchg   %ax,%ax
  8035c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035c4:	89 f9                	mov    %edi,%ecx
  8035c6:	d3 e2                	shl    %cl,%edx
  8035c8:	39 c2                	cmp    %eax,%edx
  8035ca:	73 e9                	jae    8035b5 <__udivdi3+0xe5>
  8035cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035cf:	31 ff                	xor    %edi,%edi
  8035d1:	e9 40 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035d6:	66 90                	xchg   %ax,%ax
  8035d8:	31 c0                	xor    %eax,%eax
  8035da:	e9 37 ff ff ff       	jmp    803516 <__udivdi3+0x46>
  8035df:	90                   	nop

008035e0 <__umoddi3>:
  8035e0:	55                   	push   %ebp
  8035e1:	57                   	push   %edi
  8035e2:	56                   	push   %esi
  8035e3:	53                   	push   %ebx
  8035e4:	83 ec 1c             	sub    $0x1c,%esp
  8035e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035ff:	89 f3                	mov    %esi,%ebx
  803601:	89 fa                	mov    %edi,%edx
  803603:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803607:	89 34 24             	mov    %esi,(%esp)
  80360a:	85 c0                	test   %eax,%eax
  80360c:	75 1a                	jne    803628 <__umoddi3+0x48>
  80360e:	39 f7                	cmp    %esi,%edi
  803610:	0f 86 a2 00 00 00    	jbe    8036b8 <__umoddi3+0xd8>
  803616:	89 c8                	mov    %ecx,%eax
  803618:	89 f2                	mov    %esi,%edx
  80361a:	f7 f7                	div    %edi
  80361c:	89 d0                	mov    %edx,%eax
  80361e:	31 d2                	xor    %edx,%edx
  803620:	83 c4 1c             	add    $0x1c,%esp
  803623:	5b                   	pop    %ebx
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	39 f0                	cmp    %esi,%eax
  80362a:	0f 87 ac 00 00 00    	ja     8036dc <__umoddi3+0xfc>
  803630:	0f bd e8             	bsr    %eax,%ebp
  803633:	83 f5 1f             	xor    $0x1f,%ebp
  803636:	0f 84 ac 00 00 00    	je     8036e8 <__umoddi3+0x108>
  80363c:	bf 20 00 00 00       	mov    $0x20,%edi
  803641:	29 ef                	sub    %ebp,%edi
  803643:	89 fe                	mov    %edi,%esi
  803645:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803649:	89 e9                	mov    %ebp,%ecx
  80364b:	d3 e0                	shl    %cl,%eax
  80364d:	89 d7                	mov    %edx,%edi
  80364f:	89 f1                	mov    %esi,%ecx
  803651:	d3 ef                	shr    %cl,%edi
  803653:	09 c7                	or     %eax,%edi
  803655:	89 e9                	mov    %ebp,%ecx
  803657:	d3 e2                	shl    %cl,%edx
  803659:	89 14 24             	mov    %edx,(%esp)
  80365c:	89 d8                	mov    %ebx,%eax
  80365e:	d3 e0                	shl    %cl,%eax
  803660:	89 c2                	mov    %eax,%edx
  803662:	8b 44 24 08          	mov    0x8(%esp),%eax
  803666:	d3 e0                	shl    %cl,%eax
  803668:	89 44 24 04          	mov    %eax,0x4(%esp)
  80366c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803670:	89 f1                	mov    %esi,%ecx
  803672:	d3 e8                	shr    %cl,%eax
  803674:	09 d0                	or     %edx,%eax
  803676:	d3 eb                	shr    %cl,%ebx
  803678:	89 da                	mov    %ebx,%edx
  80367a:	f7 f7                	div    %edi
  80367c:	89 d3                	mov    %edx,%ebx
  80367e:	f7 24 24             	mull   (%esp)
  803681:	89 c6                	mov    %eax,%esi
  803683:	89 d1                	mov    %edx,%ecx
  803685:	39 d3                	cmp    %edx,%ebx
  803687:	0f 82 87 00 00 00    	jb     803714 <__umoddi3+0x134>
  80368d:	0f 84 91 00 00 00    	je     803724 <__umoddi3+0x144>
  803693:	8b 54 24 04          	mov    0x4(%esp),%edx
  803697:	29 f2                	sub    %esi,%edx
  803699:	19 cb                	sbb    %ecx,%ebx
  80369b:	89 d8                	mov    %ebx,%eax
  80369d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036a1:	d3 e0                	shl    %cl,%eax
  8036a3:	89 e9                	mov    %ebp,%ecx
  8036a5:	d3 ea                	shr    %cl,%edx
  8036a7:	09 d0                	or     %edx,%eax
  8036a9:	89 e9                	mov    %ebp,%ecx
  8036ab:	d3 eb                	shr    %cl,%ebx
  8036ad:	89 da                	mov    %ebx,%edx
  8036af:	83 c4 1c             	add    $0x1c,%esp
  8036b2:	5b                   	pop    %ebx
  8036b3:	5e                   	pop    %esi
  8036b4:	5f                   	pop    %edi
  8036b5:	5d                   	pop    %ebp
  8036b6:	c3                   	ret    
  8036b7:	90                   	nop
  8036b8:	89 fd                	mov    %edi,%ebp
  8036ba:	85 ff                	test   %edi,%edi
  8036bc:	75 0b                	jne    8036c9 <__umoddi3+0xe9>
  8036be:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c3:	31 d2                	xor    %edx,%edx
  8036c5:	f7 f7                	div    %edi
  8036c7:	89 c5                	mov    %eax,%ebp
  8036c9:	89 f0                	mov    %esi,%eax
  8036cb:	31 d2                	xor    %edx,%edx
  8036cd:	f7 f5                	div    %ebp
  8036cf:	89 c8                	mov    %ecx,%eax
  8036d1:	f7 f5                	div    %ebp
  8036d3:	89 d0                	mov    %edx,%eax
  8036d5:	e9 44 ff ff ff       	jmp    80361e <__umoddi3+0x3e>
  8036da:	66 90                	xchg   %ax,%ax
  8036dc:	89 c8                	mov    %ecx,%eax
  8036de:	89 f2                	mov    %esi,%edx
  8036e0:	83 c4 1c             	add    $0x1c,%esp
  8036e3:	5b                   	pop    %ebx
  8036e4:	5e                   	pop    %esi
  8036e5:	5f                   	pop    %edi
  8036e6:	5d                   	pop    %ebp
  8036e7:	c3                   	ret    
  8036e8:	3b 04 24             	cmp    (%esp),%eax
  8036eb:	72 06                	jb     8036f3 <__umoddi3+0x113>
  8036ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036f1:	77 0f                	ja     803702 <__umoddi3+0x122>
  8036f3:	89 f2                	mov    %esi,%edx
  8036f5:	29 f9                	sub    %edi,%ecx
  8036f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036fb:	89 14 24             	mov    %edx,(%esp)
  8036fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803702:	8b 44 24 04          	mov    0x4(%esp),%eax
  803706:	8b 14 24             	mov    (%esp),%edx
  803709:	83 c4 1c             	add    $0x1c,%esp
  80370c:	5b                   	pop    %ebx
  80370d:	5e                   	pop    %esi
  80370e:	5f                   	pop    %edi
  80370f:	5d                   	pop    %ebp
  803710:	c3                   	ret    
  803711:	8d 76 00             	lea    0x0(%esi),%esi
  803714:	2b 04 24             	sub    (%esp),%eax
  803717:	19 fa                	sbb    %edi,%edx
  803719:	89 d1                	mov    %edx,%ecx
  80371b:	89 c6                	mov    %eax,%esi
  80371d:	e9 71 ff ff ff       	jmp    803693 <__umoddi3+0xb3>
  803722:	66 90                	xchg   %ax,%ax
  803724:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803728:	72 ea                	jb     803714 <__umoddi3+0x134>
  80372a:	89 d9                	mov    %ebx,%ecx
  80372c:	e9 62 ff ff ff       	jmp    803693 <__umoddi3+0xb3>
